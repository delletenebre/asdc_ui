import 'package:flutter/material.dart';

import '../../../extensions/date_time_extensions.dart';
import '../../../extensions/map_extensions.dart';
import '../../l10n/app_localizations.dart';
import '../../models/country.dart';
import '../forms/asdc_forms.dart';
import 'asdc_list_filter.dart';

class AsdcListFilterButton<T> extends StatefulWidget {
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
  State<AsdcListFilterButton<T>> createState() =>
      _AsdcListFilterButtonState<T>();
}

class _AsdcListFilterButtonState<T> extends State<AsdcListFilterButton<T>> {
  final formKey = GlobalKey<FormBuilderState>();
  late AsdcListFilter selectedOption = widget.options.first;
  dynamic seletedValue;

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final locale = lookupAppLocalizations(Locale('ru'));

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
                      labelText: 'Поле',
                      initialValue: selectedOption.name,
                      asyncOptions: () async {
                        return {
                          for (final option in widget.options)
                            option.name: option.label
                        };
                      },
                      onChanged: (name) {
                        final option = widget.options
                            .firstWhere((element) => element.name == name);
                        selectedOption = option;
                        seletedValue = null;

                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  SizedBox(
                    width: 180.0,
                    child: switch (selectedOption.type) {
                      AsdcListFilterType.text => KrsTextField(
                          labelText: 'Значение',
                          name: 'filter_field_value',
                          onChanged: (value) {
                            seletedValue = value;
                          },
                        ),
                      AsdcListFilterType.date => KrsDateField(
                          labelText: 'Значение',
                          name: 'filter_field_value',
                          firstDate: now.subDate(years: 100),
                          lastDate: now.addDate(years: 1),
                          onChanged: (value) {
                            seletedValue = value;
                          },
                        ),
                      AsdcListFilterType.select => Builder(
                          builder: (context) {
                            final asyncOptions = selectedOption.asyncOptions!
                                as Future<Map<Object, dynamic>> Function();

                            return KrsDropdownField(
                              name: 'filter_field_value',
                              labelText: 'Значение',
                              asyncOptions: asyncOptions,
                              onChanged: (key) async {
                                final values = await asyncOptions();
                                seletedValue = values[key];
                              },
                            );
                          },
                        ),
                      AsdcListFilterType.multiselect => Builder(
                          builder: (context) {
                            final asyncOptions = selectedOption.asyncOptions!
                                as Future<Map<String, String>> Function();

                            return KrsMultiselectField<String, String>(
                              name: 'filter_field_value',
                              labelText: 'Значение',
                              optionToString: (option) => option.toString(),
                              asyncOptions: asyncOptions,
                              onChanged: (value) async {
                                final values = await asyncOptions();
                                seletedValue = value?.map((key) {
                                  return values[key];
                                }).toList();
                              },
                            );
                          },
                        ),

                      /// поле выбора страны
                      AsdcListFilterType.country => Builder(
                          builder: (context) {
                            final asyncOptions = (selectedOption.asyncOptions
                                as Future<List<Country>> Function())();

                            return AsdcCountryField(
                              name: 'filter_field_value',
                              labelText: 'Значение',
                              asyncCountries: asyncOptions,
                              onChanged: (key) async {
                                final values = await asyncOptions;
                                seletedValue = values
                                    .firstWhere((element) => element.id == key,
                                        orElse: () => Country())
                                    .officialRu;
                              },
                            );
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
                    if (seletedValue != null &&
                        seletedValue.toString().isNotEmpty) {
                      formKey.currentState?.save();
                      final formData = formKey.currentState?.value;
                      widget.onApply?.call(selectedOption.copyWith(
                        value: seletedValue,
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
