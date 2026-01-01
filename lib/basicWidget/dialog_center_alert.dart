import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_templet_project/basicWidget/dialog_center.dart';

/// DialogCenter 易用版
class DialogCenterAlert extends DialogCenter {
  DialogCenterAlert({
    super.key,
    required String title,
    required String message,
    String tips = "",
    super.cancelTitle,
    super.confirmTitle,
    super.onCancel,
    super.onConfirm,
    super.buttonBar,
  }) : super(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          message: Column(
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (tips.isNotEmpty)
                Container(
                  height: 32,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      tips,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );

  static Future show({
    required String title,
    required String message,
    String tips = "",
    Widget? cancelTitle,
    Widget? confirmTitle,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return SmartDialog.show(
      alignment: Alignment.center,
      clickMaskDismiss: false,
      builder: (_) {
        return DialogCenterAlert(
          title: title,
          message: message,
          tips: tips,
          onConfirm: onConfirm,
          cancelTitle: cancelTitle,
          confirmTitle: confirmTitle,
          onCancel: onCancel,
        );
      },
    );
  }

  static Future<void> dismiss() {
    return SmartDialog.dismiss();
    // return SmartDialog.dismiss(tag: 'IdCardDialog');
  }
}
