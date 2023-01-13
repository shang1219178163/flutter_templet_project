import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter_templet_project/basicWidget/SectionHeader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tuple/tuple.dart';

class GetWidgetDemo extends StatefulWidget {
  final String? title;

  GetWidgetDemo({Key? key, this.title}) : super(key: key);

  @override
  _GetwidgetDemoState createState() => _GetwidgetDemoState();
}

class _GetwidgetDemoState extends State<GetWidgetDemo> {
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _isList = !_isList;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: buildListView(),
      ),
    );
  }

  GlobalKey _globalKey = GlobalKey();
  GlobalKey _globalKey1 = GlobalKey();

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SectionHeader.h5(title: "color"),

            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15
              ),
              height: 100,
              child: GFBorder(
                padding: EdgeInsets.all(0),
                strokeWidth: 3,
                color: Colors.red,
                dashedLine: [2, 1],
                type: GFBorderType.rect,
                child: Container(
                  color: Colors.green,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15
              ),
              height: 100,
              child: GFBorder(
                padding: EdgeInsets.all(0),
                strokeWidth: 3,
                radius: Radius.circular(20),
                color: Colors.red,
                dashedLine: [4, 2],
                type: GFBorderType.rRect,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),

            Container(
              // margin: EdgeInsets.symmetric(
              //     horizontal: 15,
              //     vertical: 15
              // ),
              height: 100,
              width: 100,
              child: GFBorder(
                padding: EdgeInsets.all(0),
                strokeWidth: 43,
                radius: Radius.circular(20),
                color: Colors.red,
                dashedLine: [2, 0],
                type: GFBorderType.rRect,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15
              ),
              child: GFBorder(
                padding: EdgeInsets.all(0),
                // color: Color(0xFF19CA4B),
                // dashedLine: [12, 0],
                type: GFBorderType.rRect,
                radius: Radius.circular(28),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color(0x42f3be21),
                      borderRadius: BorderRadius.all(Radius.circular(28))
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}