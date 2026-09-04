// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTagline => 'Découvrez ce que valent vraiment vos pièces.';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionSkip => 'Passer';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get wordOr => 'ou';

  @override
  String get navHome => 'Accueil';

  @override
  String get navCollection => 'Collection';

  @override
  String get navScan => 'Scanner';

  @override
  String get navHistory => 'Historique';

  @override
  String get navProfile => 'Profil';

  @override
  String get actionShare => 'Partager';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — valeur estimée $value. Identifiée avec Coinsight.';
  }

  @override
  String get offlineBanner => 'Hors ligne — les scans enregistrés fonctionnent';

  @override
  String get onboard1Title => 'Découvrez vos pièces';

  @override
  String get onboard1Body => 'Scannez n\'importe quelle pièce et découvrez immédiatement de quoi il s\'agit.';

  @override
  String get onboard2Title => 'Découvrez sa valeur';

  @override
  String get onboard2Body => 'Obtenez une estimation de la valeur marchande basée sur des données réelles.';

  @override
  String get onboard3Title => 'Débloquez l\'AI Coin Intelligence';

  @override
  String get onboard3Body => 'Découvrez l\'histoire, la rareté et le potentiel de vente de vos pièces.';

  @override
  String get onboardStart => 'Commencer à scanner';

  @override
  String get authSubtitle => 'Connectez-vous pour synchroniser votre collection sur tous vos appareils.';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authPassword8 => 'Mot de passe (8 caractères min.)';

  @override
  String get authName => 'Nom (facultatif)';

  @override
  String get authForgot => 'Mot de passe oublié ?';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authGoogle => 'Continuer avec Google';

  @override
  String get authApple => 'Continuer avec Apple';

  @override
  String get authGuest => 'Explorer sans compte';

  @override
  String get authNewHere => 'Nouveau ici ?';

  @override
  String get authCreate => 'Créer un compte';

  @override
  String get authCreateTitle => 'Créer un compte';

  @override
  String get authCreateCta => 'Créer un compte';

  @override
  String get authResetSent => 'Si un compte existe pour cet e-mail, un lien de réinitialisation va arriver.';

  @override
  String get authNoAccountForEmail => 'Aucun compte trouvé pour cet e-mail.';

  @override
  String get authTerms => 'En continuant, vous acceptez les Conditions d\'utilisation et la Politique de confidentialité de Coinsight.';

  @override
  String get authCreateSyncHint => 'Créez un compte pour synchroniser votre collection';

  @override
  String get valEmailEmpty => 'Saisissez votre e-mail';

  @override
  String get valEmailInvalid => 'Saisissez une adresse e-mail valide';

  @override
  String get valPasswordEmpty => 'Saisissez un mot de passe';

  @override
  String get valPasswordShort => 'Utilisez au moins 8 caractères';

  @override
  String valFieldRequired(String field) {
    return '$field est obligatoire';
  }

  @override
  String get homeWelcome => 'Bienvenue';

  @override
  String homeWelcomeNamed(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get howItWorksScan => 'Scannez';

  @override
  String get howItWorksScanBody => 'Photographiez l\'avers et le revers de votre pièce.';

  @override
  String get howItWorksIdentify => 'Identifiez';

  @override
  String get howItWorksIdentifyBody => 'Nous la comparons à des bases de données numismatiques.';

  @override
  String get howItWorksValue => 'Estimez';

  @override
  String get howItWorksValueBody => 'Consultez une fourchette de valeur marchande estimée.';

  @override
  String get mostValuableCoins => 'Pièces les plus précieuses';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get recentScans => 'Scans récents';

  @override
  String get noScansYet => 'Aucun scan pour l\'instant';

  @override
  String get noScansYetBody => 'Vos pièces scannées apparaîtront ici.';

  @override
  String get unlockBannerTitle => 'Débloquez l\'AI Coin Intelligence';

  @override
  String get unlockBannerBody => 'Histoire, rareté, état et comment la vendre.';

  @override
  String get scanTitle => 'Scanner une pièce';

  @override
  String get scanReset => 'Réinitialiser';

  @override
  String get scanFront => 'Scannez l\'avers';

  @override
  String get scanFrontShort => 'Avers';

  @override
  String get scanBack => 'Scannez le revers (facultatif)';

  @override
  String get scanBackShort => 'Revers';

  @override
  String get forBestResult => 'Pour un meilleur résultat';

  @override
  String get tipPlainBackground => 'Placez la pièce sur un fond uni.';

  @override
  String get tipWholeCoin => 'Assurez-vous que toute la pièce est visible.';

  @override
  String get tipLighting => 'Utilisez un éclairage correct et uniforme.';

  @override
  String get tipGlare => 'Évitez les reflets et les éblouissements.';

  @override
  String get identifyCoin => 'Identifier la pièce';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get uploadFromLibrary => 'Importer depuis la galerie';

  @override
  String get couldNotOpenImage => 'Impossible d\'ouvrir cette image. Vérifiez les autorisations photo dans les Réglages.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Touchez pour refaire · $issue';
  }

  @override
  String get cameraPromptFront => 'Scannez l\'avers de votre pièce';

  @override
  String get cameraPromptBack => 'Scannez le revers de votre pièce';

  @override
  String get cameraHint => 'Remplissez le cercle · fond uni · mains stables';

  @override
  String get cameraAccessOffTitle => 'L\'accès à l\'appareil photo est désactivé';

  @override
  String get cameraAccessOffBody => 'Activez l\'accès à l\'appareil photo pour Coinsight dans les Réglages, puis revenez pour scanner. Vous pouvez aussi importer une photo.';

  @override
  String get cameraUsePhotoInstead => 'Utiliser une photo';

  @override
  String get cameraNoneTitle => 'Aucun appareil photo disponible';

  @override
  String get cameraNoneBody => 'Cet appareil n\'a pas d\'appareil photo utilisable. Importez une photo.';

  @override
  String get cameraUploadPhoto => 'Importer une photo';

  @override
  String get cameraCaptureFailed => 'Impossible de prendre la photo. Réessayez.';

  @override
  String get qualityRetakeNeeded => 'Photo à refaire';

  @override
  String get qualityCouldBeBetter => 'Cette photo pourrait être meilleure';

  @override
  String get qualityRetake => 'Refaire';

  @override
  String get qualityUseAnyway => 'Utiliser quand même cette photo';

  @override
  String get issueLowResShort => 'Basse résolution';

  @override
  String get issueLowResFull => 'Cette image est trop petite. Utilisez l\'appareil photo en pleine qualité ou choisissez une photo plus grande.';

  @override
  String get issueTooDarkShort => 'Trop sombre';

  @override
  String get issueTooDarkFull => 'La photo est trop sombre. Placez-vous dans une lumière plus vive et uniforme.';

  @override
  String get issueTooBrightShort => 'Surexposée';

  @override
  String get issueTooBrightFull => 'La photo est surexposée. Réduisez la lumière directe ou éloignez-vous des reflets.';

  @override
  String get issueBlurryShort => 'Floue';

  @override
  String get issueBlurryFull => 'L\'image est trop floue. Tenez le téléphone immobile, touchez pour faire la mise au point et assurez-vous que la pièce est nette.';

  @override
  String get issueGlareShort => 'Reflets';

  @override
  String get issueGlareFull => 'Il y a de forts reflets sur la pièce. Inclinez-la légèrement ou utilisez une lumière plus douce et indirecte.';

  @override
  String get issueNoCoinShort => 'Aucune pièce détectée';

  @override
  String get issueNoCoinFull => 'Nous n\'avons pas trouvé de pièce. Placez une seule pièce sur un fond uni qui remplit la majeure partie du cadre.';

  @override
  String get issueCoinSmallShort => 'Pièce trop petite';

  @override
  String get issueCoinSmallFull => 'Rapprochez-vous pour que la pièce remplisse la majeure partie du cercle.';

  @override
  String get issueMultipleShort => 'Plusieurs objets';

  @override
  String get issueMultipleFull => 'Nous avons détecté plus d\'un objet. Scannez une seule pièce à la fois.';

  @override
  String get analyzingCoin => 'Analyse de la pièce…';

  @override
  String get stageDetectingText => 'Détection du texte';

  @override
  String get stageIdentifyingCountry => 'Identification du pays';

  @override
  String get stageDetectingYear => 'Détection de l\'année';

  @override
  String get stageSearchingDatabase => 'Recherche dans la base numismatique';

  @override
  String get stageCalculatingValue => 'Calcul de la valeur';

  @override
  String get resultTitle => 'Résultat de la pièce';

  @override
  String get loadingResult => 'Chargement du résultat…';

  @override
  String get resultOpenError => 'Impossible d\'ouvrir ce résultat.';

  @override
  String confidenceValue(String percent) {
    return '$percent de confiance';
  }

  @override
  String get estimatedMarketValue => 'VALEUR MARCHANDE ESTIMÉE';

  @override
  String typicalEstimate(String value) {
    return 'Estimation courante $value';
  }

  @override
  String get whatAffectsValue => 'Ce qui influence cette valeur';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count autres dans l\'analyse complète de la valeur';
  }

  @override
  String get notConfidentMatch => 'Correspondance incertaine';

  @override
  String get notConfidentBody => 'Nous n\'avons pas pu identifier cette pièce avec certitude. Correspondances possibles :';

  @override
  String get detailCountry => 'Pays';

  @override
  String get detailYear => 'Année';

  @override
  String get detailDenomination => 'Dénomination';

  @override
  String get detailMaterial => 'Métal';

  @override
  String get detailMint => 'Atelier';

  @override
  String get detailDiameter => 'Diamètre';

  @override
  String get detailWeight => 'Poids';

  @override
  String get detailConditionEst => 'État (est.)';

  @override
  String get detailRarityEst => 'Rareté (est.)';

  @override
  String get saveToCollection => 'Enregistrer dans la collection';

  @override
  String get savedToCollection => 'Enregistrée dans votre collection';

  @override
  String get unlockAiTitle => 'Débloquez l\'AI Coin Intelligence';

  @override
  String get aiFeatHistory => 'L\'histoire complète';

  @override
  String get aiFeatValue => 'Pourquoi les collectionneurs l\'apprécient';

  @override
  String get aiFeatRarity => 'Analyse de la rareté';

  @override
  String get aiFeatCondition => 'Analyse de l\'état';

  @override
  String get aiFeatSelling => 'Comment la vendre';

  @override
  String get unlockPremium => 'Débloquer Premium';

  @override
  String get aiCoinIntelligence => 'AI Coin Intelligence';

  @override
  String get generateAiAnalysis => 'Générer l\'analyse IA';

  @override
  String get askAiAssistant => 'Demander à l\'assistant IA';

  @override
  String get aiCtaHistory => 'Histoire de la pièce et contexte historique';

  @override
  String get aiCtaValue => 'Pourquoi elle a de la valeur, facteur par facteur';

  @override
  String get aiCtaRarityCondition => 'Analyse de la rareté et de l\'état';

  @override
  String get aiCtaSelling => 'Stratégie de vente et prix';

  @override
  String get coinStory => 'Histoire de la pièce';

  @override
  String get whyItHasValue => 'Pourquoi elle a de la valeur';

  @override
  String get rarityAnalysis => 'Analyse de la rareté';

  @override
  String get conditionEstimate => 'Estimation de l\'état';

  @override
  String get sellingRecommendations => 'Recommandations de vente';

  @override
  String get collectorInsights => 'Informations pour collectionneurs';

  @override
  String get generatingAnalysis => 'Génération de l\'analyse IA de la pièce…';

  @override
  String get aiUnavailable => 'L\'analyse IA est momentanément indisponible.';

  @override
  String get estimatedSellingPrice => 'Prix de vente estimé';

  @override
  String get suggestedListingPrice => 'Prix de mise en vente suggéré';

  @override
  String get minimumReasonablePrice => 'Prix minimum raisonnable';

  @override
  String get whereToSell => 'Où vendre';

  @override
  String get auctionSuitable => 'Adaptée à une vente aux enchères ?';

  @override
  String get professionalAppraisal => 'Expertise professionnelle';

  @override
  String get aiAssistantTitle => 'Assistant IA pour pièces';

  @override
  String aiTalkingAbout(String coin) {
    return 'Sujet : $coin';
  }

  @override
  String get aiAskHint => 'Posez une question sur cette pièce…';

  @override
  String get aiAssistantIntro => 'Posez à l\'assistant toutes vos questions sur cette pièce';

  @override
  String get aiCouldNotOpen => 'Impossible d\'ouvrir cette pièce.';

  @override
  String get qWhyValuable => 'Pourquoi cette pièce a-t-elle de la valeur ?';

  @override
  String get qIsRare => 'Cette pièce est-elle rare ?';

  @override
  String get qWhereSell => 'Où devrais-je la vendre ?';

  @override
  String get qAuthenticate => 'Devrais-je faire authentifier cette pièce ?';

  @override
  String get qHowMuchList => 'À quel prix devrais-je la mettre en vente ?';

  @override
  String get paywallHeadline => 'Débloquez toute l\'histoire derrière chaque pièce';

  @override
  String get paywallSubheadline => 'Découvrez l\'histoire, la rareté et la meilleure façon de vendre vos pièces.';

  @override
  String get featAiAnalysis => 'Analyse IA détaillée';

  @override
  String get featCoinHistory => 'Histoire de la pièce';

  @override
  String get featRarityInsights => 'Informations sur la rareté';

  @override
  String get featConditionAnalysis => 'Analyse de l\'état';

  @override
  String get featSellingRecs => 'Recommandations de vente';

  @override
  String get featCollectorInsights => 'Informations pour collectionneurs';

  @override
  String get featAiAssistant => 'Assistant IA pour pièces';

  @override
  String get featAdvancedStats => 'Statistiques avancées de la collection';

  @override
  String get planYearly => 'Annuel';

  @override
  String get planMonthly => 'Mensuel';

  @override
  String get planPerYear => 'par an';

  @override
  String get planPerMonth => 'par mois';

  @override
  String get bestValue => 'MEILLEURE OFFRE';

  @override
  String get trial7Days => '7 jours d\'essai gratuit';

  @override
  String get paywallLegal => 'L\'abonnement se renouvelle automatiquement jusqu\'à son annulation. Vous pouvez le gérer ou l\'annuler à tout moment depuis le compte de votre boutique.';

  @override
  String get paywallLoadError => 'Impossible de charger les options d\'abonnement.';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get collectionTitle => 'Collection';

  @override
  String get collectionEmpty => 'Votre collection est vide';

  @override
  String get collectionEmptyBody => 'Enregistrez une pièce scannée pour l\'ajouter ici.';

  @override
  String get scanACoin => 'Scanner une pièce';

  @override
  String get searchCoinCountry => 'Rechercher par pièce ou pays';

  @override
  String get sortRecent => 'Récentes';

  @override
  String get sortValueHigh => 'Valeur ↓';

  @override
  String get sortRarity => 'Rareté';

  @override
  String get filterRarity => 'Rareté';

  @override
  String get filterCountry => 'Pays';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterByRarity => 'Filtrer par rareté';

  @override
  String get filterByCountry => 'Filtrer par pays';

  @override
  String get noMatchFilters => 'Aucune pièce ne correspond à ces filtres';

  @override
  String get statCoins => 'Pièces';

  @override
  String get statEstValue => 'Valeur est.';

  @override
  String get statMostValuable => 'La plus précieuse';

  @override
  String rarestLabel(String name, String rarity) {
    return 'La plus rare : $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'Impossible de charger votre collection.';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyEmpty => 'Rien de scanné pour l\'instant';

  @override
  String get historyEmptyBody => 'Scannez une pièce pour commencer votre historique.';

  @override
  String get historyLoadError => 'Impossible de charger l\'historique des scans.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileGuest => 'Invité';

  @override
  String get sectionSubscription => 'Abonnement';

  @override
  String get coinsightPremium => 'Coinsight Premium';

  @override
  String get freePlan => 'Formule gratuite';

  @override
  String renewsOn(String date) {
    return 'Se renouvelle le $date';
  }

  @override
  String get subActive => 'Actif';

  @override
  String get manageSubscription => 'Gérer l\'abonnement';

  @override
  String get manageSubscriptionBody => 'Ouvre les réglages de l\'App Store / Play Store';

  @override
  String get manageSubscriptionHint => 'Gérez ou annulez depuis les réglages du compte de votre boutique.';

  @override
  String get sectionPreferences => 'Préférences';

  @override
  String get currencyLabel => 'Devise';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageSystem => 'Par défaut du système';

  @override
  String get sectionLegal => 'Mentions légales';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get sectionDeveloper => 'Développeur';

  @override
  String get premiumDebugOverride => 'Premium (forçage de débogage)';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountBody => 'Cette action supprime définitivement votre compte, vos scans et vos images. Elle est irréversible.';

  @override
  String appVersion(String version) {
    return 'Coinsight • v$version';
  }

  @override
  String get rankingsTitle => 'Classements des pièces';

  @override
  String get rankMostValuable => 'Les plus précieuses';

  @override
  String get rankRarest => 'Les plus rares';

  @override
  String get rankKeyDates => 'Dates clés';

  @override
  String get rankMostValuableSub => 'Les records du monde numismatique. Des raretés extrêmes, mais elles montrent ce que peut valoir une pièce.';

  @override
  String get rankRarestSub => 'Des pièces qui n\'arrivent presque jamais sur le marché.';

  @override
  String get rankKeyDatesSub => 'Des pièces d\'apparence ordinaire avec une date ou une marque d\'atelier pour laquelle il vaut la peine de vérifier votre monnaie.';

  @override
  String get rankLoadError => 'Impossible de charger les classements.';

  @override
  String get typicalRange => 'FOURCHETTE COURANTE';

  @override
  String get scanYoursToCheck => 'Scannez la vôtre pour vérifier';

  @override
  String get rankYears => 'Années';

  @override
  String get rankKeyDatesLabel => 'Dates clés';

  @override
  String yearBc(int year) {
    return '$year av. J.-C.';
  }

  @override
  String get errNetwork => 'Pas de connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get errServer => 'Un problème est survenu de notre côté. Réessayez dans un instant.';

  @override
  String get errUnknown => 'Erreur inattendue. Réessayez.';

  @override
  String get errNotFound => 'Nous n\'avons pas trouvé ce que vous cherchiez.';

  @override
  String get errAuth => 'Échec de l\'authentification. Réessayez.';

  @override
  String get errScanNotFound => 'Ce scan est introuvable.';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int m) {
    return 'il y a $m min';
  }

  @override
  String hoursAgo(int h) {
    return 'il y a $h h';
  }

  @override
  String daysAgo(int d) {
    return 'il y a $d j';
  }

  @override
  String get valueDisclaimer => 'Les valeurs des pièces sont des estimations basées sur les données disponibles et peuvent varier selon l\'état, l\'authenticité et la demande du marché.';

  @override
  String get gradingDisclaimer => 'Cette application ne fournit pas d\'authentification numismatique professionnelle ni de conseil financier. Les estimations d\'état sont approximatives.';

  @override
  String get condPoor => 'Médiocre (Méd.)';

  @override
  String get condFair => 'Beau (B)';

  @override
  String get condGood => 'Très Beau (TB)';

  @override
  String get condVeryGood => 'Très Très Beau (TTB)';

  @override
  String get condFine => 'Superbe (SUP)';

  @override
  String get condVeryFine => 'Superbe+ (SUP+)';

  @override
  String get condExtremelyFine => 'Splendide (SPL)';

  @override
  String get condUncirculated => 'Fleur de coin (FDC)';

  @override
  String get rarCommon => 'Commune';

  @override
  String get rarUncommon => 'Peu commune';

  @override
  String get rarRare => 'Rare';

  @override
  String get rarVeryRare => 'Très rare';

  @override
  String get rarExtremelyRare => 'Extrêmement rare';
}
