# 공식 요강 기준 제출 증빙

작업 시각:

```text
NOW=2026-06-26 09:30 KST
NOW_DATE=2026-06-26
WINDOW_START=2026-03-28
```

기준 문서: [source-pack.md](/Users/ren/IdeaProjects/APP/dol-pin/docs/submission/culture-ai-2026/source-pack.md)

## 최종 트랙 판정

**DOWNGRADE: ADX 아이디어**

판정 이유:
- 공식 요강상 ADX 우수사례는 시제품 구현 완료 또는 상용화된 아이템이어야 하며 증빙자료 첨부가 필수입니다.
- 현재 확보된 증빙은 정적 분석, 전체 테스트, 구조 preflight, iOS simulator 디버그 빌드, launch pid 반환, 알림 권한 팝업 스크린샷입니다.
- 그러나 공식 우수사례 제출에 필요한 핵심 화면 스크린샷 또는 영상은 알림 권한 팝업 수준을 넘어 `콘서트 선택 -> 물품 등록 -> AI 사진 검증 -> 예약 -> 결제/상태 전환 -> 반납/분쟁` 흐름으로 아직 확보되지 않았습니다.
- 따라서 우수사례라고 쓰지 않고 ADX 아이디어로 낮추는 것이 안전합니다.

## 원본 로그 파일 위치

2026-06-26 07:57 KST 이후 실행 가능한 검증 명령을 다시 실행했고, 원본 출력은 아래 파일로 보존했습니다. 상세 요약은 [verification-log.md](/Users/ren/IdeaProjects/APP/dol-pin/docs/submission/culture-ai-2026/verification-log.md)를 기준으로 봅니다.

| 검증 항목 | 원본 로그/증빙 파일 | 결과 | 주의 |
|---|---|---|---|
| Flutter 정적 분석 | `docs/submission/culture-ai-2026/logs/flutter-analyze-2026-06-26.log` | 통과 | 런타임 실서비스 동작 증빙은 아닙니다. |
| Flutter 테스트 | `docs/submission/culture-ai-2026/logs/flutter-test-2026-06-26.log` | 143 tests 통과 | 로그 전문에는 로컬 테스트 경로가 포함됩니다. |
| 구조 preflight | `docs/submission/culture-ai-2026/logs/release-preflight-structure-2026-06-26.log` | 통과 | `--structure-only`라 env/CLI/simulator checks는 생략됩니다. |
| Flutter 장치 조회 | `docs/submission/culture-ai-2026/logs/flutter-devices-2026-06-26.log` | iOS simulator 확인 | 장치 확인일 뿐 핵심 플로우 검증은 아닙니다. |
| iOS simulator 빌드 | `docs/submission/culture-ai-2026/logs/flutter-build-ios-simulator-debug-2026-06-26.log` | 통과 | 디버그 시뮬레이터 빌드입니다. |
| iOS simulator 설치/실행 | `docs/submission/culture-ai-2026/logs/ios-simulator-install-launch-2026-06-26.log` | launch pid 반환 | 로그 파일에는 pid 한 줄만 보존되어 있으므로 핵심 플로우 실행 증빙으로 쓰지 않습니다. |
| iOS simulator 화면 | `docs/submission/culture-ai-2026/screenshots/ios-simulator-login-2026-06-26.png` | 알림 권한 팝업 화면 | 앱 UI 확인이 아니라 권한 팝업이 표시된 첫 실행 화면 수준입니다. |

## 공식 요강 조건별 증빙

| 공식 요강 조건 | dol-pin 현재 증빙 | 판정 | 부족/주의 |
|---|---|---|---|
| 접수 마감: 2026.04.27 ~ 2026.06.26 접수 | 제출 패키지 문서 생성됨 | 부분 확인 | 공식 양식 작성, PDF 변환, zip 업로드는 레포 밖 작업으로 남아 있습니다. |
| 참가 자격: 국민 누구나, 개인/팀/단체/기업, 팀 5인 이내, 중복응모 불가 | 레포 문서에는 참가자 확정 정보 없음 | owner 확인 필요 | 참가자 형태와 중복응모 여부는 신청서 작성자가 확정해야 합니다. |
| 참가 분야/부문: 신기술활용 ADX 우수사례/ADX 아이디어 | dol-pin은 AI·디지털 기술 기반 공연 문화 서비스 기획으로 정리 가능 | ADX 아이디어 적합 | 문화데이터 필수 활용 부문으로 쓰지 않습니다. |
| ADX 우수사례: 시제품 완료 또는 상용화 + 증빙자료 필수 | `flutter analyze`, `flutter test`, iOS simulator debug build, launch pid 반환, 알림 권한 팝업 스크린샷 있음 | 우수사례 제외 | 핵심 화면/영상, Gemini 실호출, 결제/반납/분쟁 실증이 부족합니다. |
| ADX 아이디어: 문화서비스 사각해소 및 국민체감형 서비스 기획 | K-pop 콘서트 물품 대여의 사기/보증금/반납/언어 장벽 문제와 AI 사진 분석 해결책을 문서화함 | 아이디어 트랙에 적합 | 실제 운영 성과가 아니라 기획/프로토타입 구조로 제한해야 합니다. |
| 제출 서류: 참가신청서, 기획서 또는 분석보고서, 참가 서약서, 개인정보 동의서 | `plan.md`, `README.md`, `demo-script.md`, `gaps.md`, 본 증빙 문서 작성됨 | 보조 자료 작성 | 공식 양식 자체와 서명본은 별도 작성해야 합니다. |
| PDF/zip 제출 형식: PDF 변환 후 1개 압축파일, 지정 파일명, 10MB 이내 | Markdown 문서와 스크린샷 파일 존재 | 미완료 | 제출 전 공식 양식 PDF 변환과 용량 점검이 필요합니다. |
| 심사 기준: 신기술 활용 1차/2차 항목 | `plan.md`가 기획성, 적합성, 차별성, 활용성, 사회적 기여도, AI 활용성 중심으로 작성됨 | 아이디어 트랙에는 사용 가능 | 우수사례의 완성도/성과 입증 문장은 과장하지 않습니다. |
| 저작권/IP/수상작 이용 조건 | 문서에서 외부 제출 표기를 `Heznpc`로 제한하고, 실명/이메일/계정 식별자 사용을 피함 | 방향 확인 | 제출용 이미지, 샘플 데이터, 상표 표현은 최종 점검 필요 |
| 실격/주의사항: 규격 미준수, 누락, 허위, 표절, 중복수상, 제출 후 수정 불가 등 | `source-pack.md`와 `gaps.md`에 과장 금지와 하향 조건 명시 | 방향 확인 | 제출 직전 공식 양식 누락/서명/파일명/중복응모 확인 필요 |

## 로컬 검증 및 우수사례 미충족 체크

| 검증/증빙 항목 | 현재 증빙 | 상태 |
|---|---|---|
| `flutter analyze` | `mise exec -- flutter analyze` 통과, `No issues found!` | 로컬 통과 |
| `flutter test` | `mise exec -- flutter test` 통과, `143 tests`, `All tests passed!` | 로컬 통과 |
| 핵심 화면 스크린샷 또는 영상 | iOS simulator 알림 권한 팝업 스크린샷만 확보 | 부족 |
| AI 사진 검증 코드 근거 | `lib/data/datasources/gemini_service.dart`, `supabase/functions/gemini-analyze/index.ts`, `test/data/repositories/gemini_edge_contract_test.dart` | 코드 파일 확인, 실호출 미검증 |
| 예약/결제/반납/분쟁 흐름 코드 근거 | `lib/features/reservation/`, `lib/data/repositories/reservation_repository.dart`, `supabase/functions/verify-payment`, `refund-payment`, `settle-reservation`, `resolve-dispute`, 상태머신/SQL 테스트 | 구조 확인, 실환경 미검증 |
| 미구현 기능 로드맵 분리 문서 | `gaps.md`, `README.md`, `demo-script.md`에서 Bluetooth, 자동 판정, 자동 정산을 로드맵/미구현으로 분리 | 문서 분리 |

로컬 통과 항목은 있으나 핵심 화면 스크린샷 또는 영상과 실환경 연동 증빙이 부족하므로, 현 시점 판정은 **DOWNGRADE: ADX 아이디어**입니다.

## 제출 문서에서 써도 되는 주장

| 주장 | 근거 |
|---|---|
| dol-pin은 K-pop 콘서트 현장 물품 대여의 사기, 보증금 분쟁, 반납 증빙, 언어 장벽 문제를 해결하려는 ADX 아이디어입니다. | 공식 ADX 아이디어 조건 + `plan.md` 문제 정의 |
| Flutter 앱은 로컬 정적 분석과 전체 테스트를 통과했습니다. | `mise exec -- flutter analyze`, `mise exec -- flutter test` 결과 |
| iOS simulator 디버그 빌드가 생성되었고 launch 명령은 pid를 반환했습니다. | `mise exec -- flutter build ios --simulator --debug`, `xcrun simctl launch` 결과 |
| Gemini 기반 사진 분석 코드와 Edge Function 구조가 있습니다. | `gemini_service.dart`, `gemini-analyze/index.ts`, Gemini contract test |
| 예약/결제/반납/분쟁 흐름의 코드 구조가 있습니다. | 예약 화면/컨트롤러/repository/Edge Functions/SQL 상태머신 |
| Supabase/Gemini/PortOne 기능은 실서비스 환경 검증과 분리해야 합니다. | 실환경 env/배포/영수증 미확보 |

## 제출 문서에서 쓰면 안 되는 주장

| 금지 주장 | 이유 |
|---|---|
| ADX 우수사례 제출 가능 | 핵심 화면/영상 및 실환경 시연 증빙이 부족합니다. |
| 시제품 구현 완료 또는 상용화 완료 | 알림 권한 팝업 화면 이상 핵심 플로우 증빙이 부족합니다. |
| 실제 결제 운영 또는 보증금 환불 운영 완료 | PortOne sandbox/production 영수증과 Edge Function 배포 로그가 없습니다. |
| Gemini가 실제 사진 검증에 성공했습니다 | 현재 문서 기준 실호출 로그/화면이 없습니다. |
| 실제 사용자 수, 거래 수, 매출, KPI가 있습니다 | 증빙이 없습니다. |
| Bluetooth 정품 인증 구현 완료 | 코드상 stub입니다. |
| 자동 반납 사진 판정 구현 완료 | 현재 구현 기능이 아닙니다. |
| 자동 대여자 정산 구현 완료 | 현재 구현 기능이 아닙니다. |

## 다음 단계

1. 공식 양식을 최신본으로 다운로드해 참가신청서, 기획서, 서약서, 개인정보 동의서를 작성합니다.
2. ADX 아이디어로 제출한다면 `plan.md` 내용을 공식 기획서 양식에 맞춰 붙여넣습니다.
3. 우수사례 관련 문장은 이번 제출 문서에서 제외하고, 향후 별도 제출 기회가 있을 때 핵심 플로우 영상과 Gemini/PortOne/Supabase 실환경 증빙을 새로 확보한 뒤 재검토합니다.
4. PDF 변환 후 공식 안내의 압축파일 형식과 10MB 제한을 확인합니다.
