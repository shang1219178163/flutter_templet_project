//
//  chioce_wrap.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 10:42 AM.
//  Copyright © 5/17/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///多选菜单
class ChioceWrap extends StatefulWidget {

  ChioceWrap({
    Key? key,
    this.isMutiple = false,
    this.icon = const Icon(Icons.check_box_outline_blank),
    this.seletedIcon = const Icon(Icons.check_box_outlined),
    this.backgroudColor,
    required this.children,
    required this.indexs,
    required this.callback,
  }) : super(key: key);

  bool isMutiple;

  List<int> indexs = <int>[];

  final List<Widget> children;

  final Widget icon;

  final Widget seletedIcon;

  final Color? backgroudColor;

  final void Function(List<int> indexs) callback;

  @override
  _ChioceWrapState createState() => _ChioceWrapState();
}


class _ChioceWrapState extends State<ChioceWrap> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroudColor ?? Colors.transparent,
      child: Wrap(
        spacing: 8.0, // 主轴(水平)方向间距
        runSpacing: -8.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.start, //沿主轴方向居中
        children: widget.children.map((e) => TextButton.icon(
          onPressed: (){
            _changeValue(widget.children.indexOf(e));
          },
          icon: widget.indexs.contains(widget.children.indexOf(e)) ? widget.seletedIcon : widget.icon,
          label: e,
          // style: OutlinedButton.styleFrom(
          //   backgroundColor: Colors.transparent,
          //   primary: widget.selectedIndexs.contains(widget.titles.indexOf(e)) ? Theme.of(context).primaryColor : Colors.black87,
          // ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            primary: Colors.black87,
          ),
        )).toList(),
      ),
    );
  }

  void _changeValue(int value) {
    setState(() {
      if (widget.isMutiple) {
        if (widget.indexs.contains(value)) {
          widget.indexs.remove(value);
        } else {
          widget.indexs.add(value);
        }
      } else {
        if (widget.indexs.contains(value)) {

        } else {
          widget.indexs.clear();
          widget.indexs.add(value);
        }
      }
      widget.indexs.sort((a, b) => a.compareTo(b));
      widget.callback(widget.indexs);
    });
  }
}


class ChioceModel{

  ChioceModel({
    required this.title,
    required this.subtitle,
    required this.secondary,
    required this.selected,
  });

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the radio button.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// Whether to render icons and text in the [activeColor].
  ///
  /// No effort is made to automatically coordinate the [selected] state and the
  /// [checked] state. To have the list tile appear selected when the radio
  /// button is the selected radio button, set [selected] to true when [value]
  /// matches [groupValue].
  ///
  /// Normally, this property is left to its default value, false.
  late bool selected;


}