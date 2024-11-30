import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 安全键盘聚焦组件
class NSecureKeyboardFocus extends StatelessWidget {
  /// 处理安全键盘的交互问题
  const NSecureKeyboardFocus({
    super.key,
    this.isObscure = false,
    required this.focusNode,
    required this.child,
  });

  /// 是否是安全键盘
  final bool isObscure;

  final FocusNode focusNode;

  final Widget child;

  static bool _prevIsObscure = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) async {
        // 相同键盘类型无需特殊处理
        if (_prevIsObscure == isObscure) {
          return;
        }
        // 当上此弹出的键盘与本次即将弹出的键盘类型不匹配时(上次是安全键盘本次不是)
        // 确保再次获取焦点前先失去焦点, 并记录本次弹出的键盘类型
        await Future.delayed(const Duration(milliseconds: 350));
        focusNode.requestFocus();

        _prevIsObscure = isObscure;
      },
      child: child,
    );
  }
}
