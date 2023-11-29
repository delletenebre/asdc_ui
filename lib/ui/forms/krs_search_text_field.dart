import 'package:flutter/material.dart';

import 'krs_input_decoration.dart';

class KrsSearchTextField extends StatefulWidget {
  final Function(String value) onChanged;
  final String? tooltip;

  const KrsSearchTextField({
    super.key,
    required this.onChanged,
    this.tooltip,
  });

  @override
  State<KrsSearchTextField> createState() => _KrsSearchTextFieldState();
}

class _KrsSearchTextFieldState extends State<KrsSearchTextField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    final decoration = KrsInputDecoration(
      theme: theme,
      hintText: MaterialLocalizations.of(context).searchFieldLabel,
      prefixIcon: Icon(
        Icons.search_outlined,
        color: theme.colorScheme.outline.withOpacity(0.36),
      ),
      suffixIcon: _textController.text.isNotEmpty
          ? IconButton(
              tooltip: widget.tooltip,
              onPressed: () {
                _textController.clear();
                widget.onChanged('');
              },
              icon: const Icon(Icons.clear),
            )
          : null,
    );

    return TextField(
      controller: _textController,
      style: decoration.textStyle,
      decoration: decoration,
      onChanged: (value) {
        widget.onChanged(value);
      },
    );
  }
}
