import 'package:flutter/material.dart';
import '../../../../core/mock/mock_user_stats.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

/// Card "Lanjutkan Kuis" showing current quiz path progress and difficulty level.
class HomeContinueQuizCard extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeContinueQuizCard({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                children: const [
                  Icon(Icons.quiz_rounded, size: 18, color: AppColors.amberDark),
                  SizedBox(width: 8),
                  Text(
                    'Lanjutkan Kuis',
                    style: TextStyle(
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
                  border: Border.all(color: AppColors.amberDark.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Tingkat: Mahir',
                  style: TextStyle(
                    color: AppColors.amberDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Node 4: Aksara Ra (ꦫ)',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '${MockUserStats.totalCompletedQuizzes} dari 10 bab kuis terselesaikan',
            style: TextStyle(
              color: AppColors.inkSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(
              value: 0.4,
              minHeight: 7,
              backgroundColor: Color(0xFFEBE5DC),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.amberDark),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () {
              if (onNavigateTab != null) {
                onNavigateTab!(3); // Switch to Kuis tab
              } else {
                Navigator.pushNamed(context, AppRouter.quizPath);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Buka Jalur Kuis',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.ink),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

