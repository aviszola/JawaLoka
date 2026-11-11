import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/get_started_screen.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/learn/presentation/screens/vocabulary_detail_screen.dart';
import '../../features/learn/presentation/screens/aksara_detail_screen.dart';
import '../../features/translator/presentation/screens/translator_screen.dart';
import '../../features/quiz/presentation/screens/quiz_question_screen.dart';
import '../../features/quiz/presentation/screens/quiz_result_screen.dart';
import '../../features/quiz/presentation/screens/drawing_canvas_screen.dart';
import '../../features/quiz/presentation/screens/daily_result_screen.dart';
import '../../features/profile/presentation/screens/choose_blangkon_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/level_up_screen.dart';
import '../../features/quiz/domain/adaptive_quiz_bank.dart';
import '../profile/profile_scope.dart';

/// Centralized router for JawaLoka navigation.
/// All named routes are defined here.
class AppRouter {
  AppRouter._();

  // ═══════════════════════════════════════════════
  //   ROUTE NAMES
  // ═══════════════════════════════════════════════
  static const String splash = '/splash';
  static const String getStarted = '/';
  static const String languageSelection = '/language-selection';
  static const String profileSetup = '/profile-setup';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String learnHub = '/learn';
  static const String vocabularyDetail = '/learn/vocabulary';
  static const String aksaraDetail = '/learn/aksara';
  static const String translator = '/translator';
  static const String quizPath = '/quiz/path';
  static const String quizQuestion = '/quiz/question';
  static const String quizResult = '/quiz/result';
  static const String drawingCanvas = '/quest/drawing';
  static const String dailyResult = '/quest/result';
  static const String chooseBlangkon = '/profile/blangkon';
  static const String settings = '/profile/settings';
  static const String profile = '/profile';
  static const String levelUp = '/level-up';

  // ═══════════════════════════════════════════════
  //   ROUTE GENERATOR
  // ═══════════════════════════════════════════════
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.splash:
        return _FadePageRoute(page: const GetStartedScreen(), settings: settings);

      case AppRouter.getStarted:
      case '/get-started':
        return _FadePageRoute(
          page: const GetStartedScreen(),
          settings: settings,
        );

      case AppRouter.languageSelection:
        return _FadePageRoute(
          page: const LanguageSelectionScreen(),
          settings: settings,
        );

      case AppRouter.profileSetup:
      case AppRouter.register:
      case AppRouter.login:
        return _FadePageRoute(page: const ProfileSetupScreen(), settings: settings);

      case AppRouter.home:
        return _FadePageRoute(
          page: const MainShellScreen(initialIndex: 0),
          settings: settings,
        );

      case AppRouter.learnHub:
        return _FadePageRoute(
          page: const MainShellScreen(initialIndex: 1),
          settings: settings,
        );

      case AppRouter.quizPath:
        return _FadePageRoute(
          page: const MainShellScreen(initialIndex: 3),
          settings: settings,
        );

      case AppRouter.profile:
        return _FadePageRoute(
          page: const MainShellScreen(initialIndex: 4),
          settings: settings,
        );

      case AppRouter.vocabularyDetail:
        final raw = settings.arguments;
        final index = (raw is int && raw >= 0) ? raw : 0;
        return _FadePageRoute(
          page: VocabularyDetailScreen(initialIndex: index),
          settings: settings,
        );

      case AppRouter.aksaraDetail:
        return _FadePageRoute(
          page: const AksaraDetailScreen(),
          settings: settings,
        );

      case AppRouter.translator:
        return _FadePageRoute(
          page: const TranslatorScreen(),
          settings: settings,
        );

      case AppRouter.quizQuestion:
        final args = settings.arguments;
        if (args is QuizQuestionArgs) {
          final questions =
              args.questions ??
              (args.userLevel != null
                  ? AdaptiveQuizBank.getQuestionsForLevel(args.userLevel!)
                  : QuizQuestionScreen.defaultQuestions);
          return _FadePageRoute(
            page: QuizQuestionScreen(
              questions: questions,
              moduleTitle: args.moduleTitle,
              onComplete: args.onComplete,
              activityId: args.activityId,
              isEvaluation: args.isEvaluation,
            ),
            settings: settings,
          );
        }
        return _FadePageRoute(
          page: Builder(
            builder: (context) {
              final profile = ProfileScope.maybeOf(context);
              final level = profile?.userLevel ?? 1;
              return QuizQuestionScreen(
                questions: AdaptiveQuizBank.getQuestionsForLevel(level),
              );
            },
          ),
          settings: settings,
        );

      case AppRouter.quizResult:
        final args = settings.arguments;
        final QuizResult safeResult = (args is QuizResult && args.totalQuestions > 0)
            ? args
            : const QuizResult(
                score: 0,
                maxScore: 100,
                correctCount: 0,
                totalQuestions: 10,
                accuracy: 0,
                isStreakAchievedToday: false,
              );
        return _FadePageRoute(
          page: QuizResultScreen(result: safeResult),
          settings: settings,
        );

      case AppRouter.drawingCanvas:
        return _FadePageRoute(
          page: const DrawingCanvasScreen(),
          settings: settings,
        );

      case AppRouter.dailyResult:
        final args = settings.arguments;
        if (args is DailyResultArgs) {
          final safeSimilarity =
              args.similarity.isNaN || args.similarity.isInfinite
                  ? 0.0
                  : args.similarity.clamp(0.0, 1.0);
          return _FadePageRoute(
            page: DailyResultScreen(
              userName: args.userName,
              similarity: safeSimilarity,
              userStrokes: args.userStrokes,
              targetAksara: args.targetAksara,
              rewardSummary: args.rewardSummary,
            ),
            settings: settings,
          );
        }
        return _FadePageRoute(
          page: const DailyResultScreen(),
          settings: settings,
        );

      case AppRouter.chooseBlangkon:
        return _FadePageRoute(
          page: const ChooseBlangkonScreen(),
          settings: settings,
        );

      case AppRouter.settings:
        return _FadePageRoute(page: const SettingsScreen(), settings: settings);

      case AppRouter.levelUp:
        final args = settings.arguments;
        if (args is LevelUpArgs &&
            args.newLevel >= 1 &&
            args.previousLevel >= 1 &&
            args.newLevel >= args.previousLevel) {
          return _FadePageRoute(
            page: LevelUpScreen(
              newLevel: args.newLevel,
              previousLevel: args.previousLevel,
              unlockedBlangkons: args.unlockedBlangkons,
              blangkonName: args.blangkonName,
              blangkonType: args.blangkonType,
            ),
            settings: settings,
          );
        }
        return _FadePageRoute(page: const LevelUpScreen(), settings: settings);

      default:
        return _FadePageRoute(
          page: _ErrorScreen(routeName: settings.name ?? 'Unknown'),
          settings: settings,
        );
    }
  }
}

// ─── Animated page transitions ────────────────────────────────────────────────

/// Reusable transition builder that combines slide, scale, and fade animations
/// with depth-layered secondary transitions for receding pages.
Widget buildJawaLokaTransitions({
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
}) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  final curvedSecondaryAnimation = CurvedAnimation(
    parent: secondaryAnimation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  // Primary enter: Slide from right (8%), scale from 0.96 to 1.0, fade 0 to 1
  final slideIn = Tween<Offset>(
    begin: const Offset(0.08, 0.0),
    end: Offset.zero,
  ).animate(curvedAnimation);

  final scaleIn = Tween<double>(
    begin: 0.96,
    end: 1.0,
  ).animate(curvedAnimation);

  final fadeIn = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(curvedAnimation);

  // Secondary exit: Current page slightly slides left (-4%), scales down to 0.98, dims to 0.88
  final slideOut = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.04, 0.0),
  ).animate(curvedSecondaryAnimation);

  final scaleOut = Tween<double>(
    begin: 1.0,
    end: 0.98,
  ).animate(curvedSecondaryAnimation);

  final fadeOut = Tween<double>(
    begin: 1.0,
    end: 0.88,
  ).animate(curvedSecondaryAnimation);

  return SlideTransition(
    position: slideOut,
    child: ScaleTransition(
      scale: scaleOut,
      child: FadeTransition(
        opacity: fadeOut,
        child: SlideTransition(
          position: slideIn,
          child: ScaleTransition(
            scale: scaleIn,
            child: FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Page route builder providing smooth animated page transitions across all routes.
class JawaLokaPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  JawaLokaPageRoute({
    required this.page,
    required super.settings,
    Duration duration = const Duration(milliseconds: 380),
    Duration reverseDuration = const Duration(milliseconds: 320),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              buildJawaLokaTransitions(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
        );
}

/// PageTransitionsBuilder for MaterialApp theme so all route transitions are animated.
class JawaLokaPageTransitionsBuilder extends PageTransitionsBuilder {
  const JawaLokaPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return buildJawaLokaTransitions(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// Backward-compatible alias for route generator
typedef _FadePageRoute<T> = JawaLokaPageRoute<T>;
// ─── Error scaffold ───────────────────────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  final String routeName;
  const _ErrorScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.amber,
        title: const Text('Halaman Tidak Ditemukan'),
        foregroundColor: AppColors.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ꦗ',
              style: TextStyle(fontSize: 72, color: Color(0xFF231C14)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rute tidak ditemukan',
              style: TextStyle(
                color: Color(0xFF231C14),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              routeName,
              style: const TextStyle(color: Color(0xFF6B6257), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
