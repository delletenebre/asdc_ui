import 'package:flutter/material.dart';

import '../../extensions/theme_data_extensions.dart';

enum AsdcNotificationType {
  info,
  error,
  success,
}

class AsdcNotification extends StatelessWidget {
  final AsdcNotificationType type;
  final String? title;
  final String message;

  const AsdcNotification({
    super.key,
    this.type = AsdcNotificationType.info,
    this.title,
    required this.message,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (type) {
      case AsdcNotificationType.success:
        backgroundColor = theme.successContainerColor();
        foregroundColor = theme.onSuccessContainerColor();
        break;
      case AsdcNotificationType.error:
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;
        break;
      case AsdcNotificationType.info:
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        foregroundColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      constraints: const BoxConstraints(
        minWidth: 240.0,
        maxWidth: 320.0,
        maxHeight: 320.0,
      ),
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0.0, 4.0),
              color: theme.colorScheme.shadow.withOpacity(0.12),
              blurRadius: 4.0,
            )
          ]),
      child: DefaultTextStyle(
        style: TextStyle(
          color: foregroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && title!.isNotEmpty)
              Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              message,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  factory AsdcNotification.error({String? title, required String message}) =>
      AsdcNotification(
        title: title,
        message: message,
        type: AsdcNotificationType.error,
      );

  factory AsdcNotification.success({String? title, required String message}) =>
      AsdcNotification(
        title: title,
        message: message,
        type: AsdcNotificationType.success,
      );
}
