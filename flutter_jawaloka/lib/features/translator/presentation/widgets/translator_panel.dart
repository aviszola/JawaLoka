import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable input/output translation panel widget.
class TranslatorPanel extends StatelessWidget {
  /// true = output panel (amber soft bg), false = input panel (white bg)
  final bool isOutput;

  /// Label shown at top-left of the panel
  final String label;

  /// Language badge text
  final String languageBadge;

  /// Child content (TextFormField for input, Text for output)
  final Widget child;

  /// Optional trailing action buttons (copy, tts, clear)
  final List<Widget>? actions;

  /// Character counter string – only shown on input panel
  final String? characterCount;

  /// Whether to show language badge inside panel header
  final bool showLanguageBadge;

  const TranslatorPanel({
    super.key,
    required this.isOutput,
    required this.label,
    required this.languageBadge,
    required this.child,
    this.actions,
    this.characterCount,
    this.showLanguageBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isOutput ? AppColors.amberSoft : AppColors.surface;
    final border = isOutput
        ? AppColors.primaryAmber.withValues(alpha: 0.45)
        : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: label + language badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isOutput
                        ? AppColors.amberDark
                        : AppColors.inkSecondary,
                  ),
                ),
                const Spacer(),
                if (showLanguageBadge)
                  _LanguageBadge(label: languageBadge, isOutput: isOutput),
              ],
            ),
          ),

          // Content area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: child,
          ),

          // Bottom row: char counter + actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 10),
            child: Row(
              children: [
                ...?actions,
                const Spacer(),
                if (characterCount != null)
                  Text(
                    characterCount!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
}

class _LanguageBadge extends StatelessWidget {
  final String label;
  final bool isOutput;

  const _LanguageBadge({required this.label, required this.isOutput});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOutput
            ? AppColors.amber.withValues(alpha: 0.25)
            : AppColors.canvas,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isOutput
              ? AppColors.amberDark.withValues(alpha: 0.4)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isOutput ? AppColors.amberDark : AppColors.inkSecondary,
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder that fills its parent.
class ShimmerPlaceholder extends StatefulWidget {
  final double height;
  const ShimmerPlaceholder({super.key, this.height = 80});

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment(_anim.value - 1, 0),
              end: Alignment(_anim.value, 0),
              colors: const [
                AppColors.border,
                AppColors.canvas,
                AppColors.border,
              ],
            ),
          ),
        );
      },
    );
  }
}
