// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTagline => 'Finde heraus, was deine Münzen wirklich wert sind.';

  @override
  String get actionContinue => 'Weiter';

  @override
  String get actionSkip => 'Überspringen';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get wordOr => 'oder';

  @override
  String get navHome => 'Start';

  @override
  String get navCollection => 'Sammlung';

  @override
  String get navScan => 'Scannen';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navProfile => 'Profil';

  @override
  String get actionShare => 'Teilen';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — geschätzter Wert $value. Bestimmt mit Coinsight.';
  }

  @override
  String get offlineBanner => 'Offline — gespeicherte Scans funktionieren weiter';

  @override
  String get onboard1Title => 'Entdecke deine Münzen';

  @override
  String get onboard1Body => 'Scanne jede Münze und erfahre sofort, worum es sich handelt.';

  @override
  String get onboard2Title => 'Finde heraus, was sie wert ist';

  @override
  String get onboard2Body => 'Erhalte einen geschätzten Marktwert auf Basis echter Daten.';

  @override
  String get onboard3Title => 'Schalte die AI Coin Intelligence frei';

  @override
  String get onboard3Body => 'Entdecke die Geschichte, Seltenheit und das Verkaufspotenzial deiner Münzen.';

  @override
  String get onboardStart => 'Scannen starten';

  @override
  String get authSubtitle => 'Melde dich an, um deine Sammlung geräteübergreifend zu synchronisieren.';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authPassword8 => 'Passwort (mind. 8 Zeichen)';

  @override
  String get authName => 'Name (optional)';

  @override
  String get authForgot => 'Passwort vergessen?';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authGoogle => 'Mit Google fortfahren';

  @override
  String get authApple => 'Mit Apple fortfahren';

  @override
  String get authGuest => 'Ohne Konto erkunden';

  @override
  String get authNewHere => 'Neu hier?';

  @override
  String get authCreate => 'Konto erstellen';

  @override
  String get authCreateTitle => 'Konto erstellen';

  @override
  String get authCreateCta => 'Konto erstellen';

  @override
  String get authResetSent => 'Falls für diese E-Mail ein Konto besteht, ist ein Link zum Zurücksetzen unterwegs.';

  @override
  String get authNoAccountForEmail => 'Für diese E-Mail wurde kein Konto gefunden.';

  @override
  String get authTerms => 'Mit dem Fortfahren stimmst du den Nutzungsbedingungen und der Datenschutzerklärung von Coinsight zu.';

  @override
  String get authCreateSyncHint => 'Erstelle ein Konto, um deine Sammlung zu synchronisieren';

  @override
  String get valEmailEmpty => 'Gib deine E-Mail-Adresse ein';

  @override
  String get valEmailInvalid => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get valPasswordEmpty => 'Gib ein Passwort ein';

  @override
  String get valPasswordShort => 'Verwende mindestens 8 Zeichen';

  @override
  String valFieldRequired(String field) {
    return '$field ist erforderlich';
  }

  @override
  String get homeWelcome => 'Willkommen';

  @override
  String homeWelcomeNamed(String name) {
    return 'Willkommen, $name';
  }

  @override
  String get howItWorks => 'So funktioniert\'s';

  @override
  String get howItWorksScan => 'Scannen';

  @override
  String get howItWorksScanBody => 'Fotografiere Vorder- und Rückseite deiner Münze.';

  @override
  String get howItWorksIdentify => 'Bestimmen';

  @override
  String get howItWorksIdentifyBody => 'Wir gleichen sie mit Münzdatenbanken ab.';

  @override
  String get howItWorksValue => 'Bewerten';

  @override
  String get howItWorksValueBody => 'Sieh dir eine geschätzte Marktwertspanne an.';

  @override
  String get mostValuableCoins => 'Wertvollste Münzen';

  @override
  String get seeAll => 'Alle ansehen';

  @override
  String get recentScans => 'Letzte Scans';

  @override
  String get noScansYet => 'Noch keine Scans';

  @override
  String get noScansYetBody => 'Deine gescannten Münzen erscheinen hier.';

  @override
  String get unlockBannerTitle => 'Schalte die AI Coin Intelligence frei';

  @override
  String get unlockBannerBody => 'Geschichte, Seltenheit, Zustand und wie du sie verkaufst.';

  @override
  String get scanTitle => 'Münze scannen';

  @override
  String get scanReset => 'Zurücksetzen';

  @override
  String get scanFront => 'Vorderseite scannen';

  @override
  String get scanFrontShort => 'Vorderseite';

  @override
  String get scanBack => 'Rückseite scannen (optional)';

  @override
  String get scanBackShort => 'Rückseite';

  @override
  String get forBestResult => 'Für das beste Ergebnis';

  @override
  String get tipPlainBackground => 'Lege die Münze auf einen schlichten Hintergrund.';

  @override
  String get tipWholeCoin => 'Achte darauf, dass die ganze Münze sichtbar ist.';

  @override
  String get tipLighting => 'Sorge für gutes, gleichmäßiges Licht.';

  @override
  String get tipGlare => 'Vermeide Blendung und Reflexionen.';

  @override
  String get identifyCoin => 'Münze bestimmen';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get uploadFromLibrary => 'Aus der Galerie hochladen';

  @override
  String get couldNotOpenImage => 'Bild konnte nicht geöffnet werden. Prüfe die Fotoberechtigungen in den Einstellungen.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Zum Wiederholen tippen · $issue';
  }

  @override
  String get cameraPromptFront => 'Scanne die Vorderseite deiner Münze';

  @override
  String get cameraPromptBack => 'Scanne die Rückseite deiner Münze';

  @override
  String get cameraHint => 'Kreis ausfüllen · schlichter Hintergrund · ruhige Hand';

  @override
  String get cameraAccessOffTitle => 'Kamerazugriff ist deaktiviert';

  @override
  String get cameraAccessOffBody => 'Aktiviere den Kamerazugriff für Coinsight in den Geräteeinstellungen und komm zum Scannen zurück. Du kannst auch ein Foto hochladen.';

  @override
  String get cameraUsePhotoInstead => 'Foto verwenden';

  @override
  String get cameraNoneTitle => 'Keine Kamera verfügbar';

  @override
  String get cameraNoneBody => 'Dieses Gerät hat keine nutzbare Kamera. Lade ein Foto hoch.';

  @override
  String get cameraUploadPhoto => 'Foto hochladen';

  @override
  String get cameraCaptureFailed => 'Foto konnte nicht aufgenommen werden. Versuche es erneut.';

  @override
  String get qualityRetakeNeeded => 'Neu aufnehmen nötig';

  @override
  String get qualityCouldBeBetter => 'Dieses Foto könnte besser sein';

  @override
  String get qualityRetake => 'Neu aufnehmen';

  @override
  String get qualityUseAnyway => 'Dieses Foto trotzdem verwenden';

  @override
  String get issueLowResShort => 'Niedrige Auflösung';

  @override
  String get issueLowResFull => 'Dieses Bild ist zu klein. Nutze die Kamera in voller Qualität oder wähle ein größeres Foto.';

  @override
  String get issueTooDarkShort => 'Zu dunkel';

  @override
  String get issueTooDarkFull => 'Das Foto ist zu dunkel. Wechsle zu hellerem, gleichmäßigem Licht.';

  @override
  String get issueTooBrightShort => 'Überbelichtet';

  @override
  String get issueTooBrightFull => 'Das Foto ist überbelichtet. Verringere direktes Licht oder weiche Reflexionen aus.';

  @override
  String get issueBlurryShort => 'Unscharf';

  @override
  String get issueBlurryFull => 'Das Bild ist zu unscharf. Halte das Telefon ruhig, tippe zum Fokussieren und achte darauf, dass die Münze scharf ist.';

  @override
  String get issueGlareShort => 'Reflexionen';

  @override
  String get issueGlareFull => 'Es gibt starke Reflexionen auf der Münze. Kippe sie leicht oder nutze weicheres, indirektes Licht.';

  @override
  String get issueNoCoinShort => 'Keine Münze erkannt';

  @override
  String get issueNoCoinFull => 'Wir konnten keine Münze finden. Lege eine einzelne Münze auf einen schlichten Hintergrund, der den Großteil des Bildes ausfüllt.';

  @override
  String get issueCoinSmallShort => 'Münze zu klein';

  @override
  String get issueCoinSmallFull => 'Geh näher heran, damit die Münze den Großteil des Kreises ausfüllt.';

  @override
  String get issueMultipleShort => 'Mehrere Objekte';

  @override
  String get issueMultipleFull => 'Wir haben mehr als ein Objekt erkannt. Scanne immer nur eine Münze.';

  @override
  String get analyzingCoin => 'Münze wird analysiert…';

  @override
  String get stageDetectingText => 'Text wird erkannt';

  @override
  String get stageIdentifyingCountry => 'Land wird bestimmt';

  @override
  String get stageDetectingYear => 'Jahr wird erkannt';

  @override
  String get stageSearchingDatabase => 'Münzdatenbank wird durchsucht';

  @override
  String get stageCalculatingValue => 'Wert wird berechnet';

  @override
  String get resultTitle => 'Münzergebnis';

  @override
  String get loadingResult => 'Ergebnis wird geladen…';

  @override
  String get resultOpenError => 'Dieses Ergebnis konnte nicht geöffnet werden.';

  @override
  String confidenceValue(String percent) {
    return '$percent Sicherheit';
  }

  @override
  String get estimatedMarketValue => 'GESCHÄTZTER MARKTWERT';

  @override
  String typicalEstimate(String value) {
    return 'Typische Schätzung $value';
  }

  @override
  String get whatAffectsValue => 'Was diesen Wert beeinflusst';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count weitere in der vollständigen Wertanalyse';
  }

  @override
  String get notConfidentMatch => 'Keine sichere Übereinstimmung';

  @override
  String get notConfidentBody => 'Wir konnten diese Münze nicht sicher bestimmen. Mögliche Übereinstimmungen:';

  @override
  String get detailCountry => 'Land';

  @override
  String get detailYear => 'Jahr';

  @override
  String get detailDenomination => 'Nennwert';

  @override
  String get detailMaterial => 'Material';

  @override
  String get detailMint => 'Münzstätte';

  @override
  String get detailDiameter => 'Durchmesser';

  @override
  String get detailWeight => 'Gewicht';

  @override
  String get detailConditionEst => 'Zustand (geschätzt)';

  @override
  String get detailRarityEst => 'Seltenheit (geschätzt)';

  @override
  String get saveToCollection => 'In Sammlung speichern';

  @override
  String get savedToCollection => 'In deiner Sammlung gespeichert';

  @override
  String get unlockAiTitle => 'Schalte die AI Coin Intelligence frei';

  @override
  String get aiFeatHistory => 'Die vollständige Geschichte';

  @override
  String get aiFeatValue => 'Warum Sammler sie schätzen';

  @override
  String get aiFeatRarity => 'Seltenheitsanalyse';

  @override
  String get aiFeatCondition => 'Zustandsanalyse';

  @override
  String get aiFeatSelling => 'Wie du sie verkaufst';

  @override
  String get unlockPremium => 'Premium freischalten';

  @override
  String get aiCoinIntelligence => 'AI Coin Intelligence';

  @override
  String get generateAiAnalysis => 'KI-Analyse erstellen';

  @override
  String get askAiAssistant => 'KI-Assistenten fragen';

  @override
  String get aiCtaHistory => 'Münzgeschichte und historischer Kontext';

  @override
  String get aiCtaValue => 'Warum sie Wert hat, Faktor für Faktor';

  @override
  String get aiCtaRarityCondition => 'Seltenheits- und Zustandsanalyse';

  @override
  String get aiCtaSelling => 'Verkaufsstrategie und Preis';

  @override
  String get coinStory => 'Münzgeschichte';

  @override
  String get whyItHasValue => 'Warum sie Wert hat';

  @override
  String get rarityAnalysis => 'Seltenheitsanalyse';

  @override
  String get conditionEstimate => 'Zustandsschätzung';

  @override
  String get sellingRecommendations => 'Verkaufsempfehlungen';

  @override
  String get collectorInsights => 'Sammler-Einblicke';

  @override
  String get generatingAnalysis => 'KI-Münzanalyse wird erstellt…';

  @override
  String get aiUnavailable => 'Die KI-Analyse ist vorübergehend nicht verfügbar.';

  @override
  String get estimatedSellingPrice => 'Geschätzter Verkaufspreis';

  @override
  String get suggestedListingPrice => 'Empfohlener Angebotspreis';

  @override
  String get minimumReasonablePrice => 'Vernünftiger Mindestpreis';

  @override
  String get whereToSell => 'Wo verkaufen';

  @override
  String get auctionSuitable => 'Für eine Auktion geeignet?';

  @override
  String get professionalAppraisal => 'Professionelle Begutachtung';

  @override
  String get aiAssistantTitle => 'KI-Münzassistent';

  @override
  String aiTalkingAbout(String coin) {
    return 'Thema: $coin';
  }

  @override
  String get aiAskHint => 'Frag etwas zu dieser Münze…';

  @override
  String get aiAssistantIntro => 'Frag den Assistenten alles über diese Münze';

  @override
  String get aiCouldNotOpen => 'Diese Münze konnte nicht geöffnet werden.';

  @override
  String get qWhyValuable => 'Warum ist diese Münze wertvoll?';

  @override
  String get qIsRare => 'Ist diese Münze selten?';

  @override
  String get qWhereSell => 'Wo sollte ich sie verkaufen?';

  @override
  String get qAuthenticate => 'Sollte ich diese Münze authentifizieren lassen?';

  @override
  String get qHowMuchList => 'Zu welchem Preis sollte ich sie anbieten?';

  @override
  String get paywallHeadline => 'Entdecke die ganze Geschichte hinter jeder Münze';

  @override
  String get paywallSubheadline => 'Erfahre die Geschichte, die Seltenheit und den besten Weg, deine Münzen zu verkaufen.';

  @override
  String get featAiAnalysis => 'Detaillierte KI-Analyse';

  @override
  String get featCoinHistory => 'Münzgeschichte';

  @override
  String get featRarityInsights => 'Einblicke zur Seltenheit';

  @override
  String get featConditionAnalysis => 'Zustandsanalyse';

  @override
  String get featSellingRecs => 'Verkaufsempfehlungen';

  @override
  String get featCollectorInsights => 'Sammler-Einblicke';

  @override
  String get featAiAssistant => 'KI-Münzassistent';

  @override
  String get featAdvancedStats => 'Erweiterte Sammlungsstatistiken';

  @override
  String get planYearly => 'Jährlich';

  @override
  String get planMonthly => 'Monatlich';

  @override
  String get planPerYear => 'pro Jahr';

  @override
  String get planPerMonth => 'pro Monat';

  @override
  String get bestValue => 'BESTES ANGEBOT';

  @override
  String get trial7Days => '7 Tage kostenlos testen';

  @override
  String get paywallLegal => 'Das Abo verlängert sich automatisch, bis es gekündigt wird. Du kannst es jederzeit in deinem Store-Konto verwalten oder kündigen.';

  @override
  String get paywallLoadError => 'Abo-Optionen konnten nicht geladen werden.';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get collectionTitle => 'Sammlung';

  @override
  String get collectionEmpty => 'Deine Sammlung ist leer';

  @override
  String get collectionEmptyBody => 'Speichere eine gescannte Münze, um sie hier hinzuzufügen.';

  @override
  String get scanACoin => 'Münze scannen';

  @override
  String get searchCoinCountry => 'Nach Münze oder Land suchen';

  @override
  String get sortRecent => 'Neueste';

  @override
  String get sortValueHigh => 'Wert ↓';

  @override
  String get sortRarity => 'Seltenheit';

  @override
  String get filterRarity => 'Seltenheit';

  @override
  String get filterCountry => 'Land';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterByRarity => 'Nach Seltenheit filtern';

  @override
  String get filterByCountry => 'Nach Land filtern';

  @override
  String get noMatchFilters => 'Keine Münze passt zu diesen Filtern';

  @override
  String get statCoins => 'Münzen';

  @override
  String get statEstValue => 'Gesch. Wert';

  @override
  String get statMostValuable => 'Wertvollste';

  @override
  String rarestLabel(String name, String rarity) {
    return 'Seltenste: $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'Deine Sammlung konnte nicht geladen werden.';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historyEmpty => 'Noch nichts gescannt';

  @override
  String get historyEmptyBody => 'Scanne eine Münze, um deinen Verlauf zu starten.';

  @override
  String get historyLoadError => 'Der Scan-Verlauf konnte nicht geladen werden.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGuest => 'Gast';

  @override
  String get sectionSubscription => 'Abo';

  @override
  String get coinsightPremium => 'Coinsight Premium';

  @override
  String get freePlan => 'Kostenloser Plan';

  @override
  String renewsOn(String date) {
    return 'Verlängert sich am $date';
  }

  @override
  String get subActive => 'Aktiv';

  @override
  String get manageSubscription => 'Abo verwalten';

  @override
  String get manageSubscriptionBody => 'Öffnet die Einstellungen des App Store / Play Store';

  @override
  String get manageSubscriptionHint => 'Verwalte oder kündige über die Einstellungen deines Store-Kontos.';

  @override
  String get sectionPreferences => 'Einstellungen';

  @override
  String get currencyLabel => 'Währung';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get sectionLegal => 'Rechtliches';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get sectionDeveloper => 'Entwickler';

  @override
  String get premiumDebugOverride => 'Premium (Debug-Override)';

  @override
  String get signOut => 'Abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountBody => 'Dadurch werden dein Konto, deine Scans und deine Bilder dauerhaft gelöscht. Das kann nicht rückgängig gemacht werden.';

  @override
  String appVersion(String version) {
    return 'Coinsight • v$version';
  }

  @override
  String get rankingsTitle => 'Münz-Rankings';

  @override
  String get rankMostValuable => 'Wertvollste';

  @override
  String get rankRarest => 'Seltenste';

  @override
  String get rankKeyDates => 'Schlüsseldaten';

  @override
  String get rankMostValuableSub => 'Die Rekordhalter der Münzwelt. Extreme Raritäten – aber sie zeigen, was eine Münze wert sein kann.';

  @override
  String get rankRarestSub => 'Münzen, die fast nie auf den Markt kommen.';

  @override
  String get rankKeyDatesSub => 'Gewöhnlich aussehende Münzen mit einem Jahrgang oder Münzzeichen, für das sich ein Blick ins Kleingeld lohnt.';

  @override
  String get rankLoadError => 'Die Rankings konnten nicht geladen werden.';

  @override
  String get typicalRange => 'TYPISCHE SPANNE';

  @override
  String get scanYoursToCheck => 'Scanne deine, um zu prüfen';

  @override
  String get rankYears => 'Jahre';

  @override
  String get rankKeyDatesLabel => 'Schlüsseldaten';

  @override
  String yearBc(int year) {
    return '$year v. Chr.';
  }

  @override
  String get errNetwork => 'Keine Internetverbindung. Prüfe dein Netzwerk und versuche es erneut.';

  @override
  String get errServer => 'Auf unserer Seite ist etwas schiefgelaufen. Versuche es gleich noch einmal.';

  @override
  String get errUnknown => 'Unerwarteter Fehler. Versuche es erneut.';

  @override
  String get errNotFound => 'Wir konnten nicht finden, wonach du gesucht hast.';

  @override
  String get errAuth => 'Authentifizierung fehlgeschlagen. Versuche es erneut.';

  @override
  String get errScanNotFound => 'Dieser Scan wurde nicht gefunden.';

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(int m) {
    return 'vor $m Min.';
  }

  @override
  String hoursAgo(int h) {
    return 'vor $h Std.';
  }

  @override
  String daysAgo(int d) {
    return 'vor $d T.';
  }

  @override
  String get valueDisclaimer => 'Münzwerte sind Schätzungen auf Basis verfügbarer Daten und können je nach Zustand, Echtheit und Marktnachfrage variieren.';

  @override
  String get gradingDisclaimer => 'Diese App bietet keine professionelle numismatische Echtheitsprüfung oder Finanzberatung. Zustandsschätzungen sind ungefähr.';

  @override
  String get condPoor => 'Schlecht (SGE)';

  @override
  String get condFair => 'Gering erhalten (GE)';

  @override
  String get condGood => 'Schön (S)';

  @override
  String get condVeryGood => 'Sehr schön (SS)';

  @override
  String get condFine => 'Vorzüglich (VZ)';

  @override
  String get condVeryFine => 'Vorzüglich+ (VZ+)';

  @override
  String get condExtremelyFine => 'Fast Stempelglanz (fSt)';

  @override
  String get condUncirculated => 'Stempelglanz (St)';

  @override
  String get rarCommon => 'Häufig';

  @override
  String get rarUncommon => 'Weniger häufig';

  @override
  String get rarRare => 'Selten';

  @override
  String get rarVeryRare => 'Sehr selten';

  @override
  String get rarExtremelyRare => 'Äußerst selten';
}
