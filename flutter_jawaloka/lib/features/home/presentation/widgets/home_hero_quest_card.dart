import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';

/// Kartu Misi Aktif — disederhanakan untuk anak kecil:
/// label "Misi Hari Ini", aksara target besar, judul pendek,
/// lencana +30 XP, bar progres bersegmen + "3/5", dan tombol "Mulai".
class HomeHeroQuestCard extends StatelessWidget {
  const HomeHeroQuestCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryAmber,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceWarm.withValues(alpha: 0.55),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                l10n.homeHeroQuestBadge.toUpperCase(),
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '+30 XP',
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWarm,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.primaryDark.withValues(alpha: 0.25),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'ꦲ',
                          style: textTheme.displayLarge?.copyWith(
                            fontFamily: 'NotoSansJavanese',
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.homeHeroQuestTitle,
                              style: textTheme.headlineLarge?.copyWith(
                                color: AppColors.ink,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: List.generate(5, (index) {
                                      final isFilled = index < 3;
                                      return Expanded(
                                        child: Container(
                                          height: 7,
                                          margin: EdgeInsets.only(
                                            right: index < 4 ? 5 : 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isFilled
                                                ? AppColors.primaryDark
                                                : AppColors.surfaceWarm
                                                      .withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  l10n.homeHeroQuestProgressRatio(3, 5),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.drawingCanvas);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.ink,
                        elevation: 0,
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 1.2,
                        ),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              l10n.quizPathBannerStart,
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            AppIcons.forward,
                            size: 16,
                            color: AppColors.ink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
