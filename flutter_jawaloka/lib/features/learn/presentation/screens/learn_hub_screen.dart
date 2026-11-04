import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../widgets/animated_progress_ring.dart';
import '../widgets/module_card.dart';
import 'vocabulary_detail_screen.dart';
import 'aksara_detail_screen.dart';

/// Learning Hub – the main screen for all learning paths in JawaLoka.
///
/// Route name: `/learn`
class LearnHubScreen extends StatefulWidget {
  const LearnHubScreen({super.key});

  static const routeName = '/learn';

  @override
  State<LearnHubScreen> createState() => _LearnHubScreenState();
}

class _LearnHubScreenState extends State<LearnHubScreen>
    with TickerProviderStateMixin {
  int _selectedNavIndex = 1; // "Belajar" tab active

  late final AnimationController _greetingCtrl;
  late final Animation<double> _greetingFade;

  final List<_DailyWord> _dailyWords = const [
    _DailyWord(
        javanese: 'Omah',
        aksara: 'ꦲꦺꦴꦩꦃ',
        indonesian: 'Rumah',
        level: 'Ngoko'),
    _DailyWord(
        javanese: 'Banyu',
        aksara: 'ꦧꦤꦾꦸ',
        indonesian: 'Air',
        level: 'Ngoko'),
    _DailyWord(
        javanese: 'Segara',
        aksara: 'ꦱꦼꦒꦫ',
        indonesian: 'Laut',
        level: 'Krama'),
    _DailyWord(
        javanese: 'Lemah',
        aksara: 'ꦭꦼꦩꦃ',
        indonesian: 'Tanah',
        level: 'Ngoko'),
    _DailyWord(
        javanese: 'Langit',
        aksara: 'ꦭꦁꦒꦶꦠ꧀',
        indonesian: 'Langit',
        level: 'Ngoko'),
  ];

  static const List<ModuleCardData> _modules = [
    ModuleCardData(
      id: 'aksara',
      title: 'Aksara Jawa Dhasar',
      subtitle: 'Hanacaraka — 20 aksara dasar',
      iconGlyph: 'ꦲ',
      bgColor: AppColors.amberSoft,
      progress: 0.65,
      progressLabel: '20 aksara',
      tag: '65%',
    ),
    ModuleCardData(
      id: 'pacelathon',
      title: 'Pacelathon Ngoko',
      subtitle: 'Percakapan sehari-hari bahasa Ngoko',
      iconData: Icons.chat_bubble_outline_rounded,
      bgColor: AppColors.pastelMint,
      iconTextColor: AppColors.pastelMintText,
      progress: 0.32,
      progressLabel: '15 dialog',
    ),
    ModuleCardData(
      id: 'krama',
      title: 'Krama Alus & Inggil',
      subtitle: 'Unggah-ungguh & tata krama resmi',
      iconData: Icons.menu_book_rounded,
      bgColor: AppColors.pastelLavender,
      iconTextColor: AppColors.pastelLavenderText,
      progress: 0.10,
      progressLabel: '12 bab',
    ),
    ModuleCardData(
      id: 'budaya',
      title: 'Sejarah & Budaya',
      subtitle: 'Wayang, gamelan, filosofi Jawa',
      iconData: Icons.history_edu_rounded,
      bgColor: AppColors.pastelBlush,
      iconTextColor: AppColors.pastelBlushText,
      progress: 0,
      progressLabel: 'Segera hadir',
      isLocked: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _greetingCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _greetingFade =
        CurvedAnimation(parent: _greetingCtrl, curve: Curves.easeOut);
    _greetingCtrl.forward();
  }

  @override
  void dispose() {
    _greetingCtrl.dispose();
    super.dispose();
  }

  void _onModuleTap(ModuleCardData data) {
    if (data.isLocked) {
      _showLockedSnackbar();
      return;
    }
    if (data.id == 'aksara') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AksaraDetailScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VocabularyDetailScreen()),
      );
    }
  }

  void _showLockedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '🔒 Selesaikan jalur sebelumnya untuk membuka modul ini!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.ink,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amber hero header with batik texture
            _buildHeroHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Today's Progress card
                  _buildProgressCard(),
                  const SizedBox(height: 24),

                  // Quick actions strip
                  _buildQuickActions(),
                  const SizedBox(height: 28),

                  // Module section
                  _buildSectionHeader('Jalur Belajarmu', Icons.route_rounded),
                  const SizedBox(height: 14),
                  ..._modules.map(
                    (m) => ModuleCard(data: m, onTap: () => _onModuleTap(m)),
                  ),

                  const SizedBox(height: 28),

                  // Daily challenge card
                  _buildDailyChallengeCard(),
                  const SizedBox(height: 28),

                  // Tembung Dina Iki carousel
                  _buildSectionHeader(
                      'Tembung Dina Iki', Icons.translate_rounded),
                  const SizedBox(height: 14),
                  _buildWordCarousel(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.amber,
      elevation: 0,
      toolbarHeight: 0,
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.amber,
      child: Stack(
        children: [
          // Batik kawung texture overlay
          Positioned.fill(
            child: CustomPaint(
              painter: BatikKawungPainter(opacity: 0.08),
            ),
          ),
          // Parang diagonal accent (top-right)
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.07,
              child: CustomPaint(
                size: const Size(130, 130),
                painter: _ParangPatternPainter(),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  FadeTransition(
                    opacity: _greetingFade,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Selamat pagi, Dimas!',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Streak badge & Avatar
                  _StreakBadge(days: 3),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRouter.profile),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🎭', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Sugeng enjang ☀️';
    if (hour < 15) return 'Sugeng siang 🌤️';
    if (hour < 18) return 'Sugeng sonten 🌅';
    return 'Sugeng dalu 🌙';
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedProgressRing(
            progress: 0.68,
            size: 80,
            strokeWidth: 9,
            progressColor: AppColors.amberDark,
            duration: const Duration(milliseconds: 1500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '68%',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress Hari Ini',
                  style: TextStyle(
                    color: AppColors.inkSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Terus belajar! 💪',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _StatChip(icon: Icons.local_fire_department_rounded,
                        label: '3 Dina', color: AppColors.accentOrange),
                    const SizedBox(width: 8),
                    _StatChip(icon: Icons.star_rounded,
                        label: '124 XP', color: AppColors.amberDark),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.menu_book_rounded,
        label: 'Kamus',
        color: AppColors.pastelSand,
        iconColor: AppColors.amberDark,
        onTap: () => Navigator.pushNamed(context, AppRouter.vocabularyDetail),
      ),
      _QuickAction(
        icon: Icons.translate_rounded,
        label: 'Penerjemah',
        color: AppColors.pastelMint,
        iconColor: AppColors.pastelMintText,
        onTap: () => Navigator.pushNamed(context, AppRouter.translator),
      ),
      _QuickAction(
        icon: Icons.edit_note_rounded,
        label: 'Latihan',
        color: AppColors.pastelLavender,
        iconColor: AppColors.pastelLavenderText,
        onTap: () => Navigator.pushNamed(context, AppRouter.quizPath),
      ),
    ];

    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _QuickActionCard(action: a),
              ),
            ),
          )
          .toList()
        ..last = Expanded(
          child: _QuickActionCard(action: actions.last),
        ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.amberDark),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChallengeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.amber, AppColors.amberDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.amberDark.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                size: const Size(80, 80),
                painter: _ParangPatternPainter(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      '⚡ Tantangan Hari Ini',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Tulis aksara',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'ꦤꦒ',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
              const Text(
                '"Na + Ga" — Naga (Naga/Ular)',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const AksaraDetailScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    'Mulai Tantangan →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordCarousel() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dailyWords.length,
        itemBuilder: (context, i) {
          final w = _dailyWords[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VocabularyDetailScreen(word: w.javanese)),
            ),
            child: Container(
              width: 140,
              margin: EdgeInsets.only(right: i < _dailyWords.length - 1 ? 12 : 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.pastelSand,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      w.level,
                      style: const TextStyle(
                        color: AppColors.amberDark,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    w.javanese,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    w.aksara,
                    style: const TextStyle(
                      color: AppColors.amberDark,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    w.indonesian,
                    style: const TextStyle(
                      color: AppColors.inkSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (i) {
            setState(() => _selectedNavIndex = i);
            if (i == 1) {
              Navigator.pushNamed(context, AppRouter.quizPath);
            } else if (i == 2) {
              Navigator.pushNamed(context, AppRouter.translator);
            } else if (i == 3) {
              Navigator.pushNamed(context, AppRouter.profile);
            }
          },
          selectedItemColor: AppColors.accentOrange,
          unselectedItemColor: AppColors.inkMuted,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school_rounded),
              label: 'Belajar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'Kamus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting data classes
// ─────────────────────────────────────────────────────────────────────────────

class _DailyWord {
  final String javanese;
  final String aksara;
  final String indonesian;
  final String level;
  const _DailyWord(
      {required this.javanese,
      required this.aksara,
      required this.indonesian,
      required this.level});
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.onTap,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StreakBadge extends StatelessWidget {
  final int days;
  const _StreakBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: AppColors.accentOrange, size: 18),
          const SizedBox(width: 4),
          Text(
            '$days Dina',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: action.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, color: action.iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: TextStyle(
                color: action.iconColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Parang diagonal wave pattern (CustomPainter accent).
class _ParangPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double x = -size.height; x < size.width + size.height; x += 20) {
      final path = Path()..moveTo(x, 0);
      for (double y = 0; y < size.height; y += 10) {
        path.relativeQuadraticBezierTo(10, 5, 20, 0);
        path.relativeQuadraticBezierTo(10, -5, 20, 0);
        path.relativeLineTo(0, 10);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_ParangPatternPainter _) => false;
}
