import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///时间选择器
class NNDatePicker extends StatelessWidget {

  final String? title;
  final CupertinoDatePickerMode? mode;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime> onDateTimeChanged;
  final Widget? cancellChild;
  final Widget? confirmChild;
  final VoidCallback cancellOnPressed;
  final VoidCallback confirmOnPressed;

  final double? datePickerHeight;

  ///时间选择器
  NNDatePicker({
  	Key? key,
  	this.title = "请选择",
    this.datePickerHeight = 216,
    this.mode,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.cancellChild,
    this.confirmChild,
    required this.onDateTimeChanged,
    required this.cancellOnPressed,
    required this.confirmOnPressed,
  }) : assert(datePickerHeight != null),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: (datePickerHeight! + 60),
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          Row(children: [
            CupertinoButton(
              child: cancellChild ?? Text("取消"),
              // onPressed: () => Navigator.of(ctx).pop(),
              onPressed: cancellOnPressed,
            ),
            Expanded(child: Text(title ?? "请选择",
              style: TextStyle(fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,)
            ),

            CupertinoButton(
              child: confirmChild ?? Text("确定"),
              // onPressed: () => Navigator.of(ctx).pop(),
              onPressed: confirmOnPressed
            ),
          ],),
          Container(
            height: datePickerHeight,
            color: Colors.white,
            child: CupertinoDatePicker(
                use24hFormat: true,
                mode: mode ?? CupertinoDatePickerMode.dateAndTime,
                initialDateTime: initialDateTime,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDateTimeChanged: onDateTimeChanged),
          ),
        ],
      ),
    );
  }
}