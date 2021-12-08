//
//  ProgressHudDemoNew.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 3:50 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_templet_project/extensions/ddlog.dart';

final GlobalKey _globalKey = GlobalKey();

class ProgressHudDemoNew extends StatefulWidget {

  final String? title;

  ProgressHudDemoNew({ Key? key, this.title}) : super(key: key);


  @override
  _ProgressHudDemoNewState createState() => _ProgressHudDemoNewState();
}

class _ProgressHudDemoNewState extends State<ProgressHudDemoNew> {
  var titles = ["0", "1", "2",
    "3", "4", "5", "6", "7", "8"];



  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      // body: buildGridView(titles, context)
      // body: buildProgressHUD(context),
      body: buildColumn(context),
    );
  }

  Widget buildGridView(List<String> list, BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      //一行多少个
      crossAxisCount: 3,
      //滚动方向
      scrollDirection: Axis.vertical,
      // 左右间隔
      crossAxisSpacing: 8,
      // 上下间隔
      mainAxisSpacing: 8,
      //宽高比
      childAspectRatio: 1 / 0.3,

      children: initListWidget(list, context),
    );
  }

  List<Widget> initListWidget(List<String> list, BuildContext context) {
    List<Widget> lists = [];
    for (var e in list) {
      lists.add(
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${e}", style: TextStyle(fontSize: 12),),
            ],
          ),
        )
            .border(all: 1, color: Colors.lightBlue,)
            .gestures(onTap: () => {
          // ddlog("$e")
          _onPressed(list.indexOf(e), context)
        }),
      );
    }
    return lists;
  }

  void _onPressed(int e, BuildContext context) {
    ddlog(e);

    switch (e) {
      case 0:
        {

        }
        break;
      case 1:
        {

        }
        break;
      case 2:
        {
        }
        break;
      default:
        break;
    }
  }

  Widget buildColumn(BuildContext context) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => ToastNoContext(),
              // ));
              Get.toNamed(APPRouter.toastNoContext, arguments: "array");
            },
            child: Text("Flutter Toast No Context"),
          ),
          SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => ToastContext(),
              // ));
              Get.toNamed(APPRouter.toastContext, arguments: "array");

            },
            child: Text("Flutter Toast Context"),
          ),
        ],
      );
  }
}


/**
 *  ToastContext
 */
class ToastContext extends StatefulWidget {
  @override
  _ToastContextState createState() => _ToastContextState();
}

class _ToastContextState extends State<ToastContext> {

  FToast fToast = FToast();

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("This is a Custom Toast"),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      ddlog(_globalKey.currentState);
      fToast.init(_globalKey.currentState!.context);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Toasts"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Show Custom Toast"),
            onPressed: () {
              _showToast();
            },
          ),
          ElevatedButton(
            child: Text("Show Custom Toast via PositionedToastBuilder"),
            onPressed: () {
              _showBuilderToast();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Custom Toast With Close Button"),
            onPressed: () {
              _showToastCancel();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Queue Toasts"),
            onPressed: () {
              _queueToasts();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Cancel Toast"),
            onPressed: () {
              _removeToast();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: Text("Remove Queued Toasts"),
            onPressed: () {
              _removeAllQueuedToasts();
            },
          ),
        ],
      ),
    );
  }

  _showToast() {
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showBuilderToast() {
    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
  }

  _showToastCancel() {
    Widget toastWithButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              "This is a Custom Toast This is a Custom Toast This is a Custom Toast This is a Custom Toast This is a Custom Toast This is a Custom Toast",
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
            ),
            color: Colors.white,
            onPressed: () {
              fToast.removeCustomToast();
            },
          )
        ],
      ),
    );
    fToast.showToast(
      child: toastWithButton,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 50),
    );
  }

  _queueToasts() {
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  _removeToast() {
    fToast.removeCustomToast();
  }

  _removeAllQueuedToasts() {
    fToast.removeQueuedCustomToasts();
  }
}


/**
 *  ToastNoContext
 */
class ToastNoContext extends StatefulWidget {
  @override
  _ToastNoContextState createState() => _ToastNoContextState();
}

class _ToastNoContextState extends State<ToastNoContext> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Toast'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Show Long Toast'),
                  onPressed: showLongToast),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Show Short Toast'),
                  onPressed: showShortToast),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Show Center Short Toast'),
                  onPressed: showCenterShortToast),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Show Top Short Toast'),
                  onPressed: showTopShortToast),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Show Colored Toast'),
                  onPressed: showColoredToast),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  child: Text('Show  Web Colored Toast'),
                  onPressed: showWebColoredToast),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                child: Text('Cancel Toasts'),
                onPressed: cancelToast,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLongToast() {
    Fluttertoast.showToast(
      msg: "This is Long Toast",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black54,
      fontSize: 18.0,
    );
  }

  void showWebColoredToast() {
    Fluttertoast.showToast(
      msg: "This is Colored Toast with android duration of 5 Sec",
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#e74c3c",
      textColor: Colors.white,
      backgroundColor: Colors.black54,
      timeInSecForIosWeb: 5,
    );
  }

  void showColoredToast() {
    Fluttertoast.showToast(
        msg: "This is Colored Toast with android duration of 5 Sec",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void showShortToast() {
    Fluttertoast.showToast(
        msg: "This is Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        timeInSecForIosWeb: 1);
  }

  void showTopShortToast() {
    Fluttertoast.showToast(
        msg: "This is Top Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1);
  }

  void showCenterShortToast() {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  void cancelToast() {
    Fluttertoast.cancel();
  }
}
