//
//  StatefulBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 4:47 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//
///将改动局限在组件之内。

import 'package:flutter/material.dart';

class StatefulBuilderDemo extends StatefulWidget {
  final String? title;

  const StatefulBuilderDemo({Key? key, this.title}) : super(key: key);

  @override
  _StatefulBuilderDemoState createState() => _StatefulBuilderDemoState();
}

class _StatefulBuilderDemoState extends State<StatefulBuilderDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () async {
              debugPrint("done");
              await showDialogAlert();
            },
            child: Text("done", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Text(arguments.toString()),
    );
  }

  showDialogAlert() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int? selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(3, (int index) {
                  return ListTile(
                    leading: Radio<int>(
                      value: index,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() => selectedRadio = value);
                      },
                    ),
                    title: Text('Item ${index + 1}'),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }
}
