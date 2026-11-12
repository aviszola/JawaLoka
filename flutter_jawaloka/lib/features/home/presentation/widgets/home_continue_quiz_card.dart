import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../quiz/domain/curriculum/curriculum_quiz_bank.dart';
import '../../../quiz/domain/quiz_path_data.dart';
import '../../../quiz/domain/quiz_path_models.dart';
import '../../../quiz/presentation/screens/quiz_question_screen.dart';
import '../../../quiz/presentation/widgets/quiz_bottom_sheet.dart';

/// Kartu "Lanjutkan Kuis" bersih & bernuansa kuning pastel hangat.
/// Ikon pastel kuning di kiri, judul & progres node aktif, panah di kanan.
class HomeContinueQuizCard extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeContinueQuizCard({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
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
    final completedCount = nodes
        .where((n) => n.status == NodeStatus.completed)
        .length;
    final totalCount = nodes.length;
    final progressValue = totalCount > 0
        ? (completedCount / totalCount).clamp(0.0, 1.0)
        : 0.0;

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ikon Kotak Bulat Lembut Bernuansa Kuning Pastel
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: const Icon(
                AppIcons.proverbs,
                color: AppColors.primaryDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Konten Teks & Progres
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeContinueQuizTitle,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activeNode.getLocalizedTitle(context),
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.inkSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 5,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryAmber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeContinueQuizProgress(completedCount),
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.inkSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Panah Arah
            const Icon(
              AppIcons.forward,
              size: 18,
              color: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}
