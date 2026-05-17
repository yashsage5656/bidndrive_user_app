import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Custom Text Field with icons and validation styling
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isEnabled;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final Color? fillColor;
  final bool isDark;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.fillColor,
    this.isDark = false,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final textColor = isDark ? AppColors.textOnDark : AppColors.textPrimary;
    final hintColor = isDark ? AppColors.grey400 : AppColors.textLight;
    final fillColor =
        widget.fillColor ??
        (isDark ? AppColors.white.withOpacity(0.1) : AppColors.grey100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: AppSizes.fontSM,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.grey300 : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.xs),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          enabled: widget.isEnabled,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          validator: widget.validator,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontSize: AppSizes.fontMD, color: textColor),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: hintColor, fontSize: AppSizes.fontSM),
            filled: true,
            fillColor: fillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSM,
              vertical: AppSizes.paddingSM,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: hintColor,
                    size: AppSizes.iconSM,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: hintColor,
                      size: AppSizes.iconSM,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),
              borderSide: isDark
                  ? BorderSide(color: AppColors.white.withOpacity(0.2))
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
