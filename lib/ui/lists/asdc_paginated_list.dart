import 'package:asdc_ui/extensions/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../extensions/theme_data_extensions.dart';
import '../../models/laravel_error.dart';
import '../../models/paginators/paginator.dart';
import '../../resources/asdc_locale.dart';
import '../forms/asdc_forms.dart';
import 'asdc_list_filter.dart';
import 'asdc_list_filter_button.dart';

class AsdcPaginatedList<T> extends StatefulWidget {
  final bool loading;
  final Object? error;
  final Paginator<T>? paginator;

  final List<Widget Function(BuildContext context, T item)> cellBuilders;
  final void Function(T item)? onTap;

  final void Function(PaginatorState paginatorState) onPaginationChanged;

  final List<PaginatedListColumn> columns;

  final List<AsdcListFilter> filterOptions;

  final List<Widget> actions;

  const AsdcPaginatedList({
    super.key,
    this.loading = false,
    this.error,
    required this.paginator,
    required this.cellBuilders,
    this.onTap,
    required this.onPaginationChanged,
    required this.columns,
    this.filterOptions = const [],
    this.actions = const [],
  }) : assert(cellBuilders.length == columns.length);

  @override
  State<AsdcPaginatedList<T>> createState() => _AsdcPaginatedListState<T>();
}

class _AsdcPaginatedListState<T> extends State<AsdcPaginatedList<T>> {
  /// состояние меню добавления фильтра (открыто/закрыто)
  bool _isFilterMenuOpen = false;
  bool get isFilterMenuOpen => _isFilterMenuOpen;
  set isFilterMenuOpen(bool value) => setState(() => _isFilterMenuOpen = value);

  /// список добавленных фильтров
  List<AsdcListFilter> enabledFilters = <AsdcListFilter>[];

  /// ключ формы
  final formKey = GlobalKey<FormBuilderState>();

  late PaginatorState _paginatorState = PaginatorState(
    page: widget.paginator?.currentPage ?? 1,
    perPage: widget.paginator?.perPage ?? 10,
    sortBy: '',
    sortDirection: '',
    filters: {
      for (final option in enabledFilters) option.name: option.formValue
    },
  );

  /// функция при изменении состояния формы
  get onFormChanged => () {
        /// обновляем номер страницы
        formKey.currentState?.fields['page']
            ?.didChange(_paginatorState.page.toString());

        _paginatorState = _paginatorState.copyWith(
          filters: {
            for (final option in enabledFilters) option.name: option.formValue
          },
        );

        widget.onPaginationChanged(_paginatorState);
      };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final locale = AsdcLocale.of(context);

    if (widget.error != null) {
      /// ^ если произошла ошибка
      if (widget.error is LaravelError) {
        //return ErrorStateView(message: (error as LaravelError).message);
      }
    }

    if (widget.paginator == null) {
      /// ^ если данные ещё не загружены
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Material(
      elevation: 1,
      color: theme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12.0),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// виджет фильтра
                    if (widget.filterOptions.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12.0,
                          runSpacing: 12.0,
                          children: [
                            /// кнопка открытия меню добавления фильтров
                            TextButton.icon(
                              onPressed: () {
                                isFilterMenuOpen = !isFilterMenuOpen;
                              },
                              icon: const Icon(
                                Icons.filter_list_outlined,
                              ),
                              label: Text(locale.search),
                            ),

                            /// текст, если условия фитра не заданы
                            if (enabledFilters.isEmpty)
                              Text(
                                'Условия поиска не заданы',
                                style: TextStyle(
                                  color: theme.colorScheme.outline,
                                ),
                              ),

                            /// список условий фильтра
                            if (enabledFilters.isNotEmpty)
                              ...enabledFilters.mapIndexed((index, filter) {
                                return Chip(
                                  side: BorderSide.none,
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  label: Text(
                                    '${filter.label}: ${filter.value}',
                                  ),
                                  onDeleted: () {
                                    /// ^ при удалении фильтра

                                    /// создаём копию заданных условий
                                    final filters = [...enabledFilters];

                                    /// удаляем фильтр
                                    filters.removeAt(index);

                                    /// обновляем поле заданных фильтров
                                    enabledFilters = filters;
                                    onFormChanged();
                                  },
                                );
                              }).toList(),
                          ],
                        ),
                      ),

                    if (widget.actions.isNotEmpty) const SizedBox(width: 12.0),

                    ...widget.actions
                  ],
                ),
              ),

              /// виджет данных
              _DataView<T>(
                data: widget.paginator!.data,
                columns: widget.columns,
                rowBuilders: widget.cellBuilders,
                onSortChanged: (sortBy, sortDirection) {
                  _paginatorState = _paginatorState.copyWith(
                    sortBy: sortBy,
                    sortDirection: sortDirection,
                  );
                  onFormChanged();
                },
                onTap: widget.onTap,
              ),

              /// навигация по данным (номер страницы, количество результатов)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FormBuilder(
                  key: formKey,
                  initialValue: {
                    'per_page': _paginatorState.perPage,
                    'page': _paginatorState.page.toString(),
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        locale.rowsPerPage,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(width: 6.0),

                      /// поле выбора количества результатов на странице
                      SizedBox(
                        width: 80.0,
                        child: KrsDropdownField<int>(
                          isDense: true,
                          padding: EdgeInsets.zero,
                          name: 'per_page',
                          asyncOptions: () async => {
                            10: '10',
                            25: '25',
                            50: '50',
                            100: '100',
                          },
                          onChanged: (perPage) {
                            _paginatorState = _paginatorState.copyWith(
                              perPage: perPage,
                            );
                            onFormChanged();
                          },
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Text(
                        locale.tableDataOf(
                          widget.paginator!.from,
                          widget.paginator!.to,
                          widget.paginator!.total,
                        ),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 24.0),

                      /// кнопка перехода на первую страницу
                      IconButton(
                        onPressed: !widget.paginator!.firstPageEnabled
                            ? null
                            : () {
                                _paginatorState = _paginatorState.copyWith(
                                  page: 1,
                                );
                                onFormChanged();
                              },
                        tooltip: locale.firstPage,
                        icon: const Icon(Icons.first_page_outlined),
                      ),

                      /// кнопка перехода на предыдущую страницу
                      IconButton(
                        onPressed: !widget.paginator!.hasPreviousPage
                            ? null
                            : () {
                                _paginatorState = _paginatorState.copyWith(
                                  page: _paginatorState.page - 1,
                                );
                                // currentPage = widget.paginator!.currentPage - 1;
                                onFormChanged();
                              },
                        tooltip: locale.previousPage,
                        icon: const Icon(Icons.chevron_left_outlined),
                      ),

                      /// поле выбора номера страницы
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          width: 64.0,
                          child: KrsTextField(
                            isDense: true,
                            padding: EdgeInsets.zero,
                            name: 'page',
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              final page =
                                  int.tryParse(value) ?? _paginatorState.page;
                              if (page != _paginatorState.page) {
                                _paginatorState = _paginatorState.copyWith(
                                  page: page,
                                );
                                onFormChanged();
                              }
                            },
                            // onChanged: (value) {
                            //   final page =
                            //       int.tryParse(value ?? '') ?? _paginatorState.page;
                            //   if (page != _paginatorState.page) {
                            //     _paginatorState = _paginatorState.copyWith(
                            //       page: page,
                            //     );
                            //     onFormChanged();
                            //   }
                            // },
                          ),
                        ),
                      ),

                      /// кнопка перехода на следующую страницу
                      IconButton(
                        onPressed: !widget.paginator!.hasNextPage
                            ? null
                            : () {
                                _paginatorState = _paginatorState.copyWith(
                                  page: _paginatorState.page + 1,
                                );
                                onFormChanged();
                              },
                        tooltip: locale.nextPage,
                        icon: const Icon(Icons.chevron_right_outlined),
                      ),

                      /// кнопка перехода на последнюю страницу
                      IconButton(
                        onPressed: !widget.paginator!.lastPageEnabled
                            ? null
                            : () {
                                _paginatorState = _paginatorState.copyWith(
                                  page: widget.paginator!.lastPage,
                                );
                                onFormChanged();
                              },
                        tooltip: locale.lastPage,
                        icon: const Icon(Icons.last_page_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// если идёт загрузка, приглушаем цвета результатов
          if (widget.loading)
            Container(
              color: theme.colorScheme.surface.withOpacity(0.62),
            ),

          /// если открыто меню добавления условия фильтра
          Visibility(
            visible: isFilterMenuOpen,
            child: Positioned(
              top: 12.0,
              left: 12.0,
              child: AsdcListFilterButton(
                options: widget.filterOptions,
                onClose: () {
                  isFilterMenuOpen = false;
                },
                onApply: (option) {
                  /// ^ при нажатии Применить

                  /// создаём копию включенных фильтров
                  final filters = [...enabledFilters];

                  /// находим индекс фильтра, если он есть в добавленных фильтрах
                  final sameFilterIndex = filters
                      .indexWhere((element) => element.name == option.name);
                  if (sameFilterIndex > -1) {
                    /// ^ если добавляемое условие уже есть в добавленных фильтрах

                    /// удаляем фильтр
                    filters.removeAt(sameFilterIndex);

                    /// добавляем новый фильтр на тоже место в списке
                    filters.insert(sameFilterIndex, option);
                  } else {
                    /// ^ если добавляемого условия нет в добавленных фильтрах

                    /// добавляем новый фильтр
                    filters.add(option);
                  }

                  /// обновляем поле включенных фильтров
                  enabledFilters = filters;

                  onFormChanged();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaginatedListColumn {
  final String label;
  final String field;
  final double width;
  final Alignment? align;

  const PaginatedListColumn({
    this.label = '',
    this.field = '',
    this.width = 0.0,
    this.align,
  });
}

class _DataView<T> extends StatefulWidget {
  final List<T> data;
  final List<PaginatedListColumn> columns;
  final List<Widget Function(BuildContext context, T item)> rowBuilders;

  /// функция при изменении порядка сортировки по столбцам
  final void Function(String sortBy, String direction) onSortChanged;

  final void Function(T item)? onTap;

  const _DataView({
    super.key,
    required this.data,
    required this.columns,
    required this.rowBuilders,
    required this.onSortChanged,
    this.onTap,
  }) : assert(rowBuilders.length == columns.length);

  @override
  State<_DataView<T>> createState() => _DataViewState<T>();
}

class _DataViewState<T> extends State<_DataView<T>> {
  int _hoveredRow = -1;
  int get hoveredRow => _hoveredRow;
  set hoveredRow(int value) => {setState(() => _hoveredRow = value)};

  /// поле по которому включена сортировка
  String sortBy = '';

  /// направление сортировки (по возрастанию/по убыванию)
  String sortDirection = '';

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return SizedBox(
      /// + 2 - заголовки столбцов + нижняя панель
      height: (widget.data.length + 1) * 44.0,
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 12.0,
        ),
        child: TableView.builder(
          primary: false,
          pinnedRowCount: 1,
          cellBuilder: (context, vicinity) {
            if (vicinity.row == 0) {
              /// ^ если первая строка

              final column = widget.columns[vicinity.column];

              /// возвращаем заголовки таблицы
              return InkWell(
                onTap: column.field.isEmpty
                    ? null
                    : () {
                        /// ^ при нажатии на столбец

                        if (sortBy == column.field) {
                          /// ^ если по столбцу уже включена сортировка
                          if (sortDirection == 'desc') {
                            /// ^ если направление сортировки по убыванию

                            /// ставим сортировку по возрастанию
                            sortDirection = 'asc';
                          } else {
                            /// ^ если направление сортировки по возрастанию

                            /// ставим сортировку по убыванию
                            sortDirection = 'desc';
                          }
                        } else {
                          /// ^ если по полю не осуществляется сортировка

                          /// ставим сортировку по убыванию
                          sortDirection = 'desc';
                        }

                        /// обновляем поле, по которому осуществляется сортировка
                        sortBy = column.field;

                        widget.onSortChanged(sortBy, sortDirection);
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            column.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),

                        /// стрелки направления сортировки
                        if (sortBy == column.field && column.field.isNotEmpty)
                          Icon(
                            sortDirection == 'desc'
                                ? Icons.arrow_downward_outlined
                                : Icons.arrow_upward_outlined,
                            color: theme.colorScheme.outline,
                            size: 14.0,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }

            /// возвращаем ячейки таблицы
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onTap?.call(widget.data[vicinity.row - 1]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: widget.columns[vicinity.column].align ??
                      Alignment.centerLeft,
                  child: widget.rowBuilders[vicinity.column](
                      context, widget.data[vicinity.row - 1]),
                ),
              ),
            );
          },
          columnCount: widget.columns.length,
          columnBuilder: (int index) {
            return TableSpan(
              // foregroundDecoration: const TableSpanDecoration(
              //   border: TableSpanBorder(
              //     trailing: BorderSide(),
              //   ),
              // ),
              extent: index == widget.columns.length - 1
                  ? MaxTableSpanExtent(
                      FixedTableSpanExtent(widget.columns[index].width),
                      const RemainingTableSpanExtent())
                  : FixedTableSpanExtent(widget.columns[index].width),
              cursor: SystemMouseCursors.contextMenu,
            );
          },
          rowCount: widget.data.length + 1,
          rowBuilder: (int index) {
            if (index == 0) {
              /// ^ если первая строка

              /// возвращаем заголовки таблицы
              return TableSpan(
                backgroundDecoration: TableSpanDecoration(
                  border: TableSpanBorder(
                    trailing: BorderSide(
                      width: 1,
                      color: theme.colorScheme.outline.withOpacity(0.36),
                    ),
                  ),
                ),
                extent: const FixedTableSpanExtent(44),
                cursor: SystemMouseCursors.basic,
                onEnter: (event) {},
              );
            }

            return TableSpan(
              backgroundDecoration: TableSpanDecoration(
                // border: const TableSpanBorder(
                //   trailing: BorderSide(
                //     width: 1,
                //   ),
                // ),
                color: hoveredRow == index
                    ? theme.colorScheme.primary.withOpacity(0.08)
                    : null,
              ),
              extent: const FixedTableSpanExtent(44),
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                hoveredRow = index;
              },
              onExit: (event) {
                hoveredRow = -1;
              },
            );
          },
        ),
      ),
    );
  }
}
