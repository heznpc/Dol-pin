# 거래 QA 실행

실제 로컬 Supabase Auth / PostgreSQL / Storage를 사용한다. 결제사 경계만
테스트 provider로 대체하며, 운영 코드에는 테스트 결제 URL이나 우회 플래그가 없다.
QA gateway는 `127.0.0.1:55325`, 별도 Next production server는 `127.0.0.1:3010`이다.
기존 3000번 서버와 `.next` 대신 `.next-qa` 출력을 사용한다.

```bash
npm ci
supabase start -x vector,analytics
npm run check:migrations
npm run typecheck
npm run typecheck -w @dolpin/web
npm run test:db
npm run test:edge
npm run test:recovery
npm run test:finance
npx playwright install --with-deps --no-shell chromium
npm run build:qa
npm run qa:web
```

`test:finance`는 복수 결제창, 승인 응답 유실, 기한 이후 재조회, 환불 중 인수 차단,
비공개 반납 증빙, 보증금 반환과 환불 재시도를 실제 DB에서 검증한다.
브라우저 QA는 요청 → 수락 → 결제 복귀 → 인수 → 반납 → 보증금 반환,
새 브라우저에서 결제 복구, 상품·공연 페이지네이션과 URL 필터, 상품 등록을 검증한다.
외부 카드사 인증 창은 테스트가 복귀 URL로 대체한다. 실제 카드 승인·환불 검증과 구분한다.

테스트마다 합성 계정을 만들고 종료 시 해당 계정의 데이터만 정리한다.
복구 worker 테스트도 해당 fixture의 예약만 대상으로 제한한다.
이벤트 원장은 service role에도 삭제 권한을 추가하지 않는다. 정리에는 로컬
Docker의 postgres 사용자를 사용하며 원격 Supabase URL은 거부한다.

기본 증거 경로는 `/tmp/dolpin-qa-results`이며 `DOLPIN_QA_OUTPUT`으로 바꿀 수 있다.
실패 시 screenshot / trace를 남긴다. CI는 이를 7일간 보관한다.
각 테스트는 실제 DOM 상태, 페이지 제목, console 오류, 모바일 가로 넘침을 확인한다.

외장 runtime을 쓰는 환경에서는 모든 명령에 `scripts/with-runtime.sh`를 적용한다.
`.next-qa`와 `PLAYWRIGHT_BROWSERS_PATH`, `DOLPIN_QA_OUTPUT`도 외장 디스크를 사용한다.
별도의 로컬 Supabase 프로젝트는 `DOLPIN_QA_SUPABASE_WORKDIR`와
`DOLPIN_QA_DB_CONTAINER`를 함께 설정한다. 후자는 그 프로젝트의 정확한
`supabase_db_<project_id>` 이름이어야 한다. 기존 DB의 reset은 QA에 필요하지 않다.
CI의 fresh reset은 CI가 생성한 전용 DB에서만 실행한다.

# 금융 복구 배포 조건

`rental-recovery`는 service-role bearer만 허용한다. `rental-payment`와
`toss-payment`는 각자 사용자 인증 / 거래별 capability를 검사한다.
세 함수를 배포하고 토스 서버 키와 웹 복귀 주소를 설정한 다음, Vault에
`dolpin_recovery_url`(worker 전체 HTTPS URL), `dolpin_recovery_token`(service-role token)을 넣는다.
`032_recovery_schedule.sql`은 매분 worker 호출을 등록한다. `033`은 Vault 설정이
없는 새 환경의 job을 비활성화한다. Vault 구성 후 `cron.job`의
`dolpin-reconcile-rentals` job을 `cron.alter_job(jobid, active := true)`로 활성화한다. 로컬 구성 스크립트는 활성화까지 수행한다. 작업이 실행됐는지는 `cron.job_run_details`, HTTP 전달은
`net._http_response`에서 확인한다. SQL job 성공만으로 HTTP 성공을 판정하지 않는다.

로컬에서는 Edge Functions를 먼저 serve하고 다음 명령으로 Vault를 구성할 수 있다.

```bash
node scripts/configure-local-recovery.mjs
```

토스 취소는 DB operation UUID를 멱등키로 재사용한다. 최초 발송 후 14일이 넘으면
조회만 수행한다. [토스 멱등키 유효기간](https://docs.tosspayments.com/reference/using-api/authorization)은
15일이며, 같은 작업에 새 키를 만들어 재취소하지 않는다.
PortOne V1의 결과 불명 취소는 자동 재발송하지 않고 조회로만 복구한다.
영구 오류·예상과 다른 환불액은 운영 확인 대상이며, 기간 경과로 점유를 해제하지 않는다.

기존 이력에 `027_profile_field_privileges`만 있고 토스 객체를 수동 적용한 로컬 DB는
`029_toss_checkout`이 객체를 보존하며 정식 이력을 기록한다. 028은 기존 번호를 유지한다.
배포 DB의 027이 다른 내용을 가리키면 먼저 이력을 대조해야 한다. 원격 이력을 자동 repair하지 않는다.
