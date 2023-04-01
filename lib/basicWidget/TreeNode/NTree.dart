//
//  NTree.dart
//  flutter_templet_project
//
//  Created by shang on 2023/4/1 07:30.
//  Copyright © 2023/4/1 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class NTree extends StatefulWidget {

  NTree({
    Key? key,
    this.title,
    required this.list,
    // this.nodeBuilder,
    this.prefixBuilder,
    this.levelUnit = "  ",

  }) : super(key: key);

  String? title;
  /// 层级前缀单位
  String levelUnit;
  /// 数据源
  List<NTreeNodeModel> list;

  // IndexedWidgetBuilder? title;

  // ValueChangedWidgetBuilder<NTreeNodeModel>? nodeBuilder;

  Widget Function(BuildContext context, NTreeNodeModel model)? prefixBuilder;

  @override
  _NTreeState createState() => _NTreeState();
}

class _NTreeState extends State<NTree> {

  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return _buildBody(list: widget.list);
  }

  _buildBody({
    required List<NTreeNodeModel> list,
  }) {
    return Column(
      children: widget.list.map((e) => _buildNode(e: e, isRoot: true)).toList(),
    );
  }

  Widget _buildNode({required NTreeNodeModel e, bool isRoot = true}){
    return StatefulBuilder(
      builder: (ctx, setState) {

        final leading = e.isSelected ? Icon(Icons.check_box, ) : Icon(Icons.check_box_outline_blank, );
        final trailing = e.child.isEmpty ? SizedBox() :
          (e.isExpand ? Icon(Icons.keyboard_arrow_down, ) : Icon(Icons.keyboard_arrow_right, ));
        final prefix = widget.prefixBuilder?.call(context, e) ?? widget.levelUnit*e.level;
        return Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            backgroundColor: ColorExt.random,
            tilePadding: EdgeInsets.symmetric(horizontal: 10),
            // leading: leading,
            leading: IconButton(
              onPressed: () {
                e.isSelected = !e.isSelected;
                if(e.isSelected) {
                  recursion(e: e, cb: (item) => item.isSelected = e.isSelected,);
                  // e.recursion((item) { item.isSelected = e.isSelected; });
                } else {

                }
                setState((){});
              },
              icon: leading
            ),
            trailing: trailing,
            title: Text("$prefix${e.name}"),
            // title: Text("${e.name}"),
            initiallyExpanded: e.isExpand,
            onExpansionChanged: (val){
              e.isExpand = val;
              e.onClick?.call(e);
              setState((){});
            },
            children: e.child.map((e) => _buildNode(e: e, isRoot: false)).toList(),
          ),
        );
      }
    );
  }


  recursion({
     required NTreeNodeModel e,
     required void Function(NTreeNodeModel e) cb
   }) {
     cb(e);
     debugPrint("item:${e.name} ${e.isSelected}");
     e.child.forEach((item) {
       recursion(e: item, cb: cb);
    });
  }
}

class NTreeNodeModel{

  NTreeNodeModel({
    this.name,
    this.level = 0,
    this.isExpand = false,
    this.isSelected = false,
    this.enabled = true,
    this.onClick,
    this.data,
    this.child = const [],
  });
  /// 标题
  String? name;
  /// 深度级别
  int level;
  /// 是否展开
  bool isExpand;
  /// 是否已选择
  bool isSelected;
  ///
  bool enabled;
  /// 模型
  dynamic data;
  /// 子元素
  List<NTreeNodeModel> child;
  /// 点击事件
  void Function(NTreeNodeModel e)? onClick;

  /// 遍历子树
  recursion(void Function(NTreeNodeModel e)? cb) {
    cb?.call(this);
    debugPrint("item:$name $isSelected");
    child.forEach((item) {
      recursion(cb);
    });
  }
}