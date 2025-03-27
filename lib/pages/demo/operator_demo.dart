import 'package:flutter/material.dart';

class OperatorDemo extends StatefulWidget {
  const OperatorDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _OperatorDemoState createState() => _OperatorDemoState();
}

class _OperatorDemoState extends State<OperatorDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: onPressed,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                'if (a is! int) {',
              ]
                  .map((e) => TextButton(
                        onPressed: onPressed,
                        child: Text(
                          e,
                        ),
                      ))
                  .toList(),
            )
          ],
        ));
  }

  onPressed() {}
}
