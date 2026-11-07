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

  /// Nama merek aplikasi
  ///
  /// In id, this message translates to:
  /// **'JawaLoka'**
  String get splashAppName;

  /// Tagline merek di layar splash
  ///
  /// In id, this message translates to:
  /// **'Belajar bahasa dan aksara Jawa setiap hari'**
  String get splashAppTagline;

  /// Label semantik loading pada splash screen
  ///
  /// In id, this message translates to:
  /// **'Memuat aplikasi...'**
  String get splashLoadingLabel;

  /// Judul banner budaya di layar autentikasi
  ///
  /// In id, this message translates to:
  /// **'Selamat datang di JawaLoka'**
  String get authWelcomeBannerTitle;

  /// Subjudul banner budaya di layar autentikasi
  ///
  /// In id, this message translates to:
  /// **'Lestarikan warisan leluhur nusantara'**
  String get authWelcomeBannerSubtitle;

  /// Label semantik tombol navigasi kembali
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get commonBack;

  /// Label semantik tombol tutup pesan error
  ///
  /// In id, this message translates to:
  /// **'Tutup pesan error'**
  String get commonCloseError;

  /// Label input nama lengkap
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get authFullNameLabel;

  /// Label input alamat email
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// Label input kata sandi
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get authPasswordLabel;

  /// Label semantik lihat kata sandi
  ///
  /// In id, this message translates to:
  /// **'Tampilkan kata sandi'**
  String get authShowPassword;

  /// Label semantik sembunyikan kata sandi
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan kata sandi'**
  String get authHidePassword;

  /// Pesan validasi nama wajib diisi
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong'**
  String get validationNameRequired;

  /// Pesan validasi format email tidak valid
  ///
  /// In id, this message translates to:
  /// **'Format email belum benar'**
  String get validationEmailInvalid;

  /// Pesan validasi panjang kata sandi kurang
  ///
  /// In id, this message translates to:
  /// **'Kata sandi minimal 8 karakter'**
  String get validationPasswordMinLength;

  /// Pesan validasi kata sandi wajib diisi
  ///
  /// In id, this message translates to:
  /// **'Kata sandi tidak boleh kosong'**
  String get validationPasswordEmpty;

  /// Judul utama halaman login
  ///
  /// In id, this message translates to:
  /// **'Masuk ke akunmu'**
  String get loginTitle;

  /// Subjudul halaman login
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan progres belajarmu di mana saja'**
  String get loginSubtitle;

  /// Pesan kesalahan autentikasi login
  ///
  /// In id, this message translates to:
  /// **'Email atau kata sandi salah'**
  String get loginInvalidCredentialsError;

  /// Tautan lupa kata sandi
  ///
  /// In id, this message translates to:
  /// **'Lupa kata sandi?'**
  String get loginForgotPassword;

  /// Tombol utama masuk di layar login
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginButton;

  /// Pemisah opsi alternatif masuk
  ///
  /// In id, this message translates to:
  /// **'Atau masuk dengan'**
  String get loginOrWith;

  /// Tombol masuk dengan akun Google
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan dengan Google'**
  String get loginGoogleButton;

  /// Teks ajakan pendaftaran di footer login
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? '**
  String get loginDontHaveAccount;

  /// Tautan navigasi ke halaman pendaftaran
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get loginRegisterLink;

  /// Judul utama halaman pendaftaran
  ///
  /// In id, this message translates to:
  /// **'Buat akunmu'**
  String get registerTitle;

  /// Subjudul halaman pendaftaran
  ///
  /// In id, this message translates to:
  /// **'Simpan progres belajarmu di mana saja'**
  String get registerSubtitle;

  /// Petunjuk kekuatan kata sandi di layar pendaftaran
  ///
  /// In id, this message translates to:
  /// **'Gunakan kata sandi yang kuat (min. 8 karakter)'**
  String get registerPasswordHint;

  /// Tombol utama pendaftaran akun
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerButton;

  /// Teks pengantar persetujuan syarat ketentuan
  ///
  /// In id, this message translates to:
  /// **'Dengan mendaftar, kamu menyetujui '**
  String get registerTermsPrefix;

  /// Label tautan kebijakan privasi
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get registerPrivacyPolicy;

  /// Teks pengantar masuk di footer pendaftaran
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? '**
  String get registerAlreadyHaveAccount;

  /// Tautan navigasi ke halaman masuk
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get registerLoginLink;

  /// Label tab navigasi Beranda
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// Label tab navigasi Belajar
  ///
  /// In id, this message translates to:
  /// **'Belajar'**
  String get navLearn;

  /// Label tombol tengah Quest
  ///
  /// In id, this message translates to:
  /// **'Quest'**
  String get navQuest;

  /// Label tab navigasi Kuis
  ///
  /// In id, this message translates to:
  /// **'Kuis'**
  String get navQuiz;

  /// Label tab navigasi Profil
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Sapaan pagi hari di Beranda
  ///
  /// In id, this message translates to:
  /// **'Selamat pagi'**
  String get homeGreetingMorning;

  /// Sapaan siang hari di Beranda
  ///
  /// In id, this message translates to:
  /// **'Selamat siang'**
  String get homeGreetingAfternoon;

  /// Sapaan sore hari di Beranda
  ///
  /// In id, this message translates to:
  /// **'Selamat sore'**
  String get homeGreetingEvening;

  /// Sapaan malam hari di Beranda
  ///
  /// In id, this message translates to:
  /// **'Selamat malam'**
  String get homeGreetingNight;

  /// Sapaan nama pengguna di Beranda
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}!'**
  String homeGreetingUser(String name);

  /// Label pill level di samping avatar Beranda
  ///
  /// In id, this message translates to:
  /// **'L{level}'**
  String homeLevelPill(int level);

  /// Judul strip mingguan kuis di Beranda
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Kuis Minggu Ini'**
  String get homeWeeklyStripTitle;

  /// Jumlah kuis selesai minggu ini
  ///
  /// In id, this message translates to:
  /// **'{count} kuis selesai'**
  String homeWeeklyCompletedCount(int count);

  /// Pesan info streak pada strip mingguan
  ///
  /// In id, this message translates to:
  /// **'Streak kuis {count} hari aktif. Selesaikan kuis harian untuk menjaga streak.'**
  String homeWeeklyStreakInfo(int count);

  /// Singkatan hari Senin
  ///
  /// In id, this message translates to:
  /// **'Sen'**
  String get dayMon;

  /// Singkatan hari Selasa
  ///
  /// In id, this message translates to:
  /// **'Sel'**
  String get dayTue;

  /// Singkatan hari Rabu
  ///
  /// In id, this message translates to:
  /// **'Rab'**
  String get dayWed;

  /// Singkatan hari Kamis
  ///
  /// In id, this message translates to:
  /// **'Kam'**
  String get dayThu;

  /// Singkatan hari Jumat
  ///
  /// In id, this message translates to:
  /// **'Jum'**
  String get dayFri;

  /// Singkatan hari Sabtu
  ///
  /// In id, this message translates to:
  /// **'Sab'**
  String get daySat;

  /// Singkatan hari Minggu
  ///
  /// In id, this message translates to:
  /// **'Min'**
  String get daySun;

  /// Badge kartu misi harian
  ///
  /// In id, this message translates to:
  /// **'MISI HARI INI'**
  String get homeHeroQuestBadge;

  /// Target presisi misi harian
  ///
  /// In id, this message translates to:
  /// **'Target: ≥85% Presisi'**
  String get homeHeroQuestTarget;

  /// Judul aksara misi harian
  ///
  /// In id, this message translates to:
  /// **'Aksara \"Ha\" (ꦲ)'**
  String get homeHeroQuestTitle;

  /// Deskripsi panduan misi harian
  ///
  /// In id, this message translates to:
  /// **'Tulis aksara dasar pertama Hanacaraka dengan goresan tepat.'**
  String get homeHeroQuestDesc;

  /// Tombol aksi mulai menggambar di kartu hero
  ///
  /// In id, this message translates to:
  /// **'Mulai Menggambar'**
  String get homeHeroQuestButton;

  /// Judul kartu lanjutkan kuis di Beranda
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Kuis'**
  String get homeContinueQuizTitle;

  /// Label tingkat kesulitan di kartu lanjutkan kuis
  ///
  /// In id, this message translates to:
  /// **'Tingkat: Mahir'**
  String get homeContinueQuizLevel;

  /// Subjudul bab kuis aktif di kartu lanjutkan kuis
  ///
  /// In id, this message translates to:
  /// **'Node 4: Aksara Ra (ꦫ)'**
  String get homeContinueQuizNode;

  /// Progres bab terselesaikan di kartu lanjutkan kuis
  ///
  /// In id, this message translates to:
  /// **'{completed} dari 10 bab kuis terselesaikan'**
  String homeContinueQuizProgress(int completed);

  /// Tombol menuju jalur kuis di Beranda
  ///
  /// In id, this message translates to:
  /// **'Buka Jalur Kuis'**
  String get homeContinueQuizButton;

  /// Judul bagian belajar cepat di Beranda
  ///
  /// In id, this message translates to:
  /// **'Belajar Cepat'**
  String get homeQuickLearnTitle;

  /// Subjudul bagian belajar cepat di Beranda
  ///
  /// In id, this message translates to:
  /// **'Topik Ringkas'**
  String get homeQuickLearnSubtitle;

  /// Judul item kosa kata di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Kosa Kata'**
  String get homeQuickLearnVocab;

  /// Keterangan item kosa kata di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'3 Tingkat'**
  String get homeQuickLearnVocabSub;

  /// Judul item aksara di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Aksara Jawa'**
  String get homeQuickLearnAksara;

  /// Keterangan item aksara di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Hanacaraka'**
  String get homeQuickLearnAksaraSub;

  /// Judul item penerjemah di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Penerjemah'**
  String get homeQuickLearnTranslator;

  /// Keterangan item penerjemah di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Ngoko-Krama'**
  String get homeQuickLearnTranslatorSub;

  /// Judul item etika wicara di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Penggunaan Bahasa'**
  String get homeQuickLearnEtiquette;

  /// Keterangan item etika wicara di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Unggah-Ungguh'**
  String get homeQuickLearnEtiquetteSub;

  /// Judul item peribahasa di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Peribahasa'**
  String get homeQuickLearnProverbs;

  /// Keterangan item peribahasa di belajar cepat
  ///
  /// In id, this message translates to:
  /// **'Paribasan'**
  String get homeQuickLearnProverbsSub;

  /// Judul header layar Pusat Belajar
  ///
  /// In id, this message translates to:
  /// **'Pusat Belajar'**
  String get learnHeaderTitle;

  /// Subjudul header layar Pusat Belajar
  ///
  /// In id, this message translates to:
  /// **'Eksplorasi warisan budaya dan bahasa Jawa'**
  String get learnHeaderSubtitle;

  /// Judul bagian modul di Belajar
  ///
  /// In id, this message translates to:
  /// **'Modul Pembelajaran'**
  String get learnSectionModules;

  /// Judul bagian kata harian di Belajar
  ///
  /// In id, this message translates to:
  /// **'Tembung Dina Iki'**
  String get learnSectionDailyWord;

  /// Status modul terkunci
  ///
  /// In id, this message translates to:
  /// **'Terkunci'**
  String get moduleCardLocked;

  /// Judul modul aksara Jawa
  ///
  /// In id, this message translates to:
  /// **'Aksara Jawa Dhasar'**
  String get learnModuleAksaraTitle;

  /// Subjudul modul aksara Jawa
  ///
  /// In id, this message translates to:
  /// **'Hanacaraka — 20 aksara dasar, sandhangan & pasangan'**
  String get learnModuleAksaraSubtitle;

  /// Label progres modul aksara Jawa
  ///
  /// In id, this message translates to:
  /// **'20 aksara terselesaikan'**
  String get learnModuleAksaraLabel;

  /// Judul modul kosa kata kamus
  ///
  /// In id, this message translates to:
  /// **'Kosa Kata (Kamus)'**
  String get learnModuleVocabTitle;

  /// Subjudul modul kosa kata kamus
  ///
  /// In id, this message translates to:
  /// **'Kamus 3 tingkat tutur: Ngoko, Krama Madya, Krama Inggil'**
  String get learnModuleVocabSubtitle;

  /// Label progres modul kosa kata
  ///
  /// In id, this message translates to:
  /// **'120 tembung terselesaikan'**
  String get learnModuleVocabLabel;

  /// Judul modul penerjemah bahasa
  ///
  /// In id, this message translates to:
  /// **'Penerjemah Bahasa'**
  String get learnModuleTranslatorTitle;

  /// Subjudul modul penerjemah bahasa
  ///
  /// In id, this message translates to:
  /// **'Terjemahan dwiarah Indonesia, Ngoko, dan Krama'**
  String get learnModuleTranslatorSubtitle;

  /// Label modul penerjemah siap digunakan
  ///
  /// In id, this message translates to:
  /// **'Siap Digunakan'**
  String get learnModuleTranslatorLabel;

  /// Judul modul unggah-ungguh wicara
  ///
  /// In id, this message translates to:
  /// **'Penggunaan Bahasa'**
  String get learnModuleEtiquetteTitle;

  /// Subjudul modul unggah-ungguh wicara
  ///
  /// In id, this message translates to:
  /// **'Unggah-ungguh & tata krama ragam wicara'**
  String get learnModuleEtiquetteSubtitle;

  /// Label progres modul wicara
  ///
  /// In id, this message translates to:
  /// **'4 tingkatan tutur'**
  String get learnModuleEtiquetteLabel;

  /// Judul modul peribahasa dan saloka
  ///
  /// In id, this message translates to:
  /// **'Peribahasa & Saloka'**
  String get learnModuleProverbsTitle;

  /// Subjudul modul peribahasa dan saloka
  ///
  /// In id, this message translates to:
  /// **'Paribasan, bebasan, lan saloka warisan Jawa'**
  String get learnModuleProverbsSubtitle;

  /// Label progres modul peribahasa
  ///
  /// In id, this message translates to:
  /// **'15 peribahasa'**
  String get learnModuleProverbsLabel;

  /// Tag kategori modul aksara
  ///
  /// In id, this message translates to:
  /// **'Aksara'**
  String get learnTagAksara;

  /// Tag kategori modul kamus
  ///
  /// In id, this message translates to:
  /// **'Kosa Kata'**
  String get learnTagKamus;

  /// Tag kategori modul utilitas
  ///
  /// In id, this message translates to:
  /// **'Utilitas'**
  String get learnTagUtilitas;

  /// Tag kategori modul wicara
  ///
  /// In id, this message translates to:
  /// **'Wicara'**
  String get learnTagWicara;

  /// Tag kategori modul sastra
  ///
  /// In id, this message translates to:
  /// **'Sastra'**
  String get learnTagSastra;

  /// Label tingkat kesulitan mudah
  ///
  /// In id, this message translates to:
  /// **'Mudah'**
  String get difficultyMudah;

  /// Label tingkat kesulitan mahir
  ///
  /// In id, this message translates to:
  /// **'Mahir'**
  String get difficultyMahir;

  /// Label tingkat kesulitan sangat mahir
  ///
  /// In id, this message translates to:
  /// **'Sangat Mahir'**
  String get difficultySangatMahir;

  /// Judul layar jalur peta kuis
  ///
  /// In id, this message translates to:
  /// **'Jalur Kuis'**
  String get quizPathTitle;

  /// Lencana jumlah kuis selesai di AppBar
  ///
  /// In id, this message translates to:
  /// **'{count} Selesai'**
  String quizCompletedBadge(int count);

  /// Judul Unit 1 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Unit 1: Sapaan dan Salam'**
  String get quizUnit1Title;

  /// Subjudul Unit 1 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Dasar percakapan dan tata krama sopan santun'**
  String get quizUnit1Subtitle;

  /// Judul Unit 2 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Unit 2: Keluarga dan Rumah (Terkunci)'**
  String get quizUnit2Title;

  /// Subjudul Unit 2 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Silsilah keluarga, kerabat, dan lingkungan rumah'**
  String get quizUnit2Subtitle;

  /// Topik kuis Salam
  ///
  /// In id, this message translates to:
  /// **'Salam'**
  String get quizTopicSalam;

  /// Topik kuis Pamit
  ///
  /// In id, this message translates to:
  /// **'Pamit'**
  String get quizTopicPamit;

  /// Topik kuis Lencana
  ///
  /// In id, this message translates to:
  /// **'Lencana'**
  String get quizTopicLencana;

  /// Topik kuis Tanya Kabar
  ///
  /// In id, this message translates to:
  /// **'Tanya kabar'**
  String get quizTopicTanyaKabar;

  /// Topik kuis Perkenalan
  ///
  /// In id, this message translates to:
  /// **'Perkenalan'**
  String get quizTopicPerkenalan;

  /// Topik kuis Keluarga
  ///
  /// In id, this message translates to:
  /// **'Keluarga'**
  String get quizTopicKeluarga;

  /// Topik kuis Rumah
  ///
  /// In id, this message translates to:
  /// **'Rumah'**
  String get quizTopicRumah;

  /// Topik kuis Kerabat
  ///
  /// In id, this message translates to:
  /// **'Kerabat'**
  String get quizTopicKerabat;

  /// Keterangan kuis di bottom sheet konfirmasi kuis
  ///
  /// In id, this message translates to:
  /// **'Kuis {quizIndex} dari {totalQuizzes} · {questionCount} soal'**
  String quizBottomSheetProgress(
    int quizIndex,
    int totalQuizzes,
    int questionCount,
  );

  /// Tombol mulai kuis pada bottom sheet
  ///
  /// In id, this message translates to:
  /// **'Mulai Kuis'**
  String get quizBottomSheetStart;

  /// Tombol tunda kuis pada bottom sheet
  ///
  /// In id, this message translates to:
  /// **'Nanti saja'**
  String get quizBottomSheetLater;

  /// Penanda kombo jawaban benar berurutan
  ///
  /// In id, this message translates to:
  /// **'{count} Benar!'**
  String quizComboCount(int count);

  /// Label semantik opsi soal kuis
  ///
  /// In id, this message translates to:
  /// **'Pilihan {letter}: {option}'**
  String quizOptionSemantics(String letter, String option);

  /// Umpan balik jawaban benar
  ///
  /// In id, this message translates to:
  /// **'Betul!'**
  String get quizCorrect;

  /// Umpan balik jawaban salah
  ///
  /// In id, this message translates to:
  /// **'Kurang tepat'**
  String get quizIncorrect;

  /// Kunci jawaban yang benar saat salah
  ///
  /// In id, this message translates to:
  /// **'Jawaban: {answer}'**
  String quizAnswerLabel(String answer);

  /// Tombol periksa jawaban kuis
  ///
  /// In id, this message translates to:
  /// **'Periksa'**
  String get quizCheck;

  /// Tombol lanjut ke soal kuis berikutnya
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get quizContinue;

  /// Tombol selesai pada soal kuis terakhir
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get quizFinish;

  /// Judul kemenangan pada layar hasil kuis
  ///
  /// In id, this message translates to:
  /// **'Luar Biasa!'**
  String get quizResultAwesome;

  /// Banner streak aktif di layar hasil kuis
  ///
  /// In id, this message translates to:
  /// **'Streak kuis aktif: {days} hari'**
  String quizResultStreakBanner(int days);

  /// Label statistik jumlah soal benar
  ///
  /// In id, this message translates to:
  /// **'Soal Benar'**
  String get quizResultCorrectAnswers;

  /// Label durasi pengerjaan kuis
  ///
  /// In id, this message translates to:
  /// **'Waktu'**
  String get quizResultTime;

  /// Label persentase akurasi kuis
  ///
  /// In id, this message translates to:
  /// **'Akurasi'**
  String get quizResultAccuracy;

  /// Tombol kembali ke Beranda dari hasil kuis
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Beranda'**
  String get quizResultBackHome;

  /// Tombol ulangi kuis di layar hasil kuis
  ///
  /// In id, this message translates to:
  /// **'Ulangi kuis'**
  String get quizResultRetry;

  /// Judul layar latihan menulis aksara
  ///
  /// In id, this message translates to:
  /// **'Latihan Menulis'**
  String get drawingTitle;

  /// Label semantik tombol kembali layar gambar
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get drawingBackSemantics;

  /// Instruksi latihan menulis aksara
  ///
  /// In id, this message translates to:
  /// **'Tulis aksara ini!'**
  String get drawingInstruction;

  /// Penghitung jumlah goresan di kanvas
  ///
  /// In id, this message translates to:
  /// **'Goresan: {count}'**
  String drawingStrokeCount(int count);

  /// Tombol bersihkan kanvas gambar
  ///
  /// In id, this message translates to:
  /// **'Hapus Semua'**
  String get drawingClearAll;

  /// Tombol batalkan goresan terakhir
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get drawingUndo;

  /// Tombol periksa tulisan aksara pada kanvas
  ///
  /// In id, this message translates to:
  /// **'Periksa Tulisan'**
  String get drawingCheckButton;

  /// Judul layar hasil quest harian
  ///
  /// In id, this message translates to:
  /// **'Hasil Quest'**
  String get dailyResultTitle;

  /// Label meter kemiripan tulisan
  ///
  /// In id, this message translates to:
  /// **'Kemiripan'**
  String get dailyResultSimilarityLabel;

  /// Ucapan selamat lulus quest harian
  ///
  /// In id, this message translates to:
  /// **'Hebat, {name}!'**
  String dailyResultCelebrationPassed(String name);

  /// Ucapan penyemangat saat quest belum lulus
  ///
  /// In id, this message translates to:
  /// **'Ayo Latihan Lagi!'**
  String get dailyResultCelebrationFailed;

  /// Keterangan lulus quest aksara
  ///
  /// In id, this message translates to:
  /// **'Kamu berhasil menulis aksara Jawa dengan kemiripan di atas 85%.'**
  String get dailyResultDescPassed;

  /// Keterangan saat presisi belum mencapai target
  ///
  /// In id, this message translates to:
  /// **'Goresanmu hampir tepat. Coba perhatikan proporsi aksara target.'**
  String get dailyResultDescFailed;

  /// Judul kartu komparasi tulisan
  ///
  /// In id, this message translates to:
  /// **'Perbandingan Tulisan'**
  String get dailyResultComparison;

  /// Label panel hasil goresan pengguna
  ///
  /// In id, this message translates to:
  /// **'Tulisanmu'**
  String get dailyResultYourDrawing;

  /// Label panel aksara target acuan
  ///
  /// In id, this message translates to:
  /// **'Aksara Target'**
  String get dailyResultTargetScript;

  /// Status kelulusan quest tercapai
  ///
  /// In id, this message translates to:
  /// **'Status: Lulus'**
  String get dailyResultStatusPassed;

  /// Status kelulusan quest belum tercapai
  ///
  /// In id, this message translates to:
  /// **'Status: Belum Lulus'**
  String get dailyResultStatusFailed;

  /// Keterangan skor kemiripan dan ambang kelulusan
  ///
  /// In id, this message translates to:
  /// **'Kemiripan {percent}% (Syarat lulus: ≥ 85%)'**
  String dailyResultRequirement(int percent);

  /// Tombol lanjut belajar dari hasil quest
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Belajar →'**
  String get dailyResultContinueLearning;

  /// Tombol coba lagi pada hasil quest
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get dailyResultTryAgain;

  /// Judul layar Profil pengguna
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// Label semantik ikon tombol pengaturan di Profil
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get profileSettingsSemantics;

  /// Pesan validasi nama pengguna kosong di Profil
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong'**
  String get profileNameEmptyError;

  /// Toast pemberitahuan nama berhasil disimpan
  ///
  /// In id, this message translates to:
  /// **'Nama berhasil disimpan: {name}'**
  String profileNameSaved(String name);

  /// Tombol simpan pengubahan nama profil
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get profileSaveName;

  /// Tombol batal edit nama profil
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get profileCancelEdit;

  /// Pill penunjuk level pengguna
  ///
  /// In id, this message translates to:
  /// **'Lv {level}'**
  String profileLevelPill(int level);

  /// Pill penunjuk hari streak di Profil
  ///
  /// In id, this message translates to:
  /// **'Streak {days} hari'**
  String profileStreakPill(int days);

  /// Pill jumlah kuis minggu ini di Profil
  ///
  /// In id, this message translates to:
  /// **'{count} Kuis Minggu Ini'**
  String profileQuizzesThisWeek(int count);

  /// Judul bagian koleksi lencana di Profil
  ///
  /// In id, this message translates to:
  /// **'Lencana'**
  String get profileBadgeTitle;

  /// Indikator jumlah lencana terbuka
  ///
  /// In id, this message translates to:
  /// **'1 / 4 Terbuka'**
  String get profileBadgeOpenCount;

  /// Subjudul bagian lencana profil
  ///
  /// In id, this message translates to:
  /// **'Koleksi Prestasi'**
  String get profileBadgeCollection;

  /// Judul lencana streak 7 hari
  ///
  /// In id, this message translates to:
  /// **'Streak 7 Hari'**
  String get profileBadgeStreak7Title;

  /// Judul lencana streak 30 hari
  ///
  /// In id, this message translates to:
  /// **'Streak 30 Hari'**
  String get profileBadgeStreak30Title;

  /// Judul lencana level 5
  ///
  /// In id, this message translates to:
  /// **'Level 5'**
  String get profileBadgeLevel5Title;

  /// Sorotan aksi naik level di lencana
  ///
  /// In id, this message translates to:
  /// **'Naik Level'**
  String get profileBadgeLevelUpHighlight;

  /// Judul lencana tamat aksara
  ///
  /// In id, this message translates to:
  /// **'Tamat Aksara'**
  String get profileBadgeAksaraCompleteTitle;

  /// Keterangan tingkat mudah di lencana
  ///
  /// In id, this message translates to:
  /// **'Tingkat Mudah'**
  String get profileBadgeEasyLevel;

  /// Status lencana terbuka
  ///
  /// In id, this message translates to:
  /// **'Terbuka'**
  String get profileBadgeUnlocked;

  /// Status lencana terkunci
  ///
  /// In id, this message translates to:
  /// **'Terkunci'**
  String get profileBadgeLocked;

  /// Tombol utama pilih kustomisasi blangkon
  ///
  /// In id, this message translates to:
  /// **'Pilih Blangkon'**
  String get profileChooseBlangkonButton;

  /// Judul layar katalog blangkon
  ///
  /// In id, this message translates to:
  /// **'Pilih Blangkon'**
  String get blangkonTitle;

  /// Tombol simpan pilihan blangkon
  ///
  /// In id, this message translates to:
  /// **'Simpan Pilihan'**
  String get blangkonSaveButton;

  /// Syarat level untuk membuka blangkon
  ///
  /// In id, this message translates to:
  /// **'Level {level}'**
  String blangkonLevelRequired(int level);

  /// Keterangan blangkon terpasang secara bawaan
  ///
  /// In id, this message translates to:
  /// **'Terpasang awal'**
  String get blangkonInitialUnlock;

  /// Syarat membuka blangkon pusaka
  ///
  /// In id, this message translates to:
  /// **'Selesai aksara'**
  String get blangkonMasteryAksara;

  /// Deskripsi ciri khas blangkon gaya Yogyakarta
  ///
  /// In id, this message translates to:
  /// **'Klasik, mondolan bulat menonjol'**
  String get blangkonDescYogyakarta;

  /// Deskripsi ciri khas blangkon gaya Surakarta
  ///
  /// In id, this message translates to:
  /// **'Anggun, mondolan trepes pipih'**
  String get blangkonDescSurakarta;

  /// Deskripsi ciri khas blangkon gaya Banyumas
  ///
  /// In id, this message translates to:
  /// **'Tegas, corak khas Banyumasan'**
  String get blangkonDescBanyumas;

  /// Deskripsi ciri khas blangkon gaya Kedu
  ///
  /// In id, this message translates to:
  /// **'Gaya Bagelen Kedu bersahaja'**
  String get blangkonDescKedu;

  /// Deskripsi ciri khas blangkon gaya Cirebon
  ///
  /// In id, this message translates to:
  /// **'Pesisiran dinamis berwibawa'**
  String get blangkonDescCirebon;

  /// Deskripsi ciri khas blangkon gaya Pusaka
  ///
  /// In id, this message translates to:
  /// **'Mahakarya tradisi berornamen emas'**
  String get blangkonDescPusaka;

  /// Mikro tag perayaan naik level
  ///
  /// In id, this message translates to:
  /// **'PENCAPAIAN JAWALOKA'**
  String get levelUpMicroTag;

  /// Judul perayaan naik level baru
  ///
  /// In id, this message translates to:
  /// **'Level {level}!'**
  String levelUpTitle(int level);

  /// Pengantar nama blangkon baru terbuka
  ///
  /// In id, this message translates to:
  /// **'Blangkon baru terbuka: '**
  String get levelUpBlangkonUnlocked;

  /// Kategori kartu lencana baru yang didapat
  ///
  /// In id, this message translates to:
  /// **'LENCANA BARU'**
  String get levelUpBadgeCategory;

  /// Nama lencana baru diraih
  ///
  /// In id, this message translates to:
  /// **'Sinau Mandiri V'**
  String get levelUpAchievementTitle;

  /// Deskripsi syarat pencapaian lencana baru
  ///
  /// In id, this message translates to:
  /// **'Menyelesaikan 25 bab materi aksara'**
  String get levelUpAchievementDesc;

  /// Tombol langsung memakai blangkon baru terbuka
  ///
  /// In id, this message translates to:
  /// **'Pakai Blangkon'**
  String get levelUpEquipButton;

  /// Tombol lewati pemakaian blangkon saat ini
  ///
  /// In id, this message translates to:
  /// **'Nanti saja'**
  String get levelUpSkipButton;

  /// Label aksi keluar akun di Pengaturan
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get settingsLogout;

  /// Pertanyaan konfirmasi keluar akun
  ///
  /// In id, this message translates to:
  /// **'Yakin ingin keluar?'**
  String get settingsLogoutConfirm;

  /// Tombol batal di dialog Pengaturan
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get settingsCancel;

  /// Judul baris kebijakan privasi di Pengaturan
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get settingsPrivacyPolicy;

  /// Teks isi dialog kebijakan privasi
  ///
  /// In id, this message translates to:
  /// **'JawaLoka menghormati privasi Anda. Seluruh progres belajar, latihan aksara, dan preferensi pengguna disimpan secara lokal di perangkat Anda.'**
  String get settingsPrivacyPolicyContent;

  /// Tombol tutup dialog
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get settingsClose;

  /// Label baris pengaturan akun
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get settingsAccountRow;

  /// Judul dialog detail akun
  ///
  /// In id, this message translates to:
  /// **'Detail Akun'**
  String get settingsAccountDialogTitle;

  /// Label nama pengguna di dialog akun
  ///
  /// In id, this message translates to:
  /// **'Nama Pengguna'**
  String get settingsAccountNameLabel;

  /// Label email di dialog akun
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get settingsAccountEmailLabel;

  /// Judul layar penerjemah
  ///
  /// In id, this message translates to:
  /// **'Penerjemah'**
  String get translatorTitle;

  /// Label kotak teks input penerjemah
  ///
  /// In id, this message translates to:
  /// **'MASUKKAN TEKS'**
  String get translatorInputLabel;

  /// Hint kotak input teks penerjemah
  ///
  /// In id, this message translates to:
  /// **'Ketik teks...'**
  String get translatorInputHint;

  /// Tombol jalankan penerjemahan teks
  ///
  /// In id, this message translates to:
  /// **'Terjemahkan'**
  String get translatorButton;

  /// Status saat proses penerjemahan berlangsung
  ///
  /// In id, this message translates to:
  /// **'Menerjemahkan...'**
  String get translatorTranslating;

  /// Label kotak hasil terjemahan
  ///
  /// In id, this message translates to:
  /// **'HASIL TERJEMAHAN'**
  String get translatorOutputLabel;

  /// Placeholder sebelum ada hasil terjemahan
  ///
  /// In id, this message translates to:
  /// **'Hasil terjemahan akan muncul di sini…'**
  String get translatorOutputPlaceholder;

  /// Pemberitahuan teks hasil berhasil disalin
  ///
  /// In id, this message translates to:
  /// **'Teks disalin'**
  String get translatorCopiedToast;

  /// Judul bottom sheet pemilihan bahasa terjemahan
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get translatorPickerTitle;

  /// Label semantik tombol tukar bahasa terjemahan
  ///
  /// In id, this message translates to:
  /// **'Tukar bahasa'**
  String get translatorSwapSemantics;

  /// Tooltip tombol salin hasil terjemahan
  ///
  /// In id, this message translates to:
  /// **'Salin'**
  String get translatorCopyTooltip;

  /// Tooltip tombol hapus input terjemahan
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get translatorClearTooltip;

  /// Pesan saat teks belum ada di kamus contoh penerjemah
  ///
  /// In id, this message translates to:
  /// **'Belum tersedia pada versi contoh'**
  String get translatorMockUnavailable;

  /// Judul layar detail aksara
  ///
  /// In id, this message translates to:
  /// **'Aksara Jawa'**
  String get aksaraDetailTitle;

  /// Tag kategori dasar aksara
  ///
  /// In id, this message translates to:
  /// **'Dasar'**
  String get aksaraDetailTag;

  /// Judul bagian contoh kata aksara
  ///
  /// In id, this message translates to:
  /// **'Contoh Kata'**
  String get aksaraDetailExampleHeader;

  /// Judul bagian sandhangan aksara
  ///
  /// In id, this message translates to:
  /// **'Sandangan'**
  String get aksaraDetailSandanganHeader;

  /// Keterangan variasi vokal sandhangan aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Variasi vokal pada aksara ꦲ (Ha)'**
  String get aksaraDetailSandanganSubtitle;

  /// Judul bagian tata cara menulis aksara
  ///
  /// In id, this message translates to:
  /// **'Cara Menulis'**
  String get aksaraDetailWritingHeader;

  /// Langkah 1 menulis aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Mulai dari kanan atas'**
  String get aksaraDetailStep1Title;

  /// Deskripsi langkah 1 menulis aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Tarik garis lengkung ke bawah dari titik awal di kanan atas.'**
  String get aksaraDetailStep1Desc;

  /// Langkah 2 menulis aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Lengkung badan aksara'**
  String get aksaraDetailStep2Title;

  /// Deskripsi langkah 2 menulis aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Buat lengkungan utama yang membentuk tubuh aksara Ha ke kiri.'**
  String get aksaraDetailStep2Desc;

  /// Langkah 3 menulis aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Tutup dengan ekor'**
  String get aksaraDetailStep3Title;

  /// Deskripsi langkah 3 menulis aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Akhiri dengan garis ekor pendek yang melengkung ke dalam.'**
  String get aksaraDetailStep3Desc;

  /// Tombol aksi latihan menulis pada detail aksara
  ///
  /// In id, this message translates to:
  /// **'Latihan Menulis'**
  String get aksaraDetailWritingButton;

  /// Tombol aksi mulai kuis pada detail aksara
  ///
  /// In id, this message translates to:
  /// **'Mulai Kuis'**
  String get aksaraDetailQuizButton;

  /// Judul layar detail kosa kata
  ///
  /// In id, this message translates to:
  /// **'Kosa Kata'**
  String get vocabDetailTitle;

  /// Tag tingkat kesulitan kosa kata
  ///
  /// In id, this message translates to:
  /// **'Mudah'**
  String get vocabDetailTag;

  /// Judul bagian makna dan tingkatan kosa kata
  ///
  /// In id, this message translates to:
  /// **'Makna & Tingkatan'**
  String get vocabDetailMeaningHeader;

  /// Judul bagian contoh kalimat kosa kata
  ///
  /// In id, this message translates to:
  /// **'Contoh Kalimat'**
  String get vocabDetailExamplesHeader;

  /// Tombol lanjut ke kosa kata berikutnya
  ///
  /// In id, this message translates to:
  /// **'Kata Berikutnya'**
  String get vocabDetailNextButton;

  /// Toast pemberitahuan lencana streak 7 hari terbuka
  ///
  /// In id, this message translates to:
  /// **'Lencana Streak 7 Hari telah terbuka!'**
  String get profileBadgeStreak7Toast;

  /// Toast pemberitahuan syarat lencana streak 30 hari
  ///
  /// In id, this message translates to:
  /// **'Pertahankan streak 30 hari untuk membuka lencana ini!'**
  String get profileBadgeStreak30Toast;

  /// Toast pemberitahuan blangkon berhasil dipasang
  ///
  /// In id, this message translates to:
  /// **'Blangkon Surakarta berhasil dipasang!'**
  String get profileBadgeLevel5Toast;

  /// Toast pemberitahuan syarat lencana aksara
  ///
  /// In id, this message translates to:
  /// **'Selesaikan seluruh modul aksara dasar untuk membuka!'**
  String get profileBadgeAksaraToast;

  /// Toast syarat blangkon terbuka sejak awal
  ///
  /// In id, this message translates to:
  /// **'Terbuka sejak awal: {name}'**
  String blangkonToastInitial(String name);

  /// Toast syarat level untuk membuka blangkon
  ///
  /// In id, this message translates to:
  /// **'Butuh Level {level} untuk membuka {name}'**
  String blangkonToastLevel(int level, String name);

  /// Toast syarat aksara untuk membuka blangkon
  ///
  /// In id, this message translates to:
  /// **'Selesaikan seluruh materi aksara untuk membuka {name}'**
  String blangkonToastAksara(String name);

  /// Tombol aksi tandai favorit kosa kata
  ///
  /// In id, this message translates to:
  /// **'Tandai Favorit'**
  String get vocabDetailFavoriteMark;

  /// Status kosa kata sudah ditandai favorit
  ///
  /// In id, this message translates to:
  /// **'Ditandai Favorit'**
  String get vocabDetailFavoriteMarked;

  /// Label node tonggak pada peta kuis
  ///
  /// In id, this message translates to:
  /// **'Node Tonggak'**
  String get quizMilestoneNode;

  /// Pesan toast saat node kuis terkunci diketuk
  ///
  /// In id, this message translates to:
  /// **'Materi {topic} masih terkunci. Selesaikan materi sebelumnya!'**
  String quizNodeLockedToast(String topic);

  /// Format judul unit kuis
  ///
  /// In id, this message translates to:
  /// **'Unit {unit} · Tingkat {level}'**
  String quizUnitTitle(int unit, String level);

  /// Deskripsi topik kuis Salam
  ///
  /// In id, this message translates to:
  /// **'Pelajari salam dan tegur sapa sopan santun bahasa Jawa.'**
  String get quizTopicSalamDesc;

  /// Deskripsi topik kuis Pamit
  ///
  /// In id, this message translates to:
  /// **'Ungkapan pamitan dan perpisahan sehari-hari yang santun.'**
  String get quizTopicPamitDesc;

  /// Deskripsi topik kuis Lencana
  ///
  /// In id, this message translates to:
  /// **'Uji pemahaman tonggak materi sapaan dan salam.'**
  String get quizTopicLencanaDesc;

  /// Deskripsi topik kuis Tanya Kabar
  ///
  /// In id, this message translates to:
  /// **'Menanyakan keadaan dan kabar orang lain dalam bahasa Jawa.'**
  String get quizTopicTanyaKabarDesc;

  /// Deskripsi topik kuis Perkenalan
  ///
  /// In id, this message translates to:
  /// **'Mengenalkan diri dengan unggah-ungguh yang tepat.'**
  String get quizTopicPerkenalanDesc;

  /// Deskripsi topik kuis Keluarga
  ///
  /// In id, this message translates to:
  /// **'Sebutan anggota keluarga dan kerabat terdekat.'**
  String get quizTopicKeluargaDesc;

  /// Deskripsi topik kuis Rumah
  ///
  /// In id, this message translates to:
  /// **'Bagian-bagian rumah tradisional dan perlengkapan.'**
  String get quizTopicRumahDesc;

  /// Deskripsi topik kuis Kerabat
  ///
  /// In id, this message translates to:
  /// **'Tingkatan silsilah keluarga besar masyarakat Jawa.'**
  String get quizTopicKerabatDesc;

  /// Pertanyaan kuis mengidentifikasi aksara
  ///
  /// In id, this message translates to:
  /// **'Aksara apa ini?'**
  String get quizQuestionPromptWhatGlyph;

  /// Pertanyaan kuis memilih pelafalan aksara
  ///
  /// In id, this message translates to:
  /// **'Pilih pelafalan untuk aksara berikut:'**
  String get quizQuestionPromptPronunciation;

  /// Pertanyaan kuis bagaimana cara membaca aksara
  ///
  /// In id, this message translates to:
  /// **'Aksara \"{glyph}\" dibaca sebagai apa?'**
  String quizQuestionPromptHowToRead(String glyph);

  /// Pertanyaan kuis pelafalan aksara di bawah
  ///
  /// In id, this message translates to:
  /// **'Manakah pelafalan untuk aksara di bawah?'**
  String get quizQuestionPromptWhichPronunciation;

  /// Tombol lewati pertanyaan kuis
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get quizSkip;

  /// Semantik tombol tutup kuis
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get quizCloseSemantics;

  /// Judul dialog keluar kuis
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Kuis?'**
  String get quizExitDialogTitle;

  /// Pesan peringatan dialog keluar kuis
  ///
  /// In id, this message translates to:
  /// **'Progres kuis saat ini tidak akan disimpan.'**
  String get quizExitDialogMessage;

  /// Tombol konfirmasi keluar kuis
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get quizExitDialogConfirm;

  /// Tombol batal keluar kuis
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get quizExitDialogCancel;

  /// Judul bottom sheet penggunaan bahasa dan unggah-ungguh
  ///
  /// In id, this message translates to:
  /// **'Penggunaan Bahasa'**
  String get learnUnggahSheetTitle;

  /// Subjudul bottom sheet penggunaan bahasa dan unggah-ungguh
  ///
  /// In id, this message translates to:
  /// **'Tingkatan ragam bahasa Jawa menurut tata krama dan unggah-ungguh.'**
  String get learnUnggahSheetSubtitle;

  /// Judul kartu tingkatan bahasa ngoko lugu
  ///
  /// In id, this message translates to:
  /// **'1. Basa Ngoko Lugu'**
  String get learnUnggahNgokoLuguTitle;

  /// Deskripsi penggunaan bahasa ngoko lugu
  ///
  /// In id, this message translates to:
  /// **'Digunakan untuk teman sebaya, saudara muda, atau orang yang sudah sangat akrab.'**
  String get learnUnggahNgokoLuguDesc;

  /// Judul kartu tingkatan bahasa ngoko alus
  ///
  /// In id, this message translates to:
  /// **'2. Basa Ngoko Alus'**
  String get learnUnggahNgokoAlusTitle;

  /// Deskripsi penggunaan bahasa ngoko alus
  ///
  /// In id, this message translates to:
  /// **'Bahasa ngoko yang bercampur kata krama inggil untuk menghormati lawan bicara.'**
  String get learnUnggahNgokoAlusDesc;

  /// Judul kartu tingkatan bahasa krama lugu atau madya
  ///
  /// In id, this message translates to:
  /// **'3. Basa Krama Lugu / Madya'**
  String get learnUnggahKramaLuguTitle;

  /// Deskripsi penggunaan bahasa krama lugu
  ///
  /// In id, this message translates to:
  /// **'Bahasa krama sopan umum untuk orang yang belum begitu dikenal atau rekan kerja.'**
  String get learnUnggahKramaLuguDesc;

  /// Judul kartu tingkatan bahasa krama inggil atau alus
  ///
  /// In id, this message translates to:
  /// **'4. Basa Krama Inggil / Alus'**
  String get learnUnggahKramaInggilTitle;

  /// Deskripsi penggunaan bahasa krama inggil
  ///
  /// In id, this message translates to:
  /// **'Tingkatan paling luhur, digunakan kepada orang tua, guru, atau sesepuh.'**
  String get learnUnggahKramaInggilDesc;

  /// Awalan contoh kalimat pada unggah-ungguh
  ///
  /// In id, this message translates to:
  /// **'Contoh: \"{example}\"'**
  String learnUnggahExamplePrefix(String example);

  /// Judul bottom sheet peribahasa dan saloka Jawa
  ///
  /// In id, this message translates to:
  /// **'Peribahasa & Saloka Jawa'**
  String get learnPeribahasaSheetTitle;

  /// Subjudul bottom sheet peribahasa dan saloka Jawa
  ///
  /// In id, this message translates to:
  /// **'Pepatah dan ungkapan luhur warisan leluhur kebudayaan Jawa.'**
  String get learnPeribahasaSheetSubtitle;

  /// Arti peribahasa Ajining dhiri ana ing lathi
  ///
  /// In id, this message translates to:
  /// **'Kehormatan seseorang terletak pada tutur katanya, dan kehormatan tubuh terletak pada pakaiannya.'**
  String get learnProverb1Meaning;

  /// Arti peribahasa Urip iku urup
  ///
  /// In id, this message translates to:
  /// **'Hidup itu hendaknya memberi manfaat dan menerangi orang lain di sekitarnya.'**
  String get learnProverb2Meaning;

  /// Arti peribahasa Jer basuki mawa beya
  ///
  /// In id, this message translates to:
  /// **'Setiap cita-cita dan kesuksesan memerlukan usaha, pengorbanan, dan biaya.'**
  String get learnProverb3Meaning;

  /// Arti peribahasa Mikul dhuwur mendhem jero
  ///
  /// In id, this message translates to:
  /// **'Menjunjung tinggi kehormatan orang tua dan keluarga serta menutup aib atau keburukan.'**
  String get learnProverb4Meaning;

  /// Arti peribahasa Rukun agawe santosa, crah agawe bubrah
  ///
  /// In id, this message translates to:
  /// **'Kerukunan menciptakan ketenteraman dan kekuatan, perpecahan membawa kehancuran.'**
  String get learnProverb5Meaning;

  /// Arti kata harian Omah
  ///
  /// In id, this message translates to:
  /// **'Rumah'**
  String get learnDailyWordOmah;

  /// Arti kata harian Banyu
  ///
  /// In id, this message translates to:
  /// **'Air'**
  String get learnDailyWordBanyu;

  /// Arti kata harian Segara
  ///
  /// In id, this message translates to:
  /// **'Laut'**
  String get learnDailyWordSegara;

  /// Arti kata harian Lemah
  ///
  /// In id, this message translates to:
  /// **'Tanah'**
  String get learnDailyWordLemah;

  /// Arti kata harian Langit
  ///
  /// In id, this message translates to:
  /// **'Langit'**
  String get learnDailyWordLangit;

  /// Label bahasa Indonesia pada kartu makna
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get vocabDetailLangId;

  /// Label bahasa Inggris pada kartu makna
  ///
  /// In id, this message translates to:
  /// **'Bahasa Inggris'**
  String get vocabDetailLangEn;

  /// Label bahasa Jawa pada kartu makna
  ///
  /// In id, this message translates to:
  /// **'Bahasa Jawa (Ngoko)'**
  String get vocabDetailLangJv;

  /// Terjemahan contoh kalimat 1 detail kosakata
  ///
  /// In id, this message translates to:
  /// **'Rumahku ada di desa'**
  String get vocabDetailSentence1Translation;

  /// Terjemahan contoh kalimat 2 detail kosakata
  ///
  /// In id, this message translates to:
  /// **'Rumah ini sangat besar'**
  String get vocabDetailSentence2Translation;

  /// Arti contoh kata Hara pada aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Cabang'**
  String get aksaraDetailExampleHaraMeaning;

  /// Arti contoh kata Hawu pada aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Tungku'**
  String get aksaraDetailExampleHawuMeaning;

  /// Arti contoh kata Hastha pada aksara Ha
  ///
  /// In id, this message translates to:
  /// **'Delapan'**
  String get aksaraDetailExampleHasthaMeaning;
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
