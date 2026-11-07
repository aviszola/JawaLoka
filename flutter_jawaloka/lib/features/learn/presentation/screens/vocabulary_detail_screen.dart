import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// JawaLoka Vocabulary Detail Screen
/// Shows a full breakdown of a Javanese word: aksara, meaning in 3 languages,
/// example sentences, and navigation controls.
class VocabularyDetailScreen extends StatefulWidget {
  final String? word;

  const VocabularyDetailScreen({super.key, this.word});

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;

  late final AnimationController _slideCtrl;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: const Interval(0.4, 1.0),
      ),
    );
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: _buildAppBar(context),
      body: AnimatedBuilder(
        animation: _slideCtrl,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Hero "Sand" Card ──
                      SlideTransition(
                        position: _heroSlide,
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _slideCtrl,
                              curve: const Interval(0.0, 0.5),
                            ),
                          ),
                          child: const _HeroWordCard(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Makna Section ──
                      FadeTransition(
                        opacity: _contentFade,
                        child: const _MaknaSection(),
                      ),
                      const SizedBox(height: 24),

                      // ── Contoh Kalimat Section ──
                      FadeTransition(
                        opacity: _contentFade,
                        child: const _ContohKalimatSection(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Bottom Action Buttons ──
              FadeTransition(
                opacity: _contentFade,
                child: _BottomActions(
                  isFavorite: _isFavorite,
                  onFavorite: () => setState(() => _isFavorite = !_isFavorite),
                  onNext: () => Navigator.pushReplacementNamed(
                    context,
                    AppRouter.vocabularyDetail,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.canvas,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Semantics(
        label: context.l10n.commonBack,
        button: true,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
      title: Text(
        context.l10n.vocabDetailTitle,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.pastelMint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            context.l10n.vocabDetailTag,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.pastelMintText,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//   Hero Word Card
// ─────────────────────────────────────────────

class _HeroWordCard extends StatelessWidget {
  const _HeroWordCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pastelSand,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Watermark glyph
          Positioned(
            right: 16,
            bottom: -12,
            child: Text(
              'ꦲ',
              style: TextStyle(
                fontSize: 100,
                color: AppColors.ink.withValues(alpha: 0.05),
                fontFamilyFallback: const ['Noto Sans Javanese'],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                // Left: Word + Aksara + Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Omah',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -1,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ꦲꦺꦴꦩꦃ',
                        style: TextStyle(
                          fontSize: 30,
                          color: AppColors.inkSecondary,
                          fontFamilyFallback: const ['Noto Sans Javanese'],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.amberSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Ngoko',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.amberDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Audio button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33FFC247),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.ink,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//   Makna (Meaning) Section
// ─────────────────────────────────────────────

class _MaknaSection extends StatelessWidget {
  const _MaknaSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider with label
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  context.l10n.vocabDetailMeaningHeader,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 16),

        // Meaning cards
        const _MeaningCard(
          badgeText: 'ID',
          language: 'Bahasa Indonesia',
          value: 'Rumah',
          backgroundColor: AppColors.pastelMint,
          textColor: AppColors.pastelMintText,
        ),
        const SizedBox(height: 10),
        const _MeaningCard(
          badgeText: 'EN',
          language: 'English',
          value: 'House',
          backgroundColor: AppColors.pastelLavender,
          textColor: AppColors.pastelLavenderText,
        ),
        const SizedBox(height: 10),
        const _MeaningCard(
          badgeText: 'ꦗꦮ',
          language: 'Basa Jawa (Ngoko)',
          value: 'Omah',
          backgroundColor: AppColors.pastelSand,
          textColor: AppColors.ink,
          isJavanese: true,
        ),
      ],
    );
  }
}

class _MeaningCard extends StatelessWidget {
  final String badgeText;
  final String language;
  final String value;
  final Color backgroundColor;
  final Color textColor;
  final bool isJavanese;

  const _MeaningCard({
    required this.badgeText,
    required this.language,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
    this.isJavanese = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: isJavanese ? 14 : 12,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  fontFamilyFallback: isJavanese ? const ['Noto Sans Javanese'] : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.7),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//   Contoh Kalimat Section
// ─────────────────────────────────────────────

class _ContohKalimatSection extends StatelessWidget {
  const _ContohKalimatSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 16,
              color: AppColors.inkSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.vocabDetailExamplesHeader,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _ExampleSentenceCard(
          javanese: 'Omahku ana ing desa',
          aksara: 'ꦲꦺꦴꦩꦃꦏꦸꦲꦤꦆꦁꦢꦺꦱ',
          translation: 'Rumahku ada di desa',
          index: 1,
        ),
        const SizedBox(height: 10),
        const _ExampleSentenceCard(
          javanese: 'Omah iki gedhe banget',
          aksara: 'ꦲꦺꦴꦩꦃꦲꦶꦏꦶꦒꦼꦝꦺꦧꦔꦼꦠ꧀',
          translation: 'Rumah ini sangat besar',
          index: 2,
        ),
      ],
    );
  }
}

class _ExampleSentenceCard extends StatelessWidget {
  final String javanese;
  final String aksara;
  final String translation;
  final int index;

  const _ExampleSentenceCard({
    required this.javanese,
    required this.aksara,
    required this.translation,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.amberSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.amberDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  javanese,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  aksara,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.inkSecondary,
                    fontFamilyFallback: const ['Noto Sans Javanese'],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  translation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.inkMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//   Bottom Actions
// ─────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onNext;

  const _BottomActions({
    required this.isFavorite,
    required this.onFavorite,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Next word button
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.vocabDetailNextButton,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Favorite outlined button
          GestureDetector(
            onTap: onFavorite,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: isFavorite ? AppColors.amberSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isFavorite ? AppColors.amber : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? AppColors.amberDark : AppColors.inkSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFavorite
                        ? context.l10n.vocabDetailFavoriteMarked
                        : context.l10n.vocabDetailFavoriteMark,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isFavorite ? AppColors.amberDark : AppColors.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
