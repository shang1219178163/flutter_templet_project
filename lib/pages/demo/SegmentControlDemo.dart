
//
//  SegmentControlDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/4/21 10:54 AM.
//  Copyright © 6/4/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/line_segment_view.dart';
import 'package:flutter_templet_project/basicWidget/list_view_segment_control.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/color_extension.dart';
import 'package:styled_widget/styled_widget.dart';

class SegmentControlDemo extends StatefulWidget {

  final String? title;

  SegmentControlDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SegmentControlDemoState createState() => _SegmentControlDemoState();
}

class _SegmentControlDemoState extends State<SegmentControlDemo> {


  int groupValue = 0;


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        bottom: buildPreferredSize(context),
      ),
      body: buildListView(context),

    );
  }


  PreferredSizeWidget buildPreferredSize(BuildContext context) {
    return
      PreferredSize(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 24),
                Expanded(
                  child: CupertinoSegmentedControl(
                    children: const <int, Widget>{
                      0: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              'Midnight', style: TextStyle(fontSize: 15))),
                      1: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              'Viridian', style: TextStyle(fontSize: 15))),
                      2: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              'Cerulean', style: TextStyle(fontSize: 15)))
                    },
                    groupValue: groupValue,
                    onValueChanged: (value) {
                      // TODO: - fix it
                      ddlog(value.runtimeType);
                      ddlog(value.toString());
                      setState(() {
                        groupValue = int.parse("$value");
                      });
                    },
                    borderColor: Colors.white,

                    //   selectedColor: Colors.redAccent,
                    // unselectedColor: Colors.green,
                  ),
                ),
                SizedBox(width: 24)
              ],
            ),
          ),
          preferredSize: Size(double.infinity, 48));
  }

  Widget buildListView(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 15),
        buildSegmentedControl(context),

        SizedBox(height: 15),
        buildSlidingSegmentedControl(context).padding(left: 15, right: 15),

        SizedBox(height: 15),
        buildSlidingSegmentedControl2(context).padding(left: 15, right: 15),

        SizedBox(height: 15),
        buildSlidingSegmentedControl3(context).padding(left: 15, right: 15),

        SizedBox(height: 15),
        buildLineSegmentControl(null, lineColor: Theme.of(context).primaryColor),

        SizedBox(height: 15),
        buildLineSegmentControl(Colors.transparent, lineColor: Theme.of(context).primaryColor),

        SizedBox(height: 15),
        buildLineSegmentControl(Colors.black87, lineColor: Colors.white),

        SizedBox(height: 15),
        buildLineSegmentControl(Colors.white, lineColor: Colors.transparent),

        SizedBox(height: 15),
        buildListViewHorizontal(),

        SizedBox(height: 15),
        buildListViewHorizontal1(),
      ],
    );
  }


  final Map<int, Widget> children = <int, Widget>{
    0: Container(
      padding: EdgeInsets.all(8),
      child: Text(
          "Item 1", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
    1: Container(
      padding: EdgeInsets.all(8),
      child: Text(
          "Item 2", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
    2: Container(
      padding: EdgeInsets.all(8),
      child: Text(
          "Item 3", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
  };



  Widget buildSegmentedControl(BuildContext context) {
    return CupertinoSegmentedControl<int>(
      children: children,
      onValueChanged: (int newValue) {
        setState(() {
          groupValue = newValue;
        });
        ddlog(groupValue);
      },
      groupValue: groupValue,
      // borderColor: Colors.white,
    );
  }

  Widget buildSlidingSegmentedControl(BuildContext context) {
    final Map<int, Widget> children = const <int, Widget>{
      0: Text("Item 1", style: TextStyle(fontSize: 15),),
      1: Text("Item 2", style: TextStyle(fontSize: 15),),
      2: Text("Item 3", style: TextStyle(fontSize: 15),),
    };

    return CupertinoSlidingSegmentedControl(
      groupValue: groupValue,
      children: children,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        ddlog(groupValue);
      },
      backgroundColor: Colors.transparent,
      thumbColor: Colors.transparent,
    );
  }


  Widget buildSlidingSegmentedControl2(BuildContext context) {
    final Map<int, Widget> children = const <int, Widget>{
      0: Text("Item 1", style: TextStyle(fontSize: 15),),
      1: Text("Item 2", style: TextStyle(fontSize: 15),),
      2: Text("Item 3", style: TextStyle(fontSize: 15),),
    };

    return CupertinoSlidingSegmentedControl(
      groupValue: groupValue,
      children: children,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        ddlog(groupValue);
      },
      thumbColor: Colors.orangeAccent,
      // backgroundColor: Colors.transparent,
    );
  }

  Widget buildSlidingSegmentedControl3(BuildContext context) {
    final Map<int, Widget> children = const <int, Widget>{
      0: Text("Item 1", style: TextStyle(fontSize: 15),),
      1: Text("Item 2", style: TextStyle(fontSize: 15),),
      2: Text("Item 3", style: TextStyle(fontSize: 15),),
    };

    return CupertinoSlidingSegmentedControl(
      groupValue: groupValue,
      children: children,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        ddlog(groupValue);
      },
      // thumbColor: Colors.orangeAccent,
      backgroundColor: Colors.transparent,
    );
  }

  Widget buildLineSegmentControl(Color? backgroundColor, {required Color lineColor}) {
    final Map<int, Widget> children = const <int, Widget>{
      0: Text("Item 111", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
      1: Text("Item 222", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
      2: Text("Item 333", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
    };

    if (backgroundColor != null) {
      return LineSegmentView(
        groupValue: groupValue,
        children: children,
        backgroundColor: backgroundColor,
        lineColor: lineColor,
        onValueChanged: (i){
          setState(() {
            groupValue = int.parse("$i");
          });
          ddlog(groupValue);
        },
      );
    }
    return LineSegmentView(
      groupValue: groupValue,
      children: children,
      // backgroundColor: backgroundColor,
      lineColor: lineColor,
      // lineHeight: 5,
      // lineWidth: 50,
      onValueChanged: (i){
        setState(() {
          groupValue = int.parse("$i");
        });
        ddlog(groupValue);

      },
    );
  }

  late ScrollController _scrollController = ScrollController();

  ///设置单个宽度
  Widget buildListViewHorizontal() {
    var items = List.generate(8, (index) => "item_$index");
    List<double> itemWiths = [60, 70, 80, 90, 100, 110, 120, 130];

    return ListViewSegmentControl(
        items: items,
        // itemWidths: itemWiths,
        selectedIndex: 0,
        onValueChanged: (index){
          ddlog(index);
        });
  }

  ///默认宽度
  Widget buildListViewHorizontal1() {
    var items = List.generate(4, (index) => "item_$index");

    return ListViewSegmentControl(
        items: items,
        selectedIndex: 0,
        itemBgColor: Colors.transparent,
        itemSelectedBgColor: Colors.transparent,
        itemWidth: 70,
        itemRadius: 0,
        itemSelectedTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        onValueChanged: (index){
          ddlog(index);
        });
  }
}