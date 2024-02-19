import 'package:flutter/material.dart';

import '../../extensions/theme_data_extensions.dart';

class AsdcResponsiveTable extends StatelessWidget {
  final AsdcResponsiveSizes sizes;
  final int itemCount;
  final List<Widget Function(BuildContext context)> headBuilders;
  final List<Widget Function(BuildContext context, int index)> itemBuilders;
  final double spacing;
  final double indents;

  const AsdcResponsiveTable({
    super.key,
    required this.sizes,
    required this.headBuilders,
    required this.itemCount,
    required this.itemBuilders,
    this.spacing = 4.0,
    this.indents = 16.0,
  });

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    /// находим количество колонок, на которое делим сетку
    // final widthSm = sizes.sm.fold(0.0, (sum, item) => sum + item.width);
    final widthMd = sizes.md.fold(0.0, (sum, item) => sum + item.width) +
        (spacing * (headBuilders.length - 1)) +
        indents * 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        // final isSm = constraints.maxWidth < Breakpoints.sm;

        // /// ширина одной ячейки сетки
        // final width =
        //     (constraints.maxWidth - spacing * (columns - 1)) / gridSize;

        /// возможно ли вместить все колонки по ширине
        final expandable = constraints.maxWidth >= widthMd;

        return Column(
          children: [
            /// данные
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: constraints.maxWidth >= widthMd
                    ? constraints.maxWidth
                    : widthMd,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount + 1,
                  itemBuilder: (context, index) {
                    List<Widget> widgets = [];

                    for (int i = 0; i < itemBuilders.length; i++) {
                      /// желаемый размер текущей ячейки
                      final columnSize = sizes.md[i];

                      /// билдер текущей ячейки
                      Widget cell = (index == 0)

                          /// заголовки
                          ? headBuilders[i](context)

                          /// данные
                          : itemBuilders[i](context, index - 1);

                      if (columnSize.minWidth > 0.0) {
                        if (expandable) {
                          cell = Expanded(
                            child: cell,
                          );
                        } else {
                          cell = SizedBox(
                            width: columnSize.width,
                            child: cell,
                          );
                        }
                      } else {
                        cell = SizedBox(
                          width: columnSize.width,
                          child: cell,
                        );
                      }

                      widgets.add(cell);

                      if (i < itemBuilders.length - 1) {
                        widgets.add(SizedBox(width: spacing));
                      }
                    }

                    final child = Row(
                      children: widgets,
                    );

                    if (index == 0) {
                      return _ListRow(
                        hoverable: false,
                        padding: EdgeInsets.symmetric(
                          horizontal: indents,
                          vertical: 8.0,
                        ),
                        child: DefaultTextStyle(
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.outline,
                          ),
                          child: child,
                        ),
                      );
                    }

                    return _ListRow(
                      padding: EdgeInsets.symmetric(
                        horizontal: indents,
                        vertical: 8.0,
                      ),
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ListRow extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool hoverable;

  const _ListRow({
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.hoverable = true,
  });

  @override
  State<_ListRow> createState() => _ListRowState();
}

class _ListRowState extends State<_ListRow> {
  bool hovered = false;

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    final child = Padding(
      padding: widget.padding,
      child: widget.child,
    );

    if (!widget.hoverable) {
      return child;
    }

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: ColoredBox(
        color: hovered ? theme.surfaceContainerHighest : Colors.transparent,
        child: child,
      ),
    );
  }
}

class AsdcResponsiveSizes {
  final List<AsdcColumnSize> sm;
  final List<AsdcColumnSize> md;
  final List<AsdcColumnSize> lg;

  AsdcResponsiveSizes({
    required this.sm,
    required this.md,
    this.lg = const [],
  });
}

class AsdcColumnSize {
  final double minWidth;
  final double width;

  AsdcColumnSize({
    this.minWidth = 0.0,
    double? width,
  }) : width = width ?? minWidth;
}
