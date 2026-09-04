import '../../l10n/app_localizations.dart';

/// Form-field validators. Each takes the current [AppLocalizations] so error
/// messages follow the UI language. Use like:
/// `validator: (v) => Validators.email(v, context.l10n)`.
abstract final class Validators {
  static final RegExp _email = RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  static String? email(String? value, AppLocalizations l) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l.valEmailEmpty;
    if (!_email.hasMatch(v)) return l.valEmailInvalid;
    return null;
  }

  static String? password(String? value, AppLocalizations l) {
    final v = value ?? '';
    if (v.isEmpty) return l.valPasswordEmpty;
    if (v.length < 8) return l.valPasswordShort;
    return null;
  }
}
