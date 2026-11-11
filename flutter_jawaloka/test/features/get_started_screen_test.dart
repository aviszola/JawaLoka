import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/get_started_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/widgets/get_started_brand_mark.dart';
import 'package:flutter_jawaloka/features/auth/presentation/widgets/get_started_illustration_painter.dart';
import '../helpers/pump_app.dart';

void main() {
  group('GetStartedScreen & Illustration Tests', () {
    testWidgets('renders brand title, tagline, emblem, illustration, and CTA', (
      tester,
    ) async {
      await tester.pumpApp(
        const GetStartedScreen(enableAmbientAnimation: false),
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pumpAndSettle();

      // Brand Title & Tagline
      expect(find.text('JawaLoka'), findsOneWidget);
      expect(
        find.text('Sinau basa & aksara Jawa luwih gampang'),
        findsOneWidget,
      );

      // Brand Mark & Illustration
      expect(find.byType(GetStartedBrandMark), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is CustomPaint && w.painter is GetStartedIllustrationPainter,
        ),
        findsOneWidget,
      );

      // Primary Button & Disclaimer
      expect(find.text('Get Started'), findsOneWidget);
      expect(
        find.text('Aplikasi pasinaon budaya & aksara Jawa.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });

    testWidgets('triggers onGetStarted callback when button is tapped', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpApp(
        GetStartedScreen(
          enableAmbientAnimation: false,
          onGetStarted: () {
            tapped = true;
          },
        ),
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pumpAndSettle();

      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);

      await tester.tap(getStartedButton);
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('ambient gamelan animation updates painter progress cleanly', (
      tester,
    ) async {
      await tester.pumpApp(
        const GetStartedScreen(enableAmbientAnimation: true),
        onGenerateRoute: AppRouter.generateRoute,
      );
      // Pump initial frame & advance time
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 600));

      final customPaintFinder = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is GetStartedIllustrationPainter,
      );
      expect(customPaintFinder, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(customPaintFinder);
      final painter = customPaint.painter as GetStartedIllustrationPainter;
      expect(painter.animationProgress, greaterThan(0.0));
    });

    testWidgets('default flow navigates to languageSelection when tapped', (
      tester,
    ) async {
      await tester.pumpApp(
        const SizedBox.shrink(),
        initialRoute: AppRouter.getStarted,
        onGenerateRoute: (settings) {
          if (settings.name == AppRouter.getStarted) {
            return MaterialPageRoute(
              builder: (_) =>
                  const GetStartedScreen(enableAmbientAnimation: false),
            );
          }
          return AppRouter.generateRoute(settings);
        },
      );
      await tester.pumpAndSettle();

      expect(find.byType(GetStartedScreen), findsOneWidget);

      final button = find.text('Get Started');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Should now be on language selection screen
      expect(find.byType(GetStartedScreen), findsNothing);
    });

    testWidgets('triggers onSignIn callback when login link is tapped', (
      tester,
    ) async {
      bool signedIn = false;
      await tester.pumpApp(
        GetStartedScreen(
          enableAmbientAnimation: false,
          onSignIn: () {
            signedIn = true;
          },
        ),
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pumpAndSettle();

      // "Isi Data Diri" action
      final loginLink = find.text('Isi Data Diri');
      expect(loginLink, findsOneWidget);

      await tester.tap(loginLink);
      await tester.pump();

      expect(signedIn, isTrue);
    });

    testWidgets(
      'allows immediate proceed on tap and does not show countdown seconds or hourglass',
      (tester) async {
        bool tapped = false;
        await tester.pumpApp(
          GetStartedScreen(
            enableAmbientAnimation: false,
            onGetStarted: () {
              tapped = true;
            },
          ),
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pump();

        // Button shows forward arrow and NO countdown seconds or hourglass
        expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
        expect(find.byIcon(Icons.hourglass_top_rounded), findsNothing);
        expect(find.text('10s'), findsNothing);
        expect(find.textContaining(RegExp(r'\d+s')), findsNothing);

        // Tapping proceeds IMMEDIATELY without waiting
        await tester.tap(find.text('Get Started'));
        await tester.pump();
        expect(tapped, isTrue);
      },
    );

    testWidgets(
      'auto-advances into the app when there is no interaction for 10 seconds',
      (tester) async {
        bool autoProceeded = false;
        await tester.pumpApp(
          GetStartedScreen(
            enableAmbientAnimation: false,
            idleTimeout: const Duration(seconds: 10),
            onGetStarted: () {
              autoProceeded = true;
            },
          ),
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pump();

        // At 5 seconds: still has not auto-proceeded
        await tester.pump(const Duration(seconds: 5));
        expect(autoProceeded, isFalse);

        // At 10 seconds of no interaction: auto-advances
        await tester.pump(const Duration(seconds: 5));
        await tester.pump(const Duration(milliseconds: 100));
        expect(autoProceeded, isTrue);
      },
    );

    testWidgets(
      'all page transitions apply SlideTransition, ScaleTransition, and FadeTransition',
      (tester) async {
        final route = AppRouter.generateRoute(
          const RouteSettings(name: AppRouter.getStarted),
        );
        expect(route, isA<JawaLokaPageRoute>());

        // Build the transition widget tree
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.languageSelection);
                },
                child: const Text('Go'),
              );
            },
          ),
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pumpAndSettle();

        // Tap Go to trigger page transition animation
        await tester.tap(find.text('Go'));
        await tester.pump(const Duration(milliseconds: 150));

        // Transitions are actively animating
        expect(find.byType(SlideTransition), findsWidgets);
        expect(find.byType(ScaleTransition), findsWidgets);
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();
      },
    );
  });
}
