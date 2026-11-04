import 'package:flutter/material.dart';

/// Design tokens and color palette for JawaLoka based on Google Stitch design.
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════
  //   BRAND PRIMARY
  // ═══════════════════════════════════════════════
  static const Color amber = Color(0xFFFFC247);       // Primary golden amber
  static const Color amberDark = Color(0xFFF5A31A);   // Deep warm amber
  static const Color amberSoft = Color(0xFFFFF1D0);   // Soft warm cream

  // ═══════════════════════════════════════════════
  //   TYPOGRAPHY & INK
  // ═══════════════════════════════════════════════
  static const Color ink = Color(0xFF231C14);         // Deep traditional Javanese ink
  static const Color inkSecondary = Color(0xFF6B6257);// Secondary text
  static const Color inkMuted = Color(0xFF8A8074);    // Muted/disabled text

  // ═══════════════════════════════════════════════
  //   SURFACES & BACKGROUNDS
  // ═══════════════════════════════════════════════
  static const Color surface = Color(0xFFFFFFFF);     // Pure card surface
  static const Color canvas = Color(0xFFF5F1EB);      // App background (warm linen)
  static const Color border = Color(0xFFE8E1D6);      // Card borders

  // ═══════════════════════════════════════════════
  //   ACCENTS
  // ═══════════════════════════════════════════════
  static const Color accentOrange = Color(0xFFF26B2D);// Sunrise radiant orange
  static const Color kawungStroke = Color(0xFFD99414);// Ochre batik pattern stroke

  // ═══════════════════════════════════════════════
  //   SEMANTIC COLORS
  // ═══════════════════════════════════════════════
  static const Color error = Color(0xFFD64545);
  static const Color errorLight = Color(0xFFFDE8E8);
  static const Color success = Color(0xFF3E9B5F);
  static const Color successLight = Color(0xFFDCEBD2);
  static const Color successText = Color(0xFF2D5A27);

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

