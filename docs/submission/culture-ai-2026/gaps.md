# dol-pin 공모전 제출 gap 정리

기준 시각: 2026-06-26 09:30 KST

공식 확인 출처:
- [제4회 문화체육관광 인공지능·데이터 활용 공모전 공모요강](https://www.culture.go.kr/digicon/pages/contest_1)
- [제4회 문화체육관광 인공지능·데이터 활용 공모전 접수하기](https://www.culture.go.kr/digicon/pages/contest_2)

## README ↔ 코드 차이

| README 주장 | 코드/문서 증거 | 현재 판정 | 제출 문서 반영 방식 |
|---|---|---|---|
| K-pop 콘서트 물품 C2C 대여 마켓플레이스 | `lib/features/home/screens/home_screen.dart`, `lib/features/explore/screens/explore_screen.dart`, `lib/data/repositories/rental_repository.dart`, `supabase/migrations/003_rental_items.sql` | 구현됨 | 콘서트 기반 물품 탐색/등록 프로토타입으로 작성 |
| Gemini 기반 물품 인증 | `lib/data/datasources/gemini_service.dart`, `supabase/functions/gemini-analyze/index.ts`, `test/data/repositories/gemini_edge_contract_test.dart` | 코드/구조 검증됨, 실제 Gemini 호출 미검증 | AI 사진 분석/태깅 흐름은 핵심 기능으로 쓰되 실환경 검증은 별도 리스크로 표기 |
| KRW / PortOne 기준 예약 결제 검증 | `lib/features/reservation/screens/payment_screen.dart`, `lib/features/reservation/screens/reservation_screen.dart`, `supabase/functions/verify-payment/index.ts`, `test/data/repositories/payment_edge_contract_test.dart` | 코드/구조 검증됨, PortOne sandbox 영수증 미확보 | 실제 결제 운영/거래가 아니라 검증 로직이 있는 프로토타입으로 표기 |
| 예약 기반 채팅 | `lib/data/repositories/chat_repository.dart`, `supabase/migrations/011_chat_rooms.sql`, `test/data/repositories/chat_repository_test.dart` | 구조 검증됨 | 결제 확인 후 예약 단위 채팅방 연결 흐름으로 작성 |
| 픽업, 반납 사진 업로드, 보증금 반환 흐름 | `lib/features/reservation/screens/reservation_detail_screen.dart`, `lib/features/reservation/application/reservation_action_controller.dart`, `lib/data/datasources/storage_service.dart`, `supabase/functions/settle-reservation/index.ts` | 코드/구조 검증됨, 실제 결제 환불 미검증 | 반납 사진 증빙과 상태 전환 설계는 구현됨, 실제 보증금 환불은 미검증으로 표기 |
| 운영자 분쟁 해결 Edge Function | `supabase/functions/resolve-dispute/index.ts`, `scripts/resolve-dispute.mjs`, `docs/ops-runbook.md` | 코드/구조 검증됨, 배포/운영 콘솔 없음 | 운영자 CLI 기반 분쟁 처리 흐름으로 작성, 자동 판정/자동 정산으로 쓰지 않음 |
| 대여자 신뢰 표시 모델 | `lib/data/models/user_model.dart`, `lib/features/profile/widgets/lender_badge.dart`, `supabase/migrations/017_reservation_state_machine.sql`, `test/data/repositories/reservation_repository_test.dart` | 기본 모델/보호 로직 있음, 신뢰 점수 산식 운영 검증 없음 | 신뢰 표시 기반은 있다고 쓰되 KPI/실사용 평판 데이터는 쓰지 않음 |
| Bluetooth 정품 인증 | `lib/data/datasources/bluetooth_service.dart` | 명시적 stub | Phase 2 로드맵으로만 표기 |
| 자동 전후 사진 판정 | README Roadmap에 미구현으로 표기, 자동 판정 코드 없음 | 미구현 | 로드맵으로만 표기 |
| 자동 lender payout | `docs/escrow-state-machine.md`가 out-of-band 지급으로 명시 | 미구현 | 자동 정산이라고 쓰지 않고 운영/배치 정산 대상이라고 표기 |
| Indonesia/Japan localization + payment adapter hardening | `lib/l10n/*.arb`와 `PaymentService` stub 존재 | 다국어 UI는 구현, IDR/JPY 결제는 미구현 | 다국어 UI는 구현 기능, 해외 결제는 로드맵으로 분리 |

## 공모전 요구사항 ↔ 현재 구현 차이

| 공식 요구/조건 | 공식 페이지 기준 | dol-pin 현재 상태 | gap/리스크 |
|---|---|---|---|
| 접수 기간 | 2026.04.27 ~ 2026.06.26 접수 | 제출 패키지 작성일이 마감일 당일 | 공식 페이지에서 확인한 마감일 안에 압축/PDF 변환/업로드 필요. 확인되지 않은 마감 시각은 쓰지 않음 |
| 참가 자격 | 대한민국 국민 누구나, 개인 또는 5인 이내 팀/단체/기업 가능, 동일작품 중복응모 불가 | 레포 내 참가 신청서 작성 증거 없음 | 신청서에서 참가자/팀 정보를 owner가 직접 확정해야 함 |
| 제출 서류 | 참가신청서, 기획서 또는 분석보고서, 참가 서약서, 개인정보 수집 및 이용 동의서 PDF 압축 제출 | 본 디렉터리는 기획서/증빙 보조 문서만 제공 | 공식 양식 다운로드 후 PDF 작성/서명 필요 |
| ADX 우수사례 조건 | AI·디지털 기술을 활용한 문화서비스 우수사례이며, 모바일/웹 시제품 완료 또는 상용화 증빙 필수 | iOS simulator build/install/launch와 테스트 통과 증거 있음. 인증 이후 핵심 플로우 실제 시연은 미확보 | 우수사례로 제출하려면 핵심 플로우 스크린샷/영상과 환경변수 기반 실서비스 시연 증빙 추가 필요 |
| ADX 아이디어 조건 | AI·디지털 기술을 활용한 문화서비스 사각해소 및 국민체감형 서비스 기획 | 현재 증거만으로도 기획/프로토타입 패키지 가능 | 실제 시연 증빙이 부족하면 이 트랙이 더 안전 |
| 심사 기준 | 신기술 활용 1차: 기획성, 적합성, 차별성, 활용성, 사회적 기여도. 2차: 창의성/혁신성, 문제해결력, 완성도, 확장성/지속성, AI 활용 가점 | 각 항목에 맞춘 기획서 초안 작성 가능 | 완성도 항목은 실결제/실사용 증빙 부족을 솔직히 제한사항으로 써야 함 |
| IP/저작권 | 출품작 저작권은 출품자에게 있고, 수상작은 주최/주관이 비영리 목적으로 이용 가능. 타인 권리 침해 책임은 참가자에게 있음 | 외부 인물명/이메일/실명 사용 없이 Heznpc 표기로 작성 | 제출 전 이미지/샘플 데이터/상표 표현 검토 필요 |
| 시제품 완료 또는 상용화 증빙 필수 여부 | ADX 우수사례와 문화데이터 우수사례는 증빙자료 필수 | 앱 빌드/실행과 구조 검증은 가능하지만 실제 운영 증빙은 없음 | 우수사례 유지 시 제출 영상/스크린샷/테스트 로그가 핵심 증빙 |

## 우수사례 제출 가능 여부

현재 상태의 권장 포지션은 **ADX 아이디어 제출**입니다.

근거:
- `mise exec -- flutter analyze`, `mise exec -- flutter test`, `node scripts/release-preflight.mjs --structure-only`가 모두 통과했습니다.
- iOS simulator용 `build/ios/iphonesimulator/Runner.app` 디버그 빌드가 생성되었고, launch 명령은 pid를 반환했으며, 알림 권한 팝업 스크린샷을 저장했습니다.
- 코드에는 콘서트 탐색, 물품 등록, AI 사진 분석, 예약 의도 생성, KRW 결제 검증, 반납 사진, 분쟁 처리 흐름이 존재합니다.

제한:
- 화면 증빙은 앱 UI가 아니라 알림 권한 팝업이 표시된 첫 실행 화면까지만 확인했습니다.
- 실제 Supabase 프로젝트, Gemini API, PortOne sandbox/production 영수증, Edge Function 배포 로그는 현재 세션에서 확인하지 못했습니다.
- 실제 사용자 수, 거래 수, 매출, KPI, 상용 운영 증거는 없습니다.

따라서 현재 제출물은 **ADX 아이디어로 고정**하는 편이 안전합니다. 오늘 제출 문서에서는 우수사례 가능성을 열어두지 않고, 별도 제출 기회가 있을 때 핵심 플로우 영상과 Gemini/PortOne/Supabase 실환경 증빙을 새로 확보한 뒤 재검토합니다.

## 아이디어 트랙으로 낮춰야 하는 조건

아래 중 하나라도 제출 전까지 해결하지 못하면 **ADX 아이디어**로 낮추는 편이 안전합니다.

| 하향 조건 | 이유 |
|---|---|
| 인증 후 콘서트 선택 → 물품 등록 → AI 사진 검증 → 예약 → 결제/상태 전환 → 반납/분쟁 흐름을 영상으로 보여주지 못함 | 우수사례의 시제품 완료 증빙이 부족함 |
| Gemini Edge Function이 실제 API 키로 응답하는 장면 또는 테스트 로그가 없음 | AI 핵심 기능이 구조 검증에 머무름 |
| PortOne sandbox 결제/검증 영수증 또는 로그가 없음 | 결제 검증이 코드 주장에 머무름 |
| Supabase migration/function 배포 또는 로컬 Supabase 통합 실행 증거가 없음 | 서버 상태머신과 Edge Function이 실제 실행 환경에서 검증되지 않음 |
| 공식 양식에 상용 운영, 실사용자, 매출, KPI를 요구하는 서술을 넣어야 하는데 증빙이 없음 | 허위/과장 리스크가 큼 |

## 제출 전 최소 보강 목록

1. 테스트 계정과 테스트 데이터로 핵심 플로우 60~90초 영상을 촬영합니다.
2. Gemini 사진 분석 성공 화면 또는 Edge Function 로그를 확보합니다.
3. PortOne sandbox 결제 검증 로그를 확보하거나, 결제 부분은 구조 검증으로 명확히 낮춰 씁니다.
4. 공식 참가신청서/서약서/개인정보 동의서를 최신 양식으로 작성하고 PDF로 변환합니다.
5. 외부 표기 이름은 `Heznpc`만 사용합니다.
