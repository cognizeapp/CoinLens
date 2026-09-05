import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl'),
    Locale('pt')
  ];

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover what your coins are really worth.'**
  String get appTagline;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @wordOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get wordOr;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get navCollection;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @shareCoinText.
  ///
  /// In en, this message translates to:
  /// **'{coin} — estimated value {value}. Identified with Coinsights.'**
  String shareCoinText(String coin, String value);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline — cached scans still work'**
  String get offlineBanner;

  /// No description provided for @onboard1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Coins'**
  String get onboard1Title;

  /// No description provided for @onboard1Body.
  ///
  /// In en, this message translates to:
  /// **'Scan any coin and instantly discover what it is.'**
  String get onboard1Body;

  /// No description provided for @onboard2Title.
  ///
  /// In en, this message translates to:
  /// **'Find Out What It\'s Worth'**
  String get onboard2Title;

  /// No description provided for @onboard2Body.
  ///
  /// In en, this message translates to:
  /// **'Get an estimated market value based on real data.'**
  String get onboard2Body;

  /// No description provided for @onboard3Title.
  ///
  /// In en, this message translates to:
  /// **'Unlock AI Coin Intelligence'**
  String get onboard3Title;

  /// No description provided for @onboard3Body.
  ///
  /// In en, this message translates to:
  /// **'Discover the story, rarity and selling potential of your coins.'**
  String get onboard3Body;

  /// No description provided for @onboardStart.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get onboardStart;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your collection across devices.'**
  String get authSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPassword8.
  ///
  /// In en, this message translates to:
  /// **'Password (8+ characters)'**
  String get authPassword8;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get authName;

  /// No description provided for @authForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgot;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogle;

  /// No description provided for @authApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authApple;

  /// No description provided for @authGuest.
  ///
  /// In en, this message translates to:
  /// **'Explore without an account'**
  String get authGuest;

  /// No description provided for @authNewHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get authNewHere;

  /// No description provided for @authCreate.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get authCreate;

  /// No description provided for @authCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateTitle;

  /// No description provided for @authCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateCta;

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'If that email has an account, a reset link is on its way.'**
  String get authResetSent;

  /// No description provided for @authNoAccountForEmail.
  ///
  /// In en, this message translates to:
  /// **'No account found for that email.'**
  String get authNoAccountForEmail;

  /// No description provided for @authTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Coinsights Terms of Service and Privacy Policy.'**
  String get authTerms;

  /// No description provided for @authCreateSyncHint.
  ///
  /// In en, this message translates to:
  /// **'Create an account to sync your collection'**
  String get authCreateSyncHint;

  /// No description provided for @valEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get valEmailEmpty;

  /// No description provided for @valEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get valEmailInvalid;

  /// No description provided for @valPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get valPasswordEmpty;

  /// No description provided for @valPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get valPasswordShort;

  /// No description provided for @valFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String valFieldRequired(String field);

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get homeWelcome;

  /// No description provided for @homeWelcomeNamed.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String homeWelcomeNamed(String name);

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @howItWorksScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get howItWorksScan;

  /// No description provided for @howItWorksScanBody.
  ///
  /// In en, this message translates to:
  /// **'Photograph the front and back of your coin.'**
  String get howItWorksScanBody;

  /// No description provided for @howItWorksIdentify.
  ///
  /// In en, this message translates to:
  /// **'Identify'**
  String get howItWorksIdentify;

  /// No description provided for @howItWorksIdentifyBody.
  ///
  /// In en, this message translates to:
  /// **'We match it against coin databases.'**
  String get howItWorksIdentifyBody;

  /// No description provided for @howItWorksValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get howItWorksValue;

  /// No description provided for @howItWorksValueBody.
  ///
  /// In en, this message translates to:
  /// **'See an estimated market value range.'**
  String get howItWorksValueBody;

  /// No description provided for @mostValuableCoins.
  ///
  /// In en, this message translates to:
  /// **'Most valuable coins'**
  String get mostValuableCoins;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent scans'**
  String get recentScans;

  /// No description provided for @noScansYet.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get noScansYet;

  /// No description provided for @noScansYetBody.
  ///
  /// In en, this message translates to:
  /// **'Your scanned coins will appear here.'**
  String get noScansYetBody;

  /// No description provided for @unlockBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock AI Coin Intelligence'**
  String get unlockBannerTitle;

  /// No description provided for @unlockBannerBody.
  ///
  /// In en, this message translates to:
  /// **'History, rarity, condition and how to sell it.'**
  String get unlockBannerBody;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a Coin'**
  String get scanTitle;

  /// No description provided for @scanReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get scanReset;

  /// No description provided for @scanFront.
  ///
  /// In en, this message translates to:
  /// **'Scan the front'**
  String get scanFront;

  /// No description provided for @scanFrontShort.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get scanFrontShort;

  /// No description provided for @scanBack.
  ///
  /// In en, this message translates to:
  /// **'Scan the back (optional)'**
  String get scanBack;

  /// No description provided for @scanBackShort.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get scanBackShort;

  /// No description provided for @forBestResult.
  ///
  /// In en, this message translates to:
  /// **'For the best result'**
  String get forBestResult;

  /// No description provided for @tipPlainBackground.
  ///
  /// In en, this message translates to:
  /// **'Place the coin on a plain background.'**
  String get tipPlainBackground;

  /// No description provided for @tipWholeCoin.
  ///
  /// In en, this message translates to:
  /// **'Make sure the entire coin is visible.'**
  String get tipWholeCoin;

  /// No description provided for @tipLighting.
  ///
  /// In en, this message translates to:
  /// **'Use good, even lighting.'**
  String get tipLighting;

  /// No description provided for @tipGlare.
  ///
  /// In en, this message translates to:
  /// **'Avoid glare and reflections.'**
  String get tipGlare;

  /// No description provided for @identifyCoin.
  ///
  /// In en, this message translates to:
  /// **'Identify Coin'**
  String get identifyCoin;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @uploadFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Upload from library'**
  String get uploadFromLibrary;

  /// No description provided for @couldNotOpenImage.
  ///
  /// In en, this message translates to:
  /// **'Could not open that image. Check photo permissions in Settings.'**
  String get couldNotOpenImage;

  /// No description provided for @tapToRetakeWith.
  ///
  /// In en, this message translates to:
  /// **'Tap to retake · {issue}'**
  String tapToRetakeWith(String issue);

  /// No description provided for @cameraPromptFront.
  ///
  /// In en, this message translates to:
  /// **'Scan the front of your coin'**
  String get cameraPromptFront;

  /// No description provided for @cameraPromptBack.
  ///
  /// In en, this message translates to:
  /// **'Scan the back of your coin'**
  String get cameraPromptBack;

  /// No description provided for @cameraHint.
  ///
  /// In en, this message translates to:
  /// **'Fill the circle · plain background · steady hands'**
  String get cameraHint;

  /// No description provided for @cameraAccessOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off'**
  String get cameraAccessOffTitle;

  /// No description provided for @cameraAccessOffBody.
  ///
  /// In en, this message translates to:
  /// **'Enable camera access for Coinsights in your device Settings, then come back to scan. You can also upload a photo instead.'**
  String get cameraAccessOffBody;

  /// No description provided for @cameraUsePhotoInstead.
  ///
  /// In en, this message translates to:
  /// **'Use a photo instead'**
  String get cameraUsePhotoInstead;

  /// No description provided for @cameraNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No camera available'**
  String get cameraNoneTitle;

  /// No description provided for @cameraNoneBody.
  ///
  /// In en, this message translates to:
  /// **'This device has no usable camera. Upload a photo instead.'**
  String get cameraNoneBody;

  /// No description provided for @cameraUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo'**
  String get cameraUploadPhoto;

  /// No description provided for @cameraCaptureFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not take the photo. Try again.'**
  String get cameraCaptureFailed;

  /// No description provided for @qualityRetakeNeeded.
  ///
  /// In en, this message translates to:
  /// **'Retake needed'**
  String get qualityRetakeNeeded;

  /// No description provided for @qualityCouldBeBetter.
  ///
  /// In en, this message translates to:
  /// **'This photo could be better'**
  String get qualityCouldBeBetter;

  /// No description provided for @qualityRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get qualityRetake;

  /// No description provided for @qualityUseAnyway.
  ///
  /// In en, this message translates to:
  /// **'Use this photo anyway'**
  String get qualityUseAnyway;

  /// No description provided for @issueLowResShort.
  ///
  /// In en, this message translates to:
  /// **'Low resolution'**
  String get issueLowResShort;

  /// No description provided for @issueLowResFull.
  ///
  /// In en, this message translates to:
  /// **'This image is too small. Use your camera at full quality or pick a larger photo.'**
  String get issueLowResFull;

  /// No description provided for @issueTooDarkShort.
  ///
  /// In en, this message translates to:
  /// **'Too dark'**
  String get issueTooDarkShort;

  /// No description provided for @issueTooDarkFull.
  ///
  /// In en, this message translates to:
  /// **'The photo is too dark. Move to brighter, even lighting.'**
  String get issueTooDarkFull;

  /// No description provided for @issueTooBrightShort.
  ///
  /// In en, this message translates to:
  /// **'Overexposed'**
  String get issueTooBrightShort;

  /// No description provided for @issueTooBrightFull.
  ///
  /// In en, this message translates to:
  /// **'The photo is overexposed. Reduce direct light or move out of glare.'**
  String get issueTooBrightFull;

  /// No description provided for @issueBlurryShort.
  ///
  /// In en, this message translates to:
  /// **'Blurry'**
  String get issueBlurryShort;

  /// No description provided for @issueBlurryFull.
  ///
  /// In en, this message translates to:
  /// **'The image is too blurry. Hold the phone still, tap to focus, and make sure the coin is sharp.'**
  String get issueBlurryFull;

  /// No description provided for @issueGlareShort.
  ///
  /// In en, this message translates to:
  /// **'Reflections'**
  String get issueGlareShort;

  /// No description provided for @issueGlareFull.
  ///
  /// In en, this message translates to:
  /// **'There are strong reflections on the coin. Tilt it slightly or use softer, indirect light.'**
  String get issueGlareFull;

  /// No description provided for @issueNoCoinShort.
  ///
  /// In en, this message translates to:
  /// **'No coin detected'**
  String get issueNoCoinShort;

  /// No description provided for @issueNoCoinFull.
  ///
  /// In en, this message translates to:
  /// **'We could not find a coin. Place a single coin on a plain background that fills most of the frame.'**
  String get issueNoCoinFull;

  /// No description provided for @issueCoinSmallShort.
  ///
  /// In en, this message translates to:
  /// **'Coin too small'**
  String get issueCoinSmallShort;

  /// No description provided for @issueCoinSmallFull.
  ///
  /// In en, this message translates to:
  /// **'Move closer so the coin fills most of the circle.'**
  String get issueCoinSmallFull;

  /// No description provided for @issueMultipleShort.
  ///
  /// In en, this message translates to:
  /// **'Multiple objects'**
  String get issueMultipleShort;

  /// No description provided for @issueMultipleFull.
  ///
  /// In en, this message translates to:
  /// **'We detected more than one object. Scan a single coin at a time.'**
  String get issueMultipleFull;

  /// No description provided for @analyzingCoin.
  ///
  /// In en, this message translates to:
  /// **'Analyzing coin…'**
  String get analyzingCoin;

  /// No description provided for @stageDetectingText.
  ///
  /// In en, this message translates to:
  /// **'Detecting text'**
  String get stageDetectingText;

  /// No description provided for @stageIdentifyingCountry.
  ///
  /// In en, this message translates to:
  /// **'Identifying country'**
  String get stageIdentifyingCountry;

  /// No description provided for @stageDetectingYear.
  ///
  /// In en, this message translates to:
  /// **'Detecting year'**
  String get stageDetectingYear;

  /// No description provided for @stageSearchingDatabase.
  ///
  /// In en, this message translates to:
  /// **'Searching coin database'**
  String get stageSearchingDatabase;

  /// No description provided for @stageCalculatingValue.
  ///
  /// In en, this message translates to:
  /// **'Calculating value'**
  String get stageCalculatingValue;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Coin result'**
  String get resultTitle;

  /// No description provided for @loadingResult.
  ///
  /// In en, this message translates to:
  /// **'Loading result…'**
  String get loadingResult;

  /// No description provided for @resultOpenError.
  ///
  /// In en, this message translates to:
  /// **'We could not open this result.'**
  String get resultOpenError;

  /// No description provided for @confidenceValue.
  ///
  /// In en, this message translates to:
  /// **'{percent} confidence'**
  String confidenceValue(String percent);

  /// No description provided for @estimatedMarketValue.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED MARKET VALUE'**
  String get estimatedMarketValue;

  /// No description provided for @typicalEstimate.
  ///
  /// In en, this message translates to:
  /// **'Typical estimate {value}'**
  String typicalEstimate(String value);

  /// No description provided for @whatAffectsValue.
  ///
  /// In en, this message translates to:
  /// **'What affects this value'**
  String get whatAffectsValue;

  /// No description provided for @moreInFullAnalysis.
  ///
  /// In en, this message translates to:
  /// **'+{count} more in the full value analysis'**
  String moreInFullAnalysis(int count);

  /// No description provided for @notConfidentMatch.
  ///
  /// In en, this message translates to:
  /// **'Not a confident match'**
  String get notConfidentMatch;

  /// No description provided for @notConfidentBody.
  ///
  /// In en, this message translates to:
  /// **'We could not identify this coin with high confidence. Possible matches:'**
  String get notConfidentBody;

  /// No description provided for @detailCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get detailCountry;

  /// No description provided for @detailYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get detailYear;

  /// No description provided for @detailDenomination.
  ///
  /// In en, this message translates to:
  /// **'Denomination'**
  String get detailDenomination;

  /// No description provided for @detailMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get detailMaterial;

  /// No description provided for @detailMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get detailMint;

  /// No description provided for @detailDiameter.
  ///
  /// In en, this message translates to:
  /// **'Diameter'**
  String get detailDiameter;

  /// No description provided for @detailWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get detailWeight;

  /// No description provided for @detailConditionEst.
  ///
  /// In en, this message translates to:
  /// **'Condition (est.)'**
  String get detailConditionEst;

  /// No description provided for @detailRarityEst.
  ///
  /// In en, this message translates to:
  /// **'Rarity (est.)'**
  String get detailRarityEst;

  /// No description provided for @saveToCollection.
  ///
  /// In en, this message translates to:
  /// **'Save to Collection'**
  String get saveToCollection;

  /// No description provided for @savedToCollection.
  ///
  /// In en, this message translates to:
  /// **'Saved to your collection'**
  String get savedToCollection;

  /// No description provided for @unlockAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock AI Coin Intelligence'**
  String get unlockAiTitle;

  /// No description provided for @aiFeatHistory.
  ///
  /// In en, this message translates to:
  /// **'The complete history'**
  String get aiFeatHistory;

  /// No description provided for @aiFeatValue.
  ///
  /// In en, this message translates to:
  /// **'Why collectors value it'**
  String get aiFeatValue;

  /// No description provided for @aiFeatRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity analysis'**
  String get aiFeatRarity;

  /// No description provided for @aiFeatCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition insights'**
  String get aiFeatCondition;

  /// No description provided for @aiFeatSelling.
  ///
  /// In en, this message translates to:
  /// **'How to sell it'**
  String get aiFeatSelling;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// No description provided for @aiCoinIntelligence.
  ///
  /// In en, this message translates to:
  /// **'AI Coin Intelligence'**
  String get aiCoinIntelligence;

  /// No description provided for @generateAiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Generate AI analysis'**
  String get generateAiAnalysis;

  /// No description provided for @askAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI assistant'**
  String get askAiAssistant;

  /// No description provided for @aiCtaHistory.
  ///
  /// In en, this message translates to:
  /// **'Coin story & historical context'**
  String get aiCtaHistory;

  /// No description provided for @aiCtaValue.
  ///
  /// In en, this message translates to:
  /// **'Why it has value, factor by factor'**
  String get aiCtaValue;

  /// No description provided for @aiCtaRarityCondition.
  ///
  /// In en, this message translates to:
  /// **'Rarity & condition analysis'**
  String get aiCtaRarityCondition;

  /// No description provided for @aiCtaSelling.
  ///
  /// In en, this message translates to:
  /// **'Selling strategy & pricing'**
  String get aiCtaSelling;

  /// No description provided for @coinStory.
  ///
  /// In en, this message translates to:
  /// **'Coin Story'**
  String get coinStory;

  /// No description provided for @whyItHasValue.
  ///
  /// In en, this message translates to:
  /// **'Why It Has Value'**
  String get whyItHasValue;

  /// No description provided for @rarityAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Rarity Analysis'**
  String get rarityAnalysis;

  /// No description provided for @conditionEstimate.
  ///
  /// In en, this message translates to:
  /// **'Condition Estimate'**
  String get conditionEstimate;

  /// No description provided for @sellingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Selling Recommendations'**
  String get sellingRecommendations;

  /// No description provided for @collectorInsights.
  ///
  /// In en, this message translates to:
  /// **'Collector Insights'**
  String get collectorInsights;

  /// No description provided for @generatingAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Generating your AI coin analysis…'**
  String get generatingAnalysis;

  /// No description provided for @aiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI analysis is temporarily unavailable.'**
  String get aiUnavailable;

  /// No description provided for @estimatedSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimated selling price'**
  String get estimatedSellingPrice;

  /// No description provided for @suggestedListingPrice.
  ///
  /// In en, this message translates to:
  /// **'Suggested listing price'**
  String get suggestedListingPrice;

  /// No description provided for @minimumReasonablePrice.
  ///
  /// In en, this message translates to:
  /// **'Minimum reasonable price'**
  String get minimumReasonablePrice;

  /// No description provided for @whereToSell.
  ///
  /// In en, this message translates to:
  /// **'Where to sell'**
  String get whereToSell;

  /// No description provided for @auctionSuitable.
  ///
  /// In en, this message translates to:
  /// **'Auction suitable?'**
  String get auctionSuitable;

  /// No description provided for @professionalAppraisal.
  ///
  /// In en, this message translates to:
  /// **'Professional appraisal'**
  String get professionalAppraisal;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI coin assistant'**
  String get aiAssistantTitle;

  /// No description provided for @aiTalkingAbout.
  ///
  /// In en, this message translates to:
  /// **'Talking about: {coin}'**
  String aiTalkingAbout(String coin);

  /// No description provided for @aiAskHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about this coin…'**
  String get aiAskHint;

  /// No description provided for @aiAssistantIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask the assistant anything about this coin'**
  String get aiAssistantIntro;

  /// No description provided for @aiCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open this coin.'**
  String get aiCouldNotOpen;

  /// No description provided for @qWhyValuable.
  ///
  /// In en, this message translates to:
  /// **'Why is this coin valuable?'**
  String get qWhyValuable;

  /// No description provided for @qIsRare.
  ///
  /// In en, this message translates to:
  /// **'Is this coin rare?'**
  String get qIsRare;

  /// No description provided for @qWhereSell.
  ///
  /// In en, this message translates to:
  /// **'Where should I sell it?'**
  String get qWhereSell;

  /// No description provided for @qAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Should I get this coin authenticated?'**
  String get qAuthenticate;

  /// No description provided for @qHowMuchList.
  ///
  /// In en, this message translates to:
  /// **'How much should I list it for?'**
  String get qHowMuchList;

  /// No description provided for @paywallHeadline.
  ///
  /// In en, this message translates to:
  /// **'Unlock the Full Story Behind Every Coin'**
  String get paywallHeadline;

  /// No description provided for @paywallSubheadline.
  ///
  /// In en, this message translates to:
  /// **'Discover the history, rarity and best way to sell your coins.'**
  String get paywallSubheadline;

  /// No description provided for @featAiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Detailed AI analysis'**
  String get featAiAnalysis;

  /// No description provided for @featCoinHistory.
  ///
  /// In en, this message translates to:
  /// **'Coin history'**
  String get featCoinHistory;

  /// No description provided for @featRarityInsights.
  ///
  /// In en, this message translates to:
  /// **'Rarity insights'**
  String get featRarityInsights;

  /// No description provided for @featConditionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Condition analysis'**
  String get featConditionAnalysis;

  /// No description provided for @featSellingRecs.
  ///
  /// In en, this message translates to:
  /// **'Selling recommendations'**
  String get featSellingRecs;

  /// No description provided for @featCollectorInsights.
  ///
  /// In en, this message translates to:
  /// **'Collector insights'**
  String get featCollectorInsights;

  /// No description provided for @featAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI coin assistant'**
  String get featAiAssistant;

  /// No description provided for @featAdvancedStats.
  ///
  /// In en, this message translates to:
  /// **'Advanced collection statistics'**
  String get featAdvancedStats;

  /// No description provided for @featSellGuide.
  ///
  /// In en, this message translates to:
  /// **'Full where-to-sell marketplace guide'**
  String get featSellGuide;

  /// No description provided for @featNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get featNoAds;

  /// No description provided for @planYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get planYearly;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @planPerYear.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get planPerYear;

  /// No description provided for @planPerMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get planPerMonth;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get bestValue;

  /// No description provided for @trial7Days.
  ///
  /// In en, this message translates to:
  /// **'7-day free trial'**
  String get trial7Days;

  /// No description provided for @paywallLegal.
  ///
  /// In en, this message translates to:
  /// **'Subscription renews automatically until cancelled. Manage or cancel anytime in your store account.'**
  String get paywallLegal;

  /// No description provided for @paywallLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load subscription options.'**
  String get paywallLoadError;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @collectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collectionTitle;

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your collection is empty'**
  String get collectionEmpty;

  /// No description provided for @collectionEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save a scanned coin to add it here.'**
  String get collectionEmptyBody;

  /// No description provided for @scanACoin.
  ///
  /// In en, this message translates to:
  /// **'Scan a Coin'**
  String get scanACoin;

  /// No description provided for @collectionAddCoin.
  ///
  /// In en, this message translates to:
  /// **'Add a coin'**
  String get collectionAddCoin;

  /// No description provided for @collectionEditHintList.
  ///
  /// In en, this message translates to:
  /// **'Swipe a coin left to remove it, or tap + to add one.'**
  String get collectionEditHintList;

  /// No description provided for @collectionEditHintGrid.
  ///
  /// In en, this message translates to:
  /// **'Long-press a coin to remove it, or tap + to add one.'**
  String get collectionEditHintGrid;

  /// No description provided for @collectionManage.
  ///
  /// In en, this message translates to:
  /// **'Edit collection'**
  String get collectionManage;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @collectionRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from collection?'**
  String get collectionRemoveTitle;

  /// No description provided for @collectionRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'{coin} stays in your scan history — it just leaves your collection and portfolio total.'**
  String collectionRemoveBody(String coin);

  /// No description provided for @collectionRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get collectionRemoveAction;

  /// No description provided for @collectionRemovedToast.
  ///
  /// In en, this message translates to:
  /// **'Removed from your collection'**
  String get collectionRemovedToast;

  /// No description provided for @searchCoinCountry.
  ///
  /// In en, this message translates to:
  /// **'Search by coin or country'**
  String get searchCoinCountry;

  /// No description provided for @sortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get sortRecent;

  /// No description provided for @sortValueHigh.
  ///
  /// In en, this message translates to:
  /// **'Value ↓'**
  String get sortValueHigh;

  /// No description provided for @sortRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get sortRarity;

  /// No description provided for @filterRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get filterRarity;

  /// No description provided for @filterCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get filterCountry;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterByRarity.
  ///
  /// In en, this message translates to:
  /// **'Filter by rarity'**
  String get filterByRarity;

  /// No description provided for @filterByCountry.
  ///
  /// In en, this message translates to:
  /// **'Filter by country'**
  String get filterByCountry;

  /// No description provided for @noMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No coins match those filters'**
  String get noMatchFilters;

  /// No description provided for @statCoins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get statCoins;

  /// No description provided for @statEstValue.
  ///
  /// In en, this message translates to:
  /// **'Est. value'**
  String get statEstValue;

  /// No description provided for @statMostValuable.
  ///
  /// In en, this message translates to:
  /// **'Most valuable'**
  String get statMostValuable;

  /// No description provided for @rarestLabel.
  ///
  /// In en, this message translates to:
  /// **'Rarest: {name} ({rarity})'**
  String rarestLabel(String name, String rarity);

  /// No description provided for @collectionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your collection.'**
  String get collectionLoadError;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing scanned yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a coin to start building your history.'**
  String get historyEmptyBody;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your scan history.'**
  String get historyLoadError;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuest;

  /// No description provided for @sectionSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get sectionSubscription;

  /// No description provided for @coinsightPremium.
  ///
  /// In en, this message translates to:
  /// **'Coinsights Premium'**
  String get coinsightPremium;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get freePlan;

  /// No description provided for @renewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews {date}'**
  String renewsOn(String date);

  /// No description provided for @subActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subActive;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get manageSubscription;

  /// No description provided for @manageSubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Opens your App Store / Play Store settings'**
  String get manageSubscriptionBody;

  /// No description provided for @manageSubscriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Manage or cancel from your store account settings.'**
  String get manageSubscriptionHint;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @replayTutorial.
  ///
  /// In en, this message translates to:
  /// **'Replay the intro'**
  String get replayTutorial;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @sectionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get sectionLegal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @sectionDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get sectionDeveloper;

  /// No description provided for @premiumDebugOverride.
  ///
  /// In en, this message translates to:
  /// **'Premium (debug override)'**
  String get premiumDebugOverride;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account, scans and images. This cannot be undone.'**
  String get deleteAccountBody;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Coinsights • v{version}'**
  String appVersion(String version);

  /// No description provided for @rankingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Coin rankings'**
  String get rankingsTitle;

  /// No description provided for @rankMostValuable.
  ///
  /// In en, this message translates to:
  /// **'Most valuable'**
  String get rankMostValuable;

  /// No description provided for @rankRarest.
  ///
  /// In en, this message translates to:
  /// **'Rarest'**
  String get rankRarest;

  /// No description provided for @rankKeyDates.
  ///
  /// In en, this message translates to:
  /// **'Key dates'**
  String get rankKeyDates;

  /// No description provided for @rankMostValuableSub.
  ///
  /// In en, this message translates to:
  /// **'The record-setters of the coin world. Extreme rarities — but it shows what a coin can be worth.'**
  String get rankMostValuableSub;

  /// No description provided for @rankRarestSub.
  ///
  /// In en, this message translates to:
  /// **'Coins that almost never come to market.'**
  String get rankRarestSub;

  /// No description provided for @rankKeyDatesSub.
  ///
  /// In en, this message translates to:
  /// **'Ordinary-looking coins with a date or mint mark worth checking your change for.'**
  String get rankKeyDatesSub;

  /// No description provided for @rankLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the rankings.'**
  String get rankLoadError;

  /// No description provided for @rankSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, country, or denomination'**
  String get rankSearchHint;

  /// No description provided for @rankAllCountries.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get rankAllCountries;

  /// No description provided for @rankNoResults.
  ///
  /// In en, this message translates to:
  /// **'No coins match'**
  String get rankNoResults;

  /// No description provided for @rankNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear the country filter.'**
  String get rankNoResultsBody;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get premiumBadge;

  /// No description provided for @paywallTrialFraming.
  ///
  /// In en, this message translates to:
  /// **'7 days free, then {price}. Cancel anytime.'**
  String paywallTrialFraming(String price);

  /// No description provided for @paywallStartTrial.
  ///
  /// In en, this message translates to:
  /// **'Start free trial'**
  String get paywallStartTrial;

  /// No description provided for @ob1Title.
  ///
  /// In en, this message translates to:
  /// **'See what your coin is really worth'**
  String get ob1Title;

  /// No description provided for @ob1Accent.
  ///
  /// In en, this message translates to:
  /// **'really worth'**
  String get ob1Accent;

  /// No description provided for @ob1Sub.
  ///
  /// In en, this message translates to:
  /// **'Never sell for less than it\'s actually worth.'**
  String get ob1Sub;

  /// No description provided for @ob1CoinName.
  ///
  /// In en, this message translates to:
  /// **'Gold Sovereign'**
  String get ob1CoinName;

  /// No description provided for @ob1RefLabel.
  ///
  /// In en, this message translates to:
  /// **'REFERENCE VALUE'**
  String get ob1RefLabel;

  /// No description provided for @ob2Title.
  ///
  /// In en, this message translates to:
  /// **'Valuation spots the rarest 1% of coins'**
  String get ob2Title;

  /// No description provided for @ob2Accent.
  ///
  /// In en, this message translates to:
  /// **'1%'**
  String get ob2Accent;

  /// No description provided for @ob2Sub.
  ///
  /// In en, this message translates to:
  /// **'Mint errors, gold and key dates.'**
  String get ob2Sub;

  /// No description provided for @ob2MeterLabel.
  ///
  /// In en, this message translates to:
  /// **'Extremely rare'**
  String get ob2MeterLabel;

  /// No description provided for @ob2MeterLow.
  ///
  /// In en, this message translates to:
  /// **'Very common'**
  String get ob2MeterLow;

  /// No description provided for @ob2MeterHigh.
  ///
  /// In en, this message translates to:
  /// **'Ultra rare'**
  String get ob2MeterHigh;

  /// No description provided for @ob3Title.
  ///
  /// In en, this message translates to:
  /// **'Track your whole collection\'s value'**
  String get ob3Title;

  /// No description provided for @ob3Accent.
  ///
  /// In en, this message translates to:
  /// **'collection\'s value'**
  String get ob3Accent;

  /// No description provided for @ob3Sub.
  ///
  /// In en, this message translates to:
  /// **'Anytime, anywhere.'**
  String get ob3Sub;

  /// No description provided for @ob4Title.
  ///
  /// In en, this message translates to:
  /// **'Scan, discover, decide'**
  String get ob4Title;

  /// No description provided for @ob4Accent.
  ///
  /// In en, this message translates to:
  /// **'discover'**
  String get ob4Accent;

  /// No description provided for @ob4Sub.
  ///
  /// In en, this message translates to:
  /// **'A few seconds and your camera is all it takes.'**
  String get ob4Sub;

  /// No description provided for @ob4Cta.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get ob4Cta;

  /// No description provided for @ob4Step1.
  ///
  /// In en, this message translates to:
  /// **'Photograph both sides'**
  String get ob4Step1;

  /// No description provided for @ob4Step2.
  ///
  /// In en, this message translates to:
  /// **'We identify the coin'**
  String get ob4Step2;

  /// No description provided for @ob4Step3.
  ///
  /// In en, this message translates to:
  /// **'See its value and rarity'**
  String get ob4Step3;

  /// No description provided for @portfolioLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR PORTFOLIO'**
  String get portfolioLabel;

  /// No description provided for @portfolioCoins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get portfolioCoins;

  /// No description provided for @portfolioCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get portfolioCountries;

  /// No description provided for @portfolioTopCoin.
  ///
  /// In en, this message translates to:
  /// **'Top coin'**
  String get portfolioTopCoin;

  /// No description provided for @sellGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to sell this coin'**
  String get sellGuideTitle;

  /// No description provided for @sellGuideResaleLabel.
  ///
  /// In en, this message translates to:
  /// **'REALISTIC PRIVATE-SALE RANGE'**
  String get sellGuideResaleLabel;

  /// No description provided for @sellGuideResaleNote.
  ///
  /// In en, this message translates to:
  /// **'Our estimate of what a private seller nets — below retail because of buyer premiums, dealer margins and the discount collectors expect on a raw coin.'**
  String get sellGuideResaleNote;

  /// No description provided for @sellGuideDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Ranges are estimated from our valuation model, not actual sale records. A specialist appraisal is worth it before selling anything valuable.'**
  String get sellGuideDisclaimer;

  /// No description provided for @sellGuideUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock {count} more venues and selling tips with PRO'**
  String sellGuideUnlock(int count);

  /// No description provided for @sellTierHigh.
  ///
  /// In en, this message translates to:
  /// **'At this value, get the coin professionally graded (PCGS/NGC) and consign it to a major auction house — the wider bidder pool usually more than covers the seller fee.'**
  String get sellTierHigh;

  /// No description provided for @sellTierMid.
  ///
  /// In en, this message translates to:
  /// **'Sharp, well-lit photos of both sides and an honest grade description are what move mid-value coins. Certification is optional but lifts trust for buyers.'**
  String get sellTierMid;

  /// No description provided for @sellTierLow.
  ///
  /// In en, this message translates to:
  /// **'Everyday coins sell fastest in bulk lots or to a local dealer. Only pay for grading if a specific date/mint mark is the key-date exception.'**
  String get sellTierLow;

  /// No description provided for @sellEbayName.
  ///
  /// In en, this message translates to:
  /// **'eBay'**
  String get sellEbayName;

  /// No description provided for @sellEbayBlurb.
  ///
  /// In en, this message translates to:
  /// **'Largest buyer pool by far. Expect ~13% final-value fee plus payment processing. Best for anything from a few euros up to mid four figures.'**
  String get sellEbayBlurb;

  /// No description provided for @sellHeritageName.
  ///
  /// In en, this message translates to:
  /// **'Heritage Auctions'**
  String get sellHeritageName;

  /// No description provided for @sellHeritageBlurb.
  ///
  /// In en, this message translates to:
  /// **'The biggest numismatic auction house. Worldwide collector reach for rarities; seller commission is negotiable on higher-value consignments.'**
  String get sellHeritageBlurb;

  /// No description provided for @sellStacksName.
  ///
  /// In en, this message translates to:
  /// **'Stack’s Bowers'**
  String get sellStacksName;

  /// No description provided for @sellStacksBlurb.
  ///
  /// In en, this message translates to:
  /// **'Long-established auction house, strong for US and world coins. Like Heritage, best reserved for genuinely scarce material.'**
  String get sellStacksBlurb;

  /// No description provided for @sellCertifiedDealerName.
  ///
  /// In en, this message translates to:
  /// **'Certified coin dealer'**
  String get sellCertifiedDealerName;

  /// No description provided for @sellCertifiedDealerBlurb.
  ///
  /// In en, this message translates to:
  /// **'A quick, clean sale at a wholesale (buy) price — typically 60–80% of retail. No fees, no shipping risk, cash in hand.'**
  String get sellCertifiedDealerBlurb;

  /// No description provided for @sellLocalShopName.
  ///
  /// In en, this message translates to:
  /// **'Local coin shop'**
  String get sellLocalShopName;

  /// No description provided for @sellLocalShopBlurb.
  ///
  /// In en, this message translates to:
  /// **'Immediate offer, no listing hassle. Prices are lower than online but there is no fee and no chance of a chargeback.'**
  String get sellLocalShopBlurb;

  /// No description provided for @sellForumsName.
  ///
  /// In en, this message translates to:
  /// **'Collector forums'**
  String get sellForumsName;

  /// No description provided for @sellForumsBlurb.
  ///
  /// In en, this message translates to:
  /// **'Sites like CoinTalk or NGC/PCGS forums have dedicated buy/sell boards. Lower fees than eBay and knowledgeable buyers, but slower.'**
  String get sellForumsBlurb;

  /// No description provided for @sellCoinShowName.
  ///
  /// In en, this message translates to:
  /// **'Coin show / bourse'**
  String get sellCoinShowName;

  /// No description provided for @sellCoinShowBlurb.
  ///
  /// In en, this message translates to:
  /// **'Dozens of dealers in one room means competing offers. Great for selling a group at once; bring a want-list of your own too.'**
  String get sellCoinShowBlurb;

  /// No description provided for @sellFacebookName.
  ///
  /// In en, this message translates to:
  /// **'Facebook groups'**
  String get sellFacebookName;

  /// No description provided for @sellFacebookBlurb.
  ///
  /// In en, this message translates to:
  /// **'Active local buy/sell/trade groups for common coins. Meet in a safe public place and use protected payments only.'**
  String get sellFacebookBlurb;

  /// No description provided for @typicalRange.
  ///
  /// In en, this message translates to:
  /// **'TYPICAL RANGE'**
  String get typicalRange;

  /// No description provided for @scanYoursToCheck.
  ///
  /// In en, this message translates to:
  /// **'Scan yours to check'**
  String get scanYoursToCheck;

  /// No description provided for @rankYears.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get rankYears;

  /// No description provided for @rankKeyDatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Key dates'**
  String get rankKeyDatesLabel;

  /// No description provided for @yearBc.
  ///
  /// In en, this message translates to:
  /// **'{year} BC'**
  String yearBc(int year);

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errNetwork;

  /// No description provided for @errServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again shortly.'**
  String get errServer;

  /// No description provided for @errUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error. Please try again.'**
  String get errUnknown;

  /// No description provided for @errNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you were looking for.'**
  String get errNotFound;

  /// No description provided for @errAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errAuth;

  /// No description provided for @errScanNotFound.
  ///
  /// In en, this message translates to:
  /// **'That scan could not be found.'**
  String get errScanNotFound;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{m}m ago'**
  String minutesAgo(int m);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{h}h ago'**
  String hoursAgo(int h);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{d}d ago'**
  String daysAgo(int d);

  /// No description provided for @valueDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Coin values are estimates based on available data and may vary depending on condition, authenticity and market demand.'**
  String get valueDisclaimer;

  /// No description provided for @confirmCoinLink.
  ///
  /// In en, this message translates to:
  /// **'Correct the coin details'**
  String get confirmCoinLink;

  /// No description provided for @confirmCoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm what this coin is'**
  String get confirmCoinTitle;

  /// No description provided for @confirmCoinBody.
  ///
  /// In en, this message translates to:
  /// **'The value is only as accurate as the identification. Set the country, type and year and we recalculate it from verified catalogue data.'**
  String get confirmCoinBody;

  /// No description provided for @confirmCoinCta.
  ///
  /// In en, this message translates to:
  /// **'Set the coin details'**
  String get confirmCoinCta;

  /// No description provided for @correctCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Which country?'**
  String get correctCountryTitle;

  /// No description provided for @correctTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Which coin?'**
  String get correctTypeTitle;

  /// No description provided for @correctYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Which year?'**
  String get correctYearTitle;

  /// No description provided for @correctSearchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get correctSearchCountry;

  /// No description provided for @correctYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year on the coin'**
  String get correctYearLabel;

  /// No description provided for @correctYearRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a year between {from} and {to}'**
  String correctYearRange(String from, String to);

  /// No description provided for @correctSave.
  ///
  /// In en, this message translates to:
  /// **'Save and recalculate'**
  String get correctSave;

  /// No description provided for @gradingDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app does not provide professional numismatic authentication or financial advice. Condition estimates are approximate.'**
  String get gradingDisclaimer;

  /// No description provided for @condPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get condPoor;

  /// No description provided for @condFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get condFair;

  /// No description provided for @condGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get condGood;

  /// No description provided for @condVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get condVeryGood;

  /// No description provided for @condFine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get condFine;

  /// No description provided for @condVeryFine.
  ///
  /// In en, this message translates to:
  /// **'Very Fine'**
  String get condVeryFine;

  /// No description provided for @condExtremelyFine.
  ///
  /// In en, this message translates to:
  /// **'Extremely Fine'**
  String get condExtremelyFine;

  /// No description provided for @condUncirculated.
  ///
  /// In en, this message translates to:
  /// **'Uncirculated'**
  String get condUncirculated;

  /// No description provided for @rarCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get rarCommon;

  /// No description provided for @rarUncommon.
  ///
  /// In en, this message translates to:
  /// **'Uncommon'**
  String get rarUncommon;

  /// No description provided for @rarRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rarRare;

  /// No description provided for @rarVeryRare.
  ///
  /// In en, this message translates to:
  /// **'Very Rare'**
  String get rarVeryRare;

  /// No description provided for @rarExtremelyRare.
  ///
  /// In en, this message translates to:
  /// **'Extremely Rare'**
  String get rarExtremelyRare;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'nl', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'nl': return AppLocalizationsNl();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
