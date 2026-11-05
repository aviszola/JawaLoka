import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';

// ─────────────────────────────────────────────────────────
//  DRAWING CANVAS PAINTER
// ─────────────────────────────────────────────────────────

class DrawingCanvasPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color strokeColor;
  final double strokeWidth;

  const DrawingCanvasPainter({
    required this.strokes,
    this.strokeColor = AppColors.ink,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Dotted grid background ──────────────────────────
    final dotPaint = Paint()
      ..color = AppColors.inkMuted.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    const double gridSpacing = 24.0;
    const double dotRadius = 1.5;

    for (double x = gridSpacing; x < size.width; x += gridSpacing) {
      for (double y = gridSpacing; y < size.height; y += gridSpacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }

    // ── Ghost reference aksara ──────────────────────────
    final ghostStyle = TextStyle(
      fontSize: 100,
      color: AppColors.amber.withOpacity(0.15),
      fontFamily: 'NotoSansJavanese',
    );
    final ghostSpan = TextSpan(text: 'ꦲ', style: ghostStyle);
    final ghostPainter = TextPainter(
      text: ghostSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    ghostPainter.paint(
      canvas,
      Offset(
        (size.width - ghostPainter.width) / 2,
        (size.height - ghostPainter.height) / 2,
      ),
    );

    // ── User strokes ────────────────────────────────────
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        // Single tap → draw a dot
        canvas.drawCircle(stroke.first, strokeWidth / 2, Paint()..color = strokeColor);
        continue;
      }

      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        if (i < stroke.length - 1) {
          // Smooth midpoint curves
          final mid = Offset(
            (stroke[i].dx + stroke[i + 1].dx) / 2,
            (stroke[i].dy + stroke[i + 1].dy) / 2,
          );
          path.quadraticBezierTo(
            stroke[i].dx, stroke[i].dy,
            mid.dx, mid.dy,
          );
        } else {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
      }
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(DrawingCanvasPainter old) =>
      old.strokes != strokes ||
      old.strokeColor != strokeColor ||
      old.strokeWidth != strokeWidth;
}

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

  String get label {
    switch (this) {
      case _StrokeSize.thin:
        return 'T';
      case _StrokeSize.medium:
        return 'M';
      case _StrokeSize.thick:
        return 'B';
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

  List<List<Offset>> get _allStrokes =>
      [..._strokes, if (_currentStroke.isNotEmpty) _currentStroke];

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
        label: 'Kembali',
        button: true,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'Latihan Menulis',
        style: TextStyle(
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
            color: Colors.black.withOpacity(0.06),
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
              const Text(
                'Tulis aksara ini!',
                style: TextStyle(
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
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
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
                  builder: (_, __) => CustomPaint(
                    painter: DrawingCanvasPainter(
                      strokes: _allStrokes,
                      strokeWidth: _selectedSize.width,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.canvas.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Goresan: ${_strokes.length}',
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
    );
  }

  // ── Controls Row ───────────────────────────────────────

  Widget _buildControlsRow() {
    return Row(
      children: [
        // Hapus semua
        Expanded(
          child: Semantics(
            label: 'Hapus Semua',
            button: true,
            child: OutlinedButton.icon(
              onPressed: _strokes.isEmpty ? null : _clearAll,
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Hapus Semua'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                disabledForegroundColor: AppColors.inkMuted,
                side: BorderSide(
                  color: _strokes.isEmpty ? AppColors.border : AppColors.error,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Batalkan goresan
        Expanded(
          child: Semantics(
            label: 'Batalkan',
            button: true,
            child: OutlinedButton.icon(
              onPressed: _strokes.isEmpty ? null : _undoLastStroke,
              icon: const Icon(Icons.undo_rounded, size: 18),
              label: const Text('Batalkan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.inkSecondary,
                disabledForegroundColor: AppColors.inkMuted,
                side: BorderSide(
                  color: _strokes.isEmpty ? AppColors.border : AppColors.inkSecondary,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
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
                          color: isSelected ? AppColors.ink : AppColors.inkMuted,
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

  // ── Check Button ───────────────────────────────────────

  Widget _buildCheckButton(BuildContext context) {
    final hasStrokes = _strokes.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasStrokes
            ? () => Navigator.pushNamed(context, AppRouter.dailyResult)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.amber,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.inkMuted,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: const Text(
          'Periksa Tulisan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
