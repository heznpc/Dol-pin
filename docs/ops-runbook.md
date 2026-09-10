# dol-pin Ops Runbook

This runbook covers the parts of the MVP that cannot be safely hidden behind
the Flutter client: release checks, Edge Function secrets, PortOne reconciliation,
and manual dispute resolution.

## Local release preflight

Run the structure-only preflight in local development:

```bash
node scripts/release-preflight.mjs --structure-only
```

Run the full preflight before staging or production deployment:

```bash
SUPABASE_URL="https://<project-ref>.supabase.co" \
SUPABASE_ANON_KEY="<anon-key>" \
SUPABASE_SERVICE_ROLE_KEY="<service-role-key>" \
PORTONE_IMP_CODE="<merchant-code>" \
PORTONE_IMP_KEY="<rest-api-key>" \
PORTONE_IMP_SECRET="<rest-api-secret>" \
DOLPIN_ADMIN_ACTION_KEY="<32-plus-character-random-secret>" \
SENTRY_DSN="<dsn>" \
node scripts/release-preflight.mjs
```

The script prints variable names only. It must not print secret values.

## Supabase deployment checklist

```bash
supabase link --project-ref <project-ref>
supabase db push
supabase functions deploy verify-payment
supabase functions deploy refund-payment
supabase functions deploy settle-reservation
supabase functions deploy resolve-dispute
supabase functions deploy gemini-analyze
supabase functions deploy push-notification
```

`supabase/config.toml` intentionally sets `resolve-dispute` to
`verify_jwt = false` because the operator CLI authenticates with the
`x-dolpin-admin-key` action secret instead of a user JWT. Do not remove that
setting unless the CLI is changed to send a service-role `Authorization`/`apikey`
pair as an additional gateway credential.

Set Edge Function secrets after linking the project:

```bash
supabase secrets set \
  PORTONE_IMP_KEY="<rest-api-key>" \
  PORTONE_IMP_SECRET="<rest-api-secret>" \
  DOLPIN_ADMIN_ACTION_KEY="<32-plus-character-random-secret>"
```

Supabase provides `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` to Edge
Functions. Keep app-facing `SUPABASE_ANON_KEY` separate from service-role
secrets.

## PortOne staging receipts

Before production traffic, capture receipts for these paths:

1. `pending -> paid`: successful payment, `verify-payment`, chat room returned.
2. `pending -> cancelled`: abandoned pending reservation expires without a
   bootleg payment attempt.
3. `paid -> cancelled`: full refund through `refund-payment`.
4. `returned -> settled`: deposit partial refund through `settle-reservation`.
5. `returned -> settled` with zero deposit: no provider call, state transition
   still succeeds.
6. `disputed -> resolved`: `resolve-dispute` with refund amount `0`, partial,
   and full refund.
7. Stale lock retry: `refund_pending`, `settle_pending`, and `dispute_pending`
   older than ten minutes can be retried without issuing duplicate provider
   calls.

If a PortOne cancel attempt fails with an ambiguous timeout or network error,
the Edge Function keeps the payment-action lock. Retry the same operation; the
handler must inspect provider state first and only issue another cancel when the
provider still shows no matching refund.

## Manual dispute resolution

The Flutter app opens a dispute, but operators resolve it through the
secret-gated Edge Function.

Dry run first:

```bash
SUPABASE_URL="https://<project-ref>.supabase.co" \
node scripts/resolve-dispute.mjs \
  --reservation-id "<reservation-uuid>" \
  --refund-amount 0 \
  --reason "operator decision summary" \
  --idempotency-key "dispute-<reservation-uuid>-<yyyymmdd>-01"
```

Execute only after the dry-run payload is correct:

```bash
SUPABASE_URL="https://<project-ref>.supabase.co" \
DOLPIN_ADMIN_ACTION_KEY="<32-plus-character-random-secret>" \
node scripts/resolve-dispute.mjs \
  --reservation-id "<reservation-uuid>" \
  --refund-amount 0 \
  --reason "operator decision summary" \
  --idempotency-key "dispute-<reservation-uuid>-<yyyymmdd>-01" \
  --confirm
```

Use the same `--idempotency-key` when retrying the same decision. Use a new key
only for a genuinely different operator decision.

## iOS lifecycle gate

The simulator lifecycle gate is:

```bash
IOS_OWNED_DEVICE="iPhone 17" \
/Volumes/DevStore/Harness/bin/ios-owned \
  --workspace /Users/ren/IdeaProjects/APP/dol-pin/ios/Runner.xcworkspace \
  --scheme Runner \
  --bundle-id com.dolda.dolda \
  --device "iPhone 17" \
  --action screenshot \
  --shot /tmp/dol-pin-ios-owned.png

xcrun simctl list devices | grep Booted
```

The final command must print nothing.
