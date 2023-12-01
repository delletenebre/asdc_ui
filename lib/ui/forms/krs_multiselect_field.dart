import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../resources/asdc_locale.dart';
import '../dialogs/dialog_view.dart';
import '../empty_state_view.dart';
import 'krs_field_label.dart';
import 'krs_field_loading_button.dart';
import 'krs_input_decoration.dart';
import 'krs_search_text_field.dart';

class KrsMultiselectField<T, K> extends FormBuilderFieldDecoration<List<T>> {
  final Future<Map<T, K>> Function() asyncOptions;
  final Widget Function(K item)? optionBuilder;
  final String Function(K item) optionToString;

  KrsMultiselectField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    super.initialValue,
    super.valueTransformer,
    required this.asyncOptions,
    this.optionBuilder,
    required this.optionToString,
    String? labelText,
    bool filterEnabled = false,
    int maxSelected = 0,
  }) : super(
          builder: (FormFieldState<List<T>> field) {
            final state = field as _KrsDropdownFieldState<T, K>;
            final theme = Theme.of(state.context);
            final locale = AsdcLocale.of(state.context);

            /// загружаются ли элементы списка
            final loading = state._options == null;

            /// доступено ли поле для взаимодействия
            final enabledState = !loading && state.enabled;

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: enabledState,
              errorText: state.errorText,
              hintText: '${locale.selectOptions}...',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              suffixIcon: loading
                  ? const KrsFieldLoadingButton()
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: Icon(Icons.arrow_drop_down, size: 20.0)),
            );

            return KrsFieldLabel(
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              child: InkWell(
                onTap: enabledState
                    ? () async {
                        Set<T> tempValues = {...state.value ?? []};

                        await showDialog(
                            context: state.context,
                            builder: (context) {
                              Map<T, dynamic> options = state._options!;

                              return DialogView(
                                width: 360.0,
                                title: labelText != null
                                    ? Text(labelText)
                                    : const SizedBox(),
                                contentPadding: 0.0,
                                actions: [
                                  FilledButton(
                                    onPressed: () {
                                      state.didChange(tempValues.toList());

                                      /// закрываем диалоговое окно
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(locale.apply),
                                  ),
                                ],
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    if (state._options!.isEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: EmptyStateView(
                                          icon: const Icon(
                                              Icons.data_array_outlined),
                                          child: Text(
                                            locale.noDataAvailable,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: [
                                        /// текстовое поле фильтра
                                        if (filterEnabled)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 12.0,
                                              left: 12.0,
                                              right: 12.0,
                                            ),
                                            child: KrsSearchTextField(
                                              onChanged: (value) {
                                                // if (value.isEmpty) {
                                                //   options = state._options!;
                                                // } else {
                                                //   final searchQuery =
                                                //       value.toLowerCase();

                                                //   options = filter?.call(
                                                //           searchQuery,
                                                //           state._options!) ??
                                                //       Map.fromEntries(state
                                                //           ._options!.entries
                                                //           .where((item) {
                                                //         return stringifiedSelectedOption(
                                                //                 item.value)
                                                //             .toLowerCase()
                                                //             .contains(
                                                //                 searchQuery);
                                                //       }));
                                                // }
                                                final searchQuery =
                                                    value.toLowerCase();
                                                options = Map.fromEntries(state
                                                    ._options!.entries
                                                    .where((item) {
                                                  return optionToString(
                                                          item.value)
                                                      .toLowerCase()
                                                      .contains(searchQuery);
                                                }));

                                                setState(() {});
                                              },
                                            ),
                                          ),

                                        if (options.isEmpty)
                                          const Padding(
                                            padding: EdgeInsets.all(24.0),
                                            child: EmptyStateView(
                                              icon: Icon(
                                                  Icons.data_array_outlined),
                                              child: Text(
                                                'Данные не найдены. Попробуйте изменить поисковой запрос',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        if (options.length > 1)
                                          Column(
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: CheckboxListTile(
                                                  tristate: true,
                                                  dense: true,
                                                  enabled: maxSelected == 0 ||
                                                      tempValues.isNotEmpty,
                                                  onChanged: (value) {
                                                    tempValues = (value == true)
                                                        ? options.keys.toSet()
                                                        : {};

                                                    setState(() {});
                                                  },
                                                  value: tempValues.length ==
                                                          options.length
                                                      ? true
                                                      : tempValues.isNotEmpty
                                                          ? null
                                                          : false,
                                                  title: Text(
                                                    locale.selectAll,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        if (options.isNotEmpty)
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 300.0,
                                            ),
                                            child: ListView.separated(
                                              primary: false,
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider(
                                                    height: 0.0);
                                              },
                                              itemCount: options.length,
                                              itemBuilder: (context, index) {
                                                final id = options.keys
                                                    .elementAt(index);
                                                final item = options.values
                                                    .elementAt(index);
                                                final title =
                                                    optionBuilder?.call(item) ??
                                                        Text('$item');

                                                return CheckboxListTile(
                                                  enabled: maxSelected == 0 ||
                                                      tempValues.length <
                                                          maxSelected ||
                                                      (maxSelected > 0 &&
                                                          tempValues
                                                              .contains(id)),
                                                  dense: true,
                                                  title: title,
                                                  onChanged: (bool? value) {
                                                    if (value != null) {
                                                      final values = {
                                                        ...tempValues,
                                                        id
                                                      };

                                                      if (value) {
                                                        values.add(id);
                                                      } else {
                                                        values.remove(id);
                                                      }

                                                      /// сортировка в порядке как asyncItems
                                                      final a = <T>[...values];
                                                      final b = <T>[];
                                                      for (final key in state
                                                          ._options!.keys) {
                                                        if (a.contains(key)) {
                                                          b.add(key);
                                                        }
                                                      }

                                                      setState(() {
                                                        tempValues = b.toSet();
                                                      });
                                                    }
                                                  },
                                                  value:
                                                      tempValues.contains(id),
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            });
                      }
                    : null,
                child: InputDecorator(
                  decoration: decoration,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Builder(
                        builder: (context) {
                          if (state._options == null) {
                            return Text(
                              '',
                              style: decoration.hintStyle,
                            );
                          }

                          final items = state._options!;

                          final value = (state.value ?? [])
                              .where((element) => items.containsKey(element));

                          if (value.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 6.0),
                              child: Text(
                                decoration.hintText ?? '',
                                style: decoration.hintStyle,
                              ),
                            );
                          } else {
                            bool addMore = value.length > 5;

                            return Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: [
                                ...value.take(5).map((item) {
                                  return Chip(
                                    backgroundColor: enabled
                                        ? theme.colorScheme.surface
                                        : theme.colorScheme.outline
                                            .withOpacity(0.12),
                                    label:
                                        optionBuilder?.call(items[item] as K) ??
                                            Text('${items[item]}'),
                                    labelStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: enabled
                                          ? theme.colorScheme.onSurfaceVariant
                                          : theme.colorScheme.onSurfaceVariant
                                              .withOpacity(0.62),
                                    ),
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    visualDensity: const VisualDensity(
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                    deleteIconColor:
                                        theme.colorScheme.onSurfaceVariant,
                                    side: BorderSide(
                                      color: enabled
                                          ? theme.colorScheme.outline
                                          : theme.colorScheme.outline
                                              .withOpacity(0.12),
                                    ),
                                    onDeleted: !enabled
                                        ? null
                                        : () {
                                            if (state.value != null) {
                                              final values = [...state.value!]
                                                ..remove(item);
                                              state.didChange(values);

                                              // onChanged?.call(values);
                                            }
                                          },
                                  );
                                }).toList(),
                                if (addMore) Text('и ещё ${value.length - 5}'),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<KrsMultiselectField<T, K>, List<T>>
      createState() => _KrsDropdownFieldState<T, K>();
}

class _KrsDropdownFieldState<T, K> extends FormBuilderFieldDecorationState<
    KrsMultiselectField<T, K>, List<T>> {
  Map<T, K>? _options;

  final _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    effectiveFocusNode.addListener(_handleFocusChanged);

    widget.asyncOptions.call().then((items) {
      _options = items;

      /// обновляем состояние виджета
      setState(() {});
    });
  }

  @override
  void dispose() {
    _filterController.dispose();

    effectiveFocusNode.removeListener(_handleFocusChanged);

    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }
}
