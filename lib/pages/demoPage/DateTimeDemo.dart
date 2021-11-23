//
//  DateTimeDemo.dart
//  fluttertemplet
//
//  Created by shang on 8/3/21 2:36 PM.
//  Copyright © 8/3/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';


class DateTimeDemo extends StatefulWidget {

  final String? title;
  DateTimeDemo({ Key? key, this.title}) : super(key: key);


  @override
  _DateTimeDemoState createState() => _DateTimeDemoState();
}

class _DateTimeDemoState extends State<DateTimeDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(onPressed: (){
              _handleDateTime();

            }, child: Text("done", style: TextStyle(color: Colors.white),)),
          ],
        ),
        body: _buildInputDatePickerFormField(),
    );
  }

  void _handleDateTime() {
    String _time = "2012-02-27 13:27:00";
    var dateTime = DateTime.parse(_time);//字符串转时间
    var interval = dateTime.millisecondsSinceEpoch;//时间转毫秒时间戳
    var intendtime = DateTime.fromMillisecondsSinceEpoch(interval);//毫秒时间戳转时间

    ddlog(dateTime);
    ddlog(interval);
    ddlog(intendtime);
  }


  DateTime? selectedDate;

  Widget _buildInputDatePickerFormField() {
    final firstDate = DateTime(DateTime.now().year - 120);
    final lastDate = DateTime.now();

    return Container(
      padding: EdgeInsets.all(10),
      child: InputDatePickerFormField(
        firstDate: firstDate,
        lastDate: lastDate,
        fieldLabelText: "fieldLabelText",
        errorFormatText: 'errorFormatText',
        errorInvalidText: 'errorInvalidText',
        onDateSubmitted: (date) {
          print(date);
          setState(() {
            selectedDate = date;
          });
        },
        onDateSaved: (date) {
          print(date);
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

}
