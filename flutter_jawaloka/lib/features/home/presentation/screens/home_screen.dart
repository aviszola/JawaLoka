import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/home_weekly_quiz_strip.dart';
import '../widgets/home_hero_quest_card.dart';
import '../widgets/home_continue_quiz_card.dart';
import '../widgets/home_quick_learn_section.dart';

/// Beranda (Home) Screen for JawaLoka.
///
/// Features:
/// 1. Sapaan & avatar (Dimas, Level 4, avatar with equipped blangkon).
/// 2. Strip minggu (7 hari, menandai hari kuis selesai: Sen–Jum).
/// 3. Kartu hero Misi Hari Ini (satu tombol utama pill gelap "Mulai Menggambar").
/// 4. Kartu "Lanjutkan Kuis" (status node kuis aktif).
/// 5. Baris "Belajar Cepat" (pilihan materi ringkas).
class HomeScreen extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(onNavigateTab: onNavigateTab),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Strip Minggu (Hari Kuis Selesai)
                    const HomeWeeklyQuizStrip(),
                    const SizedBox(height: 20),

                    // 2. Kartu Hero Misi Hari Ini (Satu Tombol Utama Pill Gelap)
                    const HomeHeroQuestCard(),
                    const SizedBox(height: 20),

                    // 3. Kartu Lanjutkan Kuis
                    HomeContinueQuizCard(onNavigateTab: onNavigateTab),
                    const SizedBox(height: 24),

                    // 4. Baris Belajar Cepat
                    HomeQuickLearnSection(onNavigateTab: onNavigateTab),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
