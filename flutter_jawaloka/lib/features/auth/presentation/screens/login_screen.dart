import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/auth_banner.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Login Screen
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
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading = false;
  bool _showAuthError = false;
  String? _emailError;
  String? _passwordError;

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
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final emailText = _emailCtrl.text.trim();
    final passwordText = _passwordCtrl.text;

    setState(() {
      _showAuthError = false;
      _emailError = !emailText.contains('@')
          ? context.l10n.validationEmailInvalid
          : null;
      _passwordError = passwordText.isEmpty
          ? context.l10n.validationPasswordEmpty
          : null;
    });

    if (_emailError != null || _passwordError != null) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // If email is explicitly salah@jawaloka.id, demonstrate error state
    if (emailText == 'salah@jawaloka.id') {
      setState(() => _showAuthError = true);
      HapticFeedback.heavyImpact();
    } else {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
    }
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

                          // Amber Cultural Banner (tanpa chip pengisi, tinggi 120, radius 28)
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

                          // Error banner (jika kredensial salah)
                          if (_showAuthError)
                            FadeTransition(
                              opacity: Tween<double>(begin: 0, end: 1).animate(
                                CurvedAnimation(
                                  parent: _entranceCtrl,
                                  curve: const Interval(0.0, 1.0),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.errorLight,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.error.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        context
                                            .l10n
                                            .loginInvalidCredentialsError,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                    Semantics(
                                      label: context.l10n.commonCloseError,
                                      button: true,
                                      child: GestureDetector(
                                        onTap: () => setState(
                                          () => _showAuthError = false,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: AppColors.error,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Form fields
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
                                children: [
                                  CustomTextField(
                                    label: context.l10n.authEmailLabel,
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    errorText: _emailError,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.inkSecondary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon:
                                        _emailCtrl.text.contains('@') &&
                                            _emailError == null
                                        ? const Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Icon(
                                              Icons.check_circle_rounded,
                                              color: AppColors.success,
                                              size: 20,
                                            ),
                                          )
                                        : null,
                                    onChanged: (_) => setState(() {
                                      _emailError = null;
                                      _showAuthError = false;
                                    }),
                                  ),
                                  const SizedBox(height: 14),
                                  CustomTextField(
                                    label: context.l10n.authPasswordLabel,
                                    controller: _passwordCtrl,
                                    obscureText: true,
                                    showTogglePassword: true,
                                    errorText: _passwordError,
                                    textInputAction: TextInputAction.done,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: AppColors.inkSecondary,
                                        size: 20,
                                      ),
                                    ),
                                    onChanged: (_) => setState(() {
                                      _passwordError = null;
                                      _showAuthError = false;
                                    }),
                                    onSubmitted: (_) => _login(),
                                  ),
                                  const SizedBox(height: 10),

                                  // Lupa kata sandi
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to forgot password in production
                                      },
                                      child: Text(
                                        context.l10n.loginForgotPassword,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.amberDark,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.amberDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),
                          const SizedBox(height: 24),

                          // Tombol Masuk Utama
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
                                const SizedBox(height: 16),

                                // Divider dengan "Atau masuk dengan"
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: AppColors.border,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        context.l10n.loginOrWith,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.inkMuted,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: AppColors.border,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Google sign-in button
                                _GoogleSignInButton(
                                  onTap: () {
                                    // Google sign-in in production
                                  },
                                ),
                                const SizedBox(height: 18),

                                // Footer: register link (Kontras tinggi, WCAG AA compliant)
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
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleSignInButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loginGoogleButton,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amberSoft,
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.l10n.loginGoogleButton,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
