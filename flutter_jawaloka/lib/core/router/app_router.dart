import 'package:flutter/material.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
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

/// Centralized router for JawaLoka navigation.
/// All named routes are defined here.
class AppRouter {
  AppRouter._();

  // ═══════════════════════════════════════════════
  //   ROUTE NAMES
  // ═══════════════════════════════════════════════
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
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
        return _FadePageRoute(page: const SplashScreen(), settings: settings);

      case AppRouter.languageSelection:
        return _FadePageRoute(
            page: const LanguageSelectionScreen(), settings: settings);

      case AppRouter.register:
        return _FadePageRoute(
            page: const RegisterScreen(), settings: settings);

      case AppRouter.login:
        return _FadePageRoute(page: const LoginScreen(), settings: settings);

      case AppRouter.home:
        return _FadePageRoute(
            page: const MainShellScreen(initialIndex: 0), settings: settings);

      case AppRouter.learnHub:
        return _FadePageRoute(
            page: const MainShellScreen(initialIndex: 1), settings: settings);

      case AppRouter.quizPath:
        return _FadePageRoute(
            page: const MainShellScreen(initialIndex: 3), settings: settings);

      case AppRouter.profile:
        return _FadePageRoute(
            page: const MainShellScreen(initialIndex: 4), settings: settings);

      case AppRouter.vocabularyDetail:
        final raw = settings.arguments;
        final index = raw is int ? raw : 0;
        return _FadePageRoute(
            page: VocabularyDetailScreen(initialIndex: index),
            settings: settings);

      case AppRouter.aksaraDetail:
        return _FadePageRoute(
            page: const AksaraDetailScreen(), settings: settings);

      case AppRouter.translator:
        return _FadePageRoute(
            page: const TranslatorScreen(), settings: settings);

      case AppRouter.quizQuestion:
        return _FadePageRoute(
            page: const QuizQuestionScreen(), settings: settings);

      case AppRouter.quizResult:
        final args = settings.arguments;
        final QuizResult safeResult = args is QuizResult
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


            settings: settings);

      case AppRouter.drawingCanvas:
        return _FadePageRoute(
            page: const DrawingCanvasScreen(), settings: settings);

      case AppRouter.dailyResult:
        return _FadePageRoute(
            page: const DailyResultScreen(), settings: settings);

      case AppRouter.chooseBlangkon:
        return _FadePageRoute(
            page: const ChooseBlangkonScreen(), settings: settings);

      case AppRouter.settings:
        return _FadePageRoute(
            page: const SettingsScreen(), settings: settings);

      case AppRouter.levelUp:
        return _FadePageRoute(
            page: const LevelUpScreen(), settings: settings);

      default:
        return _FadePageRoute(
          page: _ErrorScreen(routeName: settings.name ?? 'Unknown'),
          settings: settings,
        );
    }
  }
}

// ─── Fade page transition ─────────────────────────────────────────────────────

class _FadePageRoute<T> extends PageRouteBuilder<T> {
  _FadePageRoute({required Widget page, required RouteSettings settings})
      : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, anim, secondaryAnimation, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        );
}

// ─── Error scaffold ───────────────────────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  final String routeName;
  const _ErrorScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC247),
        title: const Text('Halaman Tidak Ditemukan'),
        foregroundColor: const Color(0xFF231C14),
        elevation: 0,
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
