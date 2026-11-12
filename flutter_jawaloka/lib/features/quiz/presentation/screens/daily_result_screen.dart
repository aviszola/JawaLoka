import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/progression/reward_summary.dart';
import '../../domain/quest_target.dart';

// ─────────────────────────────────────────────────────────
//  SIMILARITY METER PAINTER
// ─────────────────────────────────────────────────────────

class _SimilarityMeterPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0
  final String label;

  const _SimilarityMeterPainter({
    required this.progress,
    this.label = 'Kemiripan',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 10.0;
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
      final arcPaint = Paint()
        ..color = progress >= QuestTarget.questPassThreshold
            ? AppColors.success
            : AppColors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        arcPaint,
      );
    }

    // Center percentage text
    final percentText = '${(progress * 100).round()}%';
    final percentSpan = TextSpan(
      text: percentText,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.ink,
      ),
    );
    final percentPainter = TextPainter(
      text: percentSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    percentPainter.paint(
      canvas,
      center - Offset(percentPainter.width / 2, percentPainter.height / 2 + 7),
    );

    // Similarity label below percentage
    final labelSpan = TextSpan(
      text: label,
      style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      center + Offset(-labelPainter.width / 2, percentPainter.height / 2 - 5),
    );
  }

  @override
  bool shouldRepaint(_SimilarityMeterPainter old) =>
      old.progress != progress || old.label != label;
}

// ─────────────────────────────────────────────────────────
//  DRAWN AKSARA PAINTER  (decorative simplified stroke)
// ─────────────────────────────────────────────────────────

class _DrawnAksaraPainter extends CustomPainter {
  const _DrawnAksaraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Simple stylised Ha aksara curves (decorative approximation)
    final path = Path()
      ..moveTo(w * 0.25, h * 0.30)
      ..cubicTo(w * 0.30, h * 0.20, w * 0.50, h * 0.18, w * 0.60, h * 0.28)
      ..cubicTo(w * 0.70, h * 0.38, w * 0.72, h * 0.55, w * 0.65, h * 0.60)
      ..cubicTo(w * 0.58, h * 0.65, w * 0.45, h * 0.68, w * 0.40, h * 0.62)
      ..moveTo(w * 0.35, h * 0.60)
      ..cubicTo(w * 0.30, h * 0.72, w * 0.28, h * 0.80, w * 0.35, h * 0.85)
      ..cubicTo(w * 0.42, h * 0.90, w * 0.60, h * 0.88, w * 0.65, h * 0.78);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DrawnAksaraPainter _) => false;
}

// ─────────────────────────────────────────────────────────
//  SCREEN ARGUMENTS & SCREEN
// ─────────────────────────────────────────────────────────

/// Arguments passed to [DailyResultScreen] from drawing canvas.
class DailyResultArgs {
  final double similarity;
  final List<List<Offset>> userStrokes;
  final String targetAksara;
  final String userName;
  final RewardSummary? rewardSummary;

  const DailyResultArgs({
    required this.similarity,
    required this.userStrokes,
    this.targetAksara = 'ꦲ',
    this.userName = 'Dimas',
    this.rewardSummary,
  });
}

class DailyResultScreen extends StatefulWidget {
  final String userName;
  final double similarity; // 0.0 – 1.0
  final List<List<Offset>> userStrokes;
  final String targetAksara;
  final RewardSummary? rewardSummary;

  const DailyResultScreen({
    super.key,
    this.userName = 'Dimas',
    this.similarity = 0.92,
    this.userStrokes = const [],
    this.targetAksara = 'ꦲ',
    this.rewardSummary,
  });

  @override
  State<DailyResultScreen> createState() => _DailyResultScreenState();
}

class _DailyResultScreenState extends State<DailyResultScreen>
    with TickerProviderStateMixin {
  // Card slide-up
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;

  // Similarity meter
  late final AnimationController _meterController;
  late final Animation<double> _meterAnim;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _meterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _meterAnim = Tween<double>(
      begin: 0,
      end: widget.similarity,
    ).animate(CurvedAnimation(parent: _meterController, curve: Curves.easeOut));

    // Staggered start
    _slideController.forward().then((_) {
      if (mounted) _meterController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _meterController.dispose();
    super.dispose();
  }

  // ── UI ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Semantics(
          label: context.l10n.commonBack,
          button: true,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        title: Text(
          context.l10n.dailyResultTitle,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCelebrationCard(),
              const SizedBox(height: 20),
              _buildDrawingResultCard(),
              const SizedBox(height: 20),
              _buildQuestStatusCard(),
              const SizedBox(height: 28),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Celebration Card ───────────────────────────────────

  Widget _buildCelebrationCard() {
    final isPassed = widget.similarity >= QuestTarget.questPassThreshold;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPassed
              ? [AppColors.amber, AppColors.amberDark]
              : [const Color(0xFFE8E1D6), const Color(0xFFD4C7B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildCelebrationText(isPassed)),
          const SizedBox(width: 16),
          _buildSimilarityMeter(),
        ],
      ),
    );
  }

  Widget _buildCelebrationText(bool isPassed) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isPassed
              ? l10n.dailyResultCelebrationPassed(widget.userName)
              : l10n.dailyResultCelebrationFailed,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isPassed
              ? l10n.dailyResultDescPassed(
                  (QuestTarget.questPassThreshold * 100).round(),
                )
              : l10n.dailyResultDescFailed,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.ink,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarityMeter() {
    return AnimatedBuilder(
      animation: _meterAnim,
      builder: (context, child) => SizedBox(
        width: 90,
        height: 90,
        child: CustomPaint(
          painter: _SimilarityMeterPainter(
            progress: _meterAnim.value,
            label: context.l10n.dailyResultSimilarityLabel,
          ),
        ),
      ),
    );
  }

  // ── Drawing Result Card ────────────────────────────────

  Widget _buildDrawingResultCard() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyResultComparison,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DrawingPanel(
                  title: l10n.dailyResultYourDrawing,
                  isDrawn: true,
                  userStrokes: widget.userStrokes,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DrawingPanel(
                  title: l10n.dailyResultTargetScript,
                  isDrawn: false,
                  targetChar: widget.targetAksara,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Status Card (Kemiripan & Lulus/Gagal) ──────────────────

  Widget _buildQuestStatusCard() {
    final isPassed = widget.similarity >= QuestTarget.questPassThreshold;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isPassed ? AppColors.pastelMint : AppColors.pastelSand,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPassed ? AppColors.success : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPassed ? AppColors.success : AppColors.inkMuted,
            ),
            child: Icon(
              isPassed ? Icons.check_rounded : Icons.replay_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPassed
                      ? l10n.dailyResultStatusPassed
                      : l10n.dailyResultStatusFailed,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dailyResultRequirement(
                    (widget.similarity * 100).round(),
                    (QuestTarget.questPassThreshold * 100).round(),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.inkSecondary,
                  ),
                ),
                if (widget.rewardSummary != null &&
                    widget.rewardSummary!.xpEarned > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amberSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${widget.rewardSummary!.xpEarned} XP (${widget.rewardSummary!.isFirstClear ? 'Misi Selesai' : 'Latihan'})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Buttons ────────────────────────────────────────────

  Widget _buildButtons(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
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
              l10n.dailyResultContinueLearning,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              side: const BorderSide(color: AppColors.border, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: Text(
              l10n.dailyResultTryAgain,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Drawing Panel Sub-widget ─────────────────────────────

class _DrawingPanel extends StatelessWidget {
  final String title;
  final bool isDrawn;
  final List<List<Offset>> userStrokes;
  final String targetChar;

  const _DrawingPanel({
    required this.title,
    required this.isDrawn,
    this.userStrokes = const [],
    this.targetChar = 'ꦲ',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: isDrawn ? AppColors.canvas : AppColors.amberSoft,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDrawn ? AppColors.border : AppColors.amber,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isDrawn
                ? (userStrokes.isNotEmpty
                      ? CustomPaint(
                          size: const Size(80, 80),
                          painter: UserDrawingThumbnailPainter(
                            strokes: userStrokes,
                          ),
                        )
                      : const CustomPaint(
                          size: Size(80, 80),
                          painter: _DrawnAksaraPainter(),
                        ))
                : Text(
                    targetChar,
                    style: const TextStyle(
                      fontSize: 48,
                      color: AppColors.ink,
                      fontFamily: 'NotoSansJavanese',
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Painter rendering the user's authentic handwritten strokes scaled to fit the thumbnail.
class UserDrawingThumbnailPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color strokeColor;

  const UserDrawingThumbnailPainter({
    required this.strokes,
    this.strokeColor = AppColors.ink,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;

    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final stroke in strokes) {
      for (final p in stroke) {
        if (p.dx < minX) minX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy > maxY) maxY = p.dy;
      }
    }

    if (minX == double.infinity) return;

    final strokeWidth = maxX - minX;
    final strokeHeight = maxY - minY;
    final maxDim = max(strokeWidth, strokeHeight);

    final padding = size.width * 0.12;
    final availableSize = size.width - 2 * padding;
    final scale = maxDim > 0 ? availableSize / maxDim : 1.0;

    final offsetX =
        padding + (availableSize - strokeWidth * scale) / 2 - minX * scale;
    final offsetY =
        padding + (availableSize - strokeHeight * scale) / 2 - minY * scale;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.5, 3.5 / scale)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(
          stroke.first,
          2.5 / scale,
          Paint()..color = strokeColor,
        );
      } else {
        final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant UserDrawingThumbnailPainter oldDelegate) =>
      oldDelegate.strokes != strokes || oldDelegate.strokeColor != strokeColor;
}
