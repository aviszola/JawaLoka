import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';

/// Quiz question type enum.
enum QuestionType { glyphIdentify, textToAksara }

/// Model for a single quiz question.
class QuizQuestion {
  final QuestionType type;
  final String prompt; // e.g. "Aksara apa ini?" or aksara character
  final String glyph; // Javanese character displayed
  final List<String> options; // For MCQ
  final int correctIndex;

  const QuizQuestion({
    required this.type,
    required this.prompt,
    required this.glyph,
    required this.options,
    required this.correctIndex,
  });
}

/// Full-screen quiz experience with animations.
class QuizQuestionScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String moduleTitle;
  final VoidCallback? onComplete;

  static const List<QuizQuestion> defaultQuestions = [
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara apa ini?',
      glyph: 'ꦲ',
      options: ['Ha', 'Na', 'Ca', 'Ra'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Pilih pelafalan untuk aksara berikut:',
      glyph: 'ꦤ',
      options: ['Ka', 'Da', 'Na', 'Ta'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara "ꦕ" dibaca sebagai apa?',
      glyph: 'ꦕ',
      options: ['Sa', 'Wa', 'La', 'Ca'],
      correctIndex: 3,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Manakah pelafalan untuk aksara di bawah?',
      glyph: 'ꦫ',
      options: ['Ra', 'Pa', 'Dha', 'Ja'],
      correctIndex: 0,
    ),
  ];

  const QuizQuestionScreen({
    super.key,
    this.questions = defaultQuestions,
    this.moduleTitle = 'Aksara Dhasar',
    this.onComplete,
  });

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _selectedOption = -1;
  bool _answered = false;
  bool _isCorrect = false;
  int _score = 0;
  int _streak = 0;

  late final AnimationController _progressController;
  late final Animation<double> _progressAnim;

  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnim;

  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  late final AnimationController _confettiController;
  late final List<_ConfettiParticle> _confettiParticles;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1 / widget.questions.length)
        .animate(CurvedAnimation(
            parent: _progressController, curve: Curves.easeOut));
    _progressController.forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: Offset.zero, end: const Offset(-0.04, 0)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(
              begin: const Offset(-0.04, 0), end: const Offset(0.04, 0)),
          weight: 2),
      TweenSequenceItem(
          tween: Tween(
              begin: const Offset(0.04, 0), end: const Offset(-0.04, 0)),
          weight: 2),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(-0.04, 0), end: Offset.zero),
          weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _bounceController, curve: Curves.easeOut));

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

  QuizQuestion get _current => widget.questions[_currentIndex];

  double get _progressTarget =>
      (_currentIndex + (_answered ? 1 : 0)) / widget.questions.length;

  void _selectOption(int index) {
    if (_answered) return;
    final correct = index == _current.correctIndex;

    setState(() {
      _selectedOption = index;
      _answered = true;
      _isCorrect = correct;
      if (correct) {
        _score++;
        _streak++;
      } else {
        _streak = 0;
      }
    });

    _animateProgressTo(_progressTarget);

    if (correct) {
      _bounceController.forward(from: 0);
      if (_streak >= 3) {
        _confettiController.forward(from: 0);
      }
    } else {
      _shakeController.forward(from: 0);
    }
  }

  void _animateProgressTo(double target) {
    final old = _progressAnim.value;
    _progressController.duration = const Duration(milliseconds: 600);
    // Replace animation with new range
    final tween = Tween<double>(begin: old, end: target);
    _progressController.reset();
    _progressAnim.addListener(() {}); // keep ref
    // Use a simple approach: drive via controller value directly
    // We'll re-run the animation
  }

  void _onConfirm() {
    if (!_answered) return;
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = -1;
        _answered = false;
        _isCorrect = false;
      });
      _animateProgressTo(_progressTarget);
    } else {
      widget.onComplete?.call();
      Navigator.of(context).pushReplacementNamed(AppRouter.quizResult);
    }
  }

  void _skip() {
    if (_answered) return;
    setState(() {
      _selectedOption = -1;
      _answered = false;
    });
    _onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
            if (_confettiController.isAnimating || _confettiController.value > 0)
              Positioned.fill(
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded, color: AppColors.ink, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildProgressBar()),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _skip,
                child: const Text(
                  'Lewati',
                  style: TextStyle(
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
                  fontSize: 13,
                  color: Color(0xFF7A6E60),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_streak >= 3) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4A0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 2),
                      Text(
                        'Streak $_streak!',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amberDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
        final value = (_currentIndex + (_answered ? 1 : 0)) / widget.questions.length;
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
                color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Text(
              _current.prompt,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7A6E60),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              _current.glyph,
              style: const TextStyle(
                fontSize: 96,
                fontFamily: 'NotoSansJavanese',
                color: AppColors.ink,
              ),
            ),
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

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE8E1D6);
    Color textColor = AppColors.ink;
    Widget? trailingIcon;

    if (isCorrect) {
      bgColor = const Color(0xFFDCEBD2);
      borderColor = const Color(0xFF3E9B5F);
      textColor = const Color(0xFF2A6E40);
      trailingIcon =
          const Icon(Icons.check_circle_rounded, color: Color(0xFF3E9B5F));
    } else if (isWrong) {
      bgColor = const Color(0xFFFFEAEA);
      borderColor = const Color(0xFFD64545);
      textColor = const Color(0xFFD64545);
      trailingIcon =
          const Icon(Icons.cancel_rounded, color: Color(0xFFD64545));
    } else if (isSelected) {
      bgColor = AppColors.amberSoft;
      borderColor = AppColors.amber;
    }

    Widget button = GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isCorrect || isWrong ? 2 : 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
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
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );

    if (isWrong) {
      return SlideTransition(
        position: _shakeAnim,
        child: button,
      );
    }
    return button;
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: _answered
            ? (_isCorrect
                ? const Color(0xFFDCEBD2)
                : const Color(0xFFFFEAEA))
            : const Color(0xFFF5F1EB),
        border: Border(
          top: BorderSide(
            color: _answered
                ? (_isCorrect
                    ? const Color(0xFF3E9B5F)
                    : const Color(0xFFD64545))
                : const Color(0xFFE8E1D6),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_answered) ...[
            Row(
              children: [
                Text(
                  _isCorrect ? '✅ Betul!' : '❌ Kurang tepat',
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
                'Jawaban: ${_current.options[_current.correctIndex]}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFD64545),
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
                        ? 'Lanjut →'
                        : 'Selesai ✓')
                    : 'Periksa',
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

  const _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final x = (p.x + p.speedX * progress) * size.width;
      final y = (p.y + p.speedY * progress) * size.height;
      final rotation = p.rotation + p.rotationSpeed * progress * pi * 4;
      final opacity = (1 - progress * 0.8).clamp(0.0, 1.0);

      paint.color = p.color.withOpacity(opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
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

// ---------------------------------------------------------------------------
// Demo entry point (sample data)
// ---------------------------------------------------------------------------
class DemoQuizQuestionScreen extends StatelessWidget {
  const DemoQuizQuestionScreen({super.key});

  static const _sampleQuestions = [
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara apa ini?',
      glyph: 'ꦲ',
      options: ['Ha', 'Na', 'Ca', 'Ra'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara apa ini?',
      glyph: 'ꦤ',
      options: ['Ka', 'Na', 'Da', 'Ta'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara apa ini?',
      glyph: 'ꦫ',
      options: ['Sa', 'Wa', 'Ra', 'La'],
      correctIndex: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return QuizQuestionScreen(
      questions: _sampleQuestions,
      moduleTitle: 'Aksara Jawa Dasar',
    );
  }
}
