import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../models/laravel_error.dart';
import '../../models/paginators/paginator.dart';
import '../../resources/asdc_locale.dart';
import '../forms/krs_forms.dart';

class PaginatedList<T> extends StatefulWidget {
  final bool loading;
  final Object? error;
  final Paginator? paginator;

  final List<Widget Function(BuildContext context, T item)> rowBuilders;
  final void Function(T item)? onTap;

  final void Function(PaginatorState paginatorState) onPaginationChanged;

  final List<PaginatedListColumn> columns;

  const PaginatedList({
    super.key,
    this.loading = false,
    this.error,
    required this.paginator,
    required this.rowBuilders,
    this.onTap,
    required this.onPaginationChanged,
    required this.columns,
  }) : assert(rowBuilders.length == columns.length);

  @override
  State<PaginatedList<T>> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedList<T>> {
  int hoveredRow = -1;

  /// текущий курсор
  late int currentPage = widget.paginator!.currentPage;

  /// количество результатов на странице
  late int perPage = widget.paginator!.perPage;

  /// ключ формы
  final formKey = GlobalKey<FormBuilderState>();

  /// поле по которому включена сортировка
  String sortBy = '';

  /// направление сортировки (по возрастанию/по убыванию)
  String sortDirection = '';

  /// функция при изменении состояния формы
  late final onFormChanged = () {
    /// обновляем номер страницы
    formKey.currentState?.fields['page']?.didChange(currentPage.toString());

    widget.onPaginationChanged(
      PaginatorState(
        page: currentPage,
        perPage: perPage,
        sortBy: sortBy,
        sortDirection: sortDirection,
        // filters: enabledFilters.value.convertToFormValues(),
      ),
    );
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

    return SizedBox(
      /// + 2 - заголовки столбцов + нижняя панель
      height: (widget.paginator!.data.length + 2) * 44.0,
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 12.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TableView.builder(
                primary: false,
                pinnedRowCount: 1,
                cellBuilder: (context, vicinity) {
                  if (vicinity.row == 0) {
                    /// ^ если первая строка

                    final column = widget.columns[vicinity.column];

                    /// возвращаем заголовки таблицы
                    return InkWell(
                      onTap: column.name.isEmpty
                          ? null
                          : () {
                              /// ^ при нажатии на столбец

                              if (sortBy == column.name) {
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
                              sortBy = column.name;

                              onFormChanged();
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
                              if (sortBy == column.name &&
                                  column.name.isNotEmpty)
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
                    onTap: () => widget.onTap
                        ?.call(widget.paginator!.data[vicinity.row - 1]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: widget.columns[vicinity.column].align ??
                            Alignment.centerLeft,
                        child: widget.rowBuilders[vicinity.column](
                            context, widget.paginator!.data[vicinity.row - 1]),
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
                rowCount: widget.paginator!.data.length + 1,
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

            /// навигация по данным (номер страницы, количество результатов)
            SizedBox(
              height: 44.0,
              child: FormBuilder(
                key: formKey,
                initialValue: {
                  'per_page': perPage,
                  'page': currentPage.toString(),
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      locale.rowsPerPage,
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(width: 6.0),

                    /// поле выбора количества результатов на странице
                    SizedBox(
                      width: 80.0,
                      child: KrsDropdownField<int>(
                        padding: EdgeInsets.zero,
                        name: 'per_page',
                        asyncOptions: () async => {
                          10: '10',
                          25: '25',
                          50: '50',
                          100: '100',
                        },
                        onChanged: (value) {
                          perPage = value!;
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
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(width: 24.0),

                    /// кнопка перехода на первую страницу
                    IconButton(
                      onPressed: !widget.paginator!.firstPageEnabled
                          ? null
                          : () {
                              currentPage = 1;
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
                              currentPage = widget.paginator!.currentPage - 1;
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
                          padding: EdgeInsets.zero,
                          isDense: true,
                          name: 'page',
                          onSubmitted: (value) {
                            final page = int.tryParse(value);
                            if (page != null) {
                              currentPage = page;
                              onFormChanged();
                            }
                          },
                        ),
                      ),
                    ),

                    /// кнопка перехода на следующую страницу
                    IconButton(
                      onPressed: !widget.paginator!.hasNextPage
                          ? null
                          : () {
                              currentPage = widget.paginator!.currentPage + 1;
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
                              currentPage = widget.paginator!.lastPage;
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
      ),
    );
  }
}

class PaginatedListColumn {
  final String label;
  final String name;
  final double width;
  final Alignment? align;

  PaginatedListColumn({
    this.label = '',
    this.name = '',
    this.width = 0.0,
    this.align,
  });
}
