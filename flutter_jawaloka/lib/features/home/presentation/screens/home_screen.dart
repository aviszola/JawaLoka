import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/home_weekly_quiz_strip.dart';
import '../widgets/home_hero_quest_card.dart';
import '../widgets/home_continue_quiz_card.dart';
import '../widgets/home_quick_learn_section.dart';
import '../widgets/home_cultural_wisdom_card.dart';

/// Beranda (Home) Screen JawaLoka.
///
/// Desain bersih & modern bernuansa kuning pastel hangat (kuning janur/pare anom)
/// sesuai referensi visual iPhone 16. Seluruh tulisan berkontras tinggi dan mudah dibaca:
/// 1. Header (Avatar, Sapaan & Nama, Level, Kapsul Streak).
/// 2. Kartu Misi Aktif Kuning Pastel (Aksara Misi, Tag Chips, Segmented Progress, Tombol Putih).
/// 3. Kartu Lanjutkan Kuis (Ikon Pastel Kuning, Node Aktif, Progres).
/// 4. Kuis Minggu Ini (7 Lingkaran Hari).
/// 5. Mutiara Piwulang Jawa.
/// 6. Baris Belajar Cepat.
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
              // Header bersih tanpa ilustrasi rumit
              HomeHeader(onNavigateTab: onNavigateTab),

              // Konten Beranda
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Kartu Hero Misi Aktif (Kuning Pastel Hangat)
                    const HomeHeroQuestCard(),
                    const SizedBox(height: 16),

                    // 2. Progres Belajar: Lanjutkan Kuis (Card Putih Ikon Pastel)
                    HomeContinueQuizCard(onNavigateTab: onNavigateTab),
                    const SizedBox(height: 16),

                    // 3. Kebiasaan Belajar: Kuis Minggu Ini (7 Lingkaran Hari)
                    const HomeWeeklyQuizStrip(),
                    const SizedBox(height: 24),

                    // 4. Sentuhan Budaya: Mutiara Piwulang Jawa
                    const HomeCulturalWisdomCard(),
                    const SizedBox(height: 24),

                    // 5. Belajar Cepat: Modul Ringkas
                    HomeQuickLearnSection(onNavigateTab: onNavigateTab),
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
