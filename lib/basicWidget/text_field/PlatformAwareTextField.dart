import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用于键盘监听
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// 一个能感知平台的文本表单字段
/// 在桌面/Web端响应Tab和回车，在移动端优化体验
class PlatformAwareTextField extends StatelessWidget {
  final String name;
  final String? hintText;
  final bool isLastField;

  const PlatformAwareTextField({
    super.key,
    required this.name,
    this.hintText,
    this.isLastField = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final formNavigationService = FormNavigationService.of(context);
    // 获取当前平台风格
    final isDesktop = [
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.macOS,
    ].contains(themeData.platform);

    return Focus(
      // 使用Focus来自定义键盘动作
      onKey: (node, event) {
        // **桌面/Web端专属逻辑**
        if (isDesktop && event is RawKeyDownEvent) {
          final logicalKey = event.logicalKey;
          // Tab键：移动到下一个字段
          if (logicalKey == LogicalKeyboardKey.tab) {
            if (!event.isShiftPressed) {
              // 调用全局导航服务，移动到下一个焦点
              formNavigationService?.focusNext();
              return KeyEventResult.handled; // 阻止默认Tab行为
            }
          }
          // 回车键：如果是最后一个字段则提交，否则下一个
          if (logicalKey == LogicalKeyboardKey.enter) {
            if (isLastField) {
              formNavigationService?.submitForm();
            } else {
              formNavigationService?.focusNext();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          hintText: hintText,
          // **移动端优化：添加清晰的“完成”按钮**
          suffixIcon: !isDesktop
              ? IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    if (isLastField) {
                      formNavigationService?.submitForm();
                    } else {
                      formNavigationService?.focusNext();
                    }
                  },
                )
              : null,
        ),
        textInputAction: isLastField ? TextInputAction.done : TextInputAction.next,
        // **关键：统一使用textInputAction触发导航服务**
        onSubmitted: (_) {
          if (isLastField) {
            formNavigationService?.submitForm();
          } else {
            formNavigationService?.focusNext();
          }
        },
      ),
    );
  }
}

/// 一个简易的、通过InheritedWidget提供的表单导航服务
class FormNavigationService extends InheritedWidget {
  static FormNavigationService? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<FormNavigationService>();
    return result;
  }

  const FormNavigationService({
    super.key,
    required super.child,
    required this.focusNext,
    required this.submitForm,
  });

  final void Function() focusNext;
  final void Function() submitForm;

  @override
  bool updateShouldNotify(FormNavigationService oldWidget) => false;
}
