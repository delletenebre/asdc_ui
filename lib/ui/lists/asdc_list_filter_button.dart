import 'package:flutter/material.dart';

import '../../../extensions/date_time_extensions.dart';
import '../../resources/asdc_locale.dart';
import '../forms/krs_forms.dart';
import 'asdc_list_filter.dart';

class AsdcListFilterButton extends StatefulWidget {
  final List<AsdcListFilter> options;
  final Function()? onClose;
  final Function(AsdcListFilter value)? onApply;

  const AsdcListFilterButton({
    super.key,
    this.options = const [],
    this.onClose,
    this.onApply,
  });

  @override
  State<AsdcListFilterButton> createState() => _AsdcListFilterButtonState();
}

class _AsdcListFilterButtonState extends State<AsdcListFilterButton> {
  final formKey = GlobalKey<FormBuilderState>();
  late AsdcListFilter selectedOption = widget.options.first;
  dynamic seletedValue;

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final locale = AsdcLocale.of(context);

    if (widget.options.isEmpty) {
      return const SizedBox();
    }

    final now = DateTime.now();

    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(12.0),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FormBuilder(
              key: formKey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180.0,
                    child: KrsDropdownField(
                      name: 'filter_field_name',
                      labelText: locale.field,
                      initialValue: selectedOption.value.name,
                      asyncOptions: () async {
                        return {
                          for (final option in widget.options)
                            option.name: option.label
                        };
                      },
                      onChanged: (name) {
                        final option = widget.options
                            .singleWhere((element) => element.name == name);
                        selectedOption = option;
                        seletedValue.value = null;

                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  SizedBox(
                    width: 180.0,
                    child: switch (selectedOption.value.type) {
                      AsdcListFilterType.text => KrsTextField(
                          labelText: locale.value,
                          name: 'filter_field_value',
                          onChanged: (value) {
                            seletedValue.value = value;
                          },
                        ),
                      AsdcListFilterType.date => KrsDateField(
                          labelText: locale.value,
                          name: 'filter_field_value',
                          firstDate: now.subDate(years: 100),
                          lastDate: now.addDate(years: 1),
                          onChanged: (value) {
                            seletedValue.value = value;
                          },
                        ),
                      AsdcListFilterType.select => KrsDropdownField(
                          name: 'filter_field_value',
                          labelText: locale.value,
                          asyncOptions: selectedOption.value.asyncOptions!,
                          onChanged: (key) async {
                            final values =
                                await selectedOption.value.asyncOptions!();
                            seletedValue.value = values[key];
                          },
                        ),
                      AsdcListFilterType.multiselect =>
                        KrsMultiselectField<String, String>(
                          name: 'filter_field_value',
                          labelText: locale.value,
                          optionToString: (option) => option,
                          asyncOptions: selectedOption.value.asyncOptions!,
                          onChanged: (value) async {
                            final values =
                                await selectedOption.value.asyncOptions!();
                            seletedValue.value = value?.map((key) {
                              return values[key];
                            }).toList();
                          },
                        ),
                      Object() => null,
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onClose?.call();
                  },
                  child: Text(locale.close),
                ),
                TextButton(
                  onPressed: () {
                    if (seletedValue.value != null &&
                        seletedValue.value.toString().isNotEmpty) {
                      formKey.currentState?.save();
                      final formData = formKey.currentState?.value;
                      widget.onApply?.call(selectedOption.value.copyWith(
                        value: seletedValue.value,
                        formValue: formData?.valueFor('filter_field_value'),
                      ));
                    }

                    widget.onClose?.call();
                  },
                  child: Text(locale.apply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}