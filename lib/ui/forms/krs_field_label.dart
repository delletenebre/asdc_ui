import 'package:flutter/material.dart';

class KrsFieldLabel extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool hasError;
  final bool hasFocus;
  final String? labelText;
  final Widget child;
  final TextEditingController? controller;
  final int? maxLength;

  const KrsFieldLabel({
    super.key,
    this.padding = const EdgeInsets.only(bottom: 24.0),
    this.hasError = false,
    this.hasFocus = false,
    this.labelText,
    required this.child,
    this.controller,
    this.maxLength,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    final textStyle = TextStyle(
      fontSize: 11.0,
      color: hasError
          ? theme.colorScheme.error
          : hasFocus
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
    );

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText != null)
            Builder(builder: (context) {
              /// виджет текстового поля
              final textWidget = Text(
                labelText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              );

              /// абстрактно вычисляем размеры текстового поля
              final textPainter = TextPainter(
                maxLines: textWidget.maxLines,
                textAlign: textWidget.textAlign ?? TextAlign.start,
                textDirection: textWidget.textDirection ?? TextDirection.ltr,
                text: TextSpan(
                  text: textWidget.data,
                  style: textWidget.style,
                ),
                strutStyle: textWidget.strutStyle,
              );

              return Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 2.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constrains) {
                          /// абстрактно вписываем текст в размеры
                          textPainter.layout(maxWidth: constrains.maxWidth);

                          /// проверяем, помещается ли текст полностью на экран
                          final overflowed = textPainter.didExceedMaxLines;

                          /// тестовое поле с необходимым отступом
                          final child = textWidget;

                          if (overflowed) {
                            /// ^ если текст не отображается полностью

                            /// добавляем всплывающую подсказку
                            return Tooltip(
                              message: labelText,
                              child: child,
                            );
                          }

                          return child;
                        },
                      ),
                    ),
                    if (maxLength != null)
                      Text(
                        '${controller?.text.length}/$maxLength',
                        style: textStyle.copyWith(fontSize: 10.0),
                      ),
                  ],
                ),
              );
            }),
          child,
        ],
      ),
    );
  }
}
