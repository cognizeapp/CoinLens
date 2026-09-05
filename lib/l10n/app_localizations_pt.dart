// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTagline => 'Descubra quanto valem realmente as suas moedas.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionSkip => 'Ignorar';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionClose => 'Fechar';

  @override
  String get wordOr => 'ou';

  @override
  String get navHome => 'Início';

  @override
  String get navCollection => 'Coleção';

  @override
  String get navScan => 'Digitalizar';

  @override
  String get navHistory => 'Histórico';

  @override
  String get navProfile => 'Perfil';

  @override
  String get actionShare => 'Partilhar';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — valor estimado $value. Identificada com a Coinsights.';
  }

  @override
  String get offlineBanner => 'Offline — as digitalizações guardadas funcionam';

  @override
  String get onboard1Title => 'Descubra as suas moedas';

  @override
  String get onboard1Body => 'Digitalize qualquer moeda e descubra na hora do que se trata.';

  @override
  String get onboard2Title => 'Descubra quanto vale';

  @override
  String get onboard2Body => 'Obtenha um valor de mercado estimado com base em dados reais.';

  @override
  String get onboard3Title => 'Desbloqueie a AI Coin Intelligence';

  @override
  String get onboard3Body => 'Descubra a história, a raridade e o potencial de venda das suas moedas.';

  @override
  String get onboardStart => 'Começar a digitalizar';

  @override
  String get authSubtitle => 'Inicie sessão para sincronizar a sua coleção em todos os dispositivos.';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Palavra-passe';

  @override
  String get authPassword8 => 'Palavra-passe (mín. 8 caracteres)';

  @override
  String get authName => 'Nome (opcional)';

  @override
  String get authForgot => 'Esqueceu-se da palavra-passe?';

  @override
  String get authSignIn => 'Iniciar sessão';

  @override
  String get authGoogle => 'Continuar com o Google';

  @override
  String get authApple => 'Continuar com a Apple';

  @override
  String get authGuest => 'Explorar sem conta';

  @override
  String get authNewHere => 'É novo por aqui?';

  @override
  String get authCreate => 'Criar uma conta';

  @override
  String get authCreateTitle => 'Criar conta';

  @override
  String get authCreateCta => 'Criar conta';

  @override
  String get authResetSent => 'Se existir uma conta para esse e-mail, será enviado um link para redefinir a palavra-passe.';

  @override
  String get authNoAccountForEmail => 'Não foi encontrada nenhuma conta para esse e-mail.';

  @override
  String get authTerms => 'Ao continuar, aceita os Termos de Serviço e a Política de Privacidade da Coinsights.';

  @override
  String get authCreateSyncHint => 'Crie uma conta para sincronizar a sua coleção';

  @override
  String get valEmailEmpty => 'Introduza o seu e-mail';

  @override
  String get valEmailInvalid => 'Introduza um endereço de e-mail válido';

  @override
  String get valPasswordEmpty => 'Introduza uma palavra-passe';

  @override
  String get valPasswordShort => 'Use pelo menos 8 caracteres';

  @override
  String valFieldRequired(String field) {
    return '$field é obrigatório';
  }

  @override
  String get homeWelcome => 'Bem-vindo';

  @override
  String homeWelcomeNamed(String name) {
    return 'Bem-vindo, $name';
  }

  @override
  String get howItWorks => 'Como funciona';

  @override
  String get howItWorksScan => 'Digitalize';

  @override
  String get howItWorksScanBody => 'Fotografe o anverso e o reverso da sua moeda.';

  @override
  String get howItWorksIdentify => 'Identifique';

  @override
  String get howItWorksIdentifyBody => 'Comparamo-la com bases de dados numismáticas.';

  @override
  String get howItWorksValue => 'Avalie';

  @override
  String get howItWorksValueBody => 'Veja um intervalo de valor de mercado estimado.';

  @override
  String get mostValuableCoins => 'Moedas mais valiosas';

  @override
  String get seeAll => 'Ver tudo';

  @override
  String get recentScans => 'Digitalizações recentes';

  @override
  String get noScansYet => 'Ainda não há digitalizações';

  @override
  String get noScansYetBody => 'As suas moedas digitalizadas aparecerão aqui.';

  @override
  String get unlockBannerTitle => 'Desbloqueie a AI Coin Intelligence';

  @override
  String get unlockBannerBody => 'História, raridade, estado e como vendê-la.';

  @override
  String get scanTitle => 'Digitalizar uma moeda';

  @override
  String get scanReset => 'Repor';

  @override
  String get scanFront => 'Digitalize o anverso';

  @override
  String get scanFrontShort => 'Anverso';

  @override
  String get scanBack => 'Digitalize o reverso (opcional)';

  @override
  String get scanBackShort => 'Reverso';

  @override
  String get forBestResult => 'Para um melhor resultado';

  @override
  String get tipPlainBackground => 'Coloque a moeda sobre um fundo liso.';

  @override
  String get tipWholeCoin => 'Certifique-se de que toda a moeda está visível.';

  @override
  String get tipLighting => 'Use uma luz boa e uniforme.';

  @override
  String get tipGlare => 'Evite brilhos e reflexos.';

  @override
  String get identifyCoin => 'Identificar moeda';

  @override
  String get takePhoto => 'Tirar uma foto';

  @override
  String get uploadFromLibrary => 'Carregar da galeria';

  @override
  String get couldNotOpenImage => 'Não foi possível abrir essa imagem. Verifique as permissões de fotos nas Definições.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Toque para repetir · $issue';
  }

  @override
  String get cameraPromptFront => 'Digitalize o anverso da sua moeda';

  @override
  String get cameraPromptBack => 'Digitalize o reverso da sua moeda';

  @override
  String get cameraHint => 'Preencha o círculo · fundo liso · mão firme';

  @override
  String get cameraAccessOffTitle => 'O acesso à câmara está desativado';

  @override
  String get cameraAccessOffBody => 'Ative o acesso à câmara para a Coinsights nas Definições do dispositivo e volte para digitalizar. Também pode carregar uma foto.';

  @override
  String get cameraUsePhotoInstead => 'Usar uma foto';

  @override
  String get cameraNoneTitle => 'Nenhuma câmara disponível';

  @override
  String get cameraNoneBody => 'Este dispositivo não tem uma câmara utilizável. Carregue uma foto.';

  @override
  String get cameraUploadPhoto => 'Carregar uma foto';

  @override
  String get cameraCaptureFailed => 'Não foi possível tirar a foto. Tente novamente.';

  @override
  String get qualityRetakeNeeded => 'É necessário repetir a foto';

  @override
  String get qualityCouldBeBetter => 'Esta foto podia estar melhor';

  @override
  String get qualityRetake => 'Repetir';

  @override
  String get qualityUseAnyway => 'Usar esta foto mesmo assim';

  @override
  String get issueLowResShort => 'Baixa resolução';

  @override
  String get issueLowResFull => 'Esta imagem é demasiado pequena. Use a câmara na qualidade máxima ou escolha uma foto maior.';

  @override
  String get issueTooDarkShort => 'Demasiado escura';

  @override
  String get issueTooDarkFull => 'A foto está demasiado escura. Mude para uma luz mais forte e uniforme.';

  @override
  String get issueTooBrightShort => 'Sobre-exposta';

  @override
  String get issueTooBrightFull => 'A foto está sobre-exposta. Reduza a luz direta ou afaste-se dos brilhos.';

  @override
  String get issueBlurryShort => 'Desfocada';

  @override
  String get issueBlurryFull => 'A imagem está demasiado desfocada. Segure o telemóvel firme, toque para focar e certifique-se de que a moeda está nítida.';

  @override
  String get issueGlareShort => 'Reflexos';

  @override
  String get issueGlareFull => 'Há reflexos fortes na moeda. Incline-a ligeiramente ou use uma luz mais suave e indireta.';

  @override
  String get issueNoCoinShort => 'Nenhuma moeda detetada';

  @override
  String get issueNoCoinFull => 'Não encontrámos nenhuma moeda. Coloque uma única moeda sobre um fundo liso que ocupe a maior parte do enquadramento.';

  @override
  String get issueCoinSmallShort => 'Moeda demasiado pequena';

  @override
  String get issueCoinSmallFull => 'Aproxime-se para que a moeda ocupe a maior parte do círculo.';

  @override
  String get issueMultipleShort => 'Vários objetos';

  @override
  String get issueMultipleFull => 'Detetámos mais do que um objeto. Digitalize uma moeda de cada vez.';

  @override
  String get analyzingCoin => 'A analisar a moeda…';

  @override
  String get stageDetectingText => 'A detetar o texto';

  @override
  String get stageIdentifyingCountry => 'A identificar o país';

  @override
  String get stageDetectingYear => 'A detetar o ano';

  @override
  String get stageSearchingDatabase => 'A pesquisar na base de dados numismática';

  @override
  String get stageCalculatingValue => 'A calcular o valor';

  @override
  String get resultTitle => 'Resultado da moeda';

  @override
  String get loadingResult => 'A carregar o resultado…';

  @override
  String get resultOpenError => 'Não foi possível abrir este resultado.';

  @override
  String confidenceValue(String percent) {
    return '$percent de confiança';
  }

  @override
  String get estimatedMarketValue => 'VALOR DE MERCADO ESTIMADO';

  @override
  String typicalEstimate(String value) {
    return 'Estimativa típica $value';
  }

  @override
  String get whatAffectsValue => 'O que influencia este valor';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count mais na análise completa do valor';
  }

  @override
  String get notConfidentMatch => 'Correspondência incerta';

  @override
  String get notConfidentBody => 'Não conseguimos identificar esta moeda com certeza. Correspondências possíveis:';

  @override
  String get detailCountry => 'País';

  @override
  String get detailYear => 'Ano';

  @override
  String get detailDenomination => 'Denominação';

  @override
  String get detailMaterial => 'Material';

  @override
  String get detailMint => 'Casa da moeda';

  @override
  String get detailDiameter => 'Diâmetro';

  @override
  String get detailWeight => 'Peso';

  @override
  String get detailConditionEst => 'Estado (est.)';

  @override
  String get detailRarityEst => 'Raridade (est.)';

  @override
  String get saveToCollection => 'Guardar na coleção';

  @override
  String get savedToCollection => 'Guardada na sua coleção';

  @override
  String get unlockAiTitle => 'Desbloqueie a AI Coin Intelligence';

  @override
  String get aiFeatHistory => 'A história completa';

  @override
  String get aiFeatValue => 'Por que os colecionadores a valorizam';

  @override
  String get aiFeatRarity => 'Análise de raridade';

  @override
  String get aiFeatCondition => 'Análise do estado';

  @override
  String get aiFeatSelling => 'Como vendê-la';

  @override
  String get unlockPremium => 'Desbloquear Premium';

  @override
  String get aiCoinIntelligence => 'AI Coin Intelligence';

  @override
  String get generateAiAnalysis => 'Gerar análise com IA';

  @override
  String get askAiAssistant => 'Perguntar ao assistente de IA';

  @override
  String get aiCtaHistory => 'História da moeda e contexto histórico';

  @override
  String get aiCtaValue => 'Por que tem valor, fator a fator';

  @override
  String get aiCtaRarityCondition => 'Análise de raridade e estado';

  @override
  String get aiCtaSelling => 'Estratégia de venda e preço';

  @override
  String get coinStory => 'História da moeda';

  @override
  String get whyItHasValue => 'Por que tem valor';

  @override
  String get rarityAnalysis => 'Análise de raridade';

  @override
  String get conditionEstimate => 'Estimativa do estado';

  @override
  String get sellingRecommendations => 'Recomendações de venda';

  @override
  String get collectorInsights => 'Informações para colecionadores';

  @override
  String get generatingAnalysis => 'A gerar a análise da moeda com IA…';

  @override
  String get aiUnavailable => 'A análise com IA está temporariamente indisponível.';

  @override
  String get estimatedSellingPrice => 'Preço de venda estimado';

  @override
  String get suggestedListingPrice => 'Preço de anúncio sugerido';

  @override
  String get minimumReasonablePrice => 'Preço mínimo razoável';

  @override
  String get whereToSell => 'Onde vender';

  @override
  String get auctionSuitable => 'Adequada a leilão?';

  @override
  String get professionalAppraisal => 'Avaliação profissional';

  @override
  String get aiAssistantTitle => 'Assistente de IA para moedas';

  @override
  String aiTalkingAbout(String coin) {
    return 'A falar sobre: $coin';
  }

  @override
  String get aiAskHint => 'Pergunte sobre esta moeda…';

  @override
  String get aiAssistantIntro => 'Pergunte ao assistente tudo sobre esta moeda';

  @override
  String get aiCouldNotOpen => 'Não foi possível abrir esta moeda.';

  @override
  String get qWhyValuable => 'Por que esta moeda tem valor?';

  @override
  String get qIsRare => 'Esta moeda é rara?';

  @override
  String get qWhereSell => 'Onde devo vendê-la?';

  @override
  String get qAuthenticate => 'Devo autenticar esta moeda?';

  @override
  String get qHowMuchList => 'Por quanto devo anunciá-la?';

  @override
  String get paywallHeadline => 'Desbloqueie toda a história por trás de cada moeda';

  @override
  String get paywallSubheadline => 'Descubra a história, a raridade e a melhor forma de vender as suas moedas.';

  @override
  String get featAiAnalysis => 'Análise detalhada com IA';

  @override
  String get featCoinHistory => 'História da moeda';

  @override
  String get featRarityInsights => 'Informações sobre a raridade';

  @override
  String get featConditionAnalysis => 'Análise do estado';

  @override
  String get featSellingRecs => 'Recomendações de venda';

  @override
  String get featCollectorInsights => 'Informações para colecionadores';

  @override
  String get featAiAssistant => 'Assistente de IA para moedas';

  @override
  String get featAdvancedStats => 'Estatísticas avançadas da coleção';

  @override
  String get featSellGuide => 'Full where-to-sell marketplace guide';

  @override
  String get featNoAds => 'No ads';

  @override
  String get planYearly => 'Anual';

  @override
  String get planMonthly => 'Mensal';

  @override
  String get planPerYear => 'por ano';

  @override
  String get planPerMonth => 'por mês';

  @override
  String get bestValue => 'MELHOR VALOR';

  @override
  String get trial7Days => '7 dias de avaliação gratuita';

  @override
  String get paywallLegal => 'A subscrição renova-se automaticamente até ser cancelada. Pode geri-la ou cancelá-la a qualquer momento na conta da sua loja.';

  @override
  String get paywallLoadError => 'Não foi possível carregar as opções de subscrição.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get collectionTitle => 'Coleção';

  @override
  String get collectionEmpty => 'A sua coleção está vazia';

  @override
  String get collectionEmptyBody => 'Guarde uma moeda digitalizada para adicioná-la aqui.';

  @override
  String get scanACoin => 'Digitalizar uma moeda';

  @override
  String get collectionAddCoin => 'Add a coin';

  @override
  String get collectionEditHintList => 'Swipe a coin left to remove it, or tap + to add one.';

  @override
  String get collectionEditHintGrid => 'Long-press a coin to remove it, or tap + to add one.';

  @override
  String get collectionManage => 'Edit collection';

  @override
  String get actionOpen => 'Open';

  @override
  String get actionUndo => 'Undo';

  @override
  String get collectionRemoveTitle => 'Remove from collection?';

  @override
  String collectionRemoveBody(String coin) {
    return '$coin stays in your scan history — it just leaves your collection and portfolio total.';
  }

  @override
  String get collectionRemoveAction => 'Remove';

  @override
  String get collectionRemovedToast => 'Removed from your collection';

  @override
  String get searchCoinCountry => 'Pesquisar por moeda ou país';

  @override
  String get sortRecent => 'Recentes';

  @override
  String get sortValueHigh => 'Valor ↓';

  @override
  String get sortRarity => 'Raridade';

  @override
  String get filterRarity => 'Raridade';

  @override
  String get filterCountry => 'País';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterByRarity => 'Filtrar por raridade';

  @override
  String get filterByCountry => 'Filtrar por país';

  @override
  String get noMatchFilters => 'Nenhuma moeda corresponde a esses filtros';

  @override
  String get statCoins => 'Moedas';

  @override
  String get statEstValue => 'Valor est.';

  @override
  String get statMostValuable => 'Mais valiosa';

  @override
  String rarestLabel(String name, String rarity) {
    return 'Mais rara: $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'Não foi possível carregar a sua coleção.';

  @override
  String get historyTitle => 'Histórico';

  @override
  String get historyEmpty => 'Ainda nada digitalizado';

  @override
  String get historyEmptyBody => 'Digitalize uma moeda para começar o seu histórico.';

  @override
  String get historyLoadError => 'Não foi possível carregar o histórico de digitalizações.';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileGuest => 'Convidado';

  @override
  String get sectionSubscription => 'Subscrição';

  @override
  String get coinsightPremium => 'Coinsights Premium';

  @override
  String get freePlan => 'Plano gratuito';

  @override
  String renewsOn(String date) {
    return 'Renova-se a $date';
  }

  @override
  String get subActive => 'Ativa';

  @override
  String get manageSubscription => 'Gerir subscrição';

  @override
  String get manageSubscriptionBody => 'Abre as definições da App Store / Play Store';

  @override
  String get manageSubscriptionHint => 'Faça a gestão ou cancele nas definições da conta da sua loja.';

  @override
  String get sectionPreferences => 'Preferências';

  @override
  String get currencyLabel => 'Moeda';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get replayTutorial => 'Replay the intro';

  @override
  String get languageSystem => 'Predefinição do sistema';

  @override
  String get sectionLegal => 'Aspetos legais';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get sectionDeveloper => 'Programador';

  @override
  String get premiumDebugOverride => 'Premium (substituição de depuração)';

  @override
  String get signOut => 'Terminar sessão';

  @override
  String get deleteAccount => 'Eliminar conta';

  @override
  String get deleteAccountTitle => 'Eliminar a conta?';

  @override
  String get deleteAccountBody => 'Isto elimina permanentemente a sua conta, digitalizações e imagens. Não pode ser anulado.';

  @override
  String appVersion(String version) {
    return 'Coinsights • v$version';
  }

  @override
  String get rankingsTitle => 'Classificações de moedas';

  @override
  String get rankMostValuable => 'Mais valiosas';

  @override
  String get rankRarest => 'Mais raras';

  @override
  String get rankKeyDates => 'Datas-chave';

  @override
  String get rankMostValuableSub => 'Os recordes do mundo da numismática. Raridades extremas — mas mostram quanto uma moeda pode valer.';

  @override
  String get rankRarestSub => 'Moedas que quase nunca chegam ao mercado.';

  @override
  String get rankKeyDatesSub => 'Moedas de aparência comum com uma data ou marca de casa da moeda que vale a pena procurar nos trocos.';

  @override
  String get rankLoadError => 'Não foi possível carregar as classificações.';

  @override
  String get rankSearchHint => 'Pesquisar por nome, país ou denominação';

  @override
  String get rankAllCountries => 'Todos os países';

  @override
  String get rankNoResults => 'Nenhuma moeda corresponde';

  @override
  String get rankNoResultsBody => 'Tente outro termo ou remova o filtro de país.';

  @override
  String get premiumBadge => 'PRO';

  @override
  String paywallTrialFraming(String price) {
    return '7 days free, then $price. Cancel anytime.';
  }

  @override
  String get paywallStartTrial => 'Start free trial';

  @override
  String get ob1Title => 'See what your coin is really worth';

  @override
  String get ob1Accent => 'really worth';

  @override
  String get ob1Sub => 'Never sell for less than it\'s actually worth.';

  @override
  String get ob1CoinName => 'Gold Sovereign';

  @override
  String get ob1RefLabel => 'REFERENCE VALUE';

  @override
  String get ob2Title => 'Valuation spots the rarest 1% of coins';

  @override
  String get ob2Accent => '1%';

  @override
  String get ob2Sub => 'Mint errors, gold and key dates.';

  @override
  String get ob2MeterLabel => 'Extremely rare';

  @override
  String get ob2MeterLow => 'Very common';

  @override
  String get ob2MeterHigh => 'Ultra rare';

  @override
  String get ob3Title => 'Track your whole collection\'s value';

  @override
  String get ob3Accent => 'collection\'s value';

  @override
  String get ob3Sub => 'Anytime, anywhere.';

  @override
  String get ob4Title => 'Scan, discover, decide';

  @override
  String get ob4Accent => 'discover';

  @override
  String get ob4Sub => 'A few seconds and your camera is all it takes.';

  @override
  String get ob4Cta => 'Get started';

  @override
  String get ob4Step1 => 'Photograph both sides';

  @override
  String get ob4Step2 => 'We identify the coin';

  @override
  String get ob4Step3 => 'See its value and rarity';

  @override
  String get portfolioLabel => 'YOUR PORTFOLIO';

  @override
  String get portfolioCoins => 'Coins';

  @override
  String get portfolioCountries => 'Countries';

  @override
  String get portfolioTopCoin => 'Top coin';

  @override
  String get sellGuideTitle => 'Where to sell this coin';

  @override
  String get sellGuideResaleLabel => 'REALISTIC PRIVATE-SALE RANGE';

  @override
  String get sellGuideResaleNote => 'Our estimate of what a private seller nets — below retail because of buyer premiums, dealer margins and the discount collectors expect on a raw coin.';

  @override
  String get sellGuideDisclaimer => 'Ranges are estimated from our valuation model, not actual sale records. A specialist appraisal is worth it before selling anything valuable.';

  @override
  String sellGuideUnlock(int count) {
    return 'Unlock $count more venues and selling tips with PRO';
  }

  @override
  String get sellTierHigh => 'At this value, get the coin professionally graded (PCGS/NGC) and consign it to a major auction house — the wider bidder pool usually more than covers the seller fee.';

  @override
  String get sellTierMid => 'Sharp, well-lit photos of both sides and an honest grade description are what move mid-value coins. Certification is optional but lifts trust for buyers.';

  @override
  String get sellTierLow => 'Everyday coins sell fastest in bulk lots or to a local dealer. Only pay for grading if a specific date/mint mark is the key-date exception.';

  @override
  String get sellEbayName => 'eBay';

  @override
  String get sellEbayBlurb => 'Largest buyer pool by far. Expect ~13% final-value fee plus payment processing. Best for anything from a few euros up to mid four figures.';

  @override
  String get sellHeritageName => 'Heritage Auctions';

  @override
  String get sellHeritageBlurb => 'The biggest numismatic auction house. Worldwide collector reach for rarities; seller commission is negotiable on higher-value consignments.';

  @override
  String get sellStacksName => 'Stack’s Bowers';

  @override
  String get sellStacksBlurb => 'Long-established auction house, strong for US and world coins. Like Heritage, best reserved for genuinely scarce material.';

  @override
  String get sellCertifiedDealerName => 'Certified coin dealer';

  @override
  String get sellCertifiedDealerBlurb => 'A quick, clean sale at a wholesale (buy) price — typically 60–80% of retail. No fees, no shipping risk, cash in hand.';

  @override
  String get sellLocalShopName => 'Local coin shop';

  @override
  String get sellLocalShopBlurb => 'Immediate offer, no listing hassle. Prices are lower than online but there is no fee and no chance of a chargeback.';

  @override
  String get sellForumsName => 'Collector forums';

  @override
  String get sellForumsBlurb => 'Sites like CoinTalk or NGC/PCGS forums have dedicated buy/sell boards. Lower fees than eBay and knowledgeable buyers, but slower.';

  @override
  String get sellCoinShowName => 'Coin show / bourse';

  @override
  String get sellCoinShowBlurb => 'Dozens of dealers in one room means competing offers. Great for selling a group at once; bring a want-list of your own too.';

  @override
  String get sellFacebookName => 'Facebook groups';

  @override
  String get sellFacebookBlurb => 'Active local buy/sell/trade groups for common coins. Meet in a safe public place and use protected payments only.';

  @override
  String get typicalRange => 'INTERVALO TÍPICO';

  @override
  String get scanYoursToCheck => 'Digitalize a sua para verificar';

  @override
  String get rankYears => 'Anos';

  @override
  String get rankKeyDatesLabel => 'Datas-chave';

  @override
  String yearBc(int year) {
    return '$year a.C.';
  }

  @override
  String get errNetwork => 'Sem ligação à Internet. Verifique a sua rede e tente novamente.';

  @override
  String get errServer => 'Algo correu mal do nosso lado. Tente novamente dentro de momentos.';

  @override
  String get errUnknown => 'Erro inesperado. Tente novamente.';

  @override
  String get errNotFound => 'Não encontrámos o que procurava.';

  @override
  String get errAuth => 'Falha na autenticação. Tente novamente.';

  @override
  String get errScanNotFound => 'Não foi possível encontrar essa digitalização.';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String minutesAgo(int m) {
    return 'há $m min';
  }

  @override
  String hoursAgo(int h) {
    return 'há $h h';
  }

  @override
  String daysAgo(int d) {
    return 'há $d d';
  }

  @override
  String get valueDisclaimer => 'Os valores das moedas são estimativas baseadas nos dados disponíveis e podem variar consoante o estado, a autenticidade e a procura do mercado.';

  @override
  String get gradingDisclaimer => 'Esta aplicação não fornece autenticação numismática profissional nem aconselhamento financeiro. As estimativas do estado são aproximadas.';

  @override
  String get condPoor => 'Fraco';

  @override
  String get condFair => 'Razoável';

  @override
  String get condGood => 'Bom (BC)';

  @override
  String get condVeryGood => 'Muito Bom (MBC)';

  @override
  String get condFine => 'Bela (Bela)';

  @override
  String get condVeryFine => 'Muito Bela (Soberba)';

  @override
  String get condExtremelyFine => 'Soberba (Soberba)';

  @override
  String get condUncirculated => 'Flor de Cunho (FDC)';

  @override
  String get rarCommon => 'Comum';

  @override
  String get rarUncommon => 'Pouco comum';

  @override
  String get rarRare => 'Rara';

  @override
  String get rarVeryRare => 'Muito rara';

  @override
  String get rarExtremelyRare => 'Extremamente rara';
}
