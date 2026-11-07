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

  @override
  String get splashAppName => 'JawaLoka';

  @override
  String get splashAppTagline => 'Learn Javanese language and script every day';

  @override
  String get splashLoadingLabel => 'Loading application...';

  @override
  String get authWelcomeBannerTitle => 'Welcome to JawaLoka';

  @override
  String get authWelcomeBannerSubtitle =>
      'Preserve the ancestral heritage of the archipelago';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCloseError => 'Dismiss error';

  @override
  String get authFullNameLabel => 'Full Name';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String get validationEmailInvalid => 'Invalid email format';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordEmpty => 'Password cannot be empty';

  @override
  String get loginTitle => 'Sign in to your account';

  @override
  String get loginSubtitle => 'Continue your learning progress anywhere';

  @override
  String get loginInvalidCredentialsError => 'Incorrect email or password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginOrWith => 'Or sign in with';

  @override
  String get loginGoogleButton => 'Continue with Google';

  @override
  String get loginDontHaveAccount => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Sign Up';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Save your learning progress anywhere';

  @override
  String get registerPasswordHint =>
      'Use a strong password (min. 8 characters)';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get registerTermsPrefix => 'By registering, you agree to the ';

  @override
  String get registerPrivacyPolicy => 'Privacy Policy';

  @override
  String get registerAlreadyHaveAccount => 'Have an account? ';

  @override
  String get registerLoginLink => 'Sign In';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navQuest => 'Quest';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeGreetingNight => 'Good night';

  @override
  String homeGreetingUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String homeLevelPill(int level) {
    return 'L$level';
  }

  @override
  String get homeWeeklyStripTitle => 'This Week\'s Quiz Activity';

  @override
  String homeWeeklyCompletedCount(int count) {
    return '$count quizzes completed';
  }

  @override
  String homeWeeklyStreakInfo(int count) {
    return 'Quiz streak active for $count days. Complete daily quizzes to maintain streak.';
  }

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get homeHeroQuestBadge => 'TODAY\'S QUEST';

  @override
  String get homeHeroQuestTarget => 'Target: ≥85% Precision';

  @override
  String get homeHeroQuestTitle => 'Aksara \"Ha\" (ꦲ)';

  @override
  String get homeHeroQuestDesc =>
      'Write the first basic Hanacaraka character with accurate strokes.';

  @override
  String get homeHeroQuestButton => 'Start Drawing';

  @override
  String get homeContinueQuizTitle => 'Continue Quiz';

  @override
  String get homeContinueQuizLevel => 'Level: Intermediate';

  @override
  String get homeContinueQuizNode => 'Node 4: Script Ra (ꦫ)';

  @override
  String homeContinueQuizProgress(int completed) {
    return '$completed of 10 quiz chapters completed';
  }

  @override
  String get homeContinueQuizButton => 'Open Quiz Path';

  @override
  String get homeQuickLearnTitle => 'Quick Learn';

  @override
  String get homeQuickLearnSubtitle => 'Short Topics';

  @override
  String get homeQuickLearnVocab => 'Vocabulary';

  @override
  String get homeQuickLearnVocabSub => '3 Levels';

  @override
  String get homeQuickLearnAksara => 'Javanese Script';

  @override
  String get homeQuickLearnAksaraSub => 'Hanacaraka';

  @override
  String get homeQuickLearnTranslator => 'Translator';

  @override
  String get homeQuickLearnTranslatorSub => 'Ngoko-Krama';

  @override
  String get homeQuickLearnEtiquette => 'Language Etiquette';

  @override
  String get homeQuickLearnEtiquetteSub => 'Politeness';

  @override
  String get homeQuickLearnProverbs => 'Proverbs';

  @override
  String get homeQuickLearnProverbsSub => 'Idioms';

  @override
  String get learnHeaderTitle => 'Learning Hub';

  @override
  String get learnHeaderSubtitle =>
      'Explore Javanese cultural heritage and language';

  @override
  String get learnSectionModules => 'Learning Modules';

  @override
  String get learnSectionDailyWord => 'Word of the Day';

  @override
  String get moduleCardLocked => 'Locked';

  @override
  String get learnModuleAksaraTitle => 'Basic Javanese Script';

  @override
  String get learnModuleAksaraSubtitle =>
      'Hanacaraka — 20 basic scripts, diacritics & pairs';

  @override
  String get learnModuleAksaraLabel => '20 characters completed';

  @override
  String get learnModuleVocabTitle => 'Vocabulary (Dictionary)';

  @override
  String get learnModuleVocabSubtitle =>
      '3-speech level dictionary: Ngoko, Krama Madya, Krama Inggil';

  @override
  String get learnModuleVocabLabel => '120 words completed';

  @override
  String get learnModuleTranslatorTitle => 'Language Translator';

  @override
  String get learnModuleTranslatorSubtitle =>
      'Two-way translation for Indonesian, Ngoko, and Krama';

  @override
  String get learnModuleTranslatorLabel => 'Ready to Use';

  @override
  String get learnModuleEtiquetteTitle => 'Language Etiquette';

  @override
  String get learnModuleEtiquetteSubtitle =>
      'Etiquette and speech levels for speaking';

  @override
  String get learnModuleEtiquetteLabel => '4 speech levels';

  @override
  String get learnModuleProverbsTitle => 'Proverbs & Idioms';

  @override
  String get learnModuleProverbsSubtitle =>
      'Traditional Javanese proverbs, maxims, and idioms';

  @override
  String get learnModuleProverbsLabel => '15 proverbs';

  @override
  String get learnTagAksara => 'Script';

  @override
  String get learnTagKamus => 'Dictionary';

  @override
  String get learnTagUtilitas => 'Utility';

  @override
  String get learnTagWicara => 'Speech';

  @override
  String get learnTagSastra => 'Literature';

  @override
  String get difficultyMudah => 'Easy';

  @override
  String get difficultyMahir => 'Intermediate';

  @override
  String get difficultySangatMahir => 'Advanced';

  @override
  String get quizPathTitle => 'Quiz Path';

  @override
  String quizCompletedBadge(int count) {
    return '$count Completed';
  }

  @override
  String get quizUnit1Title => 'Unit 1: Greetings and Salutations';

  @override
  String get quizUnit1Subtitle => 'Conversation basics and polite etiquette';

  @override
  String get quizUnit2Title => 'Unit 2: Family and Home (Locked)';

  @override
  String get quizUnit2Subtitle =>
      'Family lineage, relatives, and household environment';

  @override
  String get quizTopicSalam => 'Greeting';

  @override
  String get quizTopicPamit => 'Farewell';

  @override
  String get quizTopicLencana => 'Badge';

  @override
  String get quizTopicTanyaKabar => 'Ask news';

  @override
  String get quizTopicPerkenalan => 'Introduction';

  @override
  String get quizTopicKeluarga => 'Family';

  @override
  String get quizTopicRumah => 'House';

  @override
  String get quizTopicKerabat => 'Relatives';

  @override
  String quizBottomSheetProgress(
    int quizIndex,
    int totalQuizzes,
    int questionCount,
  ) {
    return 'Quiz $quizIndex of $totalQuizzes · $questionCount questions';
  }

  @override
  String get quizBottomSheetStart => 'Start Quiz';

  @override
  String get quizBottomSheetLater => 'Maybe later';

  @override
  String quizComboCount(int count) {
    return '$count Correct!';
  }

  @override
  String quizOptionSemantics(String letter, String option) {
    return 'Option $letter: $option';
  }

  @override
  String get quizCorrect => 'Correct!';

  @override
  String get quizIncorrect => 'Incorrect';

  @override
  String quizAnswerLabel(String answer) {
    return 'Answer: $answer';
  }

  @override
  String get quizCheck => 'Check';

  @override
  String get quizContinue => 'Next';

  @override
  String get quizFinish => 'Finish';

  @override
  String get quizResultAwesome => 'Awesome!';

  @override
  String quizResultStreakBanner(int days) {
    return 'Active quiz streak: $days days';
  }

  @override
  String get quizResultCorrectAnswers => 'Correct Answers';

  @override
  String get quizResultTime => 'Time';

  @override
  String get quizResultAccuracy => 'Accuracy';

  @override
  String get quizResultBackHome => 'Back to Home';

  @override
  String get quizResultRetry => 'Retry quiz';

  @override
  String get drawingTitle => 'Writing Practice';

  @override
  String get drawingBackSemantics => 'Back';

  @override
  String get drawingInstruction => 'Write this script!';

  @override
  String drawingStrokeCount(int count) {
    return 'Strokes: $count';
  }

  @override
  String get drawingClearAll => 'Clear All';

  @override
  String get drawingUndo => 'Undo';

  @override
  String get drawingCheckButton => 'Check Writing';

  @override
  String get dailyResultTitle => 'Quest Result';

  @override
  String get dailyResultSimilarityLabel => 'Similarity';

  @override
  String dailyResultCelebrationPassed(String name) {
    return 'Great job, $name!';
  }

  @override
  String get dailyResultCelebrationFailed => 'Let\'s Practice Again!';

  @override
  String get dailyResultDescPassed =>
      'You successfully wrote the Javanese script with over 85% accuracy.';

  @override
  String get dailyResultDescFailed =>
      'Your stroke is close. Check the proportions of the target character.';

  @override
  String get dailyResultComparison => 'Writing Comparison';

  @override
  String get dailyResultYourDrawing => 'Your Writing';

  @override
  String get dailyResultTargetScript => 'Target Script';

  @override
  String get dailyResultStatusPassed => 'Status: Passed';

  @override
  String get dailyResultStatusFailed => 'Status: Not Passed';

  @override
  String dailyResultRequirement(int percent) {
    return 'Accuracy $percent% (Passing requirement: ≥ 85%)';
  }

  @override
  String get dailyResultContinueLearning => 'Continue Learning →';

  @override
  String get dailyResultTryAgain => 'Try Again';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSettingsSemantics => 'Settings';

  @override
  String get profileNameEmptyError => 'Name cannot be empty';

  @override
  String profileNameSaved(String name) {
    return 'Name saved: $name';
  }

  @override
  String get profileSaveName => 'Save';

  @override
  String get profileCancelEdit => 'Cancel';

  @override
  String profileLevelPill(int level) {
    return 'Lv $level';
  }

  @override
  String profileStreakPill(int days) {
    return 'Streak $days days';
  }

  @override
  String profileQuizzesThisWeek(int count) {
    return '$count Quizzes This Week';
  }

  @override
  String get profileBadgeTitle => 'Badges';

  @override
  String get profileBadgeOpenCount => '1 / 4 Unlocked';

  @override
  String get profileBadgeCollection => 'Achievement Collection';

  @override
  String get profileBadgeStreak7Title => '7-Day Streak';

  @override
  String get profileBadgeStreak30Title => '30-Day Streak';

  @override
  String get profileBadgeLevel5Title => 'Level 5';

  @override
  String get profileBadgeLevelUpHighlight => 'Level Up';

  @override
  String get profileBadgeAksaraCompleteTitle => 'Master of Script';

  @override
  String get profileBadgeEasyLevel => 'Easy Level';

  @override
  String get profileBadgeUnlocked => 'Unlocked';

  @override
  String get profileBadgeLocked => 'Locked';

  @override
  String get profileChooseBlangkonButton => 'Choose Blangkon';

  @override
  String get blangkonTitle => 'Choose Blangkon';

  @override
  String get blangkonSaveButton => 'Save Selection';

  @override
  String blangkonLevelRequired(int level) {
    return 'Level $level';
  }

  @override
  String get blangkonInitialUnlock => 'Default unlocked';

  @override
  String get blangkonMasteryAksara => 'Script completed';

  @override
  String get levelUpMicroTag => 'JAWALOKA ACHIEVEMENT';

  @override
  String levelUpTitle(int level) {
    return 'Level $level!';
  }

  @override
  String get levelUpBlangkonUnlocked => 'New blangkon unlocked: ';

  @override
  String get levelUpBadgeCategory => 'NEW BADGE';

  @override
  String get levelUpAchievementTitle => 'Sinau Mandiri V';

  @override
  String get levelUpAchievementDesc => 'Completed 25 script chapters';

  @override
  String get levelUpEquipButton => 'Wear Blangkon';

  @override
  String get levelUpSkipButton => 'Maybe later';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicyContent =>
      'JawaLoka respects your privacy. All learning progress, script practice, and user preferences are stored locally on your device.';

  @override
  String get settingsClose => 'Close';

  @override
  String get settingsAccountRow => 'Account';

  @override
  String get translatorTitle => 'Translator';

  @override
  String get translatorInputLabel => 'ENTER TEXT';

  @override
  String get translatorInputHint => 'Type text...';

  @override
  String get translatorButton => 'Translate';

  @override
  String get translatorTranslating => 'Translating...';

  @override
  String get translatorOutputLabel => 'TRANSLATION RESULT';

  @override
  String get translatorOutputPlaceholder => 'Translation will appear here…';

  @override
  String get translatorCopiedToast => 'Text copied';

  @override
  String get translatorPickerTitle => 'Select Language';

  @override
  String get translatorSwapSemantics => 'Swap languages';

  @override
  String get translatorCopyTooltip => 'Copy';

  @override
  String get translatorClearTooltip => 'Clear';

  @override
  String get aksaraDetailTitle => 'Javanese Script';

  @override
  String get aksaraDetailTag => 'Basic';

  @override
  String get aksaraDetailExampleHeader => 'Example Words';

  @override
  String get aksaraDetailSandanganHeader => 'Diacritics';

  @override
  String get aksaraDetailSandanganSubtitle =>
      'Vowel variations on the ꦲ (Ha) script';

  @override
  String get aksaraDetailWritingHeader => 'How to Write';

  @override
  String get aksaraDetailStep1Title => 'Start from top right';

  @override
  String get aksaraDetailStep1Desc =>
      'Draw a curved line downwards from the starting point on the top right.';

  @override
  String get aksaraDetailStep2Title => 'Curve the body of script';

  @override
  String get aksaraDetailStep2Desc =>
      'Create the main curve forming the body of the script Ha to the left.';

  @override
  String get aksaraDetailStep3Title => 'Finish with tail';

  @override
  String get aksaraDetailStep3Desc =>
      'End with a short tail line curving inward.';

  @override
  String get aksaraDetailWritingButton => 'Writing Practice';

  @override
  String get aksaraDetailQuizButton => 'Start Quiz';

  @override
  String get vocabDetailTitle => 'Vocabulary';

  @override
  String get vocabDetailTag => 'Easy';

  @override
  String get vocabDetailMeaningHeader => 'Meaning & Levels';

  @override
  String get vocabDetailExamplesHeader => 'Example Sentences';

  @override
  String get vocabDetailNextButton => 'Next Word';

  @override
  String get profileBadgeStreak7Toast => '7-Day Streak badge is unlocked!';

  @override
  String get profileBadgeStreak30Toast =>
      'Maintain a 30-day streak to unlock this badge!';

  @override
  String get profileBadgeLevel5Toast =>
      'Surakarta Blangkon equipped successfully!';

  @override
  String get profileBadgeAksaraToast =>
      'Complete all basic script modules to unlock!';

  @override
  String blangkonToastInitial(String name) {
    return 'Unlocked from the start: $name';
  }

  @override
  String blangkonToastLevel(int level, String name) {
    return 'Requires Level $level to unlock $name';
  }

  @override
  String blangkonToastAksara(String name) {
    return 'Complete all script lessons to unlock $name';
  }

  @override
  String get vocabDetailFavoriteMark => 'Mark as Favorite';

  @override
  String get vocabDetailFavoriteMarked => 'Favorited';
}
