import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';

/// Modal bottom sheet shown before starting a quiz module.
class QuizBottomSheet extends StatefulWidget {
  final String moduleTitle;
  final int questionCount;
  final int estimatedMinutes;
  final int xpReward;
  final VoidCallback onStart;
  final VoidCallback? onRestart;

  const QuizBottomSheet({
    super.key,
    required this.moduleTitle,
    required this.questionCount,
    required this.estimatedMinutes,
    required this.xpReward,
    required this.onStart,
    this.onRestart,
  });

  /// Convenience method to show the bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String moduleTitle,
    required int questionCount,
    required int estimatedMinutes,
    required int xpReward,
    required VoidCallback onStart,
    VoidCallback? onRestart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuizBottomSheet(
        moduleTitle: moduleTitle,
        questionCount: questionCount,
        estimatedMinutes: estimatedMinutes,
        xpReward: xpReward,
        onStart: onStart,
        onRestart: onRestart,
      ),
    );
  }

  @override
  State<QuizBottomSheet> createState() => _QuizBottomSheetState();
}

class _QuizBottomSheetState extends State<QuizBottomSheet>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  int _selectedDifficulty = 0; // 0=Mudah, 1=Sedang, 2=Susah
  int _currentGlyphIndex = 0;

  static const _glyphs = ['ꦲ', 'ꦤ', 'ꦕ'];
  static const _difficulties = ['Mudah', 'Sedang', 'Susah'];

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentGlyphIndex = (_currentGlyphIndex + 1) % _glyphs.length;
          });
          _rotateController.forward(from: 0);
        }
      });
    _rotateController.forward();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDF9F3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 16),
          _buildGlyphPreview(),
          const SizedBox(height: 20),
          _buildModuleTitle(),
          const SizedBox(height: 16),
          _buildDifficultyChips(),
          const SizedBox(height: 20),
          _buildStatsRow(),
          const SizedBox(height: 28),
          _buildStartButton(),
          const SizedBox(height: 12),
          if (widget.onRestart != null) _buildRestartButton(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFD4CAB8),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildGlyphPreview() {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnim, _rotateController]),
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _bounceAnim.value),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [AppColors.amberSoft, Color(0xFFFFF1D0)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Text(
                _glyphs[_currentGlyphIndex],
                key: ValueKey(_currentGlyphIndex),
                style: const TextStyle(
                  fontSize: 48,
                  fontFamily: 'NotoSansJavanese',
                  color: AppColors.amberDark,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModuleTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            widget.moduleTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Latih kemampuanmu sekarang!',
            style: TextStyle(fontSize: 14, color: Color(0xFF7A6E60)),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_difficulties.length, (i) {
          final selected = i == _selectedDifficulty;
          return GestureDetector(
            onTap: () => setState(() => _selectedDifficulty = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.amber : const Color(0xFFF5F1EB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.amberDark : const Color(0xFFE8E1D6),
                ),
              ),
              child: Text(
                _difficulties[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.ink : const Color(0xFF7A6E60),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E1D6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('📋', '${widget.questionCount}', 'Soal'),
          _divider(),
          _statItem('⏱', '~${widget.estimatedMinutes}', 'Menit'),
          _divider(),
          _statItem('⭐', '+${widget.xpReward}', 'XP'),
        ],
      ),
    );
  }

  Widget _statItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF7A6E60)),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: const Color(0xFFE8E1D6));
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onStart();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.amber,
            foregroundColor: AppColors.ink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Mulai Kuis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _buildRestartButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        widget.onRestart?.call();
      },
      child: const Text(
        'Ulangi dari awal',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF7A6E60),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
