// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get langSelectTitle => 'Choose App Language';

  @override
  String get langSelectSubtitle =>
      'Customize the interface language to match your learning preference.';

  @override
  String get langSelectHint =>
      'You can change this language anytime in Settings.';

  @override
  String get langSelectContinueButton => 'Continue';

  @override
  String get langSelectJvSub => 'Javanese';

  @override
  String get langSelectIdSub => 'Default';

  @override
  String get langSelectEnSub => 'For learners worldwide';

  @override
  String get settingsLanguageRow => 'Language';

  @override
  String get settingsLanguageDialogTitle => 'Select Language';

  @override
  String quizProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }
}
