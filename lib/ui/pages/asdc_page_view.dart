import 'package:flutter/material.dart';

import '../../resources/asdc_theme.dart';

class AsdcPageView extends StatelessWidget {
  final Widget? title;
  final Widget child;

  const AsdcPageView({
    super.key,
    this.title,
    required this.child,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return Scaffold(
      // drawer: isMobile ? const NavigationDrawer() : null,
      body: SingleChildScrollView(
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
                /// заголовок страницы
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: DefaultTextStyle(
                      style: theme.textTheme.headlineSmall!,
                      child: title!,
                    ),
                  ),

                /// основной контент
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
