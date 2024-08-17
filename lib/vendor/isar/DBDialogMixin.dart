import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

mixin DBDialogMxin<T extends StatefulWidget> on State<T> {
  presentDialog({
    required TextEditingController controller,
    required ValueChanged<String> onSure,
  }) {
    // controller.text = text ?? "项目${IntExt.random(max: 999)}";

    AlertDialog(
      title: const Text("提示"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: "请输入",
              fillColor: Colors.white,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          NFooterButtonBar(
            primary: Colors.red,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            enable: true,
            // hideCancel: true,
            // isReverse: true,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onConfirm: () {
              onSure(controller.text);
              Navigator.of(context).pop();
            },
            // gap: 0,
            // btnBorderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    ).toShowDialog(context: context);
  }
}
