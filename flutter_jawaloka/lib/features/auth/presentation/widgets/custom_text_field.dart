import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable text input field with animated floating label for JawaLoka.
/// Matches Google Stitch design spec: 56px height, 20px radius, white surface.
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showTogglePassword;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.showTogglePassword = false,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late bool _obscured;
  late final FocusNode _focusNode;
  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    // Shake animation for error state
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.02, 0)).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
        );
  }

  void _onFocusChange() {
    setState(() {}); // rebuild to update label position/color
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake when error appears
    if (widget.errorText != null &&
        widget.errorText != oldWidget.errorText &&
        widget.errorText!.isNotEmpty) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  bool get _hasContent => widget.controller.text.isNotEmpty;
  bool get _isFocused => _focusNode.hasFocus;
  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _shakeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.amber.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : _hasError
                  ? [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCapitalization,
              autofillHints: widget.autofillHints,
              obscureText: _obscured,
              textInputAction: widget.textInputAction,
              onChanged: (val) {
                setState(() {});
                widget.onChanged?.call(val);
              },
              onFieldSubmitted: widget.onSubmitted,
              autofocus: widget.autofocus,
              maxLines: widget.maxLines,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: TextStyle(
                  color: _hasError
                      ? AppColors.error
                      : _isFocused
                      ? AppColors.ink
                      : AppColors.inkSecondary,
                  fontSize: 14,
                  fontWeight: _isFocused || _hasContent
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
                floatingLabelStyle: TextStyle(
                  color: _hasError ? AppColors.error : AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.showTogglePassword
                    ? Semantics(
                        label: _obscured
                            ? context.l10n.authShowPassword
                            : context.l10n.authHidePassword,
                        button: true,
                        child: GestureDetector(
                          onTap: () => setState(() => _obscured = !_obscured),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Icon(
                              _obscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.inkSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    : widget.suffixIcon,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.amber,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                errorText: null, // Handle error display manually
              ),
              validator: widget.validator,
            ),
          ),

          // Error message
          if (_hasError)
            AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: Offset.zero,
              child: Padding(
                padding: const EdgeInsets.only(top: 6, left: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.errorText!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
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
}
