import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/progression/reward_summary.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/quiz_session.dart';

export '../../domain/models/quiz_question.dart';

/// Extension for resolving localized prompts for [QuizQuestion] within the presentation layer.
extension QuizQuestionPresentationX on QuizQuestion {
  String getPrompt(BuildContext context) {
    if (prompt.isNotEmpty) {
      return prompt;
    }
    switch (promptKey) {
      case 'what_glyph':
        return context.l10n.quizQuestionPromptWhatGlyph;
      case 'pronunciation':
        return context.l10n.quizQuestionPromptPronunciation;
      case 'how_to_read':
        return context.l10n.quizQuestionPromptHowToRead(glyph);
      case 'which_pronunciation':
        return context.l10n.quizQuestionPromptWhichPronunciation;
      default:
        return context.l10n.quizQuestionPromptWhatGlyph;
    }
  }
}

/// Arguments passed when launching [QuizQuestionScreen].
class QuizQuestionArgs {
  final List<QuizQuestion>? questions;
  final String moduleTitle;
  final VoidCallback? onComplete;
  final int? userLevel;
  final String? activityId;
  final bool isEvaluation;

  const QuizQuestionArgs({
    this.questions,
    this.moduleTitle = 'Aksara Dhasar',
    this.onComplete,
    this.userLevel,
    this.activityId,
    this.isEvaluation = false,
  });
}

/// Full-screen quiz experience with animations.
class QuizQuestionScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String moduleTitle;
  final VoidCallback? onComplete;
  final String? activityId;
  final bool isEvaluation;

  /// Jumlah soal per sesi kuis aksara.
  static const int totalQuestionsPerSession = 10;

  /// Kumpulan soal bawaan untuk sesi aksara.
  static const List<QuizQuestion> defaultQuestions = QuizQuestion.defaultQuestions;

  const QuizQuestionScreen({
    super.key,
    this.questions = defaultQuestions,
    this.moduleTitle = 'Aksara Dhasar',
    this.onComplete,
    this.activityId,
    this.isEvaluation = false,
  });

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with TickerProviderStateMixin {
  late QuizSession _session;

  late final AnimationController _progressController;

  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnim;

  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  late final AnimationController _confettiController;
  late final List<_ConfettiParticle> _confettiParticles;

  @override
  void initState() {
    super.initState();

    _session = QuizSession(
      questions: widget.questions,
      moduleTitle: widget.moduleTitle,
      activityId: widget.activityId,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-0.04, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.04, 0), end: const Offset(0.04, 0)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.04, 0), end: const Offset(-0.04, 0)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.04, 0), end: Offset.zero),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnim =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
        );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    final rng = Random();
    _confettiParticles = List.generate(
      40,
      (_) => _ConfettiParticle(
        x: rng.nextDouble(),
        y: -rng.nextDouble() * 0.2,
        color: [
          AppColors.amber,
          AppColors.amberDark,
          const Color(0xFF3E9B5F),
          const Color(0xFFDDD7F6),
          Colors.white,
        ][rng.nextInt(5)],
        size: 6 + rng.nextDouble() * 6,
        speedX: (rng.nextDouble() - 0.5) * 0.6,
        speedY: 0.4 + rng.nextDouble() * 0.5,
        rotation: rng.nextDouble() * pi * 2,
        rotationSpeed: (rng.nextDouble() - 0.5) * 0.3,
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _shakeController.dispose();
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuizQuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questions != widget.questions ||
        oldWidget.moduleTitle != widget.moduleTitle ||
        oldWidget.activityId != widget.activityId) {
      setState(() {
        _session = QuizSession(
          questions: widget.questions,
          moduleTitle: widget.moduleTitle,
          activityId: widget.activityId,
        );
      });
      _animateProgressTo(0.0);
    }
  }

  /// Completely resets the active quiz session and progress bar.
  void resetSession() {
    setState(() {
      _session.reset();
    });
    _animateProgressTo(0.0);
  }

  QuizQuestion get _current =>
      _session.currentQuestion ?? widget.questions.first;

  int get _currentIndex => _session.currentIndex;
  int get _selectedOption => _session.selectedOption;
  bool get _answered => _session.answered;
  bool get _isCorrect => _session.isCorrect;

  void _selectOption(int index) {
    if (_session.answered || _session.isCompleted) return;

    setState(() {
      _session.answer(index);
    });

    _animateProgressTo(_session.progress);

    if (_session.isCorrect) {
      _bounceController.forward(from: 0);
    } else {
      _shakeController.forward(from: 0);
    }
  }

  void _animateProgressTo(double target) {
    _progressController.duration = const Duration(milliseconds: 600);
    _progressController.animateTo(target, curve: Curves.easeOut);
  }

  void _onConfirm() {
    if (!_session.answered) return;
    if (_session.currentIndex < widget.questions.length - 1) {
      setState(() {
        _session.nextQuestion();
      });
      _animateProgressTo(_session.progress);
    } else {
      _completeQuiz();
    }
  }

  void _skip() {
    if (_session.answered) return;
    if (_session.currentIndex < widget.questions.length - 1) {
      setState(() {
        _session.skip();
      });
      _animateProgressTo(_session.progress);
    } else {
      _completeQuiz();
    }
  }

  Future<void> _completeQuiz() async {
    widget.onComplete?.call();
    RewardSummary? summary;
    final profile = ProfileScope.maybeOf(context);
    if (profile != null) {
      summary = await profile.awardQuizSessionReward(
        activityId: _session.activityId,
        claimId: _session.sessionId,
        correctAnswers: _session.correctCount,
        isPerfect: _session.correctCount == _session.totalQuestions,
        scorePercentage: _session.scorePercentage,
        isEvaluation: widget.isEvaluation,
      );
    }
    final result = _session.toResult(
      rewardSummary: summary,
      isEvaluation: widget.isEvaluation,
    );
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacementNamed(AppRouter.quizResult, arguments: result);
  }

  Future<void> _onClosePressed() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.quizExitDialogTitle),
        content: Text(dialogContext.l10n.quizExitDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.quizExitDialogCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(dialogContext.l10n.quizExitDialogConfirm),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _onClosePressed();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F1EB),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildQuestionCard(),
                          const SizedBox(height: 24),
                          _buildOptions(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom confirm/next button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(),
              ),
              // Confetti overlay
              if (_confettiController.isAnimating ||
                  _confettiController.value > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _confettiController,
                      builder: (context, _) => CustomPaint(
                        painter: _ConfettiPainter(
                          particles: _confettiParticles,
                          progress: _confettiController.value,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        children: [
          Row(
            children: [
              Semantics(
                label: context.l10n.quizCloseSemantics,
                button: true,
                child: GestureDetector(
                  onTap: _onClosePressed,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.ink,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildProgressBar()),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _skip,
                child: Text(
                  context.l10n.quizSkip,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A6E60),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 36),
              Text(
                '${_currentIndex + 1}/${widget.questions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A6E60),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, _) {
        final value =
            (_currentIndex + (_answered ? 1 : 0)) / widget.questions.length;
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: const Color(0xFFE8E1D6),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard() {
    return AnimatedBuilder(
      animation: _bounceAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _answered && _isCorrect ? _bounceAnim.value : 1.0,
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE8E1D6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              _current.getPrompt(context),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7A6E60),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (_current.glyph.isNotEmpty) ...[
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _current.glyph,
                  style: const TextStyle(
                    fontSize: 72,
                    fontFamily: 'NotoSansJavanese',
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(_current.options.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOptionButton(i),
        );
      }),
    );
  }

  Widget _buildOptionButton(int index) {
    final isSelected = _selectedOption == index;
    final isCorrect = _answered && index == _current.correctIndex;
    final isWrong = _answered && isSelected && !_isCorrect;

    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.ink;
    Widget? trailingIcon;

    if (isCorrect) {
      bgColor = AppColors.successLight;
      borderColor = AppColors.success;
      textColor = AppColors.successText;
      trailingIcon = const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success,
      );
    } else if (isWrong) {
      bgColor = AppColors.errorLight;
      borderColor = AppColors.error;
      textColor = AppColors.error;
      trailingIcon = const Icon(Icons.cancel_rounded, color: AppColors.error);
    } else if (isSelected) {
      bgColor = AppColors.amberSoft;
      borderColor = AppColors.amber;
    }

    Widget button = Semantics(
      label: context.l10n.quizOptionSemantics(
        String.fromCharCode(65 + index),
        _current.options[index],
      ),
      button: true,
      selected: isSelected,
      child: GestureDetector(
        key: Key('quiz_option_$index'),
        behavior: HitTestBehavior.opaque,
        onTap: () => _selectOption(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isCorrect || isWrong ? 2 : 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.amberDark.withValues(alpha: 0.15)
                      : const Color(0xFFF0EAE1),
                ),
                alignment: Alignment.center,
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.amberDark
                        : const Color(0xFF7A6E60),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _current.options[index],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              ?trailingIcon,
            ],
          ),
        ),
      ),
    );

    if (isWrong) {
      return SlideTransition(position: _shakeAnim, child: button);
    }
    return button;
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: _answered
            ? (_isCorrect ? const Color(0xFFDCEBD2) : const Color(0xFFFFEAEA))
            : const Color(0xFFF5F1EB),
        border: const Border(top: BorderSide(color: Color(0xFFE8E1D6))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_answered) ...[
            Row(
              children: [
                Text(
                  _isCorrect
                      ? context.l10n.quizCorrect
                      : context.l10n.quizIncorrect,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _isCorrect
                        ? const Color(0xFF2A6E40)
                        : const Color(0xFFD64545),
                  ),
                ),
              ],
            ),
            if (!_isCorrect) ...[
              const SizedBox(height: 2),
              Text(
                context.l10n.quizAnswerLabel(
                  _current.options[_current.correctIndex],
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFFD64545)),
              ),
            ],
            if (_current.explanation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                _current.explanation,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _isCorrect
                      ? const Color(0xFF205530)
                      : const Color(0xFF8B2020),
                ),
              ),
              const SizedBox(height: 4),
              // ATRIBUSI SUMBER BELUM DIVERIFIKASI, jangan tampilkan ke pengguna
              Text(
                context.l10n.quizQuestionSourceAttribution,
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: _isCorrect
                      ? const Color(0xFF205530).withValues(alpha: 0.8)
                      : const Color(0xFF8B2020).withValues(alpha: 0.8),
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _answered ? _onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _answered
                    ? (_isCorrect ? const Color(0xFF3E9B5F) : AppColors.amber)
                    : const Color(0xFFD4CAB8),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFD4CAB8),
                disabledForegroundColor: const Color(0xFFA09688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: Text(
                _answered
                    ? (_currentIndex < widget.questions.length - 1
                          ? context.l10n.quizContinue
                          : context.l10n.quizFinish)
                    : context.l10n.quizCheck,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Confetti particle system
// ---------------------------------------------------------------------------

class _ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speedX;
  final double speedY;
  final double rotation;
  final double rotationSpeed;

  const _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final x = (p.x + p.speedX * progress) * size.width;
      final y = (p.y + p.speedY * progress) * size.height;
      final rotation = p.rotation + p.rotationSpeed * progress * pi * 4;
      final opacity = (1 - progress * 0.8).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
