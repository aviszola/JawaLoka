import 'package:flutter/material.dart';

/// Clean pastel-yellow auth banner (Home design benchmark).

/// No landscape/mountain illustrations — high-contrast dark ink on warm cream/yellow.
class AuthBanner extends StatelessWidget {
  final String? badgeLabel;
  final String title;
  final String subtitle;
  final String glyphWatermark;
  final double height;

  const AuthBanner({
    super.key,
    this.badgeLabel,
    required this.title,
    required this.subtitle,
    this.glyphWatermark = 'ꦲ',
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF7D46B),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFEED17B), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF231C14).withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -28,
              right: -28,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF0C0).withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3D6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF4D483).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      glyphWatermark,
                      style: const TextStyle(
                        fontFamily: 'NotoSansJavanese',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB87812),
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 88, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (badgeLabel != null && badgeLabel!.trim().isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFEED07C).withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB57D18),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              badgeLabel!.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF85580C),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF231C14),
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7C5410),
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
}
