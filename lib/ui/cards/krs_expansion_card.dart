import 'package:flutter/material.dart';

class KrsExpansionCard extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  const KrsExpansionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ExpansionTile(
        initiallyExpanded: true,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        childrenPadding: const EdgeInsets.all(12.0),
        title: title,
        children: children,
      ),
    );
  }
}
