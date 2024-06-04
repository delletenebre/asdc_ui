import 'package:flutter/material.dart';

class AsdcCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AsdcCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    Widget childWidget = child;

    if (padding != null) {
      childWidget = Padding(
        padding: padding!,
        child: child,
      );
    }

    return Material(
      elevation: 1,
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12.0),
      child: childWidget,
    );
  }
}
