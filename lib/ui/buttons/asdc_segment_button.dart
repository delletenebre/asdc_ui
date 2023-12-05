import 'package:flutter/material.dart';

enum AsdcSegmentedButtonType {
  start,
  middle,
  end,
}

class AsdcSegmentedButton extends StatelessWidget {
  final AsdcSegmentedButtonType type;
  final void Function()? onTap;
  final bool selected;
  final Widget child;

  const AsdcSegmentedButton({
    super.key,
    this.type = AsdcSegmentedButtonType.middle,
    this.onTap,
    this.selected = false,
    required this.child,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    BorderRadius? borderRadius;
    if (type == AsdcSegmentedButtonType.start) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(32.0),
        bottomLeft: Radius.circular(32.0),
      );
    } else if (type == AsdcSegmentedButtonType.end) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(32.0),
        bottomRight: Radius.circular(32.0),
      );
    }

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
          child: Center(child: child),
        ),
      ),
    );
  }
}
