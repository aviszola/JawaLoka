import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/profile/blangkon_rewards.dart';
import '../../../../core/profile/profile_preferences.dart';
import '../../../../core/profile/profile_scope.dart';
import '../widgets/blangkon_painter.dart';

class _BlangkonOption {
  final BlangkonType type;
  final String name;

  const _BlangkonOption({required this.type, required this.name});

  String description(BuildContext context, {required bool isFemale}) {
    if (isFemale) {
      switch (type) {
        case BlangkonType.yogyakarta:
          return context.l10n.busanaDescYogyakarta;
        case BlangkonType.surakarta:
          return context.l10n.busanaDescSurakarta;
        case BlangkonType.banyumas:
          return context.l10n.busanaDescBanyumas;
        case BlangkonType.kedu:
          return context.l10n.busanaDescKedu;
        case BlangkonType.cirebon:
          return context.l10n.busanaDescCirebon;
        case BlangkonType.pusaka:
          return context.l10n.busanaDescPusaka;
      }
    }
    switch (type) {
      case BlangkonType.yogyakarta:
        return context.l10n.blangkonDescYogyakarta;
      case BlangkonType.surakarta:
        return context.l10n.blangkonDescSurakarta;
      case BlangkonType.banyumas:
        return context.l10n.blangkonDescBanyumas;
      case BlangkonType.kedu:
        return context.l10n.blangkonDescKedu;
      case BlangkonType.cirebon:
        return context.l10n.blangkonDescCirebon;
      case BlangkonType.pusaka:
        return context.l10n.blangkonDescPusaka;
    }
  }
}

List<_BlangkonOption> _buildOptions(
  BuildContext context, {
  required bool isFemale,
}) {
  return BlangkonType.values
      .map((t) {
        final String name;
        if (isFemale) {
          switch (t) {
            case BlangkonType.yogyakarta:
              name = context.l10n.busanaNameYogyakarta;
              break;
            case BlangkonType.surakarta:
              name = context.l10n.busanaNameSurakarta;
              break;
            case BlangkonType.banyumas:
              name = context.l10n.busanaNameBanyumas;
              break;
            case BlangkonType.kedu:
              name = context.l10n.busanaNameKedu;
              break;
            case BlangkonType.cirebon:
              name = context.l10n.busanaNameCirebon;
              break;
            case BlangkonType.pusaka:
              name = context.l10n.busanaNamePusaka;
              break;
          }
        } else {
          name = BlangkonRewards.getName(t);
        }
        return _BlangkonOption(type: t, name: name);
      })
      .toList(growable: false);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ChooseBlangkonScreen extends StatefulWidget {
  const ChooseBlangkonScreen({super.key});

  @override
  State<ChooseBlangkonScreen> createState() => _ChooseBlangkonScreenState();
}

class _ChooseBlangkonScreenState extends State<ChooseBlangkonScreen>
    with SingleTickerProviderStateMixin {
  int get _currentUserLevel => ProfileScope.maybeOf(context)?.userLevel ?? 1;
  bool get _hasMasteredAksara =>
      ProfileScope.maybeOf(context)?.hasMasteredAksara ?? false;
  bool get _isFemale =>
      (ProfileScope.maybeOf(context)?.gender ?? UserGender.male) ==
      UserGender.female;

  late List<_BlangkonOption> _options;

  BlangkonType _selected = BlangkonType.yogyakarta;

  late AnimationController _avatarCtrl;
  late Animation<double> _avatarScale;

  @override
  void initState() {
    super.initState();
    _avatarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _avatarScale = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _avatarCtrl, curve: Curves.elasticOut));
  }

  bool _initializedFromScope = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Rebuild option names setiap kali gender atau locale berubah.
    _options = _buildOptions(context, isFemale: _isFemale);
    if (!_initializedFromScope) {
      _initializedFromScope = true;
      final equipped = ProfileScope.maybeOf(context)?.equippedBlangkon;
      if (equipped != null) _selected = equipped;
    }
  }

  @override
  void dispose() {
    _avatarCtrl.dispose();
    super.dispose();
  }

  bool _isOptionLocked(_BlangkonOption opt) {
    final profile = ProfileScope.maybeOf(context);
    if (profile != null) {
      return !profile.isBlangkonUnlocked(opt.type);
    }
    return !BlangkonRewards.isUnlocked(
      opt.type,
      userLevel: _currentUserLevel,
      hasMasteredAksara: _hasMasteredAksara,
    );
  }

  void _selectBlangkon(BlangkonType type, bool isLocked) {
    if (isLocked) {
      _showLockedSnackBar(type);
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _selected = type);
    _avatarCtrl.forward().then((_) => _avatarCtrl.reverse());
  }

  void _showLockedSnackBar(BlangkonType type) {
    final opt = _options.firstWhere((o) => o.type == type);
    final String message;
    if (type == BlangkonType.pusaka) {
      message = context.l10n.blangkonToastAksara(opt.name);
    } else {
      final reqLevel = BlangkonRewards.requiredLevels[type];
      if (reqLevel != null) {
        message = context.l10n.blangkonToastLevel(reqLevel, opt.name);
      } else {
        message = context.l10n.blangkonToastInitial(opt.name);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveSelection() {
    HapticFeedback.mediumImpact();
    ProfileScope.maybeOf(context)?.setEquippedBlangkon(_selected);
    Navigator.pop(context, _selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Column(
            children: [
              _buildHeroSection(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildBlangkonGrid(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSaveButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Section ─────────────────────────────────────────────────────────
  Widget _buildHeroSection() {
    final gender = ProfileScope.maybeOf(context)?.gender ?? UserGender.male;
    final svgPath = gender == UserGender.female
        ? _selected.putriAvatarAsset
        : _selected.putraAvatarAsset;
    final fallbackSvg = gender == UserGender.female
        ? 'assets/images/characters/avatar_putri.svg'
        : 'assets/images/characters/avatar_putra.svg';
    final opt = _options.firstWhere((o) => o.type == _selected);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        height: 320,
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFF7D46B)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft corner accent — no landscape / gunungan
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF0C0).withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF0C0).withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Karakter avatar
            Positioned(
              bottom: 32,
              child: ScaleTransition(
                scale: _avatarScale,
                child: SvgPicture.asset(
                  svgPath ?? fallbackSvg,
                  width: 160,
                  height: 185,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Chip nama + level di atas kiri
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      opt.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Deskripsi bawah
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.7),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    opt.description(context, isFemale: _isFemale),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7D46B),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Semantics(
        label: context.l10n.commonBack,
        button: true,
        child: BackButton(color: AppColors.ink),
      ),
      title: Text(
        _isFemale ? context.l10n.busanaTitle : context.l10n.blangkonTitle,
        style: const TextStyle(
          color: Color(0xFF231C14),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3D6),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color(0xFFF2D37E)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 14,
                color: Color(0xFF8A5D14),
              ),
              const SizedBox(width: 4),
              Text(
                context.l10n.homeLevelPill(_currentUserLevel),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF8A5D14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlangkonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 90 / 115,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _options.length,
      itemBuilder: (context, i) {
        final opt = _options[i];
        final isLocked = _isOptionLocked(opt);
        final isSelected = _selected == opt.type;

        return _BlangkonGridItem(
          option: opt,
          isLocked: isLocked,
          isSelected: isSelected,
          isFemale: _isFemale,
          onTap: () => _selectBlangkon(opt.type, isLocked),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveSelection,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.amber,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          _isFemale
              ? context.l10n.busanaSaveButton
              : context.l10n.blangkonSaveButton,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─── Grid item ────────────────────────────────────────────────────────────────

class _BlangkonGridItem extends StatelessWidget {
  final _BlangkonOption option;
  final bool isLocked;
  final bool isSelected;
  final bool isFemale;
  final VoidCallback onTap;

  const _BlangkonGridItem({
    required this.option,
    required this.isLocked,
    required this.isSelected,
    required this.isFemale,
    required this.onTap,
  });

  String _getConditionLabel(BuildContext context, BlangkonType type) {
    if (type == BlangkonType.yogyakarta) {
      return context.l10n.blangkonInitialUnlock;
    }
    if (type == BlangkonType.pusaka) return context.l10n.blangkonMasteryAksara;
    final reqLevel = BlangkonRewards.requiredLevels[type] ?? 1;
    return context.l10n.blangkonLevelRequired(reqLevel);
  }

  @override
  Widget build(BuildContext context) {
    final itemSvg = option.type.itemAsset(isFemale: isFemale);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amberSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.amber : AppColors.border,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: itemSvg != null
                          ? ColorFiltered(
                              colorFilter: isLocked
                                  ? const ColorFilter.matrix([
                                      0.33,
                                      0.33,
                                      0.33,
                                      0,
                                      0,
                                      0.33,
                                      0.33,
                                      0.33,
                                      0,
                                      0,
                                      0.33,
                                      0.33,
                                      0.33,
                                      0,
                                      0,
                                      0,
                                      0,
                                      0,
                                      0.5,
                                      0,
                                    ])
                                  : const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.dst,
                                    ),
                              child: SvgPicture.asset(
                                itemSvg,
                                width: 70,
                                height: 55,
                                fit: BoxFit.contain,
                              ),
                            )
                          : CustomPaint(
                              size: const Size(70, 55),
                              painter: BlangkonPainter(
                                type: option.type,
                                isLocked: isLocked,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    option.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isLocked ? const Color(0xFFB0A898) : AppColors.ink,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isLocked) ...[
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F1EB),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        _getConditionLabel(context, option.type),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B6257),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: AppColors.ink,
                  ),
                ),
              ),
            if (isLocked)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B6257).withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
