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
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Container(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(1969, 1, 1),
            onDateTimeChanged: (DateTime newDateTime) {
              // Do something
            },
          ),
        ),
    );
  }

}


