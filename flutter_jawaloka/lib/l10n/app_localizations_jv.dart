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
  String get registerTitle => 'Gawe akunmu';

  @override
  String get registerSubtitle => 'Simpen kamajuan sinaumu ing ngendi wae';

  @override
  String get registerPasswordHint =>
      'Gunakake tembung sandi sing kuwat (min. 8 aksara)';

  @override
  String get registerButton => 'Ndhaptar';

  @override
  String get registerTermsPrefix =>
      'TODO(jv): Dengan mendaftar, kamu menyetujui ';

  @override
  String get registerPrivacyPolicy => 'TODO(jv): Kebijakan Privasi';

  @override
  String get registerAlreadyHaveAccount => 'Wis duwe akun? ';

  @override
  String get registerLoginLink => 'Mlebu';

  @override
  String get navHome => 'Beranda';

  @override
  String get navLearn => 'Sinau';

  @override
  String get navQuest => 'Quest';

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
  String get homeHeroQuestTarget => 'Target: ≥85% Presisi';

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
      'Hanacaraka — 20 aksara dhasar, sandhangan & pasangan';

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
  String get learnTagKamus => 'Bausastra';

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
  String get quizUnit1Title => 'Unit 1: Aruh-aruh lan Salam';

  @override
  String get quizUnit1Subtitle => 'Dhasar pirembagan lan tata krama trapsila';

  @override
  String get quizUnit2Title => 'Unit 2: Kulawarga lan Omah (Kakonci)';

  @override
  String get quizUnit2Subtitle =>
      'Trahing kulawarga, sanak kadang, lan wewengkon omah';

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
  String get dailyResultTitle => 'Asil Quest';

  @override
  String get dailyResultSimilarityLabel => 'Kamiripan';

  @override
  String dailyResultCelebrationPassed(String name) {
    return 'Saestu sae, $name!';
  }

  @override
  String get dailyResultCelebrationFailed => 'Sumangga Gladhen Malih!';

  @override
  String get dailyResultDescPassed =>
      'Panjenengan sampun kasil nyerat aksara Jawa kanthi mirip langkung saking 85%.';

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
  String dailyResultRequirement(int percent) {
    return 'Kemiripan $percent% (Syarat lulus: ≥ 85%)';
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
  String get settingsLogout => 'Miyos';

  @override
  String get settingsLogoutConfirm => 'Saestu badhe miyos?';

  @override
  String get settingsCancel => 'Wurung';

  @override
  String get settingsPrivacyPolicy => 'Kawicaksanan Privasi';

  @override
  String get settingsPrivacyPolicyContent =>
      'JawaLoka ngajeni privasi panjenengan. Sedaya kemajengan sinau, gladhen aksara, lan pilihan naraguna kasimpen kanthi lokal wonten ing piranti panjenengan.';

  @override
  String get settingsClose => 'Tutup';

  @override
  String get settingsAccountRow => 'Akun';

  @override
  String get translatorTitle => 'Penerjemah';

  @override
  String get translatorInputLabel => 'LEBETAKEN TEKS';

  @override
  String get translatorInputHint => 'Serat teks...';

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
}
