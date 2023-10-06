//
//  ProgressHudDemoNew.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 3:50 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';

import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:tuple/tuple.dart';

final GlobalKey _globalKey = GlobalKey();

class ProgressHudDemoNew extends StatefulWidget {

  final String? title;

  const ProgressHudDemoNew({ Key? key, this.title}) : super(key: key);

  @override
  _ProgressHudDemoNewState createState() => _ProgressHudDemoNewState();
}

class _ProgressHudDemoNewState extends State<ProgressHudDemoNew> {
  var titles = ["0", "1", "2",
    "3", "4", "5", "6", "7", "8"];

  var list = [
    APPRouter.toastNoContext,
    APPRouter.toastContext,
  ];

  bool isFlag = false;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () {
            isFlag = !isFlag;
            setState(() {});
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      // body: buildGridView(titles)
      // body: buildProgressHUD(context),
      body: buildColumn(),
    );
  }

  Widget buildGridView(List<String> list,) {
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

      children: initListWidget(list,),
    );
  }

  List<Widget> initListWidget(List<String> list) {
    var lists = <Widget>[];
    for (var e in list) {
      lists.add(
        InkWell(
          onTap: (){ _onPressed(list.indexOf(e)); },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue,),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$e", style: TextStyle(fontSize: 12),),
              ],
            ),
          ),
        ),
      );
    }
    return lists;
  }

  void _onPressed(int e) {
    ddlog(e);
  }

  Widget buildColumn() {
    return
      Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: list.map((e) => ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => ToastNoContext(),
              // ));
              Get.toNamed(e, arguments: "array");
            },
            child: Text(e),
          )).toList(),
      );
  }
}



class ToastContext extends StatefulWidget {
  const ToastContext({Key? key}) : super(key: key);

  @override
  _ToastContextState createState() => _ToastContextState();
}

class _ToastContextState extends State<ToastContext> {

  ButtonStyle get buttonStyle => ElevatedButton.styleFrom(
    minimumSize: Size(100, 36),
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
  );

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

  var list = <Tuple2<String, VoidCallback>>[];


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      ddlog(_globalKey.currentState);
      fToast.init(_globalKey.currentState!.context);
    });

    list = [
      Tuple2('Show Custom Toast', _showToast, ),
      Tuple2('Show Custom Toast by PositionedToastBuilder', _showBuilderToast, ),
      Tuple2('Custom Toast With Close', _showToastCancel, ),
      Tuple2('Queue Toasts', _queueToasts, ),
      Tuple2('Cancel Toast', _removeToast, ),
      Tuple2('Remove Queued Toasts', _removeAllQueuedToasts,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToastContext"),
      ),
      body: Column(
        children: list.map((e) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: e.item2,
            // style: buttonStyle,
            child: Text(e.item1),
          ),
        ),).toList(),
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
          top: 16.0,
          left: 16.0,
          child: child,
        );
      }
    );
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


class ToastNoContext extends StatefulWidget {
  const ToastNoContext({Key? key}) : super(key: key);

  @override
  _ToastNoContextState createState() => _ToastNoContextState();
}

class _ToastNoContextState extends State<ToastNoContext> {

  var list = <Tuple2<String, VoidCallback>>[];

  bool isFlag = false;

  @override
  void initState() {
    list = [
      Tuple2('Show Long Toast', showLongToast, ),
      Tuple2('Show Short Toast', showShortToast, ),
      Tuple2('Show Center Short Toast', showCenterShortToast, ),
      Tuple2('Show Top Short Toast', showTopShortToast, ),
      Tuple2('Show Colored Toast', showColoredToast, ),
      Tuple2('Show Web Colored Toast', showWebColoredToast,),
      Tuple2('Cancel Toasts', cancelToast, ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToastNoContext'),
        actions: ['done',].map((e) => TextButton(
          onPressed: () {
            isFlag = !isFlag;
            setState(() {});
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: isFlag ? buildBody() : buildBody2(),
    );
  }

  Widget buildBody() {
    return Column(
      children: list.map((e) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: e.item2,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(e.item1),
          ),
        ),
      ),).toList(),
    );
  }

  Widget buildBody2() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: showLongToast,
          child: Text('Show Long Toast'),
        ),
        ElevatedButton(
          onPressed: showShortToast,
          child: Text('Show Short Toast'),
        ),
        ElevatedButton(
          onPressed: showCenterShortToast,
          child: Text('Show Center Short Toast'),
        ),
        ElevatedButton(
          onPressed: showTopShortToast,
          child: Text('Show Top Short Toast'),
        ),
        ElevatedButton(
          onPressed: showColoredToast,
          child: Text('Show Colored Toast'),
        ),
        ElevatedButton(
          onPressed: showWebColoredToast,
          child: Text('Show  Web Colored Toast'),
        ),
        ElevatedButton(
          onPressed: cancelToast,
          child: Text('Cancel Toasts'),
        ),
      ].map((e) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: e,
      )).toList(),
    );
  }

  void showLongToast() {
    debugPrint("showLongToast");
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
