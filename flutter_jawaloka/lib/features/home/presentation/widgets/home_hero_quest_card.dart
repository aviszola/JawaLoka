import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../quiz/domain/quest_target.dart';

/// Kartu Misi Aktif — desain bersih & elegan berlatar kuning pastel hangat
/// sesuai referensi visual iPhone 16. Tulisan berkontras tinggi dan sangat mudah dibaca.
class HomeHeroQuestCard extends StatelessWidget {
  const HomeHeroQuestCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7D46B),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9E6E1A).withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Bentuk aksen lingkaran halus di pojok kanan atas (sesuai referensi)
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFEF0C0).withValues(alpha: 0.65),
                ),
              ),
            ),

            // Konten Utama
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Baris Atas: Label Misi & Target ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFB57D18),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                l10n.homeHeroQuestBadge.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF85580C),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.homeHeroQuestTarget(
                            (QuestTarget.questPassThreshold * 100).round(),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF85580C),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Judul Utama Misi (Jelas & Kontras Tinggi) ──
                  Text(
                    l10n.homeHeroQuestTitle,
                    style: const TextStyle(
                      color: Color(0xFF231C14),
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Baris Tag Chips (Kapsul Putih Bersih) ──
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildPillTag('Aksara Jawa'),
                      _buildPillTag('ꦲ (Ha)'),
                      _buildPillTag('+30 XP'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Informasi Progres & Kategori ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          '3 dari 5 aksara selesai',
                          style: TextStyle(
                            color: Color(0xFF332612),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Aksara Legena',
                        style: TextStyle(
                          color: const Color(0xFF7C5410),
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF7C5410),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ── Segmented Progress Bar ──
                  Row(
                    children: List.generate(5, (index) {
                      final isFilled = index < 3;
                      return Expanded(
                        child: Container(
                          height: 6,
                          margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: isFilled
                                ? const Color(0xFFDE9516)
                                : const Color(0xFFEFE0A8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // ── Tombol Putih Penuh (Kontras Maksimal) ──
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.drawingCanvas);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF231C14),
                        elevation: 0,
                        side: const BorderSide(
                          color: Color(0xFFEED17B),
                          width: 1.2,
                        ),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              l10n.homeHeroQuestButton,
                              style: const TextStyle(
                                color: Color(0xFF231C14),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Color(0xFF231C14),
                          ),
                        ],
                      ),
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

  Widget _buildPillTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEED07C).withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2A2012),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
