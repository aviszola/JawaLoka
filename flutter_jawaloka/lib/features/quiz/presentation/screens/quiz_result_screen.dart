import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/presentation/widgets/wayang_gunungan_painter.dart';
import '../../../../core/presentation/widgets/celebration_confetti_painter.dart';
import '../../../profile/presentation/screens/level_up_screen.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../../domain/models/quiz_result.dart';
import 'quiz_question_screen.dart';

export '../../domain/models/quiz_result.dart';

// ─────────────────────────────────────────────────────────
//  SCORE RING PAINTER
// ─────────────────────────────────────────────────────────

class _ScoreRingPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0
  final double strokeWidth;

  const _ScoreRingPainter({required this.progress, this.strokeWidth = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active arc
    if (progress > 0) {
      final activePaint = Paint()
        ..color = AppColors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // start at top
        2 * pi * progress, // sweep
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
      score: 80,
      maxScore: 100,
      correctCount: 8,
      totalQuestions: 10,
      accuracy: 80,
      isStreakAchievedToday: true,
      currentStreak: 1,
    ),
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  // Confetti animation
  late final AnimationController _confettiController;
  late final List<ConfettiParticle> _confettiParticles;

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
      final colors = CelebrationConfettiPainter.defaultPalette;
      return ConfettiParticle(
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
    _ringAnim = Tween<double>(
      begin: 0,
      end: widget.result.scoreRatio,
    ).animate(CurvedAnimation(parent: _ringController, curve: Curves.easeOut));

    // Card slide-up
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 1.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Stars – 3 controllers with staggered delays
    _starControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _starScaleAnims = _starControllers.map((ctrl) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.elasticOut));
    }).toList();

    // Start sequence
    _slideController.forward().then((_) {
      if (!mounted) return;
      _ringController.forward();
      _startStarsSequence();
    });
  }

  Future<void> _startStarsSequence() async {
    final stars = widget.result.stars;
    for (int i = 0; i < stars; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _starControllers[i].forward();
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

          // Subtle Kawung Batik Motif
          Positioned.fill(
            child: CustomPaint(painter: BatikKawungPainter(opacity: 0.035)),
          ),

          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) => CustomPaint(
              painter: CelebrationConfettiPainter(
                progress: _confettiController.value,
                particles: _confettiParticles,
              ),
              child: const SizedBox.expand(),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
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
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gunungan Victory Crest
          const WayangGununganWidget(
            width: 54,
            height: 68,
            style: GununganStyle.royal,
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            context.l10n.quizResultAwesome,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),

          const SizedBox(height: 28),

          // Score ring
          _buildScoreRing(),

          if (widget.result.isStreakAchievedToday) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.amberDark.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFF26B2D),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.quizResultStreakBanner(
                      widget.result.currentStreak,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.amberDark,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Stats rows
          _buildStatRow(
            context.l10n.quizResultCorrectAnswers,
            '${widget.result.correctCount}/${widget.result.totalQuestions}',
            AppColors.amberDark,
          ),
          const SizedBox(height: 10),
          _buildStatRow(
            context.l10n.quizResultAccuracy,
            '${widget.result.accuracy}%',
            AppColors.success,
          ),
          if (widget.result.rewardSummary != null) ...[
            const SizedBox(height: 10),
            _buildStatRow(
              'XP Diperoleh',
              '+${widget.result.rewardSummary!.xpEarned} XP${widget.result.rewardSummary!.isFirstClear ? ' (Bonus Pertama)' : ' (Latihan)'}',
              AppColors.amberDark,
            ),
          ],

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
        builder: (context, _) => Stack(
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
                  style: TextStyle(fontSize: 20, color: AppColors.inkMuted),
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
          style: const TextStyle(fontSize: 15, color: AppColors.inkSecondary),
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
            onPressed: () async {
              final summary = widget.result.rewardSummary;
              final profile = ProfileScope.maybeOf(context);
              if (summary != null &&
                  summary.leveledUp &&
                  profile != null &&
                  profile.shouldCelebrateLevel(summary.newLevel)) {
                await profile.markLevelCelebrated(summary.newLevel);
                if (!context.mounted) return;
                await Navigator.of(context).pushNamed(
                  AppRouter.levelUp,
                  arguments: LevelUpArgs(
                    newLevel: summary.newLevel,
                    previousLevel: summary.previousLevel,
                    unlockedBlangkons: summary.unlockedBlangkons,
                  ),
                );
              }
              if (!context.mounted) return;
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).popUntil(
                  (route) =>
                      route.settings.name == AppRouter.home || route.isFirst,
                );
              } else {
                Navigator.of(context).pushReplacementNamed(AppRouter.home);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: AppColors.amber,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              context.l10n.quizResultBackHome,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Secondary: Retry (starts clean session without route stacking)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                AppRouter.quizQuestion,
                arguments: QuizQuestionArgs(
                  questions: widget.result.questions,
                  moduleTitle: widget.result.moduleTitle ?? 'Aksara Dhasar',
                  activityId: widget.result.rewardSummary?.activityId,
                  isEvaluation: widget.result.isEvaluation,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.surface, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: Text(
              context.l10n.quizResultRetry,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
