import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/quiz_bottom_sheet.dart';
import '../widgets/temple_zone_background.dart';
import '../../../../core/profile/profile_controller.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../domain/curriculum/curriculum_quiz_bank.dart';
import '../../domain/quiz_path_models.dart';
import '../../domain/quiz_path_data.dart';
import 'quiz_question_screen.dart';

/// Mission Path screen displaying the 50-node Javanese learning journey across 5 cultural units.
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
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
    final profile = ProfileScope.maybeOf(context);
    final units = profile != null
        ? QuizPathData.resolveCurriculum(
            clearedActivities: profile.clearedActivities,
            isEvaluationPassed: profile.isEvaluationPassed,
          )
        : QuizPathData.units;
    final nodes = units.expand((u) => u.nodes).toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: _buildAppBar(nodes, profile),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildContinueBanner(nodes)),
          for (final unit in units)
            SliverToBoxAdapter(child: _buildUnitBand(unit)),
          const SliverPadding(padding: EdgeInsets.only(bottom: 104)),
        ],
      ),
    );
  }

  Widget _buildContinueBanner(List<QuizPathNode> nodes) {
    if (nodes.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final activeNode = nodes.firstWhere(
      (n) => n.status == NodeStatus.current,
      orElse: () => nodes.last,
    );
    final completedCount =
        nodes.where((n) => n.status == NodeStatus.completed).length;
    final progress = completedCount / nodes.length;
    final bannerProgressText =
        '· ${l10n.quizPathBannerProgress(completedCount, nodes.length)}';
    final activeNodeTitleText =
        '${activeNode.nodeNumber}. ${activeNode.getLocalizedTitle(context)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: GestureDetector(
        onTap: () => _scrollToActiveNode(nodes),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppColors.primaryAmber),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  AppIcons.continueMission,
                  color: AppColors.primaryDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.quizPathBannerTitle,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            bannerProgressText,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.inkSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activeNodeTitleText,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryAmber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _onNodeTapped(activeNode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  foregroundColor: AppColors.surface,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  l10n.quizPathBannerStart,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ),
            ],
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
    final completedCount = profile != null
        ? nodes.where((n) => n.status == NodeStatus.completed).length
        : 0;
    final completedCountText = l10n.quizCompletedBadge(completedCount);

    return AppBar(
      backgroundColor: AppColors.canvas,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Text(
        l10n.quizPathTitle,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryAmber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.star,
                size: 16,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 4),
              Text(
                completedCountText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  String _zoneLabelForUnit(BuildContext context, int unitId) {
    final l10n = context.l10n;
    switch (unitId) {
      case 1:
        return l10n.kratonZone1Label;
      case 2:
        return l10n.kratonZone2Label;
      case 3:
        return l10n.kratonZone3Label;
      case 4:
        return l10n.kratonZone4Label;
      default:
        return l10n.kratonZone5Label;
    }
  }

  IconData _unitIcon(int unitId, bool isLocked) {
    if (isLocked) return AppIcons.lockOutline;
    switch (unitId) {
      case 1:
        return AppIcons.etiquette;
      case 2:
        return AppIcons.chooseScript;
      case 3:
        return AppIcons.sandangan;
      case 4:
        return AppIcons.proverbs;
      default:
        return AppIcons.medal;
    }
  }

  Widget _buildUnitBand(QuizUnitData unit) {
    final zoneIndex = unit.unitId - 1;
    final zoneLabel = _zoneLabelForUnit(context, unit.unitId);

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: TempleZoneBackgroundPainter(zoneIndex: zoneIndex),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUnitHeader(unit, zoneLabel),
              const SizedBox(height: 8),
              for (int i = 0; i < unit.nodes.length; i++) ...[
                if (i > 0) _buildConnector(i, unit.nodes),
                Align(
                  alignment: Alignment(unit.nodes[i].position.alignmentX, 0),
                  child: _buildNode(unit.nodes[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnitHeader(QuizUnitData unit, String zoneLabel) {
    final isLocked = unit.isLocked;
    final unitTitle = unit.getLocalizedTitle(context);
    final progressBadge = '${unit.completedCount}/${unit.nodes.length}';
    final textTheme = Theme.of(context).textTheme;

    final Color cardBg = isLocked ? AppColors.surfaceWarm : AppColors.surface;
    final Color cardBorder = isLocked
        ? AppColors.border
        : AppColors.primaryAmber.withValues(alpha: 0.55);
    final Color chipBg = isLocked
        ? AppColors.pastelSand
        : AppColors.surfaceWarm;
    final Color chipBorder = isLocked
        ? AppColors.border
        : AppColors.primaryAmber.withValues(alpha: 0.65);
    final Color chipTextColor =
        isLocked ? AppColors.inkSecondary : AppColors.primaryDark;

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          children: [
            // Motif Batik Kawung halus hanya di pojok kanan kartu sebagai tekstur
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 112,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _CornerKawungPainter(
                    opacity: isLocked ? 0.045 : 0.075,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: chipBorder),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      _unitIcon(unit.unitId, isLocked),
                      color: chipTextColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: chipBg,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: chipBorder),
                                ),
                                child: Text(
                                  zoneLabel,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: chipTextColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: chipBg,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: chipBorder),
                              ),
                              child: Text(
                                progressBadge,
                                style: textTheme.labelMedium?.copyWith(
                                  color: isLocked
                                      ? AppColors.inkSecondary
                                      : AppColors.ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          unitTitle,
                          style: textTheme.titleMedium?.copyWith(
                            color: isLocked
                                ? AppColors.ink.withValues(alpha: 0.72)
                                : AppColors.ink,
                            height: 1.25,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(int index, List<QuizPathNode> nodes) {
    final prev = nodes[index - 1];
    final curr = nodes[index];
    final isLocked = curr.status == NodeStatus.locked;
    final isCompleted = prev.status == NodeStatus.completed;

    return SizedBox(
      height: 44,
      width: double.infinity,
      child: CustomPaint(
        painter: _ConnectorPainter(
          startAlignmentX: prev.position.alignmentX,
          endAlignmentX: curr.position.alignmentX,
          isCompleted: isCompleted && !isLocked,
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
              _buildNodeAvatar(node),
              const SizedBox(height: 6),
              _buildNodeLabel(node),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodeAvatar(QuizPathNode node) {
    final bool isEvaluation = node.isMilestone;
    final bool isFinalExam = node.type == QuizNodeType.finalExam;
    final bool isCurrent = node.status == NodeStatus.current;

    final double circleSize = isEvaluation
        ? (isCurrent ? 80.0 : 74.0)
        : (isCurrent ? 74.0 : 66.0);
    final double outerBoxWidth = isEvaluation ? 108.0 : 92.0;
    final double outerBoxHeight = isEvaluation ? 102.0 : 88.0;

    final Widget coreCircle = _buildCoreCircle(
      node,
      size: circleSize,
      isEvaluation: isEvaluation,
    );

    Widget framed = coreCircle;

    if (isEvaluation) {
      framed = SizedBox(
        width: outerBoxWidth,
        height: outerBoxHeight,
        child: CustomPaint(
          painter: _EvaluationFramePainter(
            status: node.status,
            isFinalExam: isFinalExam,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: coreCircle,
            ),
          ),
        ),
      );
    }

    if (isCurrent) {
      return SizedBox(
        width: outerBoxWidth,
        height: outerBoxHeight,
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (context, child) {
            final double ringSize = circleSize + 12;
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: ringSize,
                    height: ringSize,
                    margin: isEvaluation
                        ? const EdgeInsets.only(top: 6)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryAmber.withValues(alpha: 0.70),
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
          child: framed,
        ),
      );
    }

    return SizedBox(
      width: outerBoxWidth,
      height: outerBoxHeight,
      child: Center(child: framed),
    );
  }

  Widget _buildCoreCircle(
    QuizPathNode node, {
    required double size,
    required bool isEvaluation,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final glyphStyle =
        (isEvaluation ? textTheme.displayLarge : textTheme.displayMedium)
            ?.copyWith(
              fontFamily: 'NotoSansJavanese',
              height: 1.0,
            );

    late final Color bgColor;
    late final Color borderColor;
    late final double borderWidth;
    late final Color glyphColor;
    List<BoxShadow>? shadows;
    Widget? cornerBadge;

    switch (node.status) {
      case NodeStatus.completed:
        bgColor = AppColors.primaryAmber;
        borderColor = AppColors.primaryDark;
        borderWidth = isEvaluation ? 2.4 : 2.0;
        glyphColor = AppColors.ink;
        shadows = [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];
        cornerBadge = _buildCornerBadge(
          bgColor: AppColors.success,
          borderColor: AppColors.canvas,
          icon: AppIcons.check,
          iconColor: AppColors.surface,
        );
        break;

      case NodeStatus.current:
        bgColor = AppColors.surface;
        borderColor = AppColors.primaryDark;
        borderWidth = 2.6;
        glyphColor = AppColors.ink;
        shadows = [
          BoxShadow(
            color: AppColors.primaryAmber.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ];
        break;

      case NodeStatus.locked:
        bgColor = AppColors.surfaceWarm;
        borderColor = AppColors.border;
        borderWidth = isEvaluation ? 2.0 : 1.8;
        glyphColor = AppColors.ink.withValues(alpha: 0.35);
        cornerBadge = _buildCornerBadge(
          bgColor: AppColors.pastelSand,
          borderColor: AppColors.canvas,
          icon: AppIcons.lock,
          iconColor: AppColors.inkSecondary,
        );
        break;
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: shadows,
            ),
            alignment: Alignment.center,
            child: node.status == NodeStatus.current
                ? Container(
                    width: size - 10,
                    height: size - 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryAmber,
                        width: 1.8,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      node.glyph,
                      style: glyphStyle?.copyWith(color: glyphColor),
                    ),
                  )
                : Text(
                    node.glyph,
                    style: glyphStyle?.copyWith(color: glyphColor),
                  ),
          ),
          if (cornerBadge != null)
            Positioned(
              right: -2,
              bottom: -2,
              child: cornerBadge,
            ),
        ],
      ),
    );
  }

  Widget _buildCornerBadge({
    required Color bgColor,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.8),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 12, color: iconColor),
    );
  }

  Widget _buildNodeLabel(QuizPathNode node) {
    final isLocked = node.status == NodeStatus.locked;
    final localizedTitle = node.getLocalizedTitle(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 34),
      child: Text(
        localizedTitle,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.25,
          color: isLocked ? AppColors.inkSecondary : AppColors.ink,
        ),
      ),
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

    final activeDifficulty = level <= 3 ? 0 : (level <= 6 ? 1 : 2);
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

    final activeIndex = nodes.indexWhere((n) => n.status == NodeStatus.current);
    final targetIndex = activeIndex != -1 ? activeIndex : nodes.length - 1;

    final unitHeadersBefore = (targetIndex / 10).floor() + 1;
    final estimatedOffset =
        (targetIndex * 164.0) + (unitHeadersBefore * 116.0) - 160.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = estimatedOffset.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }
}

/// Menggambar kurva jalur mulus: emas penuh bergradasi untuk jalur terlewati,
/// dan krem gelap bertitik rapat jelas terbaca untuk jalur belum dilalui.
class _ConnectorPainter extends CustomPainter {
  final double startAlignmentX;
  final double endAlignmentX;
  final bool isCompleted;

  const _ConnectorPainter({
    required this.startAlignmentX,
    required this.endAlignmentX,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

    if (isCompleted) {
      final underPaint = Paint()
        ..color = AppColors.primaryDark.withValues(alpha: 0.18)
        ..strokeWidth = 9.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, underPaint);

      final goldGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryAmber,
          Color.lerp(AppColors.primaryAmber, AppColors.primaryDark, 0.26)!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final goldPaint = Paint()
        ..shader = goldGradient
        ..strokeWidth = 7.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, goldPaint);
    } else {
      final Color trackCream = Color.lerp(
        AppColors.pastelSand,
        AppColors.inkMuted,
        0.30,
      )!;
      final trackPaint = Paint()
        ..color = trackCream
        ..strokeWidth = 7.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, trackPaint);

      final Color dotColor = Color.lerp(
        AppColors.inkMuted,
        AppColors.primaryDark,
        0.22,
      )!;
      final dotPaint = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;

      const double dotSpacing = 9.5;
      for (final metric in path.computeMetrics()) {
        double d = 3.5;
        while (d <= metric.length - 3.0) {
          final tangent = metric.getTangentForOffset(d);
          if (tangent != null) {
            canvas.drawCircle(tangent.position, 2.1, dotPaint);
          }
          d += dotSpacing;
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) =>
      old.startAlignmentX != startAlignmentX ||
      old.endAlignmentX != endAlignmentX ||
      old.isCompleted != isCompleted;
}

/// Menggambar motif Batik Kawung geometris halus di pojok kartu unit.
class _CornerKawungPainter extends CustomPainter {
  final double opacity;

  const _CornerKawungPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final shader = LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        AppColors.kawungStroke.withValues(alpha: opacity),
        AppColors.kawungStroke.withValues(alpha: opacity * 0.45),
        AppColors.kawungStroke.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final strokePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final dotPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    const double tile = 32.0;
    const double rx = 5.0;
    const double ry = 8.0;

    final int cols = (size.width / tile).ceil() + 1;
    final int rows = (size.height / tile).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double cx = size.width - c * tile - tile * 0.4;
        final double cy = r * tile + tile * 0.4;

        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx, cy - ry),
            width: rx * 2,
            height: ry * 2,
          ),
          strokePaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx, cy + ry),
            width: rx * 2,
            height: ry * 2,
          ),
          strokePaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx - ry, cy),
            width: ry * 2,
            height: rx * 2,
          ),
          strokePaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx + ry, cy),
            width: ry * 2,
            height: rx * 2,
          ),
          strokePaint,
        );
        canvas.drawCircle(Offset(cx, cy), 1.6, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_CornerKawungPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Menggambar bingkai gapura kecil + mahkota Jawa di sekeliling node Evaluasi Unit / Akhir.
class _EvaluationFramePainter extends CustomPainter {
  final NodeStatus status;
  final bool isFinalExam;

  const _EvaluationFramePainter({
    required this.status,
    required this.isFinalExam,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2 + 3;

    final bool isLocked = status == NodeStatus.locked;
    final Color frameStrokeColor = isLocked
        ? AppColors.inkSecondary.withValues(alpha: 0.35)
        : AppColors.primaryDark;
    final Color frameFillColor = isLocked
        ? AppColors.pastelSand
        : AppColors.primaryAmber;
    final Color accentFillColor = isLocked
        ? AppColors.surfaceWarm
        : AppColors.surfaceWarm;

    final fillPaint = Paint()
      ..color = frameFillColor
      ..style = PaintingStyle.fill;
    final accentPaint = Paint()
      ..color = accentFillColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = frameStrokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;

    // 1. Mahkota / Puncak Gunungan di atas lingkaran evaluasi
    final double crownBaseY = cy - (status == NodeStatus.current ? 40 : 37);
    final double crownH = isFinalExam ? 15.0 : 11.0;
    final double crownW = isFinalExam ? 30.0 : 24.0;

    final crownPath = Path()
      ..moveTo(cx - crownW / 2, crownBaseY + 2)
      ..lineTo(cx - crownW * 0.36, crownBaseY - crownH * 0.48)
      ..lineTo(cx - crownW * 0.16, crownBaseY - crownH * 0.32)
      ..lineTo(cx, crownBaseY - crownH)
      ..lineTo(cx + crownW * 0.16, crownBaseY - crownH * 0.32)
      ..lineTo(cx + crownW * 0.36, crownBaseY - crownH * 0.48)
      ..lineTo(cx + crownW / 2, crownBaseY + 2)
      ..close();
    canvas.drawPath(crownPath, fillPaint);
    canvas.drawPath(crownPath, strokePaint);

    // 2. Sayap gapura kecil kiri & kanan mengapit lingkaran
    final double shoulderXOffset = status == NodeStatus.current ? 41 : 38;
    for (final dir in [-1.0, 1.0]) {
      final double sx = cx + dir * shoulderXOffset;
      final wing = Path()
        ..moveTo(sx, cy - 11)
        ..lineTo(sx + dir * 8, cy - 8)
        ..lineTo(sx + dir * 10, cy + 12)
        ..lineTo(sx, cy + 15)
        ..close();
      canvas.drawPath(wing, accentPaint);
      canvas.drawPath(wing, strokePaint);
    }

    // 3. Umpak / dasar gapura kecil di bawah lingkaran
    final double baseY = cy + (status == NodeStatus.current ? 40 : 37);
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, baseY), width: 42, height: 6),
      const Radius.circular(3),
    );
    canvas.drawRRect(baseRect, fillPaint);
    canvas.drawRRect(baseRect, strokePaint);
  }

  @override
  bool shouldRepaint(_EvaluationFramePainter oldDelegate) =>
      oldDelegate.status != status || oldDelegate.isFinalExam != isFinalExam;
}
