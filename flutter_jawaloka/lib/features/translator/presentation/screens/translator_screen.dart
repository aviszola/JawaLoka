import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/validation/validation_messages.dart';
import '../../../../core/validation/validation_result.dart';
import '../../../../core/validation/validators.dart';
import '../../data/ai_translation_service.dart';
import '../../data/offline_dictionary_service.dart';
import '../../domain/translation_models.dart';
import '../widgets/translator_panel.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class TranslatorScreen extends StatefulWidget {
  final TranslationService translationService;
  final AiTranslationBackend aiTranslationBackend;

  const TranslatorScreen({
    super.key,
    this.translationService = const OfflineDictionaryService(),
    this.aiTranslationBackend = const GeminiTranslationBackend(),
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
  bool _autoDetectSource = false;
  bool _isTranslating = false;
  bool _isTranslatingAi = false;
  bool _isAiCooldown = false;
  Timer? _aiCooldownTimer;
  String _outputText = '';
  AiTranslationSuccess? _aiResult;
  AiTranslationError? _aiError;
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
    _aiCooldownTimer?.cancel();
    _inputCtrl.dispose();
    _swapCtrl.dispose();
    super.dispose();
  }

  // ─── Logic ──────────────────────────────────────────────────────────────────

  void _onInputChanged() {
    setState(() {}); // Rebuild char counter
    if (_inputCtrl.text.trim().isEmpty &&
        (_outputText.isNotEmpty || _aiResult != null || _aiError != null)) {
      setState(() {
        _outputText = '';
        _isTranslating = false;
        _aiResult = null;
        _aiError = null;
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
    setState(() {
      _isTranslating = true;
      _aiResult = null;
      _aiError = null;
    });

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
      _aiResult = null;
      _aiError = null;
    });
  }

  Future<void> _translateWithAi() async {
    if (!widget.aiTranslationBackend.isConfigured ||
        _isTranslating ||
        _isTranslatingAi ||
        _isAiCooldown) {
      return;
    }

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
    setState(() {
      _isTranslatingAi = true;
      _aiResult = null;
      _aiError = null;
    });

    final outcome = await widget.aiTranslationBackend.translate(
      text: text,
      target: _toVariant,
    );

    if (!mounted) return;

    _isAiCooldown = true;
    _aiCooldownTimer?.cancel();
    _aiCooldownTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isAiCooldown = false);
      }
    });

    switch (outcome) {
      case AiTranslationSuccess():
        setState(() {
          _isTranslatingAi = false;
          _outputText = outcome.translation;
          _aiResult = outcome;
          _aiError = null;
        });
      case AiTranslationFailure(:final error):
        setState(() {
          _isTranslatingAi = false;
          _outputText = '';
          _aiResult = null;
          _aiError = error;
        });
    }
  }

  Future<void> _swapLanguages() async {
    HapticFeedback.lightImpact();
    await _swapCtrl.forward();
    setState(() {
      _autoDetectSource = false;
      final tmp = _fromVariant;
      _fromVariant = _toVariant;
      _toVariant = tmp;

      final notFoundText = context.l10n.translatorMockUnavailable;
      if (_outputText.isNotEmpty && _outputText != notFoundText) {
        _inputCtrl.text = _outputText;
      }
      _outputText = '';
      _isTranslating = false;
      _aiResult = null;
      _aiError = null;
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
              const SizedBox(height: 8),
              _buildAiTranslateSection(),
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
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        Expanded(
          child: _LanguageChip(
            label: _autoDetectSource
                ? context.l10n.translatorLangAuto
                : _getLanguageLabel(context, _fromVariant),
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
                    AppIcons.swap,
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
      languageBadge: _autoDetectSource
          ? context.l10n.translatorLangAuto
          : _getLanguageLabel(context, _fromVariant),
      characterCount: '$charCount/200',
      actions: [
        if (_inputCtrl.text.isNotEmpty)
          _PanelIconButton(
            icon: AppIcons.close,
            tooltip: context.l10n.translatorClearTooltip,
            onTap: () {
              _inputCtrl.clear();
              setState(() {
                _outputText = '';
                _aiResult = null;
                _aiError = null;
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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: context.l10n.translatorInputHint,
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.inkMuted,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildPhrasesHint() {
    final examples = widget.translationService.examples(_fromVariant, max: 4);
    if (examples.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: examples.map((phrase) {
        return ActionChip(
          label: Text(
            phrase,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.ink,
            ),
          ),
          backgroundColor: AppColors.surfaceWarm,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            _inputCtrl.text = phrase;
            _inputCtrl.selection = TextSelection.collapsed(
              offset: phrase.length,
            );
            _translate();
          },
        );
      }).toList(),
    );
  }

  Widget _buildTranslateButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (_isTranslating || _isTranslatingAi) ? null : _translate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAmber,
          foregroundColor: AppColors.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: AppColors.primaryAmber.withValues(alpha: 0.55),
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              )
            : Text(
                context.l10n.translatorButton,
                style: Theme.of(context).textTheme.titleMedium,
              ),
      ),
    );
  }

  Widget _buildAiTranslateSection() {
    final l10n = context.l10n;
    final isEnabled = widget.aiTranslationBackend.isConfigured;
    if (!isEnabled) {
      return const SizedBox.shrink();
    }
    final canTap = !_isTranslating && !_isTranslatingAi && !_isAiCooldown;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            key: const Key('translator_ai_button'),
            onPressed: canTap ? _translateWithAi : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              disabledForegroundColor: AppColors.inkMuted,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: AppColors.border,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isTranslatingAi
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.ink.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.translatorTranslating,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(AppIcons.sparkle, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.translatorAiButton,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            l10n.translatorAiPrivacyNotice,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.inkSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  String _getDetectedLanguageLabel(
    BuildContext context,
    AiDetectedLanguage detected,
  ) {
    final l10n = context.l10n;
    switch (detected) {
      case AiDetectedLanguage.id:
        return l10n.translatorLangId;
      case AiDetectedLanguage.en:
        return l10n.translatorLangEn;
      case AiDetectedLanguage.jvNgoko:
        return l10n.translatorLangJvNgoko;
      case AiDetectedLanguage.jvKrama:
        return l10n.translatorLangJvKrama;
      case AiDetectedLanguage.unknown:
        return l10n.translatorAiDetectedUnknown;
    }
  }

  String _getConfidenceLabel(BuildContext context, AiConfidence confidence) {
    final l10n = context.l10n;
    switch (confidence) {
      case AiConfidence.tinggi:
        return l10n.translatorAiConfidenceHigh;
      case AiConfidence.sedang:
        return l10n.translatorAiConfidenceMedium;
      case AiConfidence.rendah:
        return l10n.translatorAiConfidenceLow;
    }
  }

  String _getAiErrorMessage(BuildContext context, AiTranslationError error) {
    final l10n = context.l10n;
    switch (error) {
      case AiTranslationError.disabled:
        return l10n.translatorAiDisabledNotice;
      case AiTranslationError.sameLanguage:
        return l10n.translatorAiErrorSameLanguage;
      case AiTranslationError.noInternet:
        return l10n.translatorAiErrorNoInternet;
      case AiTranslationError.invalidKey:
        return l10n.translatorAiErrorInvalidKey;
      case AiTranslationError.quotaExceeded:
        return l10n.translatorAiErrorQuota;
      case AiTranslationError.timeout:
        return l10n.translatorAiErrorTimeout;
      case AiTranslationError.emptyOrBlocked:
        return l10n.translatorAiErrorBlockedOrEmpty;
      case AiTranslationError.other:
        return l10n.translatorAiErrorOther;
    }
  }

  Widget _buildOutputPanel() {
    final l10n = context.l10n;
    final isLoading = _isTranslating || _isTranslatingAi;
    return TranslatorPanel(
      isOutput: true,
      label: l10n.translatorOutputLabel,
      languageBadge: _getLanguageLabel(context, _toVariant),
      actions: [
        _PanelIconButton(
          icon: AppIcons.copy,
          tooltip: l10n.translatorCopyTooltip,
          onTap: _outputText.isEmpty ? null : _copyResult,
        ),
      ],
      child: isLoading
          ? const ShimmerPlaceholder(height: 80)
          : _aiError != null
          ? Text(
              _getAiErrorMessage(context, _aiError!),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                height: 1.5,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _outputText.isEmpty
                      ? l10n.translatorOutputPlaceholder
                      : _outputText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _outputText.isEmpty
                        ? AppColors.inkMuted
                        : AppColors.ink,
                    height: 1.5,
                  ),
                ),
                if (_outputText.isNotEmpty && _aiResult != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.translatorAiResultLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.amberDark,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.translatorAiResultMeta(
                      _getDetectedLanguageLabel(
                        context,
                        _aiResult!.detectedLanguage,
                      ),
                      _getConfidenceLabel(context, _aiResult!.confidence),
                    ),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.inkSecondary,
                      height: 1.35,
                    ),
                  ),
                  if (_aiResult!.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _aiResult!.note,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.inkSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ],
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
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.translatorPickerTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (isFrom)
              ListTile(
                key: const Key('translator_lang_auto_option'),
                leading: Icon(
                  _autoDetectSource
                      ? AppIcons.checkCircle
                      : AppIcons.radioUnchecked,
                  color: _autoDetectSource
                      ? AppColors.amber
                      : AppColors.inkMuted,
                ),
                title: Text(
                  context.l10n.translatorLangAuto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  setState(() {
                    _autoDetectSource = true;
                  });
                  Navigator.pop(ctx);
                },
              ),
            ...TranslationVariant.values.map((variant) {
              final isSelected = isFrom
                  ? (!_autoDetectSource && _fromVariant == variant)
                  : _toVariant == variant;
              final label = _getLanguageLabel(context, variant);
              return ListTile(
                leading: Icon(
                  isSelected
                      ? AppIcons.checkCircle
                      : AppIcons.radioUnchecked,
                  color: isSelected ? AppColors.amber : AppColors.inkMuted,
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
                      _autoDetectSource = false;
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
            ),
          ),
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
              AppIcons.expandMore,
              size: 16,
              color: AppColors.inkSecondary,
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
                      ? AppColors.border
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: onTap != null ? AppColors.ink : AppColors.inkMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
