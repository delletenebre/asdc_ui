import 'package:flutter/material.dart';

class KrsFieldLoadingButton extends StatelessWidget {
  const KrsFieldLoadingButton({super.key});

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return IconButton(
      focusNode: FocusNode(
        skipTraversal: true,
        canRequestFocus: false,
      ),
      // tooltip: MaterialLocalizations.of(context).lastPageTooltip,
      icon: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: theme.colorScheme.outline.withOpacity(0.62),
      ),
      onPressed: null,
    );
  }
}
