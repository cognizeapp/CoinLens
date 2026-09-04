// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTagline => 'Ontdek wat je munten echt waard zijn.';

  @override
  String get actionContinue => 'Doorgaan';

  @override
  String get actionSkip => 'Overslaan';

  @override
  String get actionRetry => 'Opnieuw proberen';

  @override
  String get actionCancel => 'Annuleren';

  @override
  String get actionDelete => 'Verwijderen';

  @override
  String get actionClose => 'Sluiten';

  @override
  String get wordOr => 'of';

  @override
  String get navHome => 'Start';

  @override
  String get navCollection => 'Collectie';

  @override
  String get navScan => 'Scannen';

  @override
  String get navHistory => 'Geschiedenis';

  @override
  String get navProfile => 'Profiel';

  @override
  String get actionShare => 'Delen';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — geschatte waarde $value. Herkend met Coinsight.';
  }

  @override
  String get offlineBanner => 'Offline — opgeslagen scans werken nog';

  @override
  String get onboard1Title => 'Ontdek je munten';

  @override
  String get onboard1Body => 'Scan elke munt en ontdek meteen wat het is.';

  @override
  String get onboard2Title => 'Ontdek wat het waard is';

  @override
  String get onboard2Body => 'Krijg een geschatte marktwaarde op basis van echte data.';

  @override
  String get onboard3Title => 'Ontgrendel AI Coin Intelligence';

  @override
  String get onboard3Body => 'Ontdek het verhaal, de zeldzaamheid en het verkooppotentieel van je munten.';

  @override
  String get onboardStart => 'Beginnen met scannen';

  @override
  String get authSubtitle => 'Log in om je collectie op al je apparaten te synchroniseren.';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Wachtwoord';

  @override
  String get authPassword8 => 'Wachtwoord (min. 8 tekens)';

  @override
  String get authName => 'Naam (optioneel)';

  @override
  String get authForgot => 'Wachtwoord vergeten?';

  @override
  String get authSignIn => 'Inloggen';

  @override
  String get authGoogle => 'Doorgaan met Google';

  @override
  String get authApple => 'Doorgaan met Apple';

  @override
  String get authGuest => 'Verkennen zonder account';

  @override
  String get authNewHere => 'Nieuw hier?';

  @override
  String get authCreate => 'Een account aanmaken';

  @override
  String get authCreateTitle => 'Account aanmaken';

  @override
  String get authCreateCta => 'Account aanmaken';

  @override
  String get authResetSent => 'Als er een account voor dat e-mailadres bestaat, is er een resetlink onderweg.';

  @override
  String get authNoAccountForEmail => 'Geen account gevonden voor dat e-mailadres.';

  @override
  String get authTerms => 'Door door te gaan ga je akkoord met de Servicevoorwaarden en het Privacybeleid van Coinsight.';

  @override
  String get authCreateSyncHint => 'Maak een account aan om je collectie te synchroniseren';

  @override
  String get valEmailEmpty => 'Voer je e-mailadres in';

  @override
  String get valEmailInvalid => 'Voer een geldig e-mailadres in';

  @override
  String get valPasswordEmpty => 'Voer een wachtwoord in';

  @override
  String get valPasswordShort => 'Gebruik minstens 8 tekens';

  @override
  String valFieldRequired(String field) {
    return '$field is verplicht';
  }

  @override
  String get homeWelcome => 'Welkom';

  @override
  String homeWelcomeNamed(String name) {
    return 'Welkom, $name';
  }

  @override
  String get howItWorks => 'Hoe het werkt';

  @override
  String get howItWorksScan => 'Scannen';

  @override
  String get howItWorksScanBody => 'Fotografeer de voor- en achterkant van je munt.';

  @override
  String get howItWorksIdentify => 'Herkennen';

  @override
  String get howItWorksIdentifyBody => 'We vergelijken hem met muntdatabases.';

  @override
  String get howItWorksValue => 'Waarderen';

  @override
  String get howItWorksValueBody => 'Bekijk een geschatte marktwaardebandbreedte.';

  @override
  String get mostValuableCoins => 'Meest waardevolle munten';

  @override
  String get seeAll => 'Alles bekijken';

  @override
  String get recentScans => 'Recente scans';

  @override
  String get noScansYet => 'Nog geen scans';

  @override
  String get noScansYetBody => 'Je gescande munten verschijnen hier.';

  @override
  String get unlockBannerTitle => 'Ontgrendel AI Coin Intelligence';

  @override
  String get unlockBannerBody => 'Geschiedenis, zeldzaamheid, conditie en hoe je hem verkoopt.';

  @override
  String get scanTitle => 'Een munt scannen';

  @override
  String get scanReset => 'Opnieuw instellen';

  @override
  String get scanFront => 'Scan de voorkant';

  @override
  String get scanFrontShort => 'Voorkant';

  @override
  String get scanBack => 'Scan de achterkant (optioneel)';

  @override
  String get scanBackShort => 'Achterkant';

  @override
  String get forBestResult => 'Voor het beste resultaat';

  @override
  String get tipPlainBackground => 'Leg de munt op een egale achtergrond.';

  @override
  String get tipWholeCoin => 'Zorg dat de hele munt zichtbaar is.';

  @override
  String get tipLighting => 'Gebruik goed, gelijkmatig licht.';

  @override
  String get tipGlare => 'Vermijd schittering en weerspiegelingen.';

  @override
  String get identifyCoin => 'Munt herkennen';

  @override
  String get takePhoto => 'Een foto maken';

  @override
  String get uploadFromLibrary => 'Uploaden vanuit galerij';

  @override
  String get couldNotOpenImage => 'Kan die afbeelding niet openen. Controleer de fotomachtigingen in Instellingen.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Tik om opnieuw te maken · $issue';
  }

  @override
  String get cameraPromptFront => 'Scan de voorkant van je munt';

  @override
  String get cameraPromptBack => 'Scan de achterkant van je munt';

  @override
  String get cameraHint => 'Vul de cirkel · egale achtergrond · stille handen';

  @override
  String get cameraAccessOffTitle => 'Cameratoegang staat uit';

  @override
  String get cameraAccessOffBody => 'Schakel cameratoegang voor Coinsight in bij de instellingen van je apparaat en kom terug om te scannen. Je kunt ook een foto uploaden.';

  @override
  String get cameraUsePhotoInstead => 'Een foto gebruiken';

  @override
  String get cameraNoneTitle => 'Geen camera beschikbaar';

  @override
  String get cameraNoneBody => 'Dit apparaat heeft geen bruikbare camera. Upload een foto.';

  @override
  String get cameraUploadPhoto => 'Een foto uploaden';

  @override
  String get cameraCaptureFailed => 'Kan de foto niet maken. Probeer het opnieuw.';

  @override
  String get qualityRetakeNeeded => 'Opnieuw maken nodig';

  @override
  String get qualityCouldBeBetter => 'Deze foto kan beter';

  @override
  String get qualityRetake => 'Opnieuw maken';

  @override
  String get qualityUseAnyway => 'Deze foto toch gebruiken';

  @override
  String get issueLowResShort => 'Lage resolutie';

  @override
  String get issueLowResFull => 'Deze afbeelding is te klein. Gebruik je camera op volledige kwaliteit of kies een grotere foto.';

  @override
  String get issueTooDarkShort => 'Te donker';

  @override
  String get issueTooDarkFull => 'De foto is te donker. Ga naar helderder, gelijkmatig licht.';

  @override
  String get issueTooBrightShort => 'Overbelicht';

  @override
  String get issueTooBrightFull => 'De foto is overbelicht. Verminder direct licht of ga uit de schittering.';

  @override
  String get issueBlurryShort => 'Wazig';

  @override
  String get issueBlurryFull => 'De afbeelding is te wazig. Houd de telefoon stil, tik om scherp te stellen en zorg dat de munt scherp is.';

  @override
  String get issueGlareShort => 'Weerspiegelingen';

  @override
  String get issueGlareFull => 'Er zitten sterke weerspiegelingen op de munt. Kantel hem iets of gebruik zachter, indirect licht.';

  @override
  String get issueNoCoinShort => 'Geen munt gedetecteerd';

  @override
  String get issueNoCoinFull => 'We konden geen munt vinden. Leg één munt op een egale achtergrond die het grootste deel van het beeld vult.';

  @override
  String get issueCoinSmallShort => 'Munt te klein';

  @override
  String get issueCoinSmallFull => 'Ga dichterbij zodat de munt het grootste deel van de cirkel vult.';

  @override
  String get issueMultipleShort => 'Meerdere objecten';

  @override
  String get issueMultipleFull => 'We hebben meer dan één object gedetecteerd. Scan één munt tegelijk.';

  @override
  String get analyzingCoin => 'Munt analyseren…';

  @override
  String get stageDetectingText => 'Tekst detecteren';

  @override
  String get stageIdentifyingCountry => 'Land bepalen';

  @override
  String get stageDetectingYear => 'Jaartal detecteren';

  @override
  String get stageSearchingDatabase => 'Muntdatabase doorzoeken';

  @override
  String get stageCalculatingValue => 'Waarde berekenen';

  @override
  String get resultTitle => 'Muntresultaat';

  @override
  String get loadingResult => 'Resultaat laden…';

  @override
  String get resultOpenError => 'We konden dit resultaat niet openen.';

  @override
  String confidenceValue(String percent) {
    return '$percent zekerheid';
  }

  @override
  String get estimatedMarketValue => 'GESCHATTE MARKTWAARDE';

  @override
  String typicalEstimate(String value) {
    return 'Typische schatting $value';
  }

  @override
  String get whatAffectsValue => 'Wat deze waarde beïnvloedt';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count meer in de volledige waardeanalyse';
  }

  @override
  String get notConfidentMatch => 'Geen zekere overeenkomst';

  @override
  String get notConfidentBody => 'We konden deze munt niet met zekerheid herkennen. Mogelijke overeenkomsten:';

  @override
  String get detailCountry => 'Land';

  @override
  String get detailYear => 'Jaar';

  @override
  String get detailDenomination => 'Denominatie';

  @override
  String get detailMaterial => 'Materiaal';

  @override
  String get detailMint => 'Munt (mint)';

  @override
  String get detailDiameter => 'Diameter';

  @override
  String get detailWeight => 'Gewicht';

  @override
  String get detailConditionEst => 'Conditie (schatting)';

  @override
  String get detailRarityEst => 'Zeldzaamheid (schatting)';

  @override
  String get saveToCollection => 'Opslaan in collectie';

  @override
  String get savedToCollection => 'Opgeslagen in je collectie';

  @override
  String get unlockAiTitle => 'Ontgrendel AI Coin Intelligence';

  @override
  String get aiFeatHistory => 'De volledige geschiedenis';

  @override
  String get aiFeatValue => 'Waarom verzamelaars hem waarderen';

  @override
  String get aiFeatRarity => 'Zeldzaamheidsanalyse';

  @override
  String get aiFeatCondition => 'Conditie-analyse';

  @override
  String get aiFeatSelling => 'Hoe je hem verkoopt';

  @override
  String get unlockPremium => 'Premium ontgrendelen';

  @override
  String get aiCoinIntelligence => 'AI Coin Intelligence';

  @override
  String get generateAiAnalysis => 'AI-analyse genereren';

  @override
  String get askAiAssistant => 'Vraag het de AI-assistent';

  @override
  String get aiCtaHistory => 'Muntverhaal en historische context';

  @override
  String get aiCtaValue => 'Waarom hij waarde heeft, factor voor factor';

  @override
  String get aiCtaRarityCondition => 'Zeldzaamheids- en conditie-analyse';

  @override
  String get aiCtaSelling => 'Verkoopstrategie en prijs';

  @override
  String get coinStory => 'Muntverhaal';

  @override
  String get whyItHasValue => 'Waarom hij waarde heeft';

  @override
  String get rarityAnalysis => 'Zeldzaamheidsanalyse';

  @override
  String get conditionEstimate => 'Conditieschatting';

  @override
  String get sellingRecommendations => 'Verkoopadviezen';

  @override
  String get collectorInsights => 'Inzichten voor verzamelaars';

  @override
  String get generatingAnalysis => 'Je AI-muntanalyse wordt gegenereerd…';

  @override
  String get aiUnavailable => 'De AI-analyse is tijdelijk niet beschikbaar.';

  @override
  String get estimatedSellingPrice => 'Geschatte verkoopprijs';

  @override
  String get suggestedListingPrice => 'Voorgestelde vraagprijs';

  @override
  String get minimumReasonablePrice => 'Redelijke minimumprijs';

  @override
  String get whereToSell => 'Waar te verkopen';

  @override
  String get auctionSuitable => 'Geschikt voor een veiling?';

  @override
  String get professionalAppraisal => 'Professionele taxatie';

  @override
  String get aiAssistantTitle => 'AI-muntassistent';

  @override
  String aiTalkingAbout(String coin) {
    return 'Over: $coin';
  }

  @override
  String get aiAskHint => 'Stel een vraag over deze munt…';

  @override
  String get aiAssistantIntro => 'Vraag de assistent alles over deze munt';

  @override
  String get aiCouldNotOpen => 'Kan deze munt niet openen.';

  @override
  String get qWhyValuable => 'Waarom is deze munt waardevol?';

  @override
  String get qIsRare => 'Is deze munt zeldzaam?';

  @override
  String get qWhereSell => 'Waar moet ik hem verkopen?';

  @override
  String get qAuthenticate => 'Moet ik deze munt laten authenticeren?';

  @override
  String get qHowMuchList => 'Voor welke prijs moet ik hem aanbieden?';

  @override
  String get paywallHeadline => 'Ontgrendel het volledige verhaal achter elke munt';

  @override
  String get paywallSubheadline => 'Ontdek de geschiedenis, de zeldzaamheid en de beste manier om je munten te verkopen.';

  @override
  String get featAiAnalysis => 'Gedetailleerde AI-analyse';

  @override
  String get featCoinHistory => 'Muntgeschiedenis';

  @override
  String get featRarityInsights => 'Inzichten over zeldzaamheid';

  @override
  String get featConditionAnalysis => 'Conditie-analyse';

  @override
  String get featSellingRecs => 'Verkoopadviezen';

  @override
  String get featCollectorInsights => 'Inzichten voor verzamelaars';

  @override
  String get featAiAssistant => 'AI-muntassistent';

  @override
  String get featAdvancedStats => 'Geavanceerde collectiestatistieken';

  @override
  String get planYearly => 'Jaarlijks';

  @override
  String get planMonthly => 'Maandelijks';

  @override
  String get planPerYear => 'per jaar';

  @override
  String get planPerMonth => 'per maand';

  @override
  String get bestValue => 'BESTE KEUZE';

  @override
  String get trial7Days => '7 dagen gratis proberen';

  @override
  String get paywallLegal => 'Het abonnement wordt automatisch verlengd tot je opzegt. Je kunt het op elk moment beheren of opzeggen in je store-account.';

  @override
  String get paywallLoadError => 'Kan de abonnementsopties niet laden.';

  @override
  String get restorePurchases => 'Aankopen herstellen';

  @override
  String get collectionTitle => 'Collectie';

  @override
  String get collectionEmpty => 'Je collectie is leeg';

  @override
  String get collectionEmptyBody => 'Sla een gescande munt op om hem hier toe te voegen.';

  @override
  String get scanACoin => 'Een munt scannen';

  @override
  String get searchCoinCountry => 'Zoek op munt of land';

  @override
  String get sortRecent => 'Recent';

  @override
  String get sortValueHigh => 'Waarde ↓';

  @override
  String get sortRarity => 'Zeldzaamheid';

  @override
  String get filterRarity => 'Zeldzaamheid';

  @override
  String get filterCountry => 'Land';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterByRarity => 'Filter op zeldzaamheid';

  @override
  String get filterByCountry => 'Filter op land';

  @override
  String get noMatchFilters => 'Geen munten voldoen aan die filters';

  @override
  String get statCoins => 'Munten';

  @override
  String get statEstValue => 'Gesch. waarde';

  @override
  String get statMostValuable => 'Meest waardevol';

  @override
  String rarestLabel(String name, String rarity) {
    return 'Zeldzaamste: $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'Kan je collectie niet laden.';

  @override
  String get historyTitle => 'Geschiedenis';

  @override
  String get historyEmpty => 'Nog niets gescand';

  @override
  String get historyEmptyBody => 'Scan een munt om je geschiedenis op te bouwen.';

  @override
  String get historyLoadError => 'Kan je scangeschiedenis niet laden.';

  @override
  String get profileTitle => 'Profiel';

  @override
  String get profileGuest => 'Gast';

  @override
  String get sectionSubscription => 'Abonnement';

  @override
  String get coinsightPremium => 'Coinsight Premium';

  @override
  String get freePlan => 'Gratis abonnement';

  @override
  String renewsOn(String date) {
    return 'Wordt verlengd op $date';
  }

  @override
  String get subActive => 'Actief';

  @override
  String get manageSubscription => 'Abonnement beheren';

  @override
  String get manageSubscriptionBody => 'Opent de instellingen van App Store / Play Store';

  @override
  String get manageSubscriptionHint => 'Beheer of zeg op via de instellingen van je store-account.';

  @override
  String get sectionPreferences => 'Voorkeuren';

  @override
  String get currencyLabel => 'Valuta';

  @override
  String get languageLabel => 'Taal';

  @override
  String get languageSystem => 'Systeemstandaard';

  @override
  String get sectionLegal => 'Juridisch';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get termsOfService => 'Servicevoorwaarden';

  @override
  String get sectionDeveloper => 'Ontwikkelaar';

  @override
  String get premiumDebugOverride => 'Premium (debug-override)';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountTitle => 'Account verwijderen?';

  @override
  String get deleteAccountBody => 'Hiermee worden je account, scans en afbeeldingen permanent verwijderd. Dit kan niet ongedaan worden gemaakt.';

  @override
  String appVersion(String version) {
    return 'Coinsight • v$version';
  }

  @override
  String get rankingsTitle => 'Muntranglijsten';

  @override
  String get rankMostValuable => 'Meest waardevol';

  @override
  String get rankRarest => 'Zeldzaamst';

  @override
  String get rankKeyDates => 'Sleuteljaren';

  @override
  String get rankMostValuableSub => 'De recordhouders van de muntwereld. Extreme zeldzaamheden — maar ze laten zien wat een munt waard kan zijn.';

  @override
  String get rankRarestSub => 'Munten die vrijwel nooit op de markt komen.';

  @override
  String get rankKeyDatesSub => 'Gewoon ogende munten met een jaartal of muntteken waarvoor het de moeite waard is je wisselgeld te controleren.';

  @override
  String get rankLoadError => 'Kan de ranglijsten niet laden.';

  @override
  String get typicalRange => 'TYPISCHE BANDBREEDTE';

  @override
  String get scanYoursToCheck => 'Scan de jouwe om te controleren';

  @override
  String get rankYears => 'Jaren';

  @override
  String get rankKeyDatesLabel => 'Sleuteljaren';

  @override
  String yearBc(int year) {
    return '$year v.Chr.';
  }

  @override
  String get errNetwork => 'Geen internetverbinding. Controleer je netwerk en probeer het opnieuw.';

  @override
  String get errServer => 'Er ging iets mis aan onze kant. Probeer het zo meteen opnieuw.';

  @override
  String get errUnknown => 'Onverwachte fout. Probeer het opnieuw.';

  @override
  String get errNotFound => 'We konden niet vinden wat je zocht.';

  @override
  String get errAuth => 'Authenticatie mislukt. Probeer het opnieuw.';

  @override
  String get errScanNotFound => 'Die scan is niet gevonden.';

  @override
  String get justNow => 'Zojuist';

  @override
  String minutesAgo(int m) {
    return '$m min geleden';
  }

  @override
  String hoursAgo(int h) {
    return '$h u geleden';
  }

  @override
  String daysAgo(int d) {
    return '$d d geleden';
  }

  @override
  String get valueDisclaimer => 'Muntwaarden zijn schattingen op basis van beschikbare gegevens en kunnen variëren afhankelijk van conditie, echtheid en marktvraag.';

  @override
  String get gradingDisclaimer => 'Deze app biedt geen professionele numismatische authenticatie of financieel advies. Conditieschattingen zijn bij benadering.';

  @override
  String get condPoor => 'Zeer slecht (ZG)';

  @override
  String get condFair => 'Slecht (G)';

  @override
  String get condGood => 'Fraai (Fr)';

  @override
  String get condVeryGood => 'Zeer Fraai (ZF)';

  @override
  String get condFine => 'Prachtig (Pr)';

  @override
  String get condVeryFine => 'Zeer Prachtig (ZPr)';

  @override
  String get condExtremelyFine => 'Vrijwel FDC';

  @override
  String get condUncirculated => 'FDC (Fleur de Coin)';

  @override
  String get rarCommon => 'Algemeen';

  @override
  String get rarUncommon => 'Minder algemeen';

  @override
  String get rarRare => 'Zeldzaam';

  @override
  String get rarVeryRare => 'Zeer zeldzaam';

  @override
  String get rarExtremelyRare => 'Uiterst zeldzaam';
}
