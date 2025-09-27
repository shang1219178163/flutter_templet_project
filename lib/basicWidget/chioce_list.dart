import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

///多选列表
class ChioceList extends StatefulWidget {
  ChioceList({
    super.key,
    this.isMutiple = false,
    required this.children,
    this.indexs = const [],
    this.canScroll = false,
    required this.callback,
    this.backgroudColor,
    this.rowHeight = 65,
  });

  final List<int> indexs;

  final List<ChioceDataModel> children;

  final void Function(List<int> indexs) callback;

  final Color? backgroudColor;

  final bool canScroll;

  final bool isMutiple;

  final double rowHeight;

  @override
  _ChioceListState createState() => _ChioceListState();
}

class _ChioceListState extends State<ChioceList> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return widget.canScroll ? _buildListViewSeparated() : _buildListView();
  }

  Widget _buildListView() {
    return Material(
      color: Colors.transparent,
      child: Container(
        // color: widget.backgroudColor,
        height: widget.rowHeight * widget.children.length.toDouble(),
        child: Scrollbar(
          controller: scrollController,
          child: ListView.builder(
              controller: scrollController,
              physics: NeverScrollableScrollPhysics(), //禁止滑动
              itemExtent: widget.rowHeight,
              itemCount: widget.children.length,
              itemBuilder: (BuildContext context, int index) {
                final e = widget.children[index];
                return Container(
                  decoration: BoxDecoration(
                    // color: widget.backgroudColor,
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: ListTile(
                    dense: true,
                    // tileColor: Colors.white,
                    leading: e.secondary,
                    title: e.title,
                    subtitle: e.subtitle,
                    trailing: widget.indexs.contains(index) ? Icon(Icons.check) : null,
                    selected: widget.indexs.contains(index),
                    onTap: () {
                      _changeValue(widget.children.indexOf(e));
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildListViewSeparated() {
    return Material(
      // color: Colors.transparent,
      color: widget.backgroudColor,
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
            color: Color(0xFFe4e4e4),
          );
        },
      ).toCupertinoScrollbar(),
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
