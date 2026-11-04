import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

// ─────────────────────────────────────────────────────────
//  SIMILARITY METER PAINTER
// ─────────────────────────────────────────────────────────

class _SimilarityMeterPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0
  final String label;
  final Color activeColor;

  const _SimilarityMeterPainter({
    required this.progress,
    this.label = 'Kemiripan',
    this.activeColor = AppColors.amber,
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
        ..color = activeColor
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

    // "Kemiripan" label below percentage
    final labelSpan = TextSpan(
      text: label,
      style: const TextStyle(
        fontSize: 11,
        color: AppColors.inkMuted,
      ),
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
  bool shouldRepaint(_SimilarityMeterPainter old) => old.progress != progress;
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
//  SCREEN
// ─────────────────────────────────────────────────────────

class DailyResultScreen extends StatefulWidget {
  final String userName;
  final double similarity; // 0.0 – 1.0
  final int xpEarned;
  final int streakBonus;

  const DailyResultScreen({
    super.key,
    this.userName = 'Dimas',
    this.similarity = 0.92,
    this.xpEarned = 50,
    this.streakBonus = 10,
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

  // XP counter tick-up
  late final AnimationController _xpController;
  late final Animation<int> _xpAnim;

  // Shimmer for XP card
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _meterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _meterAnim = Tween<double>(begin: 0, end: widget.similarity).animate(
      CurvedAnimation(parent: _meterController, curve: Curves.easeOut),
    );

    _xpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _xpAnim = IntTween(begin: 0, end: widget.xpEarned).animate(
      CurvedAnimation(parent: _xpController, curve: Curves.easeOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Staggered start
    _slideController.forward().then((_) {
      _meterController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _xpController.forward();
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _meterController.dispose();
    _xpController.dispose();
    _shimmerController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hasil Latihan',
          style: TextStyle(
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCelebrationCard(),
              const SizedBox(height: 20),
              _buildDrawingResultCard(),
              const SizedBox(height: 20),
              _buildXpCard(),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.amber, AppColors.amberDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.amberDark.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildCelebrationText()),
          const SizedBox(width: 16),
          _buildSimilarityMeter(),
        ],
      ),
    );
  }

  Widget _buildCelebrationText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hebat, ${widget.userName}! 🎉',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kamu berhasil menulis aksara Jawa dengan baik',
          style: TextStyle(
            fontSize: 13,
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
      builder: (_, __) => SizedBox(
        width: 90,
        height: 90,
        child: CustomPaint(
          painter: _SimilarityMeterPainter(progress: _meterAnim.value),
        ),
      ),
    );
  }

  // ── Drawing Result Card ────────────────────────────────

  Widget _buildDrawingResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hasil Tulisanmu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDrawingPanel()),
              const SizedBox(width: 16),
              Expanded(child: _buildReferencePanel()),
            ],
          ),
          const SizedBox(height: 16),
          _buildGoodBadge(),
        ],
      ),
    );
  }

  Widget _buildDrawingPanel() {
    return Column(
      children: [
        const Text(
          'Tulisanmu',
          style: TextStyle(fontSize: 13, color: AppColors.inkSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.canvas,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
              width: 1.5,
              // Dotted border approximation with solid
            ),
          ),
          child: const CustomPaint(
            painter: _DrawnAksaraPainter(),
          ),
        ),
      ],
    );
  }

  Widget _buildReferencePanel() {
    return Column(
      children: [
        const Text(
          'Referensi',
          style: TextStyle(fontSize: 13, color: AppColors.inkSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.amberSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'ꦲ',
              style: TextStyle(
                fontSize: 60,
                color: AppColors.amberDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoodBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
          SizedBox(width: 6),
          Text(
            'Sangat Baik',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.successText,
            ),
          ),
        ],
      ),
    );
  }

  // ── XP Card ────────────────────────────────────────────

  Widget _buildXpCard() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (_, child) {
        final shimmerOpacity = 0.7 + 0.3 * _shimmerController.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.amberSoft.withOpacity(shimmerOpacity),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.amber.withOpacity(0.4)),
          ),
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _xpAnim,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '+${_xpAnim.value} XP',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.amberDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bonus streak: +${widget.streakBonus} XP 🔥',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.inkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Buttons ────────────────────────────────────────────

  Widget _buildButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
              'Lanjutkan Belajar →',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              side: const BorderSide(color: AppColors.border, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
