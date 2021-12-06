import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/widget_extension.dart';

import 'chioce_wrap.dart';


///多选列表
class ChioceList extends StatefulWidget {

  ChioceList({
    this.isMutiple = false,
    required this.children,
    required this.indexs,
    required this.canScroll,
    required this.callback,
    this.backgroudColor,
  });

  List<int> indexs = <int>[];

  var children = <ChioceModel>[];

  void Function(List<int> indexs) callback;

  final Color? backgroudColor;

  bool canScroll = false;

  bool isMutiple;

  @override
  _ChioceListState createState() => _ChioceListState();
}

class _ChioceListState extends State<ChioceList> {

  @override
  Widget build(BuildContext context) {
    return widget.canScroll ? _buildListViewSeparated(context) : _buildListView(context);
  }

  Widget _buildListView(BuildContext context) {
    return Material(
      child: Container(
        color: widget.backgroudColor ?? Colors.black.withAlpha(35),
        height: 73 * widget.children.length.toDouble(),
        width: 0,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),//禁止滑动
          children: widget.children.map((e) => ListTile(
            title: e.title,
            subtitle: e.subtitle,
            trailing: widget.indexs.contains(widget.children.indexOf(e)) ? Icon(Icons.check) : null,
            selected: widget.indexs.contains(widget.children.indexOf(e)),
            onTap: (){
              _changeValue(widget.children.indexOf(e));
            },
          ),).toList(),
        )
      )
    );
  }

  Widget _buildListViewSeparated(BuildContext context) {
    return Material(
      // color: Colors.transparent,
      color: widget.backgroudColor ?? Colors.black.withAlpha(35),
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        itemCount: widget.children.length,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          final e = widget.children[index];
          return ListTile(
            title: e.title,
            subtitle: e.subtitle,
            trailing: widget.indexs.contains(index) ? Icon(Icons.check) : null,
            selected: widget.indexs.contains(index),
            onTap: () {
              _changeValue(index);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            indent: 15,
            endIndent: 15,
            color: Color(0xFFDDDDDD),
          );
        },
      ).addCupertinoScrollbar(),
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
