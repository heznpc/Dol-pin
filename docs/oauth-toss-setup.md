# Google·Apple OAuth / 토스페이먼츠

새 RN·웹 앱은 Supabase Auth의 Google·Apple OAuth(PKCE)를 사용한다. 전화번호 OTP도 유지한다. 결제는 PortOne을 경유하지 않는 토스페이먼츠 v2 결제창 + 승인 API다.

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
# 대상 프로젝트를 확인한 후 해당 환경에 migration 027까지 적용
supabase db push
supabase secrets set --env-file supabase/functions/.env
supabase functions deploy toss-payment
```

새 공개 웹 사이트의 최초 배포는 별도 작업이다. `DOLPIN_WEB_URL`은 실행 중인 이 Next.js 앱의 origin이어야 한다. 실기기는 접근 가능한 HTTPS 주소를 사용한다. 로컬 DB에는 migration 027을 적용해 검증했으며 원격 반영은 하지 않았다.

## 동작

예약 상세의 대여자에게 수락된 예약의 결제 버튼을 표시한다. 서버가 DB에서 금액·대여자·기한을 확인하고 해당 예약에만 쓸 수 있는 무작위 결제 링크를 발급한다. DB에는 링크 토큰의 SHA-256 해시만 보관한다. 로그인 access/refresh token은 브라우저에 전달하지 않는다.

웹 결제 페이지는 URL fragment의 예약 전용 토큰을 sessionStorage에 옮기고 주소에서 지운다. 토스 인증 복귀 후 자동으로 서버 승인을 요청한다. 서버는 DB 금액과 토스의 orderId·paymentKey·통화·완료 상태를 확인한다. 동일 주문을 먼저 조회하고 같은 멱등키로 승인하여, 네트워크 장애 뒤 재시도에서 이미 승인된 결제를 재사용한다. DB의 paid 전환과 이벤트 기록은 한 번만 발생한다.

승인 결과가 불확실한 예약은 재고를 풀지 않는다. 같은 결과 화면에서 재확인한다. 결과 화면을 잃었거나 장기 미확정 건은 토스 주문 조회와 DB를 대조하는 운영 복구가 필요하다. 자동 webhook/주기적 reconciliation은 이번 범위에 포함하지 않았다.

기존 Flutter의 PortOne 결제·환불·정산 함수는 유지한다. 새 토스 결제를 기존 PortOne 환불/정산 함수로 처리하면 안 된다. **토스 환불·보증금 반환·정산 자동화는 아직 연결되지 않았다.**

## 검증

- RN/공통 및 웹 TypeScript 검사 통과.
- Next.js production build 및 Expo iOS export 통과. iOS 기기에서 OAuth·결제 복귀는 미검증.
- 실제 웹(127.0.0.1:3100, 1280×720): 로그인 버튼 표시, Google 버튼 → PKCE authorize 요청 이동 확인. provider 미설정 400은 예상 결과이며 실제 로그인 성공 증거는 아니다. OAuth 취소 callback 오류 표시와 재로그인 링크 확인. 최종 production 화면은 framework overlay·앱 콘솔 오류 없음. Browser plugin 미제공으로 Playwright CLI 사용.
- 실제 로컬 PostgreSQL: 대여자 권한, 서버 금액, 미확정 결제의 만료 방어, paid 전환 멱등성, 중복 paymentKey 거절, RPC/table 권한 통과.
- Deno provider 모사: 금액 변조 거절, 서버 금액·멱등키 전달, 기존 승인 재조회, 다른 paymentKey 거절 통과. 실제 토스 호출 증거는 아니다.
- 실제 Google·Apple 인증 및 토스 테스트 결제: 키 미설정으로 미검증.

공식 연동 기준: [Supabase PKCE](https://supabase.com/docs/guides/auth/sessions/pkce-flow), [모바일 deep link](https://supabase.com/docs/guides/auth/native-mobile-deep-linking), [토스 승인 API](https://docs.tosspayments.com/reference), [결제 흐름](https://docs.tosspayments.com/guides/v2/get-started/payment-flow).
