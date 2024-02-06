import '/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

@immutable
class ResponsiveWrap extends StatelessWidget {
  final double spacing;
  final double maxWidth;
  final List<Widget> children;
  final List<int>? gridSizes;

  const ResponsiveWrap({
    super.key,
    this.spacing = 12.0,
    this.maxWidth = 576.0,
    required this.children,
    this.gridSizes,
  }) : assert(gridSizes == null || gridSizes.length == children.length);

  @override
  Widget build(context) {
    final columns = children.length;

    /// назодим количество колонок, на которое делим сетку
    int gridSize = gridSizes?.reduce((a, b) => a + b) ?? columns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < maxWidth;
        // 768.0
        // 992.0
        // 1200.0

        /// ширина одной ячейки сетки
        final gridWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / gridSize;

        return Wrap(
          alignment: WrapAlignment.start,
          spacing: spacing,
          runSpacing: spacing,
          children: children.mapIndexed((index, child) {
            return SizedBox(
              width: isMobile ? null : gridWidth * (gridSizes?[index] ?? 1),
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
