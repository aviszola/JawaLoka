import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';

/// Authentic Javanese ornamental divider featuring traditional typography marks
/// (Pada Adeg-adeg ꧋ and Pada Lungsi ꧉) flanked by fine ochre filigree rules.
class JavaneseOrnamentalDivider extends StatelessWidget {
  final String glyph;
  final Color? color;
  final double thickness;
  final double spacing;

  const JavaneseOrnamentalDivider({
    super.key,
    this.glyph = '꧋  ꧈  ꧉',
    this.color,
    this.thickness = 1.0,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.amberDark.withValues(alpha: 0.65);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: thickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveColor.withValues(alpha: 0.0),
                    effectiveColor,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.diamond, size: 8, color: effectiveColor),
                const SizedBox(width: 6),
                Text(
                  glyph,
                  style: TextStyle(
                    fontFamily: 'NotoSansJavanese',
                    fontSize: 14,
                    color: effectiveColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(AppIcons.diamond, size: 8, color: effectiveColor),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: thickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveColor,
                    effectiveColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
