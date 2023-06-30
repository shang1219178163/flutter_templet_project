

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_suspension.dart';

class SuspensionButtonDemo extends StatefulWidget {

  SuspensionButtonDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _SuspensionButtonDemoState createState() => _SuspensionButtonDemoState();
}

class _SuspensionButtonDemoState extends State<SuspensionButtonDemo> {

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => debugPrint(e),)
          ).toList(),
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return NSuspension(
      padding: EdgeInsets.only(left: 20, top: 30, right: 40, bottom: 50),
      childSize: Size(80, 80),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        ),
      ),
      bgChild: Container(
        color: Colors.black.withOpacity(0.1), //Color.fromRGBO(242, 243, 248, 1),
      ),
    );
  }

}