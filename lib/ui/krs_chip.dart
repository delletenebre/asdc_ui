import 'package:flutter/material.dart';

import '../../../extensions/theme_data_extensions.dart';

enum KrsChipType {
  none,
  error,
  success,
}

class KrsChip extends StatelessWidget {
  final String label;
  final KrsChipType type;

  const KrsChip({
    super.key,
    this.label = '',
    this.type = KrsChipType.none,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (type) {
      case KrsChipType.success:
        backgroundColor = theme.successContainerColor();
        foregroundColor = theme.onSuccessContainerColor();
        break;
      case KrsChipType.error:
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;
        break;
      case KrsChipType.none:
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        foregroundColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.0,
          color: foregroundColor,
        ),
      ),
    );
  }

  factory KrsChip.error(String label) => KrsChip(
        label: label,
        type: KrsChipType.error,
      );

  factory KrsChip.success(String label) => KrsChip(
        label: label,
        type: KrsChipType.success,
      );
}
