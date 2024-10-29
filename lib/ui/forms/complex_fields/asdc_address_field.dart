import 'package:flutter/material.dart';

import '../../../asdc_ui.dart';

class AsdcAddressField extends StatefulWidget {
  final dynamic controller;

  final String namePrefix;

  final String registrationLabel;
  final String matchLabel;
  final String actualLabel;

  const AsdcAddressField({
    super.key,
    required this.controller,
    this.namePrefix = 'address',
    required this.registrationLabel,
    required this.matchLabel,
    required this.actualLabel,
  });

  @override
  State<AsdcAddressField> createState() => _AsdcAddressFieldState();
}

class _AsdcAddressFieldState extends State<AsdcAddressField> {
  @override
  Widget build(context) {
    final registrationName = '${widget.namePrefix}.registration';
    final matchName = '${widget.namePrefix}.is_match';
    final actualName = '${widget.namePrefix}.actual';

    return Column(children: [
      /// поле адреса регистрации / юридического адреса
      KrsTextField(
        name: registrationName,
        labelText: widget.registrationLabel,
        onChanged: (value) {
          if (widget.controller.fieldValue(matchName) == true) {
            widget.controller.changeField(actualName, value);
          }
        },
      ),

      KrsCheckboxField(
        name: matchName,
        titleText: widget.matchLabel,
        onChanged: (value) {
          if (value == true) {
            /// ^ если адреса одни и те же

            /// присваиваем значение от адреса регистрации
            widget.controller.changeField(
                actualName, widget.controller.fieldValue(registrationName));
          } else {
            /// ^ если адреса должны быть разными

            if (widget.controller.fieldValue(registrationName) ==
                widget.controller.fieldValue(actualName)) {
              /// очищаем поле, если уже было введено значение
              widget.controller.changeField(actualName, '');
            }
          }

          setState(() {});
        },
      ),

      /// поле фактического / почтового адреса
      KrsTextField(
        name: actualName,
        enabled: widget.controller.fieldValue(matchName) == false,
        labelText: widget.actualLabel,
      ),
    ]);
  }
}
