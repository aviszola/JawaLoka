import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';

/// Data model for a learning module card.
class ModuleCardData {
  final String id;
  final String title;
  final String subtitle;
  final String iconGlyph; // Javanese glyph or emoji
  final IconData? iconData; // Material icon (fallback / accent)
  final Color bgColor;
  final Color iconTextColor;
  final double?
  progress; // 0.0 – 1.0 (null if module is an inventory/reference material)
  final String progressLabel; // e.g. "20 aksara dasar"
  final bool isLocked;
  final String? tag;
  final bool isTool;

  const ModuleCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    this.iconGlyph = '',
    this.iconData,
    required this.bgColor,
    this.iconTextColor = AppColors.ink,
    this.progress,
    required this.progressLabel,
    this.isLocked = false,
    this.tag,
    this.isTool = false,
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
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeInOut));
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
          height: 68,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: d.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: d.iconGlyph.isNotEmpty
                      ? Text(
                          d.iconGlyph,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: d.iconTextColor,
                            fontFamily: 'NotoSansJavanese',
                          ),
                        )
                      : Icon(d.iconData, size: 22, color: d.iconTextColor),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  d.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                AppIcons.chevronRight,
                color: AppColors.inkSecondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

