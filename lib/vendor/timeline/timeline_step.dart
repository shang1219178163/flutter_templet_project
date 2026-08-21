//
//  TimelineStep.dart
//  flutter_templet_project
//
//  Created by shang on 12/13/21 5:14 PM.
//  Copyright © 12/13/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class TimelineStep extends StatefulWidget {

  const TimelineStep({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _TimelineStepState createState() => _TimelineStepState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _TimelineStepState extends State<TimelineStep> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Text(arguments.toString()),
    );
  }
}
