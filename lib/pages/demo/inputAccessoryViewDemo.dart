import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/KeyboardAccessoryController.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:get/get.dart';

/// 键盘辅助视图
class InputAccessoryViewDemo extends StatefulWidget {
  const InputAccessoryViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<InputAccessoryViewDemo> createState() => _InputAccessoryViewDemoState();
}

class _InputAccessoryViewDemoState extends State<InputAccessoryViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final focusNode = FocusNode();
  final textController = TextEditingController();

  final focusNodeNew = FocusNode();

  final keyboardAccessoryController = KeyboardAccessoryController();

  @override
  void dispose() {
    keyboardAccessoryController.hide();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      DLog.d(["focusNode.hasFocus", focusNode.hasFocus]);
      if (focusNode.hasFocus) {
        keyboardAccessoryController.show(
          context,
          buildToolbar(
            focusNode: focusNodeNew,
            controller: textController,
            onChanged: (v) {
              DLog.d(v);
            },
          ),
        );
      } else {
        keyboardAccessoryController.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
            buildText(
              focusNode: focusNode,
              controller: textController,
              onChanged: (v) {
                DLog.d("onChanged $v");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText({
    required FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    void onInput(String v) {
      DLog.d(v);
      final num = int.tryParse(v) ?? 0;
      if (num <= 0) {
        return;
      }
      onChanged(num);
    }

    return TextField(
      focusNode: focusNode,
      controller: controller,
      // textAlign: TextAlign.center,
      maxLines: 1,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxHeight: 32,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        hintText: "自定义",
        hintStyle: TextStyle(color: Color(0xFFA7A7AE), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (v) => onInput.debounce.call(v),
    );
  }

  Widget buildToolbar({
    FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        children: [
          // TextButton(
          //   onPressed: () => focusNode.unfocus(),
          //   child: const Text("完成"),
          // ),
          Container(
            width: 300,
            child: buildText(
              focusNode: focusNode,
              controller: controller,
              onChanged: onChanged,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard_hide),
            onPressed: () => focusNode?.unfocus(),
          ),
        ],
      ),
    );
  }
}
