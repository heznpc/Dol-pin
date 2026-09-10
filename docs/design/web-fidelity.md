# Consumer web visual check

Reference: `web-reference.png`. Render: `../verification/web-products.png`.
Both opened with view_image. Browser: Codex in-app browser, production Next.js.

| Check | Result / deliberate difference |
| --- | --- |
| Palette | Existing mobile background/surface/purple tokens retained |
| Hierarchy | Brand → concert-equipment heading → search/filter → products |
| Layout | Desktop left filters with product grid; narrow viewport uses two-column category choices |
| Product imagery | Actual uploaded synthetic fixture asset; no invented inventory to match reference count |
| Typography | Korean labels, price and deposit readable; native browser text throughout |
| Copy | Required heading/search/category labels preserved; unavailable transaction navigation deferred |
| Interaction | Search, filter, detail/back, OTP, upload and create exercised against local Supabase |

The reference is a design direction, not proof of implemented inventory or final
transaction UX. Three visible records were created through API, RN and web tests.
Final transaction screens and fuller product authoring remain subsequent slices.
