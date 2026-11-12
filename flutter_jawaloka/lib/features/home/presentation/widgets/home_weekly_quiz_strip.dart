import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
/// Strip Kuis Mingguan bernuansa kuning pastel hangat.
/// Kotak ikon pastel kuning di kiri atas, judul & hitungan, serta 7 lingkaran hari.
class HomeWeeklyQuizStrip extends StatelessWidget {
  const HomeWeeklyQuizStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final profile = ProfileScope.maybeOf(context);
    final quizzesThisWeek = profile?.quizzesThisWeek ?? 0;
    final completedDays = profile?.completedQuizDaysOfWeek ?? const <int>[];

    final dayNames = [
      l10n.dayMon,
      l10n.dayTue,
      l10n.dayWed,
      l10n.dayThu,
      l10n.dayFri,
      l10n.daySat,
      l10n.daySun,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Baris Atas: Ikon + Judul & Subjudul + Aksi ──
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  AppIcons.weeklyActivity,
                  color: AppColors.primaryDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeWeeklyStripTitle,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.homeWeeklyCompletedCount(quizzesThisWeek),
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.inkSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    AppIcons.forward,
                    size: 14,
                    color: AppColors.primaryDark,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Baris 7 Lingkaran Hari (Sen - Min) dengan Pembagian Rata ──
          Row(
            children: List.generate(7, (i) {
              final dayIndex = i + 1; // 1 = Sen, 7 = Min
              final isCompleted = completedDays.contains(dayIndex);

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primaryAmber
                            : AppColors.surfaceWarm,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.primaryDark
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                AppIcons.check,
                                size: 17,
                                color: AppColors.ink,
                              )
                            : Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.inkMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        dayNames[i],
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: isCompleted
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCompleted
                              ? AppColors.ink
                              : AppColors.inkSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
