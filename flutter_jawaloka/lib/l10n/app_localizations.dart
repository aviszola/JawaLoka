import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_jv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('jv'),
  ];

  /// Judul layar pemilihan bahasa
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa Pengantar'**
  String get langSelectTitle;

  /// Subjudul layar pemilihan bahasa
  ///
  /// In id, this message translates to:
  /// **'Sesuaikan bahasa antarmuka aplikasi dengan kenyamanan belajarmu.'**
  String get langSelectSubtitle;

  /// Petunjuk bawah layar pemilihan bahasa
  ///
  /// In id, this message translates to:
  /// **'Kamu dapat mengubah pilihan bahasa ini kapan saja melalui menu Pengaturan.'**
  String get langSelectHint;

  /// Label tombol lanjut pada layar pemilihan bahasa
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get langSelectContinueButton;

  /// Keterangan kartu pilihan bahasa Jawa
  ///
  /// In id, this message translates to:
  /// **'Bahasa Jawa'**
  String get langSelectJvSub;

  /// Keterangan kartu pilihan bahasa Indonesia
  ///
  /// In id, this message translates to:
  /// **'Bawaan'**
  String get langSelectIdSub;

  /// Keterangan kartu pilihan bahasa Inggris
  ///
  /// In id, this message translates to:
  /// **'Untuk pelajar seluruh dunia'**
  String get langSelectEnSub;

  /// Label baris pengaturan bahasa di layar Pengaturan
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguageRow;

  /// Judul dialog pemilihan bahasa di Pengaturan
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get settingsLanguageDialogTitle;

  /// Format kemajuan nomor kuis
  ///
  /// In id, this message translates to:
  /// **'Soal {current} dari {total}'**
  String quizProgress(int current, int total);

  /// Jumlah hari streak belajar
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =1{1 hari} other{{count} hari}}'**
  String streakDays(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'jv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'jv':
      return AppLocalizationsJv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
