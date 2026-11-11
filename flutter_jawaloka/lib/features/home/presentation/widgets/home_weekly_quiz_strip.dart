import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';

/// Strip Kuis Mingguan bernuansa kuning pastel hangat.
/// Kotak ikon pastel kuning di kiri atas, judul & hitungan, serta 7 lingkaran hari.
class HomeWeeklyQuizStrip extends StatelessWidget {
  const HomeWeeklyQuizStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ProfileScope.maybeOf(context);
    final quizzesThisWeek = profile?.quizzesThisWeek ?? 0;
    final completedDays = profile?.completedQuizDaysOfWeek ?? const <int>[];

    final dayNames = [
      l10n.dayMon,
      l10n.dayTue,
      l10n.dayWed,
      l10n.dayThu,
      l10n.dayFri,
      l10n.daySat,
      l10n.daySun,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0E3C5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF231C14).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Baris Atas: Ikon + Judul & Subjudul + Aksi ──
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFF4D483).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFFB87812),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeWeeklyStripTitle,
                      style: const TextStyle(
                        color: Color(0xFF231C14),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.homeWeeklyCompletedCount(quizzesThisWeek),
                      style: const TextStyle(
                        color: Color(0xFF7C6E5E),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat',
                    style: TextStyle(
                      color: Color(0xFF9E6E1A),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Color(0xFF9E6E1A),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Baris 7 Lingkaran Hari (Sen - Min) dengan Pembagian Rata ──
          Row(
            children: List.generate(7, (i) {
              final dayIndex = i + 1; // 1 = Sen, 7 = Min
              final isCompleted = completedDays.contains(dayIndex);

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFFF5B838)
                            : const Color(0xFFFBF4E4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0xFFDC9E1A)
                              : const Color(0xFFEEDBB2),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 17,
                                color: Colors.white,
                              )
                            : Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC7B38E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        dayNames[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isCompleted
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCompleted
                              ? const Color(0xFF231C14)
                              : const Color(0xFF8A7E70),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
