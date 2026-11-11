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

  @override
  String get splashAppName => 'JawaLoka';

  @override
  String get splashAppTagline => 'Sinau basa lan aksara Jawa saben dina';

  @override
  String get splashLoadingLabel => 'Ngamot aplikasi...';

  @override
  String get authWelcomeBannerTitle => 'Sugeng rawuh ing JawaLoka';

  @override
  String get authWelcomeBannerSubtitle =>
      'Nglestarekake warisan leluhur nusantara';

  @override
  String get commonBack => 'Wangsul';

  @override
  String get commonCloseError => 'Tutup pesen kaluputan';

  @override
  String get authFullNameLabel => 'Jeneng Jangkep';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Tembung Sandi';

  @override
  String get authShowPassword => 'Tampilake tembung sandi';

  @override
  String get authHidePassword => 'Delikake tembung sandi';

  @override
  String get validationNameRequired => 'Jeneng ora kena kothong';

  @override
  String get validationEmailInvalid => 'Format email durung bener';

  @override
  String get validationPasswordMinLength =>
      'Tembung sandi paling sethithik 8 aksara';

  @override
  String get validationPasswordEmpty => 'Tembung sandi ora kena kothong';

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
  String get loginTitle => 'Mlebu menyang akunmu';

  @override
  String get loginSubtitle => 'Terusake kamajuan sinaumu ing ngendi wae';

  @override
  String get loginInvalidCredentialsError => 'Email utawa tembung sandi salah';

  @override
  String get loginForgotPassword => 'Lali tembung sandi?';

  @override
  String get loginButton => 'Mlebu';

  @override
  String get loginOrWith => 'Utawa mlebu nganggo';

  @override
  String get loginGoogleButton => 'Lajengake nganggo Google';

  @override
  String get loginDontHaveAccount => 'Durung duwe akun? ';

  @override
  String get loginRegisterLink => 'Ndhaptar';

  @override
  String get loginQuestionLevelTitle => 'Tataran Kawruh Basa Jawa';

  @override
  String get loginLevelBeginner => 'Pamula (Nembe Sinau)';

  @override
  String get loginLevelIntermediate => 'Madya (Paham Tembung)';

  @override
  String get loginLevelAdvanced => 'Linuwih (Lantip Basa)';

  @override
  String get loginQuestionGoalTitle => 'Tujuwan Utama Sinau';

  @override
  String get loginGoalAksara => 'Nulis & Maca Hanacaraka';

  @override
  String get loginGoalConversation => 'Guneman Padinan';

  @override
  String get loginGoalCulture => 'Kagunan & Kabudayan';

  @override
  String get registerTitle => 'Gawe akunmu';

  @override
  String get registerSubtitle => 'Simpen kamajuan sinaumu ing ngendi wae';

  @override
  String get registerPasswordHint =>
      'Gunakake tembung sandi sing kuwat (min. 8 aksara)';

  @override
  String get registerButton => 'Ndhaptar';

  @override
  String get registerTermsPrefix => 'Dengan mendaftar, kamu menyetujui ';

  @override
  String get registerPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get registerAlreadyHaveAccount => 'Wis duwe akun? ';

  @override
  String get registerLoginLink => 'Mlebu';

  @override
  String get authContinueAsGuest => 'Lajeng dados Tamu';

  @override
  String get authSkipToLearn => 'Lumpati & Wiwit Sinau';

  @override
  String get navHome => 'Beranda';

  @override
  String get navLearn => 'Sinau';

  @override
  String get navQuest => 'Misi';

  @override
  String get navQuiz => 'Kuis';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeGreetingMorning => 'Sugeng enjang';

  @override
  String get homeGreetingAfternoon => 'Sugeng siang';

  @override
  String get homeGreetingEvening => 'Sugeng sonten';

  @override
  String get homeGreetingNight => 'Sugeng dalu';

  @override
  String homeGreetingUser(String name) {
    return 'Sugeng rawuh, $name!';
  }

  @override
  String homeLevelPill(int level) {
    return 'L$level';
  }

  @override
  String get homeWeeklyStripTitle => 'Aktivitas Kuis Minggu Iki';

  @override
  String homeWeeklyCompletedCount(int count) {
    return '$count kuis rampung';
  }

  @override
  String homeWeeklyStreakInfo(int count) {
    return 'Streak kuis $count dina aktif. Rampungake kuis saben dina kanggo njaga streak.';
  }

  @override
  String get dayMon => 'Sen';

  @override
  String get dayTue => 'Sel';

  @override
  String get dayWed => 'Reb';

  @override
  String get dayThu => 'Kem';

  @override
  String get dayFri => 'Jum';

  @override
  String get daySat => 'Sep';

  @override
  String get daySun => 'Nga';

  @override
  String get homeHeroQuestBadge => 'MISI DINA IKI';

  @override
  String homeHeroQuestTarget(int percent) {
    return 'Target: ≥$percent% Presisi';
  }

  @override
  String get homeHeroQuestTitle => 'Aksara \"Ha\" (ꦲ)';

  @override
  String get homeHeroQuestDesc =>
      'Serat aksara dhasar kapisan Hanacaraka kanthi lerese coretan.';

  @override
  String get homeHeroQuestButton => 'Miwiti Nggambar';

  @override
  String get homeContinueQuizTitle => 'Nglajengaken Kuis';

  @override
  String get homeContinueQuizLevel => 'Tataran: Wasis';

  @override
  String get homeContinueQuizNode => 'Node 4: Aksara Ra (ꦫ)';

  @override
  String homeContinueQuizProgress(int completed) {
    return '$completed saking 10 bab kuis sampun rampung';
  }

  @override
  String get homeContinueQuizButton => 'Bikak Dalan Kuis';

  @override
  String get homeQuickLearnTitle => 'Sinau Cepet';

  @override
  String get homeQuickLearnSubtitle => 'Topik Ringkes';

  @override
  String get homeQuickLearnVocab => 'Kosa Tembung';

  @override
  String get homeQuickLearnVocabSub => '3 Tataran';

  @override
  String get homeQuickLearnAksara => 'Aksara Jawa';

  @override
  String get homeQuickLearnAksaraSub => 'Hanacaraka';

  @override
  String get homeQuickLearnTranslator => 'Penerjemah';

  @override
  String get homeQuickLearnTranslatorSub => 'Ngoko-Krama';

  @override
  String get homeQuickLearnEtiquette => 'Unggah-Ungguh Basa';

  @override
  String get homeQuickLearnEtiquetteSub => 'Unggah-Ungguh';

  @override
  String get homeQuickLearnProverbs => 'Paribasan';

  @override
  String get homeQuickLearnProverbsSub => 'Paribasan';

  @override
  String get learnHeaderTitle => 'Papan Sinau';

  @override
  String get learnHeaderSubtitle => 'Njlajah warisan kabudayan lan basa Jawa';

  @override
  String get learnSectionModules => 'Modul Pasinaon';

  @override
  String get learnSectionDailyWord => 'Tembung Dina Iki';

  @override
  String get moduleCardLocked => 'Kakonci';

  @override
  String get learnModuleAksaraTitle => 'Aksara Jawa Dhasar';

  @override
  String get learnModuleAksaraSubtitle =>
      'Hanacaraka: 20 aksara dhasar, sandhangan & pasangan';

  @override
  String get learnModuleAksaraLabel => '20 aksara sampun rampung';

  @override
  String get learnModuleVocabTitle => 'Kosa Tembung (Bausastra)';

  @override
  String get learnModuleVocabSubtitle =>
      'Bausastra 3 tataran tutur: Ngoko, Krama Madya, Krama Inggil';

  @override
  String get learnModuleVocabLabel => '120 tembung sampun rampung';

  @override
  String get learnModuleTranslatorTitle => 'Penerjemah Basa';

  @override
  String get learnModuleTranslatorSubtitle =>
      'Jarwan rong arah Indonesia, Ngoko, lan Krama';

  @override
  String get learnModuleTranslatorLabel => 'Siap Diagem';

  @override
  String get learnModuleEtiquetteTitle => 'Unggah-Ungguh Basa';

  @override
  String get learnModuleEtiquetteSubtitle =>
      'Unggah-ungguh lan tata krama wernaning wicara';

  @override
  String get learnModuleEtiquetteLabel => '4 tataran tutur';

  @override
  String get learnModuleProverbsTitle => 'Paribasan lan Saloka';

  @override
  String get learnModuleProverbsSubtitle =>
      'Paribasan, bebasan, lan saloka tilaran Jawa';

  @override
  String get learnModuleProverbsLabel => '15 paribasan';

  @override
  String get learnTagAksara => 'Aksara';

  @override
  String get learnTagKamus => 'Kosa Tembung';

  @override
  String get learnTagUtilitas => 'Piranti';

  @override
  String get learnTagWicara => 'Wicara';

  @override
  String get learnTagSastra => 'Sastra';

  @override
  String get difficultyMudah => 'Gampang';

  @override
  String get difficultyMahir => 'Wasis';

  @override
  String get difficultySangatMahir => 'Linuwih';

  @override
  String get quizPathTitle => 'Dalan Kuis';

  @override
  String quizCompletedBadge(int count) {
    return '$count Rampung';
  }

  @override
  String get quizUnit1Title => 'Unit 1: Uluk Salam lan Tata Krama Awal';

  @override
  String get quizUnit1Subtitle => 'Dhasar pacelathon lan tata krama trapsila';

  @override
  String get quizUnit2Title =>
      'Unit 2: Aksara Jawa Dhasar (Nglegena) (Kakonci)';

  @override
  String get quizUnit2Subtitle => 'Nepangaken 20 aksara nglegena Hanacaraka';

  @override
  String get quizTopicSalam => 'Salam';

  @override
  String get quizTopicPamit => 'Pamit';

  @override
  String get quizTopicLencana => 'Lencana';

  @override
  String get quizTopicTanyaKabar => 'Nyuwun kabar';

  @override
  String get quizTopicPerkenalan => 'Tetepangan';

  @override
  String get quizTopicKeluarga => 'Kulawarga';

  @override
  String get quizTopicRumah => 'Omah';

  @override
  String get quizTopicKerabat => 'Sanak Kadang';

  @override
  String quizBottomSheetProgress(
    int quizIndex,
    int totalQuizzes,
    int questionCount,
  ) {
    return 'Kuis $quizIndex saking $totalQuizzes · $questionCount pitakenan';
  }

  @override
  String get quizBottomSheetStart => 'Miwiti Kuis';

  @override
  String get quizBottomSheetLater => 'Mangke rumiyin';

  @override
  String quizComboCount(int count) {
    return '$count Leres!';
  }

  @override
  String quizOptionSemantics(String letter, String option) {
    return 'Pilihan $letter: $option';
  }

  @override
  String get quizCorrect => 'Leres!';

  @override
  String get quizIncorrect => 'Kirang leres';

  @override
  String quizAnswerLabel(String answer) {
    return 'Wangsulan: $answer';
  }

  @override
  String get quizQuestionSourceAttribution =>
      'Materi JawaLoka (draf, dereng dipunverifikasi penutur Jawa)';

  @override
  String get quizCheck => 'Priksa';

  @override
  String get quizContinue => 'Lajeng';

  @override
  String get quizFinish => 'Rampung';

  @override
  String get quizResultAwesome => 'Luar Biasa!';

  @override
  String quizResultStreakBanner(int days) {
    return 'Streak kuis aktif: $days dina';
  }

  @override
  String get quizResultCorrectAnswers => 'Pitakenan Leres';

  @override
  String get quizResultTime => 'Wekdal';

  @override
  String get quizResultAccuracy => 'Katelitian';

  @override
  String get quizResultBackHome => 'Wangsul dhateng Beranda';

  @override
  String get quizResultRetry => 'Baleni kuis';

  @override
  String get drawingTitle => 'Gladhen Nulis';

  @override
  String get drawingBackSemantics => 'Wangsul';

  @override
  String get drawingInstruction => 'Serat aksara punika!';

  @override
  String drawingStrokeCount(int count) {
    return 'Coretan: $count';
  }

  @override
  String get drawingClearAll => 'Busek Kabeh';

  @override
  String get drawingUndo => 'Wurung';

  @override
  String get drawingCheckButton => 'Priksa Tulisan';

  @override
  String get dailyResultTitle => 'Asil Misi';

  @override
  String get dailyResultSimilarityLabel => 'Kamiripan';

  @override
  String dailyResultCelebrationPassed(String name) {
    return 'Saestu sae, $name!';
  }

  @override
  String get dailyResultCelebrationFailed => 'Sumangga Gladhen Malih!';

  @override
  String dailyResultDescPassed(int percent) {
    return 'Panjenengan sampun kasil nyerat aksara Jawa kanthi mirip langkung saking $percent%.';
  }

  @override
  String get dailyResultDescFailed =>
      'Coretan panjenengan meh leres. Cobi priksani ukuran aksara target.';

  @override
  String get dailyResultComparison => 'Pabandhingan Tulisan';

  @override
  String get dailyResultYourDrawing => 'Seratan panjenengan';

  @override
  String get dailyResultTargetScript => 'Aksara Target';

  @override
  String get dailyResultStatusPassed => 'Status: Lulus';

  @override
  String get dailyResultStatusFailed => 'Status: Dereng Lulus';

  @override
  String dailyResultRequirement(int percent, int threshold) {
    return 'Kemiripan $percent% (Syarat lulus: ≥ $threshold%)';
  }

  @override
  String get dailyResultContinueLearning => 'Nglajengaken Sinau →';

  @override
  String get dailyResultTryAgain => 'Cobi Malih';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSettingsSemantics => 'Setelan';

  @override
  String get profileNameEmptyError => 'Asma mboten pareng kosong';

  @override
  String profileNameSaved(String name) {
    return 'Asma kasil kasimpen: $name';
  }

  @override
  String get profileSaveName => 'Simpen';

  @override
  String get profileCancelEdit => 'Wurung';

  @override
  String profileLevelPill(int level) {
    return 'Lv $level';
  }

  @override
  String profileStreakPill(int days) {
    return 'Streak $days dina';
  }

  @override
  String profileQuizzesThisWeek(int count) {
    return '$count Kuis Minggu Iki';
  }

  @override
  String get profileBadgeTitle => 'Lencana';

  @override
  String get profileBadgeOpenCount => '1 / 4 Binuka';

  @override
  String get profileBadgeCollection => 'Koleksi Prestasi';

  @override
  String get profileBadgeStreak7Title => 'Streak 7 Dina';

  @override
  String get profileBadgeStreak30Title => 'Streak 30 Dina';

  @override
  String get profileBadgeLevel5Title => 'Level 5';

  @override
  String get profileBadgeLevelUpHighlight => 'Munggah Level';

  @override
  String get profileBadgeAksaraCompleteTitle => 'Tamat Aksara';

  @override
  String get profileBadgeEasyLevel => 'Tataran Gampang';

  @override
  String get profileBadgeUnlocked => 'Binuka';

  @override
  String get profileBadgeLocked => 'Kakonci';

  @override
  String get profileChooseBlangkonButton => 'Pilih Blangkon';

  @override
  String get blangkonTitle => 'Pilih Blangkon';

  @override
  String get blangkonSaveButton => 'Simpen Pilihan';

  @override
  String blangkonLevelRequired(int level) {
    return 'Level $level';
  }

  @override
  String get blangkonInitialUnlock => 'Kapasang wiwitan';

  @override
  String get blangkonMasteryAksara => 'Rampung aksara';

  @override
  String get blangkonDescYogyakarta => 'Klasik, mondolan bunder nonjol';

  @override
  String get blangkonDescSurakarta => 'Anggun, mondolan trepes gepeng';

  @override
  String get blangkonDescBanyumas => 'Tegas, corak mligi Banyumasan';

  @override
  String get blangkonDescKedu => 'Gaya Bagelen Kedu prasaja';

  @override
  String get blangkonDescCirebon => 'Pesisiran dinamis mrabawa';

  @override
  String get blangkonDescPusaka => 'Mahakarya tradisi kanthi ornamen emas';

  @override
  String get profileChooseBusanaButton => 'Pilih Busana';

  @override
  String get busanaTitle => 'Pilih Busana';

  @override
  String get busanaSaveButton => 'Simpen Pilihan';

  @override
  String get busanaDescYogyakarta =>
      'Alus, kebaya kutubaru khas Keraton Ngayogyakarta';

  @override
  String get busanaDescSurakarta =>
      'Endah, kebaya encim ngagem corak batik Solo';

  @override
  String get busanaDescBanyumas => 'Seger, kebaya sunda polos pesisiran';

  @override
  String get busanaDescKedu => 'Prasaja, kebaya gaya Kedu';

  @override
  String get busanaDescCirebon =>
      'Dinamis, kebaya corak mega mendung pesisir Cirebon';

  @override
  String get busanaDescPusaka => 'Mirunggan, kebaya betawi encim warni-warni';

  @override
  String get busanaNameYogyakarta => 'Kutubaru Ngayogyakarta';

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
  String get levelUpBlangkonUnlocked => 'Blangkon enggal binuka: ';

  @override
  String get levelUpBadgeCategory => 'LENCANA ENGGAL';

  @override
  String get levelUpAchievementTitle => 'Sinau Mandiri V';

  @override
  String get levelUpAchievementDesc => 'Ngrampungake 25 bab materi aksara';

  @override
  String get levelUpEquipButton => 'Agem Blangkon';

  @override
  String get levelUpSkipButton => 'Mangke rumiyin';

  @override
  String levelUpOtherRewardsCount(int count) {
    return ' (+$count blangkon sanese)';
  }

  @override
  String get levelUpNoRewardSubtitle =>
      'Sugeng! Kawruh lan seserepan sampeyan sansaya mundhak.';

  @override
  String get levelUpContinueButton => 'Lajengaken';

  @override
  String get settingsLogout => 'Miyos';

  @override
  String get settingsLogoutConfirm => 'Saestu badhe miyos?';

  @override
  String get settingsCancel => 'Wurung';

  @override
  String get settingsPrivacyPolicy => 'Kawicaksanan Privasi';

  @override
  String get settingsPrivacyPolicyContent =>
      'Aplikasi JawaLoka menyimpan nama tampilan, pilihan bahasa, koleksi blangkon, progres kuis, XP, dan Level secara lokal di perangkat Anda. Aplikasi ini tidak mengirim data ke server, tidak memiliki akun sungguhan (versi demo), dan tidak menyimpan kata sandi.';

  @override
  String get settingsClose => 'Tutup';

  @override
  String get settingsAccountRow => 'Akun';

  @override
  String get settingsAccountDialogTitle => 'Rerincen Akun';

  @override
  String get settingsAccountNameLabel => 'Asma Naraguna';

  @override
  String get settingsAccountLocalNote => 'Akun lokal wonten ing piranti menika';

  @override
  String get translatorTitle => 'Penerjemah';

  @override
  String get translatorInputLabel => 'LEBETAKEN TEKS';

  @override
  String get translatorInputHint => 'Serat teks...';

  @override
  String translatorBasicPhrasesHint(String examples) {
    return 'Contoh frasa dasar yang didukung: $examples.';
  }

  @override
  String get translatorButton => 'Jarwakake';

  @override
  String get translatorTranslating => 'Njarwakake...';

  @override
  String get translatorOutputLabel => 'ASILING JARWAN';

  @override
  String get translatorOutputPlaceholder =>
      'Asiling jarwan badhe katingal wonten mriki…';

  @override
  String get translatorCopiedToast => 'Teks sampun dipunkopi';

  @override
  String get translatorPickerTitle => 'Pilih Basa';

  @override
  String get translatorSwapSemantics => 'Lintu basa';

  @override
  String get translatorCopyTooltip => 'Kopi';

  @override
  String get translatorClearTooltip => 'Busek';

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
  String get aksaraDetailTag => 'Dhasar';

  @override
  String get aksaraDetailExampleHeader => 'Tuladha Tembung';

  @override
  String get aksaraDetailSandanganHeader => 'Sandangan';

  @override
  String get aksaraDetailSandanganSubtitle =>
      'Wernaning vokal wonten ing aksara ꦲ (Ha)';

  @override
  String get aksaraDetailWritingHeader => 'Carane Nulis';

  @override
  String get aksaraDetailStep1Title => 'Wiwiti saking tengen nginggil';

  @override
  String get aksaraDetailStep1Desc =>
      'Tarik garis mlengkung mandhap saking titik wiwitan ing tengen nginggil.';

  @override
  String get aksaraDetailStep2Title => 'Mlengkungaken awak aksara';

  @override
  String get aksaraDetailStep2Desc =>
      'Damel lengkungan wigati ingkang mbentuk awake aksara Ha mangiwa.';

  @override
  String get aksaraDetailStep3Title => 'Tutup kanthi buntut';

  @override
  String get aksaraDetailStep3Desc =>
      'Pungkasi kanthi garis buntut cendhak ingkang mlengkung mlebet.';

  @override
  String get aksaraDetailWritingButton => 'Gladhen Nulis';

  @override
  String get aksaraDetailQuizButton => 'Miwiti Kuis';

  @override
  String get vocabDetailTitle => 'Kosa Tembung';

  @override
  String get vocabDetailTag => 'Gampang';

  @override
  String get vocabDetailMeaningHeader => 'Teges & Tataran';

  @override
  String get vocabDetailExamplesHeader => 'Tuladha Ukara';

  @override
  String get vocabDetailNextButton => 'Tembung Sabanjure';

  @override
  String get profileBadgeStreak7Toast => 'Lencana Streak 7 Dina wis tinarbuka!';

  @override
  String get profileBadgeStreak30Toast =>
      'Tindakna streak 30 dina kanggo mbukak lencana iki!';

  @override
  String get profileBadgeLevel5Toast => 'Blangkon Surakarta kasil diagem!';

  @override
  String get profileBadgeAksaraToast =>
      'Rampungna kabeh modul aksara dhasar kanggo mbukak!';

  @override
  String blangkonToastInitial(String name) {
    return 'Tinarbuka saka wiwitan: $name';
  }

  @override
  String blangkonToastLevel(int level, String name) {
    return 'Mbutuhake Level $level kanggo mbukak $name';
  }

  @override
  String blangkonToastAksara(String name) {
    return 'Rampungna kabeh materi aksara kanggo mbukak $name';
  }

  @override
  String get vocabDetailFavoriteMark => 'Tandhani Favorit';

  @override
  String get vocabDetailFavoriteMarked => 'Ditandhani Favorit';

  @override
  String get quizMilestoneNode => 'Node Tonggak';

  @override
  String quizNodeLockedToast(String topic) {
    return 'Materi $topic isih kakunci. Rampungna materi sadurunge!';
  }

  @override
  String quizUnitTitle(int unit, String level) {
    return 'Unit $unit · Tataran $level';
  }

  @override
  String get quizTopicSalamDesc =>
      'Sinau salam lan aruh-aruh kanthi tata krama basa Jawa.';

  @override
  String get quizTopicPamitDesc =>
      'Tembung pamitan lan pisahan sabendina sing trapsila.';

  @override
  String get quizTopicLencanaDesc =>
      'Tes kawruh tonggak babagan sapaan lan salam.';

  @override
  String get quizTopicTanyaKabarDesc =>
      'Nyuwun kabar lan kahanane wong liya ing basa Jawa.';

  @override
  String get quizTopicPerkenalanDesc =>
      'Ngenalake dhiri pribadi nganggo unggah-ungguh sing bener.';

  @override
  String get quizTopicKeluargaDesc =>
      'Jeneng anggota kulawarga lan sanak kadhang cerak.';

  @override
  String get quizTopicRumahDesc =>
      'Perangan omah tradisional Jawa lan pirantiane.';

  @override
  String get quizTopicKerabatDesc =>
      'Tingkatan trah kulawarga ageng masyarakat Jawa.';

  @override
  String get quizQuestionPromptWhatGlyph => 'Aksara apa iki?';

  @override
  String get quizQuestionPromptPronunciation => 'Pilih pamacane aksara iki:';

  @override
  String quizQuestionPromptHowToRead(String glyph) {
    return 'Aksara \"$glyph\" diwaca apa?';
  }

  @override
  String get quizQuestionPromptWhichPronunciation =>
      'Endi pamacane aksara ing ngisor iki?';

  @override
  String get quizSkip => 'Liwati';

  @override
  String get quizCloseSemantics => 'Tutup';

  @override
  String get quizExitDialogTitle => 'Metu saka Kuis?';

  @override
  String get quizExitDialogMessage => 'Progres kuis iki ora bakal disimpen.';

  @override
  String get quizExitDialogConfirm => 'Metu';

  @override
  String get quizExitDialogCancel => 'Banjurake';

  @override
  String get learnUnggahSheetTitle => 'Panganggoning Basa';

  @override
  String get learnUnggahSheetSubtitle =>
      'Tingkatan ragam basa Jawa miturut trapsila lan unggah-ungguh.';

  @override
  String get learnUnggahNgokoLuguTitle => '1. Basa Ngoko Lugu';

  @override
  String get learnUnggahNgokoLuguDesc =>
      'Dipigunakake kanggo kanca sebaya, sedulur nom, utawa wong sing wis raket banget.';

  @override
  String get learnUnggahNgokoAlusTitle => '2. Basa Ngoko Alus';

  @override
  String get learnUnggahNgokoAlusDesc =>
      'Basa ngoko sing kacampuran tembung krama inggil kanggo ngurmati wong sing diajak guneman.';

  @override
  String get learnUnggahKramaLuguTitle => '3. Basa Krama Lugu / Madya';

  @override
  String get learnUnggahKramaLuguDesc =>
      'Basa krama sopan umum marang wong sing durung pati kenal utawa kanca kerja.';

  @override
  String get learnUnggahKramaInggilTitle => '4. Basa Krama Inggil / Alus';

  @override
  String get learnUnggahKramaInggilDesc =>
      'Tingkatan paling luhur, dipigunakake marang wong tuwa, guru, utawa pinisepuh.';

  @override
  String learnUnggahExamplePrefix(String example) {
    return 'Tuladha: \"$example\"';
  }

  @override
  String get learnPeribahasaSheetTitle => 'Paribasan & Saloka Jawa';

  @override
  String get learnPeribahasaSheetSubtitle =>
      'Pepatah lan bebasan luhur warisan leluhur kabudayan Jawa.';

  @override
  String get learnProverb1Meaning =>
      'Aji lan kurmate manungsa gumantung saka pocapan lan busanane.';

  @override
  String get learnProverb2Meaning =>
      'Urip iku becike migunani lan madhangi liyan ing sacedhake.';

  @override
  String get learnProverb3Meaning =>
      'Saben gegayuhan lan kamulyan mbutuhake pambudidaya, pangorbanan, lan ragad.';

  @override
  String get learnProverb4Meaning =>
      'Ngunggahake drajate wong tuwa lan kulawarga sarta nyimpen wewadi utawa cacat.';

  @override
  String get learnProverb5Meaning =>
      'Karukunan nuwuhake kasantosan lan kakuwatan, pasulayan ngendhangake karusakan.';

  @override
  String get learnDailyWordOmah => 'Griya';

  @override
  String get learnDailyWordBanyu => 'Toya';

  @override
  String get learnDailyWordSegara => 'Seganten';

  @override
  String get learnDailyWordLemah => 'Siti';

  @override
  String get learnDailyWordLangit => 'Awatara / Langit';

  @override
  String get vocabDetailLangId => 'Basa Indonesia';

  @override
  String get vocabDetailLangEn => 'Basa Inggris';

  @override
  String get vocabDetailLangJv => 'Basa Jawa (Ngoko)';

  @override
  String get vocabDetailSentence1Translation => 'Griyaku wonten ing dhusun';

  @override
  String get vocabDetailSentence2Translation => 'Griya menika ageng sanget';

  @override
  String get aksaraDetailExampleHaraMeaning => 'Pang';

  @override
  String get aksaraDetailExampleHawuMeaning => 'Pawon / Hawu';

  @override
  String get aksaraDetailExampleHasthaMeaning => 'Wolu';

  @override
  String get quizUnit3Title =>
      'Unit 3: Sandhangan lan Pasangan Aksara Jawa (Kakonci)';

  @override
  String get quizUnit3Subtitle =>
      'Vokalisasi, panyigeg wanda, lan pasangan aksara';

  @override
  String get quizUnit4Title =>
      'Unit 4: Kosa Tembung lan Undha-Usuk Basa (Kakonci)';

  @override
  String get quizUnit4Subtitle =>
      'Undha-usuk ngoko lugu, alus, krama lugu, lan krama inggil';

  @override
  String get quizUnit5Title =>
      'Unit 5: Budaya, Paribasan, lan Kawruh Luhur (Kakonci)';

  @override
  String get quizUnit5Subtitle =>
      'Paribasan, filosofi, adat tradisi, lan kawruh luhur Jawa';

  @override
  String get quizTopicSapaWong => 'Aruh-aruh marang Liyan';

  @override
  String get quizTopicSapaWongDesc =>
      'Tata krama nyapa lan aruh-aruh marang tiyang sanes.';

  @override
  String get quizTopicMaturNuwun => 'Matur Nuwun';

  @override
  String get quizTopicMaturNuwunDesc =>
      'Atur panuwun lan rasa syukur kanthi trapsila.';

  @override
  String get quizTopicNyuwunPangapunten => 'Nyuwun Pangapunten';

  @override
  String get quizTopicNyuwunPangapuntenDesc =>
      'Atur pangapunten lan ngakoni kaluputan kanthi andhap asor.';

  @override
  String get quizTopicPercakapanPadinan => 'Pacelathon Padinan';

  @override
  String get quizTopicPercakapanPadinanDesc =>
      'Gladhen pacelathon aruh-aruh ing kauripan padinan.';

  @override
  String get quizTopicEvaluasiUnit1 => 'Pambiji Unit 1';

  @override
  String get quizTopicEvaluasiUnit1Desc =>
      'Ujian pepak materi aruh-aruh lan unggah-ungguh awal.';

  @override
  String get quizTopicPengenalanHanacaraka => 'Pitepangan Hanacaraka';

  @override
  String get quizTopicPengenalanHanacarakaDesc =>
      'Tepang kalawan asal-usul lan filosofi 20 aksara Jawa.';

  @override
  String get quizTopicAksaraHanacaraka => 'Aksara Nglegena Ha Na Ca Ra Ka';

  @override
  String get quizTopicAksaraHanacarakaDesc =>
      'Wujud lan unine aksara Ha, Na, Ca, Ra, Ka.';

  @override
  String get quizTopicAksaraDatasawala => 'Aksara Nglegena Da Ta Sa Wa La';

  @override
  String get quizTopicAksaraDatasawalaDesc =>
      'Wujud lan unine aksara Da, Ta, Sa, Wa, La.';

  @override
  String get quizTopicAksaraPadhajayanya => 'Aksara Nglegena Pa Dha Ja Ya Nya';

  @override
  String get quizTopicAksaraPadhajayanyaDesc =>
      'Wujud lan unine aksara Pa, Dha, Ja, Ya, Nya.';

  @override
  String get quizTopicAksaraMagabathanga => 'Aksara Nglegena Ma Ga Ba Tha Nga';

  @override
  String get quizTopicAksaraMagabathangaDesc =>
      'Wujud lan unine aksara Ma, Ga, Ba, Tha, Nga.';

  @override
  String get quizTopicMacaAksaraDhasar => 'Maca Aksara Dhasar';

  @override
  String get quizTopicMacaAksaraDhasarDesc =>
      'Gladhen maca wandane tembung aksara nglegena.';

  @override
  String get quizTopicNyusunAksaraLegena => 'Ngrantam Aksara Nglegena';

  @override
  String get quizTopicNyusunAksaraLegenaDesc =>
      'Ngrantam aksara nglegena dados tembung ingkang mranani.';

  @override
  String get quizTopicNiteniWujudAksara => 'Niteni Wujuding Aksara';

  @override
  String get quizTopicNiteniWujudAksaraDesc =>
      'Mbedakaken wujuding aksara ingkang memper utawi sami.';

  @override
  String get quizTopicGladhenMacaLegena => 'Gladhen Maca Tembung Nglegena';

  @override
  String get quizTopicGladhenMacaLegenaDesc =>
      'Maca tembung rong wanda lan telung wanda tanpa sandhangan.';

  @override
  String get quizTopicEvaluasiUnit2 => 'Pambiji Unit 2';

  @override
  String get quizTopicEvaluasiUnit2Desc =>
      'Ujian pepak panguwasan 20 aksara nglegena Hanacaraka.';

  @override
  String get quizTopicSandhanganSwara => 'Sandhangan Swara Jawa';

  @override
  String get quizTopicSandhanganSwaraDesc =>
      'Ngangge wulu, suku, taling, pepet, lan taling tarung.';

  @override
  String get quizTopicSandhanganPanyigeg => 'Panyigeging Wanda';

  @override
  String get quizTopicSandhanganPanyigegDesc =>
      'Panyigeging wanda wignyan, layar, cecak, lan pangkon.';

  @override
  String get quizTopicSandhanganWyanjana => 'Sandhangan Wyanjana Jawa';

  @override
  String get quizTopicSandhanganWyanjanaDesc =>
      'Seselan wyanjana cakra, keret, lan pengkal ing aksara.';

  @override
  String get quizTopicPengenalanPasangan => 'Pitepangan Pasangan';

  @override
  String get quizTopicPengenalanPasanganDesc =>
      'Guna lan carane pasangan kanggo mateni swara vokal.';

  @override
  String get quizTopicPasanganSejajarGantung => 'Pasangan Jejer lan Gandhul';

  @override
  String get quizTopicPasanganSejajarGantungDesc =>
      'Mbedakaken pasangan ingkang jejer kalawan ingkang gandhul.';

  @override
  String get quizTopicMacaKataSandhangan => 'Maca Tembung Asandhangan';

  @override
  String get quizTopicMacaKataSandhanganDesc =>
      'Maca kosa tembung ingkang migunakaken sandhangan swara.';

  @override
  String get quizTopicNulisKataSederhana => 'Nulis Tembung Prasaja';

  @override
  String get quizTopicNulisKataSederhanaDesc =>
      'Ngrantam aksara asandhangan dados tembung ingkang bener.';

  @override
  String get quizTopicNiteniLuputNulis => 'Niteni Luputing Panulisan';

  @override
  String get quizTopicNiteniLuputNulisDesc =>
      'Manggihaken lan ndandosi luputing dununge sandhangan.';

  @override
  String get quizTopicGladhenKombinasi => 'Gladhen Kombinasi';

  @override
  String get quizTopicGladhenKombinasiDesc =>
      'Gladhen campur sandhangan swara, panyigeg, lan pasangan.';

  @override
  String get quizTopicEvaluasiUnit3 => 'Pambiji Unit 3';

  @override
  String get quizTopicEvaluasiUnit3Desc =>
      'Ujian pepak tata carane sandhangan lan pasangan aksara.';

  @override
  String get quizTopicKeluargaLanKerabat => 'Kulawarga lan Sanak';

  @override
  String get quizTopicKeluargaLanKerabatDesc =>
      'Sebutan trah kulawarga ing tataran ngoko lan krama.';

  @override
  String get quizTopicOmahLanSakiwatengene => 'Omah lan Lingkungan';

  @override
  String get quizTopicOmahLanSakiwatengeneDesc =>
      'Jeneng prabot, ruwangan omah, lan sakiwatengene.';

  @override
  String get quizTopicKagiyatanPadinan => 'Kagiyatan Padinan';

  @override
  String get quizTopicKagiyatanPadinanDesc =>
      'Tembung kriya lan pakaryan padinan ing undha-usuk basa.';

  @override
  String get quizTopicNgokoLugu => 'Basa Ngoko Lugu';

  @override
  String get quizTopicNgokoLuguDesc =>
      'Titikan lan trap-trapane ngoko lugu marang kanca raket.';

  @override
  String get quizTopicNgokoAlus => 'Basa Ngoko Alus';

  @override
  String get quizTopicNgokoAlusDesc =>
      'Campuran tembung krama inggil ing ukara ngoko kanggo ngurmati.';

  @override
  String get quizTopicKramaLugu => 'Basa Krama Lugu';

  @override
  String get quizTopicKramaLuguDesc =>
      'Basa krama formal sedheng tanpa ngunggahake dhiri pribadi.';

  @override
  String get quizTopicKramaInggil => 'Basa Krama Inggil';

  @override
  String get quizTopicKramaInggilDesc =>
      'Tataran basa paling luhur kanggo ngurmati sesepuh lan pinituwa.';

  @override
  String get quizTopicBandhinganTingkatBasa => 'Bandhingan Undha-Usuk Basa';

  @override
  String get quizTopicBandhinganTingkatBasaDesc =>
      'Mbandhingake tembung saemper ing ngoko, krama, lan krama inggil.';

  @override
  String get quizTopicWicaraUnggahUngguh => 'Pacelathon Unggah-Ungguh';

  @override
  String get quizTopicWicaraUnggahUngguhDesc =>
      'Ngetrapake undha-usuk basa ing pacelathon saben dinten.';

  @override
  String get quizTopicEvaluasiUnit4 => 'Pambiji Unit 4';

  @override
  String get quizTopicEvaluasiUnit4Desc =>
      'Ujian pepak kosa tembung lan panraping undha-usuk basa.';

  @override
  String get quizTopicAjiningDhiri => 'Ajining Dhiri ana ing Lathi';

  @override
  String get quizTopicAjiningDhiriDesc =>
      'Wulang wuruk njaga ajining dhiri lumantar wicara kang santun.';

  @override
  String get quizTopicUnggahUngguhBasa => 'Undha-Usuk Basa Jawa';

  @override
  String get quizTopicUnggahUngguhBasaDesc =>
      'Trapsila solah bawa lan tata wicara tiyang Jawa.';

  @override
  String get quizTopicParibasanJawa => 'Paribasan lan Saloka';

  @override
  String get quizTopicParibasanJawaDesc =>
      'Werdi luhur saking bebasan, paribasan, lan saloka Jawa.';

  @override
  String get quizTopicFilosofiUrip => 'Urip Iku Urup';

  @override
  String get quizTopicFilosofiUripDesc =>
      'Pituduh gesang paring paedah dhumateng sesami lan alam.';

  @override
  String get quizTopicTradisiPranatan => 'Adat lan Pranatan Jawa';

  @override
  String get quizTopicTradisiPranatanDesc =>
      'Upacara adat, pranataning gesang, lan tatacara tradisi Jawa.';

  @override
  String get quizTopicPewayanganPandhawa => 'Karakter Pandhawa Lima';

  @override
  String get quizTopicPewayanganPandhawaDesc =>
      'Watak utama paraga Pandhawa Lima lan piwulang kabecikan.';

  @override
  String get quizTopicTembangDolanan => 'Tembang Dolanan lan Piwulang';

  @override
  String get quizTopicTembangDolananDesc =>
      'Piwulang budi pekerti ing tembang dolanan lare Jawa.';

  @override
  String get quizTopicEtikaBudaya => 'Trap-trapan Etika Budaya';

  @override
  String get quizTopicEtikaBudayaDesc =>
      'Milih tindak-tanduk lan tembung sing trep ing bebrayan agung.';

  @override
  String get quizTopicKawruhLuhur => 'Piwulang Kawruh Luhur';

  @override
  String get quizTopicKawruhLuhurDesc =>
      'Ujian tataran inggil nggabungake aksara, basa, lan subasita.';

  @override
  String get quizTopicEvaluasiAkhir => 'Pambiji Pungkasan JawaLoka';

  @override
  String get quizTopicEvaluasiAkhirDesc =>
      'Ujian ageng pungkasan sedaya piwulang 50 node JawaLoka.';

  @override
  String get quizTopicUngkapanSopan => 'Ukara Sopan';

  @override
  String get quizTopicUngkapanSopanDesc =>
      'Tata krama trapsila awak, subasita, lan solah bawa ing adat Jawa.';

  @override
  String get quizTopicPenggunaanPasangan => 'Panganggoning Pasangan';

  @override
  String get quizTopicPenggunaanPasanganDesc =>
      'Paugeran lan gladhen nulis pasangan aksara ing tembung lan ukara.';

  @override
  String get quizTopicKosakataPadinan => 'Kosakata Padinan';

  @override
  String get quizTopicKosakataPadinanDesc =>
      'Tembung-tembung padinan lan paseduluran kulawarga Jawa.';

  @override
  String get quizTopicNamaBenda => 'Jeneng Barang';

  @override
  String get quizTopicNamaBendaDesc =>
      'Jeneng prabot omah, perangan omah Joglo, lan sakiwatengene.';

  @override
  String get quizTopicNamaKegiatan => 'Jeneng Kagiyatan';

  @override
  String get quizTopicNamaKegiatanDesc =>
      'Tembung kriya lan kagiyatan padinan ing basa Jawa.';

  @override
  String get quizTopicNgoko => 'Ngoko';

  @override
  String get quizTopicNgokoDesc =>
      'Panganggoning basa Ngoko marang kanca sebaya lan akrab.';

  @override
  String get quizTopicKrama => 'Krama';

  @override
  String get quizTopicKramaDesc =>
      'Tataran basa Krama alus kanggo kahanan pakurmatan lan resmi.';

  @override
  String get quizTopicPerbedaanTingkatanBahasa => 'Bedane Tingkatan Basa';

  @override
  String get quizTopicPerbedaanTingkatanBahasaDesc =>
      'Mbandhingake tembung ing tataran Ngoko, Krama, lan Krama Inggil.';

  @override
  String get quizTopicPercakapanTeman => 'Pacelathon karo Kanca';

  @override
  String get quizTopicPercakapanTemanDesc =>
      'Gladhen pacelathon akrab karo kanca nggunakake basa Ngoko kang trep.';

  @override
  String get quizTopicPercakapanDihormati => 'Pacelathon marang Wong Sepuh';

  @override
  String get quizTopicPercakapanDihormatiDesc =>
      'Pacelathon trapsila marang tiyang sepuh lan guru nganggo Krama Inggil.';

  @override
  String get quizTopicTataKramaJawa => 'Subasita Jawa';

  @override
  String get quizTopicTataKramaJawaDesc =>
      'Paugeran trapsila, ajining dhiri, lan bebuden luhur ing budaya Jawa.';

  @override
  String get quizTopicPeribahasaJawa => 'Paribasan Jawa';

  @override
  String get quizTopicPeribahasaJawaDesc =>
      'Piwulang urip lan kawruh luhur ing paribasan, bebasan, lan saloka Jawa.';

  @override
  String get quizTopicFilosofiKehidupan => 'Filosofi Gesang Jawa';

  @override
  String get quizTopicFilosofiKehidupanDesc =>
      'Piwulang filosofis: Urip Iku Urup lan Memayu Hayuning Bawana.';

  @override
  String get quizTopicTradisiJawa => 'Adat Tradisi Jawa';

  @override
  String get quizTopicTradisiJawaDesc =>
      'Upacara adat, pranatan gesang, lan tradisi luhur warisan Jawa.';

  @override
  String get quizTopicBudayaKesenian => 'Kabudayan lan Kesenian';

  @override
  String get quizTopicBudayaKesenianDesc =>
      'Kesenian wayang purwa, gamelan, lan kabudayan tradhisional Jawa.';

  @override
  String get quizTopicSituasiPadinan => 'Kahanan Urip Padinan';

  @override
  String get quizTopicSituasiPadinanDesc =>
      'Trap-trapane piwulang tembang dolanan lan budi pekerti ing urip padinan.';

  @override
  String get quizTopicTantanganBudaya => 'Tantangan Pamawas Budaya';

  @override
  String get quizTopicTantanganBudayaDesc =>
      'Gladhen jero bab tepa slira, subasita, lan paugeran kautaman Jawa.';

  @override
  String get quizTopicTantanganAkhir => 'Tantangan Pungkasan';

  @override
  String get quizTopicTantanganAkhirDesc =>
      'Tantangan puncak nggabungake aksara, undha-usuk basa, lan kawruh luhur.';
}
