import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../resources/asdc_theme.dart';
import '../ui/krs_notification.dart';

extension ContextExtensions on BuildContext {
  bool get isMobile {
    return MediaQuery.of(this).size.width < Breakpoints.sm;
  }

  /// показ уведомления
  void _showNotification(Widget child) {
    showToastWidget(
      child,
      context: this,
      position: const StyledToastPosition(
        align: Alignment.topRight,
      ),
      duration: const Duration(seconds: 5),
      isIgnoring: false,
      animation: StyledToastAnimation.slideFromRightFade,
      reverseAnimation: StyledToastAnimation.slideFromRightFade,
    );
  }

  /// информационное уведомление
  void showNotification({String? title, String message = ''}) {
    _showNotification(KrsNotification(title: title, message: message));
  }

  /// уведомление об успешной операции
  void showSuccessNotification({String? title, String message = ''}) {
    _showNotification(KrsNotification.success(title: title, message: message));
  }

  /// уведомление об операции с ошибкой
  void showErrorNotification({String? title, String message = ''}) {
    _showNotification(KrsNotification.error(title: title, message: message));
  }
}
