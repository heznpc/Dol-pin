# Rewrite verification

## 2026-09-09 — 착수

- 사용자 승인 조건 네 가지를 `rewrite-plan.md`에 명시.
- 기존 working tree clean 확인; remote visibility/운영 배포는 미확인.
- 코드 감사에서 RPC/행 잠금/기간 제약/환불 재조회 존재 확인.
- 기존 테스트 통과나 과거 문서의 구동 주장은 이번 검증으로 승계하지 않음.
- Docker default/orbstack socket이 없어 local Supabase 실행 불가.
- `~/.colima`가 `/Volumes/DevStore/VMs/Colima`를 가리키지만 DevStore가 현재
  mount되어 있지 않음. 기존 VM 디렉터리·symlink는 변경하지 않음.
- RN/Web 앱, migration reset, 실제 RLS, PG, E2E: 아직 미검증.

검증 실패를 지나쳐 다음 domain의 Web 구현으로 진행하지 않는다.

## 외장 SSD runtime 복구

- 사용자 지시: 내부 공간 부족, 외장 SSD에 새 runtime 설치.
- 외장 APFS SSD의 여유 약 309 GiB, 내부 약 7.3 GiB 확인.
- Colima 0.10.3 전용 `dol-pin` profile, CPU 4 / RAM 4 GiB / data disk 40 GiB.
- VM·다운로드 cache·임시 파일을 외장 volume으로 지정.
- 끊어진 기존 Colima symlink는 별도 backup으로 보존하고 외장 경로에 연결.
- VZ VM 실행 및 Docker 29.5.2 응답 확인. 전역 Docker context는 바꾸지 않음.
- `scripts/with-runtime.sh`로 명시적 runtime 경로와 Docker socket 사용.
- Supabase 이미지는 이 외장 VM으로 다운로드 중. migration reset은 아직 미검증.

## 실제 DB baseline 결과

- Supabase CLI 전용 실행본 2.107.0 사용. macOS code signature 문제와 복구는
  `local-runtime.md`에 기록.
- 최초 core read 테스트는 `permission denied for table reservations`로 실패.
  기존 migrations가 테이블 GRANT를 암묵적 환경 기본값에 의존함을 확인.
- `019_explicit_core_read_privileges.sql`로 명시적 read privilege를 추가하고
  직접 reservation 쓰기를 revoke. RLS policy는 유지.
- `supabase db reset --local --yes` exit 0: migrations 001–019 fresh 적용 확인.
- `supabase/tests/legacy-authority.sql`를 실제 DB에서 실행, exit 0.
  서버 가격 20,000 + 보증금 30,000 = 50,000 KRW, 기간 중복 거부,
  직접 상태 변경 거부, 무관 사용자 read/transition 거부,
  미결제 인수 거부, 결제 fixture 이후 대여자 인수 성공 확인.
- 위 테스트의 결제 상태는 신뢰된 DB fixture다. 실제 PG 검증 증거가 아니다.
- Vector의 Docker log connection 오류로 전체 start가 실패. `-x vector,analytics`
  실행으로 core runtime을 시작했다. 실제 최종 running container 목록에서는
  analytics가 남아 있으므로 analytics 제외까지 성공했다고 주장하지 않음.
- VM 메모리는 macOS swap 압박을 줄이기 위해 3 GiB로 조정한다.

## RN foundation — 실제 실행 검증

- Expo SDK 57 / React Native 0.86.3 / React 19.2.3 기반 workspace 추가.
- TypeScript strict 검사 통과. 공유 package는 DTO/schema/API contract만 담당.
- 실제 iOS 26.3 Simulator에서 Expo Go 57.0.9로 탐색 화면 렌더링 확인.
- 앱 UI에서 로컬 전용 테스트 전화번호와 고정 OTP로 로그인 후 Supabase의
  `차용자 테스트` profile 조회 확인. 증거: `verification/rn-local-account.png`.
  화면에 보이는 번호는 `config.toml`에 등록한 가상 fixture다.
- `020_verified_profile_command.sql` 적용. Auth의 인증된 phone으로만 profile 생성.
  `scripts/check-local-auth.mjs` 실행으로 OTP → profile command → RLS 조회 및
  직접 identity INSERT 거부 확인.
- 외장 workspace symlink를 Metro watchFolders/extraNodeModules에 명시해
  native bundle resolution 오류 해결. localhost의 IPv6 bind와 manifest의
  IPv4 주소 불일치도 확인해 실행 지침에 반영.
- 상품 등록/예약/결제/반납의 새 RN 흐름, consumer web, PG 실호출은 아직 미검증.
- 내부 여유가 804 MiB까지 감소해 이 검증에 사용한 Simulator와 Metro를 종료.
  dependencies, Expo 다운로드, VM 데이터는 외장 SSD에 저장했다.
