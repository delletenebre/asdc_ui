import 'package:flutter/material.dart';

class AsdcCard extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;

  const AsdcCard({
    super.key,
    this.child,
    this.children,
    this.padding = const EdgeInsets.all(16.0),
  }) : assert(child != null || children != null);

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    Widget childWidget = children != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children!)
        : child!;

    if (padding != null) {
      childWidget = Padding(
        padding: padding!,
        child: childWidget,
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

class AsdcCardTitle extends StatelessWidget {
  final String title;

  const AsdcCardTitle(this.title, {super.key});

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }
}

class AsdcCardSubtitle extends StatelessWidget {
  final String title;

  const AsdcCardSubtitle(this.title, {super.key});

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: theme.textTheme.bodyLarge),
    );
  }
}
