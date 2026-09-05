// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTagline => 'Scopri quanto valgono davvero le tue monete.';

  @override
  String get actionContinue => 'Continua';

  @override
  String get actionSkip => 'Salta';

  @override
  String get actionRetry => 'Riprova';

  @override
  String get actionCancel => 'Annulla';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get actionClose => 'Chiudi';

  @override
  String get wordOr => 'oppure';

  @override
  String get navHome => 'Home';

  @override
  String get navCollection => 'Collezione';

  @override
  String get navScan => 'Scansiona';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navProfile => 'Profilo';

  @override
  String get actionShare => 'Condividi';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — valore stimato $value. Identificata con Coinsights.';
  }

  @override
  String get offlineBanner => 'Offline — le scansioni salvate funzionano';

  @override
  String get onboard1Title => 'Scopri le tue monete';

  @override
  String get onboard1Body =>
      'Scansiona qualsiasi moneta e scopri subito di cosa si tratta.';

  @override
  String get onboard2Title => 'Scopri quanto vale';

  @override
  String get onboard2Body =>
      'Ottieni una stima del valore di mercato basata su dati reali.';

  @override
  String get onboard3Title => 'Sblocca l\'AI Coin Intelligence';

  @override
  String get onboard3Body =>
      'Scopri la storia, la rarità e il potenziale di vendita delle tue monete.';

  @override
  String get onboardStart => 'Inizia a scansionare';

  @override
  String get authSubtitle =>
      'Accedi per sincronizzare la tua collezione su tutti i dispositivi.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPassword8 => 'Password (min. 8 caratteri)';

  @override
  String get authName => 'Nome (facoltativo)';

  @override
  String get authForgot => 'Password dimenticata?';

  @override
  String get authSignIn => 'Accedi';

  @override
  String get authGoogle => 'Continua con Google';

  @override
  String get authApple => 'Continua con Apple';

  @override
  String get authGuest => 'Esplora senza account';

  @override
  String get authNewHere => 'Non hai un account?';

  @override
  String get authCreate => 'Crea un account';

  @override
  String get authCreateTitle => 'Crea account';

  @override
  String get authCreateCta => 'Crea account';

  @override
  String get authResetSent =>
      'Se esiste un account con questa email, riceverai un link per reimpostare la password.';

  @override
  String get authNoAccountForEmail =>
      'Nessun account trovato per questa email.';

  @override
  String get authTerms =>
      'Continuando accetti i Termini di servizio e la Privacy Policy di Coinsights.';

  @override
  String get authCreateSyncHint =>
      'Crea un account per sincronizzare la tua collezione';

  @override
  String get valEmailEmpty => 'Inserisci la tua email';

  @override
  String get valEmailInvalid => 'Inserisci un indirizzo email valido';

  @override
  String get valPasswordEmpty => 'Inserisci una password';

  @override
  String get valPasswordShort => 'Usa almeno 8 caratteri';

  @override
  String valFieldRequired(String field) {
    return '$field è obbligatorio';
  }

  @override
  String get homeWelcome => 'Benvenuto';

  @override
  String homeWelcomeNamed(String name) {
    return 'Benvenuto, $name';
  }

  @override
  String get howItWorks => 'Come funziona';

  @override
  String get howItWorksScan => 'Scansiona';

  @override
  String get howItWorksScanBody =>
      'Fotografa il fronte e il retro della moneta.';

  @override
  String get howItWorksIdentify => 'Identifica';

  @override
  String get howItWorksIdentifyBody =>
      'La confrontiamo con i database numismatici.';

  @override
  String get howItWorksValue => 'Valuta';

  @override
  String get howItWorksValueBody => 'Vedi una stima del valore di mercato.';

  @override
  String get mostValuableCoins => 'Monete più preziose';

  @override
  String get seeAll => 'Vedi tutte';

  @override
  String get recentScans => 'Scansioni recenti';

  @override
  String get noScansYet => 'Ancora nessuna scansione';

  @override
  String get noScansYetBody => 'Le monete scansionate compariranno qui.';

  @override
  String get unlockBannerTitle => 'Sblocca l\'AI Coin Intelligence';

  @override
  String get unlockBannerBody => 'Storia, rarità, condizioni e come venderla.';

  @override
  String get scanTitle => 'Scansiona una moneta';

  @override
  String get scanReset => 'Reimposta';

  @override
  String get scanFront => 'Scansiona il fronte';

  @override
  String get scanFrontShort => 'Fronte';

  @override
  String get scanBack => 'Scansiona il retro (facoltativo)';

  @override
  String get scanBackShort => 'Retro';

  @override
  String get forBestResult => 'Per un risultato migliore';

  @override
  String get tipPlainBackground => 'Appoggia la moneta su uno sfondo uniforme.';

  @override
  String get tipWholeCoin => 'Assicurati che l\'intera moneta sia visibile.';

  @override
  String get tipLighting => 'Usa una luce buona e uniforme.';

  @override
  String get tipGlare => 'Evita riflessi e bagliori.';

  @override
  String get identifyCoin => 'Identifica la moneta';

  @override
  String get takePhoto => 'Scatta una foto';

  @override
  String get uploadFromLibrary => 'Carica dalla galleria';

  @override
  String get couldNotOpenImage =>
      'Impossibile aprire l\'immagine. Controlla i permessi per le foto nelle Impostazioni.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Tocca per rifare · $issue';
  }

  @override
  String get cameraPromptFront => 'Scansiona il fronte della moneta';

  @override
  String get cameraPromptBack => 'Scansiona il retro della moneta';

  @override
  String get cameraHint => 'Riempi il cerchio · sfondo uniforme · mano ferma';

  @override
  String get cameraAccessOffTitle => 'Accesso alla fotocamera disattivato';

  @override
  String get cameraAccessOffBody =>
      'Attiva l\'accesso alla fotocamera per Coinsights nelle Impostazioni del dispositivo, poi torna qui per scansionare. In alternativa puoi caricare una foto.';

  @override
  String get cameraUsePhotoInstead => 'Usa una foto';

  @override
  String get cameraNoneTitle => 'Nessuna fotocamera disponibile';

  @override
  String get cameraNoneBody =>
      'Questo dispositivo non ha una fotocamera utilizzabile. Carica una foto.';

  @override
  String get cameraUploadPhoto => 'Carica una foto';

  @override
  String get cameraCaptureFailed => 'Impossibile scattare la foto. Riprova.';

  @override
  String get qualityRetakeNeeded => 'Serve rifare la foto';

  @override
  String get qualityCouldBeBetter => 'Questa foto può essere migliorata';

  @override
  String get qualityRetake => 'Rifai';

  @override
  String get qualityUseAnyway => 'Usa comunque questa foto';

  @override
  String get issueLowResShort => 'Bassa risoluzione';

  @override
  String get issueLowResFull =>
      'L\'immagine è troppo piccola. Usa la fotocamera alla massima qualità o scegli una foto più grande.';

  @override
  String get issueTooDarkShort => 'Troppo scura';

  @override
  String get issueTooDarkFull =>
      'La foto è troppo scura. Spostati in una luce più intensa e uniforme.';

  @override
  String get issueTooBrightShort => 'Sovraesposta';

  @override
  String get issueTooBrightFull =>
      'La foto è sovraesposta. Riduci la luce diretta o spostati dai bagliori.';

  @override
  String get issueBlurryShort => 'Sfocata';

  @override
  String get issueBlurryFull =>
      'L\'immagine è troppo sfocata. Tieni fermo il telefono, tocca per mettere a fuoco e assicurati che la moneta sia nitida.';

  @override
  String get issueGlareShort => 'Riflessi';

  @override
  String get issueGlareFull =>
      'Ci sono forti riflessi sulla moneta. Inclinala leggermente o usa una luce più diffusa e indiretta.';

  @override
  String get issueNoCoinShort => 'Nessuna moneta rilevata';

  @override
  String get issueNoCoinFull =>
      'Non abbiamo trovato una moneta. Metti una sola moneta su uno sfondo uniforme che riempia gran parte dell\'inquadratura.';

  @override
  String get issueCoinSmallShort => 'Moneta troppo piccola';

  @override
  String get issueCoinSmallFull =>
      'Avvicinati in modo che la moneta riempia gran parte del cerchio.';

  @override
  String get issueMultipleShort => 'Più oggetti';

  @override
  String get issueMultipleFull =>
      'Abbiamo rilevato più di un oggetto. Scansiona una moneta alla volta.';

  @override
  String get analyzingCoin => 'Analisi della moneta…';

  @override
  String get stageDetectingText => 'Rilevamento del testo';

  @override
  String get stageIdentifyingCountry => 'Identificazione del Paese';

  @override
  String get stageDetectingYear => 'Rilevamento dell\'anno';

  @override
  String get stageSearchingDatabase => 'Ricerca nel database numismatico';

  @override
  String get stageCalculatingValue => 'Calcolo del valore';

  @override
  String get resultTitle => 'Risultato moneta';

  @override
  String get loadingResult => 'Caricamento del risultato…';

  @override
  String get resultOpenError => 'Impossibile aprire questo risultato.';

  @override
  String confidenceValue(String percent) {
    return 'affidabilità $percent';
  }

  @override
  String get estimatedMarketValue => 'VALORE DI MERCATO STIMATO';

  @override
  String typicalEstimate(String value) {
    return 'Stima tipica $value';
  }

  @override
  String get whatAffectsValue => 'Cosa influenza questo valore';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count altri nell\'analisi completa del valore';
  }

  @override
  String get notConfidentMatch => 'Corrispondenza non certa';

  @override
  String get notConfidentBody =>
      'Non siamo riusciti a identificare questa moneta con certezza. Possibili corrispondenze:';

  @override
  String get detailCountry => 'Paese';

  @override
  String get detailYear => 'Anno';

  @override
  String get detailDenomination => 'Denominazione';

  @override
  String get detailMaterial => 'Materiale';

  @override
  String get detailMint => 'Zecca';

  @override
  String get detailDiameter => 'Diametro';

  @override
  String get detailWeight => 'Peso';

  @override
  String get detailConditionEst => 'Condizione (stima)';

  @override
  String get detailRarityEst => 'Rarità (stima)';

  @override
  String get saveToCollection => 'Salva nella collezione';

  @override
  String get savedToCollection => 'Salvata nella tua collezione';

  @override
  String get unlockAiTitle => 'Sblocca l\'AI Coin Intelligence';

  @override
  String get aiFeatHistory => 'La storia completa';

  @override
  String get aiFeatValue => 'Perché i collezionisti la apprezzano';

  @override
  String get aiFeatRarity => 'Analisi della rarità';

  @override
  String get aiFeatCondition => 'Analisi delle condizioni';

  @override
  String get aiFeatSelling => 'Come venderla';

  @override
  String get unlockPremium => 'Sblocca Premium';

  @override
  String get aiCoinIntelligence => 'AI Coin Intelligence';

  @override
  String get generateAiAnalysis => 'Genera analisi AI';

  @override
  String get askAiAssistant => 'Chiedi all\'assistente AI';

  @override
  String get aiCtaHistory => 'Storia della moneta e contesto storico';

  @override
  String get aiCtaValue => 'Perché ha valore, fattore per fattore';

  @override
  String get aiCtaRarityCondition => 'Analisi di rarità e condizioni';

  @override
  String get aiCtaSelling => 'Strategia di vendita e prezzo';

  @override
  String get coinStory => 'Storia della moneta';

  @override
  String get whyItHasValue => 'Perché ha valore';

  @override
  String get rarityAnalysis => 'Analisi della rarità';

  @override
  String get conditionEstimate => 'Stima delle condizioni';

  @override
  String get sellingRecommendations => 'Consigli per la vendita';

  @override
  String get collectorInsights => 'Approfondimenti per collezionisti';

  @override
  String get generatingAnalysis => 'Generazione dell\'analisi AI della moneta…';

  @override
  String get aiUnavailable => 'L\'analisi AI non è al momento disponibile.';

  @override
  String get estimatedSellingPrice => 'Prezzo di vendita stimato';

  @override
  String get suggestedListingPrice => 'Prezzo di inserzione consigliato';

  @override
  String get minimumReasonablePrice => 'Prezzo minimo ragionevole';

  @override
  String get whereToSell => 'Dove vendere';

  @override
  String get auctionSuitable => 'Adatta a un\'asta?';

  @override
  String get professionalAppraisal => 'Perizia professionale';

  @override
  String get aiAssistantTitle => 'Assistente AI per monete';

  @override
  String aiTalkingAbout(String coin) {
    return 'Argomento: $coin';
  }

  @override
  String get aiAskHint => 'Fai una domanda su questa moneta…';

  @override
  String get aiAssistantIntro =>
      'Chiedi all\'assistente qualsiasi cosa su questa moneta';

  @override
  String get aiCouldNotOpen => 'Impossibile aprire questa moneta.';

  @override
  String get qWhyValuable => 'Perché questa moneta ha valore?';

  @override
  String get qIsRare => 'Questa moneta è rara?';

  @override
  String get qWhereSell => 'Dove dovrei venderla?';

  @override
  String get qAuthenticate => 'Dovrei far autenticare questa moneta?';

  @override
  String get qHowMuchList => 'A quanto dovrei metterla in vendita?';

  @override
  String get paywallHeadline => 'Sblocca tutta la storia dietro ogni moneta';

  @override
  String get paywallSubheadline =>
      'Scopri la storia, la rarità e il modo migliore per vendere le tue monete.';

  @override
  String get featAiAnalysis => 'Analisi AI dettagliata';

  @override
  String get featCoinHistory => 'Storia della moneta';

  @override
  String get featRarityInsights => 'Approfondimenti sulla rarità';

  @override
  String get featConditionAnalysis => 'Analisi delle condizioni';

  @override
  String get featSellingRecs => 'Consigli per la vendita';

  @override
  String get featCollectorInsights => 'Approfondimenti per collezionisti';

  @override
  String get featAiAssistant => 'Assistente AI per monete';

  @override
  String get featAdvancedStats => 'Statistiche avanzate della collezione';

  @override
  String get featSellGuide => 'Guida completa ai marketplace dove vendere';

  @override
  String get featNoAds => 'Nessuna pubblicità';

  @override
  String get planYearly => 'Annuale';

  @override
  String get planMonthly => 'Mensile';

  @override
  String get planPerYear => 'all\'anno';

  @override
  String get planPerMonth => 'al mese';

  @override
  String get bestValue => 'MIGLIORE OFFERTA';

  @override
  String get trial7Days => '7 giorni di prova gratuita';

  @override
  String get paywallLegal =>
      'L\'abbonamento si rinnova automaticamente fino all\'annullamento. Puoi gestirlo o annullarlo in qualsiasi momento dal tuo account dello store.';

  @override
  String get paywallLoadError =>
      'Impossibile caricare le opzioni di abbonamento.';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get collectionTitle => 'Collezione';

  @override
  String get collectionEmpty => 'La tua collezione è vuota';

  @override
  String get collectionEmptyBody =>
      'Salva una moneta scansionata per aggiungerla qui.';

  @override
  String get scanACoin => 'Scansiona una moneta';

  @override
  String get collectionAddCoin => 'Aggiungi una moneta';

  @override
  String get collectionEditHintList =>
      'Scorri una moneta a sinistra per rimuoverla, o tocca + per aggiungerne una.';

  @override
  String get collectionEditHintGrid =>
      'Tieni premuta una moneta per rimuoverla, o tocca + per aggiungerne una.';

  @override
  String get collectionManage => 'Modifica collezione';

  @override
  String get actionOpen => 'Apri';

  @override
  String get actionUndo => 'Annulla';

  @override
  String get collectionRemoveTitle => 'Rimuovere dalla collezione?';

  @override
  String collectionRemoveBody(String coin) {
    return '$coin resta nella cronologia delle scansioni: esce solo dalla collezione e dal totale del portafoglio.';
  }

  @override
  String get collectionRemoveAction => 'Rimuovi';

  @override
  String get collectionRemovedToast => 'Rimossa dalla collezione';

  @override
  String get searchCoinCountry => 'Cerca per moneta o Paese';

  @override
  String get sortRecent => 'Recenti';

  @override
  String get sortValueHigh => 'Valore ↓';

  @override
  String get sortRarity => 'Rarità';

  @override
  String get filterRarity => 'Rarità';

  @override
  String get filterCountry => 'Paese';

  @override
  String get filterAll => 'Tutte';

  @override
  String get filterByRarity => 'Filtra per rarità';

  @override
  String get filterByCountry => 'Filtra per Paese';

  @override
  String get noMatchFilters => 'Nessuna moneta corrisponde a questi filtri';

  @override
  String get statCoins => 'Monete';

  @override
  String get statEstValue => 'Valore stim.';

  @override
  String get statMostValuable => 'Più preziosa';

  @override
  String rarestLabel(String name, String rarity) {
    return 'Più rara: $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'Impossibile caricare la tua collezione.';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get historyEmpty => 'Ancora niente da scansionare';

  @override
  String get historyEmptyBody =>
      'Scansiona una moneta per iniziare a costruire la tua cronologia.';

  @override
  String get historyLoadError =>
      'Impossibile caricare la cronologia delle scansioni.';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileGuest => 'Ospite';

  @override
  String get sectionSubscription => 'Abbonamento';

  @override
  String get coinsightPremium => 'Coinsights Premium';

  @override
  String get freePlan => 'Piano gratuito';

  @override
  String renewsOn(String date) {
    return 'Si rinnova il $date';
  }

  @override
  String get subActive => 'Attivo';

  @override
  String get manageSubscription => 'Gestisci abbonamento';

  @override
  String get manageSubscriptionBody =>
      'Apre le impostazioni di App Store / Play Store';

  @override
  String get manageSubscriptionHint =>
      'Gestisci o annulla dalle impostazioni del tuo account dello store.';

  @override
  String get sectionPreferences => 'Preferenze';

  @override
  String get currencyLabel => 'Valuta';

  @override
  String get languageLabel => 'Lingua';

  @override
  String get replayTutorial => 'Rivedi l\'introduzione';

  @override
  String get languageSystem => 'Predefinita del sistema';

  @override
  String get sectionLegal => 'Note legali';

  @override
  String get helpAndSupport => 'Aiuto e supporto';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get sectionDeveloper => 'Sviluppatore';

  @override
  String get premiumDebugOverride => 'Premium (override di debug)';

  @override
  String get signOut => 'Esci';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountTitle => 'Eliminare l\'account?';

  @override
  String get deleteAccountBody =>
      'Questa operazione elimina definitivamente il tuo account, le scansioni e le immagini. Non può essere annullata.';

  @override
  String appVersion(String version) {
    return 'Coinsights • v$version';
  }

  @override
  String get rankingsTitle => 'Classifiche delle monete';

  @override
  String get rankMostValuable => 'Più preziose';

  @override
  String get rankRarest => 'Più rare';

  @override
  String get rankKeyDates => 'Date chiave';

  @override
  String get rankMostValuableSub =>
      'I record del mondo numismatico. Rarità estreme, ma fanno capire quanto può valere una moneta.';

  @override
  String get rankRarestSub => 'Monete che quasi non compaiono mai sul mercato.';

  @override
  String get rankKeyDatesSub =>
      'Monete dall\'aspetto comune con un anno o un segno di zecca per cui vale la pena controllare gli spiccioli.';

  @override
  String get rankLoadError => 'Impossibile caricare le classifiche.';

  @override
  String get rankSearchHint => 'Cerca per nome, paese o valore nominale';

  @override
  String get rankAllCountries => 'Tutti i paesi';

  @override
  String get rankNoResults => 'Nessuna moneta corrisponde';

  @override
  String get rankNoResultsBody =>
      'Prova un termine diverso o rimuovi il filtro paese.';

  @override
  String get premiumBadge => 'PRO';

  @override
  String paywallTrialFraming(String price) {
    return '7 giorni gratis, poi $price. Disdici quando vuoi.';
  }

  @override
  String get paywallStartTrial => 'Inizia la prova gratuita';

  @override
  String get ob1Title => 'Scopri il vero valore della tua moneta';

  @override
  String get ob1Accent => 'vero valore';

  @override
  String get ob1Sub => 'Non vendere mai a un prezzo troppo basso.';

  @override
  String get ob1CoinName => 'Sterlina d\'oro';

  @override
  String get ob1RefLabel => 'VALORE DI RIFERIMENTO';

  @override
  String get ob2Title => 'La valutazione trova l\'1% delle monete più rare';

  @override
  String get ob2Accent => '1%';

  @override
  String get ob2Sub => 'Errori di conio, oro e date chiave.';

  @override
  String get ob2MeterLabel => 'Estremamente raro';

  @override
  String get ob2MeterLow => 'Molto comune';

  @override
  String get ob2MeterHigh => 'Ultra raro';

  @override
  String get ob3Title => 'Monitora il valore totale della tua collezione';

  @override
  String get ob3Accent => 'valore totale';

  @override
  String get ob3Sub => 'Sempre e ovunque.';

  @override
  String get ob4Title => 'Scansiona, scopri, decidi';

  @override
  String get ob4Accent => 'scopri';

  @override
  String get ob4Sub => 'Bastano pochi secondi e la fotocamera.';

  @override
  String get ob4Cta => 'Inizia';

  @override
  String get ob4Step1 => 'Fotografa fronte e retro';

  @override
  String get ob4Step2 => 'Identifichiamo la moneta';

  @override
  String get ob4Step3 => 'Vedi valore e rarità';

  @override
  String get portfolioLabel => 'IL TUO PORTAFOGLIO';

  @override
  String get portfolioCoins => 'Monete';

  @override
  String get portfolioCountries => 'Paesi';

  @override
  String get portfolioTopCoin => 'Top moneta';

  @override
  String get sellGuideTitle => 'Dove vendere questa moneta';

  @override
  String get sellGuideResaleLabel => 'RANGE REALISTICO DI VENDITA PRIVATA';

  @override
  String get sellGuideResaleNote =>
      'La nostra stima di quanto incassa un venditore privato — sotto il prezzo al dettaglio per via delle commissioni d’asta, dei margini dei commercianti e dello sconto che i collezionisti si aspettano su una moneta non periziata.';

  @override
  String get sellGuideDisclaimer =>
      'I range sono stimati dal nostro modello di valutazione, non da vendite reali. Per pezzi di valore conviene una perizia specialistica prima di vendere.';

  @override
  String sellGuideUnlock(int count) {
    return 'Sblocca altri $count canali e consigli di vendita con PRO';
  }

  @override
  String get sellTierHigh =>
      'A questo valore, fai periziare la moneta (PCGS/NGC) e affidala a una grande casa d’aste — il bacino di acquirenti più ampio di solito copre abbondantemente la commissione.';

  @override
  String get sellTierMid =>
      'Foto nitide e ben illuminate di entrambi i lati e una descrizione onesta della conservazione: è questo che fa vendere le monete di valore medio. La certificazione è facoltativa ma aumenta la fiducia.';

  @override
  String get sellTierLow =>
      'Le monete comuni si vendono più in fretta in lotti o a un commerciante locale. Paga la perizia solo se una data/zecca specifica è l’eccezione di pregio.';

  @override
  String get sellEbayName => 'eBay';

  @override
  String get sellEbayBlurb =>
      'Di gran lunga il bacino di acquirenti più ampio. Commissione sul venduto ~13% più costi di pagamento. Ottimo da pochi euro fino a qualche migliaio.';

  @override
  String get sellHeritageName => 'Heritage Auctions';

  @override
  String get sellHeritageBlurb =>
      'La più grande casa d’aste numismatica. Portata mondiale per le rarità; la commissione al venditore è trattabile sui pezzi di alto valore.';

  @override
  String get sellStacksName => 'Stack’s Bowers';

  @override
  String get sellStacksBlurb =>
      'Casa d’aste storica, forte su monete USA e mondiali. Come Heritage, meglio riservarla a materiale davvero raro.';

  @override
  String get sellCertifiedDealerName => 'Commerciante numismatico';

  @override
  String get sellCertifiedDealerBlurb =>
      'Vendita rapida e sicura a prezzo d’acquisto all’ingrosso — in genere il 60–80% del dettaglio. Nessuna commissione, nessun rischio di spedizione.';

  @override
  String get sellLocalShopName => 'Negozio di monete locale';

  @override
  String get sellLocalShopBlurb =>
      'Offerta immediata, nessun annuncio da gestire. Prezzi più bassi dell’online ma nessuna commissione e nessun rischio di storno.';

  @override
  String get sellForumsName => 'Forum di collezionisti';

  @override
  String get sellForumsBlurb =>
      'Siti come CoinTalk o i forum NGC/PCGS hanno sezioni dedicate alla compravendita. Commissioni più basse di eBay e acquirenti esperti, ma più lento.';

  @override
  String get sellCoinShowName => 'Fiera / convegno numismatico';

  @override
  String get sellCoinShowBlurb =>
      'Decine di commercianti in una sala significano offerte in concorrenza. Ottimo per vendere un gruppo in una volta.';

  @override
  String get sellFacebookName => 'Gruppi Facebook';

  @override
  String get sellFacebookBlurb =>
      'Gruppi locali di compravendita attivi per monete comuni. Incontratevi in un luogo pubblico sicuro e usate solo pagamenti protetti.';

  @override
  String get typicalRange => 'INTERVALLO TIPICO';

  @override
  String get scanYoursToCheck => 'Scansiona la tua per verificare';

  @override
  String get rankYears => 'Anni';

  @override
  String get rankKeyDatesLabel => 'Date chiave';

  @override
  String yearBc(int year) {
    return '$year a.C.';
  }

  @override
  String get errNetwork =>
      'Nessuna connessione a Internet. Controlla la rete e riprova.';

  @override
  String get errServer =>
      'Si è verificato un problema dalla nostra parte. Riprova tra poco.';

  @override
  String get errUnknown => 'Errore imprevisto. Riprova.';

  @override
  String get errNotFound => 'Non abbiamo trovato ciò che cercavi.';

  @override
  String get errAuth => 'Autenticazione non riuscita. Riprova.';

  @override
  String get errScanNotFound => 'Impossibile trovare questa scansione.';

  @override
  String get justNow => 'Adesso';

  @override
  String minutesAgo(int m) {
    return '$m min fa';
  }

  @override
  String hoursAgo(int h) {
    return '$h h fa';
  }

  @override
  String daysAgo(int d) {
    return '$d g fa';
  }

  @override
  String get valueDisclaimer =>
      'I valori delle monete sono stime basate sui dati disponibili e possono variare in base a condizioni, autenticità e domanda di mercato.';

  @override
  String get confirmCoinLink => 'Correggi i dati della moneta';

  @override
  String get confirmCoinTitle => 'Conferma di che moneta si tratta';

  @override
  String get confirmCoinBody =>
      'Il valore è accurato quanto l\'identificazione. Indica paese, tipo e anno e ricalcoliamo il valore dai dati di catalogo verificati.';

  @override
  String get confirmCoinCta => 'Imposta i dati della moneta';

  @override
  String get correctCountryTitle => 'Quale paese?';

  @override
  String get correctTypeTitle => 'Quale moneta?';

  @override
  String get correctYearTitle => 'Quale anno?';

  @override
  String get correctSearchCountry => 'Cerca paese';

  @override
  String get correctYearLabel => 'Anno sulla moneta';

  @override
  String correctYearRange(String from, String to) {
    return 'Inserisci un anno tra $from e $to';
  }

  @override
  String get correctSave => 'Salva e ricalcola';

  @override
  String get gradingDisclaimer =>
      'Questa app non fornisce autenticazione numismatica professionale né consulenza finanziaria. Le stime delle condizioni sono approssimative.';

  @override
  String get condPoor => 'Scadente';

  @override
  String get condFair => 'Discreta';

  @override
  String get condGood => 'Buona';

  @override
  String get condVeryGood => 'Molto buona';

  @override
  String get condFine => 'Fine';

  @override
  String get condVeryFine => 'Molto fine';

  @override
  String get condExtremelyFine => 'Splendida';

  @override
  String get condUncirculated => 'Fior di conio';

  @override
  String get rarCommon => 'Comune';

  @override
  String get rarUncommon => 'Poco comune';

  @override
  String get rarRare => 'Rara';

  @override
  String get rarVeryRare => 'Molto rara';

  @override
  String get rarExtremelyRare => 'Estremamente rara';
}
