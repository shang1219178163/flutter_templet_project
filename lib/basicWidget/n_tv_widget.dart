import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';

/// TV 基础组件,负责焦点和按键响应
class NTVWidget extends StatefulWidget {
  const NTVWidget({
    super.key,
    required this.child,
    required this.focusChanged,
    required this.onClick,
    required this.onKeyEventChanged,
    this.margin = const EdgeInsets.all(8),
    required this.decoration,
    this.hasDecoration = true,
    this.requestFocus = false,
  });

  final Widget child;

  /// 焦点回调
  final void Function(bool hasFocus)? focusChanged;

  /// 点击事件
  final VoidCallback? onClick;

  /// 是否默认请求焦点
  final bool requestFocus;

  /// 间距
  final EdgeInsets? margin;

  /// 高亮装饰器
  final BoxDecoration? decoration;

  /// 高亮装饰器是否显示
  final bool hasDecoration;

  /// 按键回调
  final KeyEventResult Function(KeyEvent event)? onKeyEventChanged;

  @override
  State<NTVWidget> createState() => NTVWidgetState();
}

class NTVWidgetState extends State<NTVWidget> with SafeSetStateMixin {
  late FocusNode _focusNode;
  bool _requested = false;

  final BoxDecoration defaultDecoration = BoxDecoration(
    border: Border.all(width: 3, color: Colors.deepOrange),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  BoxDecoration? _decoration;

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    final hasFocus = _focusNode.hasFocus;
    widget.focusChanged?.call(hasFocus);

    setState(() {
      if (hasFocus && widget.hasDecoration) {
        _decoration = widget.decoration ?? defaultDecoration;
      } else {
        _decoration = null;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ 避免 build 阶段 requestFocus
    if (widget.requestFocus && !_requested) {
      _requested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  KeyEventResult onHandleKey(KeyEvent event) {
    if (widget.onKeyEventChanged != null) {
      return widget.onKeyEventChanged!(event);
    }

    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp: // up
        FocusScope.of(context).focusInDirection(TraversalDirection.up);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown: // down
        FocusScope.of(context).focusInDirection(TraversalDirection.down);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft: // left
        FocusScope.of(context).focusInDirection(TraversalDirection.left);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight: // right
        FocusScope.of(context).focusInDirection(TraversalDirection.right);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter: // enter
        widget.onClick?.call();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: onHandleKey,
      child: Container(
        margin: widget.margin,
        decoration: _decoration,
        child: widget.child,
      ),
    );
  }
}
