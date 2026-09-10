# Backend operations and verification

Migrations 034–038 add query indexes, recovery operations and AI quotas. Apply migrations before deploying the updated Edge Functions. Existing checkout capabilities, PortOne paths and financial holds remain compatible.

## Payment recovery

Configure `dolpin_recovery_url` and `dolpin_recovery_token` in Supabase Vault, and enable the `dolpin-reconcile-rentals` cron job after deploying `rental-recovery`. Local setup uses `node scripts/configure-local-recovery.mjs` after starting `supabase functions serve`. Never put the service token in a client bundle.

The worker handles at most four checkouts and four money operations per minute. Each provider fetch has a 15-second timeout. Transient failures persist a safe error code and back off from 30 seconds to one hour. Scheduling uses the database clock. Eight failed attempts require operator review. An unexpected payment identity/refund amount, an expired refund idempotency window, or an unresolved checkout more than 24 hours past its payment deadline also requires review.

`review_required_at` does **not** replace the financial `pending` status or clear the reservation hold. A PortOne request with an unknown dispatch outcome is never sent again automatically. A reviewed job is excluded from automatic processing.

Run `npm run ops:recovery -- --check` from an operator environment. With no explicit credentials it inspects local Supabase. For a hosted project, inject `DOLPIN_OPS_URL` and `DOLPIN_OPS_SERVICE_KEY` through the operator environment. The command exits nonzero for missing configuration, an inactive schedule, stale/failed delivery, or review work. Connect this exit status to the deployment health check or existing monitoring runner; no external notification destination is configured by this repository.

The restricted `rental_recovery_queue` view exposes identifiers, attempt counts, due times and error codes. Provider bodies and credentials are not persisted. After investigating the provider record, resume one job with:

```sh
npm run ops:recovery -- --retry money:OPERATION_UUID
npm run ops:recovery -- --retry checkout:ORDER_ID
```

Retry resumes lookup/reconciliation. It does not assert success, remove holds, erase dispatch timestamps, or create a new idempotency key. If the provider still cannot establish the outcome, the job requires review again. `rental_recovery_health()` reports schedule/delivery health; the last HTTP response comes from pg_net's short-lived response cache. Dispatch IDs are retained for seven days.

## Error contract

All Edge responses with an error status contain `code`, a safe Korean `error` message, `retryable`, and `requestId`. `X-Request-Id` matches the body. Rate limits also return `retryAfter` and `Retry-After`. Permission failures use 403, state conflicts 409, provider failures 502, unavailable service 503 and timeouts 504. Unknown exceptions use 500. Legacy reconciliation booleans are preserved; raw exception/debug fields are not returned.

## AI budget

`GEMINI_MODEL` defaults to `gemini-3.6-flash`, the [documented replacement for the retired Gemini 2.0 Flash](https://ai.google.dev/gemini-api/docs/deprecations). Set `GEMINI_API_KEY` only on the server; it is sent in a header, not a URL. An empty analysis response is treated as a provider error.

`gemini-analyze` reserves quota in PostgreSQL before invoking Gemini. Default limits are **3 calls per 60-second account window and 30 per UTC day**. Service operators can change `api_usage_limits`; clients cannot read or mutate counters or invoke the quota RPC. The counter row is locked while checking/incrementing both budgets, so multiple Edge instances share the limit. Invalid requests consume no quota; provider failures consume quota. A quota-service failure fails closed. The request stream is bounded before JSON decoding.

## Query performance

Active-item indexes match chronological pagination, category and concert filters. Participant indexes support ordered reservation lists. A partial pg_trgm GIN index preserves existing `ILIKE '%term%'` search semantics. It is most useful for selective searches with extractable trigrams; one/two-character terms and very common terms may still scan. No minimum search length is imposed. See [PostgreSQL pg_trgm documentation](https://www.postgresql.org/docs/17/pgtrgm.html).

`supabase/tests` verifies database authority. `npm run test:edge` covers safe error contracts and quota gating. `npm run test:finance` uses real local Auth/DB/Storage and a provider fixture to verify concurrent budgets, backoff, escalation, manual retry and financial hold preservation. These do not establish production capacity or real-provider availability.
