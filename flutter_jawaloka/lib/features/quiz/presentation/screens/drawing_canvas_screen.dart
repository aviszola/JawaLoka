import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/profile/profile_scope.dart';
import '../../../../core/progression/reward_summary.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
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
  /// All completed strokes
  final List<List<Offset>> _strokes = [];

  /// Points in the current (in-progress) stroke
  List<Offset> _currentStroke = [];

  _StrokeSize _selectedSize = _StrokeSize.medium;

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

  @override
  void didUpdateWidget(covariant DrawingCanvasScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.aksaraChar != widget.aksaraChar ||
        oldWidget.aksaraName != widget.aksaraName) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 16),
              _buildCanvasCard(),
              const SizedBox(height: 14),
              _buildControlsRow(),
              const SizedBox(height: 28),
              _buildCheckButton(context),
            ],
          ),
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
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.ink,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        context.l10n.drawingTitle,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
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
            widget.aksaraName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            widget.aksaraChar,
            style: const TextStyle(
              fontSize: 40,
              color: AppColors.amberDark,
              fontFamily: 'NotoSansJavanese',
            ),
          ),
          Container(
            width: 1.5,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.border,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.aksaraName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              Text(
                context.l10n.drawingInstruction,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.inkSecondary,
                ),
              ),
            ],
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
                        targetAksara: widget.aksaraChar,
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
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkSecondary,
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
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
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
                textStyle: const TextStyle(
                  fontSize: 14,
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
              icon: const Icon(Icons.undo_rounded, size: 18),
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
                textStyle: const TextStyle(
                  fontSize: 14,
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
    if (_strokes.isEmpty) return;

    final similarity = StrokeSimilarityEvaluator.evaluate(
      strokes: _strokes,
      targetAksara: widget.aksaraChar,
    );

    final profile = ProfileScope.maybeOf(context);
    final userName = profile?.displayName ?? 'Dimas';
    RewardSummary? summary;

    if (profile != null) {
      final activityId = 'drawing_${widget.aksaraChar}';
      final claimId =
          'draw_${widget.aksaraChar}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
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
        targetAksara: widget.aksaraChar,
        userName: userName,
        rewardSummary: summary,
      ),
    );

    if (result == true && mounted) {
      _clearAll();
    }
  }

  // ── Check Button ───────────────────────────────────────

  Widget _buildCheckButton(BuildContext context) {
    final hasStrokes = _strokes.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasStrokes ? _onCheckDrawing : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.amber,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.inkMuted,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Text(
          context.l10n.drawingCheckButton,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
