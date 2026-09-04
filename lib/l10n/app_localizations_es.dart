// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Descubre cuánto valen realmente tus monedas.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionSkip => 'Omitir';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get wordOr => 'o';

  @override
  String get navHome => 'Inicio';

  @override
  String get navCollection => 'Colección';

  @override
  String get navScan => 'Escanear';

  @override
  String get navHistory => 'Historial';

  @override
  String get navProfile => 'Perfil';

  @override
  String get actionShare => 'Compartir';

  @override
  String shareCoinText(String coin, String value) {
    return '$coin — valor estimado $value. Identificada con Coinsight.';
  }

  @override
  String get offlineBanner => 'Sin conexión — los escaneos guardados funcionan';

  @override
  String get onboard1Title => 'Descubre tus monedas';

  @override
  String get onboard1Body => 'Escanea cualquier moneda y descubre al instante de qué se trata.';

  @override
  String get onboard2Title => 'Descubre cuánto vale';

  @override
  String get onboard2Body => 'Obtén un valor de mercado estimado basado en datos reales.';

  @override
  String get onboard3Title => 'Desbloquea la IA Coin Intelligence';

  @override
  String get onboard3Body => 'Descubre la historia, la rareza y el potencial de venta de tus monedas.';

  @override
  String get onboardStart => 'Empezar a escanear';

  @override
  String get authSubtitle => 'Inicia sesión para sincronizar tu colección en todos tus dispositivos.';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authPassword8 => 'Contraseña (mín. 8 caracteres)';

  @override
  String get authName => 'Nombre (opcional)';

  @override
  String get authForgot => '¿Olvidaste tu contraseña?';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authGoogle => 'Continuar con Google';

  @override
  String get authApple => 'Continuar con Apple';

  @override
  String get authGuest => 'Explorar sin cuenta';

  @override
  String get authNewHere => '¿Eres nuevo?';

  @override
  String get authCreate => 'Crear una cuenta';

  @override
  String get authCreateTitle => 'Crear cuenta';

  @override
  String get authCreateCta => 'Crear cuenta';

  @override
  String get authResetSent => 'Si existe una cuenta con ese correo, te llegará un enlace para restablecer la contraseña.';

  @override
  String get authNoAccountForEmail => 'No se encontró ninguna cuenta con ese correo.';

  @override
  String get authTerms => 'Al continuar aceptas los Términos de servicio y la Política de privacidad de Coinsight.';

  @override
  String get authCreateSyncHint => 'Crea una cuenta para sincronizar tu colección';

  @override
  String get valEmailEmpty => 'Introduce tu correo electrónico';

  @override
  String get valEmailInvalid => 'Introduce un correo electrónico válido';

  @override
  String get valPasswordEmpty => 'Introduce una contraseña';

  @override
  String get valPasswordShort => 'Usa al menos 8 caracteres';

  @override
  String valFieldRequired(String field) {
    return '$field es obligatorio';
  }

  @override
  String get homeWelcome => 'Bienvenido';

  @override
  String homeWelcomeNamed(String name) {
    return 'Bienvenido, $name';
  }

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get howItWorksScan => 'Escanea';

  @override
  String get howItWorksScanBody => 'Fotografía el anverso y el reverso de la moneda.';

  @override
  String get howItWorksIdentify => 'Identifica';

  @override
  String get howItWorksIdentifyBody => 'La comparamos con bases de datos numismáticas.';

  @override
  String get howItWorksValue => 'Valora';

  @override
  String get howItWorksValueBody => 'Consulta un rango de valor de mercado estimado.';

  @override
  String get mostValuableCoins => 'Monedas más valiosas';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get recentScans => 'Escaneos recientes';

  @override
  String get noScansYet => 'Aún no hay escaneos';

  @override
  String get noScansYetBody => 'Tus monedas escaneadas aparecerán aquí.';

  @override
  String get unlockBannerTitle => 'Desbloquea la IA Coin Intelligence';

  @override
  String get unlockBannerBody => 'Historia, rareza, estado y cómo venderla.';

  @override
  String get scanTitle => 'Escanear una moneda';

  @override
  String get scanReset => 'Restablecer';

  @override
  String get scanFront => 'Escanea el anverso';

  @override
  String get scanFrontShort => 'Anverso';

  @override
  String get scanBack => 'Escanea el reverso (opcional)';

  @override
  String get scanBackShort => 'Reverso';

  @override
  String get forBestResult => 'Para un mejor resultado';

  @override
  String get tipPlainBackground => 'Coloca la moneda sobre un fondo liso.';

  @override
  String get tipWholeCoin => 'Asegúrate de que toda la moneda sea visible.';

  @override
  String get tipLighting => 'Usa una luz buena y uniforme.';

  @override
  String get tipGlare => 'Evita reflejos y brillos.';

  @override
  String get identifyCoin => 'Identificar moneda';

  @override
  String get takePhoto => 'Hacer una foto';

  @override
  String get uploadFromLibrary => 'Subir desde la galería';

  @override
  String get couldNotOpenImage => 'No se pudo abrir esa imagen. Comprueba los permisos de fotos en Ajustes.';

  @override
  String tapToRetakeWith(String issue) {
    return 'Toca para repetir · $issue';
  }

  @override
  String get cameraPromptFront => 'Escanea el anverso de la moneda';

  @override
  String get cameraPromptBack => 'Escanea el reverso de la moneda';

  @override
  String get cameraHint => 'Llena el círculo · fondo liso · pulso firme';

  @override
  String get cameraAccessOffTitle => 'El acceso a la cámara está desactivado';

  @override
  String get cameraAccessOffBody => 'Activa el acceso a la cámara para Coinsight en los Ajustes del dispositivo y vuelve para escanear. También puedes subir una foto.';

  @override
  String get cameraUsePhotoInstead => 'Usar una foto';

  @override
  String get cameraNoneTitle => 'No hay cámara disponible';

  @override
  String get cameraNoneBody => 'Este dispositivo no tiene una cámara utilizable. Sube una foto.';

  @override
  String get cameraUploadPhoto => 'Subir una foto';

  @override
  String get cameraCaptureFailed => 'No se pudo hacer la foto. Inténtalo de nuevo.';

  @override
  String get qualityRetakeNeeded => 'Hay que repetir la foto';

  @override
  String get qualityCouldBeBetter => 'Esta foto podría ser mejor';

  @override
  String get qualityRetake => 'Repetir';

  @override
  String get qualityUseAnyway => 'Usar esta foto de todos modos';

  @override
  String get issueLowResShort => 'Baja resolución';

  @override
  String get issueLowResFull => 'Esta imagen es demasiado pequeña. Usa la cámara a máxima calidad o elige una foto más grande.';

  @override
  String get issueTooDarkShort => 'Demasiado oscura';

  @override
  String get issueTooDarkFull => 'La foto es demasiado oscura. Muévete a una luz más intensa y uniforme.';

  @override
  String get issueTooBrightShort => 'Sobreexpuesta';

  @override
  String get issueTooBrightFull => 'La foto está sobreexpuesta. Reduce la luz directa o apártate de los brillos.';

  @override
  String get issueBlurryShort => 'Borrosa';

  @override
  String get issueBlurryFull => 'La imagen está demasiado borrosa. Mantén el teléfono quieto, toca para enfocar y asegúrate de que la moneda esté nítida.';

  @override
  String get issueGlareShort => 'Reflejos';

  @override
  String get issueGlareFull => 'Hay reflejos fuertes en la moneda. Inclínala un poco o usa una luz más suave e indirecta.';

  @override
  String get issueNoCoinShort => 'No se detecta ninguna moneda';

  @override
  String get issueNoCoinFull => 'No encontramos ninguna moneda. Coloca una sola moneda sobre un fondo liso que ocupe la mayor parte del encuadre.';

  @override
  String get issueCoinSmallShort => 'Moneda demasiado pequeña';

  @override
  String get issueCoinSmallFull => 'Acércate para que la moneda ocupe la mayor parte del círculo.';

  @override
  String get issueMultipleShort => 'Varios objetos';

  @override
  String get issueMultipleFull => 'Hemos detectado más de un objeto. Escanea una sola moneda cada vez.';

  @override
  String get analyzingCoin => 'Analizando la moneda…';

  @override
  String get stageDetectingText => 'Detectando el texto';

  @override
  String get stageIdentifyingCountry => 'Identificando el país';

  @override
  String get stageDetectingYear => 'Detectando el año';

  @override
  String get stageSearchingDatabase => 'Buscando en la base de datos numismática';

  @override
  String get stageCalculatingValue => 'Calculando el valor';

  @override
  String get resultTitle => 'Resultado de la moneda';

  @override
  String get loadingResult => 'Cargando el resultado…';

  @override
  String get resultOpenError => 'No se pudo abrir este resultado.';

  @override
  String confidenceValue(String percent) {
    return '$percent de confianza';
  }

  @override
  String get estimatedMarketValue => 'VALOR DE MERCADO ESTIMADO';

  @override
  String typicalEstimate(String value) {
    return 'Estimación típica $value';
  }

  @override
  String get whatAffectsValue => 'Qué influye en este valor';

  @override
  String moreInFullAnalysis(int count) {
    return '+$count más en el análisis completo del valor';
  }

  @override
  String get notConfidentMatch => 'Coincidencia no fiable';

  @override
  String get notConfidentBody => 'No hemos podido identificar esta moneda con seguridad. Posibles coincidencias:';

  @override
  String get detailCountry => 'País';

  @override
  String get detailYear => 'Año';

  @override
  String get detailDenomination => 'Denominación';

  @override
  String get detailMaterial => 'Material';

  @override
  String get detailMint => 'Ceca';

  @override
  String get detailDiameter => 'Diámetro';

  @override
  String get detailWeight => 'Peso';

  @override
  String get detailConditionEst => 'Estado (est.)';

  @override
  String get detailRarityEst => 'Rareza (est.)';

  @override
  String get saveToCollection => 'Guardar en la colección';

  @override
  String get savedToCollection => 'Guardada en tu colección';

  @override
  String get unlockAiTitle => 'Desbloquea la IA Coin Intelligence';

  @override
  String get aiFeatHistory => 'La historia completa';

  @override
  String get aiFeatValue => 'Por qué la valoran los coleccionistas';

  @override
  String get aiFeatRarity => 'Análisis de rareza';

  @override
  String get aiFeatCondition => 'Análisis del estado';

  @override
  String get aiFeatSelling => 'Cómo venderla';

  @override
  String get unlockPremium => 'Desbloquear Premium';

  @override
  String get aiCoinIntelligence => 'IA Coin Intelligence';

  @override
  String get generateAiAnalysis => 'Generar análisis con IA';

  @override
  String get askAiAssistant => 'Pregunta al asistente de IA';

  @override
  String get aiCtaHistory => 'Historia de la moneda y contexto histórico';

  @override
  String get aiCtaValue => 'Por qué tiene valor, factor a factor';

  @override
  String get aiCtaRarityCondition => 'Análisis de rareza y estado';

  @override
  String get aiCtaSelling => 'Estrategia de venta y precio';

  @override
  String get coinStory => 'Historia de la moneda';

  @override
  String get whyItHasValue => 'Por qué tiene valor';

  @override
  String get rarityAnalysis => 'Análisis de rareza';

  @override
  String get conditionEstimate => 'Estimación del estado';

  @override
  String get sellingRecommendations => 'Recomendaciones de venta';

  @override
  String get collectorInsights => 'Información para coleccionistas';

  @override
  String get generatingAnalysis => 'Generando el análisis de la moneda con IA…';

  @override
  String get aiUnavailable => 'El análisis con IA no está disponible temporalmente.';

  @override
  String get estimatedSellingPrice => 'Precio de venta estimado';

  @override
  String get suggestedListingPrice => 'Precio de publicación sugerido';

  @override
  String get minimumReasonablePrice => 'Precio mínimo razonable';

  @override
  String get whereToSell => 'Dónde vender';

  @override
  String get auctionSuitable => '¿Apta para subasta?';

  @override
  String get professionalAppraisal => 'Tasación profesional';

  @override
  String get aiAssistantTitle => 'Asistente de IA para monedas';

  @override
  String aiTalkingAbout(String coin) {
    return 'Hablando de: $coin';
  }

  @override
  String get aiAskHint => 'Pregunta sobre esta moneda…';

  @override
  String get aiAssistantIntro => 'Pregunta al asistente lo que quieras sobre esta moneda';

  @override
  String get aiCouldNotOpen => 'No se pudo abrir esta moneda.';

  @override
  String get qWhyValuable => '¿Por qué tiene valor esta moneda?';

  @override
  String get qIsRare => '¿Es rara esta moneda?';

  @override
  String get qWhereSell => '¿Dónde debería venderla?';

  @override
  String get qAuthenticate => '¿Debería autenticar esta moneda?';

  @override
  String get qHowMuchList => '¿A qué precio debería publicarla?';

  @override
  String get paywallHeadline => 'Desbloquea toda la historia detrás de cada moneda';

  @override
  String get paywallSubheadline => 'Descubre la historia, la rareza y la mejor forma de vender tus monedas.';

  @override
  String get featAiAnalysis => 'Análisis detallado con IA';

  @override
  String get featCoinHistory => 'Historia de la moneda';

  @override
  String get featRarityInsights => 'Información sobre la rareza';

  @override
  String get featConditionAnalysis => 'Análisis del estado';

  @override
  String get featSellingRecs => 'Recomendaciones de venta';

  @override
  String get featCollectorInsights => 'Información para coleccionistas';

  @override
  String get featAiAssistant => 'Asistente de IA para monedas';

  @override
  String get featAdvancedStats => 'Estadísticas avanzadas de la colección';

  @override
  String get planYearly => 'Anual';

  @override
  String get planMonthly => 'Mensual';

  @override
  String get planPerYear => 'al año';

  @override
  String get planPerMonth => 'al mes';

  @override
  String get bestValue => 'MEJOR OPCIÓN';

  @override
  String get trial7Days => '7 días de prueba gratis';

  @override
  String get paywallLegal => 'La suscripción se renueva automáticamente hasta que se cancele. Puedes gestionarla o cancelarla en cualquier momento desde tu cuenta de la tienda.';

  @override
  String get paywallLoadError => 'No se pudieron cargar las opciones de suscripción.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get collectionTitle => 'Colección';

  @override
  String get collectionEmpty => 'Tu colección está vacía';

  @override
  String get collectionEmptyBody => 'Guarda una moneda escaneada para añadirla aquí.';

  @override
  String get scanACoin => 'Escanear una moneda';

  @override
  String get searchCoinCountry => 'Buscar por moneda o país';

  @override
  String get sortRecent => 'Recientes';

  @override
  String get sortValueHigh => 'Valor ↓';

  @override
  String get sortRarity => 'Rareza';

  @override
  String get filterRarity => 'Rareza';

  @override
  String get filterCountry => 'País';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterByRarity => 'Filtrar por rareza';

  @override
  String get filterByCountry => 'Filtrar por país';

  @override
  String get noMatchFilters => 'Ninguna moneda coincide con esos filtros';

  @override
  String get statCoins => 'Monedas';

  @override
  String get statEstValue => 'Valor est.';

  @override
  String get statMostValuable => 'Más valiosa';

  @override
  String rarestLabel(String name, String rarity) {
    return 'Más rara: $name ($rarity)';
  }

  @override
  String get collectionLoadError => 'No se pudo cargar tu colección.';

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyEmpty => 'Aún no has escaneado nada';

  @override
  String get historyEmptyBody => 'Escanea una moneda para empezar a crear tu historial.';

  @override
  String get historyLoadError => 'No se pudo cargar el historial de escaneos.';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileGuest => 'Invitado';

  @override
  String get sectionSubscription => 'Suscripción';

  @override
  String get coinsightPremium => 'Coinsight Premium';

  @override
  String get freePlan => 'Plan gratuito';

  @override
  String renewsOn(String date) {
    return 'Se renueva el $date';
  }

  @override
  String get subActive => 'Activa';

  @override
  String get manageSubscription => 'Gestionar suscripción';

  @override
  String get manageSubscriptionBody => 'Abre los ajustes de App Store / Play Store';

  @override
  String get manageSubscriptionHint => 'Gestiona o cancela desde los ajustes de tu cuenta de la tienda.';

  @override
  String get sectionPreferences => 'Preferencias';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get sectionLegal => 'Aviso legal';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get sectionDeveloper => 'Desarrollador';

  @override
  String get premiumDebugOverride => 'Premium (anulación de depuración)';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountTitle => '¿Eliminar la cuenta?';

  @override
  String get deleteAccountBody => 'Esto elimina permanentemente tu cuenta, tus escaneos y tus imágenes. No se puede deshacer.';

  @override
  String appVersion(String version) {
    return 'Coinsight • v$version';
  }

  @override
  String get rankingsTitle => 'Rankings de monedas';

  @override
  String get rankMostValuable => 'Más valiosas';

  @override
  String get rankRarest => 'Más raras';

  @override
  String get rankKeyDates => 'Fechas clave';

  @override
  String get rankMostValuableSub => 'Los récords del mundo de la numismática. Rarezas extremas, pero muestran cuánto puede valer una moneda.';

  @override
  String get rankRarestSub => 'Monedas que casi nunca salen al mercado.';

  @override
  String get rankKeyDatesSub => 'Monedas de aspecto corriente con una fecha o marca de ceca por la que merece la pena revisar el cambio.';

  @override
  String get rankLoadError => 'No se pudieron cargar los rankings.';

  @override
  String get typicalRange => 'RANGO TÍPICO';

  @override
  String get scanYoursToCheck => 'Escanea la tuya para comprobarlo';

  @override
  String get rankYears => 'Años';

  @override
  String get rankKeyDatesLabel => 'Fechas clave';

  @override
  String yearBc(int year) {
    return '$year a. C.';
  }

  @override
  String get errNetwork => 'Sin conexión a Internet. Comprueba tu red e inténtalo de nuevo.';

  @override
  String get errServer => 'Algo ha ido mal por nuestra parte. Inténtalo de nuevo en un momento.';

  @override
  String get errUnknown => 'Error inesperado. Inténtalo de nuevo.';

  @override
  String get errNotFound => 'No hemos encontrado lo que buscabas.';

  @override
  String get errAuth => 'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get errScanNotFound => 'No se pudo encontrar ese escaneo.';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String minutesAgo(int m) {
    return 'hace $m min';
  }

  @override
  String hoursAgo(int h) {
    return 'hace $h h';
  }

  @override
  String daysAgo(int d) {
    return 'hace $d d';
  }

  @override
  String get valueDisclaimer => 'Los valores de las monedas son estimaciones basadas en los datos disponibles y pueden variar según el estado, la autenticidad y la demanda del mercado.';

  @override
  String get gradingDisclaimer => 'Esta aplicación no ofrece autenticación numismática profesional ni asesoramiento financiero. Las estimaciones del estado son aproximadas.';

  @override
  String get condPoor => 'Malo';

  @override
  String get condFair => 'Regular';

  @override
  String get condGood => 'Bueno';

  @override
  String get condVeryGood => 'Muy bueno';

  @override
  String get condFine => 'Bien conservada (BC)';

  @override
  String get condVeryFine => 'Muy bien conservada (MBC)';

  @override
  String get condExtremelyFine => 'Excelente (EBC)';

  @override
  String get condUncirculated => 'Sin circular (SC)';

  @override
  String get rarCommon => 'Común';

  @override
  String get rarUncommon => 'Poco común';

  @override
  String get rarRare => 'Rara';

  @override
  String get rarVeryRare => 'Muy rara';

  @override
  String get rarExtremelyRare => 'Extremadamente rara';
}
