import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_header.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_streak_block.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_hero_quest_card.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_continue_quiz_card.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_weekly_quiz_strip.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_cultural_wisdom_card.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_quick_learn_section.dart';
import 'package:flutter_jawaloka/core/profile/profile_scope.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import '../helpers/pump_app.dart';

void main() {
  group('HomeScreen Redesign (Tahap B Layout)', () {
    testWidgets(
      'HomeScreen renders new section order without HomeContinueQuizCard',
      (tester) async {
        final prefs = InMemoryProfilePreferences(
          initialDisplayName: 'Dimas',
          initialTotalXP: 650,
          initialStreakDays: 5,
          initialQuizzesThisWeek: 4,
        );
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          ProfileScope(controller: controller, child: const HomeScreen()),
        );
        await tester.pumpAndSettle();

        // 1. Header tanpa kapsul streak
        expect(find.byType(HomeHeader), findsOneWidget);
        expect(find.text('Halo, Dimas!'), findsOneWidget);
        expect(find.text('Level 4'), findsOneWidget);

        // 2. Blok Streak besar baru
        expect(find.byType(HomeStreakBlock), findsOneWidget);
        expect(find.text('5 hari'), findsOneWidget);
        expect(find.text('4 misi selesai minggu ini'), findsOneWidget);

        // 3. Hero Quest Card (disederhanakan untuk anak kecil)
        expect(find.byType(HomeHeroQuestCard), findsOneWidget);
        expect(find.text('LATIHAN HARI INI'), findsOneWidget);
        expect(find.text('3/5'), findsOneWidget);
        expect(find.text('Mulai'), findsOneWidget);
        expect(find.text('Aksara Legena'), findsNothing);
        expect(find.textContaining('Presisi'), findsNothing);
        // 4. Belajar Cepat (ikon + judul saja, tanpa subjudul "3 Tingkat"/"Hanacaraka")
        expect(find.byType(HomeQuickLearnSection), findsOneWidget);
        expect(find.text('3 Tingkat'), findsNothing);
        expect(find.text('Hanacaraka'), findsNothing);
        expect(find.text('Ngoko-Krama'), findsNothing);

        // 5. HomeContinueQuizCard tidak lagi di Beranda
        expect(find.byType(HomeContinueQuizCard), findsNothing);

        // 6. Weekly Strip & Cultural Wisdom Card
        expect(find.byType(HomeWeeklyQuizStrip), findsOneWidget);
        expect(find.byType(HomeCulturalWisdomCard), findsOneWidget);

        // Verifikasi urutan vertikal
        final yStreak = tester.getTopLeft(find.byType(HomeStreakBlock)).dy;
        final yQuest = tester.getTopLeft(find.byType(HomeHeroQuestCard)).dy;
        final yQuick = tester.getTopLeft(find.byType(HomeQuickLearnSection)).dy;
        final yWeekly = tester.getTopLeft(find.byType(HomeWeeklyQuizStrip)).dy;
        final yWisdom = tester
            .getTopLeft(find.byType(HomeCulturalWisdomCard))
            .dy;

        expect(yStreak, lessThan(yQuest));
        expect(yQuest, lessThan(yQuick));
        expect(yQuick, lessThan(yWeekly));
        expect(yWeekly, lessThan(yWisdom));
      },
    );

    testWidgets(
      'HomeStreakBlock falls back to 0 when ProfileScope is absent',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale('id'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('0 hari'), findsOneWidget);
        expect(find.text('0 misi selesai minggu ini'), findsOneWidget);
      },
    );

    testWidgets(
      'Streak, Misi Hari Ini, and Belajar Cepat fit above fold at 360x800 dp',
      (tester) async {
        tester.view.physicalSize = const Size(360 * 2.0, 800 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          ProfileScope(controller: controller, child: const HomeScreen()),
        );
        await tester.pumpAndSettle();

        final quickBottom = tester
            .getBottomLeft(find.byType(HomeQuickLearnSection))
            .dy;
        expect(quickBottom, lessThanOrEqualTo(800));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'HomeScreen has no layout overflows at 360dp width and textScale 1.3',
      (tester) async {
        tester.view.physicalSize = const Size(360 * 2.0, 800 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: ProfileScope(
              controller: controller,
              child: const HomeScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
