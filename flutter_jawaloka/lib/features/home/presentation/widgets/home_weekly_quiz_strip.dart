import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/mock/mock_user_stats.dart';
import '../../../../core/theme/app_colors.dart';

/// 7-day strip displaying quiz completion status for the current week.
class HomeWeeklyQuizStrip extends StatelessWidget {
  const HomeWeeklyQuizStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AppColors.amberDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.homeWeeklyStripTitle,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                l10n.homeWeeklyCompletedCount(MockUserStats.quizzesThisWeek),
                style: const TextStyle(
                  color: AppColors.inkSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 7-day circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final dayIndex = i + 1; // 1 = Sen, 7 = Min
              final isCompleted = MockUserStats.completedQuizDaysOfWeek
                  .contains(dayIndex);

              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.amber
                          : const Color(0xFFF0EBE3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.amberDark
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: AppColors.ink,
                            )
                          : Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.inkMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayNames[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCompleted
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isCompleted ? AppColors.ink : AppColors.inkMuted,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.homeWeeklyStreakInfo(MockUserStats.streakDays),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
