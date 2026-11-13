import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_preferences.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../../../profile/presentation/widgets/javanese_avatar_widget.dart';
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
  Timer? _holdTimer;
  int _holdTicks = 0;
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
    _holdTimer?.cancel();
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
    final safe = age.clamp(1, 120);
    HapticFeedback.lightImpact();
    setState(() {
      _selectedAge = safe;
      _ageCtrl.text = '$safe';
    });
  }

  void _startAgeHold(int delta) {
    _holdTimer?.cancel();
    _holdTicks = 0;
    _scheduleNextHoldTick(delta);
  }

  void _scheduleNextHoldTick(int delta) {
    final delayMs = (_holdTicks < 5)
        ? 180
        : (_holdTicks < 12 ? 100 : 55);
    _holdTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      _holdTicks++;
      _setAge(_selectedAge + delta);
      _scheduleNextHoldTick(delta);
    });
  }

  void _stopAgeHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdTicks = 0;
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
      await profile.markSetupCompleted();
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
      await profile.markSetupCompleted();
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
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.profileSetupTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.profileSetupSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
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
                        backgroundColor: AppColors.surfaceWarm,
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
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Pilihan Gender (Putra vs Putri) ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.profileSetupSelectCharacter,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
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
                          icon: AppIcons.genderMale,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Opsi Putri
                      Expanded(
                        child: _buildGenderCard(
                          gender: UserGender.female,
                          title: l10n.profileSetupFemaleTitle,
                          subtitle: l10n.profileSetupFemaleSubtitle,
                          icon: AppIcons.genderFemale,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Input Nama Panggilan ──
                  _NicknameInputField(
                    label: l10n.profileSetupNicknameLabel,
                    hint: l10n.profileSetupNicknameHint,
                    controller: _nameCtrl,
                    errorText: _nameError,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 18),

                  // ── Input Umur ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.border,
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
                            Flexible(
                              child: Text(
                                l10n.profileSetupAgeLabel,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.profileSetupAgeYears(_selectedAge),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                              icon: AppIcons.remove,
                              semanticLabel: '−',
                              onTap: () => _setAge(_selectedAge - 1),
                              onHoldStart: () => _startAgeHold(-1),
                              onHoldEnd: _stopAgeHold,
                            ),
                            Container(
                              width: 110,
                              alignment: Alignment.center,
                              child: Text(
                                _selectedAge.toString(),
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                            _buildStepperButton(
                              icon: AppIcons.add,
                              semanticLabel: '+',
                              onTap: () => _setAge(_selectedAge + 1),
                              onHoldStart: () => _startAgeHold(1),
                              onHoldEnd: _stopAgeHold,
                            ),
                          ],
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
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          AppIcons.verifiedUser,
                          size: 18,
                          color: AppColors.inkSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.profileSetupLocalNotice,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                    trailingIcon: AppIcons.forward,
                    onPressed: _saveAndProceed,
                    customChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.profileSetupPrimaryButton,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(AppIcons.forward, size: 20),
                      ],
                    ),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          color: isSelected ? AppColors.surfaceWarm : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.amberDark : AppColors.border,
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
                      : AppColors.border,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.ink
                          : AppColors.inkSecondary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                AppIcons.checkCircle,
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
    required String semanticLabel,
    required VoidCallback onTap,
    required VoidCallback onHoldStart,
    required VoidCallback onHoldEnd,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        onLongPressStart: (_) => onHoldStart(),
        onLongPressEnd: (_) => onHoldEnd(),
        onLongPressCancel: onHoldEnd,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceWarm,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Icon(icon, color: AppColors.ink, size: 22),
        ),
      ),
    );
  }
}
// ─── Input Kolom Nama Panggilan Khusus (Ukuran Disesuaikan) ─────────────────
class _NicknameInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? errorText;
  final TextInputAction textInputAction;

  const _NicknameInputField({
    required this.label,
    this.hint,
    required this.controller,
    this.errorText,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<_NicknameInputField> createState() => _NicknameInputFieldState();
}

class _NicknameInputFieldState extends State<_NicknameInputField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.02, 0)).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant _NicknameInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != null &&
        widget.errorText != oldWidget.errorText &&
        widget.errorText!.isNotEmpty) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  bool get _hasContent => widget.controller.text.isNotEmpty;
  bool get _isFocused => _focusNode.hasFocus;
  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _shakeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: const BoxConstraints(minHeight: 56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.amber.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : _hasError
                  ? [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.words,
              textInputAction: widget.textInputAction,
              onChanged: (val) {
                setState(() {});
              },
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: TextStyle(
                  color: _hasError
                      ? AppColors.error
                      : _isFocused
                      ? AppColors.ink
                      : AppColors.inkSecondary,
                  fontSize: 17,
                  fontWeight: _isFocused || _hasContent
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
                floatingLabelStyle: TextStyle(
                  color: _hasError ? AppColors.error : AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  AppIcons.person,
                  color: AppColors.inkSecondary,
                  size: 24,
                ),
                filled: true,
                fillColor: AppColors.surface,
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.amber,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          if (_hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 16),
              child: Row(
                children: [
                  const Icon(
                    AppIcons.error,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.errorText!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
