import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///时间选择器
class NDatePicker extends StatelessWidget {
  final String? title;
  final CupertinoDatePickerMode? mode;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime> onChanged;
  final Widget? cancellChild;
  final Widget? confirmChild;
  final VoidCallback onCancell;
  final VoidCallback onConfirm;

  final double? datePickerHeight;

  ///时间选择器
  const NDatePicker({
    super.key,
    this.title = "请选择",
    this.datePickerHeight = 216,
    this.mode,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.cancellChild,
    this.confirmChild,
    required this.onChanged,
    required this.onCancell,
    required this.onConfirm,
  }) : assert(datePickerHeight != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (datePickerHeight! + 60),
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              CupertinoButton(
                // onPressed: () => Navigator.of(ctx).pop(),
                onPressed: onCancell,
                child: cancellChild ?? Text("取消"),
              ),
              Expanded(
                  child: Text(
                title ?? "请选择",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              )),
              CupertinoButton(
                // onPressed: () => Navigator.of(ctx).pop(),
                onPressed: onConfirm,
                child: confirmChild ?? Text("确定"),
              ),
            ],
          ),
          Container(
            height: datePickerHeight,
            color: Colors.white,
            child: CupertinoDatePicker(
              use24hFormat: true,
              mode: mode ?? CupertinoDatePickerMode.dateAndTime,
              initialDateTime: initialDateTime,
              minimumDate: minimumDate,
              maximumDate: maximumDate,
              onDateTimeChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
