import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NNPickerTooBar extends StatelessWidget {

  const NNPickerTooBar({
  	Key? key,
    this.height = 45,
    this.width = double.infinity,
    this.title = '请选择',
    this.actionTitles = const ['取消', '确定'],
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String title;
  final List<String> actionTitles;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.blueAccent)
      // ),
      child: NavigationToolbar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(12),
          child: Text(actionTitles[0]),
          onPressed: onCancel,
        ),
        middle: Text(title,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              backgroundColor: Colors.white,
              decoration: TextDecoration.none
          ),
          textAlign: TextAlign.center,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(12),
          child: Text(actionTitles[1]),
          onPressed: onConfirm,
        ),
      ),
    );
  }

  // buildTitleBar({
  //   String title = '请选择',
  //   List<String> actionTitles = const ['取消', '确定'],
  //   required VoidCallback onCancel,
  //   required VoidCallback onConfirm,
  // }) {
  //   return Row(
  //     children: [
  //       CupertinoButton(
  //         padding: EdgeInsets.all(12),
  //         child: Text(actionTitles[0]),
  //         onPressed: onCancel,
  //       ),
  //       Expanded(
  //         child: Text(title,
  //           style: TextStyle(
  //             fontSize: 17,
  //             fontWeight: FontWeight.normal,
  //             color: Colors.black,
  //             backgroundColor: Colors.white,
  //             decoration: TextDecoration.none,
  //           ),
  //           textAlign: TextAlign.center,
  //         )
  //       ),
  //       CupertinoButton(
  //         padding: EdgeInsets.all(12),
  //         child: Text(actionTitles[1]),
  //         onPressed: onConfirm,
  //       ),
  //     ],
  //   );
  // }
}