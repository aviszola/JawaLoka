import 'package:flutter/material.dart';

/// Design tokens and color palette for JawaLoka based on Google Stitch design.
class AppColors {
  AppColors._();

  static const Color primaryAmber = Color(0xFFF5B838); // Warm golden amber
  static const Color primaryDark = Color(0xFF85580C); // Deep warm ochre amber (WCAG AA compliant)
  static const Color amber = primaryAmber; // Backward compatibility
  static const Color amberDark = primaryDark; // Backward compatibility
  static const Color surfaceWarm = Color(0xFFFFF4D6); // Warm soft cream tint
  static const Color amberSoft = surfaceWarm; // Backward compatibility

  // ═══════════════════════════════════════════════
  //   TYPOGRAPHY & INK
  // ═══════════════════════════════════════════════
  static const Color ink = Color(0xFF231C14); // Deep traditional Javanese ink
  static const Color inkSecondary = Color(0xFF6B6257); // Secondary text
  static const Color inkMuted = Color(0xFF736A5E); // Muted text (WCAG AA compliant >= 4.5:1 on white)

  // ═══════════════════════════════════════════════
  //   SURFACES & BACKGROUNDS
  // ═══════════════════════════════════════════════
  static const Color surface = Color(0xFFFFFFFF); // Pure card surface
  static const Color canvas = Color(
    0xFFFAF6EE,
  ); // App background (warm pastel yellow linen)
  static const Color border = Color(0xFFF0E3C5); // Soft pastel card borders

  // ═══════════════════════════════════════════════
  //   ACCENTS
  // ═══════════════════════════════════════════════
  static const Color accentOrange = Color(0xFFE05A1E); // Terracotta accent (large text/icons)
  static const Color accentOrangeText = Color(0xFFA84410); // Terracotta for text (WCAG AA compliant)
  static const Color kawungStroke = Color(0xFF85580C); // Ochre batik pattern stroke

  // ═══════════════════════════════════════════════
  //   SEMANTIC COLORS
  // ═══════════════════════════════════════════════
  static const Color error = Color(0xFFC92A2A);
  static const Color errorLight = Color(0xFFFDE8E8);
  static const Color success = Color(0xFF2D6A4F);
  static const Color successLight = Color(0xFFDCEBD2);
  static const Color successText = Color(0xFF2D6A4F);

  // ═══════════════════════════════════════════════
  //   PASTEL PALETTE (for badges & cards)
  // ═══════════════════════════════════════════════
  static const Color pastelSand = Color(0xFFF1E6D2);
  static const Color pastelMint = Color(0xFFDCEBD2);
  static const Color pastelMintText = Color(0xFF2D5A27);
  static const Color pastelLavender = Color(0xFFDDD7F6);
  static const Color pastelLavenderText = Color(0xFF4E4376);
  static const Color pastelBlush = Color(0xFFF6D5CE);
  static const Color pastelBlushText = Color(0xFF6E433A);

  // ═══════════════════════════════════════════════
  //   JAVANESE LANDSCAPE (CustomPainter)
  // ═══════════════════════════════════════════════
  static const Color volcanoFarStart = Color(0xFF3C6E57);
  static const Color volcanoFarEnd = Color(0xFF2D5543);
  static const Color volcanoNearStart = Color(0xFF2E5A46);
  static const Color volcanoNearEnd = Color(0xFF214233);

  static const Color sunriseGlow = Color(0xFFFFE49E);
  static const Color sunCore = Color(0xFFFFAA33);
  static const Color sunHighlight = Color(0xFFFFF1D0);

  static const Color terraceTier1 = Color(0xFF4B805F);
  static const Color terraceTier2 = Color(0xFF3D7152);
  static const Color terraceTier3 = Color(0xFF2E5D42);
  static const Color terraceTier4 = Color(0xFF244D36);
  static const Color waterGlint = Color(0xFFFFF1D0);

  // ═══════════════════════════════════════════════
  //   UTILITY
  // ═══════════════════════════════════════════════
  static const Color navPill = Color(0x80FFFFFF);

  // ═══════════════════════════════════════════════
  //   GRADIENTS (Convenience)
  // ═══════════════════════════════════════════════
  static const LinearGradient amberGradient = LinearGradient(
    colors: [amber, amberDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient inkGradient = LinearGradient(
    colors: [Color(0xFF342B20), ink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
