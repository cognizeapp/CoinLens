# Coinsight

**Discover what your coins are really worth.** Scan. Identify. Discover value.

A cross-platform (iOS + Android) Flutter app that identifies coins from photos
and estimates their market value. Freemium: everyone gets identification +
value; Premium unlocks the AI Coin Intelligence layer (history, rarity,
condition, selling strategy, an AI assistant).

---

## Status — all 8 phases built

| Phase | Scope | State |
|------|-------|-------|
| **1** | Architecture, design system, navigation, auth, onboarding | ✅ |
| **2** | Live camera capture, image upload, on-device image-quality validation | ✅ |
| **3** | Identification pipeline — OCR → catalog match → confidence scoring | ✅ |
| **4** | Value-estimation engine with an explainable factor breakdown | ✅ |
| **5** | Subscription system, paywall, entitlement gating (RevenueCat integration point) | ✅ |
| **6** | AI Coin Intelligence + AI assistant chat (explicit, on-demand) | ✅ |
| **7** | Personal collection — save, filter, sort, insights | ✅ |
| **8** | Error/empty/loading states, connectivity, tests, store prep | ✅ |

Runs fully today on **local + mock implementations** — no backend required.
Every external dependency is behind an interface with a swappable
implementation; the composition happens in one file, [`lib/bootstrap.dart`](lib/bootstrap.dart).
Search the code for `INTEGRATION POINT` to find where the real services connect.

---

## Requirements

- Flutter SDK **3.22+** (Dart **3.4+**) — `flutter --version`
- For device builds: Android SDK / Xcode as usual. The app also runs on
  `chrome` / `edge` for a quick look (the live camera is mobile-only; the web
  build uses photo upload).

## Run it

```bash
flutter pub get
flutter run                 # picks a connected device
flutter run -d chrome       # or the web build, for a quick look
```

No configuration needed — the app runs on local/mock services out of the box.
The first run regenerates the platform folders' generated files
(`GeneratedPluginRegistrant`, `Generated.xcconfig`, …), which are intentionally
git-ignored.

To point at a real backend / RevenueCat:

```bash
cp .env.example .env        # fill in API_BASE_URL, RevenueCat keys, flags
flutter run --dart-define-from-file=.env
```

### Tests & analysis

```bash
flutter analyze     # clean — 0 issues
flutter test        # 20 tests, all passing
```

Test coverage highlights: the image-quality analyzer (blur / exposure / glare /
framing / multi-coin, against rendered fixtures), the identification pipeline
(confident match / low-confidence alternatives / unidentified), the value model
(condition + key-date + factor output), an app-boot smoke test through
onboarding, and the free vs. Premium result flow (locked upsell vs. explicit
AI-analysis generation).

---

## How identification works (product spec §7–9, §35 — "verified data first")

```
image bytes
   │
   ├─ ImageQualityAnalyzer ....... pre-flight gate (retake vs. use-anyway)
   │
   ▼
OcrService ..................... legend tokens + detected years
   │
   ▼
CoinCatalog (structured data) .. score each entry: token overlap, year in
   │                              range, denomination; rank
   ▼
confidence score .............. < 0.70 ⇒ show ranked "possible matches"
   │                              instead of asserting one answer (§27)
   ▼
ConditionEstimator ............ rough photo-only wear estimate (approximate)
   │
   ▼
ValueEstimationService ........ typical ≈ base(Fine) × condition × rarity ×
                                keyDate × mint, with every multiplier exposed
                                as a ValueFactor the UI can explain
```

The **structured `CoinIdentification`** this produces — never the raw image — is
the only input to the Premium `CoinIntelligenceService` (`toAiContext()`). The
AI explains and interprets verified data; it does not invent facts or prices.
AI analysis runs **only** for subscribers and **only** when the user taps
"Generate AI analysis" (§32).

Today: `MockOcrService` (deterministic, hashes bytes → fixture legends),
`AssetCoinCatalog` (`assets/mock/coin_catalog.json`, ~15 common types),
`HeuristicConditionEstimator` (pure-Dart), `CatalogValueEstimator` (rule-based),
`MockCoinIntelligenceService` (template-driven from the identification).
Swap in `HttpIdentificationService` / `HttpCoinIntelligenceService` by setting
`API_BASE_URL`.

---

## Architecture

Feature-first + light Clean Architecture. State: **Riverpod** (no codegen).
Routing: **go_router** with a `StatefulShellRoute` for the 5 tabs.

```
lib/
  main.dart · bootstrap.dart        entry + composition root
  app/                              MaterialApp.router + router/redirects
  core/
    config/ theme/ error/ utils/ widgets/ network/ constants/
  services/
    analytics/ subscription/ preferences/ connectivity/
  features/
    onboarding/ auth/ shell/ home/
    scan/         capture UI, image-quality gate, analysis animation
    coin/         catalog, OCR, condition, value, identification pipeline
    result/       free result + value factors + locked/premium sections
    ai/           CoinIntelligence, assistant chat
    paywall/ collection/ history/ profile/
  store/                            listing copy + release checklist
```

### Layer rules
- **domain**: entities + interfaces. No Flutter beyond `dart:ui` in the
  analyzers; no packages beyond `equatable`.
- **data**: implementations. Translate exceptions → `Failure`, return `Result<T>`.
- **presentation**: widgets + Riverpod controllers. No cross-feature `data/` imports.

---

## Connecting the backend

### API (identification + AI)
Set `API_BASE_URL`. `bootstrap()` then wires `HttpIdentificationService` and
`HttpCoinIntelligenceService` against [`ApiClient`](lib/core/network/api_client.dart).
Endpoints and JSON shapes are documented in those files. Keys stay server-side.

### Firebase (auth, storage, data)
`flutterfire configure`, uncomment the `firebase_*` deps in `pubspec.yaml`, add
`FirebaseAuthRepository` / `FirestoreScanRepository`, and swap the overrides in
`bootstrap()` when `config.enableFirebase`. Firestore shape (§22):
`users/{uid}`, `scans/{id}`, `collection/{id}`; images in Storage under
`users/{uid}/scans/{id}/`. Account/scan/image deletion is wired in the UI and
fans out via a Cloud Function.

### RevenueCat (subscriptions)
Add `purchases_flutter`, set `ENABLE_REVENUECAT=true` + public keys, finish
[`RevenueCatSubscriptionService`](lib/services/subscription/revenuecat_subscription_service.dart)
(the `Purchases` calls are stubbed in comments), swap the override in
`bootstrap()`. Products & entitlement id are in `store/release-checklist.md`.

---

## Compliance

Value figures always carry `AppConstants.valueDisclaimer`; grading carries
`AppConstants.gradingDisclaimer`. The app never guarantees a price and never
claims to provide professional authentication or financial advice. Low-confidence
identifications show ranked possible matches. The selling advice always warns
against cleaning collectible coins.
