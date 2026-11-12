import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/home_streak_block.dart';
import '../widgets/home_hero_quest_card.dart';
import '../widgets/home_quick_learn_section.dart';
import '../widgets/home_weekly_quiz_strip.dart';
import '../widgets/home_cultural_wisdom_card.dart';

/// Beranda (Home) Screen JawaLoka.
///
/// Urutan ringkas (Tahap B):
/// 1. Header (Avatar, Sapaan & Nama, Level pill).
/// 2. Blok Streak besar (angka hari `displayLarge`, ikon api `accentOrange`, 1 baris jumlah kuis).
/// 3. Kartu Misi Hari Ini (`HomeHeroQuestCard`).
/// 4. Seksi Belajar Cepat (`HomeQuickLearnSection`, ikon + judul saja).
/// 5. Aktivitas Minggu Ini (`HomeWeeklyQuizStrip`, 7 lingkaran hari).
/// 6. Mutiara Piwulang Jawa (`HomeCulturalWisdomCard`, ringkas di paling bawah).
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
              // Header bersih tanpa kapsul streak
              HomeHeader(onNavigateTab: onNavigateTab),

              // Konten Beranda sesuai urutan baru
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Blok Streak Besar Baru
                    HomeStreakBlock(onNavigateTab: onNavigateTab),
                    const SizedBox(height: 12),

                    // 2. Kartu Misi Hari Ini
                    const HomeHeroQuestCard(),
                    const SizedBox(height: 14),

                    // 3. Belajar Cepat (menggantikan Lanjutkan Kuis)
                    HomeQuickLearnSection(onNavigateTab: onNavigateTab),
                    const SizedBox(height: 16),

                    // 4. Aktivitas Minggu Ini (7 Lingkaran Hari)
                    const HomeWeeklyQuizStrip(),
                    const SizedBox(height: 16),

                    // 5. Mutiara Piwulang Jawa (ringkas, paling bawah)
                    const HomeCulturalWisdomCard(),
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
