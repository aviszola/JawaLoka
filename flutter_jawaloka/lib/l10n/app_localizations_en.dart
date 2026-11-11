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
  String get validationNameTooShort => 'Name must be at least 2 characters';

  @override
  String get validationNameTooLong => 'Name cannot exceed 30 characters';

  @override
  String get validationNameInvalidChars =>
      'Name can only contain letters, hyphens, and spaces';

  @override
  String get validationEmailEmpty => 'Email cannot be empty';

  @override
  String get validationEmailTooLong => 'Email cannot exceed 254 characters';

  @override
  String get validationPasswordTooLong =>
      'Password cannot exceed 64 characters';

  @override
  String get validationPasswordWhitespaceOnly =>
      'Password cannot contain only spaces';

  @override
  String get validationTranslationEmpty => 'Translation text cannot be empty';

  @override
  String get validationTranslationTooLong =>
      'Translation text cannot exceed 200 characters';

  @override
  String get validationDrawingEmpty => 'Please draw the character first';

  @override
  String get validationDrawingTooShort =>
      'Stroke is too short, please complete the character';

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
  String get loginQuestionLevelTitle => 'Javanese Proficiency Level';

  @override
  String get loginLevelBeginner => 'Beginner (New Learner)';

  @override
  String get loginLevelIntermediate => 'Intermediate (Basic Words)';

  @override
  String get loginLevelAdvanced => 'Advanced (Fluent Nuances)';

  @override
  String get loginQuestionGoalTitle => 'Primary Learning Goal';

  @override
  String get loginGoalAksara => 'Writing & Reading Script';

  @override
  String get loginGoalConversation => 'Daily Conversation';

  @override
  String get loginGoalCulture => 'Arts & Traditional Culture';

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
  String get authContinueAsGuest => 'Continue as Guest';

  @override
  String get authSkipToLearn => 'Skip & Start Learning';

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
  String homeHeroQuestTarget(int percent) {
    return 'Target: ≥$percent% Precision';
  }

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
      'Hanacaraka: 20 basic scripts, diacritics & pairs';

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
  String get learnModuleEtiquetteTitle => 'Language Usage';

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
  String get learnTagKamus => 'Vocabulary';

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
  String get quizUnit1Title => 'Unit 1: Greetings and Initial Etiquette';

  @override
  String get quizUnit1Subtitle =>
      'Fundamentals of conversation and courteous manners';

  @override
  String get quizUnit2Title =>
      'Unit 2: Basic Javanese Script (Legena) (Locked)';

  @override
  String get quizUnit2Subtitle =>
      'Introduction to the 20 basic Hanacaraka characters';

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
  String get quizQuestionSourceAttribution =>
      'JawaLoka Material (draft, unverified by native Javanese speakers)';

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
  String dailyResultDescPassed(int percent) {
    return 'You successfully wrote the Javanese script with over $percent% accuracy.';
  }

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
  String dailyResultRequirement(int percent, int threshold) {
    return 'Accuracy $percent% (Passing requirement: ≥ $threshold%)';
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
  String get blangkonDescYogyakarta => 'Classic, pronounced rounded mondolan';

  @override
  String get blangkonDescSurakarta => 'Elegant, flat mondolan';

  @override
  String get blangkonDescBanyumas => 'Bold, distinctive Banyumasan pattern';

  @override
  String get blangkonDescKedu => 'Simple Bagelen Kedu style';

  @override
  String get blangkonDescCirebon => 'Dynamic coastal style with authority';

  @override
  String get blangkonDescPusaka =>
      'Traditional masterpiece with gold ornamentation';

  @override
  String get profileChooseBusanaButton => 'Choose Outfit';

  @override
  String get busanaTitle => 'Choose Outfit';

  @override
  String get busanaSaveButton => 'Save Selection';

  @override
  String get busanaDescYogyakarta =>
      'Elegant Kutubaru kebaya, Yogyakarta royal style';

  @override
  String get busanaDescSurakarta =>
      'Graceful Solo kebaya with batik ornamentation';

  @override
  String get busanaDescBanyumas =>
      'Fresh Sundanese plain kebaya with coastal flair';

  @override
  String get busanaDescKedu => 'Simple Kedu-style kebaya';

  @override
  String get busanaDescCirebon =>
      'Dynamic Cirebon Mega Mendung patterned kebaya';

  @override
  String get busanaDescPusaka =>
      'Special Betawi Encim kebaya, vibrant and ornate';

  @override
  String get busanaNameYogyakarta => 'Kutubaru Yogyakarta';

  @override
  String get busanaNameSurakarta => 'Solo Kebaya';

  @override
  String get busanaNameBanyumas => 'Sundanese Kebaya';

  @override
  String get busanaNameKedu => 'Kedu Kebaya';

  @override
  String get busanaNameCirebon => 'Mega Mendung Cirebon';

  @override
  String get busanaNamePusaka => 'Betawi Encim';

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
  String levelUpOtherRewardsCount(int count) {
    return ' (+$count other blangkon)';
  }

  @override
  String get levelUpNoRewardSubtitle =>
      'Congratulations! Your mastery and proficiency continue to grow.';

  @override
  String get levelUpContinueButton => 'Continue';

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
      'JawaLoka stores your display name, language preference, blangkon collection, quiz progress, XP, and Level locally on your device. This demo app does not transmit data to any server, does not maintain real accounts, and does not store passwords.';

  @override
  String get settingsClose => 'Close';

  @override
  String get settingsAccountRow => 'Account';

  @override
  String get settingsAccountDialogTitle => 'Account Details';

  @override
  String get settingsAccountNameLabel => 'Username';

  @override
  String get settingsAccountLocalNote => 'Local account on this device';

  @override
  String get translatorTitle => 'Translator';

  @override
  String get translatorInputLabel => 'ENTER TEXT';

  @override
  String get translatorInputHint => 'Type text...';

  @override
  String translatorBasicPhrasesHint(String examples) {
    return 'Supported basic sample phrases: $examples.';
  }

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
  String get translatorMockUnavailable => 'Not available in demo version';

  @override
  String get translatorLangJvNgoko => 'Jawa Ngoko';

  @override
  String get translatorLangJvKrama => 'Jawa Krama';

  @override
  String get translatorLangId => 'Indonesia';

  @override
  String get translatorLangEn => 'English';

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

  @override
  String get quizMilestoneNode => 'Milestone Node';

  @override
  String quizNodeLockedToast(String topic) {
    return '$topic is still locked. Complete previous topics first!';
  }

  @override
  String quizUnitTitle(int unit, String level) {
    return 'Unit $unit · $level Level';
  }

  @override
  String get quizTopicSalamDesc =>
      'Learn polite Javanese greetings and etiquette.';

  @override
  String get quizTopicPamitDesc =>
      'Polite everyday farewells and parting expressions.';

  @override
  String get quizTopicLencanaDesc =>
      'Milestone test for greetings and etiquette.';

  @override
  String get quizTopicTanyaKabarDesc =>
      'Asking how someone is doing in Javanese.';

  @override
  String get quizTopicPerkenalanDesc =>
      'Introducing yourself with proper etiquette.';

  @override
  String get quizTopicKeluargaDesc =>
      'Family members and close relatives in Javanese.';

  @override
  String get quizTopicRumahDesc =>
      'Traditional Javanese house parts and furnishings.';

  @override
  String get quizTopicKerabatDesc =>
      'Genealogy and extended family terms in Javanese culture.';

  @override
  String get quizQuestionPromptWhatGlyph => 'What character is this?';

  @override
  String get quizQuestionPromptPronunciation =>
      'Choose the pronunciation for this character:';

  @override
  String quizQuestionPromptHowToRead(String glyph) {
    return 'How is character \"$glyph\" read?';
  }

  @override
  String get quizQuestionPromptWhichPronunciation =>
      'Which is the pronunciation for the character below?';

  @override
  String get quizSkip => 'Skip';

  @override
  String get quizCloseSemantics => 'Close';

  @override
  String get quizExitDialogTitle => 'Exit Quiz?';

  @override
  String get quizExitDialogMessage =>
      'Current quiz progress will not be saved.';

  @override
  String get quizExitDialogConfirm => 'Exit';

  @override
  String get quizExitDialogCancel => 'Continue';

  @override
  String get learnUnggahSheetTitle => 'Language Usage';

  @override
  String get learnUnggahSheetSubtitle =>
      'Levels of Javanese speech according to etiquette and politeness.';

  @override
  String get learnUnggahNgokoLuguTitle => '1. Ngoko Lugu';

  @override
  String get learnUnggahNgokoLuguDesc =>
      'Used for peers, younger siblings, or people who are very close.';

  @override
  String get learnUnggahNgokoAlusTitle => '2. Ngoko Alus';

  @override
  String get learnUnggahNgokoAlusDesc =>
      'Ngoko speech mixed with krama inggil words to show respect to the listener.';

  @override
  String get learnUnggahKramaLuguTitle => '3. Krama Lugu / Madya';

  @override
  String get learnUnggahKramaLuguDesc =>
      'Polite formal speech for people who are not yet well acquainted or coworkers.';

  @override
  String get learnUnggahKramaInggilTitle => '4. Krama Inggil / Alus';

  @override
  String get learnUnggahKramaInggilDesc =>
      'The highest level of politeness, used when addressing parents, teachers, or elders.';

  @override
  String learnUnggahExamplePrefix(String example) {
    return 'Example: \"$example\"';
  }

  @override
  String get learnPeribahasaSheetTitle => 'Javanese Proverbs & Idioms';

  @override
  String get learnPeribahasaSheetSubtitle =>
      'Wise proverbs and sayings inherited from Javanese ancestral culture.';

  @override
  String get learnProverb1Meaning =>
      'A person\'s honor lies in their words, and physical dignity in their attire.';

  @override
  String get learnProverb2Meaning =>
      'Life should be beneficial and illuminate the lives of those around us.';

  @override
  String get learnProverb3Meaning =>
      'Every ambition and success requires effort, sacrifice, and cost.';

  @override
  String get learnProverb4Meaning =>
      'Upholding the honor of parents and family while keeping flaws private.';

  @override
  String get learnProverb5Meaning =>
      'Unity brings strength and peace, division leads to ruin.';

  @override
  String get learnDailyWordOmah => 'House';

  @override
  String get learnDailyWordBanyu => 'Water';

  @override
  String get learnDailyWordSegara => 'Sea';

  @override
  String get learnDailyWordLemah => 'Earth / Ground';

  @override
  String get learnDailyWordLangit => 'Sky';

  @override
  String get vocabDetailLangId => 'Indonesian';

  @override
  String get vocabDetailLangEn => 'English';

  @override
  String get vocabDetailLangJv => 'Javanese (Ngoko)';

  @override
  String get vocabDetailSentence1Translation => 'My house is in the village';

  @override
  String get vocabDetailSentence2Translation => 'This house is very big';

  @override
  String get aksaraDetailExampleHaraMeaning => 'Branch';

  @override
  String get aksaraDetailExampleHawuMeaning => 'Stove';

  @override
  String get aksaraDetailExampleHasthaMeaning => 'Eight';

  @override
  String get quizUnit3Title =>
      'Unit 3: Javanese Diacritics and Subjoined Letters (Locked)';

  @override
  String get quizUnit3Subtitle =>
      'Vocalizations, syllable finals, and subjoined letter pairs';

  @override
  String get quizUnit4Title => 'Unit 4: Vocabulary and Speech Levels (Locked)';

  @override
  String get quizUnit4Subtitle =>
      'Speech levels of ngoko, krama lugu, and krama inggil';

  @override
  String get quizUnit5Title =>
      'Unit 5: Culture, Proverbs, and Philosophical Wisdom (Locked)';

  @override
  String get quizUnit5Subtitle =>
      'Javanese proverbs, philosophy, shadow puppets, and wisdom';

  @override
  String get quizTopicSapaWong => 'Greeting Others';

  @override
  String get quizTopicSapaWongDesc =>
      'Etiquette of greeting and addressing people you meet.';

  @override
  String get quizTopicMaturNuwun => 'Gratitude';

  @override
  String get quizTopicMaturNuwunDesc =>
      'Polite expressions of gratitude and appreciation.';

  @override
  String get quizTopicNyuwunPangapunten => 'Apologizing';

  @override
  String get quizTopicNyuwunPangapuntenDesc =>
      'Humble expressions for apologizing and admitting mistakes.';

  @override
  String get quizTopicPercakapanPadinan => 'Daily Conversation';

  @override
  String get quizTopicPercakapanPadinanDesc =>
      'Practice daily conversational greetings and courtesy.';

  @override
  String get quizTopicEvaluasiUnit1 => 'Unit 1 Evaluation';

  @override
  String get quizTopicEvaluasiUnit1Desc =>
      'Comprehensive test on greetings and initial etiquette.';

  @override
  String get quizTopicPengenalanHanacaraka => 'Introduction to Hanacaraka';

  @override
  String get quizTopicPengenalanHanacarakaDesc =>
      'Learn the origin and philosophy of the 20 Javanese characters.';

  @override
  String get quizTopicAksaraHanacaraka => 'Characters Ha Na Ca Ra Ka';

  @override
  String get quizTopicAksaraHanacarakaDesc =>
      'Shapes and phonetics of characters Ha, Na, Ca, Ra, Ka.';

  @override
  String get quizTopicAksaraDatasawala => 'Characters Da Ta Sa Wa La';

  @override
  String get quizTopicAksaraDatasawalaDesc =>
      'Shapes and phonetics of characters Da, Ta, Sa, Wa, La.';

  @override
  String get quizTopicAksaraPadhajayanya => 'Characters Pa Dha Ja Ya Nya';

  @override
  String get quizTopicAksaraPadhajayanyaDesc =>
      'Shapes and phonetics of characters Pa, Dha, Ja, Ya, Nya.';

  @override
  String get quizTopicAksaraMagabathanga => 'Characters Ma Ga Ba Tha Nga';

  @override
  String get quizTopicAksaraMagabathangaDesc =>
      'Shapes and phonetics of characters Ma, Ga, Ba, Tha, Nga.';

  @override
  String get quizTopicMacaAksaraDhasar => 'Reading Basic Script';

  @override
  String get quizTopicMacaAksaraDhasarDesc =>
      'Practice reading basic open-syllable legena words.';

  @override
  String get quizTopicNyusunAksaraLegena => 'Assembling Legena Script';

  @override
  String get quizTopicNyusunAksaraLegenaDesc =>
      'Assemble legena characters into meaningful words.';

  @override
  String get quizTopicNiteniWujudAksara => 'Recognizing Script Shapes';

  @override
  String get quizTopicNiteniWujudAksaraDesc =>
      'Distinguish between similarly shaped legena characters.';

  @override
  String get quizTopicGladhenMacaLegena => 'Legena Word Reading Drill';

  @override
  String get quizTopicGladhenMacaLegenaDesc =>
      'Read two- and three-syllable unvocalized legena words.';

  @override
  String get quizTopicEvaluasiUnit2 => 'Unit 2 Evaluation';

  @override
  String get quizTopicEvaluasiUnit2Desc =>
      'Comprehensive test on all 20 basic Hanacaraka characters.';

  @override
  String get quizTopicSandhanganSwara => 'Vowel Diacritics';

  @override
  String get quizTopicSandhanganSwaraDesc =>
      'Modify vowels using wulu, suku, taling, pepet, and taling tarung.';

  @override
  String get quizTopicSandhanganPanyigeg => 'Syllable Final Diacritics';

  @override
  String get quizTopicSandhanganPanyigegDesc =>
      'Syllable-closing diacritics: wignyan, layar, cecak, and pangkon.';

  @override
  String get quizTopicSandhanganWyanjana => 'Semivowel Diacritics';

  @override
  String get quizTopicSandhanganWyanjanaDesc =>
      'Medial semivowels: cakra, keret, and pengkal.';

  @override
  String get quizTopicPengenalanPasangan => 'Introduction to Pairs';

  @override
  String get quizTopicPengenalanPasanganDesc =>
      'Functions and rules of subjoined pairs to mute vowels.';

  @override
  String get quizTopicPasanganSejajarGantung => 'Aligned & Subjoined Pairs';

  @override
  String get quizTopicPasanganSejajarGantungDesc =>
      'Distinguish between aligned and hanging subjoined letters.';

  @override
  String get quizTopicMacaKataSandhangan => 'Reading Diacritic Words';

  @override
  String get quizTopicMacaKataSandhanganDesc =>
      'Read words featuring various vocalic diacritics.';

  @override
  String get quizTopicNulisKataSederhana => 'Writing Simple Words';

  @override
  String get quizTopicNulisKataSederhanaDesc =>
      'Form correctly spelled words using diacritic marks.';

  @override
  String get quizTopicNiteniLuputNulis => 'Spotting Writing Errors';

  @override
  String get quizTopicNiteniLuputNulisDesc =>
      'Identify and fix misplaced diacritics and subjoined pairs.';

  @override
  String get quizTopicGladhenKombinasi => 'Combined Practice';

  @override
  String get quizTopicGladhenKombinasiDesc =>
      'Drills combining vowel marks, final consonants, and pairs.';

  @override
  String get quizTopicEvaluasiUnit3 => 'Unit 3 Evaluation';

  @override
  String get quizTopicEvaluasiUnit3Desc =>
      'Comprehensive test on Javanese diacritics and pairs.';

  @override
  String get quizTopicKeluargaLanKerabat => 'Family & Relatives';

  @override
  String get quizTopicKeluargaLanKerabatDesc =>
      'Family lineage terms across ngoko and krama speech levels.';

  @override
  String get quizTopicOmahLanSakiwatengene => 'Home & Surroundings';

  @override
  String get quizTopicOmahLanSakiwatengeneDesc =>
      'Names of household items, rooms, and surroundings.';

  @override
  String get quizTopicKagiyatanPadinan => 'Daily Activities';

  @override
  String get quizTopicKagiyatanPadinanDesc =>
      'Verbs and everyday activities across speech registers.';

  @override
  String get quizTopicNgokoLugu => 'Ngoko Lugu Level';

  @override
  String get quizTopicNgokoLuguDesc =>
      'Characteristics and usage of ngoko lugu among peers.';

  @override
  String get quizTopicNgokoAlus => 'Ngoko Alus Level';

  @override
  String get quizTopicNgokoAlusDesc =>
      'Polite krama inggil inflections mixed into ngoko sentences.';

  @override
  String get quizTopicKramaLugu => 'Krama Lugu Level';

  @override
  String get quizTopicKramaLuguDesc =>
      'Formal polite language used in neutral interpersonal settings.';

  @override
  String get quizTopicKramaInggil => 'Krama Inggil Level';

  @override
  String get quizTopicKramaInggilDesc =>
      'Highest honorific register to address elders and leaders.';

  @override
  String get quizTopicBandhinganTingkatBasa => 'Speech Register Comparison';

  @override
  String get quizTopicBandhinganTingkatBasaDesc =>
      'Compare word counterparts across ngoko, krama, and inggil.';

  @override
  String get quizTopicWicaraUnggahUngguh => 'Etiquette in Dialogue';

  @override
  String get quizTopicWicaraUnggahUngguhDesc =>
      'Apply etiquette registers in real-world dialogue simulations.';

  @override
  String get quizTopicEvaluasiUnit4 => 'Unit 4 Evaluation';

  @override
  String get quizTopicEvaluasiUnit4Desc =>
      'Comprehensive test on vocabulary and language levels.';

  @override
  String get quizTopicAjiningDhiri => 'Dignity Through Speech';

  @override
  String get quizTopicAjiningDhiriDesc =>
      'Philosophy of preserving personal dignity through honorable speech.';

  @override
  String get quizTopicUnggahUngguhBasa => 'Javanese Social Etiquette';

  @override
  String get quizTopicUnggahUngguhBasaDesc =>
      'Principles of decorum, humility, and behavior in Javanese society.';

  @override
  String get quizTopicParibasanJawa => 'Javanese Proverbs';

  @override
  String get quizTopicParibasanJawaDesc =>
      'Profound meanings behind traditional Javanese proverbs and idioms.';

  @override
  String get quizTopicFilosofiUrip => 'Life is to Enlighten';

  @override
  String get quizTopicFilosofiUripDesc =>
      'The wisdom of living a life that illuminates and helps others.';

  @override
  String get quizTopicTradisiPranatan => 'Javanese Customs & Traditions';

  @override
  String get quizTopicTradisiPranatanDesc =>
      'Traditional ceremonies, life cycle milestones, and cultural customs.';

  @override
  String get quizTopicPewayanganPandhawa => 'Pandhava Wayang Lore';

  @override
  String get quizTopicPewayanganPandhawaDesc =>
      'Virtues and life lessons of the five Pandhava shadow puppet heroes.';

  @override
  String get quizTopicTembangDolanan => 'Folk Songs & Moral Teachings';

  @override
  String get quizTopicTembangDolananDesc =>
      'Moral values and character-building in traditional Javanese songs.';

  @override
  String get quizTopicEtikaBudaya => 'Cultural Situational Ethics';

  @override
  String get quizTopicEtikaBudayaDesc =>
      'Choosing proper actions and words in cultural and community contexts.';

  @override
  String get quizTopicKawruhLuhur => 'Higher Wisdom Challenge';

  @override
  String get quizTopicKawruhLuhurDesc =>
      'Advanced mastery combining script, linguistic etiquette, and wisdom.';

  @override
  String get quizTopicEvaluasiAkhir => 'JawaLoka Grand Evaluation';

  @override
  String get quizTopicEvaluasiAkhirDesc =>
      'Grand finale comprehensive examination across all 50 JawaLoka nodes.';

  @override
  String get quizTopicUngkapanSopan => 'Polite Expressions';

  @override
  String get quizTopicUngkapanSopanDesc =>
      'Body language, subasita, and polite manners in Javanese etiquette.';

  @override
  String get quizTopicPenggunaanPasangan => 'Using Pasangan';

  @override
  String get quizTopicPenggunaanPasanganDesc =>
      'Rules and practice of applying pasangan in words and sentences.';

  @override
  String get quizTopicKosakataPadinan => 'Everyday Vocabulary';

  @override
  String get quizTopicKosakataPadinanDesc =>
      'Fundamental everyday vocabulary and family relations in Javanese.';

  @override
  String get quizTopicNamaBenda => 'Names of Objects';

  @override
  String get quizTopicNamaBendaDesc =>
      'Names of household objects, parts of traditional Joglo house, and environment.';

  @override
  String get quizTopicNamaKegiatan => 'Names of Activities';

  @override
  String get quizTopicNamaKegiatanDesc =>
      'Action verbs and common everyday activities in Javanese.';

  @override
  String get quizTopicNgoko => 'Ngoko';

  @override
  String get quizTopicNgokoDesc =>
      'Usage and vocabulary of Ngoko for peers and close friends.';

  @override
  String get quizTopicKrama => 'Krama';

  @override
  String get quizTopicKramaDesc =>
      'Polite Javanese speech level (Krama) for formal and respectful situations.';

  @override
  String get quizTopicPerbedaanTingkatanBahasa => 'Speech Level Differences';

  @override
  String get quizTopicPerbedaanTingkatanBahasaDesc =>
      'Comparing word forms across Ngoko, Krama, and Krama Inggil.';

  @override
  String get quizTopicPercakapanTeman => 'Conversation with Friends';

  @override
  String get quizTopicPercakapanTemanDesc =>
      'Interactive dialogs with friends using proper Ngoko speech.';

  @override
  String get quizTopicPercakapanDihormati =>
      'Conversation with Respected Elders';

  @override
  String get quizTopicPercakapanDihormatiDesc =>
      'Respectful dialogue with parents, teachers, and elders using Krama Inggil.';

  @override
  String get quizTopicTataKramaJawa => 'Javanese Etiquette';

  @override
  String get quizTopicTataKramaJawaDesc =>
      'Core principles of modesty, speech ethics, and respect in Javanese culture.';

  @override
  String get quizTopicPeribahasaJawa => 'Javanese Proverbs';

  @override
  String get quizTopicPeribahasaJawaDesc =>
      'Wisdom and life guidance within Javanese proverbs (Paribasan & Saloka).';

  @override
  String get quizTopicFilosofiKehidupan => 'Philosophy of Life';

  @override
  String get quizTopicFilosofiKehidupanDesc =>
      'Profound philosophical life lessons: Urip Iku Urup, Memayu Hayuning Bawana.';

  @override
  String get quizTopicTradisiJawa => 'Javanese Traditions';

  @override
  String get quizTopicTradisiJawaDesc =>
      'Cultural rituals, customs, and ceremonies of the Javanese life cycle.';

  @override
  String get quizTopicBudayaKesenian => 'Culture and Arts';

  @override
  String get quizTopicBudayaKesenianDesc =>
      'Traditional arts, wayang purwa characters, and cultural expressions.';

  @override
  String get quizTopicSituasiPadinan => 'Everyday Situations';

  @override
  String get quizTopicSituasiPadinanDesc =>
      'Applying cultural wisdom, tembang dolanan, and social values in daily life.';

  @override
  String get quizTopicTantanganBudaya => 'Cultural Understanding Challenge';

  @override
  String get quizTopicTantanganBudayaDesc =>
      'Advanced cultural ethics, empathy, tepa slira, and social awareness challenge.';

  @override
  String get quizTopicTantanganAkhir => 'Final Challenge';

  @override
  String get quizTopicTantanganAkhirDesc =>
      'Comprehensive synthesis challenge of Aksara, language levels, and cultural values.';
}
