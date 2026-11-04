import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

// ─────────────────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────────────────

class QuizResult {
  final int score;
  final int maxScore;
  final int xpEarned;
  final String timeTaken; // e.g. "2:34"
  final int accuracy; // percentage 0–100

  const QuizResult({
    required this.score,
    required this.maxScore,
    required this.xpEarned,
    required this.timeTaken,
    required this.accuracy,
  });

  double get scoreRatio => score / maxScore;
  int get stars => score >= 90 ? 3 : score >= 70 ? 2 : 1;
}

// ─────────────────────────────────────────────────────────
//  CONFETTI PARTICLE
// ─────────────────────────────────────────────────────────

class _ConfettiParticle {
  final double x;      // 0.0 – 1.0 horizontal start
  final double yStart; // 0.0 – 1.0 vertical start (can be negative)
  final double speed;  // vertical speed multiplier
  final double size;
  final Color color;
  final bool isCircle;

  const _ConfettiParticle({
    required this.x,
    required this.yStart,
    required this.speed,
    required this.size,
    required this.color,
    required this.isCircle,
  });
}

// ─────────────────────────────────────────────────────────
//  CONFETTI PAINTER
// ─────────────────────────────────────────────────────────

class _ConfettiPainter extends CustomPainter {
  final double animValue; // 0.0 – 1.0
  final List<_ConfettiParticle> particles;

  static const List<Color> _confettiColors = [
    AppColors.amber,
    AppColors.pastelMint,
    AppColors.pastelLavender,
    AppColors.pastelBlush,
    Colors.white,
    AppColors.accentOrange,
  ];

  const _ConfettiPainter({
    required this.animValue,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final double y = (p.yStart + animValue * p.speed) % 1.2;
      final double x = p.x;
      // fade out near bottom
      final double opacity = y > 0.8 ? (1.0 - (y - 0.8) / 0.4).clamp(0.0, 1.0) : 1.0;
      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = p.color.withOpacity(opacity * 0.85)
        ..style = PaintingStyle.fill;

      final cx = x * size.width;
      final cy = y * size.height;

      if (p.isCircle) {
        canvas.drawCircle(Offset(cx, cy), p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.animValue != animValue;
}

// ─────────────────────────────────────────────────────────
//  SCORE RING PAINTER
// ─────────────────────────────────────────────────────────

class _ScoreRingPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;

  const _ScoreRingPainter({
    required this.progress,
    this.activeColor = AppColors.amber,
    this.trackColor = AppColors.border,
    this.strokeWidth = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active arc
    if (progress > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,            // start at top
        2 * pi * progress,  // sweep
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────────────────

class QuizResultScreen extends StatefulWidget {
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    this.result = const QuizResult(
      score: 85,
      maxScore: 100,
      xpEarned: 150,
      timeTaken: '2:34',
      accuracy: 85,
    ),
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  // Confetti animation
  late final AnimationController _confettiController;
  late final List<_ConfettiParticle> _confettiParticles;

  // Score ring animation
  late final AnimationController _ringController;
  late final Animation<double> _ringAnim;

  // Card slide-up animation
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;

  // Star pop-in animations (3 stars)
  late final List<AnimationController> _starControllers;
  late final List<Animation<double>> _starScaleAnims;

  final Random _random = Random(42);

  @override
  void initState() {
    super.initState();

    // Confetti
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _confettiParticles = List.generate(30, (i) {
      final colors = _ConfettiPainter._confettiColors;
      return _ConfettiParticle(
        x: _random.nextDouble(),
        yStart: _random.nextDouble() * -0.5 - 0.1,
        speed: 0.5 + _random.nextDouble() * 0.8,
        size: 6 + _random.nextDouble() * 10,
        color: colors[_random.nextInt(colors.length)],
        isCircle: _random.nextBool(),
      );
    });

    // Score ring
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _ringAnim = Tween<double>(begin: 0, end: widget.result.scoreRatio).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );

    // Card slide-up
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    // Stars – 3 controllers with staggered delays
    _starControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _starScaleAnims = _starControllers.map((ctrl) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.elasticOut),
      );
    }).toList();

    // Start sequence
    _slideController.forward().then((_) {
      _ringController.forward();
      _startStarsSequence();
    });
  }

  Future<void> _startStarsSequence() async {
    final stars = widget.result.stars;
    for (int i = 0; i < stars; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) _starControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _ringController.dispose();
    _slideController.dispose();
    for (final c in _starControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ── UI ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.amber, AppColors.amberDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (_, __) => CustomPaint(
              painter: _ConfettiPainter(
                animValue: _confettiController.value,
                particles: _confettiParticles,
              ),
              child: const SizedBox.expand(),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Floating card (slide up)
                    SlideTransition(
                      position: _slideAnim,
                      child: _buildResultCard(context),
                    ),

                    const SizedBox(height: 28),

                    // Action buttons (also slide up)
                    SlideTransition(
                      position: _slideAnim,
                      child: _buildButtons(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            'Luar Biasa! 🎉',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),

          const SizedBox(height: 28),

          // Score ring
          _buildScoreRing(),

          const SizedBox(height: 28),

          // Stats rows
          _buildStatRow('XP Diperoleh', '+${widget.result.xpEarned} XP 🌟',
              AppColors.amberDark),
          const SizedBox(height: 10),
          _buildStatRow('Waktu', '${widget.result.timeTaken} ⏱️', AppColors.ink),
          const SizedBox(height: 10),
          _buildStatRow('Akurasi', '${widget.result.accuracy}% 🎯', AppColors.success),

          const SizedBox(height: 24),

          // Stars row
          _buildStarsRow(),
        ],
      ),
    );
  }

  Widget _buildScoreRing() {
    return SizedBox(
      width: 140,
      height: 140,
      child: AnimatedBuilder(
        animation: _ringAnim,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: _ScoreRingPainter(
                progress: _ringAnim.value,
                strokeWidth: 12,
              ),
              child: const SizedBox(width: 140, height: 140),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.result.score}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                    height: 1,
                  ),
                ),
                const Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.inkSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStarsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return ScaleTransition(
          scale: _starScaleAnims[i],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.star_rounded,
              color: i < widget.result.stars
                  ? AppColors.amber
                  : AppColors.border,
              size: 42,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.learnHub),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: AppColors.amber,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: const Text(
              'Lanjut ke Level Berikutnya →',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Secondary
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.surface, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Ulangi Kuis 🔄',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
