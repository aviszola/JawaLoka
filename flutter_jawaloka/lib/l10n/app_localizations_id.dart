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

  @override
  String get splashAppName => 'JawaLoka';

  @override
  String get splashAppTagline => 'Belajar bahasa dan aksara Jawa setiap hari';

  @override
  String get splashLoadingLabel => 'Memuat aplikasi...';

  @override
  String get authWelcomeBannerTitle => 'Selamat datang di JawaLoka';

  @override
  String get authWelcomeBannerSubtitle =>
      'Lestarikan warisan leluhur nusantara';

  @override
  String get commonBack => 'Kembali';

  @override
  String get commonCloseError => 'Tutup pesan error';

  @override
  String get authFullNameLabel => 'Nama Lengkap';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Kata Sandi';

  @override
  String get authShowPassword => 'Tampilkan kata sandi';

  @override
  String get authHidePassword => 'Sembunyikan kata sandi';

  @override
  String get validationNameRequired => 'Nama tidak boleh kosong';

  @override
  String get validationEmailInvalid => 'Format email belum benar';

  @override
  String get validationPasswordMinLength => 'Kata sandi minimal 8 karakter';

  @override
  String get validationPasswordEmpty => 'Kata sandi tidak boleh kosong';

  @override
  String get validationNameTooShort => 'Nama minimal 2 karakter';

  @override
  String get validationNameTooLong => 'Nama maksimal 30 karakter';

  @override
  String get validationNameInvalidChars =>
      'Nama hanya boleh berisi huruf, tanda hubung, dan spasi';

  @override
  String get validationEmailEmpty => 'Email tidak boleh kosong';

  @override
  String get validationEmailTooLong => 'Email maksimal 254 karakter';

  @override
  String get validationPasswordTooLong => 'Kata sandi maksimal 64 karakter';

  @override
  String get validationPasswordWhitespaceOnly =>
      'Kata sandi tidak boleh hanya berisi spasi';

  @override
  String get validationTranslationEmpty => 'Teks terjemahan tidak boleh kosong';

  @override
  String get validationTranslationTooLong =>
      'Teks terjemahan maksimal 200 karakter';

  @override
  String get validationDrawingEmpty => 'Goreskan aksara terlebih dahulu';

  @override
  String get validationDrawingTooShort =>
      'Goresan terlalu pendek, tulis aksara lebih lengkap';

  @override
  String get loginTitle => 'Masuk ke akunmu';

  @override
  String get loginSubtitle => 'Lanjutkan progres belajarmu di mana saja';

  @override
  String get loginInvalidCredentialsError => 'Email atau kata sandi salah';

  @override
  String get loginForgotPassword => 'Lupa kata sandi?';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginOrWith => 'Atau masuk dengan';

  @override
  String get loginGoogleButton => 'Lanjutkan dengan Google';

  @override
  String get loginDontHaveAccount => 'Belum punya akun? ';

  @override
  String get loginRegisterLink => 'Daftar';

  @override
  String get loginQuestionLevelTitle => 'Tingkat Kemampuan Bahasa Jawa';

  @override
  String get loginLevelBeginner => 'Pemula (Baru Belajar)';

  @override
  String get loginLevelIntermediate => 'Menengah (Kosakata Dasar)';

  @override
  String get loginLevelAdvanced => 'Mahir (Unggah-ungguh)';

  @override
  String get loginQuestionGoalTitle => 'Tujuan Utama Belajar';

  @override
  String get loginGoalAksara => 'Membaca & Menulis Aksara';

  @override
  String get loginGoalConversation => 'Percakapan Sehari-hari';

  @override
  String get loginGoalCulture => 'Seni & Tradisi Jawa';

  @override
  String get registerTitle => 'Buat akunmu';

  @override
  String get registerSubtitle => 'Simpan progres belajarmu di mana saja';

  @override
  String get registerPasswordHint =>
      'Gunakan kata sandi yang kuat (min. 8 karakter)';

  @override
  String get registerButton => 'Daftar';

  @override
  String get registerTermsPrefix => 'Dengan mendaftar, kamu menyetujui ';

  @override
  String get registerPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get registerAlreadyHaveAccount => 'Sudah punya akun? ';

  @override
  String get registerLoginLink => 'Masuk';

  @override
  String get authContinueAsGuest => 'Lanjut sebagai Tamu';

  @override
  String get authSkipToLearn => 'Lewati & Mulai Belajar';

  @override
  String get navHome => 'Beranda';

  @override
  String get navLearn => 'Belajar';

  @override
  String get navQuest => 'Misi';

  @override
  String get navQuiz => 'Kuis';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeGreetingMorning => 'Selamat pagi';

  @override
  String get homeGreetingAfternoon => 'Selamat siang';

  @override
  String get homeGreetingEvening => 'Selamat sore';

  @override
  String get homeGreetingNight => 'Selamat malam';

  @override
  String homeGreetingUser(String name) {
    return 'Halo, $name!';
  }

  @override
  String homeLevelPill(int level) {
    return 'L$level';
  }

  @override
  String get homeWeeklyStripTitle => 'Aktivitas Kuis Minggu Ini';

  @override
  String homeWeeklyCompletedCount(int count) {
    return '$count kuis selesai';
  }

  @override
  String homeWeeklyStreakInfo(int count) {
    return 'Streak kuis $count hari aktif. Selesaikan kuis harian untuk menjaga streak.';
  }

  @override
  String get dayMon => 'Sen';

  @override
  String get dayTue => 'Sel';

  @override
  String get dayWed => 'Rab';

  @override
  String get dayThu => 'Kam';

  @override
  String get dayFri => 'Jum';

  @override
  String get daySat => 'Sab';

  @override
  String get daySun => 'Min';

  @override
  String get homeHeroQuestBadge => 'MISI HARI INI';

  @override
  String homeHeroQuestTarget(int percent) {
    return 'Target: ≥$percent% Presisi';
  }

  @override
  String get homeHeroQuestTitle => 'Aksara \"Ha\" (ꦲ)';

  @override
  String get homeHeroQuestDesc =>
      'Tulis aksara dasar pertama Hanacaraka dengan goresan tepat.';

  @override
  String get homeHeroQuestButton => 'Mulai Menggambar';

  @override
  String get homeContinueQuizTitle => 'Lanjutkan Kuis';

  @override
  String get homeContinueQuizLevel => 'Tingkat: Mahir';

  @override
  String get homeContinueQuizNode => 'Node 4: Aksara Ra (ꦫ)';

  @override
  String homeContinueQuizProgress(int completed) {
    return '$completed dari 10 bab kuis terselesaikan';
  }

  @override
  String get homeContinueQuizButton => 'Buka Jalur Kuis';

  @override
  String get homeQuickLearnTitle => 'Belajar Cepat';

  @override
  String get homeQuickLearnSubtitle => 'Topik Ringkas';

  @override
  String get homeQuickLearnVocab => 'Kosa Kata';

  @override
  String get homeQuickLearnVocabSub => '3 Tingkat';

  @override
  String get homeQuickLearnAksara => 'Aksara Jawa';

  @override
  String get homeQuickLearnAksaraSub => 'Hanacaraka';

  @override
  String get homeQuickLearnTranslator => 'Penerjemah';

  @override
  String get homeQuickLearnTranslatorSub => 'Ngoko-Krama';

  @override
  String get homeQuickLearnEtiquette => 'Penggunaan Bahasa';

  @override
  String get homeQuickLearnEtiquetteSub => 'Unggah-Ungguh';

  @override
  String get homeQuickLearnProverbs => 'Peribahasa';

  @override
  String get homeQuickLearnProverbsSub => 'Paribasan';

  @override
  String get learnHeaderTitle => 'Pusat Belajar';

  @override
  String get learnHeaderSubtitle => 'Eksplorasi warisan budaya dan bahasa Jawa';

  @override
  String get learnSectionModules => 'Modul Pembelajaran';

  @override
  String get learnSectionDailyWord => 'Tembung Dina Iki';

  @override
  String get moduleCardLocked => 'Terkunci';

  @override
  String get learnModuleAksaraTitle => 'Aksara Jawa Dhasar';

  @override
  String get learnModuleAksaraSubtitle =>
      'Hanacaraka: 20 aksara dasar, sandhangan & pasangan';

  @override
  String get learnModuleAksaraLabel => '20 aksara terselesaikan';

  @override
  String get learnModuleVocabTitle => 'Kosa Kata (Kamus)';

  @override
  String get learnModuleVocabSubtitle =>
      'Kamus 3 tingkat tutur: Ngoko, Krama Madya, Krama Inggil';

  @override
  String get learnModuleVocabLabel => '120 tembung terselesaikan';

  @override
  String get learnModuleTranslatorTitle => 'Penerjemah Bahasa';

  @override
  String get learnModuleTranslatorSubtitle =>
      'Terjemahan dwiarah Indonesia, Ngoko, dan Krama';

  @override
  String get learnModuleTranslatorLabel => 'Siap Digunakan';

  @override
  String get learnModuleEtiquetteTitle => 'Penggunaan Bahasa';

  @override
  String get learnModuleEtiquetteSubtitle =>
      'Unggah-ungguh & tata krama ragam wicara';

  @override
  String get learnModuleEtiquetteLabel => '4 tingkatan tutur';

  @override
  String get learnModuleProverbsTitle => 'Peribahasa & Saloka';

  @override
  String get learnModuleProverbsSubtitle =>
      'Paribasan, bebasan, lan saloka warisan Jawa';

  @override
  String get learnModuleProverbsLabel => '15 peribahasa';

  @override
  String get learnTagAksara => 'Aksara';

  @override
  String get learnTagKamus => 'Kosa Kata';

  @override
  String get learnTagUtilitas => 'Utilitas';

  @override
  String get learnTagWicara => 'Wicara';

  @override
  String get learnTagSastra => 'Sastra';

  @override
  String get difficultyMudah => 'Mudah';

  @override
  String get difficultyMahir => 'Mahir';

  @override
  String get difficultySangatMahir => 'Sangat Mahir';

  @override
  String get quizPathTitle => 'Jalur Kuis';

  @override
  String quizCompletedBadge(int count) {
    return '$count Selesai';
  }

  @override
  String get quizUnit1Title => 'Unit 1: Sapaan dan Unggah-Ungguh Awal';

  @override
  String get quizUnit1Subtitle =>
      'Dasar percakapan dan tata krama sopan santun';

  @override
  String get quizUnit2Title => 'Unit 2: Aksara Jawa Dasar (Legena) (Terkunci)';

  @override
  String get quizUnit2Subtitle => 'Pengenalan 20 aksara legena Hanacaraka';

  @override
  String get quizTopicSalam => 'Salam';

  @override
  String get quizTopicPamit => 'Pamit';

  @override
  String get quizTopicLencana => 'Lencana';

  @override
  String get quizTopicTanyaKabar => 'Tanya kabar';

  @override
  String get quizTopicPerkenalan => 'Perkenalan';

  @override
  String get quizTopicKeluarga => 'Keluarga';

  @override
  String get quizTopicRumah => 'Rumah';

  @override
  String get quizTopicKerabat => 'Kerabat';

  @override
  String quizBottomSheetProgress(
    int quizIndex,
    int totalQuizzes,
    int questionCount,
  ) {
    return 'Kuis $quizIndex dari $totalQuizzes · $questionCount soal';
  }

  @override
  String get quizBottomSheetStart => 'Mulai Kuis';

  @override
  String get quizBottomSheetLater => 'Nanti saja';

  @override
  String quizComboCount(int count) {
    return '$count Benar!';
  }

  @override
  String quizOptionSemantics(String letter, String option) {
    return 'Pilihan $letter: $option';
  }

  @override
  String get quizCorrect => 'Betul!';

  @override
  String get quizIncorrect => 'Kurang tepat';

  @override
  String quizAnswerLabel(String answer) {
    return 'Jawaban: $answer';
  }

  @override
  String get quizQuestionSourceAttribution =>
      'Materi JawaLoka (draf, belum diverifikasi penutur Jawa)';

  @override
  String get quizCheck => 'Periksa';

  @override
  String get quizContinue => 'Lanjut';

  @override
  String get quizFinish => 'Selesai';

  @override
  String get quizResultAwesome => 'Luar Biasa!';

  @override
  String quizResultStreakBanner(int days) {
    return 'Streak kuis aktif: $days hari';
  }

  @override
  String get quizResultCorrectAnswers => 'Soal Benar';

  @override
  String get quizResultTime => 'Waktu';

  @override
  String get quizResultAccuracy => 'Akurasi';

  @override
  String get quizResultBackHome => 'Kembali ke Beranda';

  @override
  String get quizResultRetry => 'Ulangi kuis';

  @override
  String get drawingTitle => 'Latihan Menulis';

  @override
  String get drawingBackSemantics => 'Kembali';

  @override
  String get drawingInstruction => 'Tulis aksara ini!';

  @override
  String drawingStrokeCount(int count) {
    return 'Goresan: $count';
  }

  @override
  String get drawingClearAll => 'Hapus Semua';

  @override
  String get drawingUndo => 'Batalkan';

  @override
  String get drawingCheckButton => 'Periksa Tulisan';

  @override
  String get dailyResultTitle => 'Hasil Misi';

  @override
  String get dailyResultSimilarityLabel => 'Kemiripan';

  @override
  String dailyResultCelebrationPassed(String name) {
    return 'Hebat, $name!';
  }

  @override
  String get dailyResultCelebrationFailed => 'Ayo Latihan Lagi!';

  @override
  String dailyResultDescPassed(int percent) {
    return 'Kamu berhasil menulis aksara Jawa dengan kemiripan di atas $percent%.';
  }

  @override
  String get dailyResultDescFailed =>
      'Goresanmu hampir tepat. Coba perhatikan proporsi aksara target.';

  @override
  String get dailyResultComparison => 'Perbandingan Tulisan';

  @override
  String get dailyResultYourDrawing => 'Tulisanmu';

  @override
  String get dailyResultTargetScript => 'Aksara Target';

  @override
  String get dailyResultStatusPassed => 'Status: Lulus';

  @override
  String get dailyResultStatusFailed => 'Status: Belum Lulus';

  @override
  String dailyResultRequirement(int percent, int threshold) {
    return 'Kemiripan $percent% (Syarat lulus: ≥ $threshold%)';
  }

  @override
  String get dailyResultContinueLearning => 'Lanjutkan Belajar →';

  @override
  String get dailyResultTryAgain => 'Coba Lagi';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSettingsSemantics => 'Pengaturan';

  @override
  String get profileNameEmptyError => 'Nama tidak boleh kosong';

  @override
  String profileNameSaved(String name) {
    return 'Nama berhasil disimpan: $name';
  }

  @override
  String get profileSaveName => 'Simpan';

  @override
  String get profileCancelEdit => 'Batal';

  @override
  String profileLevelPill(int level) {
    return 'Lv $level';
  }

  @override
  String profileStreakPill(int days) {
    return 'Streak $days hari';
  }

  @override
  String profileQuizzesThisWeek(int count) {
    return '$count Kuis Minggu Ini';
  }

  @override
  String get profileBadgeTitle => 'Lencana';

  @override
  String get profileBadgeOpenCount => '1 / 4 Terbuka';

  @override
  String get profileBadgeCollection => 'Koleksi Prestasi';

  @override
  String get profileBadgeStreak7Title => 'Streak 7 Hari';

  @override
  String get profileBadgeStreak30Title => 'Streak 30 Hari';

  @override
  String get profileBadgeLevel5Title => 'Level 5';

  @override
  String get profileBadgeLevelUpHighlight => 'Naik Level';

  @override
  String get profileBadgeAksaraCompleteTitle => 'Tamat Aksara';

  @override
  String get profileBadgeEasyLevel => 'Tingkat Mudah';

  @override
  String get profileBadgeUnlocked => 'Terbuka';

  @override
  String get profileBadgeLocked => 'Terkunci';

  @override
  String get profileChooseBlangkonButton => 'Pilih Blangkon';

  @override
  String get blangkonTitle => 'Pilih Blangkon';

  @override
  String get blangkonSaveButton => 'Simpan Pilihan';

  @override
  String blangkonLevelRequired(int level) {
    return 'Level $level';
  }

  @override
  String get blangkonInitialUnlock => 'Terpasang awal';

  @override
  String get blangkonMasteryAksara => 'Selesai aksara';

  @override
  String get blangkonDescYogyakarta => 'Klasik, mondolan bulat menonjol';

  @override
  String get blangkonDescSurakarta => 'Anggun, mondolan trepes pipih';

  @override
  String get blangkonDescBanyumas => 'Tegas, corak khas Banyumasan';

  @override
  String get blangkonDescKedu => 'Gaya Bagelen Kedu bersahaja';

  @override
  String get blangkonDescCirebon => 'Pesisiran dinamis berwibawa';

  @override
  String get blangkonDescPusaka => 'Mahakarya tradisi berornamen emas';

  @override
  String get profileChooseBusanaButton => 'Pilih Busana';

  @override
  String get busanaTitle => 'Pilih Busana';

  @override
  String get busanaSaveButton => 'Simpan Pilihan';

  @override
  String get busanaDescYogyakarta =>
      'Elegan, kebaya kutubaru khas Keraton Yogyakarta';

  @override
  String get busanaDescSurakarta =>
      'Anggun, kebaya encim penuh ornamen batik Solo';

  @override
  String get busanaDescBanyumas =>
      'Segar, kebaya sunda polos bernuansa pesisiran';

  @override
  String get busanaDescKedu => 'Sederhana, busana kebaya gaya Kedu';

  @override
  String get busanaDescCirebon =>
      'Dinamis, kebaya bermotif mega mendung pesisir Cirebon';

  @override
  String get busanaDescPusaka =>
      'Istimewa, kebaya betawi encim bermotif penuh warna';

  @override
  String get busanaNameYogyakarta => 'Kutubaru Yogyakarta';

  @override
  String get busanaNameSurakarta => 'Kebaya Surakarta';

  @override
  String get busanaNameBanyumas => 'Kebaya Sunda';

  @override
  String get busanaNameKedu => 'Kebaya Kedu';

  @override
  String get busanaNameCirebon => 'Mega Mendung Cirebon';

  @override
  String get busanaNamePusaka => 'Betawi Encim';

  @override
  String get levelUpMicroTag => 'PENCAPAIAN JAWALOKA';

  @override
  String levelUpTitle(int level) {
    return 'Level $level!';
  }

  @override
  String get levelUpBlangkonUnlocked => 'Blangkon baru terbuka: ';

  @override
  String get levelUpBadgeCategory => 'LENCANA BARU';

  @override
  String get levelUpAchievementTitle => 'Sinau Mandiri V';

  @override
  String get levelUpAchievementDesc => 'Menyelesaikan 25 bab materi aksara';

  @override
  String get levelUpEquipButton => 'Pakai Blangkon';

  @override
  String get levelUpSkipButton => 'Nanti saja';

  @override
  String levelUpOtherRewardsCount(int count) {
    return ' (+$count blangkon lainnya)';
  }

  @override
  String get levelUpNoRewardSubtitle =>
      'Selamat! Tingkat pemahaman dan kecakapanmu semakin bertambah.';

  @override
  String get levelUpContinueButton => 'Lanjutkan';

  @override
  String get settingsLogout => 'Keluar';

  @override
  String get settingsLogoutConfirm => 'Yakin ingin keluar?';

  @override
  String get settingsCancel => 'Batal';

  @override
  String get settingsPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get settingsPrivacyPolicyContent =>
      'Aplikasi JawaLoka menyimpan nama tampilan, pilihan bahasa, koleksi blangkon, progres kuis, XP, dan Level secara lokal di perangkat Anda. Aplikasi ini tidak mengirim data ke server, tidak memiliki akun sungguhan (versi demo), dan tidak menyimpan kata sandi.';

  @override
  String get settingsClose => 'Tutup';

  @override
  String get settingsAccountRow => 'Akun';

  @override
  String get settingsAccountDialogTitle => 'Detail Akun';

  @override
  String get settingsAccountNameLabel => 'Nama Pengguna';

  @override
  String get settingsAccountLocalNote => 'Akun lokal pada perangkat ini';

  @override
  String get translatorTitle => 'Penerjemah';

  @override
  String get translatorInputLabel => 'MASUKKAN TEKS';

  @override
  String get translatorInputHint => 'Ketik teks...';

  @override
  String translatorBasicPhrasesHint(String examples) {
    return 'Contoh frasa dasar yang didukung: $examples.';
  }

  @override
  String get translatorButton => 'Terjemahkan';

  @override
  String get translatorTranslating => 'Menerjemahkan...';

  @override
  String get translatorOutputLabel => 'HASIL TERJEMAHAN';

  @override
  String get translatorOutputPlaceholder =>
      'Hasil terjemahan akan muncul di sini…';

  @override
  String get translatorCopiedToast => 'Teks disalin';

  @override
  String get translatorPickerTitle => 'Pilih Bahasa';

  @override
  String get translatorSwapSemantics => 'Tukar bahasa';

  @override
  String get translatorCopyTooltip => 'Salin';

  @override
  String get translatorClearTooltip => 'Hapus';

  @override
  String get translatorMockUnavailable => 'Belum tersedia pada versi contoh';

  @override
  String get translatorLangJvNgoko => 'Jawa Ngoko';

  @override
  String get translatorLangJvKrama => 'Jawa Krama';

  @override
  String get translatorLangId => 'Indonesia';

  @override
  String get translatorLangEn => 'English';

  @override
  String get aksaraDetailTitle => 'Aksara Jawa';

  @override
  String get aksaraDetailTag => 'Dasar';

  @override
  String get aksaraDetailExampleHeader => 'Contoh Kata';

  @override
  String get aksaraDetailSandanganHeader => 'Sandangan';

  @override
  String get aksaraDetailSandanganSubtitle =>
      'Variasi vokal pada aksara ꦲ (Ha)';

  @override
  String get aksaraDetailWritingHeader => 'Cara Menulis';

  @override
  String get aksaraDetailStep1Title => 'Mulai dari kanan atas';

  @override
  String get aksaraDetailStep1Desc =>
      'Tarik garis lengkung ke bawah dari titik awal di kanan atas.';

  @override
  String get aksaraDetailStep2Title => 'Lengkung badan aksara';

  @override
  String get aksaraDetailStep2Desc =>
      'Buat lengkungan utama yang membentuk tubuh aksara Ha ke kiri.';

  @override
  String get aksaraDetailStep3Title => 'Tutup dengan ekor';

  @override
  String get aksaraDetailStep3Desc =>
      'Akhiri dengan garis ekor pendek yang melengkung ke dalam.';

  @override
  String get aksaraDetailWritingButton => 'Latihan Menulis';

  @override
  String get aksaraDetailQuizButton => 'Mulai Kuis';

  @override
  String get vocabDetailTitle => 'Kosa Kata';

  @override
  String get vocabDetailTag => 'Mudah';

  @override
  String get vocabDetailMeaningHeader => 'Makna & Tingkatan';

  @override
  String get vocabDetailExamplesHeader => 'Contoh Kalimat';

  @override
  String get vocabDetailNextButton => 'Kata Berikutnya';

  @override
  String get profileBadgeStreak7Toast => 'Lencana Streak 7 Hari telah terbuka!';

  @override
  String get profileBadgeStreak30Toast =>
      'Pertahankan streak 30 hari untuk membuka lencana ini!';

  @override
  String get profileBadgeLevel5Toast => 'Blangkon Surakarta berhasil dipasang!';

  @override
  String get profileBadgeAksaraToast =>
      'Selesaikan seluruh modul aksara dasar untuk membuka!';

  @override
  String blangkonToastInitial(String name) {
    return 'Terbuka sejak awal: $name';
  }

  @override
  String blangkonToastLevel(int level, String name) {
    return 'Butuh Level $level untuk membuka $name';
  }

  @override
  String blangkonToastAksara(String name) {
    return 'Selesaikan seluruh materi aksara untuk membuka $name';
  }

  @override
  String get vocabDetailFavoriteMark => 'Tandai Favorit';

  @override
  String get vocabDetailFavoriteMarked => 'Ditandai Favorit';

  @override
  String get quizMilestoneNode => 'Node Tonggak';

  @override
  String quizNodeLockedToast(String topic) {
    return 'Materi $topic masih terkunci. Selesaikan materi sebelumnya!';
  }

  @override
  String quizUnitTitle(int unit, String level) {
    return 'Unit $unit · Tingkat $level';
  }

  @override
  String get quizTopicSalamDesc =>
      'Pelajari salam dan tegur sapa sopan santun bahasa Jawa.';

  @override
  String get quizTopicPamitDesc =>
      'Ungkapan pamitan dan perpisahan sehari-hari yang santun.';

  @override
  String get quizTopicLencanaDesc =>
      'Uji pemahaman tonggak materi sapaan dan salam.';

  @override
  String get quizTopicTanyaKabarDesc =>
      'Menanyakan keadaan dan kabar orang lain dalam bahasa Jawa.';

  @override
  String get quizTopicPerkenalanDesc =>
      'Mengenalkan diri dengan unggah-ungguh yang tepat.';

  @override
  String get quizTopicKeluargaDesc =>
      'Sebutan anggota keluarga dan kerabat terdekat.';

  @override
  String get quizTopicRumahDesc =>
      'Bagian-bagian rumah tradisional dan perlengkapan.';

  @override
  String get quizTopicKerabatDesc =>
      'Tingkatan silsilah keluarga besar masyarakat Jawa.';

  @override
  String get quizQuestionPromptWhatGlyph => 'Aksara apa ini?';

  @override
  String get quizQuestionPromptPronunciation =>
      'Pilih pelafalan untuk aksara berikut:';

  @override
  String quizQuestionPromptHowToRead(String glyph) {
    return 'Aksara \"$glyph\" dibaca sebagai apa?';
  }

  @override
  String get quizQuestionPromptWhichPronunciation =>
      'Manakah pelafalan untuk aksara di bawah?';

  @override
  String get quizSkip => 'Lewati';

  @override
  String get quizCloseSemantics => 'Tutup';

  @override
  String get quizExitDialogTitle => 'Keluar dari Kuis?';

  @override
  String get quizExitDialogMessage =>
      'Progres kuis saat ini tidak akan disimpan.';

  @override
  String get quizExitDialogConfirm => 'Keluar';

  @override
  String get quizExitDialogCancel => 'Lanjutkan';

  @override
  String get learnUnggahSheetTitle => 'Penggunaan Bahasa';

  @override
  String get learnUnggahSheetSubtitle =>
      'Tingkatan ragam bahasa Jawa menurut tata krama dan unggah-ungguh.';

  @override
  String get learnUnggahNgokoLuguTitle => '1. Basa Ngoko Lugu';

  @override
  String get learnUnggahNgokoLuguDesc =>
      'Digunakan untuk teman sebaya, saudara muda, atau orang yang sudah sangat akrab.';

  @override
  String get learnUnggahNgokoAlusTitle => '2. Basa Ngoko Alus';

  @override
  String get learnUnggahNgokoAlusDesc =>
      'Bahasa ngoko yang bercampur kata krama inggil untuk menghormati lawan bicara.';

  @override
  String get learnUnggahKramaLuguTitle => '3. Basa Krama Lugu / Madya';

  @override
  String get learnUnggahKramaLuguDesc =>
      'Bahasa krama sopan umum untuk orang yang belum begitu dikenal atau rekan kerja.';

  @override
  String get learnUnggahKramaInggilTitle => '4. Basa Krama Inggil / Alus';

  @override
  String get learnUnggahKramaInggilDesc =>
      'Tingkatan paling luhur, digunakan kepada orang tua, guru, atau sesepuh.';

  @override
  String learnUnggahExamplePrefix(String example) {
    return 'Contoh: \"$example\"';
  }

  @override
  String get learnPeribahasaSheetTitle => 'Peribahasa & Saloka Jawa';

  @override
  String get learnPeribahasaSheetSubtitle =>
      'Pepatah dan ungkapan luhur warisan leluhur kebudayaan Jawa.';

  @override
  String get learnProverb1Meaning =>
      'Kehormatan seseorang terletak pada tutur katanya, dan kehormatan tubuh terletak pada pakaiannya.';

  @override
  String get learnProverb2Meaning =>
      'Hidup itu hendaknya memberi manfaat dan menerangi orang lain di sekitarnya.';

  @override
  String get learnProverb3Meaning =>
      'Setiap cita-cita dan kesuksesan memerlukan usaha, pengorbanan, dan biaya.';

  @override
  String get learnProverb4Meaning =>
      'Menjunjung tinggi kehormatan orang tua dan keluarga serta menutup aib atau keburukan.';

  @override
  String get learnProverb5Meaning =>
      'Kerukunan menciptakan ketenteraman dan kekuatan, perpecahan membawa kehancuran.';

  @override
  String get learnDailyWordOmah => 'Rumah';

  @override
  String get learnDailyWordBanyu => 'Air';

  @override
  String get learnDailyWordSegara => 'Laut';

  @override
  String get learnDailyWordLemah => 'Tanah';

  @override
  String get learnDailyWordLangit => 'Langit';

  @override
  String get vocabDetailLangId => 'Bahasa Indonesia';

  @override
  String get vocabDetailLangEn => 'Bahasa Inggris';

  @override
  String get vocabDetailLangJv => 'Bahasa Jawa (Ngoko)';

  @override
  String get vocabDetailSentence1Translation => 'Rumahku ada di desa';

  @override
  String get vocabDetailSentence2Translation => 'Rumah ini sangat besar';

  @override
  String get aksaraDetailExampleHaraMeaning => 'Cabang';

  @override
  String get aksaraDetailExampleHawuMeaning => 'Tungku';

  @override
  String get aksaraDetailExampleHasthaMeaning => 'Delapan';

  @override
  String get quizUnit3Title =>
      'Unit 3: Sandhangan dan Pasangan Aksara Jawa (Terkunci)';

  @override
  String get quizUnit3Subtitle =>
      'Vokalisasi, konsonan penutup, dan pasangan aksara';

  @override
  String get quizUnit4Title =>
      'Unit 4: Kosakata dan Tingkatan Bahasa (Terkunci)';

  @override
  String get quizUnit4Subtitle =>
      'Tingkatan ngoko, krama lugu, dan krama inggil';

  @override
  String get quizUnit5Title =>
      'Unit 5: Budaya, Paribasan, dan Kawruh Luhur (Terkunci)';

  @override
  String get quizUnit5Subtitle =>
      'Paribasan, filosofi, adat tradisi, dan kawruh luhur Jawa';

  @override
  String get quizTopicSapaWong => 'Menyapa Orang Lain';

  @override
  String get quizTopicSapaWongDesc =>
      'Tata krama menegur dan menyapa orang yang ditemui.';

  @override
  String get quizTopicMaturNuwun => 'Terima Kasih';

  @override
  String get quizTopicMaturNuwunDesc =>
      'Ungkapan rasa syukur dan terima kasih yang santun.';

  @override
  String get quizTopicNyuwunPangapunten => 'Meminta Maaf';

  @override
  String get quizTopicNyuwunPangapuntenDesc =>
      'Ungkapan permohonan maaf dan mengakui kekeliruan.';

  @override
  String get quizTopicPercakapanPadinan => 'Percakapan Sehari-hari';

  @override
  String get quizTopicPercakapanPadinanDesc =>
      'Latihan dialog sapaan sopan dalam kehidupan sehari-hari.';

  @override
  String get quizTopicEvaluasiUnit1 => 'Evaluasi Unit 1';

  @override
  String get quizTopicEvaluasiUnit1Desc =>
      'Uji komprehensif materi sapaan dan unggah-ungguh awal.';

  @override
  String get quizTopicPengenalanHanacaraka => 'Pengenalan Hanacaraka';

  @override
  String get quizTopicPengenalanHanacarakaDesc =>
      'Mengenal asal-usul dan filosofi 20 aksara carakan Jawa.';

  @override
  String get quizTopicAksaraHanacaraka => 'Aksara Ha Na Ca Ra Ka';

  @override
  String get quizTopicAksaraHanacarakaDesc =>
      'Bentuk dan pelafalan aksara Ha, Na, Ca, Ra, Ka.';

  @override
  String get quizTopicAksaraDatasawala => 'Aksara Da Ta Sa Wa La';

  @override
  String get quizTopicAksaraDatasawalaDesc =>
      'Bentuk dan pelafalan aksara Da, Ta, Sa, Wa, La.';

  @override
  String get quizTopicAksaraPadhajayanya => 'Aksara Pa Dha Ja Ya Nya';

  @override
  String get quizTopicAksaraPadhajayanyaDesc =>
      'Bentuk dan pelafalan aksara Pa, Dha, Ja, Ya, Nya.';

  @override
  String get quizTopicAksaraMagabathanga => 'Aksara Ma Ga Ba Tha Nga';

  @override
  String get quizTopicAksaraMagabathangaDesc =>
      'Bentuk dan pelafalan aksara Ma, Ga, Ba, Tha, Nga.';

  @override
  String get quizTopicMacaAksaraDhasar => 'Membaca Aksara Dasar';

  @override
  String get quizTopicMacaAksaraDhasarDesc =>
      'Latihan membaca kombinasi suku kata terbuka aksara legena.';

  @override
  String get quizTopicNyusunAksaraLegena => 'Menyusun Aksara Legena';

  @override
  String get quizTopicNyusunAksaraLegenaDesc =>
      'Menyusun aksara Jawa legena menjadi kata yang bermakna.';

  @override
  String get quizTopicNiteniWujudAksara => 'Mengenali Bentuk Aksara';

  @override
  String get quizTopicNiteniWujudAksaraDesc =>
      'Membedakan bentuk aksara legena yang sekilas mirip.';

  @override
  String get quizTopicGladhenMacaLegena => 'Latihan Membaca Kata Legena';

  @override
  String get quizTopicGladhenMacaLegenaDesc =>
      'Membaca kata dua dan tiga suku kata tanpa sandhangan.';

  @override
  String get quizTopicEvaluasiUnit2 => 'Evaluasi Unit 2';

  @override
  String get quizTopicEvaluasiUnit2Desc =>
      'Uji komprehensif penguasaan 20 aksara legena Hanacaraka.';

  @override
  String get quizTopicSandhanganSwara => 'Sandhangan Swara';

  @override
  String get quizTopicSandhanganSwaraDesc =>
      'Mengubah vokal aksara dengan wulu, suku, taling, dan pepet.';

  @override
  String get quizTopicSandhanganPanyigeg => 'Sandhangan Panyigeg Wanda';

  @override
  String get quizTopicSandhanganPanyigegDesc =>
      'Konsonan penutup wignyan, layar, cecak, dan pangkon.';

  @override
  String get quizTopicSandhanganWyanjana => 'Sandhangan Wyanjana';

  @override
  String get quizTopicSandhanganWyanjanaDesc =>
      'Sisipan semivokal cakra, keret, dan pengkal pada aksara.';

  @override
  String get quizTopicPengenalanPasangan => 'Pengenalan Pasangan';

  @override
  String get quizTopicPengenalanPasanganDesc =>
      'Fungsi dan cara kerja pasangan dalam mematikan vokal.';

  @override
  String get quizTopicPasanganSejajarGantung => 'Pasangan Sejajar & Gantung';

  @override
  String get quizTopicPasanganSejajarGantungDesc =>
      'Membedakan pasangan yang ditulis sejajar dan menggantung.';

  @override
  String get quizTopicMacaKataSandhangan => 'Membaca Kata Bersandhangan';

  @override
  String get quizTopicMacaKataSandhanganDesc =>
      'Membaca kosakata yang menggunakan aneka sandhangan swara.';

  @override
  String get quizTopicNulisKataSederhana => 'Menulis Kata Sederhana';

  @override
  String get quizTopicNulisKataSederhanaDesc =>
      'Menyusun aksara bersandhangan menjadi kata yang benar.';

  @override
  String get quizTopicNiteniLuputNulis => 'Mengenali Kesalahan Tulis';

  @override
  String get quizTopicNiteniLuputNulisDesc =>
      'Menemukan dan memperbaiki salah letak sandhangan & pasangan.';

  @override
  String get quizTopicGladhenKombinasi => 'Latihan Kombinasi';

  @override
  String get quizTopicGladhenKombinasiDesc =>
      'Latihan gabungan sandhangan swara, panyigeg, dan pasangan.';

  @override
  String get quizTopicEvaluasiUnit3 => 'Evaluasi Unit 3';

  @override
  String get quizTopicEvaluasiUnit3Desc =>
      'Uji komprehensif aturan sandhangan dan pasangan aksara Jawa.';

  @override
  String get quizTopicKeluargaLanKerabat => 'Keluarga & Kerabat';

  @override
  String get quizTopicKeluargaLanKerabatDesc =>
      'Sebutan silsilah keluarga dalam ragam ngoko dan krama.';

  @override
  String get quizTopicOmahLanSakiwatengene => 'Rumah & Lingkungan';

  @override
  String get quizTopicOmahLanSakiwatengeneDesc =>
      'Nama perabot, ruangan rumah, dan lingkungan sekitar.';

  @override
  String get quizTopicKagiyatanPadinan => 'Kegiatan Sehari-hari';

  @override
  String get quizTopicKagiyatanPadinanDesc =>
      'Kata kerja dan aktivitas harian dalam tataran bahasa.';

  @override
  String get quizTopicNgokoLugu => 'Ragam Ngoko Lugu';

  @override
  String get quizTopicNgokoLuguDesc =>
      'Ciri dan penggunaan bahasa ngoko lugu antarteman akrab.';

  @override
  String get quizTopicNgokoAlus => 'Ragam Ngoko Alus';

  @override
  String get quizTopicNgokoAlusDesc =>
      'Sisipan krama inggil dalam kalimat ngoko untuk menghormati.';

  @override
  String get quizTopicKramaLugu => 'Ragam Krama Lugu';

  @override
  String get quizTopicKramaLuguDesc =>
      'Bentuk sopan formal netral tanpa pengagungan berlebihan.';

  @override
  String get quizTopicKramaInggil => 'Ragam Krama Inggil';

  @override
  String get quizTopicKramaInggilDesc =>
      'Tingkatan paling tinggi untuk menghormati sesepuh dan tokoh.';

  @override
  String get quizTopicBandhinganTingkatBasa => 'Perbandingan Tingkatan Bahasa';

  @override
  String get quizTopicBandhinganTingkatBasaDesc =>
      'Membandingkan padanan satu kata dalam ngoko, krama, dan inggil.';

  @override
  String get quizTopicWicaraUnggahUngguh => 'Percakapan Unggah-Ungguh';

  @override
  String get quizTopicWicaraUnggahUngguhDesc =>
      'Menerapkan unggah-ungguh basa dalam simulasi dialog nyata.';

  @override
  String get quizTopicEvaluasiUnit4 => 'Evaluasi Unit 4';

  @override
  String get quizTopicEvaluasiUnit4Desc =>
      'Uji komprehensif kosakata dan penerapan tingkatan bahasa.';

  @override
  String get quizTopicAjiningDhiri => 'Ajining Dhiri';

  @override
  String get quizTopicAjiningDhiriDesc =>
      'Filosofi menjaga kehormatan diri melalui tutur kata yang santun.';

  @override
  String get quizTopicUnggahUngguhBasa => 'Unggah-Ungguh Basa Jawa';

  @override
  String get quizTopicUnggahUngguhBasaDesc =>
      'Etika kesopanan tindak tanduk dan tata tutur orang Jawa.';

  @override
  String get quizTopicParibasanJawa => 'Peribahasa & Paribasan';

  @override
  String get quizTopicParibasanJawaDesc =>
      'Makna mendalam ungkapan kiasan, paribasan, dan bebasan Jawa.';

  @override
  String get quizTopicFilosofiUrip => 'Filosofi Urip Iku Urup';

  @override
  String get quizTopicFilosofiUripDesc =>
      'Makna hidup memberi manfaat bagi sesama dan alam semesta.';

  @override
  String get quizTopicTradisiPranatan => 'Tradisi & Pranatan Jawa';

  @override
  String get quizTopicTradisiPranatanDesc =>
      'Upacara adat, siklus kehidupan, dan tata krama tradisi Jawa.';

  @override
  String get quizTopicPewayanganPandhawa => 'Pewayangan Pandhawa';

  @override
  String get quizTopicPewayanganPandhawaDesc =>
      'Karakter kebajikan tokoh wayang Pandhawa Lima dan nasihat hidup.';

  @override
  String get quizTopicTembangDolanan => 'Tembang Dolanan & Piwulang';

  @override
  String get quizTopicTembangDolananDesc =>
      'Pesan moral dan budi pekerti dalam tembang dolanan anak Jawa.';

  @override
  String get quizTopicEtikaBudaya => 'Etika & Situasi Budaya';

  @override
  String get quizTopicEtikaBudayaDesc =>
      'Memilih tindakan dan tutur kata yang tepat di lingkungan budaya.';

  @override
  String get quizTopicKawruhLuhur => 'Tantangan Kawruh Luhur';

  @override
  String get quizTopicKawruhLuhurDesc =>
      'Ujian tingkat lanjut memadukan aksara, basa, dan budi pekerti.';

  @override
  String get quizTopicEvaluasiAkhir => 'Evaluasi Akhir JawaLoka';

  @override
  String get quizTopicEvaluasiAkhirDesc =>
      'Evaluasi akbar seluruh materi pembelajaran 50 node JawaLoka.';

  @override
  String get quizTopicUngkapanSopan => 'Ungkapan Sopan';

  @override
  String get quizTopicUngkapanSopanDesc =>
      'Tata krama sikap badan, subasita, dan trapsila dalam adat Jawa.';

  @override
  String get quizTopicPenggunaanPasangan => 'Penggunaan Pasangan';

  @override
  String get quizTopicPenggunaanPasanganDesc =>
      'Aturan dan latihan penulisan pasangan aksara dalam kata dan kalimat.';

  @override
  String get quizTopicKosakataPadinan => 'Kosakata Sehari-hari';

  @override
  String get quizTopicKosakataPadinanDesc =>
      'Kosakata dasar sehari-hari dan hubungan kekeluargaan Jawa.';

  @override
  String get quizTopicNamaBenda => 'Nama Benda';

  @override
  String get quizTopicNamaBendaDesc =>
      'Nama benda rumah tangga, bagian rumah Joglo, dan lingkungan sekitar.';

  @override
  String get quizTopicNamaKegiatan => 'Nama Kegiatan';

  @override
  String get quizTopicNamaKegiatanDesc =>
      'Kata kerja dan aktivitas sehari-hari dalam bahasa Jawa.';

  @override
  String get quizTopicNgoko => 'Ngoko';

  @override
  String get quizTopicNgokoDesc =>
      'Penggunaan dan kosakata ragam Ngoko untuk teman sebaya dan akrab.';

  @override
  String get quizTopicKrama => 'Krama';

  @override
  String get quizTopicKramaDesc =>
      'Ragam bahasa Krama halus untuk situasi sopan dan formal.';

  @override
  String get quizTopicPerbedaanTingkatanBahasa => 'Perbedaan Tingkatan Bahasa';

  @override
  String get quizTopicPerbedaanTingkatanBahasaDesc =>
      'Perbandingan padanan kata dalam ragam Ngoko, Krama, dan Krama Inggil.';

  @override
  String get quizTopicPercakapanTeman => 'Percakapan dengan Teman';

  @override
  String get quizTopicPercakapanTemanDesc =>
      'Latihan percakapan akrab dengan teman menggunakan bahasa Ngoko yang tepat.';

  @override
  String get quizTopicPercakapanDihormati =>
      'Percakapan dengan Orang yang Dihormati';

  @override
  String get quizTopicPercakapanDihormatiDesc =>
      'Percakapan santun dengan orang tua, guru, dan sesepuh menggunakan Krama Inggil.';

  @override
  String get quizTopicTataKramaJawa => 'Tata Krama Jawa';

  @override
  String get quizTopicTataKramaJawaDesc =>
      'Prinsip kesopanan, ajining dhiri, dan etika tutur dalam budaya Jawa.';

  @override
  String get quizTopicPeribahasaJawa => 'Peribahasa Jawa';

  @override
  String get quizTopicPeribahasaJawaDesc =>
      'Nasihat hidup dan kearifan lokal dalam paribasan, bebasan, dan saloka Jawa.';

  @override
  String get quizTopicFilosofiKehidupan => 'Filosofi Kehidupan Jawa';

  @override
  String get quizTopicFilosofiKehidupanDesc =>
      'Ajaran filosofis mendalam: Urip Iku Urup dan Memayu Hayuning Bawana.';

  @override
  String get quizTopicTradisiJawa => 'Tradisi Jawa';

  @override
  String get quizTopicTradisiJawaDesc =>
      'Upacara adat, siklus hidup, dan tradisi warisan leluhur Jawa.';

  @override
  String get quizTopicBudayaKesenian => 'Budaya dan Kesenian';

  @override
  String get quizTopicBudayaKesenianDesc =>
      'Kesenian wayang purwa, gamelan, dan ekspresi budaya tradisi Jawa.';

  @override
  String get quizTopicSituasiPadinan => 'Situasi Kehidupan Sehari-hari';

  @override
  String get quizTopicSituasiPadinanDesc =>
      'Penerapan kearifan tembang dolanan dan nilai sosial dalam kehidupan nyata.';

  @override
  String get quizTopicTantanganBudaya => 'Tantangan Pemahaman Budaya';

  @override
  String get quizTopicTantanganBudayaDesc =>
      'Ujian pemahaman tepa slira, subasita, dan kepemimpinan berwawasan Jawa.';

  @override
  String get quizTopicTantanganAkhir => 'Tantangan Akhir';

  @override
  String get quizTopicTantanganAkhirDesc =>
      'Tantangan puncak memadukan aksara, tataran bahasa, dan kearifan budaya.';
}
