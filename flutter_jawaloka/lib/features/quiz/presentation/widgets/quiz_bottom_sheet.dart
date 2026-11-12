import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';
import 'package:flutter_jawaloka/core/theme/app_icons.dart';

/// Modal bottom sheet shown before starting a quiz module.
class QuizBottomSheet extends StatelessWidget {
  final String unitTitle;
  final String nodeTitle;
  final int quizIndex;
  final int totalQuizzes;
  final int questionCount;
  final String topicDescription;
  final VoidCallback onStart;

  const QuizBottomSheet({
    super.key,
    this.unitTitle = 'Unit 1 · Tingkat Mudah',
    required this.nodeTitle,
    this.quizIndex = 1,
    this.totalQuizzes = 5,
    this.questionCount = 10,
    this.topicDescription =
        'Pelajari kosakata dan ungkapan dasar sapaan dalam tata krama bahasa Jawa.',
    required this.onStart,
  });

  /// Convenience method to show the bottom sheet.
  static Future<void> show(
    BuildContext context, {
    String unitTitle = 'Unit 1 · Tingkat Mudah',
    required String nodeTitle,
    int quizIndex = 1,
    int totalQuizzes = 5,
    int questionCount = 10,
    String topicDescription =
        'Pelajari kosakata dan ungkapan dasar sapaan dalam tata krama bahasa Jawa.',
    required VoidCallback onStart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuizBottomSheet(
        unitTitle: unitTitle,
        nodeTitle: nodeTitle,
        quizIndex: quizIndex,
        totalQuizzes: totalQuizzes,
        questionCount: questionCount,
        topicDescription: topicDescription,
        onStart: onStart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Chip: "Unit 1 · Tingkat Mudah"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.amberDark.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              unitTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.amberDark,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Judul Node
          Text(
            nodeTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // "Kuis N dari M · 10 soal"
          Text(
            context.l10n.quizBottomSheetProgress(
              quizIndex,
              totalQuizzes,
              questionCount,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.inkSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Satu kartu info topik
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  AppIcons.info,
                  color: AppColors.amberDark,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    topicDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.ink,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tombol utama: "Mulai Kuis"
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onStart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amber,
                foregroundColor: AppColors.ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              child: Text(
                context.l10n.quizBottomSheetStart,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tautan: "Nanti saja"
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.quizBottomSheetLater,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.inkSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
