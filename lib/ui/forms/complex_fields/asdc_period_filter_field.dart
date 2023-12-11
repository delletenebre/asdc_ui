import 'package:flutter/material.dart';

class AsdcPeriodFilterField<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;

  const AsdcPeriodFilterField({
    super.key,
    required this.items,
  });

  @override
  State<AsdcPeriodFilterField<T>> createState() =>
      _AsdcPeriodFilterFieldState<T>();
}

class _AsdcPeriodFilterFieldState<T> extends State<AsdcPeriodFilterField<T>> {
  T? selectedItem;

  final overlayController = OverlayPortalController();

  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      PopupMenuItem(
        onTap: () {},
        child: Text('Месяц'),
      ),
      PopupMenuItem(
        onTap: () {},
        child: Text('Год'),
      ),
      PopupMenuItem(
        onTap: () {},
        child: Text('Прошлый месяц'),
      ),
      PopupMenuItem(
        onTap: () {},
        child: Text('Текущий месяц'),
      ),
      PopupMenuItem(
        onTap: () {},
        child: Text('Текущий год'),
      ),
      PopupMenuItem(
        onTap: () {},
        child: Text('Указать период'),
      ),
    ];

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: overlayController,
        overlayChildBuilder: (context) {
          return SizedBox.fromSize(
            size: MediaQuery.of(context).size,
            child: Stack(
              children: [
                ModalBarrier(
                  onDismiss: () {
                    overlayController.hide();
                  },
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: Alignment.bottomLeft,
                  child: Card(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            onTap: () {},
                            title: item.child,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(24.0, 10.0, 16.0, 10.0),
          ),
          onPressed: () {
            overlayController.toggle();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('show'),
              const SizedBox(width: 8.0),
              Icon(Icons.arrow_drop_down_outlined, size: 18.0),
            ],
          ),
        ),
      ),
    );

    // return DropdownButtonHideUnderline(
    //   child: DropdownButton<T>(
    //     value: selectedItem,
    //     selectedItemBuilder: (context) {
    //       return [Text('123'), Text('456')];
    //     },
    //     items: widget.items,
    //     onChanged: (value) {
    //       if (value != null && value != selectedItem) {
    //         setState(() {
    //           selectedItem = value;
    //         });
    //       }
    //     },
    //   ),
    // );

    return PopupMenuButton(
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      onSelected: (value) {},
      itemBuilder: (_) {
        return [
          /// кнопка перехода на страницу редактирования черновика полиса ОСАГО
          PopupMenuItem(
            onTap: () {},
            child: Text('Месяц'),
          ),
          PopupMenuItem(
            onTap: () {},
            child: Text('Год'),
          ),
          PopupMenuItem(
            onTap: () {},
            child: Text('Прошлый месяц'),
          ),
          PopupMenuItem(
            onTap: () {},
            child: Text('Текущий месяц'),
          ),
          PopupMenuItem(
            onTap: () {},
            child: Text('Текущий год'),
          ),
          PopupMenuItem(
            onTap: () {},
            child: Text('Указать период'),
          ),
        ];
      },
      icon: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 12.0, 10.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.16),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('01.01.2023 - 12.12.2024'),
            const SizedBox(width: 6.0),
            Icon(
              Icons.arrow_drop_down,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}
