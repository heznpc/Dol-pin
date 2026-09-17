# 2026-09-18 코드 기반 설계 재검토

검토 기준은 `4fd05cb`의 현행 RN·Next.js·공통 패키지·Supabase migrations 001–038과 테스트 소스다. 앱을 종료한 뒤 정적으로 검토했다. 이 기록은 실행 재현·성능 측정·배포 검증 결과가 아니다. 이전 실행 기록도 이번 판단의 검증 결과로 합산하지 않았다.

요구사항과 작업 상태의 기준은 [루트 TODO](../TODO.md)다. 아래 수정 기준은 검토자가 제안한 해결 방향이며, 이미 구현했다는 뜻이 아니다. P1은 운영 투입 전에 해결할 결함, P2는 기능 완결성과 회귀 방지를 위해 처리할 항목이다.

## 총평과 이전 판단의 수정

RPC가 권한·가격·잠금·거래 상태를 책임지고 Edge가 외부 결제사를 호출하는 구성은 실용적이다. 현재 규모에서 프레임워크 교체, 서버 분리, 메시지 브로커 도입을 정당화할 근거는 찾지 못했다. 금액 검증·일관된 잠금 순서·거래 범위 배타 제약·내구성 있는 금전 작업은 유지할 가치가 있다.

문제는 화면과 운영 경로까지 요구사항을 일관되게 적용하지 못한 데 있다. 공유 API가 있어도 인증·오류 표시·복구 상태 해석은 화면마다 따로 구현되고 있다. 데이터 무결성 방어만으로 사용자의 거래가 끝까지 해결되지는 않는다.

이전 작업에서 놓친 사항은 다음과 같다.

- Flutter TODO를 보관 영역으로 옮기면서 현행 TODO를 만들지 않았다. 요청사항이 README·여러 검증 문서에 흩어졌다.
- RN 오류 메시지 검사를 웹과 모든 SDK 오류 경로의 해결로 일반화할 수 없다(D01).
- 이메일 인증 API/모바일 구현을 웹 기능까지 제공한 것으로 간주할 수 없다(D07).
- 복구 테스트는 scheduler의 대기 간격을 확인하지만, 동일 테스트가 사용자 요청의 연속 재시도를 허용한다(D02).
- iOS 5회 시작 검사는 프로세스 생존 검사다. 로그인 UI, 거래 종료 경로, 보안 경계, 오류 대응을 검증하지 않는다.

각 지적은 반대 근거도 확인했다. RLS가 있다는 이유로 열 단위 정보까지 보호된다고 보지 않았고, DB 행 잠금이 있다는 이유로 만료된 worker의 결과까지 차단된다고 보지 않았다. 반대로 기존 권한 검사와 금융 intent가 실제로 존재하므로 “권한 검증이 없다”, “모든 환불이 중복된다” 같은 포괄적 주장은 하지 않는다.

<a id="d01"></a>
## D01 · P1 · 웹 오류 경계가 SDK 원문을 출력한다

근거: [웹 Failure](../apps/web/lib/feedback.tsx) 3행은 `error.message` 또는 `String(error)`를 그대로 렌더링한다. [공통 API](../packages/api-client/src/index.ts) 14–16행과 53–59행은 PostgREST 오류 메시지를 그대로 예외로 만든다. [OAuth callback](../apps/web/app/auth/callback/page.tsx) 11–19행도 URL의 `error_description`을 Failure로 전달한다.

Edge 응답의 안전한 오류 변환은 존재하지만 직접 DB·Auth·Storage 호출과 callback에는 그 경계를 통과하지 않는 경로가 있다. SQL 제약·SDK 진단문·외부 전달 문구가 사용자 화면에 표시될 수 있다. HTML 실행 문제를 주장하는 것이 아니라 내부/외부 원문 노출과 제품 오류 문구 통제 실패다.

수정 기준: 공통 오류 코드→앱 소유 한국어 문구 계약을 만들고 양쪽 UI가 사용한다. 재시도·재로그인·운영 확인을 구분하며 추적 ID는 진단 경로로 보낸다. API 예외와 로컬 검증 메시지를 분리한다. 임의 SQL·경로·callback 문자열이 화면에 나오지 않는 회귀 조건이 필요하다.

<a id="d02"></a>
## D02 · P1 · 자동 복구의 대기 간격을 사용자 호출이 우회한다

근거: [due view](../supabase/migrations/037_recovery_due_clock.sql) 3–5행은 `next_attempt_at`을 검사한다. 반면 최종 [claim 함수](../supabase/migrations/035_recovery_operations.sql) 22–53행은 lease와 review 상태만 검사하고 다음 재시도 시각은 검사하지 않는다. RN 거래 상세 40행과 [웹 거래 상세](../apps/web/app/rentals/[id]/page.tsx) 36행은 5초마다 `recoverPayment`를 호출하고, Edge는 이 요청에서 PG 조회를 실행한다.

[기존 테스트](../scripts/qa/backend_ops_test.ts) 235–260행은 worker가 대기하는 것을 확인한 직후 사용자 환불 endpoint를 연속 호출해 실패 8회를 누적시킨다. 따라서 “모든 경로가 backoff를 지킨다”는 증거가 아니다. 빠르게 실패하는 PG와 열린 화면/여러 탭 조합은 예정된 대기 간격보다 빨리 재조회하고 운영자 확인 상태로 들어갈 수 있다.

수정 기준: 최초 명령과 재조회 권한을 구분하되, 이미 실패한 작업의 재실행은 DB claim에서 다음 허용 시각을 강제한다. 화면의 상태 조회는 PG 호출과 분리하고 `nextRetryAt` 등 서버 상태를 따른다. scheduler·자동 화면 조회·수동 재시도 모두 같은 재시도 정책을 만족해야 한다.

<a id="d03"></a>
## D03 · P1 · 결제 확정/만료 쓰기에 현재 lease 검증이 없다

근거: [결제 복구 코드](../supabase/functions/_shared/rental-finance.ts) 33–92행은 lease로 claim한 후 `finish_toss_confirmation`과 `fail_toss_confirmation`에는 lease를 전달하지 않는다. 최종 정의인 [finish](../supabase/migrations/029_toss_checkout.sql) 45행 이후와 [fail](../supabase/migrations/030_financial_recovery.sql) 308–318행에도 현재 lease 소유권 검사가 없다. 결과 기록·lease 해제에는 해당 검사가 있으므로 전체 경로가 무방비인 것은 아니다.

정적 경쟁 시나리오: 작업 A가 승인 전 상태를 읽고 지연된다. 90초 lease가 만료되어 작업 B가 새로운 lease로 승인을 진행하는 동안 A가 복귀하면, A는 자신의 실행권이 끝났어도 만료 명령을 쓸 수 있다. 특히 fail은 현재 `payment_attempt_merchant_uid`나 새 lease를 확인하지 않고 accepted를 expired로 바꾼다. 이후 B의 확정은 상태 불일치로 실패할 수 있다. 일반 15초 HTTP timeout으로 자주 발생한다고 주장하지 않으며, 장시간 정지·DB 지연·lease 인계 조건의 미재현 정적 결함이다.

수정 기준: 모든 결제 종료 RPC에 lease를 전달하고 예약·checkout을 일관된 순서로 잠근 뒤 현재 소유권과 작업 조건을 재검사한다. 오래된 작업의 paid/expired 쓰기를 모두 거절하는 인계 회귀 사례가 필요하다. 단순 lease 시간 연장으로 대체하지 않는다.

<a id="d04"></a>
## D04 · P1 · 인수·반납 상세 장소가 공개 상품 정보에 포함된다

근거: [rental_items RLS](../supabase/migrations/003_rental_items.sql) 27–30행은 active 상품을 공개하고, [테이블 SELECT 권한](../supabase/migrations/019_explicit_core_read_privileges.sql) 7–8행은 익명 사용자에게도 주어진다. [031 migration](../supabase/migrations/031_rental_handover.sql) 1–3행이 여기에 `pickup_note`를 추가했다. 두 상품 등록 화면은 이를 “인수·반납 장소”로 받으며 상품 상세 화면은 로그인 여부와 무관하게 표시한다. 공통 API도 `select('*')`를 사용한다.

작성자가 상세 주소·연락 정보를 입력하면 거래 전 방문자에게 공개된다. 현재 저장된 실제 개인정보가 있다는 뜻은 아니다. 기존 설계의 “인수 연락과 위치는 당사자에게만” 원칙과 구현이 불일치한다. 공개 만남 장소를 지원하는 것은 가능하지만 상세 정보와 같은 필드로 취급해서는 안 된다.

수정 기준: 공개 지역/랜드마크와 거래 당사자에게 공개할 상세 지시를 분리한다. 비공개 데이터는 별도 테이블 또는 제한된 RPC로 제공하고, 기존 열의 직접 SELECT로 우회할 수 없게 한다. 기존 데이터 이관과 익명·비당사자·당사자 읽기 경계를 함께 검토한다.

<a id="d05"></a>
## D05 · P1 · 현행 거래의 분쟁 해결 경로가 닫혀 있다

근거: [DB 전이](../supabase/migrations/017_reservation_state_machine.sql) 406–411행에는 disputed 전이가 있지만 현행 공통 API와 양쪽 거래 상세에는 분쟁 접수 명령이 없다. [금전 작업 종류](../supabase/migrations/030_financial_recovery.sql) 324행은 refund/settle뿐이다. 보존된 [resolve-dispute](../supabase/functions/resolve-dispute/index.ts) 150–207행은 PortOne 조회/취소를 직접 수행한다. 선택한 `payment_provider`를 해당 실행 전에 분기하거나 거부하지 않는다. `/ops` 화면도 현행 웹 경로에 없다.

정상 반납의 보증금 반환은 구현돼 있지만, 미수령·파손·부분 환불·당사자 이의 제기를 처리할 현행 사용자→운영자→PG→거래종료 경로가 없다. 환불이 필요한 토스 거래에 legacy CLI를 일반 해결책처럼 적용하면 맞지 않는 PG로 요청하고 `dispute_pending` hold를 남길 수 있다.

수정 기준: 먼저 legacy 운영 경로가 지원하지 않는 provider를 금융 hold 이전에 거부한다. 현행 분쟁 접수·증빙·운영 권한·결정 이력·부분 환불 intent를 명시하고 같은 provider adapter/복구 원칙으로 연결한다. 임의 DB 상태 변경을 운영 해법으로 삼지 않는다.

<a id="d06"></a>
## D06 · P1 · 확정 결제의 외부 취소를 다시 대조하지 않는다

근거: [복구 queue](../supabase/migrations/035_recovery_operations.sql) 108–113행은 pending 금전 작업과 accepted checkout만 포함한다. [사용자 recover](../supabase/functions/toss-payment/index.ts)는 accepted가 아니면 PG 조회 없이 현재 DB 상태를 반환한다. 현행 함수 목록에는 결제 상태 변경 webhook 수신 경로가 없다.

paid 이후 결제사에서 수동 취소·부분 취소가 발생해도 앱 내부 금융 작업이 없다면 이 복구 경로는 대조하지 않는다. DB가 paid인 채 물품 인수 전이를 허용할 수 있다. README에도 외부 취소 대응이 계획으로 남아 있었으므로 새로 생긴 회귀가 아니라 기존 미완성 범위다.

수정 기준: 결제사 이벤트 수신과 PG 재조회, 또는 주기 대조로 외부 변경을 발견하고 인수·정산 가능 여부에 반영한다. 이벤트 중복·순서 역전·부분 취소를 내부 operation과 대조하며 이상 건은 운영 검토로 남긴다. 실제 PG 계약 검증은 별도 미검증 항목으로 유지한다.

<a id="d07"></a>
## D07 · P2 · 이메일 계정의 웹 진입점이 없다

근거: [RN EmailAuth](../apps/mobile/src/email-auth.tsx)에는 이메일 가입·비밀번호 로그인·메일 재발송이 있다. [웹 계정 페이지](../apps/web/app/account/page.tsx)에는 소셜/전화 OTP만 있고 같은 이메일 가입·로그인 폼이 없다. 서버 Auth가 이메일을 지원한다는 것만으로 사용자가 웹에서 해당 계정으로 로그인할 수 있는 것은 아니다.

수정 기준: 이메일을 기본 로그인으로 제공하고 보조 전화번호·소셜 코드는 보존한다. 이메일/비밀번호 입력 규칙과 오류 계약을 공유하며 가입 확인·재발송·로그아웃 후 재로그인을 양쪽 요구사항으로 추적한다. 사용자 질문에서 출발한 웹/앱 차이를 동작 기준으로 관리하고 동일 UI를 강제하지 않는다.

<a id="d08"></a>
## D08 · P2 · 자동 처리가 멈춰도 화면은 계속 확인 중이라고 한다

근거: review 작업은 [due view](../supabase/migrations/037_recovery_due_clock.sql)에서 제외된다. 그러나 [거래 안내](../packages/contracts/src/index.ts)의 `rentalGuidance`는 `payment_action`/승인 시도만으로 “확인이 계속된다”고 안내한다. 양쪽 거래 상세의 오류 선택에는 `recovery.error`가 빠져 있고, 사용자에게 허용된 거래 DTO에는 review 상태·다음 재시도·운영 안내가 없다. RN 오류 매핑도 `PAYMENT_REVIEW_REQUIRED`를 따로 처리하지 않는다.

수정 기준: 민감한 PG 정보 없이 `processing / retry_scheduled / needs_review`를 구분한 사용자용 상태를 제공한다. 자동 조회를 멈출 조건, 수동 재시도 가능 여부, 접수/문의 식별자를 양쪽 화면이 같은 계약으로 사용해야 한다.

<a id="d09"></a>
## D09 · P2 · 예약 복구 journal이 동시 제출에 안전하지 않다

근거: [createPendingRentals](../packages/api-client/src/pending-rentals.ts) 24–34행은 owner/item 키에서 read→set→send→remove를 개별 수행한다. 브라우저 여러 탭이 같은 localStorage를 사용하며 원자적 생성이나 비교 후 삭제가 없다. [DB 멱등키](../supabase/migrations/024_rental_request_commands.sql) 25행은 borrower/request ID이고 requested는 재고 배타 제약에 포함되지 않는다.

두 탭이 동시에 빈 값을 읽으면 다른 request ID를 보낼 수 있고 마지막 저장이 앞선 복구 기록을 덮는다. 한 응답이 다른 요청의 복구 키를 삭제할 수도 있다. 기존 테스트는 순차 재시작과 저장 실패를 검사하지만 이 경쟁을 다루지 않는다. 저장된 문자열의 JSON/형식 파손도 정상 조회와 분리된 회복 경로가 없다.

수정 기준: 요청별 journal과 동일 owner/item 제출의 원자적 조정, 자신이 저장한 request만 삭제하는 조건을 둔다. 여러 탭 경쟁·한 응답 유실·손상된 journal을 검증 대상으로 추가한다. 서버에 커밋됐는지 모르는 요청을 단순 삭제해서 새 ID로 보내지 않는다.

<a id="d10"></a>
## D10 · P2 · 업로드 파일과 상품 등록의 수명이 분리돼 있다

근거: 양쪽 상품 등록 화면은 사진 선택 즉시 [공개 product-photos bucket](../supabase/migrations/021_product_authoring.sql)에 업로드한 뒤 로컬 폼에 URL을 저장한다. 제출 취소·등록 실패와 연결된 업로드 세션/정리 경로가 없고 bucket 정책은 읽기/삽입만 제공한다. 비공개 반납 사진도 업로드 성공 뒤 반납 RPC가 실패할 수 있다.

등록을 마치지 않은 사진이 공개 URL로 남거나 참조되지 않는 파일이 누적될 수 있다. 개별 파일 크기 제한은 있어도 이 생명주기 문제를 해결하지 않는다.

수정 기준: 업로드의 소유자·참조·확정 상태를 기록하고 유예 기간 뒤 미참조 파일만 정리한다. 거래 증빙은 참조와 보존 기준을 확인하기 전 삭제하지 않는다. 사용자별 사용량 제한과 계정 삭제 시 처리 범위도 같은 계약에 포함한다.

## 추가로 누락된 설계·QA 과제

다음은 위 결함 수정과 별도로 범위를 확정해야 할 검토자 제안이며, 과거 사용자 지시라고 간주하지 않는다.

- **Q01 · 요구사항 기반 QA:** 브라우저 거래 QA의 [actor](../scripts/qa/browser/rentals.spec.ts) 5–8행은 세션을 직접 넣는다. 이메일 API 검사와 거래 QA만으로 실제 가입/로그인 UI 누락을 발견할 수 없다. 사용자 요구→플랫폼→테스트 소스→실행 증거를 구분한 추적표가 필요하다. D02의 즉시 반복 호출을 정상으로 인정하는 테스트 기대값도 수정 대상이다.
- **Q02 · 인수·반납 실패 정책:** 인수는 lender 단독 전이이고 차용자 확인/미수령 이의 절차가 없다. 반납 신고는 `returned`와 `return_confirmed_at`을 즉시 기록하지만 실제 lender 수령 확인은 이후 settle 명령이다. 연체·미반납·수령 확인 거부에 대한 기한과 운영 처리 기준, 시간대·인수 사실 증거를 명시해야 한다. 이 정책을 검토 없이 새 금전 자동화로 만들지는 않는다.
- **Q03 · 계정 복구:** 이메일 로그인 이후 비밀번호 재설정/회복 callback 경로가 없다. 가입·로그인 구현 상태와 계정 회복의 완결성을 구분한다.
- **Q04 · 상품 등록 멱등성:** [createItem](../packages/api-client/src/index.ts)은 제출마다 서버 기본 ID로 insert한다. 응답 유실 후 재제출에서 중복 상품을 방지할 고정 request ID 계약이 없다. 등록과 업로드 수명에 함께 반영한다.
- **Q05 · 종료 상태의 조회 비용:** 양쪽 거래 상세는 완료/취소 후에도 5초 조회를 유지한다. RN 결제 복구 query는 화면 경로의 활성 여부를 확인하지 않는다. 전면 화면·진행 상태에 따라 조회를 제한할 필요가 있다. 정적 호출 구조의 문제이며 실제 처리량/지연 수치를 측정한 결론은 아니다.
- **Q06 · 세션 교체 중 비동기 완료:** query cache/메모리 초안 삭제는 있으나 이미 진행 중인 등록·예약 mutation의 성공 callback은 계정 교체 이후에도 navigate/상태 변경을 수행할 수 있다. 인증 세대별 결과 적용과 저장된 복구 요청 보존/접근 정책을 함께 확인해야 한다.

## 실제 수정 순서

첫 순서는 D01·D07의 명시적 사용자 요구 누락과 D04 공개 데이터 경계다. 그다음 D02·D03·D08을 하나의 복구 계약으로 맞춘다. D05·D06은 운영 투입 전 금융 종료 경로의 필수 조건이다. D09·D10과 Q01–Q06은 해당 흐름의 회귀 조건까지 함께 작업한다. 새 프레임워크/서비스로 재작성하지 않고 현재 모듈·RPC 경계를 보완한다.
