# Coinsights — costs & external accounts ledger

Living record of every paid/free-tier external service the app depends on,
and what's configured where. Updated as things change — check this before
assuming a service is (or isn't) wired up.

## Accounts in use

| Service | Plan | Cost | Status | Notes |
|---|---|---|---|---|
| Apple Developer Program | Individual/Org | $99/yr (already active — app exists in ASC) | ✅ active | Needed for TestFlight/App Store |
| Codemagic | Free tier (500 build min/mo) | $0 so far | ✅ active | `ios-release`, `ios-workflow`, `android-workflow` workflows |
| GitHub | Free | $0 | ✅ active | `github.com/cognizeapp/CoinLens` (rename to Coinsights still pending) |
| Firebase | Spark (free) | $0 | ✅ active | Project `coinsights-eabc4`; Auth (email/Google/Apple) wired into the app |
| RevenueCat | Free up to $2.5k MTR | $0 until $2.5k/mo tracked revenue | ✅ active (iOS) | `default` offering → real App Store products `coinsights_premium_monthly`/`coinsights_premium_yearly`, both attached to the `premium` entitlement. Android side still points at placeholder Test Store products — Play Console subscriptions not created yet. |
| App Store Connect subscriptions | — | — | ✅ active | Group "Coinsights Premium": Premium Monthly (€4.99/mo) + Premium Yearly (€29.99/yr, 7-day free trial, all 175 regions). First auto-renewable subscription still needs to be submitted together with an app version before it goes live in production — TestFlight builds are unaffected by this. |
| Google Play Console | — | $25 one-time (if not already paid) | ⬜ not yet set up | Needed before any Android release; Android subscription products (monthly/yearly) not created yet, so RevenueCat's Play Store product list is still empty |

## Recurring cost triggers to watch

- **Firebase Blaze plan**: only needed if we use Cloud Functions, heavy Firestore
  reads, or Storage beyond the free Spark tier. Staying on Spark unless a
  feature explicitly requires it — will flag before switching.
- **RevenueCat**: free until $2,500/month tracked revenue, then a % fee kicks
  in. Nothing to do until the app is actually making money.
- **Codemagic**: 500 free build minutes/month on the free tier; an iOS release
  build (~5 min) + Android build (~3 min) ≈ 8 min per full CI run. Watch usage
  if builds get frequent.
- **Apple Developer**: $99/yr renewal — already paid for the current cycle
  (check App Store Connect → Membership for the renewal date).

## Change log

- 2026-09-04: File created. Beginning real Firebase Auth (Google/Apple
  Sign-In) + RevenueCat subscription integration, replacing the mock
  services used through Phase 1–8.
- 2026-09-04: Created "Premium Monthly" (€4.99/mo) and localized "Premium
  Yearly" (€29.99/yr) subscriptions in App Store Connect, added a 7-day
  free trial intro offer on Yearly (all regions), created matching products
  in RevenueCat, attached both to the `premium` entitlement, and wired them
  into the `default` offering's Monthly/Yearly packages. Android/Play Store
  side still pending.
