import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'krs_field_label.dart';
import 'krs_input_decoration.dart';

class KrsSegmentedField extends FormBuilderFieldDecoration<String?> {
  final Future<Map<String, dynamic>> Function() asyncOptions;
  final Widget Function(String?)? optionBuilder;

  KrsSegmentedField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    super.initialValue,
    required this.asyncOptions,
    this.optionBuilder,
    String? labelText,
  }) : super(
          builder: (FormFieldState<String?> field) {
            final state = field as _KrsSegmentedFieldState;
            final theme = Theme.of(state.context);

            /// загружаются ли элементы списка
            final loading = state._options == null;

            /// доступено ли поле для взаимодействия
            final enabledState = !loading && state.enabled;

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: enabledState,
              errorText: state.errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 5.5,
              ),
            );

            return KrsFieldLabel(
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              child: InputDecorator(
                decoration: decoration,
                child: SegmentedButton<String?>(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          if (states.contains(MaterialState.disabled)) {
                            return theme.colorScheme.primary.withOpacity(0.12);
                          } else {
                            return theme.colorScheme.primary.withOpacity(0.28);
                          }
                        }

                        return null;
                      },
                    ),
                    textStyle: MaterialStateProperty.all(decoration.textStyle),
                    side: MaterialStateProperty.all(BorderSide.none),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: decoration.borderRadius,
                    )),
                  ),
                  showSelectedIcon: false,
                  segments: state._options ??
                      [const ButtonSegment(value: null, label: Text(''))],
                  selected: {state.value},
                  onSelectionChanged: !enabledState
                      ? null
                      : (selection) {
                          state.didChange(selection.first);
                        },
                ),
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<KrsSegmentedField, String?> createState() =>
      _KrsSegmentedFieldState();
}

class _KrsSegmentedFieldState
    extends FormBuilderFieldDecorationState<KrsSegmentedField, String?> {
  List<ButtonSegment<String>>? _options;

  @override
  void initState() {
    super.initState();

    effectiveFocusNode.addListener(_handleFocusChanged);

    widget.asyncOptions.call().then((asyncItems) {
      _options = asyncItems.entries.map((entry) {
        final id = entry.key;
        final value = entry.value;
        final child = widget.optionBuilder?.call(value) ?? Text('$value');

        return ButtonSegment(value: id, label: child);
      }).toList();

      /// обновляем состояние виджета
      setState(() {});
    });
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_handleFocusChanged);

    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }
}
