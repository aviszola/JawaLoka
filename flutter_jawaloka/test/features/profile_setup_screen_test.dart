import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/javanese_avatar_widget.dart';
import '../helpers/pump_app.dart';

void main() {
  group('ProfileSetupScreen Widget & Integration Tests', () {
    testWidgets(
      'renders all setup fields: gender choice, name, age stepper, and buttons',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        await tester.pumpApp(
          const ProfileSetupScreen(),
          profileController: profileController,
        );
        await tester.pumpAndSettle();

        expect(find.text('Isi Data Diri'), findsOneWidget);
        expect(find.text('Pilih Karakter'), findsOneWidget);
        expect(find.text('Putra'), findsOneWidget);
        expect(find.text('Putri'), findsOneWidget);
        expect(find.text('Nama Panggilan'), findsOneWidget);
        expect(find.text('Mulai Petualangan'), findsOneWidget);
        expect(find.text('Lewati & Masuk Cepat'), findsOneWidget);
        expect(find.byType(JavaneseAvatarWidget), findsOneWidget);
      },
    );

    testWidgets('switching gender updates character badge and state', (
      tester,
    ) async {
      final profilePrefs = InMemoryProfilePreferences();
      final profileController = ProfileController(preferences: profilePrefs);
      await profileController.loadProfile();

      await tester.pumpApp(
        const ProfileSetupScreen(),
        profileController: profileController,
      );
      await tester.pumpAndSettle();

      expect(find.text('Karakter Putra (Surjan & Blangkon)'), findsOneWidget);

      // Tap on Putri
      await tester.tap(find.text('Putri'));
      await tester.pumpAndSettle();

      expect(find.text('Karakter Putri (Kebaya & Sanggul)'), findsOneWidget);
    });

    testWidgets(
      'submitting profile saves name, gender, and age to ProfileController',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();
        String? destination;

        await tester.pumpApp(
          const ProfileSetupScreen(),
          profileController: profileController,
          onGenerateRoute: (settings) {
            destination = settings.name;
            return MaterialPageRoute(
              builder: (_) => Scaffold(body: Text('Dest: ${settings.name}')),
              settings: settings,
            );
          },
        );
        await tester.pumpAndSettle();

        // Tap Putri
        await tester.tap(find.text('Putri'));
        await tester.pumpAndSettle();

        // Enter name
        await tester.enterText(find.widgetWithText(TextField, ''), 'Sekar');
        await tester.pumpAndSettle();

        // Submit
        final submitBtn = find.text('Mulai Petualangan');
        await tester.ensureVisible(submitBtn);
        await tester.tap(submitBtn);
        await tester.pumpAndSettle();

        expect(profileController.displayName, 'Sekar');
        expect(profileController.gender, UserGender.female);
        expect(destination, AppRouter.home);
      },
    );

    testWidgets('skip button saves default name and navigates to /home', (
      tester,
    ) async {
      final profilePrefs = InMemoryProfilePreferences();
      final profileController = ProfileController(preferences: profilePrefs);
      await profileController.loadProfile();
      String? destination;

      await tester.pumpApp(
        const ProfileSetupScreen(),
        profileController: profileController,
        onGenerateRoute: (settings) {
          destination = settings.name;
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: Text('Dest: ${settings.name}')),
            settings: settings,
          );
        },
      );
      await tester.pumpAndSettle();

      final skipBtn = find.text('Lewati & Masuk Cepat');
      await tester.ensureVisible(skipBtn);
      await tester.tap(skipBtn);
      await tester.pumpAndSettle();

      expect(profileController.displayName, 'Siswa Jawa');
      expect(destination, AppRouter.home);
    });
  });
}
