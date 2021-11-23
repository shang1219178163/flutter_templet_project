//
//  list_view_segment_control.dart
//  fluttertemplet
//
//  Created by shang on 10/11/21 3:08 PM.
//  Copyright © 10/11/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';

// ignore: must_be_immutable (水平菜单单选器)
class ListViewSegmentControl extends StatefulWidget {

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

  @override
  _ListViewSegmentControlState createState() => _ListViewSegmentControlState();
}

class _ListViewSegmentControlState extends State<ListViewSegmentControl> {

  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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