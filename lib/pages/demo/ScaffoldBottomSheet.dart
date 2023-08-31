

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/im_textfield_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

/// 键盘辅助视图
class ScaffoldBottomSheet extends StatefulWidget {

  ScaffoldBottomSheet({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _ScaffoldBottomSheetState createState() => _ScaffoldBottomSheetState();
}

class _ScaffoldBottomSheetState extends State<ScaffoldBottomSheet> {

  final _inputController = TextEditingController();

  final list = List.generate(20, (i) => "item_$i").toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) =>
            TextButton(
              child: Text(e,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      // bottomSheet: buildInputBar(),
      bottomSheet: buildInputView(
        onChanged: (String value) {
          list.insert(0, value);
          setState(() {});
        }
      ),
      body: Column(
        children: [
          buildInputBar(),
          Expanded(
            child: ListView(
              children: list.map((e) {

                return buildCell(
                  onDismissed: (direction) {
                    list.remove(e);
                  },
                  child: ListTile(title: Text(e),)
                );
              }).toList(),
            )
          ),
        ]
      )
    );
  }

  Widget buildCell({
    required Widget child,
    DismissDirectionCallback? onDismissed,
  }) {
    if (onDismissed == null) {
      return child;
    }
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.green,
        // child: Text("删除"),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        // child: Text("删除"),
      ),
      onDismissed: onDismissed,
      child: child,
    );
  }

  Widget buildInputBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '请输入',
        ),
      ),
    );
  }

  buildInputView({
    required ValueChanged<String>? onChanged,
  }) {
    final bottom = MediaQuery.of(context).padding.bottom;

    if (MediaQuery.of(context).viewInsets.bottom <= 300) {
      return SizedBox();
    }

    _inputController.text = "键盘辅助视图";
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: max(12, bottom),
      ),
      child: TextField(
        controller: _inputController,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          // prefixIcon: const Icon(Icons.keyboard_alt_outlined),
          suffixIcon: Container(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   padding: EdgeInsets.zero,
              //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   minimumSize: Size(50, 18),
              // ),
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.zero,
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(50, 18)
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    // side: BorderSide(color: Colors.red),
                  )
                ),
              ),
              onPressed: () {
                if (_inputController.text.isNotEmpty) {
                  onChanged?.call(_inputController.text.trim());
                }
              },
              child: Text("确定",
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        onSubmitted: (_) => onChanged?.call(_inputController.text.trim()),
      ),
    );
  }

//   buildInputView({
//     required ValueChanged<String>? onChanged,
// }) {
//     final bottom = MediaQuery.of(context).padding.bottom;
//
//     if (MediaQuery.of(context).viewInsets.bottom <= 300) {
//       return SizedBox();
//     }
//
//     _inputController.text = "键盘辅助视图";
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black12,
//       ),
//       padding: EdgeInsets.only(
//         top: 12,
//         left: 12,
//         right: 12,
//         bottom: max(12, bottom),
//       ),
//       child: TextField(
//         controller: _inputController,
//         minLines: 1,
//         maxLines: 4,
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.all(8),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           // prefixIcon: const Icon(Icons.keyboard_alt_outlined),
//           suffixIcon: IconButton(
//             onPressed: () {
//               if (_inputController.text.isNotEmpty) {
//                 onChanged?.call(_inputController.text.trim());
//               }
//             },
//             icon: Icon(Icons.send, color: Theme.of(context).primaryColor,),
//           ),
//         ),
//         onSubmitted: (_) => onChanged?.call(_inputController.text.trim()),
//       ),
//     );
//   }

}