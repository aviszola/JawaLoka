import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/translator_panel.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

class _Language {
  final String name;
  final String code;
  const _Language(this.name, this.code);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen>
    with SingleTickerProviderStateMixin {
  // Languages
  static const List<_Language> _languages = [
    _Language('Bahasa Indonesia', 'id'),
    _Language('Basa Jawa', 'jv'),
    _Language('English', 'en'),
  ];

  int _fromIndex = 0;
  int _toIndex = 1;

  // Controllers
  final TextEditingController _inputCtrl = TextEditingController();

  // State
  bool _isTranslating = false;
  String _outputText = '';

  // Swap animation
  late AnimationController _swapCtrl;
  late Animation<double> _swapRotation;

  @override
  void initState() {
    super.initState();
    _swapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _swapRotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _swapCtrl, curve: Curves.easeInOutBack));
    _inputCtrl.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _swapCtrl.dispose();
    super.dispose();
  }

  // ─── Logic ──────────────────────────────────────────────────────────────────

  void _onInputChanged() {
    setState(() {}); // Rebuild char counter
    if (_inputCtrl.text.trim().isEmpty && _outputText.isNotEmpty) {
      setState(() {
        _outputText = '';
        _isTranslating = false;
      });
    }
  }

  Future<void> _translate() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _isTranslating = true);

    // Simulated translation – replace with real API call
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    final result = _mockTranslate(text);

    setState(() {
      _isTranslating = false;
      _outputText = result;
    });
  }

  // Stub translators – replace with actual backend
  String _mockTranslate(String text) {
    final map = {
      'Halo': 'Sugeng rawuh',
      'Apa kabar?': 'Pripun kabaripun?',
      'Matur nuwun': 'Terima kasih',
      'Sugeng enjing': 'Selamat pagi',
      'Kula boten mangertos': 'Saya tidak mengerti',
    };
    return map[text] ?? 'Terjemahan: $text';
  }

  Future<void> _swapLanguages() async {
    HapticFeedback.lightImpact();
    await _swapCtrl.forward();
    setState(() {
      final tmp = _fromIndex;
      _fromIndex = _toIndex;
      _toIndex = tmp;
      _outputText = '';
      _inputCtrl.clear();
    });
    _swapCtrl.reset();
  }

  void _copyResult() {
    if (_outputText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _outputText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Disalin ke clipboard'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLanguageSelector(),
              const SizedBox(height: 14),
              _buildInputPanel(),
              const SizedBox(height: 12),
              _buildTranslateButton(),
              const SizedBox(height: 12),
              _buildOutputPanel(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.amber,
      elevation: 0,
      leading: Semantics(
        label: 'Kembali',
        button: true,
        child: BackButton(color: AppColors.ink),
      ),
      title: const Text(
        'Penerjemah',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      // Kawung texture paint
      flexibleSpace: CustomPaint(painter: _KawungTexturePainter()),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        Expanded(
          child: _LanguageChip(
            label: _languages[_fromIndex].name,
            onTap: () => _showLanguagePicker(isFrom: true),
          ),
        ),
        const SizedBox(width: 10),
        // Animated swap button
        Semantics(
          label: 'Tukar bahasa',
          button: true,
          child: GestureDetector(
            onTap: _swapLanguages,
            behavior: HitTestBehavior.opaque,
            child: Container(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _swapRotation,
                builder: (context, child) => Transform.rotate(
                  angle: _swapRotation.value * math.pi * 2,
                  child: child,
                ),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: AppColors.ink,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _LanguageChip(
            label: _languages[_toIndex].name,
            onTap: () => _showLanguagePicker(isFrom: false),
          ),
        ),
      ],
    );
  }

  Widget _buildInputPanel() {
    final charCount = _inputCtrl.text.length;
    return TranslatorPanel(
      isOutput: false,
      label: 'MASUKKAN TEKS',
      languageBadge: _languages[_fromIndex].name,
      characterCount: '$charCount/500',
      actions: [
        if (_inputCtrl.text.isNotEmpty)
          _PanelIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Hapus',
            onTap: () {
              _inputCtrl.clear();
              setState(() {
                _outputText = '';
              });
            },
          ),
      ],
      child: TextField(
        controller: _inputCtrl,
        maxLines: 4,
        maxLength: 500,
        buildCounter:
            (_, {required currentLength, required isFocused, maxLength}) =>
                null,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.ink,
          height: 1.55,
        ),
        decoration: const InputDecoration(
          hintText: 'Ketik teks...',
          hintStyle: TextStyle(color: Color(0xFFB0A898), fontSize: 15),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildTranslateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isTranslating ? null : _translate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: AppColors.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBackgroundColor: AppColors.amber.withValues(alpha: 0.55),
        ),
        child: _isTranslating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.ink.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Menerjemahkan...',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : const Text(
                'Terjemahkan',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _buildOutputPanel() {
    return TranslatorPanel(
      isOutput: true,
      label: 'HASIL TERJEMAHAN',
      languageBadge: _languages[_toIndex].name,
      actions: [
        _PanelIconButton(
          icon: Icons.copy_rounded,
          tooltip: 'Salin',
          onTap: _outputText.isEmpty ? null : _copyResult,
        ),
      ],
      child: _isTranslating
          ? const ShimmerPlaceholder(height: 80)
          : Text(
              _outputText.isEmpty
                  ? 'Hasil terjemahan akan muncul di sini…'
                  : _outputText,
              style: TextStyle(
                fontSize: 15,
                color: _outputText.isEmpty
                    ? const Color(0xFFB0A898)
                    : AppColors.ink,
                height: 1.6,
              ),
            ),
    );
  }

  // ─── Dialogs ────────────────────────────────────────────────────────────────

  void _showLanguagePicker({required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E1D6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Bahasa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ..._languages.map((lang) {
              final selectedIndex = isFrom ? _fromIndex : _toIndex;
              final isSelected = _languages.indexOf(lang) == selectedIndex;
              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.amber : const Color(0xFFB0A898),
                ),
                title: Text(
                  lang.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  setState(() {
                    if (isFrom) {
                      _fromIndex = _languages.indexOf(lang);
                    } else {
                      _toIndex = _languages.indexOf(lang);
                    }
                  });
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _LanguageChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LanguageChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Color(0xFF6B6257),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _PanelIconButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      child: Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: onTap != null ? AppColors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: onTap != null
                      ? const Color(0xFFE8E1D6)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: onTap != null ? AppColors.ink : const Color(0xFFB0A898),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Kawung texture AppBar painter ───────────────────────────────────────────

class _KawungTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kawungStroke.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const r = 12.0;
    for (double x = 0; x < size.width + r * 2; x += r * 2) {
      for (double y = 0; y < size.height + r * 2; y += r * 2) {
        final c = Offset(x, y);
        canvas.drawCircle(c.translate(-r, 0), r, paint);
        canvas.drawCircle(c.translate(r, 0), r, paint);
        canvas.drawCircle(c.translate(0, -r), r, paint);
        canvas.drawCircle(c.translate(0, r), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_KawungTexturePainter _) => false;
}
