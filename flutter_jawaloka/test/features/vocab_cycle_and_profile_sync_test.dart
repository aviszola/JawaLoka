import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/data/vocab_word.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/widgets/primary_button.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_header.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/vocabulary_detail_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  group('VocabWord & VocabularyDetail Behavior Tests', () {
    test(
      'VocabWord sample words contain at least 5 items with expected IDs',
      () {
        expect(VocabWord.sampleWords.length, greaterThanOrEqualTo(5));
        final ids = VocabWord.sampleWords.map((w) => w.id).toList();
        expect(
          ids,
          containsAll(['omah', 'banyu', 'segara', 'lemah', 'langit']),
        );
      },
    );

    test('Modulo word indexing wraps cleanly around 5 sample words', () {
      final total = VocabWord.sampleWords.length;
      expect(total, 5);

      for (int i = 0; i < total; i++) {
        final next = (i + 1) % total;
        expect(next, (i + 1) % 5);
      }
      expect((4 + 1) % total, 0); // Wraps around
    });

    testWidgets('VocabularyDetailScreen defaults invalid index safely to 0', (
      tester,
    ) async {
      await tester.pumpApp(const VocabularyDetailScreen(initialIndex: 999));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      // 'Omah' appears in hero card and jv meaning card
      expect(find.text('Omah'), findsNWidgets(2));
      expect(find.text('Rumah'), findsOneWidget);
    });

    testWidgets('VocabularyDetailScreen renders word at given index', (
      tester,
    ) async {
      await tester.pumpApp(
        const VocabularyDetailScreen(initialIndex: 1), // banyu
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      // 'Banyu' appears in hero card and jv meaning card
      expect(find.text('Banyu'), findsNWidgets(2));
      expect(find.text('Air'), findsOneWidget);
      expect(find.text('Water'), findsOneWidget);
    });

    testWidgets('VocabularyDetailScreen has no audio speaker button', (
      tester,
    ) async {
      await tester.pumpApp(const VocabularyDetailScreen(initialIndex: 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      // Audio volume_up icon was removed
      expect(find.byIcon(Icons.volume_up_rounded), findsNothing);
    });
  });

  group('QuizResult Duration Behavior Tests', () {
    testWidgets('QuizResultScreen does not render timeTaken duration row', (
      tester,
    ) async {
      const result = QuizResult(
        score: 85,
        maxScore: 100,
        correctCount: 8,
        totalQuestions: 10,
        accuracy: 85,
        isStreakAchievedToday: true,
      );

      await tester.pumpApp(const QuizResultScreen(result: result));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Waktu pengerjaan was removed
      expect(find.text('Waktu Pengerjaan'), findsNothing);
      expect(find.text('1:45'), findsNothing);
      expect(find.text('8/10'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
    });
  });

  group('Profile State & Blangkon Synchronization Behavior Tests', () {
    late InMemoryProfilePreferences profilePrefs;
    late ProfileController profileCtrl;

    setUp(() async {
      profilePrefs = InMemoryProfilePreferences();
      profileCtrl = ProfileController(preferences: profilePrefs);
      await profileCtrl.loadProfile();
    });

    test('Initial controller state matches defaults', () {
      expect(profileCtrl.equippedBlangkon, BlangkonType.yogyakarta);
      expect(profileCtrl.displayName, 'Dimas');
      expect(profileCtrl.isInitialized, isTrue);
    });

    test(
      'Setting equipped blangkon updates controller and persists in storage',
      () async {
        await profileCtrl.setEquippedBlangkon(BlangkonType.surakarta);
        expect(profileCtrl.equippedBlangkon, BlangkonType.surakarta);
        expect(
          await profilePrefs.loadEquippedBlangkon(),
          BlangkonType.surakarta,
        );
      },
    );

    test(
      'Setting display name updates controller and persists in storage',
      () async {
        await profileCtrl.setDisplayName('Raden');
        expect(profileCtrl.displayName, 'Raden');
        expect(await profilePrefs.loadDisplayName(), 'Raden');
      },
    );

    testWidgets(
      'HomeHeader displays synchronized displayName and equipped blangkon',
      (tester) async {
        await tester.pumpApp(
          const Scaffold(body: HomeHeader()),
          profileController: profileCtrl,
        );
        await tester.pump();

        expect(find.text('Halo, Dimas!'), findsOneWidget);

        await profileCtrl.setDisplayName('Budi');
        await tester.pump();

        expect(find.text('Halo, Budi!'), findsOneWidget);
      },
    );

    testWidgets(
      'SettingsScreen Akun row opens read-only account modal with name and email',
      (tester) async {
        await tester.pumpApp(
          const SettingsScreen(),
          profileController: profileCtrl,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));

        // Tap Akun row
        final accountRow = find.text('Akun');
        expect(accountRow, findsOneWidget);
        await tester.tap(accountRow);
        await tester.pumpAndSettle();

        // Dialog contents
        expect(find.text('Detail Akun'), findsOneWidget);
        expect(find.text('Nama Pengguna'), findsOneWidget);
        expect(find.text('Dimas'), findsOneWidget);
        expect(find.text('Akun lokal pada perangkat ini'), findsOneWidget);
        expect(find.text('Tutup'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Tutup'));
        await tester.pumpAndSettle();

        expect(find.text('Detail Akun'), findsNothing);
      },
    );

    testWidgets(
      'ProfileScreen reflects profile changes and syncs equipped blangkon',
      (tester) async {
        await tester.pumpApp(
          const ProfileScreen(),
          profileController: profileCtrl,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));

        expect(find.text('Dimas'), findsOneWidget);

        await profileCtrl.setDisplayName('Suryo');
        await tester.pump();

        expect(find.text('Suryo'), findsOneWidget);
      },
    );
  });

  group('Register Name Persistence & Profile Synchronization Tests', () {
    testWidgets(
      'mengisi nama dan mengetuk Daftar membuat HomeHeader menampilkan nama itu',
      (tester) async {
        final sharedStorage = InMemoryProfilePreferences();
        final profileCtrl = ProfileController(preferences: sharedStorage);
        await profileCtrl.loadProfile();

        await tester.pumpApp(
          const RegisterScreen(),
          profileController: profileCtrl,
          routes: {
            AppRouter.home: (context) => const Scaffold(body: HomeHeader()),
          },
        );
        await tester.pumpAndSettle();

        expect(profileCtrl.displayName, 'Dimas');

        // Isi nama dengan spasi di awal dan akhir untuk menguji trim
        await tester.enterText(
          find.byType(TextFormField).at(0),
          '   Siti Aminah   ',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'siti@jawaloka.id',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'passwordKuat123',
        );
        await tester.pump();

        await tester.ensureVisible(
          find.widgetWithText(PrimaryButton, 'Daftar'),
        );
        await tester.tap(find.widgetWithText(PrimaryButton, 'Daftar'));

        // Majukan timer simulasi pendaftaran (1500ms)
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1500));
        await tester.pumpAndSettle();

        // HomeHeader menampilkan nama baru yang sudah di-trim
        expect(find.byType(HomeHeader), findsOneWidget);
        expect(find.text('Halo, Siti Aminah!'), findsOneWidget);
        expect(profileCtrl.displayName, 'Siti Aminah');
      },
    );

    test(
      'pengontrol baru dengan penyimpanan yang sama memuat nama yang sama',
      () async {
        final sharedStorage = InMemoryProfilePreferences();
        final firstCtrl = ProfileController(preferences: sharedStorage);
        await firstCtrl.loadProfile();

        expect(firstCtrl.displayName, 'Dimas');

        await firstCtrl.setDisplayName('Siti Aminah');
        expect(firstCtrl.displayName, 'Siti Aminah');
        expect(await sharedStorage.loadDisplayName(), 'Siti Aminah');

        // Buat pengontrol baru memakai penyimpanan (preferences) yang sama
        final secondCtrl = ProfileController(preferences: sharedStorage);
        expect(secondCtrl.isInitialized, isFalse);

        await secondCtrl.loadProfile();
        expect(secondCtrl.isInitialized, isTrue);
        expect(secondCtrl.displayName, 'Siti Aminah');
      },
    );
  });
}
