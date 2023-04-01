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
    this.level = 0,
  }) : super(key: key);

  String? title;

  List<NTreeNodeModel> list;

  // IndexedWidgetBuilder? title;

  ValueChangedWidgetBuilder<NTreeNodeModel>? nodeBuilder;

  int level;

  @override
  _NTreeState createState() => _NTreeState();
}

class _NTreeState extends State<NTree> {
  var _level = 0;

  @override
  void initState() {
    _level = widget.level;
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return _buildBody(list: widget.list);
  }

  _buildBody({
    required List<NTreeNodeModel> list
  }) {
    return Column(
      children: widget.list.map((e) => _buildNode(e: e)).toList(),
    );
  }

  Widget _buildNode({required NTreeNodeModel e}){
    return StatefulBuilder(
      builder: (ctx, setState) {

        final trailing = e.child.isEmpty ? SizedBox() :
        (e.isExpand ? Icon(Icons.keyboard_arrow_down, ) : Icon(Icons.keyboard_arrow_right, ));
        return Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 10),
            leading: Icon(Icons.ac_unit, ),
            trailing: trailing,
            title: Text("${e.name}"),
            initiallyExpanded: e.isExpand,
            onExpansionChanged: (val){
              if (val == null) return;
              e.isExpand = val;
              setState((){});
            },
            children: e.child.map((e) => _buildNode(e: e)).toList() ,
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