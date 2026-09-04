// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Discover what your coins are really worth.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionClose => 'Close';

  @override
  String get wordOr => 'or';

  @override
  String get navHome => 'Home';

  @override
  String get navCollection => 'Collection';

  @override
  String get navScan => 'Scan';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionShare => 'Share';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — estimated value $value. Identified with Coinsight.';
  }

  @override
  String get offlineBanner => 'Offline — cached scans still work';

  @override
  String get onboard1Title => 'Discover Your Coins';

  @override
  String get onboard1Body => 'Scan any coin and instantly discover what it is.';

  @override
  String get onboard2Title => 'Find Out What It\'s Worth';

  @override
  String get onboard2Body => 'Get an estimated market value based on real data.';

  @override
  String get onboard3Title => 'Unlock AI Coin Intelligence';

  @override
  String get onboard3Body => 'Discover the story, rarity and selling potential of your coins.';

  @override
  String get onboardStart => 'Start Scanning';

  @override
  String get authSubtitle => 'Sign in to sync your collection across devices.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPassword8 => 'Password (8+ characters)';

  @override
  String get authName => 'Name (optional)';

  @override
  String get authForgot => 'Forgot password?';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authGoogle => 'Continue with Google';

  @override
  String get authApple => 'Continue with Apple';

  @override
  String get authGuest => 'Explore without an account';

  @override
  String get authNewHere => 'New here?';

  @override
  String get authCreate => 'Create an account';

  @override
  String get authCreateTitle => 'Create account';

  @override
  String get authCreateCta => 'Create account';

  @override
  String get authResetSent => 'If that email has an account, a reset link is on its way.';

  @override
  String get authNoAccountForEmail => 'No account found for that email.';

  @override
  String get authTerms => 'By continuing you agree to the Coinsight Terms of Service and Privacy Policy.';

  @override
  String get authCreateSyncHint => 'Create an account to sync your collection';

  @override
  String get valEmailEmpty => 'Enter your email';

  @override
  String get valEmailInvalid => 'Enter a valid email address';

  @override
  String get valPasswordEmpty => 'Enter a password';

  @override
  String get valPasswordShort => 'Use at least 8 characters';

  @override
  String valFieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get homeWelcome => 'Welcome';

  @override
  String homeWelcomeNamed(String name) {
    return 'Welcome, $name';
  }

  @override
  String get howItWorks => 'How it works';

  @override
  String get howItWorksScan => 'Scan';

  @override
  String get howItWorksScanBody => 'Photograph the front and back of your coin.';

  @override
  String get howItWorksIdentify => 'Identify';

  @override
  String get howItWorksIdentifyBody => 'We match it against coin databases.';

  @override
  String get howItWorksValue => 'Value';

  @override
  String get howItWorksValueBody => 'See an estimated market value range.';

  @override
  String get mostValuableCoins => 'Most valuable coins';

  @override
  String get seeAll => 'See all';

  @override
  String get recentScans => 'Recent scans';

  @override
  String get noScansYet => 'No scans yet';

  @override
  String get noScansYetBody => 'Your scanned coins will appear here.';

  @override
  String get unlockBannerTitle => 'Unlock AI Coin Intelligence';

  @override
  String get unlockBannerBody => 'History, rarity, condition and how to sell it.';

  @override
  String get scanTitle => 'Scan a Coin';

  @override
  String get scanReset => 'Reset';

  @override
  String get scanFront => 'Scan the front';

  @override
  String get scanFrontShort => 'Front';

  @override
  String get scanBack => 'Scan the back (optional)';

  @override
  String get scanBackShort => 'Back';

  @override
  String get forBestResult => 'For the best result';

  @override
  String get tipPlainBackground => 'Place the coin on a plain background.';

  @override
  String get tipWholeCoin => 'Make sure the entire coin is visible.';

  @override
  String get tipLighting => 'Use good, even lighting.';

  @override
  String get tipGlare => 'Avoid glare and reflections.';

  @override
  String get identifyCoin => 'Identify Coin';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get uploadFromLibrary => 'Upload from library';

  @override
  String get couldNotOpenImage => 'Could not open that image. Check photo permissions in Settings.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Tap to retake · $issue';
  }

  @override
  String get cameraPromptFront => 'Scan the front of your coin';

  @override
  String get cameraPromptBack => 'Scan the back of your coin';

  @override
  String get cameraHint => 'Fill the circle · plain background · steady hands';

  @override
  String get cameraAccessOffTitle => 'Camera access is off';

  @override
  String get cameraAccessOffBody => 'Enable camera access for Coinsight in your device Settings, then come back to scan. You can also upload a photo instead.';

  @override
  String get cameraUsePhotoInstead => 'Use a photo instead';

  @override
  String get cameraNoneTitle => 'No camera available';

  @override
  String get cameraNoneBody => 'This device has no usable camera. Upload a photo instead.';

  @override
  String get cameraUploadPhoto => 'Upload a photo';

  @override
  String get cameraCaptureFailed => 'Could not take the photo. Try again.';

  @override
  String get qualityRetakeNeeded => 'Retake needed';

  @override
  String get qualityCouldBeBetter => 'This photo could be better';

  @override
  String get qualityRetake => 'Retake';

  @override
  String get qualityUseAnyway => 'Use this photo anyway';

  @override
  String get issueLowResShort => 'Low resolution';

  @override
  String get issueLowResFull => 'This image is too small. Use your camera at full quality or pick a larger photo.';

  @override
  String get issueTooDarkShort => 'Too dark';

  @override
  String get issueTooDarkFull => 'The photo is too dark. Move to brighter, even lighting.';

  @override
  String get issueTooBrightShort => 'Overexposed';

  @override
  String get issueTooBrightFull => 'The photo is overexposed. Reduce direct light or move out of glare.';

  @override
  String get issueBlurryShort => 'Blurry';

  @override
  String get issueBlurryFull => 'The image is too blurry. Hold the phone still, tap to focus, and make sure the coin is sharp.';

  @override
  String get issueGlareShort => 'Reflections';

  @override
  String get issueGlareFull => 'There are strong reflections on the coin. Tilt it slightly or use softer, indirect light.';

  @override
  String get issueNoCoinShort => 'No coin detected';

  @override
  String get issueNoCoinFull => 'We could not find a coin. Place a single coin on a plain background that fills most of the frame.';

  @override
  String get issueCoinSmallShort => 'Coin too small';

  @override
  String get issueCoinSmallFull => 'Move closer so the coin fills most of the circle.';

  @override
  String get issueMultipleShort => 'Multiple objects';

  @override
  String get issueMultipleFull => 'We detected more than one object. Scan a single coin at a time.';

  @override
  String get analyzingCoin => 'Analyzing coin…';

  @override
  String get stageDetectingText => 'Detecting text';

  @override
  String get stageIdentifyingCountry => 'Identifying country';

  @override
  String get stageDetectingYear => 'Detecting year';

  @override
  String get stageSearchingDatabase => 'Searching coin database';

  @override
  String get stageCalculatingValue => 'Calculating value';

  @override
  String get resultTitle => 'Coin result';

  @override
  String get loadingResult => 'Loading result…';

  @override
  String get resultOpenError => 'We could not open this result.';

  @override
  String confidenceValue(String percent) {
    return '$percent confidence';
  }

  @override
  String get estimatedMarketValue => 'ESTIMATED MARKET VALUE';

  @override
  String typicalEstimate(String value) {
    return 'Typical estimate $value';
  }

  @override
  String get whatAffectsValue => 'What affects this value';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count more in the full value analysis';
  }

  @override
  String get notConfidentMatch => 'Not a confident match';

  @override
  String get notConfidentBody => 'We could not identify this coin with high confidence. Possible matches:';

  @override
  String get detailCountry => 'Country';

  @override
  String get detailYear => 'Year';

  @override
  String get detailDenomination => 'Denomination';

  @override
  String get detailMaterial => 'Material';

  @override
  String get detailMint => 'Mint';

  @override
  String get detailDiameter => 'Diameter';

  @override
  String get detailWeight => 'Weight';

  @override
  String get detailConditionEst => 'Condition (est.)';

  @override
  String get detailRarityEst => 'Rarity (est.)';

  @override
  String get saveToCollection => 'Save to Collection';

  @override
  String get savedToCollection => 'Saved to your collection';

  @override
  String get unlockAiTitle => 'Unlock AI Coin Intelligence';

  @override
  String get aiFeatHistory => 'The complete history';

  @override
  String get aiFeatValue => 'Why collectors value it';

  @override
  String get aiFeatRarity => 'Rarity analysis';

  @override
  String get aiFeatCondition => 'Condition insights';

  @override
  String get aiFeatSelling => 'How to sell it';

  @override
  String get unlockPremium => 'Unlock Premium';

  @override
  String get aiCoinIntelligence => 'AI Coin Intelligence';

  @override
  String get generateAiAnalysis => 'Generate AI analysis';

  @override
  String get askAiAssistant => 'Ask the AI assistant';

  @override
  String get aiCtaHistory => 'Coin story & historical context';

  @override
  String get aiCtaValue => 'Why it has value, factor by factor';

  @override
  String get aiCtaRarityCondition => 'Rarity & condition analysis';

  @override
  String get aiCtaSelling => 'Selling strategy & pricing';

  @override
  String get coinStory => 'Coin Story';

  @override
  String get whyItHasValue => 'Why It Has Value';

  @override
  String get rarityAnalysis => 'Rarity Analysis';

  @override
  String get conditionEstimate => 'Condition Estimate';

  @override
  String get sellingRecommendations => 'Selling Recommendations';

  @override
  String get collectorInsights => 'Collector Insights';

  @override
  String get generatingAnalysis => 'Generating your AI coin analysis…';

  @override
  String get aiUnavailable => 'AI analysis is temporarily unavailable.';

  @override
  String get estimatedSellingPrice => 'Estimated selling price';

  @override
  String get suggestedListingPrice => 'Suggested listing price';

  @override
  String get minimumReasonablePrice => 'Minimum reasonable price';

  @override
  String get whereToSell => 'Where to sell';

  @override
  String get auctionSuitable => 'Auction suitable?';

  @override
  String get professionalAppraisal => 'Professional appraisal';

  @override
  String get aiAssistantTitle => 'AI coin assistant';

  @override
  String aiTalkingAbout(String coin) {
    return 'Talking about: $coin';
  }

  @override
  String get aiAskHint => 'Ask about this coin…';

  @override
  String get aiAssistantIntro => 'Ask the assistant anything about this coin';

  @override
  String get aiCouldNotOpen => 'Could not open this coin.';

  @override
  String get qWhyValuable => 'Why is this coin valuable?';

  @override
  String get qIsRare => 'Is this coin rare?';

  @override
  String get qWhereSell => 'Where should I sell it?';

  @override
  String get qAuthenticate => 'Should I get this coin authenticated?';

  @override
  String get qHowMuchList => 'How much should I list it for?';

  @override
  String get paywallHeadline => 'Unlock the Full Story Behind Every Coin';

  @override
  String get paywallSubheadline => 'Discover the history, rarity and best way to sell your coins.';

  @override
  String get featAiAnalysis => 'Detailed AI analysis';

  @override
  String get featCoinHistory => 'Coin history';

  @override
  String get featRarityInsights => 'Rarity insights';

  @override
  String get featConditionAnalysis => 'Condition analysis';

  @override
  String get featSellingRecs => 'Selling recommendations';

  @override
  String get featCollectorInsights => 'Collector insights';

  @override
  String get featAiAssistant => 'AI coin assistant';

  @override
  String get featAdvancedStats => 'Advanced collection statistics';

  @override
  String get planYearly => 'Yearly';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get planPerYear => 'per year';

  @override
  String get planPerMonth => 'per month';

  @override
  String get bestValue => 'BEST VALUE';

  @override
  String get trial7Days => '7-day free trial';

  @override
  String get paywallLegal => 'Subscription renews automatically until cancelled. Manage or cancel anytime in your store account.';

  @override
  String get paywallLoadError => 'Could not load subscription options.';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get collectionTitle => 'Collection';

  @override
  String get collectionEmpty => 'Your collection is empty';

  @override
  String get collectionEmptyBody => 'Save a scanned coin to add it here.';

  @override
  String get scanACoin => 'Scan a Coin';

  @override
  String get searchCoinCountry => 'Search by coin or country';

  @override
  String get sortRecent => 'Recent';

  @override
  String get sortValueHigh => 'Value ↓';

  @override
  String get sortRarity => 'Rarity';

  @override
  String get filterRarity => 'Rarity';

  @override
  String get filterCountry => 'Country';

  @override
  String get filterAll => 'All';

  @override
  String get filterByRarity => 'Filter by rarity';

  @override
  String get filterByCountry => 'Filter by country';

  @override
  String get noMatchFilters => 'No coins match those filters';

  @override
  String get statCoins => 'Coins';

  @override
  String get statEstValue => 'Est. value';

  @override
  String get statMostValuable => 'Most valuable';

  @override
  String rarestLabel(String name, String rarity) {
    return 'Rarest: $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'Could not load your collection.';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty => 'Nothing scanned yet';

  @override
  String get historyEmptyBody => 'Scan a coin to start building your history.';

  @override
  String get historyLoadError => 'Could not load your scan history.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileGuest => 'Guest';

  @override
  String get sectionSubscription => 'Subscription';

  @override
  String get coinsightPremium => 'Coinsight Premium';

  @override
  String get freePlan => 'Free plan';

  @override
  String renewsOn(String date) {
    return 'Renews $date';
  }

  @override
  String get subActive => 'Active';

  @override
  String get manageSubscription => 'Manage subscription';

  @override
  String get manageSubscriptionBody => 'Opens your App Store / Play Store settings';

  @override
  String get manageSubscriptionHint => 'Manage or cancel from your store account settings.';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get sectionLegal => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get sectionDeveloper => 'Developer';

  @override
  String get premiumDebugOverride => 'Premium (debug override)';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBody => 'This permanently deletes your account, scans and images. This cannot be undone.';

  @override
  String appVersion(String version) {
    return 'Coinsight • v$version';
  }

  @override
  String get rankingsTitle => 'Coin rankings';

  @override
  String get rankMostValuable => 'Most valuable';

  @override
  String get rankRarest => 'Rarest';

  @override
  String get rankKeyDates => 'Key dates';

  @override
  String get rankMostValuableSub => 'The record-setters of the coin world. Extreme rarities — but it shows what a coin can be worth.';

  @override
  String get rankRarestSub => 'Coins that almost never come to market.';

  @override
  String get rankKeyDatesSub => 'Ordinary-looking coins with a date or mint mark worth checking your change for.';

  @override
  String get rankLoadError => 'Could not load the rankings.';

  @override
  String get typicalRange => 'TYPICAL RANGE';

  @override
  String get scanYoursToCheck => 'Scan yours to check';

  @override
  String get rankYears => 'Years';

  @override
  String get rankKeyDatesLabel => 'Key dates';

  @override
  String yearBc(int year) {
    return '$year BC';
  }

  @override
  String get errNetwork => 'No internet connection. Check your network and try again.';

  @override
  String get errServer => 'Something went wrong on our side. Please try again shortly.';

  @override
  String get errUnknown => 'Unexpected error. Please try again.';

  @override
  String get errNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errAuth => 'Authentication failed. Please try again.';

  @override
  String get errScanNotFound => 'That scan could not be found.';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int m) {
    return '${m}m ago';
  }

  @override
  String hoursAgo(int h) {
    return '${h}h ago';
  }

  @override
  String daysAgo(int d) {
    return '${d}d ago';
  }

  @override
  String get valueDisclaimer => 'Coin values are estimates based on available data and may vary depending on condition, authenticity and market demand.';

  @override
  String get gradingDisclaimer => 'This app does not provide professional numismatic authentication or financial advice. Condition estimates are approximate.';

  @override
  String get condPoor => 'Poor';

  @override
  String get condFair => 'Fair';

  @override
  String get condGood => 'Good';

  @override
  String get condVeryGood => 'Very Good';

  @override
  String get condFine => 'Fine';

  @override
  String get condVeryFine => 'Very Fine';

  @override
  String get condExtremelyFine => 'Extremely Fine';

  @override
  String get condUncirculated => 'Uncirculated';

  @override
  String get rarCommon => 'Common';

  @override
  String get rarUncommon => 'Uncommon';

  @override
  String get rarRare => 'Rare';

  @override
  String get rarVeryRare => 'Very Rare';

  @override
  String get rarExtremelyRare => 'Extremely Rare';
}
