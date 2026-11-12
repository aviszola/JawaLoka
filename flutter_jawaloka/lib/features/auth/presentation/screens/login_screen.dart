import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../widgets/auth_banner.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Login Screen (Guest & Preference Profiling)
/// Implements responsive, keyboard-resilient layout with SliverFillRemaining,
/// WCAG AA high-contrast typography, and no synthetic chrome elements.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  bool _isLoading = false;
  String? _nameError;
  int _selectedLevel = 1; // 1 = Pemula, 4 = Menengah, 7 = Mahir
  int _selectedGoalIndex = 0; // 0 = Aksara, 1 = Percakapan, 2 = Budaya

  late final AnimationController _entranceCtrl;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final nameResult = Validators.validateDisplayName(_nameCtrl.text);
    final l10n = context.l10n;

    setState(() {
      _nameError = switch (nameResult) {
        Valid() => null,
        Invalid(:final error) => ValidationMessages.nameError(l10n, error),
      };
    });

    if (nameResult.isInvalid) {
      HapticFeedback.heavyImpact();
      return;
    }

    final normalizedName = switch (nameResult) {
      Valid(:final value) => value,
      Invalid() => '',
    };

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final profile = ProfileScope.maybeOf(context);
    if (profile != null) {
      if (normalizedName.isNotEmpty) {
        await profile.setDisplayName(normalizedName);
      }
      await profile.setUserLevel(_selectedLevel);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
  }

  void _continueAsGuest() {
    HapticFeedback.mediumImpact();
    final text = _nameCtrl.text.trim();
    if (text.isNotEmpty) {
      final nameResult = Validators.validateDisplayName(text);
      if (nameResult case Valid(:final value)) {
        final profile = ProfileScope.maybeOf(context);
        profile?.setDisplayName(value);
      }
    }
    final profile = ProfileScope.maybeOf(context);
    profile?.setUserLevel(_selectedLevel);

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _entranceCtrl,
          builder: (context, _) {
            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Tombol Kembali (touch target >= 48 dp)
                          Row(
                            children: [
                              _BackButton(onTap: () => Navigator.pop(context)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Amber Cultural Banner (tinggi 120, radius 28)
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceCtrl,
                                curve: const Interval(0.0, 0.5),
                              ),
                            ),
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _entranceCtrl,
                                      curve: const Interval(
                                        0.0,
                                        0.6,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: AuthBanner(
                                title: context.l10n.authWelcomeBannerTitle,
                                subtitle:
                                    context.l10n.authWelcomeBannerSubtitle,
                                glyphWatermark: 'ꦗ',
                                height: 120,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Judul Halaman Masuk
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceCtrl,
                                curve: const Interval(0.2, 0.7),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.loginTitle,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.loginSubtitle,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.inkSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form & Preference Questions
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceCtrl,
                                curve: const Interval(0.3, 0.8),
                              ),
                            ),
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _entranceCtrl,
                                      curve: const Interval(
                                        0.3,
                                        0.8,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Input Nama
                                  CustomTextField(
                                    label: context.l10n.authFullNameLabel,
                                    controller: _nameCtrl,
                                    maxLength: 30,
                                    errorText: _nameError,
                                    textInputAction: TextInputAction.done,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(
                                        AppIcons.person,
                                        color: AppColors.inkSecondary,
                                        size: 20,
                                      ),
                                    ),
                                    onChanged: (_) => setState(() {
                                      _nameError = null;
                                    }),
                                    onSubmitted: (_) => _login(),
                                  ),
                                  const SizedBox(height: 18),

                                  // 2. Pertanyaan Tingkat Kemampuan
                                  Text(
                                    context.l10n.loginQuestionLevelTitle,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _PreferenceChip(
                                        label: context.l10n.loginLevelBeginner,
                                        icon: AppIcons.levelBeginner,
                                        isSelected: _selectedLevel == 1,
                                        onTap: () =>
                                            setState(() => _selectedLevel = 1),
                                      ),
                                      _PreferenceChip(
                                        label:
                                            context.l10n.loginLevelIntermediate,
                                        icon: AppIcons.levelIntermediate,
                                        isSelected: _selectedLevel == 4,
                                        onTap: () =>
                                            setState(() => _selectedLevel = 4),
                                      ),
                                      _PreferenceChip(
                                        label: context.l10n.loginLevelAdvanced,
                                        icon: AppIcons.levelAdvanced,
                                        isSelected: _selectedLevel == 7,
                                        onTap: () =>
                                            setState(() => _selectedLevel = 7),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),

                                  // 3. Pertanyaan Target Belajar
                                  Text(
                                    context.l10n.loginQuestionGoalTitle,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _PreferenceChip(
                                        label: context.l10n.loginGoalAksara,
                                        icon: AppIcons.writingSteps,
                                        isSelected: _selectedGoalIndex == 0,
                                        onTap: () => setState(
                                          () => _selectedGoalIndex = 0,
                                        ),
                                      ),
                                      _PreferenceChip(
                                        label:
                                            context.l10n.loginGoalConversation,
                                        icon: AppIcons.goalConversation,
                                        isSelected: _selectedGoalIndex == 1,
                                        onTap: () => setState(
                                          () => _selectedGoalIndex = 1,
                                        ),
                                      ),
                                      _PreferenceChip(
                                        label: context.l10n.loginGoalCulture,
                                        icon: AppIcons.goalCulture,
                                        isSelected: _selectedGoalIndex == 2,
                                        onTap: () => setState(
                                          () => _selectedGoalIndex = 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),
                          const SizedBox(height: 24),

                          // Tombol Masuk Utama & Opsi Tamu
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceCtrl,
                                curve: const Interval(0.5, 1.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                PrimaryButton(
                                  label: context.l10n.loginButton,
                                  onPressed: _isLoading ? null : _login,
                                  isLoading: _isLoading,
                                ),
                                const SizedBox(height: 12),

                                // Tombol Lanjut sebagai Tamu (Zero-Friction Guest Mode)
                                OutlinedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _continueAsGuest,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    side: const BorderSide(
                                      color: AppColors.border,
                                      width: 1.2,
                                    ),
                                    shape: const StadiumBorder(),
                                    foregroundColor: AppColors.ink,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          context.l10n.authContinueAsGuest,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        AppIcons.forward,
                                        size: 18,
                                        color: AppColors.inkSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Footer: register link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      context.l10n.loginDontHaveAccount,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.inkSecondary,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppRouter.register,
                                          ),
                                      child: Text(
                                        context.l10n.loginRegisterLink,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.ink,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.amberDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//   Private Widgets
// ─────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.commonBack,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            AppIcons.back,
            size: 18,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PreferenceChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.amber.withValues(alpha: 0.16)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.amberDark : AppColors.border,
              width: isSelected ? 1.6 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected
                    ? AppColors.amberDark
                    : AppColors.inkSecondary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.ink : AppColors.inkSecondary,
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
