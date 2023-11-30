import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'krs_field_label.dart';
import 'krs_input_decoration.dart';

class KrsDropdownField<T> extends FormBuilderFieldDecoration<T> {
  final Future<Map<T, dynamic>> Function() asyncOptions;
  final Widget Function(T)? itemBuilder;
  // final dynamic Function(T?)? valueTransformer;

  KrsDropdownField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    super.initialValue,
    super.valueTransformer,
    required this.asyncOptions,
    this.itemBuilder,
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 24.0),
    String? labelText,
    bool isDense = false,
  }) : super(
          builder: (FormFieldState<T> field) {
            final state = field as _KrsDropdownFieldState<T>;
            final theme = Theme.of(state.context);

            /// загружаются ли элементы списка
            final loading = state._options == null;

            /// доступено ли поле для взаимодействия
            final enabledState = !loading && state.enabled;

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: enabledState,
              errorText: state.errorText,
              contentPadding: isDense
                  ? const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    )
                  : const EdgeInsets.symmetric(
                      vertical: 10.5,
                      horizontal: 12.0,
                    ),
              isDense: isDense,
            );

            final hasValue =
                state._options?.map((e) => e.value).contains(state.value) ==
                    true;

            return KrsFieldLabel(
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              padding: padding,
              child: DropdownButtonFormField<T>(
                focusNode: state.effectiveFocusNode,
                isExpanded: true,
                decoration: decoration,
                borderRadius: decoration.borderRadius,
                padding: const EdgeInsets.all(0.0),
                style: decoration.textStyle,
                iconSize: 20.0,
                icon: loading
                    ? SizedBox.square(
                        dimension: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          color: theme.colorScheme.outline.withOpacity(0.36),
                        ),
                      )
                    : null,
                focusColor: Colors.transparent,
                value: hasValue ? state.value : null,
                items: state._options ?? [],
                selectedItemBuilder: (BuildContext context) {
                  return state._options?.map<Widget>((item) {
                        return DefaultTextStyle(
                          style: decoration.textStyle,
                          overflow: TextOverflow.ellipsis,
                          child: item.child,
                        );
                      }).toList() ??
                      [];
                },
                onChanged: !enabledState
                    ? null
                    : (value) {
                        /// обновляем значение поля
                        state.didChange(value);
                      },
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<KrsDropdownField<T>, T> createState() =>
      _KrsDropdownFieldState<T>();
}

class _KrsDropdownFieldState<T>
    extends FormBuilderFieldDecorationState<KrsDropdownField<T>, T> {
  List<DropdownMenuItem<T>>? _options;

  // @override
  // void didUpdateWidget(covariant FormBuilderDropdown<T> oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   final oldValues = oldWidget.items.map((e) => e.value).toList();
  //   final currentlyValues = widget.items.map((e) => e.value).toList();
  //   final oldChilds = oldWidget.items.map((e) => e.child.toString()).toList();
  //   final currentlyChilds =
  //       widget.items.map((e) => e.child.toString()).toList();

  //   if (!currentlyValues.contains(initialValue) &&
  //       !initialValue.emptyValidator()) {
  //     assert(
  //       currentlyValues.contains(initialValue) && initialValue.emptyValidator(),
  //       'The initialValue [$initialValue] is not in the list of items or is not null or empty. '
  //       'Please provide one of the items as the initialValue or update your initial value. '
  //       'By default, will apply [null] to field value',
  //     );
  //     setValue(null);
  //   }

  //   if ((!listEquals(oldChilds, currentlyChilds) ||
  //           !listEquals(oldValues, currentlyValues)) &&
  //       (currentlyValues.contains(initialValue) ||
  //           initialValue.emptyValidator())) {
  //     setValue(initialValue);
  //   }
  // }

  @override
  void initState() {
    super.initState();

    effectiveFocusNode.addListener(_handleFocusChanged);

    widget.asyncOptions.call().then((asyncItems) {
      _options = asyncItems.entries.map((entry) {
        final id = entry.key;
        final child =
            widget.itemBuilder?.call(entry.value) ?? Text('${entry.value}');

        return DropdownMenuItem(
          value: id,
          child: child,
        );
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
