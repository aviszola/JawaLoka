import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../quiz/domain/curriculum/curriculum_quiz_bank.dart';
import '../../../quiz/domain/quiz_path_data.dart';
import '../../../quiz/domain/quiz_path_models.dart';
import '../../../quiz/presentation/screens/quiz_question_screen.dart';
import '../../../quiz/presentation/widgets/quiz_bottom_sheet.dart';

/// Card "Lanjutkan Kuis" showing current quiz path progress and difficulty level.
class HomeContinueQuizCard extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeContinueQuizCard({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ProfileScope.maybeOf(context);
    final units = profile != null
        ? QuizPathData.resolveCurriculum(
            clearedActivities: profile.clearedActivities,
            isEvaluationPassed: profile.isEvaluationPassed,
          )
        : QuizPathData.units;
    final nodes = units.expand((u) => u.nodes).toList(growable: false);
    final activeNode = nodes.firstWhere(
      (n) => n.status == NodeStatus.current,
      orElse: () =>
          nodes.isNotEmpty ? nodes.first : QuizPathData.units.first.nodes.first,
    );
    final completedCount =
        nodes.where((n) => n.status == NodeStatus.completed).length;
    final totalCount = nodes.length;
    final progressValue =
        totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;

    void openActiveNode() {
      final level = profile?.userLevel ?? 1;
      final difficulty = level <= 3
          ? QuizDifficulty.mudah
          : (level <= 6 ? QuizDifficulty.mahir : QuizDifficulty.sangatMahir);

      final questions = CurriculumQuizBank.getQuestionsForNode(
        activeNode,
        difficulty: difficulty,
      );

      final isEvaluation =
          activeNode.type == QuizNodeType.milestone ||
          activeNode.type == QuizNodeType.finalExam ||
          activeNode.topicKey.startsWith('evaluasi_');

      final localizedTitle = activeNode.getLocalizedTitle(context);

      QuizBottomSheet.show(
        context,
        unitTitle: activeNode.getUnitTitle(context),
        nodeTitle: localizedTitle,
        quizIndex: activeNode.indexInUnit,
        totalQuizzes: 10,
        questionCount: questions.length,
        topicDescription: activeNode.getLocalizedDescription(context),
        onStart: () {
          Navigator.of(context).pushNamed(
            AppRouter.quizQuestion,
            arguments: QuizQuestionArgs(
              questions: questions,
              moduleTitle: localizedTitle,
              userLevel: level,
              activityId: activeNode.id,
              isEvaluation: isEvaluation,
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: openActiveNode,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.quiz_rounded,
                    size: 18,
                    color: AppColors.amberDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.homeContinueQuizTitle,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.pastelSand,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.amberDark.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.homeContinueQuizLevel,
                  style: const TextStyle(
                    color: AppColors.amberDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            activeNode.getLocalizedTitle(context),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.homeContinueQuizProgress(completedCount),
            style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 7,
              backgroundColor: const Color(0xFFEBE5DC),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amberDark),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: openActiveNode,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.homeContinueQuizButton,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.ink,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
