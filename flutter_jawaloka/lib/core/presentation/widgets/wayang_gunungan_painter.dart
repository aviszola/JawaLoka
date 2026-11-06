import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Style variants for the Wayang Gunungan (Kayon) illustration.
enum GununganStyle {
  /// Full royal polychrome (Gold, Deep Ink, Crimson accents, white highlights)
  royal,
  /// Monochrome golden outline with subtle fills for badges and cards
  goldOutline,
  /// Soft ghost watermark for subtle backgrounds
  watermark,
}

/// Hand-crafted vector painter rendering the sacred Javanese Wayang Gunungan (Kayon).
///
/// Cultural significance:
/// The Gunungan represents the cosmic mountain (Mahameru) and the Tree of Life (Pohon Hayat).
/// In Wayang Kulit, it marks the opening of knowledge, progression between acts,
/// and the triumph of wisdom over ignorance — perfectly matching JawaLoka's learning journey.
class WayangGununganPainter extends CustomPainter {
  final GununganStyle style;
  final double progress; // 0.0 - 1.0 for entrance or shimmer animation

  const WayangGununganPainter({
    this.style = GununganStyle.royal,
    this.progress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;

    // Use normalized coordinates (0..100)
    final sx = w / 100.0;
    final sy = h / 100.0;

    canvas.save();

    // ── 1. Gunungan Leaf Silhouette (Cembung Daun Kayon) ───────────────────
    final Path leafPath = Path()
      ..moveTo(50 * sx, 3 * sy) // Top peak flame
      ..cubicTo(56 * sx, 7 * sy, 72 * sx, 20 * sy, 82 * sx, 38 * sy)
      ..cubicTo(90 * sx, 52 * sy, 92 * sx, 70 * sy, 86 * sx, 84 * sy)
      ..cubicTo(82 * sx, 92 * sy, 70 * sx, 95 * sy, 54 * sx, 95 * sy)
      ..lineTo(54 * sx, 98 * sy) // Handle tangkai
      ..lineTo(46 * sx, 98 * sy)
      ..lineTo(46 * sx, 95 * sy)
      ..cubicTo(30 * sx, 95 * sy, 18 * sx, 92 * sy, 14 * sx, 84 * sy)
      ..cubicTo(8 * sx, 70 * sy, 10 * sx, 52 * sy, 18 * sx, 38 * sy)
      ..cubicTo(28 * sx, 20 * sy, 44 * sx, 7 * sy, 50 * sx, 3 * sy)
      ..close();

    switch (style) {
      case GununganStyle.royal:
        _drawRoyalGunungan(canvas, sx, sy, leafPath, w, h);
        break;
      case GununganStyle.goldOutline:
        _drawGoldOutlineGunungan(canvas, sx, sy, leafPath, w, h);
        break;
      case GununganStyle.watermark:
        _drawWatermarkGunungan(canvas, sx, sy, leafPath);
        break;
    }

    canvas.restore();
  }

  // ─── Royal Style: Rich Javanese Kraton Colors & Filigree ──────────────────
  void _drawRoyalGunungan(
      Canvas canvas, double sx, double sy, Path leafPath, double w, double h) {
    // Drop shadow
    final shadowPaint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(leafPath, shadowPaint);

    // Body Fill: Deep midnight bronze to warm mahogany gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF2A1C10),
          const Color(0xFF3E2818),
          const Color(0xFF1F140A),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(leafPath, bgPaint);

    // Inner glowing rim (Praba Emas)
    final rimPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.amber,
          AppColors.amberDark,
          const Color(0xFF8B5A2B),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * sx;
    canvas.drawPath(leafPath, rimPaint);

    // Inner border line
    final innerBorder = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * sx;
    canvas.save();
    canvas.translate(50 * sx, 50 * sy);
    canvas.scale(0.93, 0.93);
    canvas.translate(-50 * sx, -50 * sy);
    canvas.drawPath(leafPath, innerBorder);
    canvas.restore();

    // ── 2. Paduraksa / Candi Gate at the Base ──────────────────────────────
    _drawPaduraksaGate(canvas, sx, sy);

    // ── 3. Tree of Life (Pohon Hayat / Kalpataru) Trunk & Branches ─────────
    _drawTreeOfLife(canvas, sx, sy);

    // ── 4. Garuda Wings / Lar Sacred Motifs on both flanks ─────────────────
    _drawGarudaWings(canvas, sx, sy);

    // ── 5. Top Flame Finial (Makuta / Api Suci) ────────────────────────────
    _drawTopFlame(canvas, sx, sy);

    // ── 6. Tangkai Gapit (Carved buffalo horn handle at bottom) ────────────
    final handlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF5A3A1E), const Color(0xFF1E140A)],
      ).createShader(Rect.fromLTWH(46 * sx, 95 * sy, 8 * sx, 15 * sy));
    final handlePath = Path()
      ..moveTo(48 * sx, 95 * sy)
      ..lineTo(52 * sx, 95 * sy)
      ..lineTo(51 * sx, 108 * sy)
      ..lineTo(49 * sx, 108 * sy)
      ..close();
    canvas.drawPath(handlePath, handlePaint);
  }

  // ─── Gold Outline Style: Refined vector lineart for medals & cards ─────────
  void _drawGoldOutlineGunungan(
      Canvas canvas, double sx, double sy, Path leafPath, double w, double h) {
    // Subtle background tint
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.amberSoft.withValues(alpha: 0.45),
          AppColors.amber.withValues(alpha: 0.12),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(leafPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.amberDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * sx
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(leafPath, linePaint);

    // Paduraksa gate lines
    final gatePath = Path()
      ..moveTo(42 * sx, 88 * sy)
      ..lineTo(42 * sx, 74 * sy)
      ..cubicTo(42 * sx, 68 * sy, 58 * sx, 68 * sy, 58 * sx, 74 * sy)
      ..lineTo(58 * sx, 88 * sy);
    canvas.drawPath(gatePath, linePaint);

    // Tree spine
    final treePath = Path()
      ..moveTo(50 * sx, 68 * sy)
      ..lineTo(50 * sx, 18 * sy);
    canvas.drawPath(treePath, linePaint);

    // Stylized branches
    for (int i = 0; i < 4; i++) {
      final y = (26 + i * 10) * sy;
      final spread = (16 + i * 5) * sx;

      // Left branch
      final bLeft = Path()
        ..moveTo(50 * sx, y + 4 * sy)
        ..cubicTo(42 * sx, y, (50 * sx) - spread, y - 2 * sy, (50 * sx) - spread - 2 * sx, y - 8 * sy);
      canvas.drawPath(bLeft, linePaint);

      // Right branch
      final bRight = Path()
        ..moveTo(50 * sx, y + 4 * sy)
        ..cubicTo(58 * sx, y, (50 * sx) + spread, y - 2 * sy, (50 * sx) + spread + 2 * sx, y - 8 * sy);
      canvas.drawPath(bRight, linePaint);
    }

    // Top flame
    final flame = Path()
      ..moveTo(50 * sx, 3 * sy)
      ..cubicTo(53 * sx, 8 * sy, 52 * sx, 14 * sy, 50 * sx, 18 * sy)
      ..cubicTo(48 * sx, 14 * sy, 47 * sx, 8 * sy, 50 * sx, 3 * sy);
    canvas.drawPath(flame, Paint()..color = AppColors.amber);
  }

  // ─── Watermark Style: Low opacity for card background watermarks ──────────
  void _drawWatermarkGunungan(Canvas canvas, double sx, double sy, Path leafPath) {
    final strokePaint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4 * sx;
    canvas.drawPath(leafPath, strokePaint);

    // Center tree
    canvas.drawLine(
      Offset(50 * sx, 15 * sy),
      Offset(50 * sx, 85 * sy),
      strokePaint,
    );

    // Gate
    canvas.drawRect(
      Rect.fromCenter(center: Offset(50 * sx, 80 * sy), width: 16 * sx, height: 18 * sy),
      strokePaint,
    );
  }

  // ─── Details: Paduraksa Gate ──────────────────────────────────────────────
  void _drawPaduraksaGate(Canvas canvas, double sx, double sy) {
    // Gate arch (Gapura)
    final gatePath = Path()
      ..moveTo(40 * sx, 88 * sy)
      ..lineTo(40 * sx, 72 * sy)
      ..cubicTo(40 * sx, 64 * sy, 60 * sx, 64 * sy, 60 * sx, 72 * sy)
      ..lineTo(60 * sx, 88 * sy)
      ..close();

    // Dark portal interior
    canvas.drawPath(gatePath, Paint()..color = const Color(0xFF0F0A06));

    // Gold gate border
    final gateBorder = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.amber, AppColors.amberDark],
      ).createShader(Rect.fromLTWH(40 * sx, 64 * sy, 20 * sx, 24 * sy))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * sx;
    canvas.drawPath(gatePath, gateBorder);

    // Door shutters (Lawan Candi)
    final doorPaint = Paint()
      ..color = const Color(0xFF7A4A18)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(43 * sx, 73 * sy, 6 * sx, 14 * sy),
      doorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(51 * sx, 73 * sy, 6 * sx, 14 * sy),
      doorPaint,
    );

    // Gold door studs / hinges
    final studPaint = Paint()..color = AppColors.amber;
    for (int i = 0; i < 3; i++) {
      final y = (76 + i * 4.5) * sy;
      canvas.drawCircle(Offset(44.5 * sx, y), 0.8 * sx, studPaint);
      canvas.drawCircle(Offset(55.5 * sx, y), 0.8 * sx, studPaint);
    }

    // Kala Head / Makara above the gate (protective Javanese monster motif)
    final kalaPaint = Paint()..color = AppColors.amber;
    final kalaPath = Path()
      ..moveTo(47 * sx, 64 * sy)
      ..quadraticBezierTo(50 * sx, 61 * sy, 53 * sx, 64 * sy)
      ..quadraticBezierTo(50 * sx, 66 * sy, 47 * sx, 64 * sy);
    canvas.drawPath(kalaPath, kalaPaint);
  }

  // ─── Details: Tree of Life (Pohon Hayat) ──────────────────────────────────
  void _drawTreeOfLife(Canvas canvas, double sx, double sy) {
    // Tree Trunk: Golden spine from above the gate to the peak
    final trunkPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [AppColors.amberDark, AppColors.amber],
      ).createShader(Rect.fromLTWH(48 * sx, 14 * sy, 4 * sx, 50 * sy))
      ..strokeWidth = 2.2 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final trunkPath = Path()
      ..moveTo(50 * sx, 64 * sy)
      ..lineTo(50 * sx, 14 * sy);
    canvas.drawPath(trunkPath, trunkPaint);

    // Branches & Tendrils: Symmetrical Javanese floral arabesques (Lung-lungan)
    final branchPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3 * sx
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.fill;

    // 4 Tiers of lush branches
    final branchTiers = [
      {'y': 56.0, 'w': 28.0, 'curve': 6.0},
      {'y': 44.0, 'w': 26.0, 'curve': 7.0},
      {'y': 32.0, 'w': 22.0, 'curve': 8.0},
      {'y': 22.0, 'w': 16.0, 'curve': 7.0},
    ];

    for (final tier in branchTiers) {
      final y = tier['y']! * sy;
      final bw = tier['w']! * sx;
      final c = tier['curve']! * sy;

      // Left Branch
      final leftBranch = Path()
        ..moveTo(50 * sx, y + 2 * sy)
        ..cubicTo(
          42 * sx, y,
          (50 * sx) - (bw * 0.7), y - c,
          (50 * sx) - bw, y - (c * 1.4),
        );
      canvas.drawPath(leftBranch, branchPaint);

      // Left leaf tip scroll
      canvas.drawCircle(Offset((50 * sx) - bw, y - (c * 1.4)), 1.2 * sx, leafPaint);

      // Right Branch
      final rightBranch = Path()
        ..moveTo(50 * sx, y + 2 * sy)
        ..cubicTo(
          58 * sx, y,
          (50 * sx) + (bw * 0.7), y - c,
          (50 * sx) + bw, y - (c * 1.4),
        );
      canvas.drawPath(rightBranch, branchPaint);

      // Right leaf tip scroll
      canvas.drawCircle(Offset((50 * sx) + bw, y - (c * 1.4)), 1.2 * sx, leafPaint);
    }
  }

  // ─── Details: Garuda Wings / Lar Sacred Motifs ─────────────────────────────
  void _drawGarudaWings(Canvas canvas, double sx, double sy) {
    final wingPaint = Paint()
      ..color = AppColors.amberDark.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * sx;

    // Wing feathers (Lar) radiating outwards along the lower flanks
    for (int i = 0; i < 4; i++) {
      final y = (70 + i * 4) * sy;
      // Left wing feather
      final leftFeather = Path()
        ..moveTo(38 * sx, y)
        ..quadraticBezierTo(26 * sx, y - 4 * sy, 20 * sx, y + 2 * sy);
      canvas.drawPath(leftFeather, wingPaint);

      // Right wing feather
      final rightFeather = Path()
        ..moveTo(62 * sx, y)
        ..quadraticBezierTo(74 * sx, y - 4 * sy, 80 * sx, y + 2 * sy);
      canvas.drawPath(rightFeather, wingPaint);
    }
  }

  // ─── Details: Top Flame Finial ────────────────────────────────────────────
  void _drawTopFlame(Canvas canvas, double sx, double sy) {
    // Sacred Flame / Makuta peak
    final flamePath = Path()
      ..moveTo(50 * sx, 3 * sy)
      ..cubicTo(53 * sx, 7 * sy, 53 * sx, 12 * sy, 50 * sx, 15 * sy)
      ..cubicTo(47 * sx, 12 * sy, 47 * sx, 7 * sy, 50 * sx, 3 * sy)
      ..close();

    final flamePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.white, AppColors.amber, AppColors.accentOrange],
        stops: [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(50 * sx, 8 * sy), radius: 6 * sx));
    canvas.drawPath(flamePath, flamePaint);

    // Radiant flame star
    canvas.drawCircle(Offset(50 * sx, 9 * sy), 1.6 * sx, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant WayangGununganPainter oldDelegate) {
    return oldDelegate.style != style || oldDelegate.progress != progress;
  }
}

/// Standalone Widget embedding the sacred Wayang Gunungan.
class WayangGununganWidget extends StatelessWidget {
  final double width;
  final double height;
  final GununganStyle style;

  const WayangGununganWidget({
    super.key,
    this.width = 120,
    this.height = 160,
    this.style = GununganStyle.royal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: WayangGununganPainter(style: style),
      ),
    );
  }
}

