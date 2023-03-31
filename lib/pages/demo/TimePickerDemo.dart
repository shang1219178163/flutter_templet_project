//
//  TimePickerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 3:33 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class TimePickerDemo extends StatefulWidget {

  final String? title;

  const TimePickerDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TimePickerDemoState createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<TimePickerDemo> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  Future<void> _selectTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
            ),
            SizedBox(height: 8),
            Text(
              'Selected time: ${_time.format(context)}',
            ),
          ],
        ),
      ),
    );
  }
}





