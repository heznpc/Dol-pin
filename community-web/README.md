# dol-pin community web

`dol-pin`의 콘서트 물품 대여 경험에서 파생한 팬덤 커뮤니티 프로토타입입니다.

기존 Flutter 앱이 **공연에 필요한 물품을 안전하게 빌리는 문제**를 푼다면, 이 웹 앱은 공연 전후에 흩어지는 정보와 경험을 한 카페 안에서 공유하는 문제를 다룹니다.

## Product slice

현재 구현 범위는 한 아이돌 카페의 핵심 read-path에 집중합니다.

- 카페 프로필: 지역, 카테고리, 멤버 수, 게시글 수, 최근 활동
- 다가오는 공연: 기존 `dol-pin`의 `concerts` 도메인과 연결되는 정보
- 운영자 공지
- 앨범 요약
- 커스텀 게시판
  - 공지
  - 소식·스케줄
  - 공연정보
  - 직찍·직캠
  - 대여후기
  - 자유수다
- 멤버 전용 게시글 표현
- 게시글 상세 + 좋아요 hydration interaction
- dol-pin의 물품 인증 맥락에서 파생한 `응원봉 인증 7일 챌린지`

## Why this is derived from dol-pin

원본 저장소에는 이미 `concerts`, `rental_items`, 예약, 채팅, 물품 인증이라는 명확한 공연 전후 도메인이 있습니다. 커뮤니티는 이를 별도 팬카페로 복제하지 않고 다음처럼 확장합니다.

```text
concerts ─────────────→ 공연정보 / 스케줄
rental_items ─────────→ 대여후기
물품 인증 ────────────→ 응원봉 인증 챌린지
공연 현장 경험 ───────→ 직찍·직캠 / 자유수다
```

향후 실제 데이터 연결 시 Flutter 앱과 웹 커뮤니티가 같은 Supabase의 공연 ID를 기준으로 연결될 수 있도록 설계합니다.

## Stack

- React 19 + TypeScript
- Vite
- Fastify
- `react-dom/server` `renderToPipeableStream`
- `hydrateRoot`
- TanStack Query dehydration/hydration
- vanilla-extract

Next.js를 사용하지 않습니다. 프레임워크의 SSR abstraction 뒤에 숨지 않고 요청 → 데이터 prefetch → React stream → HTML 전송 → hydration의 경계를 직접 다루는 것이 이 파생 앱의 기술 목표입니다.

## Architecture

```text
Browser request
      │
      ▼
   Fastify
      │
      ├─ route parse
      ├─ QueryClient
      └─ prefetch cafe/posts
      │
      ▼
renderToPipeableStream
      │
      ├─ main cafe shell
      ├─ notices / album / feed
      └─ Suspense: challenge card
      │
      ▼
 chunked HTML response
      │
      ├─ SSR markup
      └─ dehydrated TanStack Query state
      │
      ▼
 hydrateRoot()
      │
      └─ like button becomes interactive
```

`ChallengeCard`에는 450ms의 의도적인 lab delay가 있습니다. 이 지연은 실제 제품 latency를 흉내 내려는 것이 아니라 Suspense boundary가 shell 이후 별도 chunk로 전송되는 것을 DevTools에서 쉽게 관찰하기 위한 계측 장치입니다.

## Daangn references studied

구현 방향을 잡을 때 당근이 공개한 프론트엔드 코드를 참고했습니다. 코드를 복사하지 않고 구조와 SSR 경계를 연구하는 용도입니다.

- `daangn/council` — Fastify/Vite + `renderToPipeableStream` + `hydrateRoot`
  - https://github.com/daangn/council/blob/main/api/src/app/renderer.js
  - https://github.com/daangn/council/blob/main/api/src/client/mount.ts
- `daangn/stackflow` — mobile/webview stack navigation과 SSR을 함께 고려하는 프론트엔드 구조
  - https://github.com/daangn/stackflow
- SEED Design — React/Stackflow/Vite를 아우르는 당근 공개 디자인 시스템
  - https://github.com/daangn/seed-design

## Run

```bash
cd community-web
npm install
npm run dev
```

기본 주소:

```text
http://localhost:4173/cafe/neon8-seoul
```

빌드 확인:

```bash
npm run check
npm run start
```

## Routes

```text
/cafe/neon8-seoul
/cafe/neon8-seoul?board=concert
/cafe/neon8-seoul?board=rental
/cafe/neon8-seoul/posts/lightstick-rental-review
```

게시판 이동은 현재 일반 anchor navigation으로 의도적으로 유지했습니다. 각 URL이 서버에서 독립적으로 렌더링되는 것을 확인하기 쉽고, client router를 먼저 넣어 SSR lifecycle을 가리는 것을 피하기 위해서입니다.

## Non-goals for this slice

하루짜리 파생 프로젝트에서 아래 기능은 의도적으로 구현하지 않습니다.

- 카페 개설 / 운영자 관리 화면
- 실제 인증/회원 등급
- 글쓰기 에디터
- 실시간 채팅
- 실제 이미지 업로드
- 결제/대여 transaction
- 알림
- A/B test framework

이 기능들은 원본 dol-pin이나 실제 커뮤니티 제품에서는 중요하지만, 이번 slice의 검증 대상인 **커뮤니티 read-path + React Streaming SSR**을 증명하는 데 필수적이지 않습니다.

## Next experiment

1. 기존 Supabase `concerts`를 읽어 카페 공연 카드와 연결
2. 대여 완료 reservation에서 작성 가능한 `rental review` 모델 추가
3. CSR / blocking SSR / streaming SSR의 TTFB·FCP 비교 계측
4. WebView 진입을 가정한 navigation state 보존 실험
