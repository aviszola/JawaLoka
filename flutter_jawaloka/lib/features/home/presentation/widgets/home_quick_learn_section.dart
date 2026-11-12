import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/router/app_router.dart';

/// Quick learning shortcuts row on HomeScreen.
class HomeQuickLearnSection extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeQuickLearnSection({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final items = [
      _QuickLearnItem(
        title: l10n.homeQuickLearnVocab,
        icon: AppIcons.vocab,
        tone: AppIconTone.sand,
        onTap: () => Navigator.pushNamed(context, AppRouter.vocabularyDetail),
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnAksara,
        iconGlyph: 'ꦲ',
        tone: AppIconTone.warm,
        onTap: () => Navigator.pushNamed(context, AppRouter.aksaraDetail),
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnTranslator,
        icon: AppIcons.translator,
        tone: AppIconTone.success,
        onTap: () => Navigator.pushNamed(context, AppRouter.translator),
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnEtiquette,
        icon: AppIcons.etiquette,
        tone: AppIconTone.warm,
        onTap: () {
          if (onNavigateTab != null) {
            onNavigateTab!(1);
          } else {
            Navigator.pushNamed(context, AppRouter.learnHub);
          }
        },
      ),
      _QuickLearnItem(
        title: l10n.homeQuickLearnProverbs,
        icon: AppIcons.proverbs,
        tone: AppIconTone.sand,
        onTap: () {
          if (onNavigateTab != null) {
            onNavigateTab!(1);
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
            Expanded(
              child: Text(
                l10n.homeQuickLearnTitle,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final it = items[i];
              return GestureDetector(
                onTap: it.onTap,
                child: Container(
                  width: 108,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
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
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: it.tone.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: it.iconGlyph != null
                            ? Text(
                                it.iconGlyph!,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontFamily: 'NotoSansJavanese',
                                  fontWeight: FontWeight.w700,
                                  color: it.tone.iconColor,
                                  height: 1.1,
                                ),
                              )
                            : Icon(
                                it.icon,
                                size: 18,
                                color: it.tone.iconColor,
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        it.title,
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
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
  final IconData? icon;
  final String? iconGlyph;
  final AppIconTone tone;
  final VoidCallback onTap;

  const _QuickLearnItem({
    required this.title,
    this.icon,
    this.iconGlyph,
    required this.tone,
    required this.onTap,
  });
}
