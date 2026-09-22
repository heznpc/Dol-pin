# dol-pin Ops Runbook

The active clients are React Native + Expo (`apps/mobile`) and Next.js
(`apps/web`). Flutter is archived under `legacy/flutter` and is not a release target.

Current Toss rental-payment and recovery deployment/QA is described in
[QA](qa.md) and [OAuth/Toss setup](oauth-toss-setup.md). The PortOne and dispute
sections below apply to the preserved server compatibility path; they are not
connected to the current `/ops` UI.

## Local release preflight

Run the structure-only preflight in local development:

```bash
node scripts/release-preflight.mjs --structure-only
```

For a full preflight, configure client public values in
`apps/mobile/.env.local` and `apps/web/.env.local`. Configure server/operator
values from `.env.example` in `.env`, with Edge overrides in
`supabase/functions/.env`. Process environment values take precedence.

```bash
node scripts/release-preflight.mjs
```

This checks configuration and source structure, including the preserved PortOne
server functions. Actual provider approval/refund and deployment recovery still
require the runtime gates in [QA](qa.md).

The script prints variable names only. It must not print secret values.

## Supabase deployment checklist

```bash
supabase link --project-ref <project-ref>
supabase db push
supabase functions deploy toss-payment
supabase functions deploy rental-payment
supabase functions deploy rental-recovery
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

The preserved PortOne path resolves existing disputes through the
secret-gated Edge Function. This CLI operates on that compatibility contract.

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

Use the standalone RN Release app and explicitly select the simulator:

```bash
xcrun simctl list devices available
npm run ios:build -- <SIMULATOR_UDID>
npm run qa:ios -- <SIMULATOR_UDID>
```

`qa:ios` verifies five cold launches and leaves the app running on that device.
Inspect rendered UI and navigation as described in [iOS runtime](ios-runtime.md).
Do not shut down or delete simulators owned by other tasks. The archived Flutter
workspace is not part of this gate.
