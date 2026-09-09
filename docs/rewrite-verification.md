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

## RN 상품 작성 slice

- `021_product_authoring.sql`: 상품 사진 전용 public bucket, 소유자 경로 업로드,
  상품 쓰기 column privileges, 가격·품목·사진 개수 제약 추가.
  기존 상품 전체 validation은 별도 감사 전까지 NOT VALID로 보존했다.
- 실제 Storage upload에서 기존 chat policy의 `chat_rooms` SELECT 권한 누락을
  발견해 `022_storage_policy_read_privilege.sql`로 수정. 참여자 RLS는 유지했다.
- `scripts/check-local-products.mjs` 실제 Auth/Storage/PostgREST 검증 통과:
  업로드, 등록, 비로그인 공개 조회, 소유자 수정 성공. 타인 경로 업로드·타인 수정·
  인증 플래그 변경·음수 가격 등록 거부. 스크립트는 가상 상품을 로컬 DB에 남긴다.
- 실제 iOS Simulator에서 사진 선택 → 업로드 → RHF/Zod form → 등록 → 상세 화면
  재조회 성공. `verification/rn-created-product.png`는 해당 실행 증거다.
- 재시작 후 인증 세션 유지도 확인했다. CUA 한글 자동 타이핑 누락으로 등록
  fixture는 영문을 사용했다. 실제 한국어 키보드 입력 UX는 미검증이다.
- TypeScript strict 및 기존 DB 거래 invariant 재검증 통과.
- 날짜별 availability, 콘서트 연결 form, 사진 제거/고아 업로드 회수는 후속 작업.
  새 물품 작성의 기본 경로가 검증됐으며 제품 전체 완료를 의미하지 않는다.

## Next.js 상품 slice

- RN 기본 상품 흐름 검증 이후 동일 `api-client`로 Next.js consumer 구현.
- production build와 strict typecheck 통과. 실제 in-app browser에서:
  RN 생성 상품 검색/상세 조회, 카테고리 빈 결과, 뒤로 이동 시 필터 유지,
  OTP 로그인, Storage 사진 업로드, 한글 상품 등록 후 상세 재조회 성공.
- 실제 브라우저의 production console error/warning 없음 확인.
- desktop/390px 화면 비교 후 작은 화면 필터를 2열로, 메뉴 간격을 축소.
  `verification/web-products.png`에 실제 등록 데이터 화면 보관.
- `design/web-reference.png`와 렌더링을 view_image로 직접 비교.
  팔레트, 정보 위계, 좌측 필터, 사진 배치, 가격/보증금 표기 확인.
- 생성 참고 이미지의 8개 가상 상품을 복제하지 않았다. 실제 fixture 3개만 표시.
  내 거래 navigation은 해당 거래 slice가 동작한 뒤 추가한다. 스크린샷은 기능
  검증 증거이며 최종 제품/전체 디자인 완료를 의미하지 않는다.
- CI에 local API Auth/Storage 검증, RN bundle, Next build를 추가. 원격 CI 실행은
  아직 확인하지 않았다.
- 개발 서버의 IAB bundle 초기화 오류는 재현됐으나 production에서는 같은 기능
  검증이 통과했다. 개발 모드 문제는 별도로 추적한다.
- Expo iOS production export 성공: Hermes bundle 약 4MB, 외장 output에 생성.
- 실제 선택된 브라우저 탭에서 viewport 390px / document scrollWidth 375px 확인.
  가로 넘침 없음. `verification/web-mobile.png`에 화면 보관.

## 예약 slice — 2026-09-09

- migration 023–025를 로컬에 적용했다. 신규 requested는 기간을 점유하지 않고 accepted부터 timestamp exclusion으로 점유한다.
- `scripts/check-local-rentals.mjs`: 실제 Auth/PostgREST 경로에서 당일 요금, 동일 요청 재시도, 동시 accept 단 하나 성공/다른 하나 23P01, 역할 위반, 직접 상태 변경 차단, snapshot 불변, 이벤트 중복 방지를 확인했다.
- `supabase/tests/rental-expiry.sql`: 결과 불명 payment attempt는 유지하고, 결제가 없다고 확인된 fixture만 만료시키며 이벤트를 한 번 기록했다. pg_cron 실제 실행도 `succeeded`로 확인했다.
- RN iPhone 17e에서 웹 등록 상품을 2026-09-21 10:00–20:00으로 요청했다. 5,000원 + 보증금 30,000원 견적을 확인하고, 대여자 계정으로 전환해 수락했다.
- 웹 production에서 RN 수락 거래의 동일 상태/시각/금액을 확인했다. 반대 방향으로 RN 등록 상품을 웹에서 예약 요청하고 취소했다. 해당 브라우저 console error/warn은 없었다.
- 증거: `verification/rn-rental-request.png`, `verification/rn-rental-accepted.png`, `verification/web-rn-rental.png`.
- 금융 연동 이후 상태, 실제 PG 결제, 환불·복구·운영 화면은 아직 미검증이다. 기존 legacy 생성 RPC 권한 회수 때문에 이 branch를 운영 backend에 먼저 배포하지 않는다.
- CI SDK mismatch를 `mise.toml`과 동일한 Flutter 3.44.8로 수정했다. commit 710ffde의 원격 build/database job 모두 성공했다. 예약 변경의 원격 결과는 별도 확인한다.
