//
//  ExpandIconDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 10:03 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_expansion_fade.dart';
import 'package:flutter_templet_project/basicWidget/n_expansion_menu.dart';
import 'package:flutter_templet_project/basicWidget/n_list_view_segment_control.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

import 'package:flutter_templet_project/model/tag_detail_model.dart';

import 'package:tuple/tuple.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

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
          NSectionBox(
            title: "ExpansionTile",
            child: buildExpandColorMenu(),
          ),
          NSectionBox(
            title: "ListViewSegmentControl",
            child: buildListViewHorizontal(),
          ),
          NSectionBox(
            title: "Visibility",
            child: _buildVisbility(),
          ),
          NSectionBox(
            title: "自定义 VisibleContainer",
            child: _buildVisibleContainer(),
          ),
          NSectionBox(
            title: "自定义 FoldMenu - NExpansionFade",
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
                  DLog.d("$row, $index, $indexs");
                },
                indicator: IconButton(
                  icon: isExpanded ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
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
                  DLog.d("$row, $index, $indexs");
                },
                indicator: IconButton(
                  icon: isExpanded ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                  onPressed: onToggle,
                ),
              ),
            ),
          ),
          NSectionBox(
            title: "自定义 NExpansionMenu",
            child: buildTagChoice(),
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
        ),
      ),
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
                    DLog.d(
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
        DLog.d(index);
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
            buildListViewHorizontal(titles: List.generate(8, (index) => "item4_$index")),
            SizedBox(height: 5),
            buildListViewHorizontal(titles: List.generate(8, (index) => "item5_$index")),
            SizedBox(height: 5),
          ]),
        ),
        IconButton(
          icon: _isShowing ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
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
          icon: isVisible ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            isVisible = !isVisible;
            setState(() {});
          },
        ),
      ],
    );
  }

  /// 标签组
  List<TagDetailModel> tagModels = [];
  TagDetailModel? selectedTagModel;
  TagDetailModel? selectedTagModelTmp;

  /// 筛选弹窗 标签选择
  Widget buildTagChoice({
    bool isExpand = false,
    int collapseCount = 6,
    Color btnColor = const Color(0xffFF7E6E),
  }) {
    tagModels = List.generate(9, (i) {
      return TagDetailModel(id: "$i", name: "标签$i");
    }).toList();
    final models = tagModels;
    if (models.isEmpty) {
      return const SizedBox();
    }

    final disable = (models.length <= collapseCount);

    return StatefulBuilder(builder: (context, setState) {
      final items = isExpand ? models : models.take(collapseCount).toList();

      return NExpansionMenu(
        title: "标签",
        disable: disable,
        isExpand: isExpand,
        color: btnColor,
        onExpansionChanged: (val) {
          isExpand = !isExpand;
          setState(() {});
        },
        indicatorBuilder: (isExpand) {
          return Container(
            width: 3,
            height: 14,
            margin: EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
          );
        },
        childrenHeader: (isExpanded, onTap) => Column(
          children: [
            buildChoicePart<TagDetailModel>(
              models: items,
              cbID: (e) => e.id ?? "",
              cbName: (e) => e.name ?? "",
              cbSelected: (e) => e.id == selectedTagModelTmp?.id,
              onChanged: (values) {
                debugPrint("selectedModels: ${values.map((e) => e.data.name)}");
                if (values.isEmpty) {
                  selectedTagModelTmp = null;
                  return;
                }
                selectedTagModelTmp = values.first.data;
                setState(() {});
              },
            ),
          ],
        ),
        children: const [],
      );
    });
  }

  /// 筛选弹窗 选择子菜单
  buildChoicePart<T>({
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(T) cbSelected,
    required ValueChanged<List<ChoiceBoxModel<T>>> onChanged,
  }) {
    return NChoiceBox(
      isSingle: true,
      itemColor: Colors.transparent,
      // wrapAlignment: WrapAlignment.spaceBetween,
      items: models
          .map((e) => ChoiceBoxModel<T>(
                id: cbID(e),
                title: cbName(e),
                isSelected: cbSelected(e),
                data: e,
              ))
          .toList(),
      onChanged: onChanged,
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
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        NSectionBox(
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
        NSectionBox(
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
    final tuple = isExpand ? (title: "收起", icon: Icons.expand_less) : (title: "展开", icon: Icons.expand_more);

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
