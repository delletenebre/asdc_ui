import 'package:flutter/material.dart';

import '../../resources/asdc_theme.dart';

class AsdcPageView extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final void Function(ScrollNotification scrollInfo)? onScroll;
  final Widget? floatingActionButton;

  const AsdcPageView({
    super.key,
    this.title,
    required this.child,
    this.onScroll,
    this.floatingActionButton,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // drawer: isMobile ? const NavigationDrawer() : null,
      floatingActionButton: floatingActionButton,
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          onScroll?.call(scrollInfo);

          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: Breakpoints.sm,
                maxWidth: Breakpoints.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (screenSize.width <= Breakpoints.md)
                        Transform.translate(
                          offset: const Offset(0.0, -6.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const Icon(Icons.menu),
                            ),
                          ),
                        ),

                      /// заголовок страницы
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: DefaultTextStyle(
                            style: theme.textTheme.titleLarge!,
                            child: title!,
                          ),
                        ),
                    ],
                  ),

                  /// основной контент
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
