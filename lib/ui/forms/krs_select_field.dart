import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../resources/krs_locale.dart';
import '../dialogs/dialog_view.dart';
import '../empty_state_view.dart';
import 'krs_field_label.dart';
import 'krs_field_loading_button.dart';
import 'krs_input_decoration.dart';
import 'krs_search_text_field.dart';

class KrsSelectField<T, K> extends FormBuilderFieldDecoration<T> {
  final List<T> pinnedIds;
  final Future<Map<T, K>> Function() asyncOptions;
  final Widget Function(K option)? optionBuilder;
  final String Function(K option) stringifiedSelectedOption;

  KrsSelectField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    super.initialValue,
    super.valueTransformer,
    required this.asyncOptions,
    this.optionBuilder,
    String Function(K option)? selectedOptionToString,
    String? labelText,
    bool filterEnabled = false,
    Map<T, dynamic> Function(String searchQuery, Map<T, K> options)? filter,
    this.pinnedIds = const [],
  })  : stringifiedSelectedOption =
            selectedOptionToString ?? ((option) => option.toString()),
        super(
          builder: (FormFieldState<T> field) {
            final state = field as _KrsDropdownFieldState<T, K>;
            final theme = Theme.of(state.context);
            final locale = KrsLocale.of(state.context);

            final stringifiedSelectedOption =
                selectedOptionToString ?? ((option) => option.toString());

            /// загружаются ли элементы списка
            final loading = state._options == null;

            /// доступено ли поле для взаимодействия
            final enabledState = !loading && state.enabled;

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: enabledState,
              errorText: state.errorText,
              hintText: 'Выберите вариант...',
              suffixIcon: loading
                  ? const KrsFieldLoadingButton()
                  : Row(
                      children: [
                        /// кнопка очистки выбранного варианта
                        if (state.value != null)
                          IconButton(
                            tooltip: locale.clear,
                            onPressed: () {
                              /// удаляем выбранный вариант
                              state.didChange(null);

                              /// обновляем поле
                              state._controller.clear();
                            },
                            icon: const Icon(Icons.clear_outlined),
                          ),

                        /// стрелочка выпадающего меню
                        const IconButton(
                          onPressed: null,
                          icon: Icon(Icons.arrow_drop_down_outlined),
                        ),
                      ],
                    ),
            );

            //final hasValue = state._items?.map((e) => e.value).contains(state.value) == true;

            return KrsFieldLabel(
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              child: InkWell(
                onTap: enabledState ? () {} : null,
                child: TextField(
                    controller: state._controller,
                    decoration: decoration,
                    mouseCursor: MaterialStateMouseCursor.clickable,
                    readOnly: true,
                    style: decoration.textStyle,
                    enableInteractiveSelection: false,
                    enabled: enabled,
                    onTap: !enabledState
                        ? null
                        : () async {
                            await showDialog(
                                context: state.context,
                                builder: (context) {
                                  Map<T, dynamic> options = state._options!;

                                  return DialogView(
                                    width: 400.0,
                                    title: labelText != null
                                        ? Text(labelText)
                                        : const SizedBox(),
                                    contentPadding: 0.0,
                                    actions: const [],
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
                                                    if (value.isEmpty) {
                                                      options = state._options!;
                                                    } else {
                                                      final searchQuery =
                                                          value.toLowerCase();

                                                      options = filter?.call(
                                                              searchQuery,
                                                              state
                                                                  ._options!) ??
                                                          Map.fromEntries(state
                                                              ._options!.entries
                                                              .where((item) {
                                                            return stringifiedSelectedOption(
                                                                    item.value)
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchQuery);
                                                          }));
                                                    }

                                                    setState(() {});
                                                  },
                                                ),
                                              ),

                                            if (options.isEmpty)
                                              const Padding(
                                                padding: EdgeInsets.all(24.0),
                                                child: EmptyStateView(
                                                  icon: Icon(Icons
                                                      .data_array_outlined),
                                                  child: Text(
                                                    'Данные не найдены. Попробуйте изменить поисковой запрос',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            if (options.isNotEmpty)
                                              ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxHeight: 480.0,
                                                ),
                                                child: ListView.separated(
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  separatorBuilder:
                                                      (context, index) {
                                                    if (index ==
                                                            pinnedIds.length -
                                                                1 &&
                                                        state._options!
                                                                .length ==
                                                            options.length) {
                                                      return const Divider(
                                                        height: 1.0,
                                                        indent: 12.0,
                                                        endIndent: 12.0,
                                                      );
                                                    }
                                                    return const SizedBox();
                                                  },
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final id = options.keys
                                                        .elementAt(index);
                                                    final item = options.values
                                                        .elementAt(index);
                                                    final title = optionBuilder
                                                            ?.call(item) ??
                                                        Text('$item');

                                                    return ListTile(
                                                      dense: true,
                                                      title: title,
                                                      leading: id != state.value
                                                          ? null
                                                          : const Icon(
                                                              Icons.check,
                                                              size: 20.0),
                                                      onTap: () {
                                                        /// обновляем значение поля
                                                        state.didChange(id);
                                                        // onChanged?.call(id, options[id]);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
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
                          }),
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<KrsSelectField<T, K>, T> createState() =>
      _KrsDropdownFieldState<T, K>();
}

class _KrsDropdownFieldState<T, K>
    extends FormBuilderFieldDecorationState<KrsSelectField<T, K>, T> {
  Map<T, K>? _options;

  final _controller = TextEditingController();

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

    widget.asyncOptions.call().then((items) {
      _options = items;

      if (widget.pinnedIds.isNotEmpty) {
        final pinned = <T, K>{};
        for (final pinnedKey in widget.pinnedIds) {
          if (items.containsKey(pinnedKey)) {
            pinned[pinnedKey] = items[pinnedKey] as K;
            _options?.removeWhere((key, value) => pinnedKey == key);
          }
        }

        _options = {...pinned, ..._options!};
      }

      if (_options!.containsKey(value)) {
        _controller.text =
            widget.stringifiedSelectedOption(_options![value] as K);
      }

      /// обновляем состояние виджета
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    effectiveFocusNode.removeListener(_handleFocusChanged);

    super.dispose();
  }

  @override
  void didChange(value) {
    super.didChange(value);

    if (_options?.containsKey(value) == true) {
      _controller.text =
          widget.stringifiedSelectedOption(_options![value] as K);
    }
  }

  void _handleFocusChanged() {
    setState(() {});
  }
}
