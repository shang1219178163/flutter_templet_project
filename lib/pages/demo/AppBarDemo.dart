

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:tuple/tuple.dart';

class AppBarDemo extends StatefulWidget {

  AppBarDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AppBarDemoState createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo> with SingleTickerProviderStateMixin {


  late final items = <Tuple2<String, VoidCallback>>[
    Tuple2('主题', onPressed),
    Tuple2('位置', onPressed),
    Tuple2('颜色', onPressed),
    Tuple2('滑动', onPressed),
    Tuple2('主题1', onPressed),
    Tuple2('位置1', onPressed),
    Tuple2('颜色1', onPressed),
    Tuple2('滑动1', onPressed),
  ];


  late final _tabController = TabController(length: items.length, vsync: this);

  late MediaQueryData mq = MediaQuery.of(context);


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      // appBar: AppBar(
      //   // title: Text(widget.title ?? "$widget"),
      //   // actions: ['done',].map((e) => TextButton(
      //   //   child: Text(e,
      //   //     style: TextStyle(color: Colors.white),
      //   //   ),
      //   //   onPressed: () => debugPrint(e),)
      //   // ).toList(),
      //   backgroundColor: Colors.green,
      //   leading: SizedBox(),
      //   leadingWidth: 0,
      //   elevation: 0,
      //   title: buildTab().toColoredBox(),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(arguments.toString()),
          Container(
            color: ColorExt.random,
            height: mq.viewPadding.top,
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text("statusBar ${mq.viewPadding.top}"),
          ),
          buildTab().toColoredBox(color: Theme.of(context).primaryColor),
        ],
      )
    );
  }

  onPressed(){

  }

  Widget buildTab() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.white,
        tabs: items.map((e) => Tab(text: e.item1)).toList(),
        // labelColor: textColor,
        // labelStyle: widget.labelStyle,
        // indicator: widget.isTabBottom ? decorationTop : decorationBom,
        onTap: (index) {
          debugPrint("index: $index");
          // setState(() { });
        },
      ),
    );
  }
}