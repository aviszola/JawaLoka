import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/javanese_glyph_painter.dart';

/// Central brand mark for the Get Started screen, echoing the circular
/// community motif from the reference design while adhering strictly
/// to JawaLoka's official [AppColors] design tokens.
class GetStartedBrandMark extends StatelessWidget {
  final double size;

  const GetStartedBrandMark({super.key, this.size = 64.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.amberDark.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: const _BrandMarkPainter(),
          ),
          JavaneseGlyphWidget(size: size * 0.48, color: AppColors.ink),
        ],
      ),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = w * 0.44;

    // Upward community growth arc with AppColors.amberDark
    final Paint arcPaint = Paint()
      ..color = AppColors.amberDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final Path arc = Path();
    arc.addArc(
      Rect.fromCircle(center: center, radius: radius * 0.90),
      -0.5,
      4.0,
    );
    canvas.drawPath(arc, arcPaint);

    // Arrow head on the arc top-right
    final Paint arrowPaint = Paint()
      ..color = AppColors.amberDark
      ..style = PaintingStyle.fill;

    final Path arrow = Path();
    arrow.moveTo(w * 0.82, h * 0.18);
    arrow.lineTo(w * 0.93, h * 0.22);
    arrow.lineTo(w * 0.85, h * 0.33);
    arrow.close();
    canvas.drawPath(arrow, arrowPaint);

    // 3 community member nodes with AppColors.terraceTier2
    final Paint dotPaint = Paint()
      ..color = AppColors.terraceTier2
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.22, h * 0.38), 2.5, dotPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.14), 2.8, dotPaint);
    canvas.drawCircle(Offset(w * 0.74, h * 0.32), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
