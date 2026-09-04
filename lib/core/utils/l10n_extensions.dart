import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../error/failure.dart';
import '../../features/coin/domain/coin_models.dart';
import '../../features/coin/domain/identification_service.dart';
import '../../features/scan/domain/image_quality.dart';

/// `context.l10n.someKey` — shorthand for `AppLocalizations.of(context)`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension FailureL10n on Failure {
  /// Localised, user-facing message for a failure.
  String localized(AppLocalizations l) => switch (this) {
        NetworkFailure() => l.errNetwork,
        ServerFailure() => l.errServer,
        AuthFailure() => l.errAuth,
        PermissionFailure() => message, // already specific + actionable
        ImageQualityFailure() => message,
        NotFoundFailure() => l.errNotFound,
        UnknownFailure() => l.errUnknown,
      };
}

extension CoinConditionL10n on CoinCondition {
  String localizedLabel(AppLocalizations l) => switch (this) {
        CoinCondition.poor => l.condPoor,
        CoinCondition.fair => l.condFair,
        CoinCondition.good => l.condGood,
        CoinCondition.veryGood => l.condVeryGood,
        CoinCondition.fine => l.condFine,
        CoinCondition.veryFine => l.condVeryFine,
        CoinCondition.extremelyFine => l.condExtremelyFine,
        CoinCondition.uncirculated => l.condUncirculated,
      };
}

extension CoinRarityL10n on CoinRarity {
  String localizedLabel(AppLocalizations l) => switch (this) {
        CoinRarity.common => l.rarCommon,
        CoinRarity.uncommon => l.rarUncommon,
        CoinRarity.rare => l.rarRare,
        CoinRarity.veryRare => l.rarVeryRare,
        CoinRarity.extremelyRare => l.rarExtremelyRare,
      };
}

extension IdentificationStageL10n on IdentificationStage {
  String localizedLabel(AppLocalizations l) => switch (this) {
        IdentificationStage.detectingText => l.stageDetectingText,
        IdentificationStage.identifyingCountry => l.stageIdentifyingCountry,
        IdentificationStage.detectingYear => l.stageDetectingYear,
        IdentificationStage.searchingDatabase => l.stageSearchingDatabase,
        IdentificationStage.calculatingValue => l.stageCalculatingValue,
      };
}

extension ImageQualityIssueL10n on ImageQualityIssue {
  String localizedShort(AppLocalizations l) => switch (this) {
        ImageQualityIssue.lowResolution => l.issueLowResShort,
        ImageQualityIssue.tooDark => l.issueTooDarkShort,
        ImageQualityIssue.tooBright => l.issueTooBrightShort,
        ImageQualityIssue.blurry => l.issueBlurryShort,
        ImageQualityIssue.glare => l.issueGlareShort,
        ImageQualityIssue.coinNotFound => l.issueNoCoinShort,
        ImageQualityIssue.coinTooSmall => l.issueCoinSmallShort,
        ImageQualityIssue.multipleCoins => l.issueMultipleShort,
      };

  String localizedFull(AppLocalizations l) => switch (this) {
        ImageQualityIssue.lowResolution => l.issueLowResFull,
        ImageQualityIssue.tooDark => l.issueTooDarkFull,
        ImageQualityIssue.tooBright => l.issueTooBrightFull,
        ImageQualityIssue.blurry => l.issueBlurryFull,
        ImageQualityIssue.glare => l.issueGlareFull,
        ImageQualityIssue.coinNotFound => l.issueNoCoinFull,
        ImageQualityIssue.coinTooSmall => l.issueCoinSmallFull,
        ImageQualityIssue.multipleCoins => l.issueMultipleFull,
      };
}
