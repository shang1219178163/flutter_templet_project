import 'package:flutter/material.dart';

class TestPageOne extends StatelessWidget {

  const TestPageOne({
  	Key? key,
  	this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    print("$this:$context");

    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? "$this"),
          actions: ['done',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onDone,)
          ).toList(),
        ),
        body: Text(arguments.toString())
    );
  }

  onDone() {
    print("onDone");
  }
}