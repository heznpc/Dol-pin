# Google·Apple OAuth / 토스페이먼츠

RN·웹 앱은 이메일 가입·로그인을 기본으로 제공하며 Google·Apple OAuth(PKCE)와 전화번호 OTP도 유지한다. 결제는 PortOne을 경유하지 않는 토스페이먼츠 v2 결제창 + 승인 API다.

## 입력할 환경 변수

- `apps/web/.env.example` → `apps/web/.env.local`: Supabase URL·anon key, `NEXT_PUBLIC_TOSS_CLIENT_KEY`.
- `apps/mobile/.env.example` → `apps/mobile/.env.local`: Supabase URL·anon key.
- `supabase/functions/.env.example` → `supabase/functions/.env`: `TOSS_SECRET_KEY`, `DOLPIN_WEB_URL`.
- 루트 `.env.example` → `.env`: `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `APPLE_CLIENT_ID`, `APPLE_CLIENT_SECRET`.

기존 `.env.local`을 덮어쓰지 않고 필요한 변수만 추가한다. 토스 키는 **API 개별 연동**의 `test_ck_`/`test_sk_` 쌍으로 먼저 검증한다. 결제위젯용 `test_gck_`/`test_gsk_` 키와 혼용하지 않는다. Apple secret은 .p8 원문이 아닌 서명된 client-secret JWT이며 만료 전에 교체한다.

OAuth 클라이언트 비밀키는 Supabase Auth에서 사용하고 앱 번들에 넣지 않는다. 로컬은 루트 `.env`를 작성한 다음 `node scripts/configure-oauth.mjs`를 실행하고 Supabase Auth를 재시작하면 된다. 이 스크립트는 값이 모두 채워진 provider만 활성화하고 비밀값은 출력하거나 config에 복사하지 않는다. CLI는 루트 `.env`의 값을 읽는다.

호스팅된 Supabase는 Dashboard → Authentication → Providers에 같은 Google·Apple 값들을 등록해야 한다. 앱의 env만 바꾸어서는 외부 OAuth 제공자 설정을 바꿀 수 없다.

## Redirect 등록

- Google/Apple 제공자 콘솔의 서버 callback: `https://<project-ref>.supabase.co/auth/v1/callback`.
- Supabase Auth Redirect URLs: `<웹 origin>/auth/callback`, `dolpin://auth/callback`.
- 로컬 웹 기본값: `http://127.0.0.1:3000/auth/callback`.
- 모바일은 `dolpin` scheme이 포함된 development/standalone build를 사용한다. Expo Go의 임의 scheme은 대상이 아니다.

## 서버 반영

```bash
# 대상 프로젝트와 docs/qa.md의 복구 배포 조건을 확인한 후 적용
supabase db push
supabase secrets set --env-file supabase/functions/.env
supabase functions deploy toss-payment
supabase functions deploy rental-payment
supabase functions deploy rental-recovery
```

새 공개 웹 사이트의 최초 배포는 별도 작업이다. `DOLPIN_WEB_URL`은 실행 중인 이 Next.js 앱의 origin이어야 한다. 실기기는 접근 가능한 HTTPS 주소를 사용한다. 원격 반영과 실제 PG 승인은 별도 검증이 필요하다.

## 동작

예약 상세의 대여자에게 수락된 예약의 결제 버튼을 표시한다. 서버가 DB에서 금액·대여자·기한을 확인하고 해당 예약에만 쓸 수 있는 무작위 결제 링크를 발급한다. DB에는 링크 토큰의 SHA-256 해시만 보관한다. 로그인 access/refresh token은 브라우저에 전달하지 않는다.

웹 결제 페이지는 URL fragment의 예약 전용 토큰을 sessionStorage에 옮기고 주소에서 지운다. 토스 인증 복귀 후 자동으로 서버 승인을 요청한다. 서버는 DB 금액과 토스의 orderId·paymentKey·통화·완료 상태를 확인한다. 동일 주문을 먼저 조회하고 같은 멱등키로 승인하여, 네트워크 장애 뒤 재시도에서 이미 승인된 결제를 재사용한다. DB의 paid 전환과 이벤트 기록은 한 번만 발생한다.

승인 결과가 불확실한 예약은 재고를 풀지 않는다. 같은 결과 화면에서 재확인하며, 장기 미확정 건은 rental-recovery의 결제사 조회와 DB 대조로 복구한다. 주기적 복구 배포 조건과 검증 범위는 [QA](qa.md)를 따른다.

서버의 PortOne 결제·환불·정산 호환 함수는 유지한다. 토스 환불·보증금 반환은 전용 rental-payment 경로로 처리하며 PortOne 함수와 혼용하지 않는다. 자동 대여료 지급은 제공하지 않는다. Flutter 클라이언트는 legacy/flutter에 보관한다.

## 검증

- RN/공통 및 웹 TypeScript 검사 통과.
- Next.js production build 및 Expo iOS export 통과. iOS 기기에서 OAuth·결제 복귀는 미검증.
- 실제 웹(127.0.0.1:3100, 1280×720): 로그인 버튼 표시, Google 버튼 → PKCE authorize 요청 이동 확인. provider 미설정 400은 예상 결과이며 실제 로그인 성공 증거는 아니다. OAuth 취소 callback 오류 표시와 재로그인 링크 확인. 최종 production 화면은 framework overlay·앱 콘솔 오류 없음. Browser plugin 미제공으로 Playwright CLI 사용.
- 실제 로컬 PostgreSQL: 대여자 권한, 서버 금액, 미확정 결제의 만료 방어, paid 전환 멱등성, 중복 paymentKey 거절, RPC/table 권한 통과.
- Deno provider 모사: 금액 변조 거절, 서버 금액·멱등키 전달, 기존 승인 재조회, 다른 paymentKey 거절 통과. 실제 토스 호출 증거는 아니다.
- 실제 Google·Apple 인증 및 토스 테스트 결제: 키 미설정으로 미검증.

공식 연동 기준: [Supabase PKCE](https://supabase.com/docs/guides/auth/sessions/pkce-flow), [모바일 deep link](https://supabase.com/docs/guides/auth/native-mobile-deep-linking), [토스 승인 API](https://docs.tosspayments.com/reference), [결제 흐름](https://docs.tosspayments.com/guides/v2/get-started/payment-flow).

## 카카오·네이버 추가

RN·웹 계정 화면에 카카오와 네이버를 추가했다. 카카오는 Supabase `kakao`, 네이버는 `custom:naver` OIDC를 사용한다. 네이버 discovery의 issuer·S256·RS256 지원을 직접 조회했다. 구형 `/oauth2.0` API 대신 discovery가 지정하는 `/oauth2` 경로를 사용하고 ID 토큰 검증은 Supabase에 맡긴다.

- 루트 `.env`: `KAKAO_CLIENT_ID`(REST API 키), `KAKAO_CLIENT_SECRET`, `NAVER_CLIENT_ID`, `NAVER_CLIENT_SECRET`.
- 카카오 로컬 활성화: `node scripts/configure-oauth.mjs` 후 Auth 재시작. 호스팅 환경은 Supabase의 Kakao provider에 같은 값을 입력한다. 이메일 미동의 로그인을 허용하려면 provider의 Allow users without an email 설정을 켠다.
- 네이버 등록: 루트 `.env`의 `SUPABASE_URL`·`SUPABASE_SERVICE_ROLE_KEY`가 대상 환경인지 확인한 뒤 `node scripts/configure-naver.mjs`. 같은 identifier가 있으면 갱신한다. 비밀값은 출력하지 않는다.
- 네이버 Developers에는 Supabase 커스텀 제공자 화면에서 표시되는 Callback URL을 그대로 등록한다. 커스텀 제공자는 기본 제공자와 callback 경로가 다를 수 있으므로 `/auth/v1/callback`을 임의로 쓰지 않는다.
- migration 028은 이메일·전화번호 미동의 계정도 **Auth가 저장한** 카카오/네이버 identity가 있을 때 프로필을 생성하게 한다. 사용자 수정 가능한 metadata를 근거로 허용하지 않고, 연락처·본인확인 상태도 만들어내지 않는다. 실제 PostgreSQL에서 정상 identity와 metadata 위조 거절을 검증했다.
- 실제 네이버·카카오 인증 성공/복귀는 키 미설정으로 미검증. 네이버 커스텀 provider 등록에는 해당 기능을 지원하는 Supabase Auth 버전이 필요하다.

현재 iOS 실행은 [전용 RN Release 앱](ios-runtime.md)을 사용한다. 과거 Expo Go 실행 기록은 현재의 크래시·OAuth 복귀 검증을 대체하지 않는다.

기준: [카카오 Supabase 연동](https://supabase.com/docs/guides/auth/social-login/auth-kakao), [커스텀 제공자](https://supabase.com/docs/guides/auth/custom-oauth-providers), [네이버 OIDC](https://developers.naver.com/docs/login/devguide/devguide.md).
