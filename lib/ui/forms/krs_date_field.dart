import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../extensions/string_extensions.dart';
import '../../extensions/date_time_extensions.dart';
import 'krs_field_label.dart';
import 'krs_input_decoration.dart';

const inputDateFormat = 'dd.MM.yyyy';
const serverDateFormat = 'yyyy-MM-dd';

class KrsDateField extends FormBuilderFieldDecoration<String> {
  final DateTime firstDate;
  final DateTime lastDate;

  KrsDateField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    String? initialValue,
    String? labelText,
    required DateTime firstDate,
    required DateTime lastDate,
  })  : firstDate = firstDate.startOfDay!,
        lastDate = lastDate.endOfDay!,
        super(
          initialValue: initialValue,
          valueTransformer: (value) {
            /// пробуем сначала в серверном формате (если форма была заполнена
            /// начальными значениями) и затем в клиентском формате (если поле
            /// заполнял пользователь)
            final date =
                value.toDate(serverDateFormat) ?? value.toDate(inputDateFormat);

            /// форматитуем в серверный формат даты
            return date?.format(serverDateFormat) ?? value;
          },
          builder: (FormFieldState<String?> field) {
            final state = field as _KrsDateFieldState;
            final theme = Theme.of(state.context);

            final now = DateTime.now().startOfDay!;

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: state.enabled,
              errorText: state.errorText,
              hintText: 'дд.мм.гггг',
              suffixIcon: IconButton(
                focusNode: FocusNode(
                  skipTraversal: true,
                  canRequestFocus: false,
                ),
                tooltip: 'Открыть календарь',
                icon: const Icon(Icons.calendar_month_outlined),
                onPressed: () async {
                  // state._updateDatePickerCurrentDate();

                  DateTime currentValue =
                      state.value.toDate(inputDateFormat) ?? now;

                  if (currentValue.isAfter(lastDate) ||
                      currentValue.isBefore(firstDate)) {
                    currentValue = firstDate;
                  }

                  final picked = await showDatePicker(
                    context: state.context,
                    initialDate: currentValue,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  );

                  if (picked != null) {
                    /// обновляем значение поля
                    state.didChange(picked.format(inputDateFormat));
                  }
                },
              ),
            );

            return KrsFieldLabel(
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              child: TextField(
                controller: state._effectiveController,
                focusNode: state.effectiveFocusNode,
                decoration: decoration,
                keyboardType: TextInputType.number,
                // textInputAction: textInputAction,
                style: decoration.textStyle,

                // autofocus: autofocus,
                // readOnly: readOnly,

                autocorrect: false,
                enableSuggestions: false,
                // onTap: onTap,
                onTapOutside: (event) {
                  /// убираем фокус с поля
                  state.effectiveFocusNode.unfocus();
                },
                // onEditingComplete: onEditingComplete,
                // onSubmitted: onSubmitted,
                enabled: state.enabled,

                inputFormatters: [
                  state._maskFormatter,
                ],
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<KrsDateField, String> createState() =>
      _KrsDateFieldState();
}

class _KrsDateFieldState
    extends FormBuilderFieldDecorationState<KrsDateField, String> {
  TextEditingController? get _effectiveController => _controller;

  TextEditingController? _controller;

  final _maskFormatter = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  String? localFormatted(String? value) =>
      value.toDate(serverDateFormat).format(inputDateFormat);

  String? serverFormatted(String? value) =>
      value.toDate(inputDateFormat).format(serverDateFormat);

  @override
  void initState() {
    super.initState();

    //setting this to value instead of initialValue here is OK since we handle initial value in the parent class
    _controller = TextEditingController(text: localFormatted(value));
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
      _effectiveController!.text = localFormatted(initialValue) ?? '';
    });
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    final localFormattedValue =
        (value.toDate(serverDateFormat) ?? value.toDate(inputDateFormat))
            .format(inputDateFormat);
    if (_effectiveController!.text != value) {
      _effectiveController!.text = localFormattedValue;
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
    setState(() {});
  }
}
