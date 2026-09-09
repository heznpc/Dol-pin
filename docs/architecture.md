# Dol-pin architecture

상태: 재편 목표 구조. 현재 구현 여부는 `rewrite-verification.md`를 따른다.

```text
React Native + Expo                 Next.js
주요 소비자 앱                       소비자 웹 + /ops
native session/camera/deep link      SSR / URL filters / web session
          |                            |
          +----- contracts / api-client+
                         |
                    Supabase Auth
                         |
        +----------------+-------------------+
        |                                    |
   RLS read / 허용 필드 수정          RPC / Edge Functions
        |                           DB command / PG orchestration
        |                                    | <--> PortOne
        +---------------PostgreSQL-----------+
                      constraints / locks
                  reservations / payments / refunds
                    events / recovery work
                             |
                          Storage
                공개 상품 사진 / 비공개 거래 증빙
```

## 책임

- RPC: authenticated actor 확인, role/현재 상태/전제조건 검증, 잠금,
  원자적 상태 변경과 이벤트 기록. 외부 HTTP를 DB transaction 안에서 호출하지 않는다.
- Edge Function: PG 재조회·취소·웹훅 검증·복구 실행. 외부 호출 전 intent를 저장한다.
- Next.js: 페이지·세션·SSR. 독자적인 결제·취소·정산 규칙을 만들지 않는다.
- Service role: 제한된 내부 작업만. RLS를 우회하므로 사용자 요청의 권한을
  service role 보유 여부로 대체하지 않는다.
- `/ops`: 관리자 사용자 신원·권한을 검증한 command만 실행. 범용 상태 UPDATE 금지.

## 공유 패키지

`packages/contracts`: DTO, Zod schema, command 입출력, 표시 정보, 생성 DB 타입.
`packages/api-client`: 주입된 Supabase client를 통한 read/command 호출.

UI·React hooks·platform storage·authoritative business rule은 공유 패키지에
섞지 않는다. 단순 타입과 함수를 각자 별도 workspace로 쪼개지 않는다.

## Client state

| 데이터 | 소유자 |
| --- | --- |
| 상품·예약·결제·프로필 | 서버; 상호작용 캐시는 TanStack Query |
| 웹 검색·정렬·공유 가능한 필터 | URL |
| 모바일 화면 간 탐색 조건·미제출 예약 초안 | route 또는 필요한 Zustand store |
| 입력 폼의 진행 중 값·validation | React Hook Form + Zod |
| 확정 가격·권한·available actions | backend; client 값은 UX 보조만 |

로그아웃/계정 교체 시 사용자 캐시와 초안을 지운다. 사용자별 query key를
분리한다. Zustand의 예시를 신규 기능 요구사항으로 해석하지 않는다.

## 금융 작업

1. DB에 고유 operation ID·목적·금액·payment 연결을 먼저 저장한다.
2. worker가 실행권을 획득하고 PG를 호출한다.
3. 결과를 같은 operation에 반영한다. 상태 변경과 event는 하나의 transaction이다.
4. 결과 불명은 PG 재조회/복구 대상으로 남긴다. 오래된 intent도 복구 대상이다.

execution lease 만료는 금융 작업 실패가 아니다. lease를 다른 worker가
획득해도 PG 결과가 불명인 상태에서 새 operation으로 취소를 재실행하지 않는다.
PG success 뒤 DB가 실패하면 `reconciliation_required` 쓰기 자체도 실패할 수
있다. 따라서 해당 enum을 반드시 저장할 수 있다고 가정하지 않는다.

## 보존 기준

기존 reservations·concerts·rental_items와 유효한 제약은 근거가 있을 때만
변경한다. 새 이름이나 프런트엔드 프레임워크 때문에 DB를 초기화하지 않는다.
신규 migration은 누적 적용하며 배포 데이터의 존재·양·호환성은 별도 확인한다.
