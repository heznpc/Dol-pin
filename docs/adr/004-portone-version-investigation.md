# ADR 004 — PortOne version investigation

Status: investigation; migration not approved by this ADR. 2026-09-09.

## Decision rule

Preserve V1 unless V2 offers a demonstrated benefit for this product that
outweighs migration and verification cost. Recency alone is not a reason.
Backend operation identity and reconciliation are required with either version.

## Evidence

| Dimension | Existing V1 | V2 | Implication |
| --- | --- | --- | --- |
| Repository | `_shared/portone.ts` calls `api.iamport.kr`; verify/refund/settle/dispute paths exist | No implementation | V1 has meaningful reuse value |
| Identity | merchant_uid / imp_uid; caller currently generates attempt ID | Different request/response contract | Shared DTO must not pretend these identifiers are interchangeable |
| Retry | Current DB pending action and provider re-query; generic operation idempotency is incomplete | API documents idempotency keys for retries | V2 mechanism is useful but does not make PG + DB atomic |
| Webhooks | V1 supports webhooks; repo has no dedicated verified webhook handler | V2 supports payment webhooks | Callback-independent verification must be implemented either way |
| RN | `iamport-react-native` 3.0.3 exists; React/RN/WebView peers | `@portone/react-native-sdk` 0.7.0; React/RN/browser SDK/WebView peers | RN rewrite alone does not force V2 |
| Expo runtime | Development build/payment-app return not verified | Development build/payment-app return not verified | Package presence is not runtime compatibility proof |
| Account/channel | Existing code defaults to html5_inicis; actual test channel unknown | Configured channel and compatibility unknown | Do not migrate account configuration based on assumptions |
| Cost | Harden existing adapter and add per-operation recovery | New credentials/config, client SDK, adapter and reconciliation mapping | Compare with a working payment spike before deciding |

The versions above were queried from npm on 2026-09-09; they are observations,
not installation instructions or a promise of compatibility.

## Interim implementation boundary

- Keep current V1 code intact while building the frontend foundation.
- Do not install both payment SDKs into production applications.
- Run one payment capability spike using available test-channel configuration.
- Final ADR must record chosen version, identifiers, refund correlation,
  retry semantics, webhook authentication/re-query, and native return evidence.
- Until then, provider-backed payment completion is UNKNOWN.

## Sources

- [Existing V1 API](https://developers.portone.io/api/rest-v1/overview?v=v1)
- [V1 RN SDK](https://github.com/portone-io/iamport-react-native)
- [V2 RN SDK](https://github.com/portone-io/react-native-sdk)
- [V2 API / idempotency](https://developers.portone.io/api/rest-v2/overview)
- [V1 webhook guide](https://help.portone.io/content/content200004)
