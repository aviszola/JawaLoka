import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/profile/blangkon_rewards.dart';
import '../../../../core/profile/profile_preferences.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../widgets/blangkon_painter.dart';
import '../widgets/javanese_avatar_widget.dart';

/// JawaLoka - Profile (Profil) Screen.
/// Pixel-accurate implementation of Stitch Screen #e5a2d70abae2486ebdec67b521794944.
///
/// Features:
/// - Top bar with gear settings icon button
/// - Amber Hero Card with faint Kawung background texture
/// - Avatar with 75% circular progress ring, cute Javanese character, and edit button
/// - Inline editable name (Dimas)
/// - Three status pills: Level 4, Streak 5 hari, 8 Kuis Minggu Ini
/// - 4-badge achievement collection grid (Streak 7 Hari, Streak 30 Hari, Level 5, Tamat Aksara)
/// - Primary ink button: "Pilih Blangkon" leading to customization catalog
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String _displayName = 'Dimas';
  bool _isEditingName = false;
  final TextEditingController _nameCtrl = TextEditingController(text: 'Dimas');
  String? _nameError;

  BlangkonType _equippedBlangkon = BlangkonType.yogyakarta;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
        );

    _entranceCtrl.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = ProfileScope.maybeOf(context);
    if (profile != null) {
      if (!_isEditingName) {
        _displayName = profile.displayName;
        _nameCtrl.text = _displayName;
      }
      _equippedBlangkon = profile.equippedBlangkon;
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _saveName() {
    final validation = Validators.validateDisplayName(_nameCtrl.text);
    if (validation.isInvalid) {
      final err = (validation as Invalid<String, NameError>).error;
      final msg = ValidationMessages.nameError(context.l10n, err);
      setState(() => _nameError = msg);
      HapticFeedback.heavyImpact();
      return;
    }

    final normalized = (validation as Valid<String, NameError>).value;

    setState(() {
      _displayName = normalized;
      _nameCtrl.text = normalized;
      _nameError = null;
      _isEditingName = false;
    });

    ProfileScope.maybeOf(context)?.setDisplayName(normalized);
    HapticFeedback.mediumImpact();
    _showToast(context.l10n.profileNameSaved(normalized));
  }

  void _cancelEditName() {
    setState(() {
      _nameCtrl.text = _displayName;
      _nameError = null;
      _isEditingName = false;
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroCard(),
                        const SizedBox(height: 20),
                        _buildBadgeSection(),
                        const SizedBox(height: 24),
                        _buildBlangkonButton(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 1. Top Bar ────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.profileTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              letterSpacing: -0.5,
            ),
          ),
          // Gear Settings Button
          Semantics(
            label: context.l10n.profileSettingsSemantics,
            button: true,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, AppRouter.settings);
              },
              child: Container(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                alignment: Alignment.center,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    AppIcons.settings,
                    size: 21,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Amber Hero Card ───────────────────────────────────────────────────

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 260),
      decoration: BoxDecoration(
        color: AppColors.primaryAmber,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main Card Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with Progress Ring
                JavaneseAvatarWidget(
                  size: 92,
                  blangkonType: _equippedBlangkon,
                  progress: ProfileScope.maybeOf(context)?.levelProgress ?? 0.0,
                  showEditButton: true,
                  onEditTap: () async {
                    HapticFeedback.selectionClick();
                    final val = await Navigator.pushNamed(
                      context,
                      AppRouter.chooseBlangkon,
                    );
                    if (!mounted) return;
                    if (val is BlangkonType) {
                      setState(() => _equippedBlangkon = val);
                      ProfileScope.maybeOf(context)?.setEquippedBlangkon(val);
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Name Area (View Mode or Inline Edit)
                if (!_isEditingName) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingName = true;
                        _nameCtrl.text = _displayName;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _displayName,
                            style: Theme.of(context).textTheme.headlineMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          AppIcons.verified,
                          size: 18,
                          color: AppColors.amberDark,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          AppIcons.edit,
                          size: 16,
                          color: AppColors.inkSecondary,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 36,
                        child: TextField(
                          controller: _nameCtrl,
                          autofocus: true,
                          maxLength: 30,
                          buildCounter:
                              (
                                context, {
                                required currentLength,
                                required isFocused,
                                required maxLength,
                              }) => null,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.ink,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.ink,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Semantics(
                        label: context.l10n.profileSaveName,
                        button: true,
                        child: GestureDetector(
                          onTap: _saveName,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 48,
                              minWidth: 48,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              context.l10n.profileSaveName,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Semantics(
                        label: context.l10n.profileCancelEdit,
                        button: true,
                        child: GestureDetector(
                          onTap: _cancelEditName,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 48,
                              minWidth: 48,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              context.l10n.profileCancelEdit,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_nameError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _nameError!,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 14),

                // Status Pills: Lv 4, Streak 5 hari, and 8 Kuis Minggu Ini
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ProfileScope.maybeOf(context)?.gender ==
                                    UserGender.female
                                ? AppIcons.genderFemale
                                : AppIcons.genderMale,
                            size: 14,
                            color: AppColors.amberDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${ProfileScope.maybeOf(context)?.gender.label ?? "Putra"} • ${ProfileScope.maybeOf(context)?.age ?? 17} Th',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            AppIcons.dot,
                            size: 8,
                            color: AppColors.amberDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.l10n.profileLevelPill(
                              ProfileScope.maybeOf(context)?.userLevel ?? 1,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final xpText =
                            '${ProfileScope.maybeOf(context)?.totalXP ?? 0} XP';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.ink.withValues(alpha: 0.05),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                AppIcons.xp,
                                size: 14,
                                color: AppColors.amberDark,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                xpText,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            AppIcons.streak,
                            size: 16,
                            color: AppColors.accentOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.profileStreakPill(
                              ProfileScope.maybeOf(context)?.streakDays ?? 0,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            AppIcons.missionCount,
                            size: 16,
                            color: AppColors.amberDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.profileQuizzesThisWeek(
                              ProfileScope.maybeOf(context)?.quizzesThisWeek ??
                                  0,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Section Lencana ───────────────────────────────────────────────────

  Widget _buildBadgeSection() {
    final profile = ProfileScope.maybeOf(context);
    final userLevel = profile?.userLevel ?? 1;
    final hasMasteredAksara = profile?.hasMasteredAksara ?? false;
    final isLevel5Unlocked = userLevel >= 5;
    final isAksaraUnlocked = hasMasteredAksara;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  context.l10n.profileBadgeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pastelSand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.profileBadgeOpenCount,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              context.l10n.profileBadgeCollection,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Grid of 4 Achievement Badges
        LayoutBuilder(
          builder: (_, constraints) {
            final cardWidth = constraints.maxWidth;
            return Column(
              children: [
                // Badge 1: Streak 7 Hari (Unlocked)
                _buildBadgeCard(
                  width: cardWidth,
                  title: context.l10n.profileBadgeStreak7Title,
                  statusLabel: context.l10n.profileBadgeUnlocked,
                  isUnlocked: true,
                  bgColor: AppColors.surfaceWarm,
                  icon: AppIcons.star,
                  iconColor: AppColors.primaryDark,
                  onTap: () =>
                      _showToast(context.l10n.profileBadgeStreak7Toast),
                ),
                const SizedBox(height: 12),

                // Badge 2: Streak 30 Hari (Locked)
                _buildBadgeCard(
                  width: cardWidth,
                  title: context.l10n.profileBadgeStreak30Title,
                  statusLabel: context.l10n.profileBadgeLocked,
                  isUnlocked: false,
                  bgColor: Colors.white,
                  icon: AppIcons.lock,
                  iconColor: AppColors.inkMuted,
                  onTap: () =>
                      _showToast(context.l10n.profileBadgeStreak30Toast),
                ),
                _buildBadgeCard(
                  width: cardWidth,
                  title: context.l10n.profileBadgeLevel5Title,
                  statusLabel: isLevel5Unlocked
                      ? context.l10n.profileBadgeUnlocked
                      : context.l10n.profileBadgeLocked,
                  isUnlocked: isLevel5Unlocked,
                  bgColor: AppColors.surfaceWarm,
                  icon: isLevel5Unlocked
                      ? AppIcons.trophy
                      : AppIcons.lock,
                  iconColor: isLevel5Unlocked
                      ? AppColors.primaryDark
                      : AppColors.inkMuted,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (isLevel5Unlocked) {
                      _showToast(context.l10n.profileBadgeLevel5Toast);
                      return;
                    }
                    _showToast(
                      context.l10n.blangkonToastLevel(
                        5,
                        BlangkonRewards.getName(BlangkonType.surakarta),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Badge 4: Tamat Aksara
                _buildBadgeCard(
                  width: cardWidth,
                  title: context.l10n.profileBadgeAksaraCompleteTitle,
                  statusLabel: isAksaraUnlocked
                      ? context.l10n.profileBadgeUnlocked
                      : context.l10n.profileBadgeEasyLevel,
                  isUnlocked: isAksaraUnlocked,
                  bgColor: AppColors.surfaceWarm,
                  icon: AppIcons.proverbs,
                  iconColor: AppColors.primaryDark,
                  onTap: () => _showToast(context.l10n.profileBadgeAksaraToast),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required double width,
    required String title,
    required String statusLabel,
    required bool isUnlocked,
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
    Widget? customIconWidget,
    String? badgeHighlight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isUnlocked ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isUnlocked ? AppColors.ink : AppColors.inkMuted,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppColors.surface.withValues(alpha: 0.9)
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      badgeHighlight ?? statusLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isUnlocked ? AppColors.ink : AppColors.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child:
                    customIconWidget ??
                    Icon(
                      icon,
                      size: 24,
                      color: isUnlocked ? iconColor : AppColors.inkMuted,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 4. Primary Button: Pilih Blangkon ────────────────────────────────────

  Widget _buildBlangkonButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          HapticFeedback.mediumImpact();
          final val = await Navigator.pushNamed(
            context,
            AppRouter.chooseBlangkon,
          );
          if (!mounted) return;
          if (val is BlangkonType) {
            setState(() => _equippedBlangkon = val);
            ProfileScope.maybeOf(context)?.setEquippedBlangkon(val);
          }
        },
        icon: const Icon(
          AppIcons.blangkonStyle,
          size: 20,
          color: AppColors.amber,
        ),
        label: Text(
          (ProfileScope.maybeOf(context)?.gender ?? UserGender.male) ==
                  UserGender.female
              ? context.l10n.profileChooseBusanaButton
              : context.l10n.profileChooseBlangkonButton,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: AppColors.ink.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
