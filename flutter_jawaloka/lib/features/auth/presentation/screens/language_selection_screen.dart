/*  */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Language Selection Screen.
/// First screen shown after splash — user selects their UI language.
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  String _selectedLang = 'id'; // Default: Bahasa Indonesia

  late final AnimationController _entranceController;
  late final Map<String, AnimationController> _cardControllers;

  final List<_LanguageOption> _options = const [
    _LanguageOption(
      code: 'jw',
      name: 'Basa Jawa',
      sub: 'Javanese',
      avatar: 'ꦗ',
      avatarBg: AppColors.pastelSand,
      avatarBorder: Color(0xFFE4D7C0),
    ),
    _LanguageOption(
      code: 'id',
      name: 'Bahasa Indonesia',
      sub: 'Default',
      avatar: 'ID',
      avatarBg: Color(0xFFFFE3A6),
      avatarBorder: Color(0xFFF5CD78),
      isJavaneseGlyph: false,
    ),
    _LanguageOption(
      code: 'en',
      name: 'English',
      sub: 'For learners worldwide',
      avatar: 'EN',
      avatarBg: AppColors.pastelLavender,
      avatarBorder: Color(0xFFCEC6EE),
      isJavaneseGlyph: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _cardControllers = {
      for (var opt in _options)
        opt.code: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 180),
        ),
    };
  }

  @override
  void dispose() {
    _entranceController.dispose();
    for (final c in _cardControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectLanguage(String code) {
    if (_selectedLang == code) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedLang = code);
    // BELUM TERHUBUNG KE LOKALISASI: pilihan bahasa belum disimpan ke persistent storage / belum mengubah locale app
    _cardControllers[code]?.forward(from: 0.0);
  }

  void _proceed() {
    HapticFeedback.mediumImpact();
    // BELUM TERHUBUNG KE LOKALISASI: preferensi bahasa (_selectedLang) belum disimpan ke shared_preferences
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _entranceController,
          builder: (context, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Jarak atas wajar di bawah area aman (tanpa elemen ikon matahari dekoratif)
                        const SizedBox(height: 32),

                        // Judul & Subjudul
                        FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _entranceController,
                              curve: const Interval(0.0, 0.6),
                            ),
                          ),
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _entranceController,
                                    curve: const Interval(
                                      0.0,
                                      0.6,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.selectLanguageTitle,
                                  style: theme.textTheme.displayMedium
                                      ?.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                        letterSpacing: -0.5,
                                        height: 1.2,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppStrings.selectLanguageSubtitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    color: AppColors.inkSecondary,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Kartu Pilihan Bahasa
                        ..._options.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final opt = entry.value;
                          final isSelected = _selectedLang == opt.code;

                          return SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: Offset(0, 0.3 + idx * 0.1),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _entranceController,
                                    curve: Interval(
                                      0.15 + idx * 0.1,
                                      0.65 + idx * 0.1,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: FadeTransition(
                              opacity: Tween<double>(begin: 0, end: 1).animate(
                                CurvedAnimation(
                                  parent: _entranceController,
                                  curve: Interval(
                                    0.15 + idx * 0.1,
                                    0.6 + idx * 0.1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _LanguageCard(
                                  option: opt,
                                  isSelected: isSelected,
                                  onTap: () => _selectLanguage(opt.code),
                                ),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 8),

                        // Teks bantuan
                        FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _entranceController,
                              curve: const Interval(0.5, 1.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              AppStrings.selectLanguageHint,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                color: AppColors.inkSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol Aksi Bawah dengan SafeArea alami (tanpa home indicator tiruan)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: PrimaryButton(
                      label: AppStrings.continueButton,
                      onPressed: _proceed,
                      trailingIcon: Icons.arrow_forward_rounded,
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

/// Kartu pilihan bahasa individual dengan semantik aksesibilitas
class _LanguageCard extends StatefulWidget {
  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: Key('lang_semantics_${widget.option.code}'),
      label: widget.option.name,
      button: true,
      inMutuallyExclusiveGroup: true,
      checked: widget.isSelected,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: 76, // Tinggi minimal >= 72 dp
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.amberSoft
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected ? AppColors.amber : AppColors.border,
                width: widget.isSelected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected
                      ? AppColors.amber.withValues(alpha: 0.15)
                      : AppColors.ink.withValues(alpha: 0.04),
                  blurRadius: widget.isSelected ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Avatar badge bahasa
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.option.avatarBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.option.avatarBorder),
                  ),
                  child: Center(
                    child: Text(
                      widget.option.avatar,
                      style: TextStyle(
                        fontSize: widget.option.isJavaneseGlyph ? 22 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Nama + Subjudul
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.option.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: widget.isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.option.sub,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.inkSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppColors.amber
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isSelected
                          ? AppColors.amber
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: widget.isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.ink,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Model data opsi bahasa
class _LanguageOption {
  final String code;
  final String name;
  final String sub;
  final String avatar;
  final Color avatarBg;
  final Color avatarBorder;
  final bool isJavaneseGlyph;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.sub,
    required this.avatar,
    required this.avatarBg,
    required this.avatarBorder,
    this.isJavaneseGlyph = true,
  });
}
