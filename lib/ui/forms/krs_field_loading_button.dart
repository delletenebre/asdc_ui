import 'package:flutter/material.dart';

class KrsFieldLoadingButton extends StatefulWidget {
  const KrsFieldLoadingButton({super.key});

  @override
  State<KrsFieldLoadingButton> createState() => _KrsFieldLoadingButtonState();
}

class _KrsFieldLoadingButtonState extends State<KrsFieldLoadingButton> {
  final focusNode = FocusNode(
    skipTraversal: true,
    canRequestFocus: false,
  );

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return IconButton(
      focusNode: focusNode,
      // tooltip: MaterialLocalizations.of(context).lastPageTooltip,
      icon: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: theme.colorScheme.outline.withOpacity(0.62),
      ),
      onPressed: null,
    );
  }
}
