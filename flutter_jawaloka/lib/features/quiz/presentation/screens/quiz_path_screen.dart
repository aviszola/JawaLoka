import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/quiz_path_painter.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/quiz_bottom_sheet.dart';
import 'package:flutter_jawaloka/core/mock/mock_user_stats.dart';

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
  static const List<String> _difficultyLevels = [
    'Mudah',
    'Mahir',
    'Sangat Mahir',
  ];

  /// Data jalur kuis per unit pembelajaran.
  static final List<_PathNodeData> _nodes = [
    // Unit 1: Sapaan dan Salam
    const _PathNodeData(
      topicName: 'Salam',
      glyph: 'ꦱ',
      description: 'Pelajari salam dan tegur sapa sopan santun bahasa Jawa.',
      status: NodeStatus.completed,
      quizIndex: 1,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
      topicName: 'Pamit',
      glyph: 'ꦥ',
      description: 'Ungkapan pamitan dan perpisahan sehari-hari yang santun.',
      status: NodeStatus.completed,
      quizIndex: 2,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
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
      topicName: 'Tanya kabar',
      glyph: 'ꦠ',
      description: 'Menanyakan keadaan dan kabar orang lain dalam bahasa Jawa.',
      status: NodeStatus.current,
      quizIndex: 4,
      totalInUnit: 5,
      unitTitle: 'Unit 1 · Tingkat Mudah',
    ),
    const _PathNodeData(
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
    return AppBar(
      backgroundColor: const Color(0xFFF5F1EB),
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text(
        'Jalur Kuis',
        style: TextStyle(
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
                '$_completedQuizzes Selesai',
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
            children: List.generate(_difficultyLevels.length, (index) {
              final isSelected = _selectedDifficultyIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    _difficultyLevels[index],
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
            'Unit 1: Sapaan dan Salam',
            'Dasar percakapan dan tata krama sopan santun',
          ),

        // Header for Unit 2 before the first locked node of Unit 2
        if (index == 5)
          _buildUnitHeader(
            'Unit 2: Keluarga dan Rumah (Terkunci)',
            'Silsilah keluarga, kerabat, dan lingkungan rumah',
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
      onTap:
          node.status == NodeStatus.locked ? null : () => _onNodeTapped(node),
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
            boxShadow: [
              BoxShadow(
                color: AppColors.amber.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            node.isMilestone
                ? Icons.military_tech_rounded
                : Icons.check_rounded,
            size: node.isMilestone ? 36 : 32,
            color: Colors.white,
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
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.35),
                        width: 3,
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
                    border: Border.all(color: AppColors.amber, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.amber.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: node.isMilestone
                      ? const Icon(
                          Icons.military_tech_rounded,
                          size: 36,
                          color: AppColors.amberDark,
                        )
                      : Text(
                          node.glyph,
                          style: const TextStyle(
                            fontSize: 32,
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
          child: Icon(
            node.isMilestone
                ? Icons.military_tech_rounded
                : Icons.lock_rounded,
            size: 28,
            color: const Color(0xFFADA49A),
          ),
        );
        break;
    }

    return SizedBox(width: 84, height: 84, child: Center(child: circle));
  }

  Widget _buildNodeLabel(_PathNodeData node) {
    final isLocked = node.status == NodeStatus.locked;
    return Column(
      children: [
        Text(
          node.topicName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isLocked ? const Color(0xFFADA49A) : AppColors.ink,
          ),
        ),
        if (node.isMilestone)
          const Text(
            'Node Tonggak',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.amberDark,
            ),
          ),
      ],
    );
  }

  void _onNodeTapped(_PathNodeData node) {
    QuizBottomSheet.show(
      context,
      unitTitle: node.unitTitle,
      nodeTitle: node.topicName,
      quizIndex: node.quizIndex,
      totalQuizzes: node.totalInUnit,
      questionCount: 10,
      topicDescription: node.description,
      onStart: () {
        Navigator.of(context).pushNamed(AppRouter.quizQuestion);
      },
    );
  }
}

class _PathNodeData {
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
