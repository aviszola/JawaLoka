import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'animated_progress_ring.dart';

/// Data model for a learning module card.
class ModuleCardData {
  final String id;
  final String title;
  final String subtitle;
  final String iconGlyph;      // Javanese glyph or emoji
  final IconData? iconData;    // Material icon (fallback / accent)
  final Color bgColor;
  final Color iconTextColor;
  final double progress;       // 0.0 – 1.0
  final String progressLabel;  // e.g. "20 aksara"
  final bool isLocked;
  final String? tag;

  const ModuleCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    this.iconGlyph = '',
    this.iconData,
    required this.bgColor,
    this.iconTextColor = AppColors.ink,
    required this.progress,
    required this.progressLabel,
    this.isLocked = false,
    this.tag,
  });
}

/// Reusable module card for the Learning Hub.
///
/// Shows module icon, title, progress ring + bar, and a lock overlay
/// for locked content.  Navigates via [onTap] callback.
class ModuleCard extends StatefulWidget {
  final ModuleCardData data;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.data, this.onTap});

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return GestureDetector(
      onTapDown: (_) => _hoverCtrl.forward(),
      onTapUp: (_) {
        _hoverCtrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _hoverCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  // Icon badge
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: d.bgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: d.iconGlyph.isNotEmpty
                          ? Text(
                              d.iconGlyph,
                              style: TextStyle(
                                fontSize: 26,
                                color: d.iconTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : Icon(d.iconData, size: 26, color: d.iconTextColor),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title + subtitle + progress bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row + tag
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                d.title,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (d.tag != null) ...[
                              const SizedBox(width: 6),
                              _BadgePill(label: d.tag!),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d.subtitle,
                          style: const TextStyle(
                            color: AppColors.inkSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Linear progress + label
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: d.isLocked ? 0 : d.progress,
                                  minHeight: 6,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    d.isLocked
                                        ? AppColors.border
                                        : AppColors.amberDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              d.isLocked
                                  ? '—'
                                  : '${(d.progress * 100).round()}%',
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          d.progressLabel,
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress ring (compact, only when unlocked)
                  if (!d.isLocked) ...[
                    const SizedBox(width: 10),
                    AnimatedProgressRing(
                      progress: d.progress,
                      size: 44,
                      strokeWidth: 5,
                      progressColor: AppColors.amberDark,
                      child: Text(
                        '${(d.progress * 100).round()}',
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

              // Lock overlay
              if (d.isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.canvas.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: _WayangLockIcon(),
                    ),
                  ),
                ),

              // Chevron
              if (!d.isLocked)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.inkMuted.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String label;
  const _BadgePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.pastelMint,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.pastelMintText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Wayang silhouette drawn with CustomPainter for locked content.
class _WayangLockIcon extends StatelessWidget {
  const _WayangLockIcon();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: CustomPaint(painter: _WayangSilhouettePainter()),
        ),
        const SizedBox(height: 4),
        const Text(
          'Terkunci',
          style: TextStyle(
            color: AppColors.inkSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Simple Wayang puppet silhouette (CustomPainter).
class _WayangSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.inkSecondary.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.14), width: w * 0.28, height: h * 0.22),
      paint,
    );

    // Crown / headdress
    final crownPath = Path()
      ..moveTo(w * 0.36, h * 0.05)
      ..lineTo(w * 0.42, h * 0.0)
      ..lineTo(w * 0.5, h * 0.03)
      ..lineTo(w * 0.58, h * 0.0)
      ..lineTo(w * 0.64, h * 0.05)
      ..lineTo(w * 0.6, h * 0.08)
      ..lineTo(w * 0.4, h * 0.08)
      ..close();
    canvas.drawPath(crownPath, paint);

    // Body
    final bodyPath = Path()
      ..moveTo(w * 0.38, h * 0.26)
      ..lineTo(w * 0.3, h * 0.55)
      ..lineTo(w * 0.42, h * 0.56)
      ..lineTo(w * 0.42, h * 0.75)
      ..lineTo(w * 0.58, h * 0.75)
      ..lineTo(w * 0.58, h * 0.56)
      ..lineTo(w * 0.7, h * 0.55)
      ..lineTo(w * 0.62, h * 0.26)
      ..close();
    canvas.drawPath(bodyPath, paint);

    // Left arm
    final leftArm = Path()
      ..moveTo(w * 0.3, h * 0.3)
      ..quadraticBezierTo(w * 0.08, h * 0.42, w * 0.05, h * 0.65)
      ..lineTo(w * 0.12, h * 0.66)
      ..quadraticBezierTo(w * 0.17, h * 0.46, w * 0.38, h * 0.36)
      ..close();
    canvas.drawPath(leftArm, paint);

    // Right arm
    final rightArm = Path()
      ..moveTo(w * 0.7, h * 0.3)
      ..quadraticBezierTo(w * 0.92, h * 0.42, w * 0.95, h * 0.65)
      ..lineTo(w * 0.88, h * 0.66)
      ..quadraticBezierTo(w * 0.83, h * 0.46, w * 0.62, h * 0.36)
      ..close();
    canvas.drawPath(rightArm, paint);

    // Lock icon overlay
    final lockPaint = Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.88), width: w * 0.32, height: h * 0.18),
        const Radius.circular(4),
      ),
      lockPaint,
    );
    final lockArcPaint = Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.83), width: w * 0.18, height: h * 0.14),
      3.14,
      3.14,
      false,
      lockArcPaint,
    );
  }

  @override
  bool shouldRepaint(_WayangSilhouettePainter _) => false;
}
