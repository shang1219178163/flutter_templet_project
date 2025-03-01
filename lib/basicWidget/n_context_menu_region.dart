import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef WidgetOffsetBuilder = Widget Function(BuildContext context, Offset offset);

// flutter 3.3 后官方组件 SelectionArea
/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class NContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [NContextMenuRegion].
  const NContextMenuRegion({
    super.key,
    required this.child,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final WidgetOffsetBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<NContextMenuRegion> createState() => _NContextMenuRegionState();
}

class _NContextMenuRegionState extends State<NContextMenuRegion> {
  Offset? _longPressOffset;

  final _contextMenuController = ContextMenuController();

  static bool get _longPressEnabled {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
        return true;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!_contextMenuController.isShown) {
      return;
    }
    _hide();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _longPressOffset = details.globalPosition;
  }

  void _onLongPress() {
    assert(_longPressOffset != null);
    _show(_longPressOffset!);
    _longPressOffset = null;
  }

  void _show(Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    _contextMenuController.remove();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapUp: _onSecondaryTapUp,
      onTap: _onTap,
      onLongPress: _longPressEnabled ? _onLongPress : null,
      onLongPressStart: _longPressEnabled ? _onLongPressStart : null,
      child: widget.child,
    );
  }
}
