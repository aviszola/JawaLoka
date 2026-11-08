import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/auth_banner.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Registration Screen
/// Design ref: Stitch #776cbb8fdc5b475da5428fda44a7d353
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  bool _isLoading = false;
  bool _hasAttemptedSubmit = false;
  String? _emailError;
  String? _passwordError;
  String? _nameError;

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
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    String? nameErr;
    String? emailErr;
    String? passErr;

    if (name.isEmpty) {
      nameErr = context.l10n.validationNameRequired;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      emailErr = context.l10n.validationEmailInvalid;
    }

    if (password.length < 8) {
      passErr = context.l10n.validationPasswordMinLength;
    }

    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passwordError = passErr;
    });

    return nameErr == null && emailErr == null && passErr == null;
  }

  Future<void> _register() async {
    _hasAttemptedSubmit = true;
    final isValid = _validateForm();

    if (!isValid) {
      HapticFeedback.heavyImpact();
      return;
    }

    final trimmedName = _nameCtrl.text.trim();
    // DEMO: tanpa backend
    // Kata sandi TIDAK disimpan di mana pun (buang setelah validasi)
    _passwordCtrl.clear();

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // DEMO: tanpa backend - simpan nama langsung ke ProfileController
    await ProfileScope.maybeOf(context)?.setDisplayName(trimmedName);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigasi ke beranda dan bersihkan riwayat onboarding/pendaftaran
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

                          // Tombol Kembali
                          Row(
                            children: [
                              _BackButton(onTap: () => Navigator.pop(context)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 1. Amber Cultural Banner (tanpa chip LANGKAH AWAL, tinggi 120, radius 28)
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
                                glyphWatermark: 'ꦲ',
                                height: 120,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 2. Judul Halaman Tunggal (Buat akunmu & Simpan progres belajarmu di mana saja)
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
                                  context.l10n.registerTitle,
                                  style: theme.textTheme.displayMedium
                                      ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.registerSubtitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    color: AppColors.inkSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 3. Kolom Formulir Pendaftaran
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
                                    begin: const Offset(0, 0.15),
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
                                  // KEPUTUSAN PRODUK: nama di registrasi atau di profil
                                  CustomTextField(
                                    label: context.l10n.authFullNameLabel,
                                    controller: _nameCtrl,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.name],
                                    errorText: _nameError,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.person_outline,
                                        color: AppColors.inkSecondary,
                                        size: 20,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      if (_hasAttemptedSubmit) _validateForm();
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  CustomTextField(
                                    label: context.l10n.authEmailLabel,
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.email],
                                    errorText: _emailError,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.inkSecondary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon:
                                        _emailCtrl.text.trim().contains('@') &&
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
                                    onChanged: (_) {
                                      if (_hasAttemptedSubmit) _validateForm();
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  CustomTextField(
                                    label: context.l10n.authPasswordLabel,
                                    controller: _passwordCtrl,
                                    obscureText: true,
                                    showTogglePassword: true,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                    errorText: _passwordError,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: AppColors.inkSecondary,
                                        size: 20,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      if (_hasAttemptedSubmit) _validateForm();
                                    },
                                    onSubmitted: (_) => _register(),
                                  ),
                                  const SizedBox(height: 8),

                                  // Hint kekuatan kata sandi
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          size: 14,
                                          color: AppColors.amberDark,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            context.l10n.registerPasswordHint,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.inkSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Spacer fleksibel: mendorong aksi ke bawah saat keyboard tertutup, ikut scroll saat terbuka
                          const Spacer(),
                          const SizedBox(height: 24),

                          // 4. Tombol Aksi Bawah & Footer
                          PrimaryButton(
                            label: context.l10n.registerButton,
                            onPressed: _isLoading ? null : _register,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 16),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      context.l10n.registerPrivacyPolicy,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    content: Text(
                                      context.l10n.settingsPrivacyPolicyContent,
                                      style: const TextStyle(
                                        color: AppColors.inkSecondary,
                                        height: 1.4,
                                      ),
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
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: context.l10n.registerTermsPrefix,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.inkSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: context.l10n.registerPrivacyPolicy,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.amberDark,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.l10n.registerAlreadyHaveAccount,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  color: AppColors.inkSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                ),
                                child: Text(
                                  context.l10n.registerLoginLink,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
      ),
    );
  }
}
