import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
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
      meaningId: 'Hidup itu harus menyala dan memberi manfaat bagi sesama.',
      meaningJv: 'Urip iku kudu murub lan migunani tumrap sapadha-padha.',
      meaningEn: 'Life should shine bright and bring benefit to others.',
      contextId:
          'Ajaran luhur tentang kebermanfaatan hidup: setiap manusia hendaknya selalu memberi cahaya kebaikan bagi masyarakat tanpa pamrih.',
      contextJv:
          'Piwulang luhur babagan guna gesang: saben manungsa prayogane tansah aweh pepadhang marang bebrayan agung tanpa pamrih.',
      contextEn:
          'A noble Javanese teaching on meaningful living: every person should strive to illuminate and help society selflessly.',
      sourceId: 'Piwulang Luhur Budaya Jawa (Sunan Kalijaga)',
      sourceJv: 'Piwulang Luhur Budaya Jawa (Sunan Kalijaga)',
      sourceEn: 'Noble Javanese Wisdom (Sunan Kalijaga)',
    ),
    _WisdomItem(
      aksara: 'ꦗꦼꦂꦧꦱꦸꦏꦶꦩꦮꦧꦺꦪ',
      latin: 'Jer Basuki Mawa Beya',
      meaningId:
          'Setiap keberhasilan dan kebahagiaan menuntut pengorbanan dan ikhtiar nyata.',
      meaningJv:
          'Saben kasuksesan lan kabagyan mesthi mbutuhake pangorbanan lan usaha nyata.',
      meaningEn:
          'Every success and well-being requires real effort and sacrifice.',
      contextId:
          'Kebijaksanaan tentang pengorbanan: segala cita-cita luhur selalu memerlukan biaya, tekad, dan kerja keras.',
      contextJv:
          'Kawicaksanan babagan pangorbanan: samubarang gegayuhan luhur mesthi mbutuhake ragad, tekad, lan kurbaning raga rasa.',
      contextEn:
          'Wisdom about dedication: every worthy aspiration demands commitment, perseverance, and sincere sacrifice.',
      sourceId: 'Sesanti Budaya Jawa',
      sourceJv: 'Sesanti Praja Jawa Timur',
      sourceEn: 'Traditional Javanese Motto',
    ),
    _WisdomItem(
      aksara: 'ꦲꦭꦺꦴꦤ꧀ꦲꦭꦺꦴꦤ꧀ꦮꦠꦺꦴꦤ꧀ꦏꦼꦭꦏꦺꦴꦤ꧀',
      latin: 'Alon-Alon Waton Kelakon',
      meaningId:
          'Ketelitian dan kehati-hatian lebih utama daripada ketergesa-gesaan yang mencelakakan.',
      meaningJv:
          'Kateliten lan pangati-ati luwih prayoga tinimbang kesusu kang bisa mbebayani.',
      meaningEn:
          'Steadiness and carefulness prevail over haste that leads to mistakes.',
      contextId:
          'Bukan anjuran untuk bermalas-malasan, melainkan prinsip kehati-hatian (prayitna) agar setiap langkah berpijak teguh.',
      contextJv:
          'Dudu piwulang supaya kesed, nanging paugeran pangati-ati (prayitna) supaya saben jangka bisa mantep lan kasil.',
      contextEn:
          'Not an excuse for laziness, but the principle of mindfulness (prayitna) so every step is steady and well-founded.',
      sourceId: 'Falsafah Budi Pekerti Luhur',
      sourceJv: 'Falsafah Budi Pekerti Luhur',
      sourceEn: 'Javanese Ethics Philosophy',
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
    final l10n = context.l10n;
    final langCode = Localizations.localeOf(context).languageCode;

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
                            l10n.homeWisdomBadge,
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
                  tooltip: l10n.homeWisdomNextTooltip,
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
              current.meaningFor(langCode),
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
                      current.sourceFor(langCode),
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      current.contextFor(langCode),
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
                          ? l10n.homeWisdomClose
                          : l10n.homeWisdomReadMore,
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
  final String meaningId;
  final String meaningJv;
  final String meaningEn;
  final String contextId;
  final String contextJv;
  final String contextEn;
  final String sourceId;
  final String sourceJv;
  final String sourceEn;

  const _WisdomItem({
    required this.aksara,
    required this.latin,
    required this.meaningId,
    required this.meaningJv,
    required this.meaningEn,
    required this.contextId,
    required this.contextJv,
    required this.contextEn,
    required this.sourceId,
    required this.sourceJv,
    required this.sourceEn,
  });

  String meaningFor(String code) => switch (code) {
    'jv' => meaningJv,
    'en' => meaningEn,
    _ => meaningId,
  };

  String contextFor(String code) => switch (code) {
    'jv' => contextJv,
    'en' => contextEn,
    _ => contextId,
  };

  String sourceFor(String code) => switch (code) {
    'jv' => sourceJv,
    'en' => sourceEn,
    _ => sourceId,
  };
}
