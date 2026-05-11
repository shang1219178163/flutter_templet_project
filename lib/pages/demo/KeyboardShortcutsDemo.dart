import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/util/dlog.dart';

/// 键盘开借鉴
class KeyboardShortcutsDemo extends StatefulWidget {
  const KeyboardShortcutsDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<KeyboardShortcutsDemo> createState() => _KeyboardShortcutsDemoState();
}

class _KeyboardShortcutsDemoState extends State<KeyboardShortcutsDemo> {
  final scrollController = ScrollController();
  final controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: buildTextfield(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextfield() {
    Widget textField = TextField(
      controller: controller,
      focusNode: _focusNode, // 绑定FocusNode
      decoration: const InputDecoration(hintText: '请输入'),
    );

    // 【关键点3】：用Shortcuts/Actions声明快捷键
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyC, control: true): CopyIntent(),
        SingleActivator(LogicalKeyboardKey.keyV, control: true): PasteIntent(),
      },
      child: Actions(
        actions: {
          CopyIntent: CallbackAction<CopyIntent>(onInvoke: (_) => onCopy()),
          PasteIntent: CallbackAction<PasteIntent>(onInvoke: (_) => onPaste()),
        },
        child: textField,
      ),
    );
  }

  void onCopy() {
    DLog.d(controller.text);
    var text = controller.selection.textInside(controller.text);
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> onPaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    var text = data?.text ?? "";
    DLog.d(text);
    if (text.isNotEmpty) {
      controller.text = text;
    }
  }
}

// 定义“意图”，连接快捷键和动作
class CopyIntent extends Intent {
  const CopyIntent();
}

class PasteIntent extends Intent {
  const PasteIntent();
}
