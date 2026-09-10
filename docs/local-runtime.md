# 외장 디스크 개발 runtime

내부 디스크 여유가 적은 개발 환경에서는 Colima VM, 컨테이너 이미지·volume,
npm cache와 임시 파일을 외장 디스크에 둔다. 저장소의 경로는 바꾸지 않는다.

```bash
export DOLPIN_RUNTIME_ROOT=/Volumes/SSD/dol-pin-runtime
mkdir -p "$DOLPIN_RUNTIME_ROOT"
bash scripts/with-runtime.sh start
bash scripts/with-runtime.sh docker info
bash scripts/with-runtime.sh supabase start -x vector,analytics
```

`SSD`는 실제 마운트 이름으로 바꾼다. 매번 같은 runtime root를 사용한다.
다른 shell의 Docker context를 전역 변경하지 않는다. `with-runtime.sh`는
명령에만 전용 Docker socket과 cache 경로를 적용한다.

## 데이터 위치

| 경로 | 내용 |
| --- | --- |
| `$DOLPIN_RUNTIME_ROOT/colima/_lima` | VM OS·Docker data disk |
| `$DOLPIN_RUNTIME_ROOT/colima/dol-pin` | profile 설정·socket |
| `$DOLPIN_RUNTIME_ROOT/cache/colima` | VM image 다운로드 |
| `$DOLPIN_RUNTIME_ROOT/cache/npm` | npm 다운로드 cache |
| `$DOLPIN_RUNTIME_ROOT/tmp` | 이 wrapper의 임시 파일 |
| `$DOLPIN_RUNTIME_ROOT/bin` | 필요한 경우 설치한 전용 CLI |

Docker의 `/var/lib/docker`와 `/var/lib/containerd`는 VM 내부 경로다.
물리 디스크가 외장에 있는지 확인하려면 다음을 함께 확인한다.

```bash
bash scripts/with-runtime.sh colima -p dol-pin ssh -- df -h / /var/lib/docker
du -sh "$DOLPIN_RUNTIME_ROOT"
```

macOS 자체의 swap과 시스템 로그까지 외장으로 이동하는 설정은 아니다.
`node_modules`, Expo/Next build output도 npm cache와는 별개다. 앞으로 설치할
대용량 dependency/build artifact는 외장 위치를 지정한 뒤 생성한다.

## 종료와 재개

```bash
bash scripts/with-runtime.sh supabase stop
bash scripts/with-runtime.sh colima stop dol-pin
```

VM을 종료한 뒤 외장 디스크를 분리한다. profile 삭제·volume prune을 종료 수단으로
사용하지 않는다. `supabase db reset`은 로컬 데이터를 지우므로 검증용 DB에서만
실행하며, 원격 프로젝트에 사용하지 않는다.

## 이 환경에서 확인한 CLI 문제

Supabase CLI 2.107.0의 macOS ARM64 실행 파일은 설치본과 npm 재다운로드본에서
모두 code signature 검증이 실패했다. npm 배포본의 `supabase`와 `supabase-go`
두 파일을 외장 runtime `bin`에 함께 복사하고 ad-hoc 서명 후 실행을 확인했다.
전역 Homebrew 설치본은 수정하지 않았다. 이는 해당 파일에 대한 로컬 복구 기록이며
모든 환경에 서명 수정을 권장하는 설치 절차는 아니다.

현재 전용 VM은 3 GiB RAM을 사용한다. Docker log collector인 Vector가 이 환경에서
연결 오류를 내므로 로컬 시작 명령에서 제외한다. 이 설정은 제품의 거래 event
history를 끄는 것이 아니다. 컨테이너 로그는 `docker logs`로 확인할 수 있다.

Colima의 기존 home symlink가 연결되지 않은 디스크를 가리키면 먼저 이를
확인한다. 기존 symlink/데이터를 삭제하지 않고 백업하고 새 runtime에 연결한다.

## RN 실행

일반 환경에서는 repository root에서 `npm ci`를 실행한다. 외장 workspace를
사용하는 이 환경에서는 외장 `workspace`에 root package.json을 복사하고,
`apps`와 `packages`를 저장소로 연결한 후 해당 위치에서 설치한다. 저장소의
`node_modules`는 외장 workspace의 node_modules로 연결한다. lockfile은 저장소에
보관한다. Metro 설정은 일반 설치와 외장 설치를 함께 지원한다.

```bash
bash scripts/with-runtime.sh node scripts/setup-local-env.mjs
export __UNSAFE_EXPO_HOME_DIRECTORY="$DOLPIN_RUNTIME_ROOT/expo"
export TMPDIR="$DOLPIN_RUNTIME_ROOT/tmp"
export REACT_NATIVE_PACKAGER_HOSTNAME=127.0.0.1
npm run start -w @dolpin/mobile -- --port 8081 --lan
```

이 주소는 같은 Mac의 iOS Simulator용이다. 실기기는 기기에서 접근 가능한 API와
Metro 주소가 필요하다. `--localhost`가 IPv6에만 bind하면서 manifest는 IPv4를
반환하는 환경에서는 bundle 로딩이 실패하므로 위 조합을 사용한다. 서버 수명 관리
하네스가 있는 환경은 이 명령을 해당 하네스로 실행하고 작업 종료 시 중지한다.

`supabase/config.toml`의 세 전화번호와 OTP는 로컬 개발 fixture다. SMS provider의
값은 의도적으로 유효하지 않은 placeholder이며 실제 발송 기능이 아니다.
hosted Auth 설정으로 옮기지 않는다. 로컬 Auth 검증:

```bash
node scripts/check-local-auth.mjs
npm run typecheck
```

이 검증은 가상 계정/profile을 로컬 DB에 남긴다. 실제 PG 결제를 호출하지 않는다.

## Next.js 실행

Next.js `distDir`는 프로젝트 밖의 절대 경로를 지원하지 않는다. 기본 `.next`를
사용하고 외장 output directory로 symlink한다. 외장 output의 상위 경로에도
workspace node_modules가 resolve되어야 서버가 React/Next runtime을 찾는다.
이 환경은 runtime root의 `node_modules`를 `workspace/node_modules`에 연결했다.
기존 디렉터리가 있다면 덮어쓰지 않고 위치와 내용을 먼저 확인한다.

```bash
mkdir -p "$DOLPIN_RUNTIME_ROOT/next-output"
ln -s "$DOLPIN_RUNTIME_ROOT/next-output" apps/web/.next
# runtime root에 node_modules가 없는 경우:
ln -s "$DOLPIN_RUNTIME_ROOT/workspace/node_modules" "$DOLPIN_RUNTIME_ROOT/node_modules"
NEXT_TELEMETRY_DISABLED=1 npm run build -w @dolpin/web
NEXT_TELEMETRY_DISABLED=1 npm run start -w @dolpin/web
```

마지막 서버 명령도 설치된 수명 관리 하네스로 실행한다. 검증은 production server로
수행했다. 내장 브라우저의 개발 모드 번들 초기화 오류는 미해결 항목이다.
lockfile에 외장 symlink를 따라 생긴 `../...` extraneous 항목은 배포 계약이 아니므로
제거하고 workspace의 상대 경로 항목만 보관한다.
