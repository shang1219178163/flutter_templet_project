//
//  ExpandIconDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 10:03 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_expansion_fade.dart';
import 'package:flutter_templet_project/basicWidget/n_list_view_segment_control.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/basicWidget/visible_container.dart';
import 'package:flutter_templet_project/extension/change_notifier_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

import 'package:tuple/tuple.dart';

class ExpandIconDemo extends StatefulWidget {
  final String? title;

  const ExpandIconDemo({Key? key, this.title}) : super(key: key);

  @override
  _ExpandIconDemoState createState() => _ExpandIconDemoState();
}

class _ExpandIconDemoState extends State<ExpandIconDemo> {
  late final bool _isExpanded = false;

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

  final List<int> _foldIndexs = List.generate(5, (index) => index);

  // List<Tuple2<List<String>, int>> foldList = _foldIndexs.map((e){
  //   final i = _foldIndexs.indexOf(e);
  //   return Tuple2(List.generate(8, (index) => "item${i}_$index"), i);
  // }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: ListView(
        children: [
          NSectionHeader(
            title: "ExpansionTile",
            child: buildExpandColorMenu(),
          ),
          NSectionHeader(
            title: "ListViewSegmentControl",
            child: buildListViewHorizontal(),
          ),
          NSectionHeader(
            title: "Visibility",
            child: _buildVisbility(),
          ),
          NSectionHeader(
            title: "自定义 VisibleContainer",
            child: _buildVisibleContainer(),
          ),
          NSectionHeader(
            title: "自定义 FoldMenu",
            child: NExpansionFade(
              isExpanded: false,
              childBuilder: (isExpanded, onToggle) => FoldMenu(
                children: [
                  Tuple2(List.generate(8, (index) => "item0_$index"), 0),
                  Tuple2(List.generate(8, (index) => "item1_$index"), 1),
                  Tuple2(List.generate(8, (index) => "item2_$index"), 2),
                ],
                // foldCount: 2,
                isVisible: isVisible,
                onValueChanged: (row, index, indexs) {
                  ddlog("$row, $index, $indexs");
                },
                indicator: IconButton(
                  icon: isExpanded
                      ? Icon(Icons.keyboard_arrow_up)
                      : Icon(Icons.keyboard_arrow_down),
                  onPressed: onToggle,
                ),
              ),
              expandedBuilder: (isExpanded, onToggle) => FoldMenu(
                children: [
                  Tuple2(List.generate(8, (index) => "item0_$index"), 0),
                  Tuple2(List.generate(8, (index) => "item1_$index"), 1),
                  Tuple2(List.generate(8, (index) => "item2_$index"), 2),
                  Tuple2(List.generate(8, (index) => "item3_$index"), 3),
                  Tuple2(List.generate(8, (index) => "item4_$index"), 4),
                ],
                // foldCount: 3,
                isVisible: isVisible,
                onValueChanged: (row, index, indexs) {
                  ddlog("$row, $index, $indexs");
                },
                indicator: IconButton(
                  icon: isExpanded
                      ? Icon(Icons.keyboard_arrow_up)
                      : Icon(Icons.keyboard_arrow_down),
                  onPressed: onToggle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 颜色扩展菜单
  Widget buildExpandColorMenu() {
    return Theme(
      data: ThemeData(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            iconColor: selectedColor.value,
            collapsedIconColor: selectedColor.value,
          )),
      child: ExpansionTile(
        leading: Icon(
          Icons.color_lens,
          color: selectedColor.value,
        ),
        title: Text(
          '颜色主题',
          style: TextStyle(color: selectedColor.value),
        ),
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
                    selectedColor.value = e;
                    ddlog(
                      e.nameDes,
                    );
                    setState(() {});
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: e,
                    child: selectedColor.value == e
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  ///设置单个宽度
  Widget buildListViewHorizontal({List<String>? titles}) {
    var items = titles ?? List.generate(8, (index) => "item_$index");
    var itemWiths = <double>[60, 70, 80, 90, 100, 110, 120, 130];

    return NListViewSegmentControl(
      items: items,
      // itemWidths: itemWiths,
      selectedIndex: 0,
      onValueChanged: (index) {
        ddlog(index);
      },
    );
  }

  bool _isShowing = true;

  Widget _buildVisbility() {
    return Container(
      color: Colors.green,
      child: Column(children: [
        SizedBox(height: 5),
        buildListViewHorizontal(),
        Visibility(
          visible: _isShowing,
          child: Column(children: [
            SizedBox(height: 5),
            buildListViewHorizontal(
                titles: List.generate(8, (index) => "item4_$index")),
            SizedBox(height: 5),
            buildListViewHorizontal(
                titles: List.generate(8, (index) => "item5_$index")),
            SizedBox(height: 5),
          ]),
        ),
        IconButton(
          icon: _isShowing
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            setState(() {
              _isShowing = !_isShowing;
            });
          },
        )
      ]),
    );
  }

  bool isVisible = true;

  Widget _buildVisibleContainer() {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          // height: 50,
          child: Column(
            children: [
              SizedBox(height: 5),
              buildListViewHorizontal(
                titles: List.generate(8, (index) => "item1_$index"),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Column(
            children: [
              SizedBox(height: 5),
              buildListViewHorizontal(
                titles: List.generate(8, (index) => "item4_$index"),
              ),
              SizedBox(height: 5),
              buildListViewHorizontal(
                titles: List.generate(8, (index) => "item5_$index"),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        IconButton(
          icon: isVisible
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            isVisible = !isVisible;
            setState(() {});
          },
        ),
      ],
    );
  }
}

class ExpansionTileCard extends StatefulWidget {
  ExpansionTileCard({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ExpansionTileCardState createState() => _ExpansionTileCardState();
}

class _ExpansionTileCardState extends State<ExpansionTileCard> {
  final isExpanded = false.vn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        NSectionHeader(
          title: "ExpansionTile",
          child: ExpansionTile(
            onExpansionChanged: (value) {
              isExpanded.value = value;
            },
            title: Text(
              "ExpansionTile",
              style: TextStyle(
                color: Colors.black,
                letterSpacing: -1,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            childrenPadding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            // iconColor: Colors.green,
            trailing: ValueListenableBuilder<bool>(
              valueListenable: isExpanded,
              builder: (context, value, child) {
                return buildTrailing(isExpand: value);
              },
            ),
            children: [
              Column(
                children: [
                  Container(
                    height: 200,
                    color: ColorExt.random,
                  ),
                ],
              ),
            ],
          ),
        ),
        NSectionHeader(
          title: "NExpansionFade",
          child: NExpansionFade(
            isExpanded: isExpanded.value,
            childBuilder: (isExpand, onToggle) {
              return InkWell(
                onTap: () {
                  onToggle();
                },
                child: Container(
                  height: 100,
                  color: ColorExt.random,
                ),
              );
            },
            expandedBuilder: (isExpand, onToggle) {
              return InkWell(
                onTap: () {
                  onToggle();
                },
                child: Container(
                  height: 200,
                  color: ColorExt.random,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  buildTrailing({
    Color? color,
    bool isExpand = true,
  }) {
    // return AnimatedRotation(
    //   turns: _isExpanded.value ? .5 : 0,
    //   duration: Duration(milliseconds: 300),
    //   child: Icon(
    //     // Icons.abc_sharp,
    //     Icons.arrow_drop_down_outlined,
    //     size: 40,
    //   ),
    // );

    return _buildCustomBtn(isExpand: isExpand, color: Colors.green);
  }

  _buildCustomBtn({
    bool isExpand = true,
    Color color = Colors.blueAccent,
  }) {
    final tuple = isExpand
        ? (title: "收起", icon: Icons.expand_less)
        : (title: "展开", icon: Icons.expand_more);

    return Icon(
      tuple.icon,
      size: 24,
      color: color,
    );

    return Container(
      width: 66,
      height: 30,
      // color: Colors.red,
      padding: EdgeInsets.only(left: 8, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Text(
            tuple.title,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 0),
          Icon(
            tuple.icon,
            size: 24,
            color: color,
          ),
        ],
      ),
    );
  }
}
