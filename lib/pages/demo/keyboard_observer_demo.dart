import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:get/get.dart';

class KeyboardObserverDemo extends StatefulWidget {
  const KeyboardObserverDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<KeyboardObserverDemo> createState() => _KeyboardObserverDemoState();
}

class _KeyboardObserverDemoState extends State<KeyboardObserverDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final pressedKeysVN = ValueNotifier<Set<LogicalKeyboardKey>>(Set());

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleEvent);
  }

  @override
  void dispose() {
    super.dispose();
    HardwareKeyboard.instance.removeHandler(_handleEvent);
  }

  bool _handleEvent(event) {
    pressedKeysVN.value = HardwareKeyboard.instance.logicalKeysPressed;

    final result = HardwareKeyboard.instance.logicalKeysPressed.containsAll([
      LogicalKeyboardKey.controlLeft,
      LogicalKeyboardKey.keyA,
    ]);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("键盘监听"),
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
            ValueListenableBuilder(
              valueListenable: pressedKeysVN,
              builder: (context, keys, child) {
                final result = keys.map((e) => e.keyLabel).join(" + ");
                return Column(
                  children: [
                    Text("${pressedKeysVN.value}"),
                    Text(result),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
