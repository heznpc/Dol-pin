# dol-pin — review

조사 일자: 2026-04-11 (세션 1 patch 완료 시점)
스택: Flutter 3.41.4 · Riverpod · Supabase (Auth/DB/Storage/Edge Functions) · Sentry · l10n (KO/EN/JA/ID) · PortOne (KR) · Gemini VLM
도메인: K-pop 콘서트 물품 C2C 대여 마켓플레이스

타임라인:
- **세션 0** — PR #13 (`63da32c`): PostgREST search injection / push-notification JWT / FCM Legacy → HTTP v1 전환 + analyze 부분 정리
- **세션 1** — 오늘 진행한 7 묶음 patch: 네이티브 release 권한, 부트스트랩, 네트워크·결제 타입, i18n, Supabase backend, CI/툴링, repo hygiene

이 파일은 이전 버전의 `review.md` 를 통째로 대체합니다. 원본 시장 분석 섹션이 필요하면 `git log -p review.md` 에서 확인.

---

## 1. 이번 세션에서 닫힌 항목

### P0 — 출시 블로커

- **Android release 빌드 네트워크 불가** — 기존 `main` manifest에는 `INTERNET` 조차 없고 `debug` overlay에만 있어서 release APK 는 Supabase/PortOne/Gemini 호출 전면 실패 상태였음. `INTERNET`, `POST_NOTIFICATIONS`, `CAMERA`, `READ_MEDIA_IMAGES`, `ACCESS_FINE_LOCATION`, `BLUETOOTH_SCAN/CONNECT` 등 12개 권한 + 커스텀 스킴 `dolpin://app` intent-filter 추가. `android:label` "dolda" → "dol-pin".
- **iOS `NS*UsageDescription` 전무** — Camera/Photo Library/Location/Bluetooth 4 종에 대한 사유 문자열 없이 해당 API 호출 시 crash + App Store 자동 reject. 6 개 `NSUsageDescription` 영어로 작성 + `CFBundleDisplayName`/`CFBundleName` "dol-pin" 통일 + `CFBundleURLTypes` 에 `dolpin://` 스킴. (사유 문자열 locale 분리는 P2)
- **PortOne `verify-payment` / `refund-payment` Edge Function 부재** — 클라이언트는 두 엔드포인트를 호출하지만 서버 함수가 존재하지 않아 결제 검증·환불 모두 404. 두 함수 신규 구현 (`supabase/functions/{verify,refund}-payment/index.ts`). `PORTONE_IMP_SECRET` 은 Deno env 에서만 읽고 caller JWT 검증 → `merchant_uid` 파싱으로 reservation 역추적 → amount tampering 체크 → `pending→confirmed` / `refunded`·`refund_partial` 상태 전이(멱등). PortOne 토큰은 module-scope 캐시 (`push-notification` 의 FCM 패턴 재사용).
- **HTTP 호출 무한 hang 가능** — 모든 outbound `http.post` 에 타임아웃 부재. 모바일 네트워크 이상 시 사용자 화면이 무한 대기. `gemini_service` 30 s, `payment_service` 20 s, `TimeoutException → NetworkFailure` 매핑 (`lib/core/errors/failures.dart`).
- **`GoRouter` 가 auth 상태 변화에 비반응** — 탑레벨 상수로 선언되어 redirect 가 사용자 네비게이션 시에만 재평가. 로그아웃/토큰 만료가 화면에 반영 안 됨. `_GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange)` + `refreshListenable` 연결.

### P1 — 런칭 전 권장

- **`PlatformDispatcher.instance.onError` 누락** — Flutter 3.3+ 에서 일부 async 에러는 zone 이 아닌 `PlatformDispatcher` 로 올라옴. 두 핸들러 모두 설정해야 Sentry coverage 완성. 추가.
- **루트 ErrorBoundary 없음** — widget build exception 이 release 에서 빨간 화면으로 노출될 수 있음. `ErrorWidget.builder` 전역 설정으로 release 빌드에서는 친절한 fallback widget 노출 + Sentry 리포트. 기존 `lib/core/utils/error_boundary.dart` 는 dead code (Flutter 는 per-subtree boundary 미지원) → 삭제.
- **`image_picker` 원본 이미지** — 12 MB+ HEIC 이 그대로 Gemini 로 base64 전송 → 6 MB edge body limit 초과 / OOM 위험. `pickMultiImage(maxWidth: 1600, maxHeight: 1600, imageQuality: 82)` + `gemini_service` 에 base64 전 4 MB 가드.
- **CI Flutter 버전 미고정** — `subosito/flutter-action@v2` 의 `channel: stable` 만 지정. `env.FLUTTER_VERSION: '3.41.4'` (로컬 mise 버전과 동기화) + 캐시 키에 버전 포함.
- **Dependabot 12 PR 방치** — 원본 review 에서 지적. `.github/dependabot.yml` 신규: `pub` + `github-actions` 두 ecosystem, `groups` 로 patch/minor/dev 묶음 weekly monday.
- **Storage bucket RLS 부재** — `storage_service.dart` 가 클라이언트가 넣은 `userId` 로 path 를 만들어 upload. 악성 클라이언트가 임의 userId 지정 가능. `supabase/migrations/016_storage_rls.sql` 로 `rental-photos` / `profile-photos` / `chat-images` 3 버킷 전체에 `(storage.foldername(name))[2] = auth.uid()::text` 경로 강제 + chat_rooms 참여자 검증.

### P2 / P3

- **`users` RLS `is_lender = TRUE` 하드 필터** — borrower-only 유저 프로필이 채팅 상대에게 NULL 로 보임. `014_users_rls_chat_partner.sql`: reservation 참여자이면 노출 (subquery).
- **`reviews` insert 에 reservation 종료 검증 없음** — 가짜 리뷰 가능. `015_reviews_guard.sql`: `status = 'returned'` + 참여자 + 자기리뷰 금지 `WITH CHECK`.
- **`PaymentResult.transactionId` 필드 1 개에 merchant_uid / imp_uid 혼선** — `merchantUid` (우리 측 order id, 항상 생성 시 set) + `impUid` (PortOne 측 transaction id, callback 이후 set) 분리. `PaymentGateway` 인터페이스 파라미터도 `paymentRef` 로 의미 명확화.
- **`analysis_options.yaml` 최소 구성** — `unawaited_futures` / `unnecessary_await_in_return` / `avoid_slow_async_io` / `prefer_final_locals` / `prefer_final_in_for_each` 추가 (CI break 방지 위해 모두 `info` level 로 demote).
- **Korean 하드코딩 메시지** — `Validators.*` 는 영어로 전환 (현 사용처는 테스트뿐인 dead-call 이므로 영어 fallback 으로 충분). `AuthRepository.signInWithOtp` 은 새 `OtpRateLimitFailure` 반환 → `LoginScreen` 에서 타입 체크하여 `l.otpRateLimit(seconds)` 로 localize. ARB 4 개 locale 에 `otpRateLimit` 키 추가 + `flutter gen-l10n`.
- **README 블루투스 정품 인증 표기** — MVP 섹션에서 제거, "Roadmap / Phase 2" 로 이동. `BluetoothService` stub 상태 명시.
- **`.DS_Store` 12 개 + `dolda_plan.pdf` tracked** — `git rm --cached` + `.gitignore` 에 `*.pdf`, `dolda_기획서.md`, `.flutter-plugins-dependencies` 추가.

---

## 2. 앞으로 해야 하는 TODO (우선순위별)

### P0 — 다음 세션 1순위

- [ ] **Repository test mock 재작성** — `test/data/repositories/*.dart` 4 파일, 30 errors. `PostgrestBuilder<T, R, S>` 3-generic 변경 미대응으로 main CI 가 2 주+ red. 배포 게이트 복구를 위해 최우선.
  - 권장 경로: **wrapper 인터페이스 도입**. `SupabaseRentalDataSource` 같은 얇은 abstraction 을 repository 와 `supabase_flutter` 사이에 삽입 → 테스트는 wrapper 만 mock, SDK 타입 계층 변경에 둔감해짐.
  - 대안 A: `supabase_flutter` 2.12.2 업데이트 + 공식 fake client (존재 시)
  - 대안 B: testcontainer/Postgres 기반 통합 테스트로 교체 (maintenance 비용 높음)
- [ ] **Xendit 결제 연동** — `payment_service.dart:XenditGateway` 스텁. Indomaret/Alfamart/QRIS/eWallet. 인도네시아 런칭 차단.
- [ ] **Stripe 결제 연동** — `StripeGateway` 스텁. Konbini/PayPay. 일본 런칭 차단.
- [ ] **Escrow state machine** — `reservations.status` 전이 (pending → confirmed → delivered → returned → settled / disputed) 코드 부재. migration 004 에는 컬럼뿐. `lib/data/reservation_state_machine.dart` (신규) + Edge Function + RLS trust boundary.
- [ ] **Firebase / FCM 실제 연동** — `firebase_messaging` 패키지 미설치 → 서버→클라 푸시 수신 불가. 현재 `push_notification_service.dart` 는 로컬 알림 (`flutter_local_notifications`) 만 지원. 필요 작업:
  1. `flutterfire configure`
  2. `firebase_core` + `firebase_messaging` pubspec 추가
  3. `google-services.json` / `GoogleService-Info.plist` 생성
  4. `FirebaseMessaging.onTokenRefresh` 리스너 → `push_tokens` upsert
  5. 세션 0 의 `push-notification` edge function 은 이미 FCM HTTP v1 준비 완료 — service account secret 만 설정하면 동작
- [ ] **브랜드 최종 결정 + 번들 ID 재발급** — 이 세션은 네이티브 label 만 `dol-pin` 으로 통일. `com.dolpin.app` 번들 ID 는 그대로. 브랜드 확정 후 Firebase / Sentry / App Store Connect 재구성 필요.

### P1 — 런칭 전 권장

- [ ] **Universal link** (`apple-app-site-association` + `assetlinks.json`) — 현재는 `dolpin://` 스킴만. 실 도메인 확보 후 추가.
- [ ] **BLE 실 구현 vs drop 결정** — `flutter_blue_plus` + HYBE/SM/JYP 라이트스틱 BLE 스펙 확보 필요. 실 비용 고려 시 Phase 2 드롭 권장 (사진 + Gemini VLM + escrow 로 trust 형성).
- [ ] **Sentry 외 product metric 도입** — PostHog / Grafana / Supabase Analytics. 결제 성공률 / retention / edge function 에러율 / OTP 성공률.
- [ ] **dev / staging / prod flavor** — `--dart-define=APP_ENV=...` + Sentry `environment` tag + 별도 Supabase / Firebase 프로젝트.
- [ ] **PortOne webhook** — 현재 클라이언트 polling 기반. PortOne webhook → `verify-payment` 변형으로 결제 완료 이벤트 수신 (reservation race 방지).
- [ ] **Repository test rewrite 완료 후 `flutter test --coverage` CI 단계 추가**
- [ ] **LICENSE / SECURITY.md** — 라이선스 정책 결정 + anon key 제보 창구.

### P2 — 장기 품질

- [ ] `validators.dart` 를 `AppLocalizations` 소비자로 리팩터 — `Validators.phone(l, value)` 시그니처. 영어 fallback 제거.
- [ ] iOS 권한 사유 문자열 `InfoPlist.strings` 로 KO/EN/JA/ID localize.
- [ ] `reservations.status` 를 Postgres enum 으로 강제 + 전이 validation trigger.
- [ ] 이미지 업로드 EXIF 제거 (위치 정보 프라이버시).
- [ ] `users.fcm_token` 단일 컬럼 → `push_tokens(user_id, device_id, token)` 멀티 디바이스 테이블.
- [ ] `pubspec.yaml` 알파벳 정렬 + `sort_pub_dependencies` lint 활성화.
- [ ] 채팅 메시지 sanitize (zero-width / 제어 문자 제거).
- [ ] `reservation_repository.confirmReturn` 의 `return_photo` path 형식 검증 (`reservations/{id}/return.jpg` regex 또는 signed URL).
- [ ] `analysis_options.yaml` 의 새 lint 를 `info` → `warning` 으로 promote (기존 경고 해결 후).

### P3 — 선택

- [ ] LICENSE, CODEOWNERS, `.gitattributes`.
- [ ] Splash screen / App icon 교체 (현재 Flutter 기본).
- [ ] `integration_test/` 부재 — golden test / 결제 플로우 e2e.
- [ ] App Store 제출용 screenshot 세트 (6.7" / 5.5" / iPad).
- [ ] Accessibility 1차 (Semantics / tap target ≥ 48dp / text scaling clamp).

---

## 3. 세션 1 배포 체크리스트

아래 단계 없이는 새 edge function / migration 이 실제로 동작하지 않습니다.

1. **Supabase secrets**
   ```bash
   supabase secrets set \
     PORTONE_IMP_KEY="..." \
     PORTONE_IMP_SECRET="..."
   ```
2. **Edge function 배포**
   ```bash
   supabase functions deploy verify-payment
   supabase functions deploy refund-payment
   ```
3. **Migration 적용** (순서 중요)
   ```bash
   supabase db push
   # 014 users RLS chat partner
   # 015 reviews guard
   # 016 storage RLS
   ```
4. **ARB → Dart 재생성** — 이미 세션 1 에서 실행됨, 5 개 `app_localizations*.dart` 커밋 포함.
5. **Pub dependencies** — `characters: ^1.3.0` 추가
   ```bash
   flutter pub get
   ```
6. **첫 release 빌드 검증**
   ```bash
   flutter build apk --release
   flutter build ios --release --no-codesign
   ```
   INTERNET 권한이 실제 release APK 에 반영돼 Supabase 호출이 통하는지, iOS 권한 사유 문자열이 reject 되지 않는지 확인.

---

## 4. main CI 상태 (2026-04-11 기준)

- 마지막 성공: **2026-03-27 이전** (`d84f3da` `chore: add .gitignore...`)
- 마지막 실패: `63da32c` PR #13 merge — analyze 일부 정리했지만 repository test 4 파일이 여전히 컴파일 불가
- 세션 1 patch 후: 여전히 red (**repository test 미터치**, 의도적). `lib/` 쪽 신규 이슈 0 건.

→ **CI 복구 = Repository test rewrite** 가 최상위 TODO.

---

## 5. 이 세션에서 의도적으로 건드리지 않은 항목

| 항목 | 이유 |
|---|---|
| Xendit / Stripe 실연동 | 결제사 계정 · API 키 · webhook URL 필요 |
| Escrow state machine 전체 구현 | 대규모 비즈니스 결정 필요 |
| Repository test mock 재작성 | SDK 내부 타입 계층 추측 위험 — 별도 집중 작업 필요 |
| FCM token refresh lifecycle | `firebase_messaging` 미설치 → 리스너 등록 불가 |
| Firebase 프로젝트 재등록 | 번들 ID / 브랜드 최종 결정 선행 |
| dev / staging / prod flavor | 큰 스코프 + 복수 프로젝트 생성 필요 |
| LICENSE / SECURITY.md | 라이선스 정책 결정 |
| 모니터링 플랫폼 도입 | PostHog / Grafana / 등 결정 필요 |
| Splash / App icon | 디자인 asset 필요 |
| BLE 실제 구현 | 제조사 BLE 스펙 확보 + 하드웨어 디버깅 |

---

## 6. 세션 1 에서 수정된 파일 (커밋 단위별 grouping)

1. **Native platform config** — `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`
2. **App bootstrap hardening** — `lib/main.dart`, `lib/core/router/app_router.dart`, `lib/core/utils/error_boundary.dart` (D)
3. **Network + payment types** — `lib/core/errors/failures.dart`, `lib/data/datasources/gemini_service.dart`, `lib/data/datasources/payment_service.dart`, `lib/features/reservation/screens/payment_screen.dart`, `lib/features/register/screens/register_item_screen.dart`
4. **i18n + OTP rate-limit UX** — `lib/core/utils/validators.dart`, `lib/data/repositories/auth_repository.dart`, `lib/features/auth/screens/login_screen.dart`, `lib/l10n/app_{en,ko,ja,id}.arb`, `lib/l10n/app_localizations*.dart` (×5), `pubspec.yaml`, `pubspec.lock`
5. **Supabase backend** — `supabase/functions/{verify,refund}-payment/index.ts`, `supabase/migrations/{014,015,016}_*.sql`
6. **Tooling & CI** — `.github/workflows/ci.yml`, `.github/dependabot.yml`, `analysis_options.yaml`, `lib/core/utils/paginated_notifier.dart`
7. **Repo hygiene + review rewrite** — `README.md`, `.gitignore`, `review.md`, `.DS_Store` ×12 (D), `dolda_plan.pdf` (D)
