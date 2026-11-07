import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/mock/mock_user_stats.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../profile/presentation/widgets/blangkon_painter.dart';
import '../../../profile/presentation/widgets/javanese_avatar_widget.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';

/// Top header for HomeScreen with warm amber background and subtle Kawung motif.
class HomeHeader extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomeHeader({super.key, this.onNavigateTab});

  String _greetingText(BuildContext context) {
    final l10n = context.l10n;
    final hour = DateTime.now().hour;
    if (hour < 11) return l10n.homeGreetingMorning;
    if (hour < 15) return l10n.homeGreetingAfternoon;
    if (hour < 18) return l10n.homeGreetingEvening;
    return l10n.homeGreetingNight;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      color: AppColors.amber,
      child: Stack(
        children: [
          // Background subtle batik pattern wrapped in RepaintBoundary (opacity <= 0.04)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: BatikKawungPainter(opacity: 0.035),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greetingText(context),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.homeGreetingUser(
                            ProfileScope.maybeOf(context)?.displayName ??
                                MockUserStats.userName,
                          ),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Streak Badge (fire icon + days)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.accentOrange,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.streakDays(MockUserStats.streakDays),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Avatar with Level pill
                  GestureDetector(
                    onTap: () {
                      if (onNavigateTab != null) {
                        onNavigateTab!(4); // Switch to Profil tab
                      } else {
                        Navigator.pushNamed(context, AppRouter.profile);
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.ink, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.ink.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: JavaneseAvatarWidget(
                              blangkonType: ProfileScope.maybeOf(context)
                                      ?.equippedBlangkon ??
                                  BlangkonType.yogyakarta,
                              size: 38,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              l10n.homeLevelPill(MockUserStats.userLevel),
                              style: const TextStyle(
                                color: AppColors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

