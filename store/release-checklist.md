# Release checklist

## Assets to produce (not code)
- App icon 1024×1024 (no alpha for iOS). Drop as `assets/icon/icon.png`, then
  add `flutter_launcher_icons` and run it, or set icons manually per platform.
- Adaptive icon foreground/background for Android.
- Screenshots: 6.7" + 5.5" iPhone, 12.9" iPad, Android phone + 7"/10" tablet.
  Suggested set: Scan screen, Analyzing animation, Free result, Paywall,
  Premium analysis, Collection.
- Feature graphic 1024×500 (Play).

## Backend before launch
- Deploy identification + value + AI endpoints; set `API_BASE_URL`.
- Create Firebase project; `flutterfire configure`; enable Auth (Email, Google,
  Apple), Firestore, Storage, Analytics, Crashlytics; set `ENABLE_FIREBASE=true`.
- Firestore security rules: a user reads/writes only their own `users/{uid}`,
  `scans`, `collection` docs. Storage rules: only `users/{uid}/**`.
- Cloud Function: on account delete, cascade-delete the user's scans, collection
  docs and Storage objects.

## Subscriptions (Phase 5)
- App Store Connect + Play Console products:
  `coinsight_premium_monthly` (€4.99), `coinsight_premium_yearly` (€29.99),
  7-day free trial on yearly.
- RevenueCat project, entitlement `premium`, offering with both packages.
- Set `ENABLE_REVENUECAT=true` + public SDK keys; swap the subscription
  override in `bootstrap()`.

## Compliance
- Privacy policy + terms hosted; URLs in `AppConstants`.
- App Privacy questionnaire: photos are uploaded for identification; account
  data stored; analytics collected. No tracking / no data sold.
- Confirm every value/grading surface shows the disclaimer strings.
- Apple: Sign in with Apple present because Google sign-in is offered.
- Android: `INTERNET` + `CAMERA` permissions declared; camera `uses-feature`
  marked not required.

## Build
- Bump `version:` in `pubspec.yaml`.
- iOS: set bundle id, signing, `NSCameraUsageDescription` /
  `NSPhotoLibraryUsageDescription` (already in Info.plist).
- Android: set `applicationId`, signing config, `minSdkVersion >= 21`.
- `flutter build appbundle --release --dart-define-from-file=.env`
- `flutter build ipa --release --dart-define-from-file=.env`
