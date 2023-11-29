import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final Widget icon;
  final Widget child;
  final Widget? action;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.child,
    this.action,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// виджет изображения
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
              ),
              child: IconTheme(
                data: IconThemeData(
                  size: 64.0,
                  color: theme.colorScheme.outline.withOpacity(0.36),
                ),
                child: icon,
              ),
            ),

            /// виджет сообщения
            DefaultTextStyle(
              style: TextStyle(
                color: theme.colorScheme.outline,
              ),
              child: child,
            ),

            /// виджет действия
            if (action != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: action,
              ),
          ],
        ),
      ),
    );
  }
}
