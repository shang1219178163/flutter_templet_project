import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_templet_project/basicWidget/dialog_center_alert.dart';

/// DialogCenter 单按钮
class DialogCenterSingleButton extends DialogCenterAlert {
  DialogCenterSingleButton({
    super.key,
    required super.title,
    required super.message,
    super.tips,
    String? buttonTitle,
    VoidCallback? onPressed,
  }) : super(
          buttonBar: TextButton(
            onPressed: onPressed ?? DialogCenter.dismiss,
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              buttonTitle ?? '关闭',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5F40FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

  static Future show({
    required String title,
    required String message,
    String tips = "",
    String? buttonTitle,
    VoidCallback? onPressed,
  }) {
    return SmartDialog.show(
      alignment: Alignment.center,
      clickMaskDismiss: false,
      builder: (_) {
        return DialogCenterSingleButton(
          title: title,
          message: message,
          tips: tips,
          buttonTitle: buttonTitle,
          onPressed: onPressed,
        );
      },
    );
  }

  static Future<void> dismiss() {
    return SmartDialog.dismiss();
  }
}
