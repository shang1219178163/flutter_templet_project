//
//  list_view_segment_control.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/21 3:08 PM.
//  Copyright © 10/11/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:tuple/tuple.dart';

// ignore: must_be_immutable (水平菜单单选器)
class ListViewSegmentControl extends StatefulWidget {

  ListViewSegmentControl({
    Key? key,
    required this.items,
    required this.selectedIndex,
    this.itemWidths,
    this.height = 30,
    this.itemWidth = 100,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.margin = const EdgeInsets.symmetric(horizontal: 10),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 0),
    this.itemMargin = const EdgeInsets.symmetric(horizontal: 5),
    this.itemRadius = 15,
    this.itemTextStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.itemSelectedTextStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.itemBgColor = const Color(0xFFF5F5F5),
    this.itemSelectedBgColor =  Colors.orange,
    required this.onValueChanged,
  }) : super(key: key);

  List<String> items = [];

  List<double>? itemWidths;

  int selectedIndex = 0;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final EdgeInsetsGeometry itemPadding;
  final EdgeInsetsGeometry itemMargin;

  final double height;
  final double itemWidth;

  final double itemRadius;

  final TextStyle itemTextStyle;
  final TextStyle itemSelectedTextStyle;

  final Color itemBgColor;
  final Color itemSelectedBgColor;

  void Function(int value) onValueChanged;

  @override
  _ListViewSegmentControlState createState() => _ListViewSegmentControlState();
}

class _ListViewSegmentControlState extends State<ListViewSegmentControl> {

  late ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.itemWidths != null) {
      assert(widget.itemWidths!.length == widget.items.length);
    }
    return buildListViewHorizontal(context);
  }

  Widget buildListViewHorizontal(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: widget.height,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.items.length,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index){
          return GestureDetector(
            onTap: (){
              ddlog(index);
              setState(() {
                widget.selectedIndex = index;
              });
              widget.onValueChanged(index);

              final screenSize = MediaQuery.of(context).size;
              if (_scrollController.position.maxScrollExtent <= 0) {
                // ddlog([_scrollController.position.maxScrollExtent, screenSize.width]);
                return;
              }
              ///选中item滚动中间
              if (widget.itemWidths != null) {
                // final offsetX = widget.itemWidths!.take(widget.selectedIndex).reduce((value, element) => value + element);
                // _scrollController.animateTo(offsetX, duration: new Duration(seconds: 1), curve: Curves.ease);
                return;
              }
              final offsetX = widget.selectedIndex*(widget.itemWidth + widget.itemPadding.horizontal) - widget.itemWidth;
              _scrollController.animateTo(offsetX, duration: new Duration(seconds: 1), curve: Curves.ease);
            },
            child: Container(
              width: widget.itemWidths != null ? widget.itemWidths![index] : widget.itemWidth,
              height: widget.height,
              margin: widget.itemMargin,
              padding: widget.itemPadding,
              alignment: Alignment.center,
              // color: ColorExt.random(),
              decoration: BoxDecoration(
                color: widget.selectedIndex == index ? widget.itemSelectedBgColor : widget.itemBgColor,
                borderRadius: BorderRadius.circular(widget.itemRadius),
              ),
              child: Text(widget.items[index],
                textAlign: TextAlign.center,
                style: widget.selectedIndex == index ? widget.itemSelectedTextStyle : widget.itemTextStyle,
              ),
            ),
          );
        }),
    );
  }
}



/// 多行折叠菜单
class FoldMenu extends StatefulWidget {

  FoldMenu({
    Key? key,
    required this.isVisible,
    required this.children,
    required this.onValueChanged,
    this.itemWidth = 100,
    this.foldCount = 0,
    this.indicator}) : super(key: key);

  late bool isVisible;

  final Widget? indicator;

  final double itemWidth;

  final int foldCount;

  List<Tuple2<List<String>, int>> children;

  void Function(int row, int index, List<int> indexs) onValueChanged;

  @override
  _FoldMenuState createState() => _FoldMenuState();
}

class _FoldMenuState extends State<FoldMenu> {

  List<int> _indexs = [];

  @override
  Widget build(BuildContext context) {
    _indexs = widget.children.map((e) => e.item2).toList();

    List<Tuple2<List<String>, int>> topChildren = widget.children.sublist(0, widget.children.length - widget.foldCount);
    List<Tuple2<List<String>, int>> foldChildren = widget.children.sublist(widget.children.length - 1 - widget.foldCount, widget.children.length - 1);

    return Container(
      // color: Colors.green,
      child: Column(
        children: [
          if (topChildren.length > 0) Column(
            children: topChildren.map((e) => buildListViewHorizontal(e: e, row: widget.children.indexOf(e))).toList(),
          ),
          Visibility(
            visible: widget.isVisible,
            child: Column(
              children: foldChildren.map((e) => buildListViewHorizontal(e: e, row: widget.children.indexOf(e))).toList(),
            ),
          ),
          widget.indicator ?? IconButton(
            icon: widget.isVisible ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              setState(() {
                widget.isVisible = !widget.isVisible;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildListViewHorizontal({
    required Tuple2<List<String>, int> e,
    required int row}) {
    return ListViewSegmentControl(
        items: e.item1,
        itemWidth: widget.itemWidth,
        selectedIndex: e.item2,
        onValueChanged: (index){
          // ddlog("${e.item2}, ${index}");
          _indexs[row] = index;
          // ddlog("${row}, ${index}, ${_indexs}");
          widget.onValueChanged(row, index, _indexs);
        });
  }

}