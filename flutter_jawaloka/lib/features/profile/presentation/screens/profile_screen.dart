import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../../../../core/presentation/widgets/wayang_gunungan_painter.dart';
import '../../../../core/presentation/widgets/javanese_calligraphy_painter.dart';
import '../widgets/blangkon_painter.dart';
import '../widgets/javanese_avatar_widget.dart';
import 'level_up_screen.dart';
import '../../../../core/mock/mock_user_stats.dart';

/// JawaLoka - Profile (Profil) Screen.
/// Pixel-accurate implementation of Stitch Screen #e5a2d70abae2486ebdec67b521794944.
///
/// Features:
/// - Top bar with gear settings icon button
/// - Amber Hero Card with faint Kawung background texture
/// - Avatar with 75% circular progress ring, cute Javanese character, and edit button
/// - Inline editable name (Dimas)
/// - Three status pills: Level 4, Streak 5 hari, 8 Kuis Minggu Ini
/// - 4-badge achievement collection grid (Streak 7 Hari, Streak 30 Hari, Level 5, Tamat Aksara)
/// - Primary ink button: "Pilih Blangkon" leading to customization catalog
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String _displayName = MockUserStats.userName;
  bool _isEditingName = false;
  final TextEditingController _nameCtrl = TextEditingController(text: MockUserStats.userName);
  String? _nameError;

  BlangkonType _equippedBlangkon = BlangkonType.yogyakarta;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOutCubic,
    ));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _saveName() {
    final text = _nameCtrl.text.trim();
    if (text.isEmpty) {
      setState(() => _nameError = 'Nama tidak boleh kosong');
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      _displayName = text;
      _nameError = null;
      _isEditingName = false;
    });

    HapticFeedback.mediumImpact();
    _showToast('Nama berhasil disimpan: $text');
  }

  void _cancelEditName() {
    setState(() {
      _nameCtrl.text = _displayName;
      _nameError = null;
      _isEditingName = false;
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroCard(),
                        const SizedBox(height: 20),
                        _buildBadgeSection(),
                        const SizedBox(height: 24),
                        _buildBlangkonButton(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 1. Top Bar ────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profil',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.5,
            ),
          ),
          // Gear Settings Button
          Semantics(
            label: 'Pengaturan',
            button: true,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, AppRouter.settings);
              },
              child: Container(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                alignment: Alignment.center,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    size: 21,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Amber Hero Card ───────────────────────────────────────────────────

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 260),
      decoration: BoxDecoration(
        color: AppColors.amber,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFECC258)),
        boxShadow: [
          BoxShadow(
            color: AppColors.amber.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Faint Kawung Texture Background (opacity <= 0.04)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: BatikKawungPainter(opacity: 0.035),
                ),
              ),
            ),
          ),

          // Soft Top Glow Accent
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),

          // Main Card Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with Progress Ring
                JavaneseAvatarWidget(
                  size: 92,
                  blangkonType: _equippedBlangkon,
                  progress: 0.75, // Level 4 towards Level 5 (75%)
                  showEditButton: true,
                  onEditTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pushNamed(context, AppRouter.chooseBlangkon)
                        .then((val) {
                      if (val is BlangkonType) {
                        setState(() => _equippedBlangkon = val);
                      }
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Name Area (View Mode or Inline Edit)
                if (!_isEditingName) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingName = true;
                        _nameCtrl.text = _displayName;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _displayName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: AppColors.ink,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 36,
                        child: TextField(
                          controller: _nameCtrl,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.ink, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.ink, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _saveName,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _cancelEditName,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_nameError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _nameError!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 14),

                // Status Pills: Lv 4, Streak 5 hari, and 8 Kuis Minggu Ini
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: AppColors.amberDark),
                          SizedBox(width: 6),
                          Text(
                            'Lv ${MockUserStats.userLevel}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 16,
                            color: Color(0xFFF26522),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Streak ${MockUserStats.streakDays} hari',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.quiz_outlined,
                            size: 16,
                            color: AppColors.amberDark,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${MockUserStats.quizzesThisWeek} Kuis Minggu Ini',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Section Lencana ───────────────────────────────────────────────────

  Widget _buildBadgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Lencana',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.pastelSand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '1 / 4 Terbuka',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Koleksi Prestasi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Grid of 4 Achievement Badges
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 20) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Badge 1: Streak 7 Hari (Unlocked)
                _buildBadgeCard(
                  width: cardWidth,
                  title: 'Streak 7 Hari',
                  statusLabel: 'Terbuka',
                  isUnlocked: true,
                  bgColor: AppColors.pastelBlush,
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF26522),
                  onTap: () => _showToast('Lencana Streak 7 Hari telah terbuka!'),
                ),

                // Badge 2: Streak 30 Hari (Locked)
                _buildBadgeCard(
                  width: cardWidth,
                  title: 'Streak 30 Hari',
                  statusLabel: 'Terkunci',
                  isUnlocked: false,
                  bgColor: AppColors.pastelSand,
                  icon: Icons.lock_rounded,
                  iconColor: AppColors.inkMuted,
                  onTap: () => _showToast('Pertahankan streak 30 hari untuk membuka lencana ini!'),
                ),

                // Badge 3: Level 5 (Locked - tap to preview Level Up!)
                _buildBadgeCard(
                  width: cardWidth,
                  title: 'Level 5',
                  statusLabel: 'Terkunci',
                  isUnlocked: false,
                  bgColor: AppColors.pastelMint,
                  icon: Icons.emoji_events_rounded,
                  iconColor: AppColors.pastelMintText,
                  customIconWidget: const WayangGununganWidget(
                    width: 24,
                    height: 28,
                    style: GununganStyle.goldOutline,
                  ),
                  badgeHighlight: 'Naik Level',
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LevelUpScreen(),
                      ),
                    ).then((result) {
                      if (result == true) {
                        setState(() => _equippedBlangkon = BlangkonType.surakarta);
                        _showToast('Blangkon Surakarta berhasil dipasang!');
                      }
                    });
                  },
                ),

                // Badge 4: Tamat Aksara (Locked)
                _buildBadgeCard(
                  width: cardWidth,
                  title: 'Tamat Aksara',
                  statusLabel: 'Tingkat Mudah',
                  isUnlocked: false,
                  bgColor: AppColors.pastelLavender,
                  icon: Icons.auto_stories_rounded,
                  iconColor: AppColors.inkMuted,
                  customIconWidget: const CustomPaint(
                    size: Size(22, 22),
                    painter: JavaneseCalligraphyPainter(
                      aksara: 'ꦲ',
                      inkColor: AppColors.inkMuted,
                      strokeThickness: 3.5,
                      showInkPools: false,
                    ),
                  ),
                  onTap: () => _showToast('Selesaikan seluruh modul aksara dasar untuk membuka!'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required double width,
    required String title,
    required String statusLabel,
    required bool isUnlocked,
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
    Widget? customIconWidget,
    String? badgeHighlight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? AppColors.amber.withValues(alpha: 0.5)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Circular Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.06),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: customIconWidget ??
                    Icon(icon, size: 20, color: iconColor),
              ),
            ),

            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isUnlocked ? FontWeight.w800 : FontWeight.w700,
                    color: isUnlocked ? AppColors.ink : AppColors.inkMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeHighlight ?? statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isUnlocked
                          ? const Color(0xFFD9534F)
                          : AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── 4. Primary Button: Pilih Blangkon ────────────────────────────────────

  Widget _buildBlangkonButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pushNamed(context, AppRouter.chooseBlangkon).then((val) {
            if (val is BlangkonType) {
              setState(() => _equippedBlangkon = val);
            }
          });
        },
        icon: const Icon(Icons.style_outlined, size: 20, color: AppColors.amber),
        label: const Text(
          'Pilih Blangkon',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: AppColors.ink.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
