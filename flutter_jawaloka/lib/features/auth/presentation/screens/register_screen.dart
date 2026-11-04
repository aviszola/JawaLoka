import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _register() async {
    // Basic validation
    setState(() {
      _nameError = _nameCtrl.text.trim().isEmpty ? 'Nama tidak boleh kosong' : null;
      _emailError = !_emailCtrl.text.contains('@') ? 'Format email tidak valid' : null;
      _passwordError = _passwordCtrl.text.length < 8
          ? 'Kata sandi minimal 8 karakter'
          : null;
    });

    if (_nameError != null || _emailError != null || _passwordError != null) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to home / learn hub
    Navigator.of(context).pushReplacementNamed(AppRouter.learnHub);
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
                              CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.0, 0.5)),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
                                CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
                              ),
                              child: const AuthBanner(
                                badgeLabel: 'Langkah Awal',
                                title: 'Buat akunmu',
                                subtitle: 'Simpan progres belajarmu di mana saja',
                                glyphWatermark: 'ꦲ',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Header text
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.2, 0.7)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daftar sekarang',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink, letterSpacing: -0.5),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Mulai perjalanan belajar bahasa Jawa',
                                  style: TextStyle(fontSize: 14, color: AppColors.inkSecondary, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form fields
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.3, 0.8)),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                                CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
                              ),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    label: 'Nama Lengkap',
                                    controller: _nameCtrl,
                                    keyboardType: TextInputType.name,
                                    errorText: _nameError,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(Icons.person_outline, color: AppColors.inkSecondary, size: 20),
                                    ),
                                    onChanged: (_) => setState(() => _nameError = null),
                                  ),
                                  const SizedBox(height: 14),
                                  CustomTextField(
                                    label: 'Email',
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    errorText: _emailError,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Icon(Icons.email_outlined, color: AppColors.inkSecondary, size: 20),
                                    ),
                                    suffixIcon: _emailCtrl.text.contains('@') && _emailError == null
                                        ? const Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                          )
                                        : null,
                                    onChanged: (_) => setState(() => _emailError = null),
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
                                      child: Icon(Icons.lock_outline, color: AppColors.inkSecondary, size: 20),
                                    ),
                                    onChanged: (_) => setState(() => _passwordError = null),
                                    onSubmitted: (_) => _register(),
                                  ),
                                  const SizedBox(height: 8),
                                  // Password strength hint
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 14, color: AppColors.amberDark),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Gunakan kata sandi yang kuat (min. 8 karakter)',
                                          style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, fontWeight: FontWeight.w500),
                                        ),
                                      ],
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Column(
                    children: [
                      PrimaryButton(
                        label: 'Daftar',
                        onPressed: _isLoading ? null : _register,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          text: 'Dengan mendaftar, kamu menyetujui ',
                          style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
                          children: [
                            TextSpan(
                              text: 'Kebijakan Privasi',
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun? ', style: TextStyle(fontSize: 14, color: AppColors.inkSecondary)),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(width: 128, height: 4, decoration: BoxDecoration(color: AppColors.ink.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                    ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.ink),
      ),
    );
  }
}

