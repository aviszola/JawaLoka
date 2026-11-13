import 'package:flutter/material.dart';
import '../../../../core/l10n/app_locales.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/l10n/locale_scope.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/profile/profile_preferences.dart';
import '../../../../core/presentation/widgets/app_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/blangkon_painter.dart';
import '../widgets/javanese_avatar_widget.dart';

// ─── Settings Card Container ──────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// ─── Settings Screen ──────────────────────────────────────────────────────────

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late AnimationController _bodyCtrl;
  late Animation<Offset> _headerSlide;
  late Animation<double> _bodyFade;

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bodyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _bodyFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _bodyCtrl, curve: Curves.easeOutCubic));

    _headerCtrl.forward();
    _bodyCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  // ── Logout confirmation dialog ──────────────────────────────────────────────
  void _showLogoutDialog() {
    showAppDialog<void>(
      context: context,
      tone: AppDialogTone.destructive,
      icon: AppIcons.logout,
      title: context.l10n.settingsLogout,
      message: context.l10n.settingsLogoutConfirm,
      primaryLabel: context.l10n.settingsLogout,
      onPrimary: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await ProfileScope.maybeOf(context)?.resetSetupCompleted();
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.profileSetup,
          (route) => false,
        );
      },
      secondaryLabel: context.l10n.settingsCancel,
      onSecondary: () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }

  // ── Language selection dialog ───────────────────────────────────────────────
  void _showLanguageDialog() {
    final controller = LocaleScope.of(context);
    final dialogTitle = context.l10n.settingsLanguageDialogTitle;

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.ink.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (ctx, animation, secondaryAnimation) => SimpleDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          dialogTitle,
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.titleLarge,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              controller.setLocale(const Locale('jv'));
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                AppLocales.endonymOf('jv'),
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(color: AppColors.ink),
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              controller.setLocale(const Locale('id'));
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                AppLocales.endonymOf('id'),
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(color: AppColors.ink),
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              controller.setLocale(const Locale('en'));
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                AppLocales.endonymOf('en'),
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(color: AppColors.ink),
              ),
            ),
          ),
        ],
      ),
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  // ── Privacy policy dialog ───────────────────────────────────────────────────
  void _showPrivacyPolicyDialog() {
    showAppDialog<void>(
      context: context,
      tone: AppDialogTone.info,
      icon: AppIcons.privacy,
      title: context.l10n.settingsPrivacyPolicy,
      customContent: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: SingleChildScrollView(
          child: Text(
            context.l10n.settingsPrivacyPolicyContent,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.inkSecondary,
              height: 1.4,
            ),
          ),
        ),
      ),
      primaryLabel: context.l10n.settingsClose,
      onPrimary: () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }

  // ── Account detail dialog ───────────────────────────────────────────────────
  // DEMO: tanpa backend - akun lokal
  void _showAccountDialog() {
    final profile = ProfileScope.maybeOf(context);
    final l10n = context.l10n;
    final name = profile?.displayName ?? 'Dimas';
    final gender = profile?.gender ?? UserGender.male;
    final genderLabel = gender == UserGender.female
        ? l10n.profileSetupFemaleTitle
        : l10n.profileSetupMaleTitle;

    showAppDialog<void>(
      context: context,
      tone: AppDialogTone.info,
      icon: AppIcons.person,
      title: l10n.settingsProfileDialogTitle,
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.settingsProfileDialogNickname,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.inkSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.settingsProfileDialogCharacterAge,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.inkSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.settingsProfileDialogCharacterAgeValue(
              genderLabel,
              profile?.age ?? 17,
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.settingsProfileDialogLocalNote,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.inkSecondary,
            ),
          ),
        ],
      ),
      primaryLabel: l10n.settingsClose,
      onPrimary: () => Navigator.of(context, rootNavigator: true).pop(),
      secondaryLabel: l10n.settingsProfileDialogEditButton,
      onSecondary: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushNamed(context, AppRouter.profileSetup);
      },
    );
  }

  // ── Header Widget (High Contrast, WCAG AA Compliant) ─────────────────────────
  Widget _buildHeader() {
    final displayName = ProfileScope.maybeOf(context)?.displayName ?? 'Dimas';
    final equippedBlangkon =
        ProfileScope.maybeOf(context)?.equippedBlangkon ??
        BlangkonType.yogyakarta;
    final userFullName = displayName;
    return SlideTransition(
      position: _headerSlide,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.surfaceWarm, AppColors.canvas],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Semantics(
                  label: context.l10n.commonBack,
                  button: true,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        AppIcons.back,
                        size: 18,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Reusable Avatar Component
                JavaneseAvatarWidget(size: 60, blangkonType: equippedBlangkon),
                const SizedBox(width: 16),
                // Name & level (High Contrast Ink on Amber)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userFullName,
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.homeLevelPill(
                          ProfileScope.maybeOf(context)?.userLevel ?? 1,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Body Widget ─────────────────────────────────────────────────────────────
  Widget _buildBody() {
    const chevron = Icon(AppIcons.chevronRight, color: AppColors.inkMuted);

    return FadeTransition(
      opacity: _bodyFade,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          _SettingsCard(
            children: [
              // 1. Akun
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(
                  AppIcons.person,
                  color: AppColors.ink,
                ),
                title: Text(
                  context.l10n.settingsAccountRow,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: chevron,
                onTap: _showAccountDialog,
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),

              // 2. Bahasa
              Builder(
                builder: (ctx) {
                  final controller = LocaleScope.of(ctx);
                  final rowTitle = ctx.l10n.settingsLanguageRow;
                  final activeLanguageName = AppLocales.endonymOf(
                    controller.locale.languageCode,
                  );

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      AppIcons.language,
                      color: AppColors.ink,
                    ),
                    title: Text(
                      rowTitle,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activeLanguageName,
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                            color: AppColors.inkSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          AppIcons.chevronRight,
                          color: AppColors.inkMuted,
                        ),
                      ],
                    ),
                    onTap: _showLanguageDialog,
                  );
                },
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),

              // 3. Kebijakan Privasi
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(
                  AppIcons.privacy,
                  color: AppColors.ink,
                ),
                title: Text(
                  context.l10n.settingsPrivacyPolicy,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: chevron,
                onTap: _showPrivacyPolicyDialog,
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),

              // 5. Kredit kamus
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(
                  AppIcons.info,
                  color: AppColors.inkMuted,
                ),
                title: Text(
                  context.l10n.settingsDataCredit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                ),
                trailing: chevron,
              ),

              // 4. Keluar
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(
                  AppIcons.logout,
                  color: AppColors.error,
                ),
                title: Text(
                  context.l10n.settingsLogout,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: _showLogoutDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
