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
| Firebase | _to confirm_ | _to confirm_ | 🔄 checking | Auth + Firestore for real accounts/collections |
| RevenueCat | Free up to $2.5k MTR | $0 until $2.5k/mo tracked revenue | 🔄 checking | Subscription/IAP infrastructure |
| Google Play Console | — | $25 one-time (if not already paid) | ⬜ not yet set up | Needed before any Android release |

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
