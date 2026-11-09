import 'package:flutter/material.dart';
import '../../../../core/l10n/app_locales.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/l10n/locale_scope.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/theme/app_colors.dart';
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
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.settingsLogout,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          context.l10n.settingsLogoutConfirm,
          style: const TextStyle(color: AppColors.inkSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              context.l10n.settingsCancel,
              style: const TextStyle(color: AppColors.inkSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text(
              context.l10n.settingsLogout,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Language selection dialog ───────────────────────────────────────────────
  void _showLanguageDialog() {
    final controller = LocaleScope.of(context);
    final dialogTitle = context.l10n.settingsLanguageDialogTitle;

    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          dialogTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
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
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
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
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
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
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Privacy policy dialog ───────────────────────────────────────────────────
  void _showPrivacyPolicyDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.settingsPrivacyPolicy,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          context.l10n.settingsPrivacyPolicyContent,
          style: const TextStyle(color: AppColors.inkSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              context.l10n.settingsClose,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Account detail dialog ───────────────────────────────────────────────────
  // DEMO: tanpa backend - akun lokal
  void _showAccountDialog() {
    final profile = ProfileScope.maybeOf(context);
    final l10n = context.l10n;
    final name = profile?.displayName ?? 'Dimas';

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.settingsAccountDialogTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsAccountNameLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.settingsAccountLocalNote,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.inkSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.settingsClose,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header Widget (High Contrast, WCAG AA Compliant) ─────────────────────────
  Widget _buildHeader() {
    final displayName =
        ProfileScope.maybeOf(context)?.displayName ?? 'Dimas';
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
          color: AppColors.amber,
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
                        Icons.arrow_back_ios_new_rounded,
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.homeLevelPill(
                          ProfileScope.maybeOf(context)?.userLevel ?? 1,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
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
    const chevron = Icon(Icons.chevron_right, color: AppColors.inkMuted);

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
                  Icons.person_outline_rounded,
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
                      Icons.language_rounded,
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
                          style: const TextStyle(
                            color: AppColors.inkSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
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
                  Icons.privacy_tip_outlined,
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

              // 4. Keluar
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(
                  Icons.logout_rounded,
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
