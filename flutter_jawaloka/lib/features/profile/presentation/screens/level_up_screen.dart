import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../widgets/blangkon_painter.dart';
import '../widgets/javanese_avatar_widget.dart';

/// JawaLoka - Level Up & New Unlock Screen.
/// Pixel-accurate implementation of Stitch Screen #c515113f3b024dd89f70c06fc8e0ef40.
///
/// Features:
/// - Warm amber celebration background with subtle Kawung batik pattern
/// - Animated confetti particles celebration
/// - Micro-pill tag: "PENCAPAIAN JAWALOKA"
/// - Center hero: Avatar with Radiant Halo Glow wearing Surakarta (Solo) Blangkon
/// - Overlapping "Lv 5" star badge pill
/// - Headline celebration: "Level 5!" & "Blangkon baru terbuka: Blangkon Surakarta"
/// - "Sinau Mandiri V" achievement card with trophy & verified icon
/// - Primary ink CTA: "Pakai Blangkon" and secondary text link: "Nanti saja"
class LevelUpScreen extends StatefulWidget {
  final int newLevel;
  final String blangkonName;
  final BlangkonType blangkonType;

  const LevelUpScreen({
    super.key,
    this.newLevel = 5,
    this.blangkonName = 'Blangkon Surakarta',
    this.blangkonType = BlangkonType.surakarta,
  });

  static const String routeName = '/level-up';

  @override
  State<LevelUpScreen> createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends State<LevelUpScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _confettiCtrl;
  late final AnimationController _entranceCtrl;

  late final Animation<double> _haloScale;
  late final Animation<double> _avatarScale;
  late final Animation<double> _cardSlide;
  late final Animation<double> _fadeAnim;

  final List<_ConfettiItem> _confetti = [];

  @override
  void initState() {
    super.initState();

    // 1. Entrance animation
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _avatarScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    _cardSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    );

    // 2. Halo Glow Pulse animation
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _haloScale = Tween<double>(begin: 0.95, end: 1.12).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // 3. Floating Confetti animation
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _initConfetti();
    _entranceCtrl.forward();
  }

  void _initConfetti() {
    final rng = math.Random(42);
    final colors = [
      const Color(0xFFF6D5CE), // Soft blush
      const Color(0xFFDDD7F6), // Soft lavender
      const Color(0xFFFFDDB5), // Soft orange/peach
      Colors.white,
      AppColors.amberDark,
    ];

    for (int i = 0; i < 24; i++) {
      _confetti.add(_ConfettiItem(
        x: rng.nextDouble(),
        yStart: rng.nextDouble(),
        speed: 0.25 + rng.nextDouble() * 0.45,
        size: 5.0 + rng.nextDouble() * 5.0,
        color: colors[rng.nextInt(colors.length)],
        isCircle: rng.nextBool(),
        rotationSpeed: (rng.nextDouble() - 0.5) * 4,
      ));
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _confettiCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _onEquipBlangkon() {
    HapticFeedback.heavyImpact();
    Navigator.pop(context, true);
  }

  void _onSkip() {
    HapticFeedback.lightImpact();
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.amber,
      body: Stack(
        children: [
          // 1. Subtle Kawung Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: BatikKawungPainter(opacity: 0.035),
            ),
          ),

          // 2. Floating Celebration Confetti
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiCtrl,
              builder: (context, _) {
                return CustomPaint(
                  painter: _CelebrationConfettiPainter(
                    particles: _confetti,
                    progress: _confettiCtrl.value,
                  ),
                );
              },
            ),
          ),

          // 3. Main Content Area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Micro-Pill
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _buildTopMicroTag(),
                  ),

                  // Center Hero Section: Halo, Avatar, Level Pill & Headlines
                  _buildCenterHero(),

                  // Bottom Unlocked Achievement Card & Action Buttons
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: AnimatedBuilder(
                      animation: _cardSlide,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _cardSlide.value),
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          _buildAchievementCard(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                        ],
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

  // ── Top Micro Tag ─────────────────────────────────────────────────────────

  Widget _buildTopMicroTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'PENCAPAIAN JAWALOKA',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ── Center Hero Section ───────────────────────────────────────────────────

  Widget _buildCenterHero() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar Stack with Radiant Halo Glow
        ScaleTransition(
          scale: _avatarScale,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Outer Radiant Halo Glow Rings
              AnimatedBuilder(
                animation: _haloScale,
                builder: (context, _) {
                  return Transform.scale(
                    scale: _haloScale.value,
                    child: Container(
                      width: 195,
                      height: 195,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 36,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Middle Outer Ring
              Container(
                width: 165,
                height: 165,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.08),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),

              // Javanese Avatar wearing Surakarta Blangkon
              JavaneseAvatarWidget(
                size: 130,
                blangkonType: widget.blangkonType,
                backgroundColor: const Color(0xFFFFF9E9),
              ),

              // Sparkle Star Accents
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: AppColors.amberDark,
                  ),
                ),
              ),

              // Overlapping Level Badge Pill at the bottom
              Positioned(
                bottom: -14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppColors.amberDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lv ${widget.newLevel}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Headline Celebration Text
        Text(
          'Level ${widget.newLevel}!',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            children: [
              const TextSpan(text: 'Blangkon baru terbuka: '),
              TextSpan(
                text: widget.blangkonName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Achievement Unlocked Card ─────────────────────────────────────────────

  Widget _buildAchievementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Trophy Icon Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.amberSoft,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.5)),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 26,
              color: AppColors.amberDark,
            ),
          ),
          const SizedBox(width: 14),

          // Middle: Titles
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LENCANA BARU',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Sinau Mandiri V',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Menyelesaikan 25 bab materi aksara',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),

          // Right: Verified Checkmark
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.canvas,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.verified_rounded,
              size: 18,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary Filled Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _onEquipBlangkon,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 4,
              shadowColor: AppColors.ink.withValues(alpha: 0.3),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pakai Blangkon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Secondary Text Button
        TextButton(
          onPressed: _onSkip,
          child: const Text(
            'Nanti saja',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.inkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Confetti Particle Helper ──────────────────────────────────────────────────

class _ConfettiItem {
  final double x;
  final double yStart;
  final double speed;
  final double size;
  final Color color;
  final bool isCircle;
  final double rotationSpeed;

  _ConfettiItem({
    required this.x,
    required this.yStart,
    required this.speed,
    required this.size,
    required this.color,
    required this.isCircle,
    required this.rotationSpeed,
  });
}

class _CelebrationConfettiPainter extends CustomPainter {
  final List<_ConfettiItem> particles;
  final double progress;

  _CelebrationConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = ((p.yStart + progress * p.speed) % 1.2) * size.height;
      final x = p.x * size.width;

      final paint = Paint()..color = p.color.withValues(alpha: 0.85);

      if (p.isCircle) {
        canvas.drawCircle(Offset(x, y), p.size / 2, paint);
      } else {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(progress * p.rotationSpeed * math.pi);
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.7),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

