import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

/// Extension on [BuildContext] for clean, type-safe access to [AppLocalizations].
///
/// Usage: `context.l10n.langSelectTitle`
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

