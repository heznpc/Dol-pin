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
