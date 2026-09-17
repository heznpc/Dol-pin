# iOS 로컬 실행과 크래시 회귀 검사

실행 기본값은 Expo Go가 아닌 **돌핀 전용 Release 시뮬레이터 앱**이다.
`app.dolpin.preview`는 로컬 검증용 식별자이며 기존 Flutter 앱과 별도로 설치된다.
App Store 등록이나 배포 서명은 수행하지 않는다.

```bash
npm ci
xcrun simctl list devices available
npm run ios:build -- <SIMULATOR_UDID>
npm run ios:open -- <SIMULATOR_UDID>
npm run qa:ios -- <SIMULATOR_UDID>
```

Xcode CLI와 CocoaPods가 필요하다. 최초 빌드는 React Native 및 Expo 네이티브
의존성을 내려받으므로 시간이 걸린다. `ios:build`는 Expo prebuild, CocoaPods,
Release simulator 빌드를 순서대로 수행한다. 생성된 `apps/mobile/ios`는 추적하지
않으며 설정의 원본은 `apps/mobile/app.json`이다. Flutter의 네이티브 프로젝트는 `legacy/flutter/ios/`에 보관하며 사용하지 않는다.
CocoaPods는 반드시 생성된 iOS 디렉터리를 작업 경로로 사용한다.
Pod 설치 중 호스트 바이너리를 만드는 스크립트에도 선택된 Xcode의 macOS SDK를
명시한다. 별도로 설치된 Command Line Tools SDK가 더 새로워도 링커와 섞이지 않는다.
시뮬레이터 서명은 Xcode의 ad-hoc 서명을 사용한다. `CODE_SIGNING_ALLOWED=NO`로
끄면 SecureStore에 필요한 시뮬레이터 entitlement도 빠져 키체인 접근이 실패한다.
앱에 배포용 entitlement를 수동 재서명하는 대신 Xcode의 생성 절차를 유지한다.

앱은 JS 번들을 내장한다. 실행할 때 Metro나 Expo Go가 필요하지 않으며,
소스 변경을 반영하려면 `ios:build`를 다시 실행해야 한다. Supabase 연결은
빌드 시 `apps/mobile/.env.local`의 공개 URL/anon key를 사용하므로 해당 backend는
실행 중이어야 한다. 시뮬레이터는 Mac의 loopback 주소에 접근할 수 있다.

빌드 출력은 `DOLPIN_IOS_BUILD_ROOT`, 또는 `DOLPIN_RUNTIME_ROOT/dolpin-ios-preview`
(미설정 시 시스템 임시 디렉터리)이다. 외장 runtime 환경 예시:

```bash
DOLPIN_RUNTIME_ROOT=/Volumes/SSD/dol-pin-runtime \
CP_HOME_DIR=/Volumes/SSD/dol-pin-runtime/cocoapods \
bash scripts/with-runtime.sh npm run ios:build -- <SIMULATOR_UDID>

DOLPIN_RUNTIME_ROOT=/Volumes/SSD/dol-pin-runtime \
bash scripts/with-runtime.sh npm run qa:ios -- <SIMULATOR_UDID>
```

`qa:ios`는 지정한 기기에만 설치하고 5회 프로세스를 재시작한다. 매회 20초 동안
프로세스 생존과 실행 파일 정체성을 확인한다.
딥링크는 iOS의 앱 열기 확인창이 개입할 수 있으므로 UI 조작과 함께 별도 검증한다.
중간에 종료되면 실패하며 마지막 앱은 켜 둔다. 기기를 삭제하거나 초기화하지 않는다.
이는 시작 안정성 검사이고 화면·거래 동작 검증을 대체하지 않는다.
브라우저 금융 QA 및 네이티브 수동 UI 검증과 함께 사용한다.

## 2026-09-10 크래시 조사

Expo Go 57.0.9 / iOS 26.3 Simulator / macOS 27.0 환경에서 두 건을 확인했다.
둘 다 `EXC_BAD_ACCESS / SIGSEGV`이며 `ExpoGoReactNativeFactory` →
`AppContext.registerNativeModules` → `ModuleRegistry.register` 경로에서 발생했다.

- 첫 번째: `AudioModule.definition` → `EXPermissionsService.registerRequesters` → `objc_retain`.
- 두 번째: `EventListener.init` → `NotificationCenterManager.addDelegate` → Swift 배열 해제.

크래시 스레드 이름은 JavaScript이지만, 실제 장애 지점은 네이티브 모듈 초기화다.
두 보고서 모두 복수의 React JavaScript 스레드에서 네이티브 모듈 등록이 동시에 진행 중이었다.
정확한 메모리 경합 조건까지 확정하지는 않는다. 돌핀에 필요하지 않은
모듈까지 포함한 Expo Go 실행 환경을 제거하고, 프로젝트의 의존성으로 생성한
단독 앱을 검증 대상으로 삼는다. Expo Go 내부 바이너리를 수정한 것은 아니다.

근거: 로컬 Apple crash report의 위 스택과
[Expo 공식 로컬 빌드 안내](https://docs.expo.dev/guides/local-app-development/).

선택한 Xcode의 기본 런타임이 설치되어 있지 않으면 빌드 대상이 전부 거부될 수 있다.
`ios:build`에 기기 UDID를 넘기면 그 기기의 설치된 런타임을 빌드 동안 사용하도록
`simctl runtime match`를 설정하고, 성공·실패 후 기존 override를 복원한다.
이 옵션은 새 런타임을 내려받거나 기기를 초기화하지 않는다.

## 검증 결과 (2026-09-10)

- Xcode 26.6 / iOS SDK 26.5.1 Release 시뮬레이터 빌드 성공, ad-hoc 서명 검증 통과.
- 기존 iPhone 17e / iOS 26.3.1에서 최종 빌드 5회 연속 시작, 각 20초 생존 검사 통과.
- Metro 및 Expo Go 없이 실제 로컬 Supabase 상품 목록 로딩, 상품 상세와 계정 화면 이동 확인.
- 최초 무서명 빌드에서 발견한 SecureStore entitlement 오류는 Xcode 시뮬레이터 서명으로 해소.
- 최종 검사 후 앱 프로세스 생존과 상품 목록 표시 확인; 새 dolpin crash report 없음.
- 딥링크 복귀·소셜 로그인·실기기·실제 결제의 검증 결과로 확대 해석하지 않는다.
