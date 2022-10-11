//
//  CalendarDatePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:02 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDatePickerDemo extends StatefulWidget {

  final String? title;

  CalendarDatePickerDemo({ Key? key, this.title}) : super(key: key);


  @override
  _CalendarDatePickerDemoState createState() => _CalendarDatePickerDemoState();
}

class _CalendarDatePickerDemoState extends State<CalendarDatePickerDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          _buildHeader("buildCalendarDatePicker", ),
          buildCalendarDatePicker(),
          Divider(),
          _buildHeader("buildCupertinoDatePicker", ),
          buildCupertinoDatePicker()
        ],
      )
    );
  }

  _buildHeader(String str) {
    return Text(str, style: TextStyle(fontSize: 20,), textAlign: TextAlign.left);
  }

  buildCupertinoDatePicker() {
    return Container(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime(1969, 1, 1),
        // minimumDate: DateTime(2020, 6),
        // maximumDate: DateTime(2023, 6),
        onDateTimeChanged: (DateTime newDateTime) {
        // Do something
        },
      ),
    );
  }

  buildCalendarDatePicker() {
    return CalendarDatePicker(
      onDateChanged: (DateTime value) {
        print(value);
      },
      initialDate: DateTime.now(), // 初始化选中日期
      firstDate: DateTime(2020, 6, 0), // 开始日期
      lastDate: DateTime(2023, 6, 0), // 结束日期

    );
  }

}

c

