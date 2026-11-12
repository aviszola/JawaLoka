import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Nada visual dialog JawaLoka sesuai tingkat dampak tindakan.
enum AppDialogTone {
  /// Informasi netral (ikon pada ubin surfaceWarm + primaryDark)
  info,

  /// Peringatan / keluar dari misi (ikon pada ubin primaryAmber + ink)
  warning,

  /// Tindakan destruktif / keluar akun (ikon pada ubin errorLight + error)
  destructive,
}

/// Menampilkan dialog berstandar JawaLoka menggunakan [AlertDialog]
/// dengan radius 24, ubin ikon bulat 56 dp di atas, judul & isi rata tengah,
/// dua tombol sejajar 48 dp, animasi masuk scale + fade 180 ms,
/// dan penghalang `AppColors.ink` 45%.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required AppDialogTone tone,
  required IconData icon,
  required String title,
  String? message,
  Widget? customContent,
  required String primaryLabel,
  required VoidCallback onPrimary,
  String? secondaryLabel,
  VoidCallback? onSecondary,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.ink.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _AppDialogContent(
        tone: tone,
        icon: icon,
        title: title,
        message: message,
        customContent: customContent,
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary,
      );
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _AppDialogContent extends StatelessWidget {
  final AppDialogTone tone;
  final IconData icon;
  final String title;
  final String? message;
  final Widget? customContent;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const _AppDialogContent({
    required this.tone,
    required this.icon,
    required this.title,
    this.message,
    this.customContent,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color tileBg;
    final Color tileIconColor;
    final Color primaryBg;
    final Color primaryFg;

    switch (tone) {
      case AppDialogTone.info:
        tileBg = AppColors.surfaceWarm;
        tileIconColor = AppColors.primaryDark;
        primaryBg = AppColors.primaryAmber;
        primaryFg = AppColors.ink;
      case AppDialogTone.warning:
        tileBg = AppColors.primaryAmber;
        tileIconColor = AppColors.ink;
        primaryBg = AppColors.primaryAmber;
        primaryFg = AppColors.ink;
      case AppDialogTone.destructive:
        tileBg = AppColors.errorLight;
        tileIconColor = AppColors.error;
        primaryBg = AppColors.error;
        primaryFg = AppColors.surface;
    }

    return AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: tileBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 28, color: tileIconColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(color: AppColors.ink),
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.inkSecondary,
                height: 1.4,
              ),
            ),
          ],
          if (customContent != null) ...[
            const SizedBox(height: 12),
            customContent!,
          ],
          const SizedBox(height: 20),
          if (secondaryLabel != null && onSecondary != null)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: onSecondary,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: tone == AppDialogTone.warning
                            ? AppColors.primaryDark
                            : AppColors.ink,
                        side: BorderSide(
                          color: tone == AppDialogTone.warning
                              ? AppColors.primaryAmber
                              : AppColors.border,
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          secondaryLabel!,
                          style: textTheme.labelLarge?.copyWith(
                            color: tone == AppDialogTone.warning
                                ? AppColors.primaryDark
                                : AppColors.ink,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onPrimary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBg,
                        foregroundColor: primaryFg,
                        elevation: 0,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          primaryLabel,
                          style: textTheme.labelLarge?.copyWith(
                            color: primaryFg,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onPrimary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBg,
                  foregroundColor: primaryFg,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  primaryLabel,
                  style: textTheme.labelLarge?.copyWith(color: primaryFg),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
