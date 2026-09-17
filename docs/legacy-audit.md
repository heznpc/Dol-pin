# Legacy audit — 2026-09-09

2026-09-17 경로 정리: 아래 `lib/`, `test/`, `ios/`, `android/` 경로의 Flutter
파일은 현재 `legacy/flutter/` 아래에 있다. 이 표는 당시 감사 기록이며 현행 앱의
기능·CI 상태는 루트 README와 `docs/backend-operations.md`를 기준으로 확인한다.

정적 코드 감사. IMPLEMENTED는 코드 존재를 뜻하며 실서비스 실행 성공을 뜻하지
않는다. 원격 schema·PG 계정·운영 데이터는 미확인이다. BROKEN은 코드상 잘못된
경로가 발견됐다는 뜻이며 런타임 재현 여부를 별도 표기한다.

| 영역 | 상태 | 처리 | 코드 근거와 발견 |
| --- | --- | --- | --- |
| 콘서트·품목 탐색 | IMPLEMENTED | PRESERVE | `lib/features/explore/screens/explore_screen.dart:55`: concert/category filter. `lib/core/constants/enums.dart`: 한정 품목 enum |
| 서버 가격·당사자 계산 | IMPLEMENTED | PRESERVE | `supabase/migrations/017_reservation_state_machine.sql:978`: item 잠금·서버 계산·자기 상품 예약 거부 |
| 서버 상태 전이 | IMPLEMENTED | PRESERVE/HARDEN | 같은 migration `:425`: actor 추론, role, legal transitions, FOR UPDATE. `:45`에서 broad participant UPDATE policy 삭제 |
| 대여자 수락 | NOT IMPLEMENTED | REWRITE | `lib/core/constants/enums.dart:3`: 별도 accepted 제거. 새 요청→수락→결제는 제품 정책 변경 |
| 기간 중복·만료 | PARTIAL | PRESERVE/HARDEN | migration `:244`: exclusion constraint는 pending부터 기간 점유. `:608` 만료 함수. 새 정책은 요청 공존/수락 시 점유 |
| 날짜 계산 | PARTIAL | REWRITE | migration `:1006` return_date <= rental_date 거부. 당일 콘서트 대여를 표현하지 못함 |
| 결제 검증 | PARTIAL | PRESERVE/HARDEN | `supabase/functions/verify-payment/index.ts:151`: 금액·통화·attempt 검증과 `mark_reservation_paid`; 통화와 attempt 검증이 조건부 |
| 결제 보상 처리 | PARTIAL | REWRITE | 같은 함수 `:204`: RPC 오류/실패에 자동 취소. DB commit 후 응답 유실과 확정 거부를 구분할 증거 부족 |
| 금융 잠금 만료 | BROKEN | REWRITE | migration `:483`, `:825`: 경과 시간만으로 payment_action 해제. PG 성공/DB 실패 이후 인수 등 잘못된 전이가 가능. 장애 재현은 미검증 |
| 전액 환불 | PARTIAL | PRESERVE/HARDEN | `supabase/functions/refund-payment/index.ts`: intent-like pending 저장, provider cancelled 재조회 후 local transition 재시도. 복구가 없다고 평가하면 안 됨 |
| 보증금 부분 취소 | PARTIAL | PRESERVE/HARDEN | `supabase/functions/settle-reservation/index.ts`: lender 확인, 부분 취소, 누적 cancel_amount 기반 재시도. operation별 근거 보강 필요 |
| 대여료 지급 | NOT IMPLEMENTED | DROP FROM MVP | 같은 함수가 `lender_payout_pending` 반환. settled는 실제 지급 증명이 아님 |
| Storage | PARTIAL | REWRITE | `016_storage_rls.sql:34` rental-photos 전체 공개 SELECT. `017`은 반납 증빙 쓰기 제한. 공개 상품과 비공개 증빙 분리 필요 |
| 프로필·review | PARTIAL | PRESERVE/HARDEN | `018_public_user_profiles.sql` 공개 필드 축소 view. `017:268` 완료 거래 당사자 review 제한. 실제 RLS 검증 필요 |
| 운영 분쟁 | PARTIAL | REWRITE | `resolve-dispute/index.ts:40` shared admin key, 부분 환불·resolution 이력. 사용자 ops 권한·복구 command로 전환 |
| 오류 보고 | PARTIAL | PRESERVE | `lib/core/utils/crash_reporter.dart`: DSN 조건부 Sentry, debug no-op. 배포 수집 여부 UNKNOWN |
| 테스트 | PARTIAL | PRESERVE/REWRITE | `test/data/repositories/payment_edge_contract_test.dart`, `storage_policy_test.dart`: 소스 문자열 검사. domain 테스트 사례는 살리고 실제 DB 테스트 추가 |
| CI | PARTIAL | REWRITE | `.github/workflows/ci.yml`: Flutter analyze/test, release structure, Deno check. DB reset·RLS·동시성·E2E gate 없음 |
| BLE | NOT IMPLEMENTED | DROP | `lib/data/datasources/bluetooth_service.dart:68`: 명시적 stub, UnimplementedError |
| 해외 결제 | NOT IMPLEMENTED | DROP | `lib/data/datasources/unsupported_payment_gateways.dart`: 미지원 adapter |
| Flutter UI/runtime 반복 장애 | UNKNOWN | INVESTIGATE | 전환 배경은 사용자 제공. 원인별 재현 목록은 아직 없음. RN 전환만으로 해소됐다고 주장하지 않음 |

## 다음 감사/실검증

1. 기존 migrations를 fresh local Supabase에 적용해 baseline 재현.
2. 실제 사용자 역할로 RLS/RPC 및 시간 경과 환불 장애 경로 실행.
3. Auth callback·사진·인수 연락 UX와 오류 재현 목록 확인.
4. PG API/SDK 비교와 실제 test channel 가용성 확인.
5. 원격 적용 전 데이터 존재·migration 호환성·공개 이력 별도 확인.
