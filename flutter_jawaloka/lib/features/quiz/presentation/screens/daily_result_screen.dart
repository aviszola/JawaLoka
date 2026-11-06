import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/mock/mock_user_stats.dart';
import '../../../../core/presentation/widgets/wayang_gunungan_painter.dart';
import '../../../../core/presentation/widgets/javanese_calligraphy_painter.dart';

// ─────────────────────────────────────────────────────────
//  SIMILARITY METER PAINTER
// ─────────────────────────────────────────────────────────

class _SimilarityMeterPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0

  const _SimilarityMeterPainter({
    required this.progress,
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
        ..color = progress >= 0.85 ? AppColors.success : AppColors.amber
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
    const labelSpan = TextSpan(
      text: 'Kemiripan',
      style: TextStyle(
        fontSize: 12,
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
//  SCREEN
// ─────────────────────────────────────────────────────────

class DailyResultScreen extends StatefulWidget {
  final String userName;
  final double similarity; // 0.0 – 1.0

  const DailyResultScreen({
    super.key,
    this.userName = MockUserStats.userName,
    this.similarity = 0.92,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hasil Quest',
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
    final isPassed = widget.similarity >= 0.85;
    return Container(
      clipBehavior: Clip.antiAlias,
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
      child: Stack(
        children: [
          // Gunungan watermark emblem on the right edge
          Positioned(
            right: -15,
            top: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.12,
              child: const WayangGununganWidget(
                width: 140,
                height: 180,
                style: GununganStyle.royal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildCelebrationText(isPassed)),
                const SizedBox(width: 16),
                _buildSimilarityMeter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationText(bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isPassed ? 'Hebat, ${widget.userName}!' : 'Ayo Latihan Lagi!',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isPassed
              ? 'Kamu berhasil menulis aksara Jawa dengan kemiripan di atas 85%.'
              : 'Goresanmu hampir tepat. Coba perhatikan proporsi aksara target.',
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
      builder: (context, _) => SizedBox(
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perbandingan Tulisan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _DrawingPanel(title: 'Tulisanmu', isDrawn: true)),
              SizedBox(width: 16),
              Expanded(child: _DrawingPanel(title: 'Aksara Target', isDrawn: false)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Status Card (Kemiripan & Lulus/Gagal) ──────────────────

  Widget _buildQuestStatusCard() {
    final isPassed = widget.similarity >= 0.85;
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
                  isPassed ? 'Status: Lulus' : 'Status: Belum Lulus',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kemiripan ${(widget.similarity * 100).round()}% (Syarat lulus: ≥ 85%)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            onPressed: () => Navigator.pushNamed(context, AppRouter.home),
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

// ─── Drawing Panel Sub-widget ─────────────────────────────

class _DrawingPanel extends StatelessWidget {
  final String title;
  final bool isDrawn;

  const _DrawingPanel({required this.title, required this.isDrawn});

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
                ? const CustomPaint(
                    size: Size(80, 80),
                    painter: JavaneseCalligraphyPainter(
                      aksara: 'ꦲ',
                      inkColor: AppColors.ink,
                      strokeThickness: 5.5,
                      showInkPools: true,
                    ),
                  )
                : const CustomPaint(
                    size: Size(80, 80),
                    painter: JavaneseCalligraphyPainter(
                      aksara: 'ꦲ',
                      inkColor: AppColors.amberDark,
                      strokeThickness: 4.5,
                      showInkPools: false,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
