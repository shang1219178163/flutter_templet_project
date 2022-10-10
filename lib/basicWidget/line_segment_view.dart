//
//  LineSegmentWidget.dart
//  flutter_templet_project
//
//  Created by shang on 6/14/21 8:47 AM.
//  Copyright © 6/14/21 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';


enum LineSegmentStyle {
  top,
  bottom,
}

///线条指示器分段组件
class LineSegmentView<T> extends StatefulWidget {
  
  final Map<T, Widget> children;
  
  T? groupValue;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final LineSegmentStyle style;

  final Color? backgroundColor;
  final Color lineColor;
  final double? lineWidth;
  final double lineHeight;

  final double height;

  final Radius radius;

  void Function(T value) onValueChanged;

  LineSegmentView({
    Key? key,
    required this.children,
    required this.groupValue,
    this.style = LineSegmentStyle.bottom,
    this.backgroundColor = CupertinoColors.tertiarySystemFill,
    this.lineColor = Colors.blue,
    this.lineWidth,
    this.lineHeight = 2,
    this.height = 36,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15),
    this.radius = const Radius.circular(4),
    required this.onValueChanged,

  }) : super(key: key);


  @override
  _LineSegmentViewState createState() => _LineSegmentViewState();
}

class _LineSegmentViewState extends State<LineSegmentView> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double contentWidth = screenWidth - widget.margin.horizontal - widget.padding.horizontal;
    double itemWidth = contentWidth / widget.children.values.length;

    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.all(widget.radius),
      ),
      child: Stack(
        children: [
          Row(
            children: widget.children.values.map((e) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: widget.height,
                  width: itemWidth,
                  child: TextButton(
                    child: e,
                    onPressed: (){
                      // ddlog(e);
                      setState(() {
                        widget.groupValue = widget.children.values.toList().indexOf(e);
                      });
                      widget.onValueChanged(widget.groupValue);
                    },
                  ),
                ),
              ],
            ),
            ).toList(),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            top: widget.style == LineSegmentStyle.top ? 0 : widget.height - widget.lineHeight,
            left: widget.lineWidth != null ? widget.groupValue*itemWidth + (itemWidth - widget.lineWidth!)*0.5 : widget.groupValue*itemWidth,
            child: Container(
              height: widget.lineHeight,
              width: widget.lineWidth ?? itemWidth,
              color: widget.lineColor,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(4),
              //   color: widget.lineColor,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
