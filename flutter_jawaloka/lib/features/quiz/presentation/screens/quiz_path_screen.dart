import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/presentation/widgets/wayang_gunungan_painter.dart';
import '../widgets/quiz_bottom_sheet.dart';
import '../../../../core/profile/profile_controller.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../domain/curriculum/curriculum_quiz_bank.dart';
import '../../domain/quiz_path_models.dart';
import '../../domain/quiz_path_data.dart';
import 'quiz_question_screen.dart';

/// Duolingo-style quiz path map with Javanese aesthetic and 50-node extended curriculum.
class QuizPathScreen extends StatefulWidget {
  const QuizPathScreen({super.key});

  @override
  State<QuizPathScreen> createState() => _QuizPathScreenState();
}

class _QuizPathScreenState extends State<QuizPathScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  int? _selectedDifficultyIndex; // null = auto-select from profile userLevel

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jumpLabel = context.l10n.homeContinueQuizButton;
    final profile = ProfileScope.maybeOf(context);
    final units = profile != null
        ? QuizPathData.resolveCurriculum(
            clearedActivities: profile.clearedActivities,
            isEvaluationPassed: profile.isEvaluationPassed,
          )
        : QuizPathData.units;
    final nodes = units.expand((u) => u.nodes).toList(growable: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: _buildAppBar(nodes, profile),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPathSection(index, nodes, units),
                childCount: nodes.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _scrollToActiveNode(nodes),
        backgroundColor: AppColors.amber,
        foregroundColor: AppColors.ink,
        elevation: 3,
        icon: const Icon(Icons.navigation_rounded, size: 20),
        label: Text(
          jumpLabel,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    List<QuizPathNode> nodes,
    ProfileController? profile,
  ) {
    final l10n = context.l10n;
    final difficultyLevels = [
      l10n.difficultyMudah,
      l10n.difficultyMahir,
      l10n.difficultySangatMahir,
    ];
    final completedCount = profile != null
        ? nodes.where((n) => n.status == NodeStatus.completed).length
        : 0;
    final completedCountText = l10n.quizCompletedBadge(completedCount);
    final activeDifficultyIndex = _selectedDifficultyIndex ??
        (profile != null
            ? (profile.userLevel <= 3
                ? 0
                : (profile.userLevel <= 6 ? 1 : 2))
            : 0);

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
              const Icon(
                Icons.star_rounded,
                size: 16,
                color: AppColors.amberDark,
              ),
              const SizedBox(width: 4),
              Text(
                completedCountText,
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
              final isSelected = activeDifficultyIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    difficultyLevels[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.ink
                          : const Color(0xFF7A6E60),
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

  Widget _buildUnitHeader(QuizUnitData unit) {
    final isLocked = unit.isLocked;
    final title = unit.getLocalizedTitle(context);
    final subtitle = unit.getLocalizedSubtitle(context);
    final progressBadge = '${unit.completedCount}/${unit.nodes.length}';

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFE8E1D6) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLocked ? const Color(0xFFD4CAB8) : AppColors.border,
        ),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFD4CAB8).withValues(alpha: 0.5)
                  : AppColors.amber.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              isLocked
                  ? Icons.lock_outline_rounded
                  : (unit.unitId == 5
                        ? Icons.military_tech_rounded
                        : Icons.menu_book_rounded),
              color: isLocked ? const Color(0xFFADA49A) : AppColors.amberDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 2),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFFD4CAB8).withValues(alpha: 0.4)
                  : AppColors.amber.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              progressBadge,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isLocked ? const Color(0xFF8A8073) : AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathSection(
    int index,
    List<QuizPathNode> nodes,
    List<QuizUnitData> units,
  ) {
    final node = nodes[index];
    final isFirstInUnit = node.indexInUnit == 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Unit header before the first node of each unit
        if (isFirstInUnit) _buildUnitHeader(units[node.unitId - 1]),

        // Connector from previous node in the same unit
        if (!isFirstInUnit) _buildConnector(index, nodes),

        // Node with smooth horizontal positioning
        Align(
          alignment: Alignment(node.position.alignmentX, 0),
          child: _buildNode(node),
        ),
      ],
    );
  }

  Widget _buildConnector(int index, List<QuizPathNode> nodes) {
    final prev = nodes[index - 1];
    final curr = nodes[index];
    final isLocked = curr.status == NodeStatus.locked;
    final isCompleted = prev.status == NodeStatus.completed;

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: CustomPaint(
        painter: _ConnectorPainter(
          startAlignmentX: prev.position.alignmentX,
          endAlignmentX: curr.position.alignmentX,
          isCompleted: isCompleted && !isLocked,
          isLocked: isLocked,
        ),
      ),
    );
  }

  Widget _buildNode(QuizPathNode node) {
    final localizedTitle = node.getLocalizedTitle(context);

    return Semantics(
      button: true,
      label: localizedTitle,
      child: GestureDetector(
        onTap: () => _onNodeTapped(node),
        child: SizedBox(
          width: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNodeCircle(node),
              const SizedBox(height: 6),
              _buildNodeLabel(node),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodeCircle(QuizPathNode node) {
    Widget circle;
    final isFinalExam = node.type == QuizNodeType.finalExam;

    switch (node.status) {
      case NodeStatus.completed:
        circle = Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.amber,
            shape: BoxShape.circle,
            border: Border.all(
              color: isFinalExam
                  ? const Color(0xFFB8860B)
                  : AppColors.amberDark,
              width: isFinalExam ? 3.0 : 2.5,
            ),
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
                    border: Border.all(
                      color: isFinalExam
                          ? const Color(0xFFB8860B)
                          : AppColors.amberDark,
                      width: 3,
                    ),
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

    if (isFinalExam) {
      return SizedBox(
        width: 86,
        height: 86,
        child: Stack(
          alignment: Alignment.center,
          children: [
            circle,
            Positioned(
              top: 0,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.amberDark, width: 1.5),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 14,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(width: 86, height: 86, child: Center(child: circle));
  }

  Widget _buildNodeLabel(QuizPathNode node) {
    final isLocked = node.status == NodeStatus.locked;
    final localizedTitle = node.getLocalizedTitle(context);
    final milestoneLabel = context.l10n.quizMilestoneNode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          localizedTitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isLocked ? const Color(0xFFADA49A) : AppColors.ink,
          ),
        ),
        if (node.topicKey == 'lencana')
          Text(
            milestoneLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.amberDark,
            ),
          ),
      ],
    );
  }

  void _onNodeTapped(QuizPathNode node) {
    final localizedTitle = node.getLocalizedTitle(context);

    if (node.status == NodeStatus.locked) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final lockedToast = context.l10n.quizNodeLockedToast(localizedTitle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lockedToast),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final profile = ProfileScope.maybeOf(context);
    final level = profile?.userLevel ?? 1;

    // Map difficulty: use explicitly selected chip if set, else auto-tier by userLevel
    final activeDifficulty = _selectedDifficultyIndex ??
        (level <= 3 ? 0 : (level <= 6 ? 1 : 2));

    final difficulty = activeDifficulty == 0
        ? QuizDifficulty.mudah
        : (activeDifficulty == 1
            ? QuizDifficulty.mahir
            : QuizDifficulty.sangatMahir);

    final questions = CurriculumQuizBank.getQuestionsForNode(
      node,
      difficulty: difficulty,
    );

    final isEvaluation =
        node.type == QuizNodeType.milestone ||
        node.type == QuizNodeType.finalExam ||
        node.topicKey.startsWith('evaluasi_');

    QuizBottomSheet.show(
      context,
      unitTitle: node.getUnitTitle(context),
      nodeTitle: localizedTitle,
      quizIndex: node.indexInUnit,
      totalQuizzes: 10,
      questionCount: questions.length,
      topicDescription: node.getLocalizedDescription(context),
      onStart: () {
        Navigator.of(context).pushNamed(
          AppRouter.quizQuestion,
          arguments: QuizQuestionArgs(
            questions: questions,
            moduleTitle: localizedTitle,
            userLevel: level,
            activityId: node.id,
            isEvaluation: isEvaluation,
          ),
        );
      },
    );
  }

  void _scrollToActiveNode(List<QuizPathNode> nodes) {
    if (!_scrollController.hasClients) return;
    HapticFeedback.selectionClick();

    final activeIndex = nodes.indexWhere(
      (n) => n.status == NodeStatus.current,
    );
    final targetIndex = activeIndex != -1 ? activeIndex : nodes.length - 1;

    final unitHeadersBefore = (targetIndex / 10).floor() + 1;
    final estimatedOffset =
        (targetIndex * 150.0) + (unitHeadersBefore * 90.0) - 160.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = estimatedOffset.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }
}

/// Draws the curved bezier connector between two nodes with smooth horizontal positioning.
class _ConnectorPainter extends CustomPainter {
  final double startAlignmentX;
  final double endAlignmentX;
  final bool isCompleted;
  final bool isLocked;

  const _ConnectorPainter({
    required this.startAlignmentX,
    required this.endAlignmentX,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCompleted ? AppColors.amber : const Color(0xFFD4CAB8)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Node wrapper width is 120. Calculate center of child in Align(alignment: Alignment(x, 0)).
    final availableWidth = size.width - 120;
    final startCenterX =
        size.width / 2 + (startAlignmentX * availableWidth / 2);
    final endCenterX = size.width / 2 + (endAlignmentX * availableWidth / 2);

    final startPoint = Offset(startCenterX, 0);
    final endPoint = Offset(endCenterX, size.height);
    final midY = size.height / 2;

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..cubicTo(
        startPoint.dx,
        midY,
        endPoint.dx,
        midY,
        endPoint.dx,
        endPoint.dy,
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
          metric.extractPath(d, min(d + dashLen, metric.length)),
          paint,
        );
        d += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) =>
      old.startAlignmentX != startAlignmentX ||
      old.endAlignmentX != endAlignmentX ||
      old.isCompleted != isCompleted ||
      old.isLocked != isLocked;
}
