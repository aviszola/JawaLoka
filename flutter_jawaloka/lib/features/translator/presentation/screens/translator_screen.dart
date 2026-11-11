import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../../data/offline_dictionary_service.dart';
import '../../domain/translation_models.dart';
import '../widgets/translator_panel.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class TranslatorScreen extends StatefulWidget {
  final TranslationService translationService;

  const TranslatorScreen({
    super.key,
    this.translationService = const OfflineDictionaryService(),
  });

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen>
    with SingleTickerProviderStateMixin {
  TranslationVariant _fromVariant = TranslationVariant.id;
  TranslationVariant _toVariant = TranslationVariant.jvNgoko;

  String _getLanguageLabel(BuildContext context, TranslationVariant variant) {
    final l10n = context.l10n;
    switch (variant) {
      case TranslationVariant.jvNgoko:
        return l10n.translatorLangJvNgoko;
      case TranslationVariant.jvKrama:
        return l10n.translatorLangJvKrama;
      case TranslationVariant.id:
        return l10n.translatorLangId;
      case TranslationVariant.en:
        return l10n.translatorLangEn;
    }
  }

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
    final validation = Validators.validateTranslationInput(_inputCtrl.text);
    if (validation.isInvalid) {
      final err = (validation as Invalid<String, TranslationInputError>).error;
      final msg = ValidationMessages.translationError(context.l10n, err);
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

    final text = (validation as Valid<String, TranslationInputError>).value;
    setState(() => _isTranslating = true);

    final result = await widget.translationService.translate(
      text: text,
      from: _fromVariant,
      to: _toVariant,
    );

    if (!mounted) return;
    final String output = switch (result) {
      Found(:final text) => text,
      NotFound() => context.l10n.translatorMockUnavailable,
    };

    setState(() {
      _isTranslating = false;
      _outputText = output;
    });
  }

  Future<void> _swapLanguages() async {
    HapticFeedback.lightImpact();
    await _swapCtrl.forward();
    setState(() {
      final tmp = _fromVariant;
      _fromVariant = _toVariant;
      _toVariant = tmp;

      final notFoundText = context.l10n.translatorMockUnavailable;
      if (_outputText.isNotEmpty && _outputText != notFoundText) {
        _inputCtrl.text = _outputText;
      }
      _outputText = '';
      _isTranslating = false;
    });
    _swapCtrl.reset();
  }

  void _copyResult() {
    if (_outputText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _outputText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.translatorCopiedToast),
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
      backgroundColor: AppColors.canvas,
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
              const SizedBox(height: 8),
              _buildPhrasesHint(),
              const SizedBox(height: 10),
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
      backgroundColor: AppColors.canvas,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Semantics(
        label: context.l10n.commonBack,
        button: true,
        child: BackButton(color: AppColors.ink),
      ),
      title: Text(
        context.l10n.translatorTitle,
        style: const TextStyle(
          color: Color(0xFF231C14),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        Expanded(
          child: _LanguageChip(
            label: _getLanguageLabel(context, _fromVariant),
            onTap: () => _showLanguagePicker(isFrom: true),
          ),
        ),
        const SizedBox(width: 10),
        // Animated swap button
        Semantics(
          label: context.l10n.translatorSwapSemantics,
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
                    border: Border.all(color: AppColors.border, width: 1.5),
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
            label: _getLanguageLabel(context, _toVariant),
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
      label: context.l10n.translatorInputLabel,
      languageBadge: _getLanguageLabel(context, _fromVariant),
      characterCount: '$charCount/200',
      actions: [
        if (_inputCtrl.text.isNotEmpty)
          _PanelIconButton(
            icon: Icons.close_rounded,
            tooltip: context.l10n.translatorClearTooltip,
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
        maxLength: 200,
        buildCounter:
            (_, {required currentLength, required isFocused, maxLength}) =>
                null,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.ink,
          height: 1.55,
        ),
        decoration: InputDecoration(
          hintText: context.l10n.translatorInputHint,
          hintStyle: const TextStyle(color: Color(0xFFB0A898), fontSize: 15),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildPhrasesHint() {
    final examples = widget.translationService
        .examples(_fromVariant, max: 4)
        .join(', ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        context.l10n.translatorBasicPhrasesHint(examples),
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.inkSecondary,
          height: 1.35,
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
                  Text(
                    context.l10n.translatorTranslating,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Text(
                context.l10n.translatorButton,
                style: const TextStyle(
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
      label: context.l10n.translatorOutputLabel,
      languageBadge: _getLanguageLabel(context, _toVariant),
      actions: [
        _PanelIconButton(
          icon: Icons.copy_rounded,
          tooltip: context.l10n.translatorCopyTooltip,
          onTap: _outputText.isEmpty ? null : _copyResult,
        ),
      ],
      child: _isTranslating
          ? const ShimmerPlaceholder(height: 80)
          : Text(
              _outputText.isEmpty
                  ? context.l10n.translatorOutputPlaceholder
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
            Text(
              context.l10n.translatorPickerTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...TranslationVariant.values.map((variant) {
              final isSelected = isFrom
                  ? _fromVariant == variant
                  : _toVariant == variant;
              final label = _getLanguageLabel(context, variant);
              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.amber : const Color(0xFFB0A898),
                ),
                title: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  setState(() {
                    if (isFrom) {
                      if (_toVariant == variant) {
                        _toVariant = _fromVariant;
                      }
                      _fromVariant = variant;
                    } else {
                      if (_fromVariant == variant) {
                        _fromVariant = _toVariant;
                      }
                      _toVariant = variant;
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
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
