# dol-da (돌다) 기획서

> **Your concert, one tap away. Safe. Fast. Local.**

- Version: MVP 1.0
- Date: 2026-03
- Platform: iOS / Android (Flutter)
- Model: C2C Rental Marketplace
- Target: K-pop fans worldwide (Phase 1: Korea + Indonesia + Japan)

---

## 1. Service Overview

dol-da는 콘서트/라이브 이벤트에 필요한 물품을 팬끼리 빌려주고 빌리는 **글로벌 C2C 대여 마켓플레이스**다.

X(트위터) DM 거래의 사기 위험, 번개장터의 대여 기능 부재, 인도네시아 수작업 대여 계정의 비효율을 하나의 앱으로 해결한다. 플랫폼은 중개만 수행하며, 등록/가격/수령/반납은 사용자가 직접 한다.

### Why Now

- 콘서트 물품 대여 전용 C2C 플랫폼: **글로벌 0개**
- X.com에서 이미 수작업 대여 생태계 형성 (인도네시아, 한국, 일본, 말레이시아)
- K-pop 글로벌 투어 비중: 2019년 4% -> 2025년 7.7% (Top 100 기준)
- HYBE 단독 2025년 콘서트 매출 7,639억원, 279회 공연, 53개 도시
- Galaxy Ultra 렌탈 열풍: 스냅슛 하루 2,000명+ 이용, B2C만 존재 -> C2C 공백
- "K-pop 콘서트 스타터 키트 = 응원봉 + 렌탈 삼성폰"이 이미 공식화

### Core Value

| Safety | Convenience | Trust |
|--------|-------------|-------|
| Escrow payment | 3-tap reservation | Registered lender system |
| Identity verification | Concert-based filtering | Bi-directional reviews |
| Funds held until completion | Real-time chat | Bluetooth authenticity verification |

---

## 2. Market Analysis

### 2-1. Global Market Size

| Market | Size | Growth | Source |
|--------|------|--------|--------|
| Global Live Entertainment | $202.9B (2025) | CAGR 5.1% | MarketsandMarkets |
| K-pop Events | $14.27B (2025) | CAGR 6~8.2% | Maximize Market Research |
| Global Music Merchandise | $16.3B (2030E) | - | MIDiA Research |
| Global Fan Engagement | $7.24B (2025) -> $37.89B (2035) | CAGR 18% | Future Market Insights |
| Live Music Tickets | $41.7B (2025) | - | Statista |

### 2-2. Target Market by Region

#### Korea (Phase 1)

- 번개장터에서 이미 응원봉 대여 게시물 상시 존재 (RIIZE, NCT, ZB1, aespa 등)
- X/카카오톡 DM 대여 거래 활발, 사기 피해 다수
- 뉴시스: "콘서트 직전 팬들의 고민...응원봉 없이 가도 될까요"
- 응원봉 가격 5만원 육박, 티켓+교통비+굿즈 합산 부담 큼
- 기존 대여 인프라: 번개장터(판매 플랫폼에서 우회), X DM(사기 위험)

#### Indonesia (Phase 1)

- **dol-da의 가장 강력한 PMF 증거가 여기 있다.**
- X.com에서 전문 대여 계정 다수 운영 중 (@wonsewakpop 등)
- 그룹별 가격 표준화 완료: NCT 150k/day, ENHYPEN 200k, Blackpink 300-350k, SEVENTEEN 250-350k IDR
- 자체 신뢰 메커니즘: KTP(신분증) 사진 요구, 보증금 선입금, COD venue
- 전용 앱 없이 X DM + 수작업으로 운영 = **pre-service market**
- 인도네시아 K-pop 팬 수: 동남아 최대, 월드투어 동남아 거점

#### Japan (Phase 1)

- K-pop + J-pop 모두 응원봉(ペンライト) 문화 존재
- 아시아 최대 콘서트 시장, 연간 라이브 공연 수만 회
- #ペンライト貸し出し 해시태그로 X.com 거래 활발
- 높은 신뢰 사회 = C2C 대여에 유리한 환경

#### Global Expansion (Phase 2+)

- 북미/유럽: K-pop 투어 급성장, 응원봉 배송비/관세 부담으로 대여 수요
- 태국/필리핀: K-pop 팬덤 두터움, 가격 민감도 높아 대여 수요 큼
- Reddit r/kpop, r/kpophelp에서 "lightstick rental" 논의 지속적으로 발생

### 2-3. Blue Ocean Validation

5대 블루오션 판별 기준을 **모두 충족**하는 유일한 도메인:

| Criteria | Status |
|----------|--------|
| 1. 전용 C2C 플랫폼 글로벌 0개 | O |
| 2. VC 투자받은 스타트업 없음 | O |
| 3. 비공식 거래 이미 발생 중 | O (번개장터, X DM, 인니 대여 계정) |
| 4. 강한 바이럴 채널 존재 | O (K-pop 팬 = SNS 최강 바이럴 엔진) |
| 5. 기존 B2C 대안 불편/부재 | O (전용 서비스 없음) |

> 코스프레, 파티소품, 악기, 여행물품 등 7개 도메인을 분석한 결과, 위 5가지를 모두 충족하는 도메인은 콘서트/팬덤 물품이 유일. 패션/캠핑/촬영장비 등은 이미 수십억 달러 규모의 자본이 투입된 레드오션.

---

## 3. Pain Point & X.com Validation

### 3-1. X.com Research Results

X.com(트위터) 실제 데이터 기반으로 5대 Pain Point를 검증:

| Pain Point | Validation | Strength | dol-da Solution |
|------------|-----------|----------|-----------------|
| DM 거래 사기 위험 | 사기 경고 전용 계정(@kingky_ghost 등), 먹튀/가품 피해 다수 | **Strong** | Escrow + Identity verification |
| 응원봉 가격 부담 | BP $170, 한국 5만원 육박, 팬 커뮤니티 가격 논쟁 지속 | **Strong** | Rental model (정가의 1/5~1/10) |
| 대여 수요 이미 존재 | 인니 전문 계정, 번개장터 게시물, X DM 거래 | **Very Strong** | Automation of manual process |
| 전용 플랫폼 부재 | Pocamarket=포카, 번개장터=판매, X=DM. 대여 전용 0개 | **Strong** | Only dedicated solution |
| 가품/상태 불안 | Shopee 가품 범람, TikTok 구별법 영상 수십만 조회 | **Medium** | Bluetooth 정품 인증 + 커뮤니티 신고 |
| 응원봉 강제 업그레이드 | BTS Ver.4: 구버전 무선 호환 차단, Weverse 수 분 품절, 리셀 급등 | **Strong** | 대여로 강제 구매 부담 해소 + 정찰제 |

### 3-2. Pre-Service Market Evidence (Indonesia)

인도네시아 X.com 대여 시장은 dol-da가 자동화하려는 모든 프로세스를 이미 수작업으로 운영 중:

| Manual Process (현재) | dol-da Feature |
|-----------------------|----------------|
| X.com 프로필에 가격표 게시 | Item listing with structured pricing |
| DM으로 예약 조율 | In-app reservation system |
| KTP 사진 요구 (신분증) | Identity verification |
| 은행 이체로 보증금 선입금 | Escrow payment |
| 콘서트 venue에서 COD | Concert-based meetup coordination |
| 수동 재고 관리 (엑셀/메모) | Automated inventory & calendar |
| 분쟁 시 해결 수단 없음 | Photo comparison + dispute resolution |

---

## 4. Competitive Landscape

| Service | Type | Rental | Escrow | Concert Filter | i18n | Threat |
|---------|------|--------|--------|----------------|------|--------|
| Pocamarket | Photocard app | X | O | X | EN/KR | Low |
| Bias Room | Photocard collection | X | Partial | X | EN/KR | Low |
| Bunjang | General marketplace | Informal | O | X | KR | **Medium** |
| X (Twitter) | SNS | Informal (DM) | X | X | All | Low |
| **Snapshoot** | **Phone rental (B2C)** | **O (phone only)** | N/A (B2C) | X | KR | **Medium** |
| Forholiday/CamzRental | Phone/Camera (B2C) | O (phone only) | N/A (B2C) | X | KR | Low |
| Fat Llama/Hygglo | General P2P rental | O (general) | O | X | EN/EU | Low |
| ShareGrid/Wedio | Camera P2P rental | O (camera) | O | X | EN | Low |
| **dol-da** | **Concert C2C rental** | **O (all concert items)** | **O** | **O** | **KR/ID/JP/EN** | - |

> **dol-da vs Snapshoot**: 스냅슛은 B2C (자체 재고). dol-da는 C2C (개인 간). 가격 경쟁력 + 응원봉/장비 통합 + 콘서트 필터 = 차별화. 스냅슛이 응원봉까지 확장하기 어렵고, dol-da가 재고를 보유할 필요 없음.

> Positioning: 포카 거래 레드오션을 피하고 "콘서트 대여" 블루오션에 집중. "dol-da = the concert rental app."

---

## 5. Core Features (MVP)

> MVP Principle: Platform mediates only. Registration, pricing, pickup/return are all user-driven. Bunjang's rental version, but specialized for concerts and global.

### 5-1. Lender Registration System

물품을 올리려면 대여자 등록 필수. 일반 회원은 대여만 가능.

- **Identity Verification**: Phone number (required) + Government ID (optional, badge awarded)
  - Korea: PASS 본인인증
  - Indonesia: KTP upload + phone OTP
  - Japan: Phone OTP + optional MyNumber
  - Global: Phone OTP + optional ID
- **Profile**: Display name, fandom groups, available region, response rate
- **Grade System**: Transaction count/reviews -> Newbie -> Regular -> Power Lender

### 5-2. Item Listing & Search

**콘서트 단위 필터링이 UX 핵심.** Home에서 concert 선택 -> 해당 콘서트 관련 items만 노출.

#### Core Categories (MVP)

| Category | Examples | Avg. Rental/day | Deposit | Trust Layer | AOV |
|----------|----------|-----------------|---------|-------------|-----|
| **Lightstick** | Official lightsticks by group | KRW 5,000~8,000 / IDR 150~350k | 50~80% of retail | BT Verify | Low |
| **Phone/Camera** | Galaxy S23~S25 Ultra, iPhone Pro Max | KRW 20,000~50,000 | 30~50% of retail | IMEI Verify | **High** |

#### Expansion Categories (Phase 2+)

| Category | Examples | Avg. Rental/day | Deposit | Trust Layer |
|----------|----------|-----------------|---------|-------------|
| Lens/Accessories | Phone telephoto attach, binoculars | KRW 5,000~15,000 | Purchase price | Serial photo |
| Slogan/Banner | Fan-made slogans, banners | KRW 3,000~5,000 | Production cost | Community |
| Costume | Concert dress code outfits | KRW 5,000~10,000 | Purchase price | Community |
| Other | Portable charger, folding chair, etc. | Lender sets | Lender sets | Community |

#### Phone/Camera Category Deep Dive

이 카테고리는 dol-da의 AOV 문제를 해결하는 핵심 카테고리다.

**시장 현황 (B2C)**:
- 스냅슛: 2022년 10대로 시작 -> 현재 수백 대 보유. 하루 2,000명+ 이용
- 포홀리데이: S23U 11,800원, S24U 15,700원/일. BTS/SVT/SKZ 콘서트 때 폭발적 수요
- 동남아: 최소 12개 B2C 업체 운영 중. $50 이하 일 대여
- 삼성이 Galaxy Ultra를 "K-pop 공식폰"으로 마케팅 + 콘서트 스폰서

**C2C 기회**:
- S23U -> S25U 업그레이드한 팬의 유휴 구형 폰
- B2C 대비 저렴 (업체 마진 없음)
- 콘서트 venue에서 직거래 = 물류 문제 없음

**Category-specific Trust**:

| Trust | Lightstick | Phone/Camera |
|-------|-----------|--------------|
| Escrow | O | O |
| Identity | O | O |
| **Item Verify** | **BT 페어링** | **IMEI 등록 + 도난폰 조회** |
| Deposit ratio | 50~80% | **70~100%** (고가) |
| Pre/post photo | O | O |
| Community | O | O |

IMEI check: IMEI.info API 연동으로 등록 시 자동 도난폰 조회. 도난 이력 있으면 등록 차단.

Required fields: Item photos (min 2), category, daily price, deposit, availability, pickup method (in-person/delivery), linked concert (optional). **Phone category additional**: IMEI number (auto-verified).

**Currency**: Auto-detected by user region. Displayed in local currency (KRW, IDR, JPY, USD). Stored in base currency, converted at transaction time.

### 5-3. Reservation & Payment (Escrow)

3-step reservation UX. Escrow: lender delivers -> borrower confirms pickup -> rental fee released. Deposit returned after return confirmation.

- **Payment Methods**:
  - Korea: KakaoPay, TossPay, Card (via PortOne)
  - Indonesia: GoPay, OVO, Dana, Bank Transfer (via Xendit/Midtrans)
  - Japan: PayPay, Convenience Store, Card
  - Global: Stripe (Card, Apple Pay, Google Pay)
- **Escrow Flow**: Reserve -> Pay (rental + deposit) -> Pickup confirmed -> Rental fee released -> Return confirmed -> Deposit returned
- **Auto-cancel**: 24h no response from lender -> auto-cancel + refund

### 5-4. Real-time Chat & Push

- In-chat photo sharing, location sharing (pickup point)
- Notifications: reservation request, payment complete, pickup/return reminder, review request
- **Auto-translation**: Google Translate API for cross-language chat (KR<->EN, ID<->EN, JP<->EN). LLM translation post-MVP.

### 5-5. Review & Rating System

Both parties review after completion. Separate lender rating (item condition, response speed) and borrower rating (punctuality, item care).

### 5-6. Account & Data Management (App Store Required)

Apple App Store 가이드라인 5.1.1(v) 필수 준수:

- **계정 삭제**: 설정 > 계정 삭제 (앱 내에서 완전 삭제 가능)
- **데이터 열람/수정**: 내 정보 조회 및 수정
- **데이터 내보내기**: 내 거래 내역/리뷰 JSON 다운로드
- 삭제 시 진행 중 거래가 있으면 완료 후 삭제 예약 처리

---

## 6. Trust Architecture & AI

> 사진 기반 AI 정품 판별은 업계 전체가 실패 중 (CheckCheck: Trustpilot 2.6/5, StockX: 가품 통과 판결). dol-da는 AI에 의존하지 않는 신뢰 구조를 설계한다.

### 6-1. Trust Layer Architecture

```
Layer 1. Escrow              -- 돈을 잡고 있으니 먹튀 불가
Layer 2. Identity Verification -- KTP/PASS/신분증 실명 연동
Layer 3. Bluetooth Auth       -- 공식 앱 페어링 = 정품 뱃지 (킬러 피처)
Layer 4. Community Review/Report -- 팬이 가품을 제일 잘 안다
Layer 5. VLM Auto-tagging     -- 편의 기능 (자동 분류)
```

### 6-2. [MVP] Bluetooth Authenticity Verification

공식 K-pop 응원봉은 그룹별 공식 앱과 Bluetooth 페어링된다. 가품은 연결 불가. 콘서트 현장 페어링 부스에서 "연결 안 되면 가품" 판정한 실제 사례 확인됨.

| Group | Official App | Bluetooth |
|-------|-------------|-----------|
| BTS | BTS Official Light Stick App | O |
| BLACKPINK | BLACKPINK LIGHT STICK v2 App | O |
| Stray Kids | Stray Kids Light Stick App | O |
| IVE | IVE Official Light Stick App | O |
| SEVENTEEN | SEVENTEEN Light Stick App | O |

**Flow**: 대여자가 물품 등록 -> 앱에서 Bluetooth 페어링 테스트 유도 -> 성공 시 "Bluetooth Verified" 뱃지 자동 부여 -> 이용자에게 정품 신뢰 제공

사진 기반 AI보다 정확도가 압도적 (하드웨어 레벨 검증 ~100% vs 사진 AI 70~90%).

### 6-3. [MVP] VLM Auto-tagging

물품 사진 업로드 시 VLM API로 자동 분류. 판정이 아닌 편의 기능.

| Feature | Tech | Description |
|---------|------|-------------|
| Auto-tagging | Gemini Flash API | "BTS Ver.4 응원봉" 자동 인식 -> 유저가 확인/수정 |
| Condition assist | Gemini Flash API | 상태 참고 의견 제안 -> 대여자가 최종 선택 |
| Return comparison | Gemini Flash API | 대여 전/후 사진 비교 -> 분쟁 시 참고 자료 |

Cost: ~$0.0004/image. 월 500건 = $0.2/월.

**NOT included in MVP**: AI 기반 정품 판별 (정확도 보증 불가, 오판 시 플랫폼 신뢰 붕괴)

### 6-4. [Post-MVP] Fraud Detection

MVP uses rule-based: duplicate photo warning, suspicious pricing flag, multi-account device blocking.

### 6-5. [Post-MVP] LLM

| Feature | Description | Timeline |
|---------|-------------|----------|
| Listing assistant | Photo -> auto category/description/price suggestion | MVP (VLM) |
| FAQ chatbot | Payment/refund/guide auto-response | MVP (rule-based) |
| Dispute mediation | Chat/photo analysis -> situation summary + resolution | Post-MVP (LLM) |
| Concert recommendation | Interest-based item suggestions | Post-MVP (LLM) |
| Smart translation | Context-aware fan terminology translation | Post-MVP (LLM) |

### 6-6. Why NOT Photo-based AI Authentication

업계 사례 분석 결과:

| Service | Method | Accuracy | Problem |
|---------|--------|----------|---------|
| StockX | AI + Human + Physical | 99.95% claimed | 2025 법원에서 가품 통과 책임 판결 |
| CheckCheck | AI (CNN) + Human | Unknown | Trustpilot 2.6/5, 같은 상품 결과 매번 다름 |
| Entrupy | AI + **전용 현미경 HW** | 99.86% | 전용 하드웨어 필수 (폰 카메라 불가) |
| LegitApp | AI + Human 2명+ | High | 결국 사람이 최종 판단 |

결론: 사진만으로 AI가 정품 판별 -> 정확도 보장 불가. VLM 환각률 10~30%. dol-da에서 "AI 인증 정품" 라벨을 붙였다가 틀리면 플랫폼 신뢰가 한 방에 날아간다.

---

## 7. User Flow & UX

### Toss-style UX Principles

- **Principle 1**: One action per screen (no information overload)
- **Principle 2**: Safety UI always visible (escrow badge, verification icon)
- **Principle 3**: Concert-schedule-based home (upcoming concerts -> filtered items)
- **Principle 4**: Dark mode default (fandom app = heavy night usage)
- **Principle 5**: Language auto-detect, manual override. All UI strings externalized (ARB files)

### Borrower Flow

| Step | Screen | Description |
|------|--------|-------------|
| 1 | Home | Select upcoming concert from list |
| 2 | Explore | Filtered items for that concert. Sort by category/region/price |
| 3 | Detail | Photos, BT verified badge, condition grade, lender profile/rating, pickup method |
| 4 | Reserve | Select dates -> confirm rental fee + deposit -> pay |
| 5 | Chat | Coordinate pickup location/time with lender |
| 6 | Pickup | Receive item, tap 'Confirm Pickup' -> rental fee released to lender |
| 7 | Return | Return item, lender taps 'Confirm Return' -> deposit returned |
| 8 | Review | Bi-directional review |

### Lender Flow

Register as lender -> Upload photos -> VLM auto-tag (category suggestion) -> Bluetooth pairing test (optional, "Verified" badge) -> Set rental terms -> Publish -> Reservation notification -> Accept/Decline -> Chat coordination -> Deliver -> Receive rental fee -> Confirm return -> Deposit released

### Screen Structure

- **Home Tab**: Upcoming concert calendar + trending items + nearby items
- **Explore Tab**: Filter by concert / category / region (concert filter = top priority)
- **Register Tab**: Item registration (lender only, VLM auto-tag + BT verify)
- **Chat Tab**: Active transaction chats
- **My Page**: Profile, transaction history, rental management, settlements, settings, language, **account deletion**

---

## 8. Tech Stack

| Layer | Tech | Rationale |
|-------|------|-----------|
| Frontend | Flutter (Dart) | iOS/Android simultaneous, Hot Reload, Toss-level animation |
| State Management | Riverpod | Type-safe, testable, Flutter recommended |
| Backend | Supabase (PostgreSQL) | Realtime DB, Auth, Storage integrated. Complex queries > Firebase |
| Auth | Supabase Auth + regional ID APIs | Social login + PASS(KR) / KTP-OTP(ID) / MyNumber(JP) |
| Payment | PortOne(KR), Xendit(ID), Stripe(JP/Global) | Regional PG with escrow support. **IAP 미사용** (물리적 상품 = 면제) |
| Chat | Supabase Realtime + Firebase FCM | Real-time messaging + push notifications |
| Image Storage | Supabase Storage + CDN | Item photo upload/management |
| AI (MVP) | Gemini Flash API | VLM auto-tagging (~$0.0004/image). No training data needed |
| AI (Post-MVP) | OpenAI / Claude API | LLM chatbot/recommendation/translation |
| Auth (MVP) | Flutter Bluetooth API | Lightstick Bluetooth pairing verification |
| Auth (MVP) | IMEI.info API | Phone stolen check on item registration |
| Translation | Google Translate API | Cross-language chat. LLM upgrade later |
| i18n | Flutter ARB + intl | All UI strings externalized, locale auto-detect |
| OTA Update | Shorebird | Flutter OTA updates without app store review |
| CI/CD | GitHub Actions + Fastlane | Auto build/test/deploy |
| Monitoring | Sentry + Firebase Analytics | Crash reports + user behavior analytics |

> Architecture: Flutter <- Riverpod -> Supabase(DB/Auth/Storage) + Regional PG(Payment) + Gemini Flash(AI). Serverless, optimized for solo developer.

---

## 9. Development Structure

### 9-1. Directory Structure

```
dolda/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart                          # MaterialApp, routing, theme
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   └── api_endpoints.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── dark_theme.dart
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   ├── l10n/                         # Localization
│   │   │   ├── app_en.arb
│   │   │   ├── app_ko.arb
│   │   │   ├── app_id.arb               # Indonesian
│   │   │   └── app_ja.arb               # Japanese
│   │   ├── utils/
│   │   │   ├── formatters.dart           # Price/date format (locale-aware)
│   │   │   ├── currency.dart             # Multi-currency conversion
│   │   │   ├── validators.dart
│   │   │   └── extensions.dart
│   │   └── errors/
│   │       └── failures.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── rental_item_model.dart
│   │   │   ├── reservation_model.dart
│   │   │   ├── concert_model.dart
│   │   │   ├── review_model.dart
│   │   │   └── chat_message_model.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── rental_repository.dart
│   │   │   ├── reservation_repository.dart
│   │   │   ├── concert_repository.dart
│   │   │   ├── review_repository.dart
│   │   │   ├── chat_repository.dart
│   │   │   └── payment_repository.dart   # Multi-PG abstraction
│   │   └── datasources/
│   │       ├── supabase_client.dart
│   │       └── storage_service.dart
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── rental_provider.dart
│   │   ├── reservation_provider.dart
│   │   ├── concert_provider.dart
│   │   ├── chat_provider.dart
│   │   ├── ai_provider.dart
│   │   └── locale_provider.dart          # Language/currency state
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── signup_screen.dart
│   │   │   │   └── identity_verify_screen.dart  # Regional ID verification
│   │   │   └── widgets/
│   │   │       └── social_login_button.dart
│   │   │
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── concert_card.dart
│   │   │       ├── popular_items.dart
│   │   │       └── nearby_items.dart
│   │   │
│   │   ├── explore/
│   │   │   ├── screens/
│   │   │   │   ├── explore_screen.dart
│   │   │   │   └── item_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── concert_filter.dart
│   │   │       ├── category_chips.dart
│   │   │       └── rental_item_card.dart
│   │   │
│   │   ├── register/
│   │   │   ├── screens/
│   │   │   │   ├── register_item_screen.dart
│   │   │   │   └── lender_signup_screen.dart
│   │   │   └── widgets/
│   │   │       ├── photo_upload.dart
│   │   │       ├── ai_recognition_result.dart
│   │   │       └── condition_selector.dart
│   │   │
│   │   ├── reservation/
│   │   │   ├── screens/
│   │   │   │   ├── reservation_screen.dart
│   │   │   │   ├── payment_screen.dart    # Regional PG routing
│   │   │   │   └── escrow_status_screen.dart
│   │   │   └── widgets/
│   │   │       ├── date_picker.dart
│   │   │       ├── price_summary.dart     # Local currency display
│   │   │       └── escrow_badge.dart
│   │   │
│   │   ├── chat/
│   │   │   ├── screens/
│   │   │   │   ├── chat_list_screen.dart
│   │   │   │   └── chat_room_screen.dart
│   │   │   └── widgets/
│   │   │       ├── message_bubble.dart
│   │   │       ├── translated_message.dart  # Auto-translation indicator
│   │   │       └── location_share.dart
│   │   │
│   │   └── profile/
│   │       ├── screens/
│   │       │   ├── profile_screen.dart
│   │       │   ├── my_rentals_screen.dart
│   │       │   ├── transaction_history_screen.dart
│   │       │   ├── settings_screen.dart     # Language, currency, region
│   │       │   └── delete_account_screen.dart  # App Store required
│   │       └── widgets/
│   │           ├── lender_badge.dart
│   │           └── rating_display.dart
│   │
│   ├── ai/
│   │   ├── vlm_service.dart              # Gemini Flash API call
│   │   ├── prompts.dart                  # Recognition/comparison prompt templates
│   │   └── item_analysis_model.dart      # Response parsing model
│   │
│   ├── bluetooth/
│   │   ├── bluetooth_auth_service.dart   # Lightstick BT pairing verification
│   │   └── lightstick_app_registry.dart  # Known official app package names
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── dolda_button.dart
│       │   ├── dolda_card.dart
│       │   ├── loading_indicator.dart
│       │   ├── error_widget.dart
│       │   └── safe_badge.dart
│       └── dialogs/
│           ├── confirm_dialog.dart
│           └── report_dialog.dart
│
├── assets/
│   ├── images/
│   └── fonts/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── supabase/
│   └── migrations/
│       ├── 001_users.sql
│       ├── 002_concerts.sql
│       ├── 003_rental_items.sql
│       ├── 004_reservations.sql
│       ├── 005_reviews.sql
│       ├── 006_chat_messages.sql
│       ├── 007_fraud_flags.sql
│       └── 008_rls_policies.sql
│
├── pubspec.yaml
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── deploy.yml
└── fastlane/
    ├── Fastfile
    └── Appfile
```

### 9-2. Supabase DB Schema

```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT NOT NULL UNIQUE,
  nickname TEXT NOT NULL,
  profile_image TEXT,
  is_lender BOOLEAN DEFAULT FALSE,
  identity_verified BOOLEAN DEFAULT FALSE,
  lender_grade TEXT DEFAULT 'newbie',       -- newbie / regular / power
  fav_groups TEXT[],
  country TEXT NOT NULL,                     -- KR / ID / JP / US / ...
  region TEXT,                               -- city-level (Seoul / Jakarta / Tokyo)
  locale TEXT DEFAULT 'en',                  -- ko / id / ja / en
  currency TEXT DEFAULT 'USD',               -- KRW / IDR / JPY / USD
  response_rate DECIMAL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ                     -- soft delete (App Store required)
);

-- Concerts
CREATE TABLE concerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,                       -- "Stray Kids 5th World Tour Jakarta"
  artist TEXT NOT NULL,
  venue TEXT NOT NULL,
  city TEXT NOT NULL,                         -- Jakarta, Seoul, Tokyo
  country TEXT NOT NULL,                      -- ID, KR, JP
  concert_date DATE NOT NULL,
  poster_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Rental Items
CREATE TABLE rental_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lender_id UUID REFERENCES users(id) NOT NULL,
  concert_id UUID REFERENCES concerts(id),
  category TEXT NOT NULL,                     -- lightstick / phone / camera / slogan / costume / etc
  title TEXT NOT NULL,
  description TEXT,
  photos TEXT[] NOT NULL,                     -- min 2
  daily_price INTEGER NOT NULL,               -- in lender's local currency minor unit
  currency TEXT NOT NULL,                      -- KRW / IDR / JPY / USD
  deposit INTEGER NOT NULL,
  condition_grade TEXT,                        -- S/A/B/C (lender self-rated)
  vlm_tag TEXT,                               -- VLM auto-tag ("BTS Ver.4")
  bt_verified BOOLEAN DEFAULT FALSE,          -- Bluetooth pairing verified (lightstick)
  imei TEXT,                                   -- IMEI number (phone category)
  imei_verified BOOLEAN DEFAULT FALSE,         -- IMEI stolen check passed
  pickup_method TEXT NOT NULL,                -- direct / delivery / both
  pickup_location JSONB,                      -- {lat, lng, address, note}
  available_from DATE,
  available_to DATE,
  status TEXT DEFAULT 'active',               -- active / reserved / inactive
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Reservations (Escrow)
CREATE TABLE reservations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_id UUID REFERENCES rental_items(id) NOT NULL,
  borrower_id UUID REFERENCES users(id) NOT NULL,
  lender_id UUID REFERENCES users(id) NOT NULL,
  rental_date DATE NOT NULL,
  return_date DATE NOT NULL,
  rental_fee INTEGER NOT NULL,
  deposit INTEGER NOT NULL,
  total_paid INTEGER NOT NULL,
  currency TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  -- pending -> accepted -> paid -> picked_up -> returned -> completed
  -- pending -> rejected / cancelled / expired
  pickup_confirmed_at TIMESTAMPTZ,
  return_confirmed_at TIMESTAMPTZ,
  return_photo TEXT,                           -- VLM comparison photo
  payment_provider TEXT,                       -- portone / xendit / stripe
  payment_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Reviews
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reservation_id UUID REFERENCES reservations(id) NOT NULL,
  reviewer_id UUID REFERENCES users(id) NOT NULL,
  reviewee_id UUID REFERENCES users(id) NOT NULL,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  content TEXT,
  review_type TEXT NOT NULL,                   -- lender_review / borrower_review
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat Messages
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reservation_id UUID REFERENCES reservations(id),
  sender_id UUID REFERENCES users(id) NOT NULL,
  receiver_id UUID REFERENCES users(id) NOT NULL,
  message TEXT,
  translated_message TEXT,                     -- auto-translated text
  source_lang TEXT,                             -- ko / id / ja / en
  image_url TEXT,
  location JSONB,                              -- {lat, lng, address}
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Fraud Flags (rule-based)
CREATE TABLE fraud_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) NOT NULL,
  flag_type TEXT NOT NULL,                     -- duplicate_photo / suspicious_price / multi_account
  severity TEXT DEFAULT 'warning',             -- warning / block / ban
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Reports (App Store 1.2 required: user content moderation)
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id UUID REFERENCES users(id) NOT NULL,
  reported_user_id UUID REFERENCES users(id),
  reported_item_id UUID REFERENCES rental_items(id),
  reason TEXT NOT NULL,                        -- scam / counterfeit / inappropriate / other
  description TEXT,
  status TEXT DEFAULT 'pending',               -- pending / reviewed / resolved / dismissed
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Blocks (App Store 1.2 required)
CREATE TABLE user_blocks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blocker_id UUID REFERENCES users(id) NOT NULL,
  blocked_id UUID REFERENCES users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(blocker_id, blocked_id)
);
```

### 9-3. Key Packages (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Supabase
  supabase_flutter: ^2.5.0

  # Routing
  go_router: ^14.0.0

  # Payment (multi-region)
  iamport_flutter: ^0.10.0              # PortOne (Korea)
  # Xendit/Stripe via REST API          # Indonesia / Global

  # AI (VLM API)
  http: ^1.2.0                          # Gemini Flash API calls
  google_generative_ai: ^0.4.0          # Google AI SDK

  # Bluetooth
  flutter_blue_plus: ^1.31.0            # BT lightstick pairing verification

  # Image
  image_picker: ^1.0.0
  cached_network_image: ^3.3.0

  # UI
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  intl: ^0.19.0                         # Locale-aware formatting

  # Utility
  firebase_messaging: ^15.0.0
  geolocator: ^12.0.0
  url_launcher: ^6.2.0
  shared_preferences: ^2.2.0
  freezed_annotation: ^2.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  riverpod_generator: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  flutter_lints: ^3.0.0
```

### 9-4. Key Patterns & Rules

**Data Flow**: Screen -> Provider(Riverpod) -> Repository -> Supabase

**Naming**:
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `kPrefixCamelCase`
- Providers: `xxxProvider` (e.g., `rentalListProvider`)

**Error Handling**: All Repository methods return `AsyncValue<T>`. UI branches on error/loading/success.

**RLS**: All tables have Row Level Security. Own data only. `lender_id = auth.uid()`.

**i18n**: All user-facing strings in ARB files. No hardcoded strings. `context.l10n.xxx` pattern.

**Currency**: Stored in local currency minor units. Display converted via `CurrencyFormatter`. Exchange rates cached daily.

---

## 10. Revenue Model

### Fee Structure

| Revenue Source | Rate | Target | Description |
|----------------|------|--------|-------------|
| Transaction fee | 15~20% | Lender | Based on rental fee |
| Deposit fee | None | - | Escrow held, fully returned |
| Premium subscription | $4.99/mo | Optional | Priority listing, reduced fee (15%->10%) |
| Promotion | Per listing | Lender/Brand | Top exposure, concert-linked banners (post-MVP) |

### Revenue Simulation

카테고리 믹스: Lightstick 60% + Phone/Camera 30% + Other 10% (Phone이 AOV를 끌어올림)

**Phase 1 - Korea + Indonesia (6 months post-launch)**:
- Lightstick: 300 tx/mo x KRW 7,000 x 17.5% = KRW 367,500
- Phone/Camera: 100 tx/mo x KRW 25,000 x 17.5% = KRW 437,500
- Combined: KRW 805,000/mo + IDR revenue (~$1,100/mo total)

**Phase 2 - Asia (1 year)**:
- 3,000 tx/mo x avg $10 (phone mix raises avg) x 17.5% = $5,250/mo

**Phase 3 - Global (2 years)**:
- 15,000 tx/mo x avg $12 x 17.5% = $31,500/mo

> Phone/Camera category가 전체 AOV를 $6 -> $10~12로 끌어올린다. 거래 건수가 같아도 수익이 ~60% 증가.

> Initial priority: user acquisition over revenue. First 3 months: 0% commission event.

---

## 11. Risk & Mitigation

| Risk | Severity | Probability | Mitigation |
|------|----------|-------------|------------|
| Fraud/no-show | High | High | Escrow mandatory, identity verification, rule-based fraud detection |
| Item damage/loss | High | Medium | Deposit system, pre/post photo comparison (VLM), deposit deduction |
| Legal (per country) | Medium | Medium | KR: 통신판매중개자. ID: OJK fintech regs. JP: 特定商取引法. Consult local counsel per market |
| Cold start (per concert) | High | High | Pre-launch lender recruitment, concert-specific campaigns |
| Low AOV | High | Certain | Phone/Camera category (high AOV), bundle rentals |
| Low frequency | High | High | Category expansion (festivals, sports), off-season merch trading |
| Cross-border complexity | Medium | Medium | Phase by country, local PG per market, regional compliance |
| Phone theft/loss (high-value) | High | Medium | IMEI registration, 70~100% deposit, identity verified, auto-report stolen if not returned |
| B2C competitors (Snapshoot etc.) | Medium | Medium | C2C = lower price point, older model availability, integrated with lightstick rental (one-stop) |
| App Store rejection | Medium | Low | Compliance checklist (Section 15) adherence |

---

## 12. Go-to-Market Strategy

### 12-1. Launch Timing

2026 summer concert season. Major group tours (Stray Kids, NCT, SEVENTEEN) peak. Start campaigns 2~3 weeks before each concert.

### 12-2. Pre-launch Supply Seeding

> Solve the chicken-and-egg problem before launch.

**Korea**:
- X partner lender recruitment: "dol-da partner lender - first 50: 0% commission forever + priority listing"
- Target: Fans with 3+ lightsticks, post-fandom fans wanting to monetize, Bunjang rental posters
- Goal: 50 lenders, 200 items at launch

**Indonesia**:
- Recruit existing X.com rental account operators as power lenders
- @wonsewakpop-type accounts already have inventory + customer base
- Offer: migration support, 0% commission first 3 months, ambassador program
- Goal: 20 lenders, 100 items at launch

**Japan**:
- Target #ペンライト貸し出し community on X
- Goal: 10 lenders, 50 items at launch

### 12-3. Channel Strategy

| Channel | Market | Strategy |
|---------|--------|----------|
| X (Twitter) | All | Core channel. #dolda #concertrental. Fan account collabs, RT events |
| Instagram | All | Concert vibe content. Rental success story reels |
| TikTok | ID/Global | "I rented a lightstick for $2" format. Price comparison content |
| Reddit | EN | r/kpop, r/kpophelp. Organic posts about rental experience |
| Everytime/대학커뮤니티 | KR | College student fans, campus concert season |
| LINE OpenChat | JP | J-pop/K-pop fan communities |

### 12-4. Launch Promotions

- 0% commission for first 3 months (all markets)
- First listing: free priority exposure
- Referral: both sides get credit when invitee completes first transaction
- Concert-specific: "[Concert Name] lightstick rental event" banner
- Phone upgrade campaign: "S25U로 업그레이드했으면, S23U는 dol-da에서 빌려줘!" -> 구형 폰 공급 확보
- Bundle promotion: "응원봉 + 울트라 같이 빌리면 할인" -> AOV 극대화

---

## 13. Agency Partnership & Fixed Pricing (정찰제)

### 13-1. Problem: The Forced Upgrade Cycle

```
기획사가 만든 악순환:

1. 응원봉 정가 $35~60
2. 신버전 출시 -> 구버전 호환 차단 (BTS Ver.4: 6월부터 Ver.4만 무선 제어)
3. Weverse 수 분 만에 전량 품절
4. 네이버 스토어/리셀러에서 웃돈 (정가의 1.5~3배)
5. 가품 범람 (Shopee, Amazon)
6. 팬: "비싸서 못 사" + "품절이라 못 사" + "가품일까봐 무섭"
```

BTS Army Bomb Ver.4 사례 (2026.02):
- 정가 $35.05, Weverse 수 분 만에 품절
- 구버전 무선 호환 차단 -> "강제 업그레이드 = 현금 뜯기" 팬 대규모 반발
- 가품 Ver.5 사전예약 사기까지 등장
- 응원봉 제조 원가 상승: 반도체 칩 30%+, 배송비 3배, 제조 대기 2개월->6개월

### 13-2. dol-da + Agency Partnership Model

| Model | Description | Agency Benefit | dol-da Benefit |
|-------|-------------|----------------|----------------|
| **A. Official Rental Stock** | 기획사가 dol-da에 공식 대여용 재고 공급, 정찰 대여가 설정 | 대여 수익 분배 (현재 C2C 대여에서 기획사 수익 = 0) | 공식 재고 = 신뢰 극대화 |
| **B. Certified C2C** | 개인 간 대여를 기획사가 "공인", BT 인증 API 연동 | 대여 건당 로열티 수취, 브랜드 관리 | 공식 인증 뱃지 = 차별화 |
| **C. Venue Booth** | 콘서트 venue에서 dol-da 대여 부스 운영 허가 | 팬 만족도 향상, 굿즈 접근성 개선 | 현장 수령/반납 원스톱 |

### 13-3. Why Agencies Should Care

| Agency Pain Point | dol-da Solution |
|-------------------|-----------------|
| 구버전 강제 배제 -> 팬 반발 | "구버전은 대여로" -> 반발 완화 |
| 품절 -> 리셀/가품 범람 | 대여 옵션으로 수요 분산 |
| C2C 대여에서 기획사 수익 0원 | 대여 건당 로열티/라이선스 수취 |
| 가품 유통으로 브랜드 훼손 | BT 인증 연동으로 정품만 유통 |
| 칩 부족/제조 대기로 공급 한계 | 대여 = 기존 재고 회전율 극대화 |

### 13-4. Implementation Timeline

- **MVP (Phase 1)**: C2C 순수 개인 간 대여로 시작. 기획사 관계 없이 운영
- **Phase 2**: 거래량/유저 확보 후 기획사에 제안. 데이터(대여 건수, 유저 수, Bluetooth 인증률)로 설득
- **Phase 3**: 공식 파트너십 체결. 정찰제 도입, 공식 재고 공급, venue 부스

> 정찰제는 dol-da의 중장기 핵심 차별화 전략. MVP에서는 C2C로 시작하되, 기획사 파트너십을 위한 데이터 수집 구조를 처음부터 설계한다.

---

## 14. Expansion Roadmap

```
Phase 1 (MVP): K-pop Concert Item Rental
  Markets: Korea + Indonesia + Japan
  Categories: Lightstick (BT Verify) + Phone/Camera (IMEI Verify)
  Trust: Escrow + ID + BT/IMEI Auth + Community Review

Phase 2: Agency Partnership + Expansion
  Markets: + Thailand, Philippines, Global (EN)
  Categories: + Slogan/Banner, Costume, Festival gear
  Biz: Agency partnership proposal with data. Fixed pricing pilot.

Phase 3: Beyond K-pop + Official Channel
  Categories: + J-pop/Anime event items, EDM festival gear (LED, totems)
  Features: + Official rental stock (agency supplied), venue booth pilot
  Biz: + Merch trading (buy/sell), premium subscription

Phase 4: The Live Event Rental Platform
  Categories: + Sports fan gear (jerseys, scarves)
  Features: + LLM dispute mediation, smart recommendations
  Model: "The live event rental marketplace" with agency partnerships
```

---

## 15. App Store Compliance (Apple / Google)

### 15-1. Payment: IAP Exemption

dol-da는 **물리적 상품(응원봉, 폰, 카메라)의 대여 중개**이므로 Apple IAP를 사용하지 않는다.

| Guideline | Content | dol-da Status |
|-----------|---------|---------------|
| **3.1.3(e)** | 앱 외부에서 소비되는 물리적 상품/서비스 -> IAP 이외의 결제 수단 사용 **필수** | **적용**. PortOne/Xendit/Stripe 사용 |
| **3.1.3(d)** | 개인 간 실시간 서비스 (P2P) -> IAP 이외의 결제 수단 사용 가능 | **적용**. C2C 대여 거래 |
| **3.1.1** | 라이선스 키, QR, 암호화폐 등 자체 잠금 메커니즘 금지 | 해당 없음 |

> 번개장터, 당근마켓, 에어비앤비 등 물리적 상품/서비스 C2C 앱은 모두 외부 PG 사용 중. dol-da도 동일 구조.

### 15-2. User Generated Content (Guideline 1.2)

C2C 마켓플레이스 = UGC 앱. 다음 기능 **전부 필수**:

| Requirement | Implementation |
|-------------|---------------|
| 부적절 콘텐츠 필터링 | 사진 업로드 시 기본 moderation + VLM 태깅 |
| **신고 기능** | 물품/사용자/채팅 신고 (reason 선택 + 설명) |
| **차단 기능** | 사용자 차단 -> 해당 유저의 물품/채팅 숨김 |
| **적시 대응** | 신고 접수 24시간 내 검토 (운영 대시보드) |
| **개발자 연락처** | 앱 내 고객센터 이메일 + FAQ 상시 노출 |

### 15-3. Privacy & Data (Guideline 5.1.1)

| Requirement | Implementation |
|-------------|---------------|
| **(i) 개인정보 처리방침** | 앱 내 + App Store Connect 링크. 4개 언어 |
| **(ii) 데이터 수집 동의** | Bluetooth/위치/카메라 각각 명시적 권한 요청 |
| **(iii) 데이터 최소화** | BT = 정품 인증만, 위치 = 수령 조율만, 카메라 = 사진 촬영만 |
| **(v) 계정 삭제** | 설정 > 계정 삭제. 진행 중 거래 있으면 완료 후 삭제 예약 |
| **(ix) 법인 제출** | 금융 거래(에스크로) 포함 -> **법인 계정으로 제출 권장** |

### 15-4. Bluetooth Data (Guideline 5.1.2)

- BT 기기 데이터는 정품 인증 목적으로만 사용
- 개인정보 처리방침에 BT 데이터 수집 범위/목적 명시
- 마케팅/광고/데이터마이닝 목적 사용 금지

### 15-5. Push Notifications (Guideline 4.5.4)

- 푸시는 앱 필수 요건이 아님 (거부 가능)
- 거래 상태 알림, 채팅 알림 등 기능적 용도만 사용
- 개인정보(전화번호, 주소) 푸시로 전송 금지

### 15-6. Login & Authentication (Guideline 4.8)

- Apple Login 필수 제공 (Sign in with Apple)
- Google Login 제공 시 Apple Login도 동등하게 제공
- 로그인 없이 앱 둘러보기 가능 (탐색은 비회원 허용, 거래 시 로그인 요구)

### 15-7. App Review Submission Checklist

심사 제출 시 준비 사항:

```
[ ] 개인정보 처리방침 (4개 언어, App Store Connect + 앱 내)
[ ] 이용약관 (에스크로 정책, 분쟁 해결 절차, 환불 정책)
[ ] 고객 지원 연락처 (이메일, FAQ)
[ ] 테스트 계정 2개 (lender + borrower, 심사 메모에 기재)
[ ] 테스트용 물품 등록 (BT 인증 시뮬레이션 포함)
[ ] 결제 테스트 모드 (sandbox/test key 적용)
[ ] 신고/차단 기능 작동 확인
[ ] 계정 삭제 기능 작동 확인
[ ] 심사 메모: 에스크로 시스템, BT 인증, 외부 PG 사용 근거 상세 기술
[ ] 스크린샷: 에스크로 뱃지, 신원 인증, 신고 기능 포함
[ ] 연령 등급: 12+ (신원 정보 수집)
[ ] 법인 개발자 계정으로 제출
```

### 15-8. Regional Legal Compliance

| Region | Key Regulation | dol-da Obligation |
|--------|---------------|-------------------|
| Korea | 전자상거래법, 통신판매중개자 | 통신판매중개자 신고. 에스크로 의무 (이미 적용) |
| Korea | 개인정보보호법 | 개인정보 처리방침, 동의, 삭제 기능 |
| Indonesia | OJK Fintech Regulations | 에스크로/결제 관련 규제 확인 필요 |
| Indonesia | PP 71/2019 (전자시스템) | 개인정보 수집/처리 규제 |
| Japan | 特定商取引法 | 통신판매 표시 의무 (사업자 정보 공개) |
| Japan | 個人情報保護法 | 개인정보 취급 방침, 제3자 제공 동의 |
| Global | GDPR (EU users) | Phase 2+ 유럽 진출 시 대응. 데이터 이동권, 삭제권 |
| Global | COPPA (US, under 13) | 13세 미만 가입 제한 (이미 본인인증으로 필터) |

---

## 16. Structural Challenges & Responses

P2P 대여의 구조적 문제 (TechCrunch, 2015 -> 2026년에도 유효):

| Challenge | dol-da Response |
|-----------|----------------|
| **Low AOV** ($5~$10 per rental) | Phone/Camera category (AOV 3~6x). Galaxy Ultra C2C = $15~35/day. Bundle "lightstick + phone" rental. |
| **Low frequency** (event-driven) | Multi-category expansion. Off-season merch trading. Global = always some concert somewhere. |
| **Supplier attrition** ("not worth the hassle") | Non-monetary motivation: fandom pride, lender badges, community reputation. Power lender perks. |
| **Double logistics** (deliver + return) | In-person meetup at venue (COD). Concert-based matching = same place, same time. |
| **"Airbnb works because suppliers make a living"** | dol-da suppliers don't need living income. Fandom = intrinsic motivation. Camera gear lenders can earn meaningful side income. |
| **Forced upgrade = resale markup** | Agency partnership (정찰제) -> official rental stock at fixed price. Cuts resellers out. |
| **Counterfeit risk** | Bluetooth auth (not photo AI). Hardware-level verification ~100% accuracy. Industry-unique advantage. |

---

## 17. Success Probability & Cost Estimation

### 17-1. Success Probability

#### Base Rate

| Benchmark | Failure Rate | Source |
|-----------|-------------|--------|
| All startups | ~90% | CB Insights |
| E-commerce / Marketplace | ~80% | Failory |
| C2C Rental Marketplace | ~90%+ | TechCrunch |

#### dol-da Upward Adjustments

| Factor | Multiplier | Rationale |
|--------|-----------|-----------|
| Pre-service market exists | x2~3 | 인도네시아 X.com 대여 계정이 이미 수작업 운영 중 |
| Zero global competitors | x1.5 | 전용 C2C 콘서트 대여 앱 = 지구상 0개 |
| Dev cost ~$0 | x2 | Claude 구현 -> 외주 $15K~$40K 절약. 런웨이 사실상 무한 |
| Fandom viral | x1.5 | K-pop 팬 = SNS 최강 바이럴 엔진 |
| Niche-first strategy | x1.3 | ThredUP(아동복->전체 의류), Poshmark(여성 패션->전체) 등 검증 |
| BT auth = moat | x1.2 | 하드웨어 레벨 정품 인증. 타 플랫폼 모방 어려움 |

#### dol-da Downward Adjustments

| Factor | Multiplier | Rationale |
|--------|-----------|-----------|
| Structural Low AOV | x0.5 | 응원봉 건당 $5~8. Phone 포함해도 평균 $10~12 |
| Per-concert cold start | x0.6 | 매 콘서트마다 수요-공급 매칭 반복 필요 |
| Event-driven frequency | x0.7 | 1인당 연 2~4회 콘서트. 일상적 사용 아님 |
| Solo developer limits | x0.7 | 3개국 PG, i18n 4개 언어, 법률 컴플라이언스 |
| Long PMF timeline | x0.8 | 니치 마켓플레이스 PMF 평균 18~22개월 |

#### Adjusted Probability

```
Base rate:               10%
Upward:  x2 x1.5 x2 x1.5 x1.3 x1.2 = x14.04
Downward: x0.5 x0.6 x0.7 x0.7 x0.8  = x0.1176
Adjusted: 10% x 14.04 x 0.1176       = ~16.5%
```

| Scenario | Probability | Definition |
|----------|------------|------------|
| Optimistic | ~25% | PMF + $10K+/mo revenue within 2 years |
| Realistic | ~15~17% | PMF + self-sustaining revenue in 2~3 years |
| Pessimistic | ~8% | Niche community app, small-scale survival |
| Failure | ~50~60% | Cold start unsolved, growth stalls, shutdown |

> **핵심 변수**: 인도네시아 X.com 대여 계정 전환 성공 여부. 성공하면 확률 30%+.

### 17-2. Cost Breakdown

#### Development Cost

| Item | Agency Cost | Claude Build | Note |
|------|------------|-------------|------|
| Flutter MVP | $15,000~$40,000 | **$0** | 3~6 months |
| UI/UX Design | $3,000~$8,000 | $0~$500 | Figma templates + Claude |
| **Total** | **$18,000~$48,000** | **$0~$500** | |

#### Monthly Infrastructure

| Item | Free Tier | Paid Trigger | Paid Cost |
|------|-----------|-------------|-----------|
| Supabase | 500MB, 50K MAU | ~5,000 MAU | $25/mo (Pro) |
| Firebase FCM | Unlimited push | - | $0 |
| Gemini Flash API | Free tier | 500+ items/mo | ~$0.20/mo |
| Apple Developer | - | Pre-launch | $99/yr ($8.25/mo) |
| Google Play | - | Pre-launch | $25 one-time |
| Domain | - | Pre-launch | ~$12/yr ($1/mo) |
| Sentry | 5K events | Scale | $26/mo (Team) |
| **Monthly total (early)** | | | **~$10/mo** |
| **Monthly total (growth)** | | | **~$60/mo** |

#### Variable Costs (per transaction volume)

| Item | Unit Cost | 500 tx/mo | 3,000 tx/mo |
|------|----------|-----------|-------------|
| PG fees | 2.5~3.5% | Deducted from commission | Same |
| IMEI.info API | ~$0.01/call | $1.5 | $9 |
| Google Translate API | $20/1M chars | ~$2 | ~$12 |
| Supabase Storage | $0.021/GB | ~$0.5 | ~$3 |
| **Variable total** | | **~$4/mo** | **~$24/mo** |

#### Marketing

| Item | Cost | Strategy |
|------|------|----------|
| Paid ads | $0 (early) | Fandom viral, organic X/TikTok |
| Influencer | $0~$200/mo | Fan account collabs, barter deals |
| 0% commission event | Opportunity cost only | 3 months free -> user acquisition |
| **Marketing total (early)** | **$0~$200/mo** | |

#### Legal & Admin

| Item | Cost | Timing |
|------|------|--------|
| Business registration (KR) | Free | Pre-launch |
| 통신판매업 신고 | Free | Pre-launch |
| Privacy policy / ToS | $0 (template) ~ $500 (lawyer) | Pre-launch |
| Indonesia entity/agent | $500~$2,000 | Phase 1 launch |
| Japan 特定商取引法 | $300~$1,000 | Phase 1 launch |

#### 12-Month Total

| Phase | Duration | Total Cost | Monthly Avg |
|-------|----------|-----------|-------------|
| MVP Development | 3~4 months | $125~$625 | ~$150/mo |
| Launch (KR+ID) | +3 months | $500~$2,500 | ~$500/mo (legal included) |
| Operation (growth) | 6~18 months | $60~$300/mo | ~$150/mo |
| **12-month total** | | **$2,000~$5,000** | |

> Claude 구현으로 인건비 $0. 인프라는 Free Tier로 커버. **12개월 총 비용 $2,000~$5,000**. 외주 대비 1/10.

### 17-3. Break-Even Point

```
Monthly fixed cost:      ~$150 (growth phase)
Net revenue per tx:      avg $10 x 17.5% = $1.75, minus PG fee = ~$1.40
BEP transaction count:   $150 / $1.40 = ~107 tx/mo

= 3.6 tx/day
= 5~7 tx on concert weekends (2~3 days/week)
```

서울+자카르타 주요 콘서트 2~3개가 겹치면 월 100건 달성 가능.

### 17-4. Verdict

```
Investment:     ~$3,000 (12 months)
Success rate:   ~15~17%
Upside:         $30K~$380K annual revenue if successful
Downside:       $3~5K loss if failed
Risk profile:   Asymmetric bet (low downside, high upside)
```

| Criterion | Result |
|-----------|--------|
| Financial risk | Very low. Max $3~5K loss |
| Time risk | Medium. 6~12 months commitment |
| Expected value | Positive. Low probability but tiny downside, large upside |
| Learning value | High. Flutter/Supabase/PG/i18n production experience |
| **Worth building?** | **Yes. Asymmetric bet.** |

---

> **dol-da's key is execution speed.** A clear niche (concert rental) + Bluetooth verification + escrow trust + K-pop fandom viral engine. Ship MVP fast, iterate on user feedback. The Indonesian pre-service market proves demand exists -- now automate it. Agency partnership (정찰제) is the mid-term moat.
