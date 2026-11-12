import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_preferences.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../../../profile/presentation/widgets/javanese_avatar_widget.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Profile Setup Screen (Pengaturan Data Diri & Karakter).
/// Menggantikan formulir autentikasi akun tradisional:
/// Menyimpan nama panggilan, umur, dan jenis kelamin (Putra / Putri)
/// secara langsung ke penyimpanan lokal perangkat tanpa menautkan akun.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController(text: '17');

  UserGender _selectedGender = UserGender.male;
  int _selectedAge = 17;
  String? _nameError;
  bool _isLoading = false;

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
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
        );

    _entranceCtrl.forward();

    // Inisialisasi awal dari profil yang sudah ada (jika ada)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ProfileScope.maybeOf(context);
      if (profile != null && mounted) {
        if (profile.displayName.isNotEmpty && profile.displayName != 'Dimas') {
          _nameCtrl.text = profile.displayName;
        }
        setState(() {
          _selectedGender = profile.gender;
          _selectedAge = profile.age;
          _ageCtrl.text = '$_selectedAge';
        });
      }
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  void _onGenderChanged(UserGender gender) {
    if (_selectedGender == gender) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedGender = gender);
  }

  void _setAge(int age) {
    final safe = age.clamp(6, 99);
    HapticFeedback.lightImpact();
    setState(() {
      _selectedAge = safe;
      _ageCtrl.text = '$safe';
    });
  }

  Future<void> _saveAndProceed() async {
    final rawName = _nameCtrl.text.trim();
    final ValidationResult<String, NameError> nameResult = rawName.isEmpty
        ? const Invalid(NameError.empty)
        : Validators.validateDisplayName(rawName);

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
      Invalid() => rawName,
    };

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final profile = ProfileScope.maybeOf(context);
    if (profile != null) {
      await profile.setDisplayName(normalizedName);
      await profile.setGender(_selectedGender);
      await profile.setAge(_selectedAge);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
  }

  Future<void> _skipAndProceed() async {
    HapticFeedback.mediumImpact();
    final l10n = context.l10n;
    final profile = ProfileScope.maybeOf(context);
    if (profile != null) {
      final inputName = _nameCtrl.text.trim();
      final finalName =
          inputName.isNotEmpty ? inputName : l10n.profileSetupDefaultGuestName;
      await profile.setDisplayName(finalName);
      await profile.setGender(_selectedGender);
      await profile.setAge(_selectedAge);
    }

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // ── Sub-badge Tagline ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.profileSetupBadgeTag,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.inkSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.profileSetupTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.profileSetupSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.inkSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Live Avatar Preview ──
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) {
                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOutBack,
                        ),
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey(_selectedGender),
                      child: JavaneseAvatarWidget(
                        size: 110,
                        gender: _selectedGender,
                        backgroundColor: const Color(0xFFFFF7E6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Badge Teks Karakter
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.amberDark.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      _selectedGender == UserGender.male
                          ? l10n.profileSetupCharacterMaleBadge
                          : l10n.profileSetupCharacterFemaleBadge,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Pilihan Gender (Putra vs Putri) ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.profileSetupSelectCharacter,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Opsi Putra
                      Expanded(
                        child: _buildGenderCard(
                          gender: UserGender.male,
                          title: l10n.profileSetupMaleTitle,
                          subtitle: l10n.profileSetupMaleSubtitle,
                          icon: Icons.face_rounded,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Opsi Putri
                      Expanded(
                        child: _buildGenderCard(
                          gender: UserGender.female,
                          title: l10n.profileSetupFemaleTitle,
                          subtitle: l10n.profileSetupFemaleSubtitle,
                          icon: Icons.face_3_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Input Nama Panggilan ──
                  CustomTextField(
                    label: l10n.profileSetupNicknameLabel,
                    hint: l10n.profileSetupNicknameHint,
                    controller: _nameCtrl,
                    errorText: _nameError,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.inkSecondary,
                      size: 22,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 18),

                  // ── Input Umur ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE8DFCE),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.profileSetupAgeLabel,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              l10n.profileSetupAgeYears(_selectedAge),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.amberDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Stepper row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStepperButton(
                              icon: Icons.remove_rounded,
                              onTap: () => _setAge(_selectedAge - 1),
                            ),
                            Container(
                              width: 110,
                              alignment: Alignment.center,
                              child: Text(
                                _selectedAge.toString(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            _buildStepperButton(
                              icon: Icons.add_rounded,
                              onTap: () => _setAge(_selectedAge + 1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Quick age chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [10, 15, 17, 20, 25].map((age) {
                            final isSelected = _selectedAge == age;
                            return GestureDetector(
                              onTap: () => _setAge(age),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.ink
                                      : AppColors.canvas,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.ink
                                        : const Color(0xFFDDD3C2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  l10n.profileSetupAgeChip(age),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.inkSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Privacy / No Account Notice ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3ECE0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: AppColors.inkSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.profileSetupLocalNotice,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inkSecondary,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Tombol Aksi Utama: Mulai Petualangan ──
                  PrimaryButton(
                    label: l10n.profileSetupPrimaryButton,
                    isLoading: _isLoading,
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: _saveAndProceed,
                  ),
                  const SizedBox(height: 12),

                  // ── Tombol Aksi Sekunder: Lewati ──
                  TextButton(
                    onPressed: _skipAndProceed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.inkSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      l10n.profileSetupSkipButton,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required UserGender gender,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () => _onGenderChanged(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF9EE) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.amberDark : const Color(0xFFE2D7C5),
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.amberDark.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.amberDark
                      : const Color(0xFFE2D7C5),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  gender == UserGender.female
                      ? 'assets/images/characters/avatar_putri.svg'
                      : 'assets/images/characters/avatar_putra.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.ink
                          : AppColors.inkSecondary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.inkSecondary
                          : AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.amberDark,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0E7D8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDD2C0), width: 1),
        ),
        child: Icon(icon, color: AppColors.ink, size: 22),
      ),
    );
  }
}
