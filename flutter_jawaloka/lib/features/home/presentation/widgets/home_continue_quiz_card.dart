import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFF0E3C5), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF231C14).withValues(alpha: 0.04),
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
                color: const Color(0xFFFFF3D6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF4D483).withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFFB87812),
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
                    style: const TextStyle(
                      color: Color(0xFF231C14),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activeNode.getLocalizedTitle(context),
                    style: const TextStyle(
                      color: Color(0xFF7C6E5E),
                      fontSize: 13,
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
                      backgroundColor: const Color(0xFFF6ECD8),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF5B838),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeContinueQuizProgress(completedCount),
                    style: const TextStyle(
                      color: Color(0xFF8A7E70),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Panah Arah
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: Color(0xFF9E6E1A),
            ),
          ],
        ),
      ),
    );
  }
}
