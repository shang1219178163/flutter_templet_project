
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// SmartDialog 通用弹窗
class DialogCenter extends StatefulWidget {
  const DialogCenter({
    super.key,
    required this.title,
    required this.message,
    this.content,
    this.cancelTitle,
    this.confirmTitle,
    this.buttonBar,
    this.onCancel,
    this.onConfirm,
  });

  /// 标题
  final Widget? title;

  /// 显示内容
  final Widget message;

  /// title + message
  final Widget? content;

  /// 取消标题
  final Widget? cancelTitle;

  /// 确认标题
  final Widget? confirmTitle;

  /// 确认按钮Bar(替换按钮整行菜单)
  final Widget? buttonBar;

  /// 取消按钮
  final VoidCallback? onCancel;

  /// 确认按钮
  final VoidCallback? onConfirm;

  @override
  State<DialogCenter> createState() => _DialogCenterState();

  static Future show({
    required Widget? title,
    required Widget message,
    Widget? content,
    Widget? cancelTitle,
    Widget? confirmTitle,
    Widget? buttonBar,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return SmartDialog.show(
      // tag: 'DialogCenter',
      alignment: Alignment.center,
      builder: (_) {
        return DialogCenter(
          title: title,
          message: message,
          content: content,
          cancelTitle: cancelTitle,
          confirmTitle: confirmTitle,
          buttonBar: buttonBar,
          onCancel: onCancel,
          onConfirm: onConfirm,
        );
      },
    );
  }

  static void dismiss() {
    SmartDialog.dismiss();
    // SmartDialog.dismiss(tag: 'DialogCenter');
  }
}

class _DialogCenterState extends State<DialogCenter> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: themeProvider.color242434OrWhite,
      child: Container(
        decoration: BoxDecoration(
          // color: themeProvider.color242434OrWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.content ??
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.title ??
                          const Text(
                            '标题',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                      const SizedBox(height: 10),
                      widget.message,
                    ],
                  ),
                ),
            // const SizedBox(height: 20),
            Divider(),
            widget.buttonBar ??
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: widget.onCancel ?? DialogCenter.dismiss,
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: widget.cancelTitle ??
                            Text(
                              '取消',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeProvider.subtitleColor,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 0.5,
                      height: 46,
                      child: VerticalDivider(),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: widget.onConfirm ?? DialogCenter.dismiss,
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: widget.confirmTitle ??
                            const Text(
                              '确定',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
