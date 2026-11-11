import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0E3C5), width: 1.2),
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
                      color: const Color(0xFFFFF3D6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFF4D483).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: Color(0xFFB87812),
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'MUTIARA PIWULANG',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Color(0xFFB87812),
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
                    Icons.refresh_rounded,
                    size: 18,
                    color: Color(0xFF7C6E5E),
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
                  style: const TextStyle(
                    fontFamily: 'NotoSansJavanese',
                    fontSize: 26,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF231C14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                '“${current.latin}”',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF85580C),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              current.meaning,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF7C6E5E),
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF6EE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0E3C5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.source,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF85580C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      current.context,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.45,
                        color: Color(0xFF231C14),
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
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A7E70),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: const Color(0xFF8A7E70),
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
