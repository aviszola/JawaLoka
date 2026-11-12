import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Empat nada ubin ikon resmi JawaLoka (seluruh pasangan kontras >= 3:1).
enum AppIconTone {
  /// Hangat: surfaceWarm + primaryDark (gamifikasi, level, etika)
  warm,

  /// Amber: primaryAmber + ink (aksi utama, kuis/misi)
  amber,

  /// Pasir: pastelSand + ink (kosakata, peribahasa, sastra)
  sand,

  /// Hijau: successLight + success (penerjemah, status berhasil)
  success,
}

extension AppIconToneColors on AppIconTone {
  Color get backgroundColor {
    switch (this) {
      case AppIconTone.warm:
        return AppColors.surfaceWarm;
      case AppIconTone.amber:
        return AppColors.primaryAmber;
      case AppIconTone.sand:
        return AppColors.pastelSand;
      case AppIconTone.success:
        return AppColors.successLight;
    }
  }

  Color get iconColor {
    switch (this) {
      case AppIconTone.warm:
        return AppColors.primaryDark;
      case AppIconTone.amber:
        return AppColors.ink;
      case AppIconTone.sand:
        return AppColors.ink;
      case AppIconTone.success:
        return AppColors.success;
    }
  }
}

/// Peta ikon semantik terpusat JawaLoka.
///
/// Seluruh widget wajib memakai konstanta di kelas ini (tanpa `Icons.*`
/// langsung di luar berkas ini). Setiap fitur utama memakai ikon unik
/// dari keluarga Material `*_rounded` / `*_outlined`.
class AppIcons {
  AppIcons._();

  // ── Navigasi Bawah ──
  static const IconData navHome = Icons.home_outlined;
  static const IconData navHomeActive = Icons.home_rounded;
  static const IconData navLearn = Icons.menu_book_outlined;
  static const IconData navLearnActive = Icons.menu_book_rounded;
  static const IconData navPractice = Icons.draw_rounded; // Tab tengah Latihan
  static const IconData navMission = Icons.flag_outlined; // Tab Misi (eks Kuis)
  static const IconData navMissionActive = Icons.flag_rounded;
  static const IconData navProfile = Icons.person_outline_rounded;
  static const IconData navProfileActive = Icons.person_rounded;

  // ── Gamifikasi & Statistik ──
  static const IconData streak = Icons.local_fire_department_rounded;
  static const IconData xp = Icons.bolt_rounded;
  static const IconData level = Icons.workspace_premium_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData trophy = Icons.emoji_events_rounded;
  static const IconData medal = Icons.military_tech_rounded;
  static const IconData verified = Icons.verified_rounded;
  static const IconData weeklyActivity = Icons.bar_chart_rounded;
  static const IconData missionCount = Icons.assignment_turned_in_outlined;
  static const IconData continueMission = Icons.navigation_rounded;

  // ── Modul Belajar (ikon unik per fitur) ──
  static const IconData vocab = Icons.abc_rounded;
  static const IconData translator = Icons.g_translate_rounded;
  static const IconData etiquette = Icons.record_voice_over_rounded;
  static const IconData proverbs = Icons.auto_stories_rounded;
  static const IconData writingSteps = Icons.format_list_numbered_rounded;
  static const IconData exampleText = Icons.text_fields_rounded;
  static const IconData sandangan = Icons.tune_rounded;
  static const IconData exampleChat = Icons.chat_bubble_outline_rounded;
  static const IconData practiceTarget = Icons.track_changes_rounded;
  static const IconData chooseScript = Icons.grid_view_rounded;

  // ── Aksi & Kontrol UI ──
  static const IconData forward = Icons.arrow_forward_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData checkCircle = Icons.check_circle_rounded;
  static const IconData cancel = Icons.cancel_rounded;
  static const IconData radioUnchecked = Icons.radio_button_unchecked_rounded;
  static const IconData expandMore = Icons.keyboard_arrow_down_rounded;
  static const IconData expandLess = Icons.keyboard_arrow_up_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData swap = Icons.swap_horiz_rounded;
  static const IconData copy = Icons.copy_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData undo = Icons.undo_rounded;
  static const IconData add = Icons.add_rounded;
  static const IconData remove = Icons.remove_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData sparkle = Icons.auto_awesome_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData lockOutline = Icons.lock_outline_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteOutline = Icons.favorite_border_rounded;
  static const IconData shield = Icons.shield_outlined;
  static const IconData blangkonStyle = Icons.style_outlined;
  static const IconData diamond = Icons.diamond_rounded;
  static const IconData dot = Icons.circle;

  // ── Profil, Pengaturan & Onboarding ──
  static const IconData settings = Icons.settings_outlined;
  static const IconData person = Icons.person_outline_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData privacy = Icons.privacy_tip_outlined;
  static const IconData logout = Icons.logout_rounded;
  static const IconData genderMale = Icons.face_rounded;
  static const IconData genderFemale = Icons.face_3_rounded;
  static const IconData verifiedUser = Icons.verified_user_outlined;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline_rounded;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData levelBeginner = Icons.eco_rounded;
  static const IconData levelIntermediate = Icons.auto_stories_rounded;
  static const IconData levelAdvanced = Icons.military_tech_rounded;
  static const IconData goalConversation = Icons.forum_rounded;
  static const IconData goalCulture = Icons.theater_comedy_rounded;
}
