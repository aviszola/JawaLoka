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

  const TranslatorPanel({
    super.key,
    required this.isOutput,
    required this.label,
    required this.languageBadge,
    required this.child,
    this.actions,
    this.characterCount,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isOutput ? AppColors.amberSoft : AppColors.surface;
    final border = isOutput ? AppColors.amber.withOpacity(0.35) : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withOpacity(0.06),
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
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isOutput ? AppColors.amberDark : const Color(0xFF6B6257),
                  ),
                ),
                const Spacer(),
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
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 10),
            child: Row(
              children: [
                if (characterCount != null)
                  Text(
                    characterCount!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B6257),
                    ),
                  ),
                const Spacer(),
                if (actions != null) ...actions!,
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
        color: isOutput ? AppColors.amber.withOpacity(0.25) : const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isOutput ? AppColors.amberDark.withOpacity(0.4) : const Color(0xFFE8E1D6),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isOutput ? AppColors.amberDark : const Color(0xFF6B6257),
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
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
                Color(0xFFE8E1D6),
                Color(0xFFF5F1EB),
                Color(0xFFE8E1D6),
              ],
            ),
          ),
        );
      },
    );
  }
}
