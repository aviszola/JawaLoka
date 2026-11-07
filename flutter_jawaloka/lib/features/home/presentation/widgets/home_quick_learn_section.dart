import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// Quick learning shortcuts row on HomeScreen.
class HomeQuickLearnSection extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeQuickLearnSection({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _QuickLearnItem(
        title: l10n.homeQuickLearnVocab,
        subtitle: l10n.homeQuickLearnVocabSub,
        icon: Icons.menu_book_rounded,
        bgColor: AppColors.pastelSand,
        iconColor: AppColors.amberDark,
        onTap: () => Navigator.pushNamed(context, AppRouter.vocabularyDetail),
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnAksara,
        subtitle: l10n.homeQuickLearnAksaraSub,
        icon: Icons.edit_note_rounded,
        bgColor: AppColors.amberSoft,
        iconColor: AppColors.accentOrange,
        onTap: () => Navigator.pushNamed(context, AppRouter.aksaraDetail),
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnTranslator,
        subtitle: l10n.homeQuickLearnTranslatorSub,
        icon: Icons.translate_rounded,
        bgColor: AppColors.pastelMint,
        iconColor: AppColors.pastelMintText,
        onTap: () => Navigator.pushNamed(context, AppRouter.translator),
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnEtiquette,
        subtitle: l10n.homeQuickLearnEtiquetteSub,
        icon: Icons.record_voice_over_rounded,
        bgColor: AppColors.pastelLavender,
        iconColor: AppColors.pastelLavenderText,
        onTap: () {
          if (onNavigateTab != null) {
            onNavigateTab!(1); // Belajar tab
          } else {
            Navigator.pushNamed(context, AppRouter.learnHub);
          }
        },
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnProverbs,
        subtitle: l10n.homeQuickLearnProverbsSub,
        icon: Icons.auto_stories_rounded,
        bgColor: AppColors.pastelBlush,
        iconColor: AppColors.pastelBlushText,
        onTap: () {
          if (onNavigateTab != null) {
            onNavigateTab!(1); // Belajar tab
          } else {
            Navigator.pushNamed(context, AppRouter.learnHub);
          }
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.homeQuickLearnTitle,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              l10n.homeQuickLearnSubtitle,
              style: const TextStyle(
                color: AppColors.inkSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final it = items[i];
              return GestureDetector(
                onTap: it.onTap,
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: it.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(it.icon, size: 18, color: it.iconColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        it.title,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        it.subtitle,
                        style: const TextStyle(
                          color: AppColors.inkSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickLearnItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickLearnItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}
