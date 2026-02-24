// // !!! 关键引入：Web环境下必须先判断 kIsWeb !!!
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:context_menu/context_menu.dart';
// import 'package:flutter_context_menu/flutter_context_menu.dart';
//
// class SmartInputField extends StatefulWidget {
//   final TextEditingController controller;
//   const SmartInputField({
//     super.key,
//     required this.controller,
//   });
//
//   @override
//   State<SmartInputField> createState() => _SmartInputFieldState();
// }
//
// class _SmartInputFieldState extends State<SmartInputField> {
//   // 【关键点1】：FocusNode是桌面和Web焦点管理的核心
//   final FocusNode _focusNode = FocusNode();
//
//   // 构建右键菜单项
//   List<ContextMenuButton> _buildContextMenuItems() {
//     return [
//       ContextMenuButton(label: '复制', onPressed: _copy),
//       ContextMenuButton(label: '粘贴', onPressed: _paste),
//     ];
//   }
//
//   void _copy() {
//     final text = widget.controller.selection.textInside(widget.controller.text);
//     if (text.isNotEmpty) {
//       Clipboard.setData(ClipboardData(text: text));
//     }
//   }
//
//   Future<void> _paste() async {
//     final data = await Clipboard.getData(Clipboard.kTextPlain);
//     if (data != null) {
//       widget.controller.text = data.text!;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 【关键点2】：正确的平台判断顺序！Web优先！
//     bool needDesktopContextMenu = kIsWeb || (!Platform.isAndroid && !Platform.isIOS);
//
//     Widget textField = TextField(
//       controller: widget.controller,
//       focusNode: _focusNode, // 绑定FocusNode
//       decoration: const InputDecoration(hintText: '试试右键或快捷键'),
//     );
//
//     // 仅为桌面/Web环境包裹右键菜单
//     if (needDesktopContextMenu) {
//       textField = ContextMenuRegion(
//         contextMenu: ContextMenu(buttons: _buildContextMenuItems()),
//         child: textField,
//       );
//     }
//
//     // 【关键点3】：用Shortcuts/Actions声明快捷键
//     return Shortcuts(
//       shortcuts: const {
//         SingleActivator(LogicalKeyboardKey.keyC, control: true): CopyIntent(),
//         SingleActivator(LogicalKeyboardKey.keyV, control: true): PasteIntent(),
//       },
//       child: Actions(
//         actions: {
//           CopyIntent: CallbackAction<CopyIntent>(onInvoke: (_) => _copy()),
//           PasteIntent: CallbackAction<PasteIntent>(onInvoke: (_) => _paste()),
//         },
//         child: textField,
//       ),
//     );
//   }
// }
//
// // 定义“意图”，连接快捷键和动作
// class CopyIntent extends Intent {
//   const CopyIntent();
// }
//
// class PasteIntent extends Intent {
//   const PasteIntent();
// }
