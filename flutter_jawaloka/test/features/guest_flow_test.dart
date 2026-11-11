import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/language_selection_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/register_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Zero Friction & Guest Mode Navigation Tests', () {
    testWidgets('LanguageSelectionScreen skip to learn navigates to /home', (
      tester,
    ) async {
      String? navigatedRoute;

      await tester.pumpApp(
        const LanguageSelectionScreen(),
        onGenerateRoute: (settings) {
          navigatedRoute = settings.name;
          return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: Text('Destination: ${settings.name}')),
            settings: settings,
          );
        },
      );
      await tester.pumpAndSettle();

      final skipFinder = find.text('Lewati & Mulai Belajar');
      expect(skipFinder, findsOneWidget);

      await tester.tap(skipFinder);
      await tester.pumpAndSettle();

      expect(navigatedRoute, AppRouter.home);
    });

    testWidgets(
      'RegisterScreen continue as guest navigates to /home and saves name if entered',
      (tester) async {
        String? navigatedRoute;
        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);

        await tester.pumpApp(
          const RegisterScreen(),
          profileController: profileController,
          onGenerateRoute: (settings) {
            navigatedRoute = settings.name;
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Text('Destination: ${settings.name}')),
              settings: settings,
            );
          },
        );
        await tester.pumpAndSettle();

        // Enter a name
        await tester.enterText(
          find.byType(TextFormField).first,
          'Budi Santoso',
        );
        await tester.pumpAndSettle();

        final guestFinder = find.text('Lanjut sebagai Tamu');
        expect(guestFinder, findsOneWidget);
        await tester.ensureVisible(guestFinder);
        await tester.pumpAndSettle();
        await tester.tap(guestFinder);

        expect(navigatedRoute, AppRouter.home);
        expect(profileController.displayName, 'Budi Santoso');
      },
    );

    testWidgets(
      'LoginScreen continue as guest navigates to /home directly without form validation',
      (tester) async {
        String? navigatedRoute;

        await tester.pumpApp(
          const LoginScreen(),
          onGenerateRoute: (settings) {
            navigatedRoute = settings.name;
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Text('Destination: ${settings.name}')),
              settings: settings,
            );
          },
        );
        await tester.pumpAndSettle();

        final guestFinder = find.text('Lanjut sebagai Tamu');
        expect(guestFinder, findsOneWidget);

        await tester.tap(guestFinder);
        await tester.pumpAndSettle();

        expect(navigatedRoute, AppRouter.home);
      },
    );
  });
}
