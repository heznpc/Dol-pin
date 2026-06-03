# Reservation Escrow State Machine

> Status: v1 (KRW only) — 2026-05-29
>
> KRW launch only. Xendit / Stripe gateways still stubbed; their refund
> semantics differ enough (e.g. Stripe `payment_intent` vs PortOne
> `imp_uid`) that they each need their own settle-reservation handler.

## Why a state machine

The reservation row holds money in escrow: borrower paid `total_paid =
rental_fee + deposit` at `pending → paid` time. That money must reach
**one of three end states**:

1. **settled** — borrower returned the item, lender approved → deposit
   refunded to borrower, rental_fee released to lender.
2. **cancelled** — payment voided; full refund to borrower.
3. **resolved** — admin distributed the held money after a dispute
   (split arbitrarily — partial deposit forfeit, lender penalty, etc.).

A free-text `status TEXT` column with no transition validation allows
silently illegal moves (`pending → settled` skipping payment;
`returned → paid` reverting evidence; `cancelled → picked_up` doubling
the asset). Every illegal move is a real-money bug. The state machine
makes those moves a Postgres `RAISE EXCEPTION`.

## States

| State | Money held | Item location | Terminal | Who pays if it stays here |
|---|---|---|---|---|
| `pending` | borrower's card (not yet captured) | with lender | no | nobody |
| `paid` | escrow (Supabase logically; PortOne actually) | with lender | no | platform float (gradually leaking interest) |
| `picked_up` | escrow | with borrower | no | platform float |
| `returned` | escrow | with lender (claimed) | no | platform float |
| `settled` | rental_fee → lender; deposit → borrower | with lender | **yes** | — |
| `cancelled` | full refund → borrower | with lender (never moved) | **yes** | — |
| `disputed` | escrow | with borrower or lender (contested) | no | platform float + ops time |
| `resolved` | distributed per admin decision | per admin decision | **yes** | — |

## Legal transitions

| From | To | Actor | Trigger | Side effects |
|---|---|---|---|---|
| `pending` | `paid` | system | PortOne `verify-payment` returns success + amount match | `payment_provider`, `payment_id` stamped |
| `pending` | `cancelled` | borrower | borrower cancels before paying | none (no money held) |
| `paid` | `picked_up` | lender | lender confirms handover | `pickup_confirmed_at` stamped |
| `paid` | `cancelled` | borrower OR lender | mutual cancel before pickup | `refund-payment` (full) |
| `picked_up` | `returned` | borrower | borrower reports return | `return_confirmed_at` + optional `return_photo` |
| `picked_up` | `disputed` | borrower OR lender | counter-party no-show, asset damage mid-rental, etc. | none — held until `resolved` |
| `returned` | `settled` | lender | lender accepts return condition | `settle-reservation` edge function: PortOne partial cancel of `deposit` → borrower; `rental_fee` released to lender (out-of-band batch payout) |
| `returned` | `disputed` | lender | lender rejects return condition | none |
| `disputed` | `resolved` | admin (service-role) | ops decision | refund-payment partial or full, depending on decision |

Anything not in this table is illegal and rejected by the RPC.

## Actor model

The RPC distinguishes four actors:

- **borrower** — `auth.uid() = reservations.borrower_id`
- **lender** — `auth.uid() = reservations.lender_id`
- **system** — service-role key (used by `verify-payment`, `refund-payment`, `settle-reservation`)
- **admin** — service-role key + explicit `admin = true` flag in the RPC call (currently the only admin path is direct DB access; an admin console comes later)

Borrower and lender CAN call the RPC directly from the Flutter client.
System and admin transitions go through Edge Functions only.

## Why no `accepted` state

The original Dart enum had `accepted` between `pending` and `paid`.
This added a free-text-row that the lender could flip without any
money change — a confusing intermediate where the borrower thought
"the lender accepted me" but the payment intent hadn't been captured.
In v1 the model is **payment is the acceptance**: when PortOne
confirms, the lender is implicitly committed because they listed the
item with `Item.status = active`. If the lender wants to refuse a
specific borrower, they decline before payment by leaving
`pending` to `cancelled` from their side (legal transition added).

## Why no `completed` state

`completed` was ambiguous between "money settled" and "item returned".
We split them: `returned` (item back, money still held) and `settled`
(money distributed). `completed` is gone.

## Refund math

KRW is integer-only. PortOne accepts partial cancels via the `amount`
parameter on `/payments/cancel`.

| Transition | PortOne cancel `amount` | Reservation columns |
|---|---|---|
| `paid → cancelled` | `total_paid` (full) | `status='cancelled'` |
| `returned → settled` | `deposit` (deposit only) | `status='settled'` |
| `disputed → resolved` (full refund) | `total_paid` | `status='resolved'` |
| `disputed → resolved` (deposit forfeit) | `rental_fee` (rental fee back to borrower; deposit stays held → released to lender as penalty payout) | `status='resolved'` |
| `disputed → resolved` (full forfeit) | 0 (no PortOne action; lender gets everything) | `status='resolved'` |

The `rental_fee` release to the lender is **out-of-band**: PortOne does
not pay out to lenders directly; the platform batches payouts to a
lender bank account via PortOne's payout API or manual transfer. v1
does not implement the payout side — it leaves a record in the
reservation row that the platform owes the lender the rental_fee, and
relies on a separate batch job (not in this PR).

## RLS implications

Direct UPDATE on `reservations.status` from the Flutter client is now
**denied** for non-admin actors. Migration 019 adds a row-level policy
that blocks UPDATE on the `status` column, forcing all transitions
through the SECURITY DEFINER RPC.

Other columns on `reservations` (e.g. `pickup_confirmed_at`,
`return_confirmed_at`, `return_photo`) are still UPDATE-able by
participants — these are evidence-fields, not state-control fields,
and they're stamped by the RPC anyway.

## Idempotency

The RPC is idempotent on **same actor, same target state, same row**:
calling `transition_reservation_status(id, 'picked_up')` twice in a row
from the lender returns `{already: true}` on the second call. This
matches the mobile pattern where a user double-taps "confirm pickup"
and the second tap should not be an error.

It is NOT idempotent across actors — borrower can't fast-follow lender's
`picked_up` because borrower doesn't have legal authority on that
transition.

## Open questions (out of this PR)

- **Lender payout API integration** — required before `settled` can
  actually release rental_fee. Currently the row is marked `settled`
  but the rental_fee is just paper-promised to the lender.
- **Auto-transition timers** — if `picked_up` stays for > `return_date
  + 24h` with no `returned`, should the system auto-flip to
  `disputed`? Not in v1; this is a cron job that needs design.
- **Cross-currency** — Xendit / Stripe paths reuse the state machine
  structure but each needs its own `settle-reservation` and refund
  helpers.
- **Admin console** — `disputed → resolved` currently requires direct
  DB access. An ops UI is needed before launch traffic exceeds what
  one person can resolve manually.
