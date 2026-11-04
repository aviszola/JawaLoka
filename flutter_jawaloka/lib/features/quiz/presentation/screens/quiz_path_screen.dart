import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/quiz_path_painter.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/quiz_bottom_sheet.dart';

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
  int _totalXP = 350;

  /// Demo path data - in production this comes from a repository.
  static final List<_PathNodeData> _nodes = [
    _PathNodeData(
        javaScript: 'ꦲ', latinName: 'Ha', status: NodeStatus.completed, level: 1),
    _PathNodeData(
        javaScript: 'ꦤ', latinName: 'Na', status: NodeStatus.completed, level: 2),
    _PathNodeData(
        javaScript: 'ꦕ', latinName: 'Ca', status: NodeStatus.completed, level: 3),
    _PathNodeData(
        javaScript: 'ꦫ', latinName: 'Ra', status: NodeStatus.current, level: 4),
    _PathNodeData(
        javaScript: 'ꦏ', latinName: 'Ka', status: NodeStatus.locked, level: 5),
    _PathNodeData(
        javaScript: 'ꦢ', latinName: 'Da', status: NodeStatus.locked, level: 6),
    _PathNodeData(
        javaScript: 'ꦠ', latinName: 'Ta', status: NodeStatus.locked, level: 7),
    _PathNodeData(
        javaScript: 'ꦱ', latinName: 'Sa', status: NodeStatus.locked, level: 8),
    _PathNodeData(
        javaScript: 'ꦮ', latinName: 'Wa', status: NodeStatus.locked, level: 9),
    _PathNodeData(
        javaScript: 'ꦭ', latinName: 'La', status: NodeStatus.locked, level: 10),
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
      centerTitle: true,
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
              const Text('⭐', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '$_totalXP XP',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPathSection(int index) {
    final node = _nodes[index];
    final isEven = index % 2 == 0;

    return Column(
      children: [
        // Draw connecting line to previous node (except first)
        if (index > 0) _buildConnector(index),
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
      onTap: node.status == NodeStatus.locked
          ? null
          : () => _onNodeTapped(node),
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
                color: AppColors.amber.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.check_rounded, size: 32, color: Colors.white),
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
                        color: AppColors.amber.withOpacity(0.35),
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
                        color: AppColors.amber.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    node.javaScript,
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
          child: const Icon(Icons.lock_rounded, size: 28, color: Color(0xFFADA49A)),
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
          node.javaScript,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'NotoSansJavanese',
            color: isLocked ? const Color(0xFFADA49A) : AppColors.ink,
          ),
        ),
        Text(
          node.latinName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isLocked ? const Color(0xFFADA49A) : const Color(0xFF7A6E60),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  void _onNodeTapped(_PathNodeData node) {
    QuizBottomSheet.show(
      context,
      moduleTitle: 'Aksara ${node.latinName}',
      questionCount: 12,
      estimatedMinutes: 8,
      xpReward: 50,
      onStart: () {
        Navigator.of(context).pushNamed(AppRouter.quizQuestion);
      },
      onRestart: () {
        Navigator.of(context).pushNamed(AppRouter.quizQuestion);
      },
    );
  }
}

class _PathNodeData {
  final String javaScript;
  final String latinName;
  final NodeStatus status;
  final int level;

  const _PathNodeData({
    required this.javaScript,
    required this.latinName,
    required this.status,
    required this.level,
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
