//
//  LineSegmentWidget.dart
//  flutter_templet_project
//
//  Created by shang on 6/14/21 8:47 AM.
//  Copyright © 6/14/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NLineSegmentStyle {
  top,
  bottom,
}

///线条指示器分段组件
class NLineSegmentView<T> extends StatefulWidget {

  NLineSegmentView({
    Key? key,
    required this.children,
    required this.groupValue,
    this.style = NLineSegmentStyle.bottom,
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
  final Map<T, Widget> children;

  final T? groupValue;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final NLineSegmentStyle style;

  final Color? backgroundColor;
  final Color lineColor;
  final double? lineWidth;
  final double lineHeight;

  final double height;

  final Radius radius;

  final void Function(T value) onValueChanged;

  @override
  _NLineSegmentViewState<T> createState() => _NLineSegmentViewState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<T, Widget>>('children', children));
    properties.add(DiagnosticsProperty<T?>('groupValue', groupValue));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
    properties.add(EnumProperty<NLineSegmentStyle>('style', style));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('lineColor', lineColor));
    properties.add(DoubleProperty('lineWidth', lineWidth));
    properties.add(DoubleProperty('lineHeight', lineHeight));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<Radius>('radius', radius));
    properties.add(ObjectFlagProperty<void Function(T value)>.has('onValueChanged', onValueChanged));
  }
}

class _NLineSegmentViewState<T> extends State<NLineSegmentView<T>> {
  late T? groupValue = widget.groupValue;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    var contentWidth = screenWidth - widget.margin.horizontal - widget.padding.horizontal;
    var itemWidth = contentWidth / widget.children.values.length;

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
            children: widget.children.values
                .map(
                  (e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: widget.height,
                        width: itemWidth,
                        child: TextButton(
                          onPressed: () {
                            // DLog.d(e);
                            setState(() {
                              groupValue = widget.children.values.toList().indexOf(e) as T;
                            });
                            widget.onValueChanged(groupValue as T);
                          },
                          child: e,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            top: widget.style == NLineSegmentStyle.top ? 0 : widget.height - widget.lineHeight,
            left: widget.lineWidth != null
                ? (groupValue as num? ?? 0) * itemWidth + (itemWidth - widget.lineWidth!) * 0.5
                : (groupValue as num? ?? 0) * itemWidth,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T?>('groupValue', groupValue));
  }
}
