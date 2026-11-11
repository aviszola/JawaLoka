import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../profile/presentation/widgets/blangkon_painter.dart';
import '../../../profile/presentation/widgets/javanese_avatar_widget.dart';

/// Header beranda bersih bernuansa kuning pastel hangat — tanpa ilustrasi rumit.
/// Mengikuti referensi visual: Avatar + Sapaan + Level pill + Kapsul check-in harian.
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
    final profile = ProfileScope.maybeOf(context);

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Baris Atas: Avatar + Sapaan + Level Pill ──
              Row(
                children: [
                  // Avatar pengguna dengan bingkai kuning pastel lembut
                  GestureDetector(
                    onTap: () {
                      if (onNavigateTab != null) {
                        onNavigateTab!(4);
                      } else {
                        Navigator.pushNamed(context, AppRouter.profile);
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEEC2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF4D483),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF231C14,
                            ).withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: JavaneseAvatarWidget(
                          blangkonType:
                              profile?.equippedBlangkon ??
                              BlangkonType.yogyakarta,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Sapaan & Nama
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greetingText(context).toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF946E20),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.homeGreetingUser(
                            profile?.displayName ?? 'Dimas',
                          ),
                          style: const TextStyle(
                            color: Color(0xFF231C14),
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Pill Level
                  GestureDetector(
                    onTap: () {
                      if (onNavigateTab != null) {
                        onNavigateTab!(4);
                      } else {
                        Navigator.pushNamed(context, AppRouter.profile);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3D6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFF2D37E),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        l10n.homeLevelPill(profile?.userLevel ?? 1),
                        style: const TextStyle(
                          color: Color(0xFF8A5D14),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Kapsul Check-in / Streak Harian ──
              GestureDetector(
                onTap: () {
                  if (onNavigateTab != null) {
                    onNavigateTab!(3); // Kuis tab
                  } else {
                    Navigator.pushNamed(context, AppRouter.quizPath);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFF0E3C5),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF231C14).withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFFE27B34),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${l10n.streakDays(profile?.streakDays ?? 5)} · ${l10n.homeWeeklyCompletedCount(profile?.quizzesThisWeek ?? 4)}',
                          style: const TextStyle(
                            color: Color(0xFF231C14),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Color(0xFF9E6E1A),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
