import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/presentation/widgets/wayang_gunungan_painter.dart';
import '../widgets/quiz_path_painter.dart';
import '../widgets/quiz_bottom_sheet.dart';
import '../../../../core/mock/mock_user_stats.dart';

/// Duolingo-style quiz path map with Javanese aesthetic.
class QuizPathScreen extends StatefulWidget {
  const QuizPathScreen({super.key});

  @override
  State<QuizPathScreen> createState() => _QuizPathScreenState();
}

class _QuizPathScreenState extends State<QuizPathScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;
  final int _completedQuizzes = MockUserStats.totalCompletedQuizzes;

  int _selectedDifficultyIndex = 0; // 0 = Mudah, 1 = Mahir, 2 = Sangat Mahir

  /// Data jalur kuis per unit pembelajaran.
  static final List<_PathNodeData> _nodes = [
    // Unit 1: Sapaan dan Salam
    const _PathNodeData(
      topicKey: 'salam',
      topicName: 'Salam',
      glyph: 'ꦱ',
      description: 'Pelajari salam dan tegur sapa sopan santun bahasa Jawa.',
      status: NodeStatus.completed,
      quizIndex: 1,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
      topicKey: 'pamit',
      topicName: 'Pamit',
      glyph: 'ꦥ',
      description: 'Ungkapan pamitan dan perpisahan sehari-hari yang santun.',
      status: NodeStatus.completed,
      quizIndex: 2,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
      topicKey: 'lencana',
      topicName: 'Lencana',
      glyph: 'ꦭ',
      description: 'Uji pemahaman tonggak materi sapaan dan salam.',
      status: NodeStatus.completed,
      isMilestone: true,
      quizIndex: 3,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
      topicKey: 'tanya_kabar',
      topicName: 'Tanya kabar',
      glyph: 'ꦠ',
      description: 'Menanyakan keadaan dan kabar orang lain dalam bahasa Jawa.',
      status: NodeStatus.current,
      quizIndex: 4,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
      topicKey: 'perkenalan',
      topicName: 'Perkenalan',
      glyph: 'ꦥ',
      description: 'Mengenalkan diri dengan unggah-ungguh yang tepat.',
      status: NodeStatus.locked,
      quizIndex: 5,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),

    // Unit 2: Keluarga dan Rumah (terkunci)
    const _PathNodeData(
      topicKey: 'keluarga',
      topicName: 'Keluarga',
      glyph: 'ꦏ',
      description: 'Sebutan anggota keluarga dan kerabat terdekat.',
      status: NodeStatus.locked,
      quizIndex: 1,
      totalInUnit: 3,
      unitTitle: 'Unit 2 · Tingkat Mudah',
      isUnit2: true,
    ),
    const _PathNodeData(
      topicKey: 'rumah',
      topicName: 'Rumah',
      glyph: 'ꦫ',
      description: 'Bagian-bagian rumah tradisional dan perlengkapan.',
      status: NodeStatus.locked,
      quizIndex: 2,
      totalInUnit: 3,
      unitTitle: 'Unit 2 · Tingkat Mudah',
      isUnit2: true,
    ),
    const _PathNodeData(
      topicKey: 'kerabat',
      topicName: 'Kerabat',
      glyph: 'ꦏ',
      description: 'Tingkatan silsilah keluarga besar masyarakat Jawa.',
      status: NodeStatus.locked,
      quizIndex: 3,
      totalInUnit: 3,
      unitTitle: 'Unit 2 · Tingkat Mudah',
      isUnit2: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPathSection(index),
                childCount: _nodes.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = context.l10n;
    final difficultyLevels = [
      l10n.difficultyMudah,
      l10n.difficultyMahir,
      l10n.difficultySangatMahir,
    ];
    return AppBar(
      backgroundColor: const Color(0xFFF5F1EB),
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Text(
        l10n.quizPathTitle,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 16, color: AppColors.amberDark),
              const SizedBox(width: 4),
              Text(
                l10n.quizCompletedBadge(_completedQuizzes),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          alignment: Alignment.centerLeft,
          child: Row(
            children: List.generate(difficultyLevels.length, (index) {
              final isSelected = _selectedDifficultyIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    difficultyLevels[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color:
                          isSelected ? AppColors.ink : const Color(0xFF7A6E60),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.amber,
                  backgroundColor: const Color(0xFFEFE8DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.amberDark
                          : const Color(0xFFD4CAB8),
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDifficultyIndex = index;
                      });
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitHeader(String title, String subtitle,
      {bool isLocked = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFE8E1D6) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLocked ? const Color(0xFFD4CAB8) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isLocked ? Icons.lock_outline_rounded : Icons.menu_book_rounded,
            color: isLocked ? const Color(0xFFADA49A) : AppColors.amberDark,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isLocked ? const Color(0xFFADA49A) : AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A6E60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathSection(int index) {
    final node = _nodes[index];
    final isEven = index % 2 == 0;

    return Column(
      children: [
        // Header for Unit 1 before the first node
        if (index == 0)
          _buildUnitHeader(
            context.l10n.quizUnit1Title,
            context.l10n.quizUnit1Subtitle,
          ),

        // Header for Unit 2 before the first locked node of Unit 2
        if (index == 5)
          _buildUnitHeader(
            context.l10n.quizUnit2Title,
            context.l10n.quizUnit2Subtitle,
            isLocked: true,
          ),

        // Draw connecting line to previous node (except first node of each unit)
        if (index > 0 && index != 5) _buildConnector(index),

        // The node itself
        Padding(
          padding: EdgeInsets.only(
            left: isEven ? 60 : 0,
            right: isEven ? 0 : 60,
          ),
          child: _buildNode(node),
        ),
      ],
    );
  }

  Widget _buildConnector(int index) {
    final prev = _nodes[index - 1];
    final curr = _nodes[index];
    final isLocked = curr.status == NodeStatus.locked;
    final isCompleted = prev.status == NodeStatus.completed;

    return Container(
      height: 48,
      alignment: Alignment.center,
      child: CustomPaint(
        size: const Size(100, 48),
        painter: _ConnectorPainter(
          isCompleted: isCompleted && !isLocked,
          isLocked: isLocked,
          flip: index % 2 == 0,
        ),
      ),
    );
  }

  Widget _buildNode(_PathNodeData node) {
    return GestureDetector(
      onTap: () => _onNodeTapped(node),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNodeCircle(node),
          const SizedBox(height: 6),
          _buildNodeLabel(node),
        ],
      ),
    );
  }

  Widget _buildNodeCircle(_PathNodeData node) {
    Widget circle;
    switch (node.status) {
      case NodeStatus.completed:
        circle = Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.amber,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.amberDark, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.amberDark.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: node.isMilestone
              ? const WayangGununganWidget(
                  width: 40,
                  height: 48,
                  style: GununganStyle.royal,
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      node.glyph,
                      style: const TextStyle(
                        fontSize: 30,
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NotoSansJavanese',
                      ),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        );
        break;

      case NodeStatus.current:
        circle = AnimatedBuilder(
          animation: _pulseAnim,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulse ring
                Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.45),
                        width: 3.5,
                      ),
                    ),
                  ),
                ),
                // Inner circle
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF9F3),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.amberDark, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.amberDark.withValues(alpha: 0.35),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: node.isMilestone
                      ? const WayangGununganWidget(
                          width: 38,
                          height: 46,
                          style: GununganStyle.royal,
                        )
                      : Text(
                          node.glyph,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.amberDark,
                            fontFamily: 'NotoSansJavanese',
                          ),
                        ),
                ),
              ],
            );
          },
        );
        break;

      case NodeStatus.locked:
        circle = Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E1D6),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4CAB8), width: 2),
          ),
          alignment: Alignment.center,
          child: node.isMilestone
              ? const Opacity(
                  opacity: 0.4,
                  child: WayangGununganWidget(
                    width: 34,
                    height: 42,
                    style: GununganStyle.watermark,
                  ),
                )
              : const Icon(
                  Icons.lock_rounded,
                  size: 26,
                  color: Color(0xFFADA49A),
                ),
        );
        break;
    }

    return SizedBox(width: 86, height: 86, child: Center(child: circle));
  }

  Widget _buildNodeLabel(_PathNodeData node) {
    final isLocked = node.status == NodeStatus.locked;
    return Column(
      children: [
        Text(
          node.getTopicName(context),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isLocked ? const Color(0xFFADA49A) : AppColors.ink,
          ),
        ),
        if (node.isMilestone)
          Text(
            context.l10n.quizMilestoneNode,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.amberDark,
            ),
          ),
      ],
    );
  }

  void _onNodeTapped(_PathNodeData node) {
    if (node.status == NodeStatus.locked) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.quizNodeLockedToast(node.getTopicName(context)),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    QuizBottomSheet.show(
      context,
      unitTitle: node.getUnitTitle(context),
      nodeTitle: node.getTopicName(context),
      quizIndex: node.quizIndex,
      totalQuizzes: node.totalInUnit,
      questionCount: 10,
      topicDescription: node.getDescription(context),
      onStart: () {
        Navigator.of(context).pushNamed(AppRouter.quizQuestion);
      },
    );
  }
}

class _PathNodeData {
  final String topicKey;
  final String topicName;
  final String glyph;
  final String description;
  final NodeStatus status;
  final bool isMilestone;
  final int quizIndex;
  final int totalInUnit;
  final String unitTitle;
  final bool isUnit2;

  const _PathNodeData({
    required this.topicKey,
    required this.topicName,
    required this.glyph,
    required this.description,
    required this.status,
    this.isMilestone = false,
    required this.quizIndex,
    required this.totalInUnit,
    this.unitTitle = 'Unit 1 · Tingkat Mudah',
    this.isUnit2 = false,
  });

  String getTopicName(BuildContext context) {
    switch (topicKey) {
      case 'salam':
        return context.l10n.quizTopicSalam;
      case 'pamit':
        return context.l10n.quizTopicPamit;
      case 'lencana':
        return context.l10n.quizTopicLencana;
      case 'tanya_kabar':
        return context.l10n.quizTopicTanyaKabar;
      case 'perkenalan':
        return context.l10n.quizTopicPerkenalan;
      case 'keluarga':
        return context.l10n.quizTopicKeluarga;
      case 'rumah':
        return context.l10n.quizTopicRumah;
      case 'kerabat':
        return context.l10n.quizTopicKerabat;
      default:
        return topicName;
    }
  }

  String getDescription(BuildContext context) {
    switch (topicKey) {
      case 'salam':
        return context.l10n.quizTopicSalamDesc;
      case 'pamit':
        return context.l10n.quizTopicPamitDesc;
      case 'lencana':
        return context.l10n.quizTopicLencanaDesc;
      case 'tanya_kabar':
        return context.l10n.quizTopicTanyaKabarDesc;
      case 'perkenalan':
        return context.l10n.quizTopicPerkenalanDesc;
      case 'keluarga':
        return context.l10n.quizTopicKeluargaDesc;
      case 'rumah':
        return context.l10n.quizTopicRumahDesc;
      case 'kerabat':
        return context.l10n.quizTopicKerabatDesc;
      default:
        return description;
    }
  }

  String getUnitTitle(BuildContext context) {
    return context.l10n.quizUnitTitle(
      isUnit2 ? 2 : 1,
      context.l10n.difficultyMudah,
    );
  }
}

/// Draws the small curved connector between two nodes.
class _ConnectorPainter extends CustomPainter {
  final bool isCompleted;
  final bool isLocked;
  final bool flip;

  const _ConnectorPainter({
    required this.isCompleted,
    required this.isLocked,
    required this.flip,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCompleted ? AppColors.amber : const Color(0xFFD4CAB8)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(flip ? size.width * 0.3 : size.width * 0.7, 0)
      ..quadraticBezierTo(
        size.width / 2,
        size.height / 2,
        flip ? size.width * 0.7 : size.width * 0.3,
        size.height,
      );

    if (isLocked) {
      _drawDashed(canvas, path, paint..color = const Color(0xFFD4CAB8));
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dashLen = 8.0;
    const gapLen = 5.0;
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(
            metric.extractPath(d, min(d + dashLen, metric.length)), paint);
        d += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) =>
      old.isCompleted != isCompleted || old.isLocked != isLocked;
}
