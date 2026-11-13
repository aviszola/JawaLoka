import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/theme/app_icons.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/profile_setup_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  group('ProfileSetupScreen Nickname Field Size & Responsiveness', () {
    testWidgets(
      'Lebar 360 dp x tinggi 640 dp dengan textScaler 1.3: tidak overflow dan tinggi kolom minimal 56 dp',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        await tester.pumpApp(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.3),
              ),
              child: const ProfileSetupScreen(),
            ),
          ),
          profileController: profileController,
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);

        final fieldFinder = find.byType(TextFormField);
        expect(fieldFinder, findsOneWidget);

        final size = tester.getSize(fieldFinder);
        expect(size.height, greaterThanOrEqualTo(56.0),
            reason: 'Tinggi kolom minimal 56 dp');

        final icon = tester.widget<Icon>(find.byIcon(AppIcons.person));
        expect(icon.size, equals(24.0),
            reason: 'Ukuran ikon sebelah kiri harus 24 dp');

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.style?.fontSize, equals(18.0),
            reason: 'Ukuran huruf isi kolom harus 18 sp');
      },
    );

    testWidgets(
      'Skala teks ekstrim 1.5 pada 360 dp tidak menimbulkan overflow dan kolom tetap proporsional',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        await tester.pumpApp(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.5),
              ),
              child: const ProfileSetupScreen(),
            ),
          ),
          profileController: profileController,
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);

        final fieldFinder = find.byType(TextFormField);
        expect(fieldFinder, findsOneWidget);

        final size = tester.getSize(fieldFinder);
        expect(size.height, greaterThanOrEqualTo(56.0));
      },
    );

    testWidgets(
      'Teks panjang 30 karakter dapat dimasukkan tanpa terpotong dan tanpa overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        await tester.pumpApp(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.3),
              ),
              child: const ProfileSetupScreen(),
            ),
          ),
          profileController: profileController,
        );
        await tester.pumpAndSettle();

        const longName30 = 'Raden Mas Dimas Suryoputro Bro';
        expect(longName30.length, equals(30));

        final fieldFinder = find.byType(TextField);
        await tester.enterText(fieldFinder, longName30);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(longName30), findsOneWidget);
      },
    );

    testWidgets(
      'Keyboard muncul (viewInsets 300) dan kolom tetap dapat di-scroll dan terlihat',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final profilePrefs = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        await tester.pumpApp(
          const ProfileSetupScreen(),
          profileController: profileController,
        );
        await tester.pumpAndSettle();

        // Simulasi keyboard muncul setinggi 300 dp
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();

        final fieldFinder = find.byType(TextField);
        await tester.ensureVisible(fieldFinder);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(fieldFinder, findsOneWidget);
      },
    );
  });
}
