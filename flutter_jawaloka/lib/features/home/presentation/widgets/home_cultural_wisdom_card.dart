import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';

/// Interactive cultural wisdom card displaying daily Javanese proverbs (Paribasan)
/// with authentic Aksara script, transliteration, and philosophical commentary.
class HomeCulturalWisdomCard extends StatefulWidget {
  const HomeCulturalWisdomCard({super.key});

  @override
  State<HomeCulturalWisdomCard> createState() => _HomeCulturalWisdomCardState();
}

class _HomeCulturalWisdomCardState extends State<HomeCulturalWisdomCard> {
  int _currentIndex = 0;
  bool _isExpanded = false;

  static const List<_WisdomItem> _proverbs = [
    _WisdomItem(
      aksara: 'ꦲꦸꦫꦶꦥ꧀ꦲꦶꦏꦸꦲꦸꦫꦸꦥ꧀',
      latin: 'Urip Iku Urup',
      meaning: 'Hidup itu harus menyala dan memberi manfaat bagi sesama.',
      context:
          'Piwulang luhur babagan guna gesang: saben manungsa prayogane tansah aweh pepadhang marang bebrayan agung tanpa pamrih.',
      source: 'Serat Wedhatama — Pupuh Pangkur',
    ),
    _WisdomItem(
      aksara: 'ꦗꦼꦂꦧꦱꦸꦏꦶꦩꦮꦧꦺꦪ',
      latin: 'Jer Basuki Mawa Beya',
      meaning:
          'Setiap keberhasilan dan kebahagiaan menuntut pengorbanan dan ikhtiar nyata.',
      context:
          'Kawicaksanan babagan pangorbanan: samubarang gegayuhan luhur mesthi mbutuhake ragad, tekad, lan kurbaning raga rasa.',
      source: 'Sesanti Praja Jawa Timur',
    ),
    _WisdomItem(
      aksara: 'ꦲꦭꦺꦴꦤ꧀ꦲꦭꦺꦴꦤ꧀ꦮꦠꦺꦴꦤ꧀ꦏꦼꦭꦏꦺꦴꦤ꧀',
      latin: 'Alon-Alon Waton Kelakon',
      meaning:
          'Ketelitian dan kehati-hatian lebih utama daripada ketergesa-gesaan yang mencelakakan.',
      context:
          'Bukan anjuran untuk bermalas-malasan, melainkan prinsip kehati-hatian (pradapa) agar setiap langkah berpijak teguh.',
      source: 'Falsafah Budi Pekerti Luhur',
    ),
  ];

  void _nextProverb() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _proverbs.length;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _proverbs[_currentIndex];
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          AppIcons.sparkle,
                          size: 12,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'MUTIARA PIWULANG',
                            style: textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.primaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    AppIcons.refresh,
                    size: 18,
                    color: AppColors.inkSecondary,
                  ),
                  onPressed: _nextProverb,
                  tooltip: 'Ganti Piwulang',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  current.aksara,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    fontFamily: 'NotoSansJavanese',
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                '“${current.latin}”',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              current.meaning,
              textAlign: TextAlign.center,
              maxLines: _isExpanded ? null : 1,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                height: 1.4,
                color: AppColors.inkSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.source,
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      current.context,
                      style: textTheme.labelMedium?.copyWith(
                        height: 1.45,
                        color: AppColors.ink,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _isExpanded
                          ? 'Tutup Makna Luhur'
                          : 'Waca Makna Luhur & Sumber',
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? AppIcons.expandLess
                        : AppIcons.expandMore,
                    size: 16,
                    color: AppColors.inkMuted,
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

class _WisdomItem {
  final String aksara;
  final String latin;
  final String meaning;
  final String context;
  final String source;

  const _WisdomItem({
    required this.aksara,
    required this.latin,
    required this.meaning,
    required this.context,
    required this.source,
  });
}
