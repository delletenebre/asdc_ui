import 'package:flutter/material.dart';

class AsdcOverlayPortal<T> extends StatefulWidget {
  final Offset offset;
  final Widget overlay;
  final Widget child;

  /// для вычисления того, помещается ли виджет в рамках экрана
  final Size? size;
  const AsdcOverlayPortal({
    super.key,
    this.offset = Offset.zero,
    required this.overlay,
    required this.child,
    this.size,
  });

  @override
  State<AsdcOverlayPortal<T>> createState() => AsdcOverlayPortalState<T>();
}

class AsdcOverlayPortalState<T> extends State<AsdcOverlayPortal<T>> {
  final overlayController = OverlayPortalController();

  final _layerLink = LayerLink();

  final _key = GlobalKey();

  Alignment targetAnchor = Alignment.bottomLeft;
  Alignment followerAnchor = Alignment.topLeft;
  //
  // final width = 200.0;
  // final itemExtent = 44.0;
  // final verticalPadding = 12.0;

  @override
  void initState() {
    super.initState();
  }

  /// открываем меню
  void showOverlay() {
    // Check if the key is ready and the context exists
    if (widget.size != null && _key.currentContext != null) {
      // Access the render object associated with the key's context
      final renderBox = _key.currentContext!.findRenderObject() as RenderBox;

      // Get the position of the render object relative to the screen
      final widgetPosition = renderBox.localToGlobal(Offset.zero);
      final screenSize = MediaQuery.of(context).size;

      final notFitRight =
          screenSize.width - (widgetPosition.dx + renderBox.size.width) <
              widget.size!.width;

      final notFitBottom =
          screenSize.height - (widgetPosition.dy + renderBox.size.height) <
              widget.size!.height;

      if (notFitRight && notFitBottom) {
        /// ^ не вмещается по правому краю
        targetAnchor = Alignment.topRight;
        followerAnchor = Alignment.bottomRight;
      } else if (notFitRight) {
        /// ^ не вмещается по правому краю
        targetAnchor = Alignment.bottomRight;
        followerAnchor = Alignment.topRight;
      } else if (notFitBottom) {
        /// ^ не вмещается по правому краю
        targetAnchor = Alignment.topLeft;
        followerAnchor = Alignment.bottomLeft;
      }
    }

    overlayController.toggle();
  }

  /// закрываем меню
  void hideOverlay() {
    overlayController.hide();

    targetAnchor = Alignment.bottomLeft;
    followerAnchor = Alignment.topLeft;
  }

  @override
  Widget build(context) {
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
                  color: Colors.black.withOpacity(0.12),
                  onDismiss: () {
                    hideOverlay();
                  },
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: targetAnchor,
                  followerAnchor: followerAnchor,
                  child: Transform.translate(
                    offset: widget.offset,
                    child: widget.overlay,
                  ),
                ),
              ],
            ),
          );
        },
        child: SizedBox(key: _key, child: widget.child),
      ),
    );
  }
}
