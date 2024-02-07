import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get theme => 'Тема оформления';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get send => 'Отправить';

  @override
  String get rowsPerPage => 'Результатов на странице';

  @override
  String tableDataOf(Object from, Object to, Object total) {
    return '$from – $to из $total';
  }

  @override
  String get firstPage => 'Первая страница';

  @override
  String get lastPage => 'Последняя страница';

  @override
  String get previousPage => 'Предыдущая страница';

  @override
  String get nextPage => 'Следующая страница';

  @override
  String get selectOption => 'Выберите вариант...';

  @override
  String get selectOptions => 'Выберите варианты';

  @override
  String get field => 'Поле';

  @override
  String get value => 'Значение';

  @override
  String get month => 'Месяц';

  @override
  String get year => 'Год';

  @override
  String get threeMonths => 'Три месяца';

  @override
  String get lastMonth => 'Прошлый месяц';

  @override
  String get currentMonth => 'Текущий месяц';

  @override
  String get currentYear => 'Текущий год';

  @override
  String get lastYear => 'Прошлый год';

  @override
  String get specifyPeriod => 'Указать период';

  @override
  String get edit => 'Редактировать';

  @override
  String get save => 'Сохранить';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get changesSaved => 'Изменения успешно сохранены';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get loadingData => 'Загрузка данных';

  @override
  String get notSpecified => 'Не указано';

  @override
  String get selectAll => 'Выделить все';

  @override
  String get apply => 'Применить';

  @override
  String get noDataAvailable => 'Нет данных';

  @override
  String get search => 'Поиск';

  @override
  String get clear => 'Очистить';

  @override
  String get error => 'Ошибка';

  @override
  String get delete => 'Удалить';

  @override
  String get back => 'Назад';

  @override
  String get cancel => 'Отмена';

  @override
  String get add => 'Добавить';

  @override
  String get copy => 'Копировать';

  @override
  String get close => 'Закрыть';
}
