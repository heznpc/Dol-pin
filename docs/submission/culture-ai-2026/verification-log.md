# 검증 로그

작업 시각:

```text
NOW=2026-06-26 09:30 KST
NOW_DATE=2026-06-26
WINDOW_START=2026-03-28
```

최종 트랙 판정: **DOWNGRADE: ADX 아이디어**

이 문서는 제출 패키지 작성 과정에서 다시 실행한 검증 명령과 한계를 기록합니다. 최초 iOS simulator 실행 및 최초 스크린샷 생성 시점의 원본 로그 파일은 별도 보존되어 있지 않았습니다. 따라서 2026-06-26 07:57 KST 이후 실행 가능한 명령을 다시 실행하고, 원본 출력 로그를 `docs/submission/culture-ai-2026/logs/` 아래에 보존했습니다.

## 실행 명령 요약

| 항목 | 실행 명령 | 결과 | 원본 로그 파일 | 한계 |
|---|---|---|---|---|
| Flutter 정적 분석 | `mise exec -- flutter analyze` | 통과. `No issues found! (ran in 88.1s)` | `docs/submission/culture-ai-2026/logs/flutter-analyze-2026-06-26.log` | 정적 분석 통과는 런타임 실서비스 동작을 보장하지 않습니다. |
| Flutter 테스트 | `mise exec -- flutter test` | 통과. 143개 테스트, `All tests passed!` | `docs/submission/culture-ai-2026/logs/flutter-test-2026-06-26.log` | 테스트 로그에는 로컬 테스트 경로가 포함됩니다. 외부 제출 PDF에는 요약만 쓰는 편이 안전합니다. |
| Release preflight 구조 검사 | `node scripts/release-preflight.mjs --structure-only` | 통과. `release preflight: ok` | `docs/submission/culture-ai-2026/logs/release-preflight-structure-2026-06-26.log` | `--structure-only` 모드는 env, CLI, simulator checks를 생략합니다. |
| Flutter 장치 확인 | `mise exec -- flutter devices` | 부팅된 iOS simulator, macOS, Chrome 확인 | `docs/submission/culture-ai-2026/logs/flutter-devices-2026-06-26.log` | 장치 목록 확인일 뿐 핵심 앱 플로우 검증은 아닙니다. |
| iOS simulator 디버그 빌드 | `mise exec -- flutter build ios --simulator --debug` | 통과. `Built build/ios/iphonesimulator/Runner.app` | `docs/submission/culture-ai-2026/logs/flutter-build-ios-simulator-debug-2026-06-26.log` | 앱스토어 배포 빌드나 실제 기기 빌드가 아닙니다. |
| iOS simulator 설치/실행 | `xcrun simctl install booted build/ios/iphonesimulator/Runner.app` / `xcrun simctl launch booted com.dolda.dolda` | launch pid 반환. 통합 명령은 종료 코드 0으로 끝났으나 보존 로그에는 pid 한 줄만 남았습니다. | `docs/submission/culture-ai-2026/logs/ios-simulator-install-launch-2026-06-26.log` | 핵심 앱 플로우 검증이 아니라 프로세스 launch 확인입니다. |
| iOS simulator 스크린샷 | `xcrun simctl io booted screenshot docs/submission/culture-ai-2026/screenshots/ios-simulator-login-2026-06-26.png` | PNG 저장 | `docs/submission/culture-ai-2026/screenshots/ios-simulator-login-2026-06-26.png` | 앱 UI 확인이 아니라 알림 권한 팝업이 표시된 첫 실행 화면입니다. |

## 원문에 가까운 핵심 출력

### `mise exec -- flutter analyze`

```text
Analyzing dol-pin...
No issues found! (ran in 88.1s)
```

### `mise exec -- flutter test`

```text
03:56 +143: All tests passed!
```

### `node scripts/release-preflight.mjs --structure-only`

```text
[warn] structure-only mode skipped env, CLI, and simulator checks
release preflight: ok
```

### `mise exec -- flutter devices`

```text
Found 3 connected devices:
  iPad Pro 13-inch (M5) (mobile) ... ios ... simulator
  macOS (desktop) ... darwin-arm64
  Chrome (web) ... web-javascript
```

### `mise exec -- flutter build ios --simulator --debug`

```text
Building com.dolda.dolda for simulator (ios)...
Running Xcode build...
Xcode build done.                                           252.3s
✓ Built build/ios/iphonesimulator/Runner.app
```

### `xcrun simctl install` / `xcrun simctl launch`

```text
com.dolda.dolda: 8345
```

## 검증 결과 해석

현재 검증으로 말할 수 있는 것은 다음입니다.

- Flutter 정적 분석은 통과했습니다.
- Flutter 전체 테스트는 143개 기준으로 통과했습니다.
- 구조 전용 release preflight는 통과했습니다.
- iOS simulator용 디버그 빌드 산출물이 생성되었습니다.
- launch 명령은 pid를 반환했습니다.
- 화면 증빙은 앱 UI가 아니라 알림 권한 팝업이 표시된 첫 실행 화면입니다.

현재 검증으로 말하면 안 되는 것은 다음입니다.

- ADX 우수사례 제출 조건인 시제품 완료 또는 상용화가 충분히 증빙되었다는 주장
- 콘서트 선택부터 반납/분쟁까지의 핵심 플로우가 영상으로 검증되었다는 주장
- Gemini 사진 분석이 실제 환경에서 성공했다는 주장
- Supabase Edge Function이 실제 배포 환경에서 검증되었다는 주장
- PortOne 결제, 환불, 정산이 샌드박스 또는 운영 환경에서 검증되었다는 주장

## 제출 문서 반영 원칙

공식 제출 문서에는 검증 결과를 다음처럼 제한해서 씁니다.

> 로컬 검증 기준으로 Flutter 정적 분석과 전체 테스트를 통과했고, iOS simulator용 디버그 빌드 산출물 생성과 launch pid 반환까지 확인했습니다. 다만 현재 확보된 화면 증빙은 알림 권한 팝업이 표시된 첫 실행 화면 수준이며, 핵심 서비스 흐름과 외부 연동은 실환경 검증 전 단계입니다. 따라서 본 제출은 ADX 우수사례가 아니라 ADX 아이디어로 한정합니다.

## 보존된 파일

| 파일 | 용도 |
|---|---|
| `docs/submission/culture-ai-2026/logs/flutter-analyze-2026-06-26.log` | 정적 분석 원본 로그 |
| `docs/submission/culture-ai-2026/logs/flutter-test-2026-06-26.log` | 전체 테스트 원본 로그 |
| `docs/submission/culture-ai-2026/logs/release-preflight-structure-2026-06-26.log` | 구조 preflight 원본 로그 |
| `docs/submission/culture-ai-2026/logs/flutter-devices-2026-06-26.log` | Flutter 장치 조회 로그 |
| `docs/submission/culture-ai-2026/logs/flutter-build-ios-simulator-debug-2026-06-26.log` | iOS simulator 빌드 로그 |
| `docs/submission/culture-ai-2026/logs/ios-simulator-install-launch-2026-06-26.log` | iOS simulator launch pid 로그 |
| `docs/submission/culture-ai-2026/screenshots/ios-simulator-login-2026-06-26.png` | iOS simulator 알림 권한 팝업 화면 |
