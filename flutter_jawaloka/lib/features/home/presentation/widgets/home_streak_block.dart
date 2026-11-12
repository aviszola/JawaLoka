import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';

/// Blok Streak utama di Beranda — menonjol namun ringkas.
/// Menampilkan angka hari streak dengan skala `displayLarge`, ikon api `accentOrange`,
/// dan satu baris keterangan jumlah kuis selesai minggu ini.
class HomeStreakBlock extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeStreakBlock({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final profile = ProfileScope.maybeOf(context);
    final streakDays = profile?.streakDays ?? 0;
    final quizzesThisWeek = profile?.quizzesThisWeek ?? 0;

    return GestureDetector(
      onTap: () {
        if (onNavigateTab != null) {
          onNavigateTab!(3);
        } else {
          Navigator.pushNamed(context, AppRouter.quizPath);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                AppIcons.streak,
                color: AppColors.accentOrange,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.streakDays(streakDays),
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.ink,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.homeStreakBlockSubtitle(quizzesThisWeek),
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.inkSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              AppIcons.forward,
              size: 18,
              color: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}
