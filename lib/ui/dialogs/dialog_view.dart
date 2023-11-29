import 'package:flutter/material.dart';

import '../../resources/krs_theme.dart';

class DialogView extends StatelessWidget {
  final double width;
  final bool centerTitle;
  final Widget? title;
  final Widget? subtitle;
  final Widget content;
  final List<Widget> actions;
  final List<Widget> secondaryActions;
  final double contentPadding;
  final Widget? menuButton;
  final String? closeButtonLabel;

  const DialogView({
    super.key,
    this.width = Breakpoints.sm,
    this.title,
    this.subtitle,
    this.centerTitle = false,
    required this.content,
    this.contentPadding = 24.0,
    this.actions = const [],
    this.secondaryActions = const [],
    this.menuButton,
    this.closeButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final closeButton = TextButton(
      onPressed: () async {
        /// закрываем диалоговое окно
        Navigator.maybeOf(context)?.pop();
      },
      child: Text(closeButtonLabel ??
          MaterialLocalizations.of(context).closeButtonLabel),
    );

    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          child: SizedBox(
            width: width,
            child: Stack(
              children: [
                if (menuButton != null)
                  Positioned(
                    top: 12.0,
                    right: 12.0,
                    child: menuButton!,
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Align(
                          alignment: centerTitle
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: centerTitle
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle(
                                style: theme.textTheme.titleLarge!,
                                child: title!,
                              ),
                              if (subtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: DefaultTextStyle(
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.62),
                                    ),
                                    child: subtitle!,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    /// основной контент
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: contentPadding,
                      ),
                      child: content,
                    ),

                    /// кнопки действия
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          /// вторичные кнопки действия
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: secondaryActions,
                          ),

                          /// основные кнопки действия
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [closeButton, ...actions].map((widget) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 12.0,
                                  ),
                                  child: widget,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
