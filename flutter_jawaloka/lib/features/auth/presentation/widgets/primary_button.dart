import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable primary pill button for JawaLoka.
/// Supports loading state with spinner, ink (dark) or amber variant.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isAmber;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double height;
  final double? width;
  final Widget? customChild;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isAmber = false,
    this.leadingIcon,
    this.trailingIcon,
    this.height = 56,
    this.width,
    this.customChild,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isAmber ? AppColors.amber : AppColors.ink;
    final textColor = isAmber ? AppColors.ink : Colors.white;
    final shadowColor = isAmber
        ? AppColors.amberDark.withValues(alpha: 0.4)
        : AppColors.ink.withValues(alpha: 0.3);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: onPressed == null && !isLoading ? 0.98 : 1.0,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            disabledBackgroundColor: bgColor.withValues(alpha: 0.7),
            shape: const StadiumBorder(),
            elevation: 0,
            shadowColor: shadowColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isAmber ? AppColors.ink : Colors.white,
                    ),
                  ),
                )
              : customChild ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leadingIcon != null) ...[
                          Icon(leadingIcon, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            letterSpacing: 0.1,
                          ),
                        ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(trailingIcon, size: 20),
                        ],
                      ],
                    ),
        ),
      ),
    );
  }
}

/// Secondary outlined button variant.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: const StadiumBorder(),
          backgroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.ink),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
