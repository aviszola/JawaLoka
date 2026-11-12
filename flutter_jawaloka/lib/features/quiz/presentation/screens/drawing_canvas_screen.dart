import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/progression/reward_summary.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../../domain/quest_target.dart';
import '../../domain/stroke_similarity_evaluator.dart';
import '../widgets/drawing_canvas_painter.dart';
import 'daily_result_screen.dart';

// ─────────────────────────────────────────────────────────
//  STROKE WIDTH OPTION
// ─────────────────────────────────────────────────────────

enum _StrokeSize { thin, medium, thick }

extension _StrokeSizeExt on _StrokeSize {
  double get width {
    switch (this) {
      case _StrokeSize.thin:
        return 2.5;
      case _StrokeSize.medium:
        return 4.5;
      case _StrokeSize.thick:
        return 7.0;
    }
  }

  double get indicatorSize {
    switch (this) {
      case _StrokeSize.thin:
        return 6;
      case _StrokeSize.medium:
        return 10;
      case _StrokeSize.thick:
        return 15;
    }
  }
}

// ─────────────────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────────────────

class DrawingCanvasScreen extends StatefulWidget {
  final String aksaraChar;
  final String aksaraName;

  const DrawingCanvasScreen({
    super.key,
    this.aksaraChar = 'ꦲ',
    this.aksaraName = 'Ha',
  });

  @override
  State<DrawingCanvasScreen> createState() => _DrawingCanvasScreenState();
}

class _DrawingCanvasScreenState extends State<DrawingCanvasScreen> {
  /// Target aksara aktif dari sumber tunggal [QuestTarget].
  late QuestTarget _activeTarget;

  /// All completed strokes
  final List<List<Offset>> _strokes = [];

  /// Points in the current (in-progress) stroke
  List<Offset> _currentStroke = [];

  bool _isEvaluating = false;
  _StrokeSize _selectedSize = _StrokeSize.medium;

  @override
  void initState() {
    super.initState();
    _activeTarget = QuestTarget.byChar(widget.aksaraChar);
  }
  List<List<Offset>> get _allStrokes => [
    ..._strokes,
    if (_currentStroke.isNotEmpty) _currentStroke,
  ];

  // ── Gesture handlers ───────────────────────────────────

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke = [..._currentStroke, details.localPosition];
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (_currentStroke.isEmpty) return;
    setState(() {
      _strokes.add(List.unmodifiable(_currentStroke));
      _currentStroke = [];
    });
  }

  void _clearAll() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
  }

  void _undoLastStroke() {
    if (_strokes.isEmpty) return;
    setState(() {
      _strokes.removeLast();
    });
  }

  void _selectTarget(QuestTarget target) {
    if (_activeTarget.aksaraChar != target.aksaraChar) {
      setState(() {
        _activeTarget = target;
        _strokes.clear();
        _currentStroke = [];
      });
    }
    Navigator.of(context).pop();
  }

  void _showAksaraPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final l10n = ctx.l10n;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.drawingPickerTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.drawingPickerSubtitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: QuestTarget.hanacarakaAll.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (_, index) {
                    final target = QuestTarget.hanacarakaAll[index];
                    final isSelected =
                        _activeTarget.aksaraChar == target.aksaraChar;

                    return GestureDetector(
                      key: Key('aksara_picker_item_${target.aksaraName}'),
                      onTap: () => _selectTarget(target),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.amberSoft
                              : AppColors.canvas,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.amberDark
                                : AppColors.border,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                target.aksaraChar,
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontFamily: 'NotoSansJavanese',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                target.aksaraName,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.amberDark
                                      : AppColors.inkSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant DrawingCanvasScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.aksaraChar != widget.aksaraChar ||
        oldWidget.aksaraName != widget.aksaraName) {
      _activeTarget = QuestTarget.byChar(widget.aksaraChar);
      _clearAll();
    }
  }

  // ── UI ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompactHeight = constraints.maxHeight < 540;

            if (!isCompactHeight) {
              // Standard mobile viewport: non-scrolling fixed canvas layout
              // Drawing gestures never conflict with vertical scrolling.
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 12),
                    Expanded(child: Center(child: _buildCanvasCard())),
                    const SizedBox(height: 12),
                    _buildControlsRow(),
                    const SizedBox(height: 14),
                    _buildCheckButton(context),
                  ],
                ),
              );
            }

            // Fallback for extreme low-height or landscape viewports
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 12),
                  _buildCanvasCard(),
                  const SizedBox(height: 12),
                  _buildControlsRow(),
                  const SizedBox(height: 14),
                  _buildCheckButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.canvas,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Semantics(
        label: context.l10n.drawingBackSemantics,
        button: true,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              AppIcons.back,
              size: 18,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
      title: Text(
        context.l10n.drawingTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.amberSoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _activeTarget.aksaraName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.amberDark,
            ),
          ),
        ),
      ],
    );
  }

  // ── Info Card ──────────────────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            _activeTarget.aksaraChar,
            key: const Key('quest_header_aksara_glyph'),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.amberDark,
              fontFamily: 'NotoSansJavanese',
              height: 1.1,
            ),
          ),
          Container(
            width: 1.5,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: AppColors.border,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _activeTarget.aksaraName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  context.l10n.drawingInstruction,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            key: const Key('open_aksara_picker_button'),
            onTap: _showAksaraPicker,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.amberSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    AppIcons.chooseScript,
                    size: 15,
                    color: AppColors.amberDark,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.drawingChooseAksaraButton,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.amberDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Canvas Card ────────────────────────────────────────

  Widget _buildCanvasCard() {
    return AspectRatio(
      aspectRatio: 1.15,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Painting area
              RepaintBoundary(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: AnimatedBuilder(
                    animation: const AlwaysStoppedAnimation(0),
                    // triggers rebuild on setState
                    builder: (context, _) => CustomPaint(
                      painter: DrawingCanvasPainter(
                        strokes: _allStrokes,
                        strokeWidth: _selectedSize.width,
                        targetAksara: _activeTarget.aksaraChar,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),

              // Stroke counter overlay
              Positioned(
                top: 12,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.canvas.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    context.l10n.drawingStrokeCount(_strokes.length),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Controls Row ───────────────────────────────────────

  Widget _buildControlsRow() {
    return Row(
      children: [
        // Hapus semua
        Expanded(
          child: Semantics(
            label: context.l10n.drawingClearAll,
            button: true,
            child: OutlinedButton.icon(
              onPressed: _strokes.isEmpty ? null : _clearAll,
              icon: const Icon(AppIcons.delete, size: 18),
              label: Text(context.l10n.drawingClearAll),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                disabledForegroundColor: AppColors.inkMuted,
                side: BorderSide(
                  color: _strokes.isEmpty ? AppColors.border : AppColors.error,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Batalkan goresan
        Expanded(
          child: Semantics(
            label: context.l10n.drawingUndo,
            button: true,
            child: OutlinedButton.icon(
              onPressed: _strokes.isEmpty ? null : _undoLastStroke,
              icon: const Icon(AppIcons.undo, size: 18),
              label: Text(context.l10n.drawingUndo),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.inkSecondary,
                disabledForegroundColor: AppColors.inkMuted,
                side: BorderSide(
                  color: _strokes.isEmpty
                      ? AppColors.border
                      : AppColors.inkSecondary,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Stroke width selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _StrokeSize.values.map((size) {
              final isSelected = _selectedSize == size;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 48,
                  ),
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.amber : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: size.indicatorSize,
                        height: size.indicatorSize,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.ink
                              : AppColors.inkMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _onCheckDrawing() async {
    if (_isEvaluating) return;

    final validation = Validators.validateQuestStrokes(_strokes);
    if (validation.isInvalid) {
      final err =
          (validation as Invalid<List<List<Offset>>, QuestDrawingError>).error;
      final msg = ValidationMessages.questDrawingError(context.l10n, err);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final profile = ProfileScope.maybeOf(context);
    final userName = profile?.displayName ?? 'Dimas';
    setState(() => _isEvaluating = true);

    try {
      final similarity = await StrokeSimilarityEvaluator.evaluateWithFontMask(
        strokes: _strokes,
        targetAksara: _activeTarget.aksaraChar,
      );

      RewardSummary? summary;

      if (profile != null) {
        final activityId = 'drawing_${_activeTarget.aksaraChar}';
        final claimId =
            'draw_${_activeTarget.aksaraChar}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
        summary = await profile.awardDrawingChallengeReward(
          activityId: activityId,
          claimId: claimId,
          similarity: similarity,
        );
      }

      if (!mounted) return;

      final result = await Navigator.pushNamed(
        context,
        AppRouter.dailyResult,
        arguments: DailyResultArgs(
          similarity: similarity,
          userStrokes: _strokes.map((s) => List<Offset>.from(s)).toList(),
          targetAksara: _activeTarget.aksaraChar,
          userName: userName,
          rewardSummary: summary,
        ),
      );

      if (result == true && mounted) {
        _clearAll();
      }
    } finally {
      if (mounted) {
        setState(() => _isEvaluating = false);
      }
    }
  }

  // ── Check Button ───────────────────────────────────────

  Widget _buildCheckButton(BuildContext context) {
    final hasStrokes = _strokes.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (hasStrokes && !_isEvaluating) ? _onCheckDrawing : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.amber,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.inkMuted,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: _isEvaluating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.amber),
                ),
              )
            : Text(
                context.l10n.drawingCheckButton,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.amber),
              ),
      ),
    );
  }
}
