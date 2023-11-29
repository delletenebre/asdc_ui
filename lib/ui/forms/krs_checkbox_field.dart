import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'krs_field_label.dart';
import 'krs_input_decoration.dart';

class KrsCheckboxField extends FormBuilderFieldDecoration<bool> {
  
  KrsCheckboxField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    
    bool? initialValue,
    String? labelText,
    required String titleText,
    String disabledTooltip = '',
    
  }) :
    super(
      initialValue: initialValue,
      builder: (FormFieldState<bool?> field) {
        final state = field as _KrsChekboxFieldState;

        return Tooltip(
          message: !state.enabled ? disabledTooltip : '',
          child: KrsFieldLabel(
            hasError: state.hasError,
            labelText: labelText,
            child: LabeledSwitch(
              enabled: state.enabled,
              value: state.value == true,
              title: Text(titleText),
              errorText: state.errorText ?? '',
              onChanged: !state.enabled ? null : (value) {
                /// обновляем значение поля
                state.didChange(value);
              },
            ),
          ),
        );
      },
    );
  
  @override
  FormBuilderFieldDecorationState<KrsCheckboxField, bool> createState() =>
      _KrsChekboxFieldState();
}

class _KrsChekboxFieldState
    extends FormBuilderFieldDecorationState<KrsCheckboxField, bool> {
}

class LabeledSwitch extends StatelessWidget {
  final FocusNode? focusNode;
  final bool enabled;
  final Widget? title;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String errorText;

  const LabeledSwitch({
    super.key,
    this.focusNode,
    this.enabled = true,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0,),
    required this.value,
    required this.onChanged,
    this.errorText = '',
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    final enabled = onChanged != null;

    final decoration = KrsInputDecoration(theme: theme);

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 37.0,
            child: InkWell(
              borderRadius: decoration.borderRadius,
              focusNode: focusNode,
              onTap: onChanged == null ? null : () {
                onChanged?.call(!value);
              },
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        height: 28.0,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Checkbox(
                            isError: errorText.isNotEmpty,
                            activeColor: enabled ? null : theme.colorScheme.outline,
                            focusNode: FocusNode(
                              skipTraversal: true,
                            ),
                            value: value,
                            onChanged: !enabled ? null : (newValue) {
                              onChanged?.call(newValue == true);
                            },
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: DefaultTextStyle(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: enabled
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.outline,
                          fontSize: 13.0,
                        ),
                        child: title ?? const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
          ),

          if (errorText.isNotEmpty) Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0,),
            child: Text(errorText,
              maxLines: decoration.errorMaxLines,
              overflow: TextOverflow.ellipsis,
              style: decoration.errorStyle,
            ),
          ),

        ],
    );
  }
}