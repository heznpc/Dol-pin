# Dol-pin 재편 실행 계획

상태: 사용자 승인 조건 반영, 실행 중. 2026-09-09.

## 제품과 목적

Dol-pin은 K-pop 콘서트에서 사용하는 한정된 품목의 C2C 대여 서비스다.
일반 렌탈·중고거래·SaaS로 확장하지 않는다. React Native + Expo 전환은
사용자가 결정한 전제다. 기존 통제를 보존하면서 결함과 정책 공백을 고치는
**frontend rewrite + backend hardening + domain policy completion**으로 정의한다.

## 승인 조건 — 실행 순서에 적용

1. 각 domain vertical slice는 **RN 구현 → backend 실제 검증 → Web 연결**
   순서로 진행한다. RN/Web을 별도로 병렬 구현하거나, backend 검증 실패를
   무시하고 Web을 붙이지 않는다. 계약·schema는 처음부터 양쪽을 지원한다.
2. PortOne 버전은 기존 V1과 V2의 멱등성·웹훅·RN 지원·이전 비용을 비교한
   ADR 이후 결정한다. 최신이라는 이유로 전환하지 않는다.
3. 운영 경로는 `/ops`다. 거래 조사·미완료 금융 작업·복구·분쟁·이력 중심이며
   상태를 직접 고치는 범용 CRUD 도구가 아니다.
4. metrics UI는 제외한다. 초기에는 사건/시각/출처를 기록할 schema와
   instrumentation만 둔다. conversion/cancel/refund rate는 실제 데이터 이후다.

## 변하지 않는 경계

- 모바일과 웹 모두 소비자가 거래를 시작하고 끝낼 수 있다. UI parity는 요구하지 않는다.
- 거래 권한과 상태 전이는 Supabase RPC/Edge Functions에 둔다.
- Next.js Server Action은 필요할 때 공통 command를 호출하는 얇은 어댑터다.
- 승인되지 않은 최초 public 전환·공개 배포는 최종 결과를 제시한 뒤 별도 승인한다.
- 단계별 구현·검증·diff 검토·커밋·푸시. 실구동 전에는 완료로 표시하지 않는다.
- Flutter는 새 클라이언트의 실구동 검증 전까지 그대로 보존한다.

## Phase

| Phase | 변경 내용 | 보존 | 재작성/제외 | 검증·완료 기준 |
| --- | --- | --- | --- | --- |
| 1 | legacy audit·거래 정책·ADR | 유효한 규칙과 테스트 사례 | 사실과 다른 문서 | 코드 근거, 모르는 항목, 실제 검증 결과 구분 |
| 2 | 최소 workspace·RN 기반·공통 계약 | Flutter 참고본 | 불필요한 공유 추상화 제외 | RN 개발 빌드·로그인·사진/결제 복귀 기술 검증; Web은 기반만 |
| 3 | DB·Auth·Storage | 유효 제약과 RLS 의도 | 비공개 증빙, 허용 필드, 권한 경계 | local reset·실제 비인가 read/write 차단 |
| 4 | 상품 slice | 콘서트·품목·상품 UX | 클라이언트 UI | RN 등록/탐색 → backend 검증 → Web 동일 계약 연결 |
| 5 | 예약 slice | 서버 계산·기간 중복 방어 | 수락·거절·만료·조건 snapshot | RN → 동시 수락/만료/당일 대여 검증 → Web |
| 6 | 결제 slice | 유효 결제 검증 사례 | ADR에 따른 어댑터·intent/웹훅 | RN → 위조/중복/늦은 결제·PG 결과 불명 검증 → Web |
| 7 | 인수·반납·환불 slice | 사진 증빙과 역할 분리 | 환불 식별·복구 | RN → 초과/중복 환불·PG 성공/DB 실패 검증 → Web |
| 8 | operations | 분쟁 처리 개념 | 공유 관리자 키·수동 상태 편집 | `/ops` 권한·작업 이력·반복 복구 안전성 |
| 9 | 통합·CI | 의미 있는 테스트 사례 | 핵심 문자열 검사 대체 | 두 client 교차 거래, 앱 복귀, 실제 RLS/RPC, CI |
| 10 | 시연·문서·배포 준비 | 제품 정체성·근거 | 안정화 후 Flutter 보관 | 재현 가능한 빌드/시연; 최초 공개 승인 요청 |

CI는 각 phase의 검증이 생기는 즉시 추가한다. Mock PG E2E와 실제 PortOne
test channel 검증은 따로 기록한다. 빌드 성공은 결제·권한·실구동 증거가 아니다.

## Scope cut

해외 PG·Bluetooth·AI 추가·추천·커뮤니티·최근 본 상품·상품 비교·고급 지표·
자동 대여료 지급·microservices·Kafka·full event sourcing은 제외한다.
인수 조율에 필요한 최소 연락 수단은 별도이며, 채팅 고도화 제외와 혼동하지 않는다.

## 추적

- [기존 구현 감사](legacy-audit.md)
- [아키텍처](architecture.md)
- [거래 정책](rental-state-machine.md)
- [결제 버전 조사](adr/004-portone-version-investigation.md)
- [검증 기록](rewrite-verification.md)
