// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Javanese (`jv`).
class AppLocalizationsJv extends AppLocalizations {
  AppLocalizationsJv([String locale = 'jv']) : super(locale);

  @override
  String get langSelectTitle => 'Pilih Basa Pitedah';

  @override
  String get langSelectSubtitle =>
      'Cocogna basa antarmuka aplikasi manut kepenake anggonmu sinau.';

  @override
  String get langSelectHint =>
      'Panjenengan saged ngowahi pilihan basa punika kapan kemawon lumantar menu Pengaturan.';

  @override
  String get langSelectContinueButton => 'Lajeng';

  @override
  String get langSelectJvSub => 'Basa Jawa';

  @override
  String get langSelectIdSub => 'Bawaan';

  @override
  String get langSelectEnSub => 'Kanggo para pambelajar saindenging jagad';

  @override
  String get settingsLanguageRow => 'Basa';

  @override
  String get settingsLanguageDialogTitle => 'Pilih Basa';

  @override
  String quizProgress(int current, int total) {
    return 'Pitakon $current saka $total';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dina',
      one: '1 dina',
    );
    return '$_temp0';
  }
}
