// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get langSelectTitle => 'Pilih Bahasa Pengantar';

  @override
  String get langSelectSubtitle =>
      'Sesuaikan bahasa antarmuka aplikasi dengan kenyamanan belajarmu.';

  @override
  String get langSelectHint =>
      'Kamu dapat mengubah pilihan bahasa ini kapan saja melalui menu Pengaturan.';

  @override
  String get langSelectContinueButton => 'Lanjut';

  @override
  String get langSelectJvSub => 'Bahasa Jawa';

  @override
  String get langSelectIdSub => 'Bawaan';

  @override
  String get langSelectEnSub => 'Untuk pelajar seluruh dunia';

  @override
  String get settingsLanguageRow => 'Bahasa';

  @override
  String get settingsLanguageDialogTitle => 'Pilih Bahasa';

  @override
  String quizProgress(int current, int total) {
    return 'Soal $current dari $total';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
      one: '1 hari',
    );
    return '$_temp0';
  }
}
