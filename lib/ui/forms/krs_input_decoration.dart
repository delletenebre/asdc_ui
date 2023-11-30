import 'package:flutter/material.dart';

class KrsInputDecoration extends InputDecoration {
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  static final BorderRadius _borderRadius = BorderRadius.circular(4);

  KrsInputDecoration({
    required ThemeData theme,
    super.errorText,
    String? hintText,
    EdgeInsetsGeometry? contentPadding,
    Widget? suffixIcon,
    Function()? onSuffixPressed,
    int hintMaxLines = 1,
    Widget? prefixIcon,
    bool enabled = true,
    TextStyle style = const TextStyle(
      fontSize: 14.0,
      height: 1.1,
      fontWeight: FontWeight.w400,
    ),
    InputBorder? border,
    bool isDense = false,
  })  : textStyle = style.copyWith(
          fontSize: 14.0,
          color:
              enabled ? theme.colorScheme.onSurface : theme.colorScheme.outline,
        ),
        borderRadius = _borderRadius,
        super(
          constraints: BoxConstraints.tightFor(height: isDense ? 28.0 : 36.0),
          isCollapsed: true,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: isDense ? 10.5 : 16.5,
                horizontal: isDense ? 8.0 : 12.0,
              ),

          errorMaxLines: 2,
          errorStyle: TextStyle(
            fontSize: 11.0,
            color: theme.colorScheme.error,
          ),

          floatingLabelBehavior: FloatingLabelBehavior.always,

          border: border ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.62),
                  width: 1.0,
                ),
                borderRadius: _borderRadius,
              ),

          enabledBorder: border ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: enabled
                      ? theme.colorScheme.outline.withOpacity(0.62)
                      : theme.colorScheme.outline.withOpacity(0.16),
                  width: 1.0,
                ),
                borderRadius: _borderRadius,
              ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.0,
            ),
            borderRadius: _borderRadius,
          ),

          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.0,
            ),
            borderRadius: _borderRadius,
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.0,
            ),
            borderRadius: _borderRadius,
          ),

          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.16),
              width: 1.0,
            ),
            borderRadius: _borderRadius,
          ),

          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: theme.colorScheme.primary,
          //   ),
          // ),

          filled: !enabled,
          fillColor: theme.colorScheme.outline.withOpacity(0.06),

          hintText: enabled ? hintText : null,
          hintMaxLines: hintMaxLines,
          hintStyle: TextStyle(
            color: theme.colorScheme.outline.withOpacity(0.62),
            fontSize: 12.0,
          ),

          suffixIconConstraints: const BoxConstraints(
            maxHeight: 28.0,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: IconTheme(
                    data: IconThemeData(
                      color: theme.colorScheme.outline,
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: suffixIcon,
                    ),
                  ),
                ),

          // (suffixIcon != null) ? IconButton(
          //   splashRadius: 24.0,
          //   onPressed: onSuffixPressed,
          //   icon: Icon(suffixIcon,
          //     color: theme.colorScheme.outline,
          //   ),
          // ) : null,

          prefixIcon: prefixIcon,
        );
}
