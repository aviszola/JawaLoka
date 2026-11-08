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

  /// Label tombol tengah Misi/Quest
  ///
  /// In id, this message translates to:
  /// **'Misi'**
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
  /// **'Target: ≥{percent}% Presisi'**
  String homeHeroQuestTarget(int percent);

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
  /// **'Unit 1: Sapaan dan Unggah-Ungguh Awal'**
  String get quizUnit1Title;

  /// Subjudul Unit 1 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Dasar percakapan dan tata krama sopan santun'**
  String get quizUnit1Subtitle;

  /// Judul Unit 2 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Unit 2: Aksara Jawa Dasar (Legena) (Terkunci)'**
  String get quizUnit2Title;

  /// Subjudul Unit 2 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Pengenalan 20 aksara legena Hanacaraka'**
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

  /// Atribusi sumber tetap pada kartu penjelasan kuis
  ///
  /// In id, this message translates to:
  /// **'Materi JawaLoka (draf, belum diverifikasi penutur Jawa)'**
  String get quizQuestionSourceAttribution;

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

  /// Judul layar hasil misi harian
  ///
  /// In id, this message translates to:
  /// **'Hasil Misi'**
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
  /// **'Kamu berhasil menulis aksara Jawa dengan kemiripan di atas {percent}%.'**
  String dailyResultDescPassed(int percent);

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
  /// **'Kemiripan {percent}% (Syarat lulus: ≥ {threshold}%)'**
  String dailyResultRequirement(int percent, int threshold);

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

  /// Jumlah blangkon tambahan yang terbuka saat lompat level
  ///
  /// In id, this message translates to:
  /// **' (+{count} blangkon lainnya)'**
  String levelUpOtherRewardsCount(int count);

  /// Subjudul perayaan naik level tanpa hadiah blangkon
  ///
  /// In id, this message translates to:
  /// **'Selamat! Tingkat pemahaman dan kecakapanmu semakin bertambah.'**
  String get levelUpNoRewardSubtitle;

  /// Tombol lanjut pada perayaan naik level tanpa hadiah blangkon
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get levelUpContinueButton;

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
  /// **'Aplikasi JawaLoka menyimpan nama tampilan, pilihan bahasa, koleksi blangkon, progres kuis, XP, dan Level secara lokal di perangkat Anda. Aplikasi ini tidak mengirim data ke server, tidak memiliki akun sungguhan (versi demo), dan tidak menyimpan kata sandi.'**
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

  /// Keterangan jenis akun lokal perangkat di dialog akun
  ///
  /// In id, this message translates to:
  /// **'Akun lokal pada perangkat ini'**
  String get settingsAccountLocalNote;

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

  /// Petunjuk satu baris contoh frasa dasar yang didukung penerjemah
  ///
  /// In id, this message translates to:
  /// **'Contoh frasa dasar yang didukung: Halo, Apa kabar?, Matur nuwun, Sugeng enjing, Kula boten mangertos.'**
  String get translatorBasicPhrasesHint;

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

  /// Judul Unit 3 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Unit 3: Sandhangan dan Pasangan Aksara Jawa (Terkunci)'**
  String get quizUnit3Title;

  /// Subjudul Unit 3 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Vokalisasi, konsonan penutup, dan pasangan aksara'**
  String get quizUnit3Subtitle;

  /// Judul Unit 4 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Unit 4: Kosakata dan Tingkatan Bahasa (Terkunci)'**
  String get quizUnit4Title;

  /// Subjudul Unit 4 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Tingkatan ngoko, krama lugu, dan krama inggil'**
  String get quizUnit4Subtitle;

  /// Judul Unit 5 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Unit 5: Budaya, Paribasan, dan Kawruh Luhur (Terkunci)'**
  String get quizUnit5Title;

  /// Subjudul Unit 5 di peta kuis
  ///
  /// In id, this message translates to:
  /// **'Paribasan, filosofi, adat tradisi, dan kawruh luhur Jawa'**
  String get quizUnit5Subtitle;

  /// Topik kuis Menyapa Orang Lain
  ///
  /// In id, this message translates to:
  /// **'Menyapa Orang Lain'**
  String get quizTopicSapaWong;

  /// Deskripsi topik kuis Menyapa Orang Lain
  ///
  /// In id, this message translates to:
  /// **'Tata krama menegur dan menyapa orang yang ditemui.'**
  String get quizTopicSapaWongDesc;

  /// Topik kuis Terima Kasih
  ///
  /// In id, this message translates to:
  /// **'Terima Kasih'**
  String get quizTopicMaturNuwun;

  /// Deskripsi topik kuis Terima Kasih
  ///
  /// In id, this message translates to:
  /// **'Ungkapan rasa syukur dan terima kasih yang santun.'**
  String get quizTopicMaturNuwunDesc;

  /// Topik kuis Meminta Maaf
  ///
  /// In id, this message translates to:
  /// **'Meminta Maaf'**
  String get quizTopicNyuwunPangapunten;

  /// Deskripsi topik kuis Meminta Maaf
  ///
  /// In id, this message translates to:
  /// **'Ungkapan permohonan maaf dan mengakui kekeliruan.'**
  String get quizTopicNyuwunPangapuntenDesc;

  /// Topik kuis Percakapan Sehari-hari
  ///
  /// In id, this message translates to:
  /// **'Percakapan Sehari-hari'**
  String get quizTopicPercakapanPadinan;

  /// Deskripsi topik kuis Percakapan Sehari-hari
  ///
  /// In id, this message translates to:
  /// **'Latihan dialog sapaan sopan dalam kehidupan sehari-hari.'**
  String get quizTopicPercakapanPadinanDesc;

  /// Topik kuis Evaluasi Unit 1
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Unit 1'**
  String get quizTopicEvaluasiUnit1;

  /// Deskripsi topik kuis Evaluasi Unit 1
  ///
  /// In id, this message translates to:
  /// **'Uji komprehensif materi sapaan dan unggah-ungguh awal.'**
  String get quizTopicEvaluasiUnit1Desc;

  /// Topik kuis Pengenalan Hanacaraka
  ///
  /// In id, this message translates to:
  /// **'Pengenalan Hanacaraka'**
  String get quizTopicPengenalanHanacaraka;

  /// Deskripsi topik kuis Pengenalan Hanacaraka
  ///
  /// In id, this message translates to:
  /// **'Mengenal asal-usul dan filosofi 20 aksara carakan Jawa.'**
  String get quizTopicPengenalanHanacarakaDesc;

  /// Topik kuis Aksara Ha Na Ca Ra Ka
  ///
  /// In id, this message translates to:
  /// **'Aksara Ha Na Ca Ra Ka'**
  String get quizTopicAksaraHanacaraka;

  /// Deskripsi topik kuis Aksara Ha Na Ca Ra Ka
  ///
  /// In id, this message translates to:
  /// **'Bentuk dan pelafalan aksara Ha, Na, Ca, Ra, Ka.'**
  String get quizTopicAksaraHanacarakaDesc;

  /// Topik kuis Aksara Da Ta Sa Wa La
  ///
  /// In id, this message translates to:
  /// **'Aksara Da Ta Sa Wa La'**
  String get quizTopicAksaraDatasawala;

  /// Deskripsi topik kuis Aksara Da Ta Sa Wa La
  ///
  /// In id, this message translates to:
  /// **'Bentuk dan pelafalan aksara Da, Ta, Sa, Wa, La.'**
  String get quizTopicAksaraDatasawalaDesc;

  /// Topik kuis Aksara Pa Dha Ja Ya Nya
  ///
  /// In id, this message translates to:
  /// **'Aksara Pa Dha Ja Ya Nya'**
  String get quizTopicAksaraPadhajayanya;

  /// Deskripsi topik kuis Aksara Pa Dha Ja Ya Nya
  ///
  /// In id, this message translates to:
  /// **'Bentuk dan pelafalan aksara Pa, Dha, Ja, Ya, Nya.'**
  String get quizTopicAksaraPadhajayanyaDesc;

  /// Topik kuis Aksara Ma Ga Ba Tha Nga
  ///
  /// In id, this message translates to:
  /// **'Aksara Ma Ga Ba Tha Nga'**
  String get quizTopicAksaraMagabathanga;

  /// Deskripsi topik kuis Aksara Ma Ga Ba Tha Nga
  ///
  /// In id, this message translates to:
  /// **'Bentuk dan pelafalan aksara Ma, Ga, Ba, Tha, Nga.'**
  String get quizTopicAksaraMagabathangaDesc;

  /// Topik kuis Membaca Aksara Dasar
  ///
  /// In id, this message translates to:
  /// **'Membaca Aksara Dasar'**
  String get quizTopicMacaAksaraDhasar;

  /// Deskripsi topik kuis Membaca Aksara Dasar
  ///
  /// In id, this message translates to:
  /// **'Latihan membaca kombinasi suku kata terbuka aksara legena.'**
  String get quizTopicMacaAksaraDhasarDesc;

  /// Topik kuis Menyusun Aksara Legena
  ///
  /// In id, this message translates to:
  /// **'Menyusun Aksara Legena'**
  String get quizTopicNyusunAksaraLegena;

  /// Deskripsi topik kuis Menyusun Aksara Legena
  ///
  /// In id, this message translates to:
  /// **'Menyusun aksara Jawa legena menjadi kata yang bermakna.'**
  String get quizTopicNyusunAksaraLegenaDesc;

  /// Topik kuis Mengenali Bentuk Aksara
  ///
  /// In id, this message translates to:
  /// **'Mengenali Bentuk Aksara'**
  String get quizTopicNiteniWujudAksara;

  /// Deskripsi topik kuis Mengenali Bentuk Aksara
  ///
  /// In id, this message translates to:
  /// **'Membedakan bentuk aksara legena yang sekilas mirip.'**
  String get quizTopicNiteniWujudAksaraDesc;

  /// Topik kuis Latihan Membaca Kata Legena
  ///
  /// In id, this message translates to:
  /// **'Latihan Membaca Kata Legena'**
  String get quizTopicGladhenMacaLegena;

  /// Deskripsi topik kuis Latihan Membaca Kata Legena
  ///
  /// In id, this message translates to:
  /// **'Membaca kata dua dan tiga suku kata tanpa sandhangan.'**
  String get quizTopicGladhenMacaLegenaDesc;

  /// Topik kuis Evaluasi Unit 2
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Unit 2'**
  String get quizTopicEvaluasiUnit2;

  /// Deskripsi topik kuis Evaluasi Unit 2
  ///
  /// In id, this message translates to:
  /// **'Uji komprehensif penguasaan 20 aksara legena Hanacaraka.'**
  String get quizTopicEvaluasiUnit2Desc;

  /// Topik kuis Sandhangan Swara
  ///
  /// In id, this message translates to:
  /// **'Sandhangan Swara'**
  String get quizTopicSandhanganSwara;

  /// Deskripsi topik kuis Sandhangan Swara
  ///
  /// In id, this message translates to:
  /// **'Mengubah vokal aksara dengan wulu, suku, taling, dan pepet.'**
  String get quizTopicSandhanganSwaraDesc;

  /// Topik kuis Sandhangan Panyigeg Wanda
  ///
  /// In id, this message translates to:
  /// **'Sandhangan Panyigeg Wanda'**
  String get quizTopicSandhanganPanyigeg;

  /// Deskripsi topik kuis Sandhangan Panyigeg Wanda
  ///
  /// In id, this message translates to:
  /// **'Konsonan penutup wignyan, layar, cecak, dan pangkon.'**
  String get quizTopicSandhanganPanyigegDesc;

  /// Topik kuis Sandhangan Wyanjana
  ///
  /// In id, this message translates to:
  /// **'Sandhangan Wyanjana'**
  String get quizTopicSandhanganWyanjana;

  /// Deskripsi topik kuis Sandhangan Wyanjana
  ///
  /// In id, this message translates to:
  /// **'Sisipan semivokal cakra, keret, dan pengkal pada aksara.'**
  String get quizTopicSandhanganWyanjanaDesc;

  /// Topik kuis Pengenalan Pasangan
  ///
  /// In id, this message translates to:
  /// **'Pengenalan Pasangan'**
  String get quizTopicPengenalanPasangan;

  /// Deskripsi topik kuis Pengenalan Pasangan
  ///
  /// In id, this message translates to:
  /// **'Fungsi dan cara kerja pasangan dalam mematikan vokal.'**
  String get quizTopicPengenalanPasanganDesc;

  /// Topik kuis Pasangan Sejajar & Gantung
  ///
  /// In id, this message translates to:
  /// **'Pasangan Sejajar & Gantung'**
  String get quizTopicPasanganSejajarGantung;

  /// Deskripsi topik kuis Pasangan Sejajar & Gantung
  ///
  /// In id, this message translates to:
  /// **'Membedakan pasangan yang ditulis sejajar dan menggantung.'**
  String get quizTopicPasanganSejajarGantungDesc;

  /// Topik kuis Membaca Kata Bersandhangan
  ///
  /// In id, this message translates to:
  /// **'Membaca Kata Bersandhangan'**
  String get quizTopicMacaKataSandhangan;

  /// Deskripsi topik kuis Membaca Kata Bersandhangan
  ///
  /// In id, this message translates to:
  /// **'Membaca kosakata yang menggunakan aneka sandhangan swara.'**
  String get quizTopicMacaKataSandhanganDesc;

  /// Topik kuis Menulis Kata Sederhana
  ///
  /// In id, this message translates to:
  /// **'Menulis Kata Sederhana'**
  String get quizTopicNulisKataSederhana;

  /// Deskripsi topik kuis Menulis Kata Sederhana
  ///
  /// In id, this message translates to:
  /// **'Menyusun aksara bersandhangan menjadi kata yang benar.'**
  String get quizTopicNulisKataSederhanaDesc;

  /// Topik kuis Mengenali Kesalahan Tulis
  ///
  /// In id, this message translates to:
  /// **'Mengenali Kesalahan Tulis'**
  String get quizTopicNiteniLuputNulis;

  /// Deskripsi topik kuis Mengenali Kesalahan Tulis
  ///
  /// In id, this message translates to:
  /// **'Menemukan dan memperbaiki salah letak sandhangan & pasangan.'**
  String get quizTopicNiteniLuputNulisDesc;

  /// Topik kuis Latihan Kombinasi
  ///
  /// In id, this message translates to:
  /// **'Latihan Kombinasi'**
  String get quizTopicGladhenKombinasi;

  /// Deskripsi topik kuis Latihan Kombinasi
  ///
  /// In id, this message translates to:
  /// **'Latihan gabungan sandhangan swara, panyigeg, dan pasangan.'**
  String get quizTopicGladhenKombinasiDesc;

  /// Topik kuis Evaluasi Unit 3
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Unit 3'**
  String get quizTopicEvaluasiUnit3;

  /// Deskripsi topik kuis Evaluasi Unit 3
  ///
  /// In id, this message translates to:
  /// **'Uji komprehensif aturan sandhangan dan pasangan aksara Jawa.'**
  String get quizTopicEvaluasiUnit3Desc;

  /// Topik kuis Keluarga & Kerabat
  ///
  /// In id, this message translates to:
  /// **'Keluarga & Kerabat'**
  String get quizTopicKeluargaLanKerabat;

  /// Deskripsi topik kuis Keluarga & Kerabat
  ///
  /// In id, this message translates to:
  /// **'Sebutan silsilah keluarga dalam ragam ngoko dan krama.'**
  String get quizTopicKeluargaLanKerabatDesc;

  /// Topik kuis Rumah & Lingkungan
  ///
  /// In id, this message translates to:
  /// **'Rumah & Lingkungan'**
  String get quizTopicOmahLanSakiwatengene;

  /// Deskripsi topik kuis Rumah & Lingkungan
  ///
  /// In id, this message translates to:
  /// **'Nama perabot, ruangan rumah, dan lingkungan sekitar.'**
  String get quizTopicOmahLanSakiwatengeneDesc;

  /// Topik kuis Kegiatan Sehari-hari
  ///
  /// In id, this message translates to:
  /// **'Kegiatan Sehari-hari'**
  String get quizTopicKagiyatanPadinan;

  /// Deskripsi topik kuis Kegiatan Sehari-hari
  ///
  /// In id, this message translates to:
  /// **'Kata kerja dan aktivitas harian dalam tataran bahasa.'**
  String get quizTopicKagiyatanPadinanDesc;

  /// Topik kuis Ragam Ngoko Lugu
  ///
  /// In id, this message translates to:
  /// **'Ragam Ngoko Lugu'**
  String get quizTopicNgokoLugu;

  /// Deskripsi topik kuis Ragam Ngoko Lugu
  ///
  /// In id, this message translates to:
  /// **'Ciri dan penggunaan bahasa ngoko lugu antarteman akrab.'**
  String get quizTopicNgokoLuguDesc;

  /// Topik kuis Ragam Ngoko Alus
  ///
  /// In id, this message translates to:
  /// **'Ragam Ngoko Alus'**
  String get quizTopicNgokoAlus;

  /// Deskripsi topik kuis Ragam Ngoko Alus
  ///
  /// In id, this message translates to:
  /// **'Sisipan krama inggil dalam kalimat ngoko untuk menghormati.'**
  String get quizTopicNgokoAlusDesc;

  /// Topik kuis Ragam Krama Lugu
  ///
  /// In id, this message translates to:
  /// **'Ragam Krama Lugu'**
  String get quizTopicKramaLugu;

  /// Deskripsi topik kuis Ragam Krama Lugu
  ///
  /// In id, this message translates to:
  /// **'Bentuk sopan formal netral tanpa pengagungan berlebihan.'**
  String get quizTopicKramaLuguDesc;

  /// Topik kuis Ragam Krama Inggil
  ///
  /// In id, this message translates to:
  /// **'Ragam Krama Inggil'**
  String get quizTopicKramaInggil;

  /// Deskripsi topik kuis Ragam Krama Inggil
  ///
  /// In id, this message translates to:
  /// **'Tingkatan paling tinggi untuk menghormati sesepuh dan tokoh.'**
  String get quizTopicKramaInggilDesc;

  /// Topik kuis Perbandingan Tingkatan Bahasa
  ///
  /// In id, this message translates to:
  /// **'Perbandingan Tingkatan Bahasa'**
  String get quizTopicBandhinganTingkatBasa;

  /// Deskripsi topik kuis Perbandingan Tingkatan Bahasa
  ///
  /// In id, this message translates to:
  /// **'Membandingkan padanan satu kata dalam ngoko, krama, dan inggil.'**
  String get quizTopicBandhinganTingkatBasaDesc;

  /// Topik kuis Percakapan Unggah-Ungguh
  ///
  /// In id, this message translates to:
  /// **'Percakapan Unggah-Ungguh'**
  String get quizTopicWicaraUnggahUngguh;

  /// Deskripsi topik kuis Percakapan Unggah-Ungguh
  ///
  /// In id, this message translates to:
  /// **'Menerapkan unggah-ungguh basa dalam simulasi dialog nyata.'**
  String get quizTopicWicaraUnggahUngguhDesc;

  /// Topik kuis Evaluasi Unit 4
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Unit 4'**
  String get quizTopicEvaluasiUnit4;

  /// Deskripsi topik kuis Evaluasi Unit 4
  ///
  /// In id, this message translates to:
  /// **'Uji komprehensif kosakata dan penerapan tingkatan bahasa.'**
  String get quizTopicEvaluasiUnit4Desc;

  /// Topik kuis Ajining Dhiri
  ///
  /// In id, this message translates to:
  /// **'Ajining Dhiri'**
  String get quizTopicAjiningDhiri;

  /// Deskripsi topik kuis Ajining Dhiri
  ///
  /// In id, this message translates to:
  /// **'Filosofi menjaga kehormatan diri melalui tutur kata yang santun.'**
  String get quizTopicAjiningDhiriDesc;

  /// Topik kuis Unggah-Ungguh Basa Jawa
  ///
  /// In id, this message translates to:
  /// **'Unggah-Ungguh Basa Jawa'**
  String get quizTopicUnggahUngguhBasa;

  /// Deskripsi topik kuis Unggah-Ungguh Basa Jawa
  ///
  /// In id, this message translates to:
  /// **'Etika kesopanan tindak tanduk dan tata tutur orang Jawa.'**
  String get quizTopicUnggahUngguhBasaDesc;

  /// Topik kuis Peribahasa & Paribasan
  ///
  /// In id, this message translates to:
  /// **'Peribahasa & Paribasan'**
  String get quizTopicParibasanJawa;

  /// Deskripsi topik kuis Peribahasa & Paribasan
  ///
  /// In id, this message translates to:
  /// **'Makna mendalam ungkapan kiasan, paribasan, dan bebasan Jawa.'**
  String get quizTopicParibasanJawaDesc;

  /// Topik kuis Filosofi Urip Iku Urup
  ///
  /// In id, this message translates to:
  /// **'Filosofi Urip Iku Urup'**
  String get quizTopicFilosofiUrip;

  /// Deskripsi topik kuis Filosofi Urip Iku Urup
  ///
  /// In id, this message translates to:
  /// **'Makna hidup memberi manfaat bagi sesama dan alam semesta.'**
  String get quizTopicFilosofiUripDesc;

  /// Topik kuis Tradisi & Pranatan Jawa
  ///
  /// In id, this message translates to:
  /// **'Tradisi & Pranatan Jawa'**
  String get quizTopicTradisiPranatan;

  /// Deskripsi topik kuis Tradisi & Pranatan Jawa
  ///
  /// In id, this message translates to:
  /// **'Upacara adat, siklus kehidupan, dan tata krama tradisi Jawa.'**
  String get quizTopicTradisiPranatanDesc;

  /// Topik kuis Pewayangan Pandhawa
  ///
  /// In id, this message translates to:
  /// **'Pewayangan Pandhawa'**
  String get quizTopicPewayanganPandhawa;

  /// Deskripsi topik kuis Pewayangan Pandhawa
  ///
  /// In id, this message translates to:
  /// **'Karakter kebajikan tokoh wayang Pandhawa Lima dan nasihat hidup.'**
  String get quizTopicPewayanganPandhawaDesc;

  /// Topik kuis Tembang Dolanan & Piwulang
  ///
  /// In id, this message translates to:
  /// **'Tembang Dolanan & Piwulang'**
  String get quizTopicTembangDolanan;

  /// Deskripsi topik kuis Tembang Dolanan & Piwulang
  ///
  /// In id, this message translates to:
  /// **'Pesan moral dan budi pekerti dalam tembang dolanan anak Jawa.'**
  String get quizTopicTembangDolananDesc;

  /// Topik kuis Etika & Situasi Budaya
  ///
  /// In id, this message translates to:
  /// **'Etika & Situasi Budaya'**
  String get quizTopicEtikaBudaya;

  /// Deskripsi topik kuis Etika & Situasi Budaya
  ///
  /// In id, this message translates to:
  /// **'Memilih tindakan dan tutur kata yang tepat di lingkungan budaya.'**
  String get quizTopicEtikaBudayaDesc;

  /// Topik kuis Tantangan Kawruh Luhur
  ///
  /// In id, this message translates to:
  /// **'Tantangan Kawruh Luhur'**
  String get quizTopicKawruhLuhur;

  /// Deskripsi topik kuis Tantangan Kawruh Luhur
  ///
  /// In id, this message translates to:
  /// **'Ujian tingkat lanjut memadukan aksara, basa, dan budi pekerti.'**
  String get quizTopicKawruhLuhurDesc;

  /// Topik kuis Evaluasi Akhir JawaLoka
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Akhir JawaLoka'**
  String get quizTopicEvaluasiAkhir;

  /// Deskripsi topik kuis Evaluasi Akhir JawaLoka
  ///
  /// In id, this message translates to:
  /// **'Evaluasi akbar seluruh materi pembelajaran 50 node JawaLoka.'**
  String get quizTopicEvaluasiAkhirDesc;

  /// Topic title or description for quizTopicUngkapanSopan
  ///
  /// In id, this message translates to:
  /// **'Ungkapan Sopan'**
  String get quizTopicUngkapanSopan;

  /// Topic title or description for quizTopicUngkapanSopanDesc
  ///
  /// In id, this message translates to:
  /// **'Tata krama sikap badan, subasita, dan trapsila dalam adat Jawa.'**
  String get quizTopicUngkapanSopanDesc;

  /// Topic title or description for quizTopicPenggunaanPasangan
  ///
  /// In id, this message translates to:
  /// **'Penggunaan Pasangan'**
  String get quizTopicPenggunaanPasangan;

  /// Topic title or description for quizTopicPenggunaanPasanganDesc
  ///
  /// In id, this message translates to:
  /// **'Aturan dan latihan penulisan pasangan aksara dalam kata dan kalimat.'**
  String get quizTopicPenggunaanPasanganDesc;

  /// Topic title or description for quizTopicKosakataPadinan
  ///
  /// In id, this message translates to:
  /// **'Kosakata Sehari-hari'**
  String get quizTopicKosakataPadinan;

  /// Topic title or description for quizTopicKosakataPadinanDesc
  ///
  /// In id, this message translates to:
  /// **'Kosakata dasar sehari-hari dan hubungan kekeluargaan Jawa.'**
  String get quizTopicKosakataPadinanDesc;

  /// Topic title or description for quizTopicNamaBenda
  ///
  /// In id, this message translates to:
  /// **'Nama Benda'**
  String get quizTopicNamaBenda;

  /// Topic title or description for quizTopicNamaBendaDesc
  ///
  /// In id, this message translates to:
  /// **'Nama benda rumah tangga, bagian rumah Joglo, dan lingkungan sekitar.'**
  String get quizTopicNamaBendaDesc;

  /// Topic title or description for quizTopicNamaKegiatan
  ///
  /// In id, this message translates to:
  /// **'Nama Kegiatan'**
  String get quizTopicNamaKegiatan;

  /// Topic title or description for quizTopicNamaKegiatanDesc
  ///
  /// In id, this message translates to:
  /// **'Kata kerja dan aktivitas sehari-hari dalam bahasa Jawa.'**
  String get quizTopicNamaKegiatanDesc;

  /// Topic title or description for quizTopicNgoko
  ///
  /// In id, this message translates to:
  /// **'Ngoko'**
  String get quizTopicNgoko;

  /// Topic title or description for quizTopicNgokoDesc
  ///
  /// In id, this message translates to:
  /// **'Penggunaan dan kosakata ragam Ngoko untuk teman sebaya dan akrab.'**
  String get quizTopicNgokoDesc;

  /// Topic title or description for quizTopicKrama
  ///
  /// In id, this message translates to:
  /// **'Krama'**
  String get quizTopicKrama;

  /// Topic title or description for quizTopicKramaDesc
  ///
  /// In id, this message translates to:
  /// **'Ragam bahasa Krama halus untuk situasi sopan dan formal.'**
  String get quizTopicKramaDesc;

  /// Topic title or description for quizTopicPerbedaanTingkatanBahasa
  ///
  /// In id, this message translates to:
  /// **'Perbedaan Tingkatan Bahasa'**
  String get quizTopicPerbedaanTingkatanBahasa;

  /// Topic title or description for quizTopicPerbedaanTingkatanBahasaDesc
  ///
  /// In id, this message translates to:
  /// **'Perbandingan padanan kata dalam ragam Ngoko, Krama, dan Krama Inggil.'**
  String get quizTopicPerbedaanTingkatanBahasaDesc;

  /// Topic title or description for quizTopicPercakapanTeman
  ///
  /// In id, this message translates to:
  /// **'Percakapan dengan Teman'**
  String get quizTopicPercakapanTeman;

  /// Topic title or description for quizTopicPercakapanTemanDesc
  ///
  /// In id, this message translates to:
  /// **'Latihan percakapan akrab dengan teman menggunakan bahasa Ngoko yang tepat.'**
  String get quizTopicPercakapanTemanDesc;

  /// Topic title or description for quizTopicPercakapanDihormati
  ///
  /// In id, this message translates to:
  /// **'Percakapan dengan Orang yang Dihormati'**
  String get quizTopicPercakapanDihormati;

  /// Topic title or description for quizTopicPercakapanDihormatiDesc
  ///
  /// In id, this message translates to:
  /// **'Percakapan santun dengan orang tua, guru, dan sesepuh menggunakan Krama Inggil.'**
  String get quizTopicPercakapanDihormatiDesc;

  /// Topic title or description for quizTopicTataKramaJawa
  ///
  /// In id, this message translates to:
  /// **'Tata Krama Jawa'**
  String get quizTopicTataKramaJawa;

  /// Topic title or description for quizTopicTataKramaJawaDesc
  ///
  /// In id, this message translates to:
  /// **'Prinsip kesopanan, ajining dhiri, dan etika tutur dalam budaya Jawa.'**
  String get quizTopicTataKramaJawaDesc;

  /// Topic title or description for quizTopicPeribahasaJawa
  ///
  /// In id, this message translates to:
  /// **'Peribahasa Jawa'**
  String get quizTopicPeribahasaJawa;

  /// Topic title or description for quizTopicPeribahasaJawaDesc
  ///
  /// In id, this message translates to:
  /// **'Nasihat hidup dan kearifan lokal dalam paribasan, bebasan, dan saloka Jawa.'**
  String get quizTopicPeribahasaJawaDesc;

  /// Topic title or description for quizTopicFilosofiKehidupan
  ///
  /// In id, this message translates to:
  /// **'Filosofi Kehidupan Jawa'**
  String get quizTopicFilosofiKehidupan;

  /// Topic title or description for quizTopicFilosofiKehidupanDesc
  ///
  /// In id, this message translates to:
  /// **'Ajaran filosofis mendalam: Urip Iku Urup dan Memayu Hayuning Bawana.'**
  String get quizTopicFilosofiKehidupanDesc;

  /// Topic title or description for quizTopicTradisiJawa
  ///
  /// In id, this message translates to:
  /// **'Tradisi Jawa'**
  String get quizTopicTradisiJawa;

  /// Topic title or description for quizTopicTradisiJawaDesc
  ///
  /// In id, this message translates to:
  /// **'Upacara adat, siklus hidup, dan tradisi warisan leluhur Jawa.'**
  String get quizTopicTradisiJawaDesc;

  /// Topic title or description for quizTopicBudayaKesenian
  ///
  /// In id, this message translates to:
  /// **'Budaya dan Kesenian'**
  String get quizTopicBudayaKesenian;

  /// Topic title or description for quizTopicBudayaKesenianDesc
  ///
  /// In id, this message translates to:
  /// **'Kesenian wayang purwa, gamelan, dan ekspresi budaya tradisi Jawa.'**
  String get quizTopicBudayaKesenianDesc;

  /// Topic title or description for quizTopicSituasiPadinan
  ///
  /// In id, this message translates to:
  /// **'Situasi Kehidupan Sehari-hari'**
  String get quizTopicSituasiPadinan;

  /// Topic title or description for quizTopicSituasiPadinanDesc
  ///
  /// In id, this message translates to:
  /// **'Penerapan kearifan tembang dolanan dan nilai sosial dalam kehidupan nyata.'**
  String get quizTopicSituasiPadinanDesc;

  /// Topic title or description for quizTopicTantanganBudaya
  ///
  /// In id, this message translates to:
  /// **'Tantangan Pemahaman Budaya'**
  String get quizTopicTantanganBudaya;

  /// Topic title or description for quizTopicTantanganBudayaDesc
  ///
  /// In id, this message translates to:
  /// **'Ujian pemahaman tepa slira, subasita, dan kepemimpinan berwawasan Jawa.'**
  String get quizTopicTantanganBudayaDesc;

  /// Topic title or description for quizTopicTantanganAkhir
  ///
  /// In id, this message translates to:
  /// **'Tantangan Akhir'**
  String get quizTopicTantanganAkhir;

  /// Topic title or description for quizTopicTantanganAkhirDesc
  ///
  /// In id, this message translates to:
  /// **'Tantangan puncak memadukan aksara, tataran bahasa, dan kearifan budaya.'**
  String get quizTopicTantanganAkhirDesc;
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
