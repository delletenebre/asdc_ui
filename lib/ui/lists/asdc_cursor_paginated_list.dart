import 'package:flutter/material.dart';

import '../../models/laravel_error.dart';
import '../../models/paginators/paginator.dart';

class AsdcCursorPaginatedList<T> extends StatelessWidget {
  final bool loading;
  final Object? error;
  final CursorPaginator? paginator;

  final Widget Function(BuildContext context, T item) itemBuilder;
  final void Function(T item)? onTap;

  final void Function(PaginatorState paginatorState) onPaginationChanged;

  const AsdcCursorPaginatedList({
    super.key,
    this.loading = false,
    this.error,
    required this.paginator,
    required this.itemBuilder,
    this.onTap,
    required this.onPaginationChanged,
  });

  @override
  Widget build(context) {
    // final theme = Theme.of(context);
    // final locale = KrsLocale.of(context);

    if (error != null) {
      /// ^ если произошла ошибка
      if (error is LaravelError) {
        //return ErrorStateView(message: (error as LaravelError).message);
      }
    }

    if (paginator == null) {
      /// ^ если данные ещё не загружены
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    /// текущий курсор
    // final currentPage = useState(paginator!.cursor);

    /// количество результатов на странице
    // final perPage = useState(paginator!.perPage);

    /// ключ формы
    // final formKey = useState(GlobalKey<FormBuilderState>());

    // /// поле по которому включена сортировка
    // final sortBy = useState('');

    // /// направление сортировки (по возрастанию/по убыванию)
    // final sortDirection = useState('');

    /// функция при изменении состояния формы
    // final onFormChanged = useCallback(() {
    //   /// обновляем номер страницы
    //   formKey.value.currentState?.fields['page']
    //       ?.didChange(currentPage.value.toString());

    //   onPaginationChanged(
    //     PaginatorState(
    //       page: currentPage.value,
    //       perPage: perPage.value,
    //       sortBy: sortBy.value,
    //       sortDirection: sortDirection.value,
    //       filters: enabledFilters.value.convertToFormValues(),
    //     ),
    //   );
    // });

    return ListView.builder(
      // itemExtent: 48.0,
      itemCount: paginator!.data.length,
      itemBuilder: (context, index) {
        final item = paginator!.data[index];

        return itemBuilder(context, item);
        // return KrsListRow(
        //   sizes: columns.map((e) => e.width).toList(),
        //   onTap: onTap == null
        //       ? null
        //       : () => onTap!.call(paginator!.data[index]),
        //   children: children,
        // );
      },
    );
  }
}
