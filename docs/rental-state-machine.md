# 거래 정책과 상태 전이 설계

상태: 구현 전 정책 초안. 기존 `reservation_status`는 아직 변경하지 않았다.

## 제품 경계

K-pop 콘서트용 한정 품목의 개인 간 대여. 상품 하나는 개별 물품 하나를
뜻한다. 수량 재고·묶음 상품은 이번 범위에서 제외한다.

요청 여러 개는 공존할 수 있지만 같은 기간의 수락/활성 대여는 공존할 수 없다.
서버에서 가격을 계산하고 수락된 상품·가격·보증금·기간·인수 조건을 snapshot으로
고정한다. 조건 변경이 필요하면 이용자 재동의를 받는다.

당일 대여를 허용할 수 있어야 한다. 기존 DATE 차액 방식은 당일 대여를
거부하므로 그대로 이식하지 않는다. 예약 시간대는 Asia/Seoul을 명시하고,
실제 점유 시간과 요금의 일수 반올림 규칙은 별도 계약으로 정의한다.

## 제안 상태 전이

아래 이름은 wire/schema 확정 전이다. payment/refund state를 예약 enum에
전부 중복하지 않는다. 인수 가능 여부는 결제 상태도 함께 검증한다.

| From | Command | Actor | Preconditions | To |
| --- | --- | --- | --- | --- |
| 없음 | requestRental | borrower | 본인 상품 아님, 허용 품목/기간, 서버 견적 | requested |
| requested | acceptRental | lender | 본인 상품, 조건 일치, 겹치는 점유 없음 | accepted |
| requested | rejectRental | lender | 본인 거래 | rejected |
| requested | cancelRental | borrower | 본인 거래 | cancelled |
| accepted | expireRental | system | 결제 기한 경과; 진행/결과 불명 PG 작업 처리 정책 적용 | expired |
| accepted | verifyPayment | backend | 고정 payment attempt와 PG 금액/통화/상태 일치 | accepted + payment paid |
| accepted | confirmPickup | lender | payment paid, 환불/분쟁 없음, 거래 활성 | picked_up |
| picked_up | reportReturn | borrower | 본인 비공개 증빙, 거래 활성 | return_reported |
| return_reported | confirmReturn | lender | 물품 수령·상태 확인 | returned |
| returned | completeRental | system | 보증금 처리 완료, 미해결 분쟁 없음 | completed |
| accepted | cancelRental | participant | 인수 전, 정책 충족; 결제 있으면 환불 intent | cancelled + refund pending/none |
| picked_up/return_reported/returned | openDispute | permitted participant | 사유·증빙, 해결되지 않은 해당 거래 | disputed |
| disputed | resolveDispute | ops | 권한·사유·금전 작업 결과 확정 | 정책에 따른 종료 상태 |

`cancelled`는 보증금/결제 환급이 끝났다는 뜻이 아니다. 사용자에게 예약 상태와
환불 처리 상태를 함께 보여준다. `completed`도 대여료 실제 지급을 뜻하지 않는다.
자동 lender payout은 제외하며 지급 대기와 실제 지급 완료를 구분한다.

## 반드시 테스트할 정책

- 동시에 다른 요청 두 개를 수락했을 때 단 하나만 점유를 획득한다.
- 결제 만료와 PG 성공이 경합해도 돈을 받았다는 사실을 잃지 않는다.
- 반납 신고와 대여자 수령 확인은 다른 action이다.
- 조건 snapshot은 이후 상품 수정의 영향을 받지 않는다.
- 누적 완료 환불 + 진행 중 환불이 결제액을 넘지 않는다.
- 보증금 반환, 거래 취소, 분쟁 환불은 별도 operation으로 식별한다.
- 인수 연락과 위치는 거래 당사자에게만 제공한다.
- 미응답/분실/분쟁은 최소 operations 처리로 연결한다. 자동 배상 판정은 하지 않는다.
