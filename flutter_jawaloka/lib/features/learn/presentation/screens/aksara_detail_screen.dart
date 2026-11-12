import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/router/app_router.dart';
import '../../../quiz/domain/quest_target.dart';

/// JawaLoka Aksara Jawa Detail Screen
/// Shows a full breakdown of an aksara character: pronunciation, example words,
/// sandangan diacritics, writing tips, and navigation controls.
class AksaraDetailScreen extends StatefulWidget {
  const AksaraDetailScreen({super.key});

  @override
  State<AksaraDetailScreen> createState() => _AksaraDetailScreenState();
}

class _AksaraDetailScreenState extends State<AksaraDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _heroScale;
  late final Animation<double> _section1Fade;
  late final Animation<double> _section2Fade;
  late final Animation<double> _section3Fade;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();

    _heroScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _section1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.20, 0.65, curve: Curves.easeOut),
      ),
    );

    _section2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.40, 0.82, curve: Curves.easeOut),
      ),
    );

    _section3Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: _buildAppBar(context),
      body: AnimatedBuilder(
        animation: _entranceCtrl,
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

                      // ── Hero Card ──
                      ScaleTransition(
                        scale: _heroScale,
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _entranceCtrl,
                              curve: const Interval(0.0, 0.4),
                            ),
                          ),
                          child: const _AksaraHeroCard(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Contoh Kata Section ──
                      FadeTransition(
                        opacity: _section1Fade,
                        child: const _ContohKataSection(),
                      ),
                      const SizedBox(height: 24),

                      // ── Sandangan Section ──
                      FadeTransition(
                        opacity: _section2Fade,
                        child: const _SandanganSection(),
                      ),
                      const SizedBox(height: 24),

                      // ── Cara Menulis Section ──
                      FadeTransition(
                        opacity: _section3Fade,
                        child: const _CaraMenulisSection(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Bottom Button Row ──
              FadeTransition(
                opacity: _section3Fade,
                child: _BottomButtons(
                  onWritingTap: () =>
                      Navigator.pushNamed(context, AppRouter.drawingCanvas),
                  onQuizTap: () =>
                      Navigator.pushNamed(context, AppRouter.quizQuestion),
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
              AppIcons.back,
              size: 18,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.aksaraDetailTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.amberSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              context.l10n.aksaraDetailTag,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.amberDark,
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}

// ─────────────────────────────────────────────
//   Hero Card
// ─────────────────────────────────────────────

class _AksaraHeroCard extends StatelessWidget {
  const _AksaraHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryAmber,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Soft corner accent (Home hero benchmark)
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Stroke order mini indicators (top-right)
          Positioned(
            top: 16,
            right: 16,
            child: CustomPaint(
              size: const Size(60, 20),
              painter: AksaraStrokePainter(),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.04),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: Center(
                        child: Text(
                          QuestTarget.hanacarakaAll
                              .firstWhere((t) => t.glyphKey == 'ha')
                              .aksaraChar,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontFamily: 'NotoSansJavanese',
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ha',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.ink,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '/hɑ/',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w500,
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

/// Custom painter that draws stroke order arrows (3 steps).
class AksaraStrokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.amberDark.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final arrowPaint = Paint()
      ..color = AppColors.amberDark.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const double dotR = 6.0;
    const double spacing = 20.0;

    // Draw 3 stroke step dots with number labels
    for (int i = 0; i < 3; i++) {
      final cx = dotR + i * spacing;
      final cy = size.height / 2;

      canvas.drawCircle(Offset(cx, cy), dotR, dotPaint);

      // Number label
      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));

      // Arrow between dots
      if (i < 2) {
        final startX = cx + dotR + 2;
        final endX = cx + spacing - dotR - 2;
        final midY = cy;

        canvas.drawLine(Offset(startX, midY), Offset(endX, midY), arrowPaint);

        // Arrowhead
        final arrowPath = Path()
          ..moveTo(endX, midY)
          ..lineTo(endX - 4, midY - 3)
          ..moveTo(endX, midY)
          ..lineTo(endX - 4, midY + 3);
        canvas.drawPath(arrowPath, arrowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//   Contoh Kata Section
// ─────────────────────────────────────────────

class _ContohKataSection extends StatelessWidget {
  const _ContohKataSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: AppIcons.exampleText,
          label: context.l10n.aksaraDetailExampleHeader,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ExampleWordCard(
                aksara: 'ꦲꦫ',
                latin: 'Hara',
                meaning: context.l10n.aksaraDetailExampleHaraMeaning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ExampleWordCard(
                aksara: 'ꦲꦮꦸ',
                latin: 'Hawu',
                meaning: context.l10n.aksaraDetailExampleHawuMeaning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ExampleWordCard(
                aksara: 'ꦲꦱ꧀ꦛ',
                latin: 'Hastha',
                meaning: context.l10n.aksaraDetailExampleHasthaMeaning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExampleWordCard extends StatelessWidget {
  final String aksara;
  final String latin;
  final String meaning;

  const _ExampleWordCard({
    required this.aksara,
    required this.latin,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            aksara,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontFamilyFallback: const [
                'NotoSansJavanese',
                'Noto Sans Javanese',
              ],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            latin,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            meaning,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//   Sandangan Section
// ─────────────────────────────────────────────

class _SandanganSection extends StatelessWidget {
  const _SandanganSection();

  static const List<_SandanganData> _items = [
    _SandanganData(combined: 'ꦲꦶ', name: 'Wulu', result: 'Hi'),
    _SandanganData(combined: 'ꦲꦸ', name: 'Suku', result: 'Hu'),
    _SandanganData(combined: 'ꦲꦺ', name: 'Taling', result: 'He'),
    _SandanganData(combined: 'ꦲꦺꦴ', name: 'Taling-Tarung', result: 'Ho'),
    _SandanganData(combined: 'ꦲꦼ', name: 'Pepet', result: 'Hǝ'),
    _SandanganData(combined: 'ꦲꦃ', name: 'Visarga', result: 'Hah'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: AppIcons.sandangan,
          label: context.l10n.aksaraDetailSandanganHeader,
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.aksaraDetailSandanganSubtitle,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _SandanganChip(data: _items[i]),
          ),
        ),
      ],
    );
  }
}

class _SandanganData {
  final String combined;
  final String name;
  final String result;
  const _SandanganData({
    required this.combined,
    required this.name,
    required this.result,
  });
}

class _SandanganChip extends StatelessWidget {
  final _SandanganData data;
  const _SandanganChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.amberSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              data.combined,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamilyFallback: const [
                  'NotoSansJavanese',
                  'Noto Sans Javanese',
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.result,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.amberDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//   Cara Menulis Section
// ─────────────────────────────────────────────

class _CaraMenulisSection extends StatelessWidget {
  const _CaraMenulisSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: AppIcons.writingSteps,
          label: context.l10n.aksaraDetailWritingHeader,
        ),
        const SizedBox(height: 12),
        _WritingStepCard(
          step: 1,
          title: context.l10n.aksaraDetailStep1Title,
          description: context.l10n.aksaraDetailStep1Desc,
        ),
        const SizedBox(height: 8),
        _WritingStepCard(
          step: 2,
          title: context.l10n.aksaraDetailStep2Title,
          description: context.l10n.aksaraDetailStep2Desc,
        ),
        const SizedBox(height: 8),
        _WritingStepCard(
          step: 3,
          title: context.l10n.aksaraDetailStep3Title,
          description: context.l10n.aksaraDetailStep3Desc,
        ),
      ],
    );
  }
}

class _WritingStepCard extends StatelessWidget {
  final int step;
  final String title;
  final String description;

  const _WritingStepCard({
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.4,
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
//   Shared Section Header
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.amberSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.amberDark),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//   Bottom Buttons
// ─────────────────────────────────────────────

class _BottomButtons extends StatelessWidget {
  final VoidCallback onWritingTap;
  final VoidCallback onQuizTap;

  const _BottomButtons({required this.onWritingTap, required this.onQuizTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Writing practice button (primary)
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onWritingTap,
              child: Container(
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
                      context.l10n.aksaraDetailWritingButton,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      AppIcons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Quiz button (secondary outlined)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onQuizTap,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.amber, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.aksaraDetailQuizButton,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.amberDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      AppIcons.practiceTarget,
                      color: AppColors.amberDark,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
