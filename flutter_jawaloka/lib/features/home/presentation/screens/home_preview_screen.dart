import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../../../splash/presentation/widgets/javanese_glyph_painter.dart';

/// Interactive Home / Dashboard Screen for JawaLoka.
/// Showcases core language learning modules: Ngoko, Krama, and Aksara Jawa.
class HomePreviewScreen extends StatefulWidget {
  const HomePreviewScreen({super.key});

  @override
  State<HomePreviewScreen> createState() => _HomePreviewScreenState();
}

class _HomePreviewScreenState extends State<HomePreviewScreen> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      appBar: AppBar(
        backgroundColor: AppColors.amber,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const JavaneseGlyphWidget(size: 22, color: AppColors.ink),
            ),
            const SizedBox(width: 10),
            const Text(
              'JawaLoka',
              style: TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.local_fire_department, color: AppColors.accentOrange, size: 18),
                SizedBox(width: 4),
                Text(
                  '3 Dina',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background subtle batik accent
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: Container(
              color: AppColors.amber,
              child: CustomPaint(
                painter: BatikKawungPainter(opacity: 0.06),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Javanese Word Banner
                  _buildDailyWordCard(),
                  const SizedBox(height: 20),

                  // Section Title
                  const Text(
                    'Pilihan Sinau (Pilihan Belajar)',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Learning Tracks
                  _buildTrackTile(
                    title: 'Aksara Jawa (Hanacaraka)',
                    subtitle: 'Sinau nulis lan maca 20 aksara dhasar',
                    glyph: 'ꦲ',
                    level: 'Dhasar • 20 Aksara',
                    color: AppColors.amber,
                  ),
                  const SizedBox(height: 12),
                  _buildTrackTile(
                    title: 'Basa Ngoko',
                    subtitle: 'Basa saben dina kanggo kanca & kulawarga',
                    glyph: 'ꦔ',
                    level: 'Tingkat 1 • Pacelathon',
                    color: const Color(0xFFE8F5E9),
                  ),
                  const SizedBox(height: 12),
                  _buildTrackTile(
                    title: 'Krama Alus & Inggil',
                    subtitle: 'Tata krama marang wong tuwa & pinisepuh',
                    glyph: 'ꦏ',
                    level: 'Tingkat 2 • Unggah-ungguh',
                    color: const Color(0xFFFFF3E0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        selectedItemColor: AppColors.accentOrange,
        unselectedItemColor: AppColors.ink.withValues(alpha: 0.45),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Sinau',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            activeIcon: Icon(Icons.edit_note),
            label: 'Aksara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Kamus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildDailyWordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tembung Dina Iki',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.volume_up_rounded, color: AppColors.accentOrange, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Sugeng Enjang',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ • Selamat pagi (Krama)',
            style: TextStyle(
              color: AppColors.ink.withValues(alpha: 0.65),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTile({
    required String title,
    required String subtitle,
    required String glyph,
    required String level,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.ink.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                glyph,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.ink.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  level,
                  style: const TextStyle(
                    color: AppColors.accentOrange,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.ink.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

