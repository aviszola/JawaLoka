import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/presentation/widgets/javanese_calligraphy_painter.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';

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
      duration: const Duration(milliseconds: 900),
    )..forward();

    _heroScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _section1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.35, 0.65),
      ),
    );

    _section2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.5, 0.8),
      ),
    );

    _section3Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.65, 1.0),
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
        label: 'Kembali',
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Aksara Jawa',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
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
            child: const Text(
              'Dasar',
              style: TextStyle(
                fontSize: 12,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8EE),
            Color(0xFFFFF1D0),
            Color(0xFFF5E9C8),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Subtle Kawung Batik Watermark on hero card
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: BatikKawungPainter(opacity: 0.04),
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
                // Circular amber background with aksara
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: AppColors.amber,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40FFC247),
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CustomPaint(
                      size: Size(76, 76),
                      painter: JavaneseCalligraphyPainter(
                        aksara: 'ꦲ',
                        inkColor: AppColors.ink,
                        strokeThickness: 5.5,
                        showInkPools: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Latin name
                const Text(
                  'Ha',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),

                // Pronunciation
                const Text(
                  '/hɑ/',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.inkSecondary,
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
          icon: Icons.text_fields_rounded,
          label: 'Contoh Kata',
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _ExampleWordCard(
                aksara: 'ꦲꦫ',
                latin: 'Hara',
                meaning: 'Cabang',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ExampleWordCard(
                aksara: 'ꦲꦮꦸ',
                latin: 'Hawu',
                meaning: 'Tungku',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ExampleWordCard(
                aksara: 'ꦲꦱ꧀ꦛ',
                latin: 'Hastha',
                meaning: 'Delapan',
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
            style: TextStyle(
              fontSize: 22,
              color: AppColors.ink,
              fontFamilyFallback: const ['Noto Sans Javanese'],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            latin,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            meaning,
            style: const TextStyle(
              fontSize: 12,
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
          icon: Icons.tune_rounded,
          label: 'Sandangan',
        ),
        const SizedBox(height: 4),
        const Text(
          'Variasi vokal pada aksara ꦲ (Ha)',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 76,
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.amberSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.amber.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.combined,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.ink,
              fontFamilyFallback: const ['Noto Sans Javanese'],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.result,
            style: const TextStyle(
              fontSize: 12,
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
          icon: Icons.edit_note_rounded,
          label: 'Cara Menulis',
        ),
        const SizedBox(height: 12),
        const _WritingStepCard(
          step: 1,
          title: 'Mulai dari kanan atas',
          description: 'Tarik garis lengkung ke bawah dari titik awal di kanan atas.',
        ),
        const SizedBox(height: 8),
        const _WritingStepCard(
          step: 2,
          title: 'Lengkung badan aksara',
          description: 'Buat lengkungan utama yang membentuk tubuh aksara Ha ke kiri.',
        ),
        const SizedBox(height: 8),
        const _WritingStepCard(
          step: 3,
          title: 'Tutup dengan ekor',
          description: 'Akhiri dengan garis ekor pendek yang melengkung ke dalam.',
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
                style: const TextStyle(
                  fontSize: 14,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkSecondary,
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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
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

  const _BottomButtons({
    required this.onWritingTap,
    required this.onQuizTap,
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Latihan Menulis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.edit_rounded, color: Colors.white, size: 16),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mulai Kuis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.amberDark,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.track_changes_rounded, color: AppColors.amberDark, size: 16),
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
