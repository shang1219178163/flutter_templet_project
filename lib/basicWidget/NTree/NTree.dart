//
//  NTree.dart
//  flutter_templet_project
//
//  Created by shang on 2023/4/1 07:30.
//  Copyright © 2023/4/1 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/en_expansion_tile.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class NTree extends StatefulWidget {

  NTree({
    Key? key,
    required this.list,
    this.color = Colors.black87,
    this.iconColor = Colors.blueAccent,
    this.indent = 30,
  }) : super(key: key);

  /// 数据源
  List<NTreeNodeModel> list;
  /// 标题颜色
  Color color;
  /// 文字颜色
  Color iconColor;
  /// 层级缩进
  double indent;

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
    return Column(
      children: widget.list.map((e) {
        return Column(
          children: [
            _buildNode(
              e: e,
              color: widget.color,
              iconColor: widget.iconColor,
            ),
            if(e.isExpand)Padding(
              padding: EdgeInsets.only(left: widget.indent),
              child: NTree(
                color: widget.color,
                list: e.items,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildNode({
    required NTreeNodeModel e,
    Color? color,
    Color? iconColor,
  }){
    final leadingIcon = e.isSelected ? Icon(Icons.check_box, color: iconColor,)
        : Icon(Icons.check_box_outline_blank, color: iconColor,);
    final trailing = e.items.isEmpty ? SizedBox() :
    (e.isExpand ? Icon(Icons.keyboard_arrow_down, color: iconColor,)
        : Icon(Icons.keyboard_arrow_right, color: iconColor,));

    final leading = IconButton(
      onPressed: () {
        e.isSelected = !e.isSelected;
        recursion(e: e, cb: (item) => item.isSelected = e.isSelected,);
        setState((){});
      },
      icon: leadingIcon,
    );
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnExpansionTile(
        backgroundColor: ColorExt.random,
        // tilePadding: EdgeInsets.symmetric(horizontal: 100),
        // leading: leading,
        leading: leading,
        trailing: trailing,
        title: Text("${e.name}",
          style: TextStyle(
            color: color,
          ),
        ),
        // title: Text("${e.name}"),
        initiallyExpanded: e.isExpand,
        onExpansionChanged: (val){
          e.isExpand = val;
          e.onClick?.call(e);
          setState((){});
        },
        header: (onTap) => InkWell(
          onTap: (){
            onTap();
            e.isExpand = !e.isExpand;
            setState((){});
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 0,
              top: 4,
              bottom: 4,
              right: 16,
            ),
            child: Row(
              children: [
                leading,
                Expanded(
                  child: Text("${e.name}",
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  recursion({
     required NTreeNodeModel e,
     required void Function(NTreeNodeModel e) cb
   }) {
     cb(e);
     debugPrint("item:${e.name} ${e.isSelected}");
     e.items.forEach((item) {
       recursion(e: item, cb: cb);
    });
  }
}

class NTreeNodeModel{

  NTreeNodeModel({
    this.name,
    this.isExpand = false,
    this.isSelected = false,
    this.enabled = true,
    this.onClick,
    this.data,
    this.items = const [],
  });
  /// 标题
  String? name;
  /// 是否展开
  bool isExpand;
  /// 是否已选择
  bool isSelected;
  ///
  bool enabled;
  /// 模型
  dynamic data;
  /// 子元素
  List<NTreeNodeModel> items;
  /// 点击事件
  void Function(NTreeNodeModel e)? onClick;

  /// 遍历子树
  recursion(void Function(NTreeNodeModel e)? cb) {
    cb?.call(this);
    debugPrint("item:$name $isSelected");
    items.forEach((item) {
      recursion(cb);
    });
  }
}