import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/presentation/widgets/javanese_calligraphy_painter.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/get_started_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/language_selection_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/widgets/primary_button.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_continue_quiz_card.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/daily_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/drawing_canvas_painter.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/quiz_bottom_sheet.dart';
import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'End-to-End Main Flow: Splash -> Get Started (10s) -> Language -> Register -> Home -> Active Quiz -> Quest Trace -> Quest Result -> Profile -> Settings',
    (WidgetTester tester) async {
      // 1. Setup view dimensions so all elements fit comfortably
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // ── STEP 1: GET STARTED SCREEN (bisa langsung lanjut tanpa menunggu) ───
      await tester.pumpApp(
        const GetStartedScreen(enableAmbientAnimation: false),
        onGenerateRoute: AppRouter.generateRoute,
      );

      expect(find.byType(GetStartedScreen), findsOneWidget);

      final getStartedBtn = find.text('Get Started');
      expect(getStartedBtn, findsOneWidget);
      await tester.tap(getStartedBtn);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      // ── STEP 2: LANGUAGE SELECTION ─────────────────────────────────────────
      expect(find.byType(LanguageSelectionScreen), findsOneWidget);

      // Tap PrimaryButton to proceed with default Indonesian language
      final langContinueBtn = find.descendant(
        of: find.byType(LanguageSelectionScreen),
        matching: find.byType(PrimaryButton),
      );
      expect(langContinueBtn, findsOneWidget);
      await tester.tap(langContinueBtn);
      await tester.pumpAndSettle();

      // ── STEP 3: REGISTER SCREEN ────────────────────────────────────────────
      expect(find.byType(RegisterScreen), findsOneWidget);

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(3));

      // Fill in user credentials
      const testName = 'Dewi Lestari';
      await tester.enterText(textFields.at(0), testName); // Nama Lengkap
      await tester.enterText(textFields.at(1), 'dewi@jawaloka.id'); // Email
      await tester.enterText(textFields.at(2), 'rahasia123'); // Password
      await tester.pump();

      // Tap Register PrimaryButton
      final registerBtn = find.descendant(
        of: find.byType(RegisterScreen),
        matching: find.byType(PrimaryButton),
      );
      expect(registerBtn, findsOneWidget);
      await tester.tap(registerBtn);
      await tester.pumpAndSettle();

      // ── STEP 4: HOME SCREEN (BERANDA) ──────────────────────────────────────
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify user display name appears on the Home dashboard
      expect(find.textContaining(testName), findsWidgets);

      // Tap "Lanjutkan Kuis" card
      final continueQuizCard = find.byType(HomeContinueQuizCard);
      expect(continueQuizCard, findsOneWidget);
      await tester.tap(continueQuizCard);
      await tester.pumpAndSettle();

      // Verify QuizBottomSheet opens
      expect(find.byType(QuizBottomSheet), findsOneWidget);

      // Tap "Mulai Kuis" inside the bottom sheet
      final startQuizBtn = find.descendant(
        of: find.byType(QuizBottomSheet),
        matching: find.byType(ElevatedButton),
      );
      expect(startQuizBtn, findsOneWidget);
      await tester.tap(startQuizBtn);
      await tester.pumpAndSettle();

      // ── STEP 5: QUIZ QUESTIONS -> QUIZ RESULT ──────────────────────────────
      expect(find.byType(QuizQuestionScreen), findsOneWidget);

      // Answer questions until the session completes and navigates to QuizResultScreen
      int maxSafetyIterations = 20;
      while (find.byType(QuizQuestionScreen).evaluate().isNotEmpty &&
          maxSafetyIterations-- > 0) {
        // Tap first option (Key: quiz_option_0)
        final option0 = find.byKey(const Key('quiz_option_0'));
        expect(option0, findsOneWidget);
        await tester.tap(option0);
        await tester.pump();

        // Tap bottom bar button ("Lanjut" or "Selesai")
        final confirmBtn = find.descendant(
          of: find.byType(QuizQuestionScreen),
          matching: find.byType(ElevatedButton),
        );
        expect(confirmBtn, findsOneWidget);
        await tester.tap(confirmBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
      }

      // Verify QuizResultScreen is displayed
      expect(find.byType(QuizResultScreen), findsOneWidget);

      // Tap "Kembali ke Beranda" button on QuizResultScreen
      final backHomeBtn = find.descendant(
        of: find.byType(QuizResultScreen),
        matching: find.byType(ElevatedButton),
      );
      expect(backHomeBtn, findsOneWidget);
      await tester.tap(backHomeBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Returned to HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);

      // ── STEP 6: QUEST (DRAWING CANVAS SCREEN) ──────────────────────────────
      // Tap center action button with pen icon (size 26 in amber circle)
      final questCenterBtn = find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.edit_rounded && w.size == 26,
      );
      expect(questCenterBtn, findsOneWidget);
      await tester.tap(questCenterBtn);
      await tester.pumpAndSettle();

      expect(find.byType(DrawingCanvasScreen), findsOneWidget);

      // Generate authentic trace points for target Aksara 'ꦲ'
      final path = JavaneseCalligraphyPainter.buildPathForAksara('ꦲ', 1.0, 1.0);
      final metrics = path.computeMetrics().toList();
      final totalLength = metrics.fold<double>(0.0, (sum, m) => sum + m.length);
      final sampledPoints = <Offset>[];
      const int sampleCount = 60;
      final stepDist = totalLength / sampleCount;
      for (final metric in metrics) {
        for (double d = 0.0; d < metric.length; d += stepDist) {
          final tangent = metric.getTangentForOffset(d);
          if (tangent != null) {
            sampledPoints.add(tangent.position);
          }
        }
      }
      expect(sampledPoints, isNotEmpty);

      // Locate canvas CustomPaint to calculate scale and offset
      final canvasCustomPaint = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is DrawingCanvasPainter,
      );
      expect(canvasCustomPaint, findsOneWidget);

      final canvasRect = tester.getRect(canvasCustomPaint);
      final ghostSize = min(canvasRect.width, canvasRect.height) * 0.65;
      final ghostLeft = (canvasRect.width - ghostSize) / 2;
      final ghostTop = (canvasRect.height - ghostSize) / 2;

      Offset toScreenOffset(Offset p) {
        return canvasRect.topLeft +
            Offset(
              ghostLeft + p.dx * (ghostSize / 100),
              ghostTop + p.dy * (ghostSize / 100),
            );
      }

      // Draw the authentic trace using TestGesture
      final gesture = await tester.startGesture(
        toScreenOffset(sampledPoints.first),
      );
      for (final pt in sampledPoints.skip(1)) {
        await gesture.moveTo(toScreenOffset(pt));
      }
      await gesture.up();
      await tester.pump();

      // Submit drawing with "Periksa Tulisan"
      final checkDrawingBtn = find.descendant(
        of: find.byType(DrawingCanvasScreen),
        matching: find.byType(ElevatedButton),
      );
      expect(checkDrawingBtn, findsOneWidget);
      await tester.tap(checkDrawingBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // ── STEP 7: QUEST RESULT (DAILY RESULT SCREEN) ─────────────────────────
      expect(find.byType(DailyResultScreen), findsOneWidget);

      // Tap "Lanjutkan Belajar" to return to Main Shell
      final continueLearningBtn = find.descendant(
        of: find.byType(DailyResultScreen),
        matching: find.byType(ElevatedButton),
      );
      expect(continueLearningBtn, findsOneWidget);
      await tester.tap(continueLearningBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // ── STEP 8: PROFILE SCREEN ─────────────────────────────────────────────
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap Profile tab in bottom navigation bar
      final profileTab = find.byIcon(Icons.person_outline_rounded);
      expect(profileTab, findsOneWidget);
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      // Verify user display name is visible on ProfileScreen
      expect(find.text(testName), findsWidgets);

      // ── STEP 9: SETTINGS SCREEN ────────────────────────────────────────────
      // Tap settings gear icon button
      final settingsGearBtn = find.byIcon(Icons.settings_outlined);
      expect(settingsGearBtn, findsOneWidget);
      await tester.tap(settingsGearBtn);
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
      // Verify user name is present in Settings account section
      expect(find.textContaining(testName), findsWidgets);

      // Final check: absolutely no exceptions were thrown during the entire flow
      expect(tester.takeException(), isNull);
    },
  );
}
