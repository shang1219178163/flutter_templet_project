//
//  NTree.dart
//  flutter_templet_project
//
//  Created by shang on 2023/4/1 07:30.
//  Copyright © 2023/4/1 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/nn_slider.dart';

class NTree extends StatefulWidget {

  NTree({
    Key? key,
    this.title,
    required this.list,
    this.nodeBuilder,
    this.prefixBuilder,

  }) : super(key: key);

  String? title;

  List<NTreeNodeModel> list;

  // IndexedWidgetBuilder? title;

  ValueChangedWidgetBuilder<NTreeNodeModel>? nodeBuilder;

  Widget Function(BuildContext context, int level, NTreeNodeModel model)? titleBuilder;

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
    return _buildBody(list: widget.list, level: 0);
  }

  _buildBody({
    required List<NTreeNodeModel> list,
    int level = 0,
  }) {
    return Column(
      children: widget.list.map((e) => _buildNode(e: e, level: level)).toList(),
    );
  }

  Widget _buildNode({required NTreeNodeModel e, int level = 0}){
    return StatefulBuilder(
      builder: (ctx, setState) {
        final leading = e.isSelected ? Icon(Icons.check_box_outline_blank, ) : Icon(Icons.check_box, );
        final trailing = e.child.isEmpty ? SizedBox() :
          (e.isExpand ? Icon(Icons.keyboard_arrow_down, ) : Icon(Icons.keyboard_arrow_right, ));
        return Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 10),
            leading: leading,
            trailing: trailing,
            title: widget.titleBuilder?.call(context, level, e) ?? Text("${"_"*level}${e.name}"),
            initiallyExpanded: e.isExpand,
            onExpansionChanged: (val){
              if (val == null) return;
              e.isExpand = val;
              level = 0;
              setState((){});
            },
            children: e.child.map((e) => _buildNode(e: e, level: ++level)).toList() ,
          ),
        );
      }
    );
  }
}



class NTreeNodeModel{

  NTreeNodeModel({
    this.name,
    this.isExpand = false,
    this.isSelected = false,
    this.enabled = true,

    this.data,
    this.child = const [],
  });

  String? name;

  bool isExpand;

  bool isSelected;
  bool enabled;

  NTreeNodeModel? data;

  List<NTreeNodeModel> child;

}