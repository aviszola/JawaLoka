import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/primary_button.dart';

/// JawaLoka Language Selection Screen.
/// First screen shown after splash — user picks their UI language.
/// Design: Google Stitch Project #17251431980647989546, Screen #1f081e9b56724b8ab9aa389ab7b7bc1e
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
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
      duration: const Duration(milliseconds: 700),
    )..forward();

    _cardControllers = {
      for (var opt in _options)
        opt.code: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )
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
    _cardControllers[code]?.forward(from: 0.0);
  }

  void _proceed() {
    HapticFeedback.mediumImpact();
    // Navigate to Register screen
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _entranceController,
          builder: (context, _) {
            return Column(
              children: [
                // Status bar spacer
                const SizedBox(height: 8),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Sun icon badge
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -0.5),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _entranceController,
                            curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
                          )),
                          child: FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _entranceController,
                                curve: const Interval(0.0, 0.5),
                              ),
                            ),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.amberSoft,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFFFE7B3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.amber.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.wb_sunny_outlined,
                                color: AppColors.amberDark,
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title & trilingual subtitle
                        FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _entranceController,
                              curve: const Interval(0.15, 0.65),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _entranceController,
                              curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pilih bahasa',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Pilih basa · Pilih bahasa · Choose language',
                                  style: TextStyle(
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

                        // Language Option Cards
                        ..._options.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final opt = entry.value;
                          final isSelected = _selectedLang == opt.code;

                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.4 + idx * 0.15),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _entranceController,
                              curve: Interval(
                                0.25 + idx * 0.1,
                                0.75 + idx * 0.1,
                                curve: Curves.easeOutCubic,
                              ),
                            )),
                            child: FadeTransition(
                              opacity: Tween<double>(begin: 0, end: 1).animate(
                                CurvedAnimation(
                                  parent: _entranceController,
                                  curve: Interval(0.25 + idx * 0.1, 0.7 + idx * 0.1),
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

                        // Helper text
                        FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _entranceController,
                              curve: const Interval(0.6, 1.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Kamu bisa menggantinya kapan saja di Pengaturan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
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

                // Bottom Action
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Column(
                    children: [
                      PrimaryButton(
                        label: 'Lanjut',
                        onPressed: _proceed,
                        trailingIcon: Icons.arrow_forward_rounded,
                      ),
                      const SizedBox(height: 8),
                      // Android gesture bar
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
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Individual language option card
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
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 76,
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.amberSoft : AppColors.surface,
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
              // Avatar circle
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
              // Name + subtitle
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
                  color: widget.isSelected ? AppColors.amber : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected ? AppColors.amber : AppColors.border,
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
    );
  }
}

/// Language option data model
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

