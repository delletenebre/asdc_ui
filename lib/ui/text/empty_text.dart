import 'package:flutter/material.dart';

class EmptyText extends StatelessWidget {
  final String? text;
  final TextStyle? style;

  final String emptyText;
  final TextStyle? emptyStyle;

  const EmptyText(
    this.text,
    this.emptyText, {
    super.key,
    this.style,
    this.emptyStyle,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    if (text != null && text!.isNotEmpty) {
      return Text(
        text!,
        style: style,
      );
    }

    return Text(
      emptyText,
      style: emptyStyle ??
          TextStyle(
            color: theme.colorScheme.outline.withOpacity(0.96),
          ),
    );
  }
}
