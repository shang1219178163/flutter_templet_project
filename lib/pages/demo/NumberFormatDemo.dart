//
//  NumberFormatDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/3/21 2:35 PM.
//  Copyright © 8/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import "package:intl/intl.dart";


class NumberFormatDemo extends StatefulWidget {

  final String? title;
  NumberFormatDemo({ Key? key, this.title}) : super(key: key);


  @override
  _NumberFormatDemoState createState() => _NumberFormatDemoState();
}

class _NumberFormatDemoState extends State<NumberFormatDemo> {

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(onPressed: (){
              handleNumber();

            }, child: Text("done", style: TextStyle(color: Colors.white),)),
          ],
        ),
        body: Text(arguments.toString())
    );
  }

  void handleNumber() {
    final format = NumberFormat("#,##0.00", "en_US");

    ddlog("Eg. 1: ${format.format(123456789.75)}");
    ddlog("Eg. 2: ${format.format(.715)}");
    ddlog("Eg. 3: ${format.format(12345678975/100)}");
    ddlog("Eg. 4: ${format.format(int.parse('12345678975')/100)}");
    ddlog("Eg. 5: ${format.format(double.parse('123456789.75'))}");
  }
}
