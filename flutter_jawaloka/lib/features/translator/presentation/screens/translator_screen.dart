import 'dart:async';
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

class _HistoryItem {
  final String source;
  final String result;
  final String fromLang;
  final String toLang;
  const _HistoryItem({
    required this.source,
    required this.result,
    required this.fromLang,
    required this.toLang,
  });
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
  final ScrollController _historyScroll = ScrollController();
  Timer? _debounce;

  // State
  bool _isTranslating = false;
  String _outputText = '';
  String _outputAksara = '';
  List<_HistoryItem> _history = [];

  // Swap animation
  late AnimationController _swapCtrl;
  late Animation<double> _swapRotation;

  // Quick suggestions
  static const List<String> _suggestions = [
    'Halo',
    'Apa kabar?',
    'Matur nuwun',
    'Sugeng enjing',
    'Kula boten mangertos',
    'Pundi dalemipun?',
    'Sampun nedha?',
  ];

  @override
  void initState() {
    super.initState();
    _swapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _swapRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _swapCtrl, curve: Curves.easeInOutBack),
    );
    _inputCtrl.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _inputCtrl.dispose();
    _swapCtrl.dispose();
    _historyScroll.dispose();
    super.dispose();
  }

  // ─── Logic ──────────────────────────────────────────────────────────────────

  void _onInputChanged() {
    setState(() {}); // rebuild char counter
    if (_inputCtrl.text.trim().isEmpty) {
      setState(() {
        _outputText = '';
        _outputAksara = '';
        _isTranslating = false;
      });
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _translate);
  }

  Future<void> _translate() async {
    if (_inputCtrl.text.trim().isEmpty) return;
    setState(() => _isTranslating = true);

    // Simulated translation – replace with real API call
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    final result = _mockTranslate(_inputCtrl.text.trim());
    final aksara = _mockToAksara(_inputCtrl.text.trim());

    setState(() {
      _isTranslating = false;
      _outputText = result;
      _outputAksara = aksara;
      _history = [
        _HistoryItem(
          source: _inputCtrl.text.trim(),
          result: result,
          fromLang: _languages[_fromIndex].name,
          toLang: _languages[_toIndex].name,
        ),
        ..._history.take(2),
      ];
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

  String _mockToAksara(String text) {
    // Placeholder Aksara Jawa-ish representation
    return 'ꦲꦭꦺꦴ꧈ $text ꧈';
  }

  Future<void> _swapLanguages() async {
    HapticFeedback.lightImpact();
    await _swapCtrl.forward();
    setState(() {
      final tmp = _fromIndex;
      _fromIndex = _toIndex;
      _toIndex = tmp;
      _outputText = '';
      _outputAksara = '';
      _inputCtrl.clear();
    });
    _swapCtrl.reset();
  }

  void _applySuggestion(String text) {
    _inputCtrl.text = text;
    _inputCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    _translate();
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
              const SizedBox(height: 20),
              _buildSuggestions(),
              const SizedBox(height: 20),
              if (_history.isNotEmpty) _buildHistory(),
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
      title: const Text(
        'Penerjemah',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded, color: AppColors.ink),
          onPressed: () {},
          tooltip: 'Riwayat',
        ),
      ],
      // Kawung texture paint
      flexibleSpace: CustomPaint(
        painter: _KawungTexturePainter(),
      ),
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
        GestureDetector(
          onTap: _swapLanguages,
          child: AnimatedBuilder(
            animation: _swapRotation,
            builder: (context, child) => Transform.rotate(
              angle: _swapRotation.value * 3.14159 * 2,
              child: child,
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE8E1D6), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.swap_horiz_rounded, color: AppColors.ink, size: 20),
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
                _outputAksara = '';
              });
            },
          ),
      ],
      child: TextField(
        controller: _inputCtrl,
        maxLines: 4,
        maxLength: 500,
        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          disabledBackgroundColor: AppColors.amber.withOpacity(0.55),
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
                      color: AppColors.ink.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Menerjemahkan...', style: TextStyle(fontWeight: FontWeight.w600)),
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
          icon: Icons.volume_up_rounded,
          tooltip: 'Ucapkan',
          onTap: _outputText.isEmpty ? null : () {},
        ),
        const SizedBox(width: 4),
        _PanelIconButton(
          icon: Icons.copy_rounded,
          tooltip: 'Salin',
          onTap: _outputText.isEmpty ? null : _copyResult,
        ),
      ],
      child: _isTranslating
          ? const ShimmerPlaceholder(height: 80)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _outputText.isEmpty ? 'Hasil terjemahan akan muncul di sini…' : _outputText,
                  style: TextStyle(
                    fontSize: 15,
                    color: _outputText.isEmpty ? const Color(0xFFB0A898) : AppColors.ink,
                    height: 1.6,
                  ),
                ),
                if (_outputAksara.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _outputAksara,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.amberDark,
                        height: 1.5,
                        fontFamily: 'NotoSansJavanese',
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saran Cepat',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B6257),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => _SuggestionChip(
              label: _suggestions[i],
              onTap: () => _applySuggestion(_suggestions[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Riwayat Terakhir',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B6257),
                letterSpacing: 0.4,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _history = []),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._history.map((item) => _HistoryCard(item: item, onTap: () => _applySuggestion(item.source))),
      ],
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
            const Text('Pilih Bahasa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._languages.map((lang) {
              final selectedIndex = isFrom ? _fromIndex : _toIndex;
              final isSelected = _languages.indexOf(lang) == selectedIndex;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.amber : const Color(0xFFB0A898),
                ),
                title: Text(lang.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  setState(() {
                    if (isFrom) _fromIndex = _languages.indexOf(lang);
                    else _toIndex = _languages.indexOf(lang);
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFFE8E1D6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withOpacity(0.06),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF6B6257)),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFFE8E1D6)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _PanelIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _PanelIconButton({required this.icon, required this.tooltip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: onTap != null ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: onTap != null ? const Color(0xFFE8E1D6) : Colors.transparent,
            ),
          ),
          child: Icon(
            icon,
            size: 17,
            color: onTap != null ? AppColors.ink : const Color(0xFFB0A898),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;
  final VoidCallback onTap;
  const _HistoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E1D6)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.source,
                    style: const TextStyle(fontSize: 13, color: AppColors.ink, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.result,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B6257)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F1EB),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${item.fromLang} → ${item.toLang}',
                style: const TextStyle(fontSize: 9, color: Color(0xFF6B6257), fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
      ..color = AppColors.kawungStroke.withOpacity(0.18)
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
