//
//  ExpandIconDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 10:03 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_view_segment_control.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';
import 'package:flutter_templet_project/basicWidget/visible_container.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

import 'package:tuple/tuple.dart';

class ExpandIconDemo extends StatefulWidget {

  final String? title;

  ExpandIconDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ExpandIconDemoState createState() => _ExpandIconDemoState();
}

class _ExpandIconDemoState extends State<ExpandIconDemo> {

  late bool _isExpanded = false;

  List<Color> colors = [
    Colors.black,
    Colors.pink,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  var selectedColor = ValueNotifier(Colors.black);

  List<int> _foldIndexs = List.generate(5, (index) => index);

  // List<Tuple2<List<String>, int>> foldList = _foldIndexs.map((e){
  //   final i = _foldIndexs.indexOf(e);
  //   return Tuple2(List.generate(8, (index) => "item${i}_$index"), i);
  // }).toList();


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: ListView(
        children: [
          SectionHeader.h4(title: "ExpansionTile",),
          buildExpandColorMenu(),
          // Divider(),
          SectionHeader.h4(title: "ListViewSegmentControl"),
          buildListViewHorizontal(),
          Divider(),
          SectionHeader.h4(title: "Visibility", ),
          _buildVisbility(),
          Divider(),
          SectionHeader.h4(title: "自定义 VisibleContainer",),
          _buildVisibleContainer(),
          Divider(),
          SectionHeader.h4(title: "自定义 FoldMenu", ),
          FoldMenu(
            children: [
              Tuple2(List.generate(8, (index) => "item0_$index"), 0),
              Tuple2(List.generate(8, (index) => "item1_$index"), 1),
              Tuple2(List.generate(8, (index) => "item2_$index"), 2),
              Tuple2(List.generate(8, (index) => "item3_$index"), 3),
              Tuple2(List.generate(8, (index) => "item4_$index"), 4),
            ],
            foldCount: 3,
            isVisible: _isVisible,
            onValueChanged: (row, index, indexs){
              ddlog("${row}, ${index}, ${indexs}");
            },
          )
        ],
      ),
    );
  }



  Widget buildExpandColorMenu() {
    return ExpansionTile(
      leading: Icon(Icons.color_lens, color: selectedColor.value,),
      title: Text('颜色主题', style: TextStyle(color: selectedColor.value),),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((e) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedColor.value = e;
                  });
                  ddlog(e.nameDes,);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  color: e,
                  child: selectedColor.value == e ? Icon(Icons.done, color: Colors.white,) : null,
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  ///设置单个宽度
  Widget buildListViewHorizontal({List<String>? titles}) {
    var items = titles ?? List.generate(8, (index) => "item_$index");
    List<double> itemWiths = [60, 70, 80, 90, 100, 110, 120, 130];

    return ListViewSegmentControl(
      items: items,
      // itemWidths: itemWiths,
      selectedIndex: 0,
      onValueChanged: (index){
        ddlog(index);
      });
  }

  bool _isShowing = true;
  _buildVisbility() {
    return Container(
      color: Colors.green,
      child: Column(
        children: [
          SizedBox(height:5),
          buildListViewHorizontal(),
          Visibility(
            visible: _isShowing,
            child:
              Column(
                children: [
                  SizedBox(height: 5),
                  buildListViewHorizontal(titles: List.generate(8, (index) => "item4_$index")),
                  SizedBox(height: 5),
                  buildListViewHorizontal(titles: List.generate(8, (index) => "item5_$index")),
                  SizedBox(height: 5),
                ]
              ),
          ),
          IconButton(
            icon: _isShowing ? Icon(Icons.keyboard_arrow_up) : Icon(
                Icons.keyboard_arrow_down),
            onPressed: () {
              setState(() {
                _isShowing = !_isShowing;
              });
          },)
        ]
      ),
    );
  }


  bool _isVisible = true;
  _buildVisibleContainer() {
    return VisibleContainer(
        isVisible: _isVisible,
        // indicator: ListTile(
        //   leading: Icon(Icons.fourteen_mp),
        //   title: Text("title"),
        //   subtitle: Text("subtitle"),
        //   trailing: RotatedBox(
        //     quarterTurns: _isVisible == true ? 2 : 0,
        //     child: Icon(Icons.keyboard_arrow_down),
        //   ),
        // //   trailing: Icon(Icons.chevron_right),
        //   onTap: () {
        //     setState(() {
        //       _isVisible = !_isVisible;
        //     });
        //   }
        // ),
        header: Container(
          color: Colors.orange,
          // height: 50,
          child: Column(
            children: [
              SizedBox(height:5),
              buildListViewHorizontal(titles: List.generate(8, (index) => "item1_$index")),
              SizedBox(height:5),
            ]
          ),
        ),
        body: Column(
          children: [
            SizedBox(height:5),
            buildListViewHorizontal(titles: List.generate(8, (index) => "item4_$index")),
            SizedBox(height:5),
            buildListViewHorizontal(titles: List.generate(8, (index) => "item5_$index")),
            SizedBox(height:5),
          ]
      ),
    );
  }

}

