# AGENTS.md — community-web

## Goal

This directory is a focused derivative of the existing dol-pin product. Preserve the connection to concerts and rentals while demonstrating a hand-wired React Streaming SSR stack.

## Invariants

- Do not replace Fastify + Vite + `react-dom/server` with Next.js, Remix, or another SSR framework.
- Keep `renderToPipeableStream` and `hydrateRoot` visible in the codebase.
- Keep server-prefetched TanStack Query state hydrated on the client; avoid an immediate duplicate initial fetch.
- Treat `/cafe/:slug` and `/cafe/:slug/posts/:id` as independently server-renderable URLs.
- Do not copy proprietary or non-public Daangn implementation details. Public `daangn/*` repositories may be used only as study references.
- Do not copy Daangn branding, logo, or exact UI. The product identity remains dol-pin.

## Product constraints

The community is derived from dol-pin, not a generic forum. Features should map to existing product context where possible:

- concerts → 공연정보 / 소식·스케줄
- rental items / reservations → 대여후기
- item verification → 응원봉 인증 challenge
- event-day coordination → 자유수다 / 현장정보

## Agent workflow

For a non-trivial change:

1. State the user or engineering problem before editing.
2. Inspect the affected route, query key, and SSR/client boundary.
3. Make the smallest coherent change.
4. Run `npm run typecheck`.
5. Run `npm run build` for changes touching SSR, hydration, Vite, or styling.
6. Verify that server and client query keys remain identical.
7. Review generated diff for hydration mismatches, browser-only APIs during SSR, and accidental client-only rendering.

## Streaming lab boundary

`ChallengeCard` currently carries an intentional 450ms lazy-load delay so the Suspense boundary can be seen in the HTML stream. Do not present this as production latency or a performance optimization. If removed, replace it with another explicit, observable streaming experiment and update README.
