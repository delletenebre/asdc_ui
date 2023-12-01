import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'krs_field_label.dart';
import 'krs_field_loading_button.dart';
import 'krs_input_decoration.dart';

class KrsAutocompleteField extends FormBuilderFieldDecoration<String> {
  final Future<Iterable<String>> Function() asyncItems;
  final void Function(bool, String?)? onFocusChanged;

  KrsAutocompleteField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    Widget? suffixIcon,
    String? initialValue,
    String? labelText,
    String? hintText,
    bool loading = false,
    required this.asyncItems,
    ValueChanged<String>? onSubmitted,
    this.onFocusChanged,
  }) : super(
          initialValue: initialValue,
          builder: (FormFieldState<String?> field) {
            final state = field as _KrsAutocompleteFieldState;
            final theme = Theme.of(state.context);

            final loadingState = (loading || state._suggestions == null)
                ? const KrsFieldLoadingButton()
                : null;

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: state.enabled,
              errorText: state.errorText,
              hintText: hintText,
              suffixIcon: loadingState ?? suffixIcon,
            );

            return KrsFieldLabel(
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              child: LayoutBuilder(
                builder: (context, constraints) => RawAutocomplete(
                  // key: key,
                  textEditingController: state._effectiveController,
                  focusNode: state.effectiveFocusNode,
                  optionsBuilder: (textEditingValue) async {
                    if (state._suggestions == null) {
                      return <String>[];
                    } else {
                      final matches = <String>[];
                      matches.addAll(state._suggestions!);

                      matches.retainWhere((s) {
                        return s
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });

                      return matches;
                    }
                  },
                  onSelected: (value) {
                    /// обновляем значение поля
                    state.didChange(value);
                  },
                  optionsViewBuilder: (context, onSelected, options) => Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: theme.colorScheme.surface,
                      surfaceTintColor: theme.colorScheme.surfaceTint,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(4.0),
                      child: Container(
                        width: constraints.maxWidth,
                        height: min(40.0 * options.length, 40.0 * 3.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);

                            return ListTile(
                              onTap: () {
                                onSelected(option);
                              },
                              dense: true,
                              title: Text(
                                option,
                                style: const TextStyle(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  fieldViewBuilder: (context, textEditingController, focusNode,
                          onFieldSubmitted) =>
                      TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: decoration,
                    style: decoration.textStyle,
                    onTapOutside: (event) {
                      /// убираем фокус с поля
                      state.effectiveFocusNode.unfocus();
                    },
                    onSubmitted: onSubmitted,
                    enabled: state.enabled,
                  ),
                ),
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<KrsAutocompleteField, String> createState() =>
      _KrsAutocompleteFieldState();
}

class _KrsAutocompleteFieldState
    extends FormBuilderFieldDecorationState<KrsAutocompleteField, String> {
  TextEditingController? get _effectiveController => _controller;

  TextEditingController? _controller;

  Iterable<String>? _suggestions;

  @override
  void initState() {
    super.initState();

    /// загружаем все подсказки
    widget.asyncItems().then((items) {
      setState(() => _suggestions = items);
    });

    //setting this to value instead of initialValue here is OK since we handle initial value in the parent class
    _controller = TextEditingController(text: value);
    _controller!.addListener(_handleControllerChanged);

    effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    // Dispose the _controller when initState created it
    _controller!.removeListener(_handleControllerChanged);
    _controller!.dispose();

    effectiveFocusNode.removeListener(_handleFocusChanged);

    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = initialValue ?? '';
    });
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != (value ?? '')) {
      didChange(_effectiveController!.text);
    }
  }

  void _handleFocusChanged() {
    widget.onFocusChanged
        ?.call(effectiveFocusNode.hasFocus, _effectiveController?.text);
    setState(() {});
  }
}
