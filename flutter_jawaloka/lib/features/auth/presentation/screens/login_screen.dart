import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/auth_banner.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Login Screen
/// Mirrors the design language of register_screen.dart with login-specific content.
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
    setState(() {
      _showAuthError = false;
      _emailError = !_emailCtrl.text.contains('@') ? 'Format email tidak valid' : null;
      _passwordError = _passwordCtrl.text.isEmpty ? 'Kata sandi tidak boleh kosong' : null;
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

    // If email is explicitly salah@jawaloka.id, demonstrate error state from Stitch design
    if (_emailCtrl.text.trim() == 'salah@jawaloka.id') {
      setState(() => _showAuthError = true);
      HapticFeedback.heavyImpact();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRouter.learnHub);
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
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Back button row
                          Row(
                            children: [
                              _BackButton(onTap: () => Navigator.pop(context)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Amber Cultural Banner
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceCtrl,
                                curve: const Interval(0.0, 0.5),
                              ),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _entranceCtrl,
                                  curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
                                ),
                              ),
                              child: const AuthBanner(
                                badgeLabel: 'Sugeng rawuh kembali',
                                title: 'Selamat datang kembali',
                                subtitle: 'Lanjutkan petualangan aksaramu',
                                glyphWatermark: 'ꦗ',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Header text
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceCtrl,
                                curve: const Interval(0.2, 0.7),
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Masuk sekarang',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lanjutkan perjalanan belajar bahasa Jawa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.inkSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Error banner (shown when credentials are wrong)
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
                                    color: AppColors.error.withValues(alpha: 0.3),
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
                                    const Expanded(
                                      child: Text(
                                        'Email atau kata sandi salah',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() => _showAuthError = false),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: AppColors.error,
                                        size: 18,
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
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _entranceCtrl,
                                  curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                                ),
                              ),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    label: 'Email',
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
                                    suffixIcon: _emailCtrl.text.contains('@') && _emailError == null
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
                                    label: 'Kata Sandi',
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

                                  // Forgot password link
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to forgot password in production
                                      },
                                      child: const Text(
                                        'Lupa kata sandi?',
                                        style: TextStyle(
                                          fontSize: 13,
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
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom actions
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _entranceCtrl,
                      curve: const Interval(0.5, 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Column(
                      children: [
                        // Primary login button
                        PrimaryButton(
                          label: 'Masuk',
                          onPressed: _isLoading ? null : _login,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 16),

                        // Divider with "Atau masuk dengan"
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.border,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Atau masuk dengan',
                                style: TextStyle(
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
                        const SizedBox(height: 16),

                        // Footer: register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.inkSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                AppRouter.register,
                              ),
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 128,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.ink.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.ink,
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
    return GestureDetector(
      onTap: onTap,
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
            // Google "G" logo using text — avoids external asset dependency
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentOrange,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Lanjutkan dengan Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
