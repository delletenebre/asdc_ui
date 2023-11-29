// import 'package:einsurance/extensions/date_time_extensions.dart';
// import 'package:einsurance/utils/krs_form_builder.dart';
// import 'package:einsurance/extensions/string_extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:reactive_forms/reactive_forms.dart';

// import '../../../enums/report_period_type.dart';
// import '../../../resources/krs_locale.dart';
// import '../../../ui/forms/krs_reactive_date_field.dart';
// import '../../../ui/forms/krs_reactive_select_field.dart';

// class KrsPeriodFields extends HookWidget {
//   final void Function(DateTime?, DateTime?)? onChange;

//   const KrsPeriodFields({
//     super.key,
//     this.onChange,
//   });

//   @override
//   Widget build(context) {
//     final locale = KrsLocale.of(context);

//     /// текущая дата
//     final now = DateTime.now();

//     final form = krsFormBuilder.group({
//       'period_type': [
//         ReportPeriodType.currentMonth.id,
//       ],
//       'date_start': [
//         '',
//       ],
//       'date_end': [
//         '',
//       ],
//     });

//     final startDateControl = form.control('date_start');
//     final endDateControl = form.control('date_end');

//     form.valueChanges.listen((value) {
//       final sDate = startDateControl.value.toString();
//       final eDate = endDateControl.value.toString();
//       onChange?.call(sDate.toDate(), eDate.toDate());
//     });
    
//     return FormBuilder(
//       formGroup: form,
//       child: Wrap(
//         spacing: 12.0,
//         children: [
//           /// поле фильтра по дате создания от
//           KrsReactiveSelectField(
//             width: 180.0,
//             labelText: 'Период',
//             name: 'period_type',
//             dialogTitleText: 'Выберите период',
//             itemToTitle: (item) => item,
//             asyncOptions: () async => ReportPeriodType.options,
//           ),

//           /// поле фильтра по дате от
//           ReactiveValueListenableBuilder<String>(
//             name: 'period_type',
//             builder: (context, periodTypeControl, child) {

//               if (periodTypeControl.value == ReportPeriodType.specify.id) {
//                 startDateControl.markAsEnabled();
//               } else {
//                 startDateControl.markAsDisabled();

//                 DateTime? date;

//                 if (periodTypeControl.value == ReportPeriodType.currentMonth.id) {
//                   date = now.firstDay();
//                 } else if (periodTypeControl.value == ReportPeriodType.lastMonth.id) {
//                   date = now.subDate(months: 1).firstDay();
//                 } else if (periodTypeControl.value == ReportPeriodType.currentYear.id) {
//                   date = now.firstYearDay();
//                 }

//                 if (date != null) {
//                   startDateControl.value = date.format(DateTimeFormatExtensions.dateFormat);
//                 }

//               }

//               return child!;
//             },

//             child: KrsReactiveDateField(
//               width: 140.0,
//               labelText: 'Период от',
//               name: 'date_start',
//               firstDate: now.subDate(years: 10),
//               lastDate: now.addDate(years: 1),
//             ),
//           ),

//           /// поле фильтра по дате до
//           ReactiveValueListenableBuilder<String>(
//             name: 'period_type',
//             builder: (context, periodTypeControl, child) {

//               if (periodTypeControl.value == ReportPeriodType.specify.id) {
//                 endDateControl.markAsEnabled();
//               } else {
//                 endDateControl.markAsDisabled();

//                 DateTime? date;

//                 if (periodTypeControl.value == ReportPeriodType.currentMonth.id) {
//                   date = now.lastDay();
//                 } else if (periodTypeControl.value == ReportPeriodType.lastMonth.id) {
//                   date = now.subDate(months: 1).lastDay();
//                 } else if (periodTypeControl.value == ReportPeriodType.currentYear.id) {
//                   date = now.lastYearDay();
//                 }

//                 if (date != null) {
//                   endDateControl.value = date.format(DateTimeFormatExtensions.dateFormat);
//                 }
//               }

//               return child!;
//             },

//             child: KrsReactiveDateField(
//               width: 140.0,
//               labelText: 'Период до',
//               name: 'date_end',
//               firstDate: now.subDate(years: 10),
//               lastDate: now.addDate(years: 1),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }