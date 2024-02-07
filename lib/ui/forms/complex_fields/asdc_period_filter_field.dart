import 'package:asdc_ui/extensions/date_time_extensions.dart';
import 'package:asdc_ui/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../asdc_overlay_portal.dart';
import '../../dialogs/dialog_view.dart';
import '../../responsive_wrap.dart';
import '../asdc_forms.dart';

enum AsdcPeriods {
  month,
  quarter,
  lastMonth,
  currentMonth,
  currentYear,
  lastYear,
  period,
}

class AsdcPeriodFilterField<T> extends StatefulWidget {
  // final List<AsdcPeriodFilters> filters;
  final String locale;
  final void Function(DateTime startDate, DateTime endDate)? onChanged;
  final AsdcPeriods? initialPeriod;

  const AsdcPeriodFilterField({
    super.key,
    // this.filters = const [],
    this.locale = 'ru',
    this.onChanged,
    this.initialPeriod,
  });

  @override
  State<AsdcPeriodFilterField<T>> createState() =>
      _AsdcPeriodFilterFieldState<T>();
}

class _AsdcPeriodFilterFieldState<T> extends State<AsdcPeriodFilterField<T>> {
  T? selectedItem;

  String buttonText = '';
  AsdcPeriods currentPeriod = AsdcPeriods.month;

  final width = 200.0;
  final itemExtent = 44.0;
  final verticalPadding = 12.0;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      changeValue(widget.initialPeriod ?? AsdcPeriods.month);
    });
    super.initState();
  }

  Future<void> changeValue(AsdcPeriods period) async {
    final locale = lookupAppLocalizations(Locale(widget.locale));

    final now = DateTime.now();

    switch (period) {
      case AsdcPeriods.month:
        startDate = now.subDate(months: 1);
        endDate = now;
        buttonText = locale.month;
        break;
      case AsdcPeriods.quarter:
        startDate = now.subDate(months: 3);
        endDate = now;
        buttonText = locale.threeMonths;
        break;
      case AsdcPeriods.lastMonth:
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 0);
        buttonText = locale.lastMonth;
        break;
      case AsdcPeriods.currentMonth:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        buttonText = locale.currentMonth;
        break;
      case AsdcPeriods.currentYear:
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        buttonText = locale.currentYear;
        break;
      case AsdcPeriods.lastYear:
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31);
        buttonText = locale.lastYear;
        break;
      case AsdcPeriods.period:
        try {
          final (sDate, eDate) = await showDialog(
            context: context,
            builder: (dialogContext) {
              DateTime sDate = startDate;
              DateTime eDate = endDate;
              return DialogView(
                width: 480.0,
                title: Text(locale.specifyPeriod),
                actions: [
                  FilledButton(
                    onPressed: () async {
                      /// закрываем диалоговое окно и возвращаем выбранные даты
                      Navigator.of(dialogContext)
                          .pop<(DateTime?, DateTime?)>((sDate, eDate));
                    },
                    child: Text(locale.save),
                  ),
                ],
                content: ResponsiveWrap(
                  maxWidth: 480.0 - 48.0,

                  /// поле ввода пароля
                  children: [
                    KrsDateField(
                      name: 'start_date',
                      labelText: 'locale.newPassword',
                      initialValue: sDate.format('yyyy-MM-dd'),
                      firstDate: DateTime.now().subDate(years: 10),
                      lastDate: DateTime.now().addDate(years: 1),
                      onChanged: (date) {
                        final parsedDate = date.toDate(inputDateFormat);
                        if (parsedDate != null) {
                          sDate = parsedDate;
                        }
                      },
                    ),
                    KrsDateField(
                      name: 'end_date',
                      labelText: 'locale.newPassword',
                      initialValue: eDate.format('yyyy-MM-dd'),
                      firstDate: DateTime.now().subDate(years: 10),
                      lastDate: DateTime.now().addDate(years: 1),
                      onChanged: (date) {
                        final parsedDate = date.toDate(inputDateFormat);
                        if (parsedDate != null) {
                          eDate = parsedDate;
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
          startDate = sDate;
          endDate = eDate;
          buttonText =
              '${startDate.format('dd.MM.yyyy')} - ${endDate.format('dd.MM.yyyy')}';
        } catch (exception) {
          return;
        }
        break;
    }

    currentPeriod = period;

    widget.onChanged?.call(startDate, endDate);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = lookupAppLocalizations(Locale(widget.locale));

    final items = [
      PopupMenuItem(
        onTap: () {},
        value: AsdcPeriods.month,
        child: Text(locale.month),
      ),
      PopupMenuItem(
        onTap: () {},
        value: AsdcPeriods.quarter,
        child: Text(locale.threeMonths),
      ),
      PopupMenuItem(
        onTap: () {},
        value: AsdcPeriods.lastMonth,
        child: Text(locale.lastMonth),
      ),
      PopupMenuItem(
        onTap: () {},
        value: AsdcPeriods.currentMonth,
        child: Text(locale.currentMonth),
      ),
      PopupMenuItem(
        onTap: () {},
        value: AsdcPeriods.currentYear,
        child: Text(locale.currentYear),
      ),
      PopupMenuItem(
        onTap: () {},
        value: AsdcPeriods.lastYear,
        child: Text(locale.lastYear),
      ),
      PopupMenuItem(
        value: AsdcPeriods.period,
        child: Text(locale.specifyPeriod),
      ),
    ];

    final key = GlobalKey<AsdcOverlayPortalState>();

    return AsdcOverlayPortal(
      key: key,
      size: Size(width, (items.length * itemExtent) + (verticalPadding * 2)),
      offset: const Offset(0.0, -16.0),
      overlay: Card(
        elevation: 12.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width,
            minWidth: width,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
            ),
            shrinkWrap: true,
            itemExtent: itemExtent,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                onTap: () {
                  changeValue(item.value!);
                  key.currentState?.hideOverlay();
                },
                title: item.child,
              );
            },
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(24.0, 10.0, 16.0, 10.0),
            ),
            onPressed: () {
              key.currentState?.showOverlay();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(buttonText),
                const SizedBox(width: 8.0),
                const Icon(Icons.arrow_drop_down_outlined, size: 18.0),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            '${startDate.formatDate('dd MMM y')} — ${endDate.formatDate('dd MMM y')}',
            style: TextStyle(
              fontSize: 10.0,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
