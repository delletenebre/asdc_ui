import 'package:flutter/material.dart';

enum KrsSegmentedButtonType {
  start,
  middle,
  end,
}

class KrsSegmentedButton extends StatelessWidget {
  final KrsSegmentedButtonType type;
  final void Function()? onTap;
  final bool selected;
  final Widget child;

  const KrsSegmentedButton({
    super.key,
    this.type = KrsSegmentedButtonType.middle,
    this.onTap,
    this.selected = false,
    required this.child,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    BorderRadius? borderRadius;
    if (type == KrsSegmentedButtonType.start) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(32.0),
        bottomLeft: Radius.circular(32.0),
      );
    } else if (type == KrsSegmentedButtonType.end) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(32.0),
        bottomRight: Radius.circular(32.0),
      );
    }

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color:
              selected ? theme.colorScheme.primary : theme.colorScheme.surface,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
          child: child,
        ),
      ),
    );
  }
}
