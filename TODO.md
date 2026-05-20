# dol-pin 상용화 TODO

> 2026-04-03 기준 | 완성도 ~60%

## 상용화 블로커

- [ ] Xendit 결제 연동 (인도네시아) — 현재 스텁 반환
- [ ] Stripe 결제 연동 (글로벌) — 현재 스텁 반환
- [ ] 에스크로 릴리즈 로직 — DB 스키마만 존재
- [ ] 수수료 계산 엔진 — 15-20% 문서화만 됨
- [ ] 사기 방지 룰 엔진 — fraud_flags 테이블만 존재
- [ ] 프리미엄 배지 등급 산정 로직 + UI
- [ ] 거래 내역 상세 화면

## 신뢰/검증

- [ ] 블루투스 라이트스틱 인증 — 디렉토리 빈 상태
- [ ] IMEI 검증 (폰 대여)
- [ ] 사진 비교 (반납 VLM 검증)
- [ ] 분쟁 해결 플로우

## 수익화

- [ ] 프리미엄 구독 ($4.99/월, 수수료 15%→10%)
- [ ] 정산 대시보드
- [ ] 보증금 반환/차감 자동화

## 배포

- [ ] 앱스토어 제출 (iOS + Android)
- [ ] Supabase Edge Functions — Xendit/Stripe webhook
- [ ] 에러 모니터링 (Sentry/Crashlytics)
- [ ] 환경 분리 (dev/staging/prod)

## 제작 병목 주의

- **Xendit/Stripe 연동**: 각 결제사 공식 문서 + Flutter SDK 예제를 컨텍스트에 선행 로드. 3개국 각각 다른 API라 한 번에 하나씩만
- **에스크로 로직**: 상태 전이(예약→결제→대여→반납→정산→분쟁) 다이어그램 먼저 설계 후 구현. 한 번에 전체 플로우 맡기면 토큰 폭식
- **BLE 연동**: Flutter blue_plus 문서 + 기기별 프로토콜 확인 필수. 하드웨어 의존 디버깅은 AI로 해결 어려움

## 모더나이제이션 잔여 항목 (2026-05-21 sweep 이후)

### 차기 sweep 대상

- [ ] **`portone_flutter` 0.12 → 1.0** — 1.0.x 는 `json_annotation ^4.11`
  을 요구하지만 `custom_lint 0.7.5`가 `analyzer ^7.0.0` 에 묶여 있어
  버전 해석이 안 됨. `custom_lint` 가 analyzer 10+ 지원하는 릴리스 내면
  같은 PR 에서 함께 bump. 그 시점에 V2 widget
  (`package:portone_flutter/v2/portone_payment.dart`) 전환도 고려.
- [ ] **`flutter_riverpod` 2.6 → 3.x** — autoRetry / pause-on-invisible
  / mutation 같은 신규 API 가 있지만 Provider 시그니처 변경 + Consumer
  API 시프트로 작업량 큼. 별도 PR.
- [ ] **`go_router` 14 → 17.x** — 3 메이저. `onEnter` 콜백 / Zone-based
  context / `RelativeGoRouteData` 등 신규. 라우트 정의 전반 검토 필요.
- [ ] **Repository test mock 재작성** — `test/data/repositories/*.dart`
  4 파일이 `PostgrestBuilder` 의 3-generic 변경 미대응으로 `flutter test`
  4개 실패. 이번 sweep 의 변경과 무관하게 main 이 이미 red. 권장: wrapper
  abstraction 도입 (review.md P0).
- [ ] **Flutter SDK 로컬 동기화** — `mise.toml` 은 여전히 `latest` pin.
  CI 는 3.44.0 으로 고정했으므로 로컬에서 `mise install` 한 번 실행해서
  동기화 권장. 또는 mise.toml 도 `3.44.0` 으로 고정.
- [ ] **EXIF strip on image upload** — `flutter_image_compress` 또는
  `image` 패키지로 메타 제거. K-pop 콘서트 GPS 가 사진 메타에 남으면
  사용자 신원 추적 표면. P2 라벨.
- [ ] **PRIVACY.md** — 앱스토어 privacy nutrition label 작성 전 데이터
  흐름표 (Supabase 저장 위치 + retention + 삭제 경로) 1 장 추가.
- [ ] **Supabase RLS lint in CI** — `supabase db lint` 를 PR 잡으로
  추가. 마이그레이션 17개 누적, review 만으로 보장하는 상태.

### 이번 sweep 에서 처리한 항목 (참조용)

- SECURITY.md 작성, dependabot pub-majors 그룹 분리, CI 워크플로
  least-privilege + SHA-pin + Gradle 캐시, CodeQL 워크플로 추가,
  Edge Function 공통 모듈 (`_shared/{cors,auth,quota}.ts`) + `deno.json`
  pin, `gemini-analyze` JWT + per-user quota (migration 017),
  CORS allowlist (`ALLOWED_ORIGINS` env), `analysis_options` lints
  `info→warning`, Sentry `CrashReporter.init` 실제 호출, `iamport_flutter
  → portone_flutter`, `sentry_flutter 8→9`, `share_plus 10→13`, Flutter
  SDK pin 3.44.0 (CI).
