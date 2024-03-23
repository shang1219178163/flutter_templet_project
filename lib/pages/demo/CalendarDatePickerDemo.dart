//
//  CalendarDatePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:02 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/localizations/AppCupertinoLocalizations.dart';

class CalendarDatePickerDemo extends StatefulWidget {

  final String? title;

  const CalendarDatePickerDemo({ Key? key, this.title}) : super(key: key);


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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              NSectionHeader(
                title: "buildCalendarDatePicker",
                child: buildCalendarDatePicker(),
              ),
              NSectionHeader(
                title: "buildCalendarDatePicker",
                child: Column(
                  children: [
                    // Text("${selectedDate.toLocal()}".substring(0, 10)),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text("${selectedDate.toLocal()}".substring(0, 10)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }


  Widget buildCalendarDatePicker() {
    final indexs = List.generate(9, (index) => index);
    final dateTimes = indexs.map((e) => DateTime(2023, 6, e)).toList();

    return CalendarDatePicker(
      // initialCalendarMode: DatePickerMode.year,
      onDateChanged: (DateTime value) {
        debugPrint(value.toString());
      },
      firstDate: DateTime(2020, 6, 0), // 开始日期
      lastDate: DateTime(2030, 7, 0), // 结束日期
      initialDate: DateTime.now(), // 初始化选中日期
      selectableDayPredicate: (val) {
        if (val.weekday == 5 || val.weekday == 6) {
          return false;
        } else {
          return true;
        }
        return dateTimes.contains(val);
      },
    );
  }

  Widget buildCupertinoDatePicker() {
    var now = DateTime.now();
    var initialDate = DateTime(now.year, now.month, now.day, now.hour, 0);

    return Container(
      // height: 300,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        minuteInterval: 30,
        use24hFormat: true,
        initialDateTime: initialDate,
        // minimumDate: DateTime(2020, 6),
        // maximumDate: DateTime(2023, 6),
        dateOrder: DatePickerDateOrder.ymd,
        onDateTimeChanged: (DateTime newDateTime) {
          // Do something
        },
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

