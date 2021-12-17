//
//  StepConnector.dart
//  flutter_templet_project
//
//  Created by shang on 12/16/21 1:43 PM.
//  Copyright © 12/16/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: unused_element
class SteperConnector extends StatelessWidget {
  /// Creates a indent.
  ///
  /// The [direction]and [child] must be null. And [space], [indent] and
  /// [endIndent] must be null or non-negative.
  const SteperConnector({
    Key? key,
    required this.direction,
    this.space = 2,
    this.indent = 0,
    this.endIndent = 0,
    required this.child,
  })   : assert(space >= 0),
        assert(indent >= 0),
        assert(endIndent >= 0),
        super(key: key);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the
  /// size specified by this value.
  final double space;

  /// The amount of empty space to the leading edge of the connector.
  final double indent;

  /// The amount of empty space to the trailing edge of the connector.
  final double endIndent;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.vertical ? space : null,
      height: direction == Axis.vertical ? null : space,
      child: Center(
        child: Padding(
          padding: direction == Axis.vertical
              ? EdgeInsetsDirectional.only(
            top: indent,
            bottom: endIndent,
          )
              : EdgeInsetsDirectional.only(
            start: indent,
            end: endIndent,
          ),
          child: child,
        ),
      ),
    );
  }
}


class SteperNode extends StatelessWidget {

  SteperNode({
    Key? key,
    this.direction = Axis.vertical,
    this.color = Colors.blue,
    this.indicatorSize = 30,
    this.indicator,
    this.indent = 0,
    this.endIndent = 0,
    this.startConnector,
    this.endConnector,
    this.drawStartConnector = true,
    this.drawEndConnector = true,
  }) : super(key: key);

  /// {@macro timelines.direction}
  Axis direction;

  Color color;
  double indicatorSize;
  Widget? indicator;
  double indent;
  double endIndent;
  Widget? startConnector;
  Widget? endConnector;
  bool? drawStartConnector;
  bool? drawEndConnector;

  @override
  Widget build(BuildContext context) {
    final indicator = this.indicator ?? Container(
      color: color,
      width: 30,
      height: 30,
    );

    var startConnector = this.direction == Axis.vertical ? this.startConnector ?? Container(
      color: color,
      width: 2,
    ) : Container(
      color: color,
      height: 2,
    );
    if (this.drawStartConnector == false) {
      startConnector = Container();
    }

    var endConnector = this.direction == Axis.vertical ? this.endConnector ?? Container(
      color: color,
      width: 2,
    ) : Container(
      color: color,
      height: 2,
    );

    if (this.drawEndConnector == false) {
      endConnector = Container();
    }

    final kFlexMultiplier = 1000;
    final indicatorFlex = 0.5;

    Widget result = indicator;
    final items = [
      if (indicatorFlex > 0)
        Flexible(
          flex: (indicatorFlex * kFlexMultiplier).toInt(),
          child: startConnector,
        ),
      indicator,
      if (indicatorFlex < 1)
        Flexible(
          flex: ((1 - indicatorFlex) * kFlexMultiplier).toInt(),
          child: endConnector,
        ),
    ];

    switch (direction) {
      case Axis.vertical:
        result = Column(
          mainAxisSize: MainAxisSize.min,
          children: items,
        );
        break;
      case Axis.horizontal:
        result = Row(
          mainAxisSize: MainAxisSize.min,
          children: items,
        );
        break;
    }
    return result;
  }
}




class NNTimelineTile extends StatelessWidget {
  const NNTimelineTile({
    Key? key,
    this.direction,
    required this.node,
    this.contents,
    this.oppositeContents,
    this.mainAxisExtent = 0,
    this.crossAxisExtent,
  })  : super(key: key);

  final Axis? direction;

  /// A widget that displays indicator and two connectors.
  final Widget node;

  /// The contents to display inside the timeline tile.
  final Widget? contents;

  /// The contents to display on the opposite side of the [contents].
  final Widget? oppositeContents;

  /// widget([IntrinsicHeight]/[IntrinsicWidth]) when building.
  final double? mainAxisExtent;

  final double? crossAxisExtent;

  @override
  Widget build(BuildContext context) {
    const kFlexMultiplier = 1000.0;
    final nodeFlex = 0.5 * kFlexMultiplier;
    var minNodeExtent = 0.0;

    var items = [
      if (nodeFlex > 0)
        Expanded(
          flex: nodeFlex.toInt(),
          child: Align(
            alignment: direction == Axis.vertical
                ? AlignmentDirectional.centerEnd
                : Alignment.bottomCenter,
            child: oppositeContents ?? SizedBox.shrink(),
          ),
        ),
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: direction == Axis.vertical ? minNodeExtent : 0.0,
          minHeight: direction == Axis.vertical ? 0.0 : minNodeExtent,
        ),
        child: node,
      ),
      if (nodeFlex < kFlexMultiplier)
        Expanded(
          flex: (kFlexMultiplier - nodeFlex).toInt(),
          child: Align(
            alignment: direction == Axis.vertical
                ? AlignmentDirectional.centerStart
                : Alignment.topCenter,
            child: contents ?? SizedBox.shrink(),
          ),
        ),
    ];

    var result;
    switch (direction) {
      case Axis.vertical:
        result = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );

        if (mainAxisExtent != null) {
          result = SizedBox(
            width: crossAxisExtent,
            height: mainAxisExtent,
            child: result,
          );
        } else {
          result = IntrinsicHeight(
            child: result,
          );

          if (crossAxisExtent != null) {
            result = SizedBox(
              width: crossAxisExtent,
              child: result,
            );
          }
        }
        break;
      case Axis.horizontal:
        result = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );
        if (mainAxisExtent != null) {
          result = SizedBox(
            width: mainAxisExtent,
            height: crossAxisExtent,
            child: result,
          );
        } else {
          result = IntrinsicWidth(
            child: result,
          );

          if (crossAxisExtent != null) {
            result = SizedBox(
              height: crossAxisExtent,
              child: result,
            );
          }
        }
        break;
      default:
        throw ArgumentError.value(direction, '$direction is invalid.');
    }

    result = Align(
      child: result,
    );

    return result;
  }
}
