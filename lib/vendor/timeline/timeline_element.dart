// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/timeline/common/colors.dart';
import 'package:flutter_templet_project/vendor/timeline/common/font_const.dart';
import 'package:flutter_templet_project/vendor/timeline/timeline_painter.dart';
import 'package:flutter_templet_project/vendor/timeline/triangle_painter.dart';

///构建timeline 组件Widget
class TimelineElement extends StatelessWidget {
  TimelineElement(
      {Key? key,
      required this.lineColor,
      required this.backgroundColor,
      required this.model,
      required this.controller,
      this.firstElement = true,
      this.lastElement = false,
      this.titleStyle,
      this.subtitleStyle,
      this.descriptionStyle,
      this.leftContent = true,
      this.height = 80.0})
      : super(key: key);

  final Color lineColor;
  final Color backgroundColor;
  final Map<String, dynamic> model;
  final bool firstElement;
  final bool lastElement;
  final Animation<double> controller;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;
  final bool? leftContent;
  final double? height;

  ///构建时间线Widget
  Widget _buildLine(BuildContext context, Widget? child) {
    return Container(
      width: 30.0,
      // color: Colors.red,
      child: CustomPaint(
        painter: TimelinePainter(
            lineColor: lineColor,
            backgroundColor: backgroundColor,
            firstElement: firstElement,
            lastElement: lastElement,
            controller: controller),
      ),
    );
  }

  Widget bubble() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
          margin: EdgeInsets.only(top: 5),
          alignment: Alignment.topLeft,
          color: WBColors.color_F4F7FF,
          child: Text(
            model['remark'],
            style: TextStyle(
                fontFamily: FontConst.pingFangSC_Regular,
                fontSize: 12,
                color: WBColors.color_666666,
                fontWeight: FontWeight.w400),
            maxLines: 2,
          ),
        ),

        ///气泡小三角
        Positioned(
            top: -4.0,
            left: 0,
            child: Container(
              width: 8,
              height: 7.5,
              child: CustomPaint(
                painter:
                    TrianglePainter(color: WBColors.color_F4F7FF, path: Path()),
              ),
            ))
      ],
    );
  }

  ///构建时间线右侧Widget
  Widget _buildContentRightColumn(BuildContext context) {
    return Container(
        // color: Colors.green,
        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///顶部标题和副标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model['title'].length > 47
                      ? model['title'].substring(0, 47) + "..."
                      : model['title'],
                  style: titleStyle ??
                      TextStyle(
                          fontFamily: FontConst.pingFangSC_Medium,
                          color: WBColors.color_333333,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                ),
                model['subtitle'] != null
                    ? Text(
                        model['subtitle'],
                        style: subtitleStyle ??
                            TextStyle(
                                fontFamily: FontConst.pingFangSC_Regular,
                                color: WBColors.color_999999,
                                fontSize: 12),
                        maxLines: 2,
                      )
                    : Text('')
              ],
            ),

            ///时间轴timeline详情描述
            Expanded(
                child: model['remark'] != null
                    ? bubble()
                    : Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          model['description'] != null
                              ? model['description'].length > 50
                                  ? model['description'].substring(0, 47) +
                                      '...'
                                  : model['description']
                              : "", // To prevent overflowing of text to the next element, the text is truncated if greater than 75 characters
                          style: descriptionStyle ??
                              TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontConst.pingFangSC_Regular,
                                  color: WBColors.color_666666),
                          maxLines: 2,
                        ),
                      ))
          ],
        ));
  }

  ///构建时间线左侧Widget
  Widget _buildContentLeftColumn(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              model['day'],
              style: TextStyle(
                  color: WBColors.color_666666,
                  fontSize: 13,
                  fontFamily: FontConst.pingFangSC_Regular),
              maxLines: 2,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              model['time'],
              style: TextStyle(
                  color: WBColors.color_AAAAAA,
                  fontSize: 12,
                  fontFamily: FontConst.pingFangSC_Regular),
              maxLines: 2,
            )
          ],
        ));
  }

  Widget _buildRow(BuildContext context) {
    return Stack(
      // alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          height: calculatedHeight(),
          color: backgroundColor,
          // alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (leftContent != null)
                _buildContentLeftColumn(context)
              else
                Text(''),
              AnimatedBuilder(
                builder: (context, child) => _buildLine(context, child),
                animation: controller,
              ),
              Expanded(child: _buildContentRightColumn(context)),
            ],
          ),
        ),

        // Positioned(
        //   child: Image(
        //     //判断是否是第一个节点展示相应的节点图片
        //     image: AssetImage(firstElement?'assets/images/paint_last.png':'assets/images/paint.png'),
        //     width: 7,
        //     height: firstElement ? 11.5 : 7, //第一个节点高亮节点 图片大小不一致
        //   ),
        //   left: leftContent ? 47.5 : 11.5, //不展示左侧时间线的 调整图片节点定位位置
        //   top: 4,
        //   // bottom: firstElement ? height != null ? (height / 2) : 40.0 :  height != null ? (height / 2) + 4.5 : 44.5,
        // ),
      ],
    );
  }

  ///计算时间轴高度
  calculatedHeight() {
    double calHeight;
    if ((model['description'] == '' || model['description'] == null) &&
        (model['remark'] == null || model['remark'] == '')) {
      ///描述和备注都为空 调整容器高度为40
      calHeight = 44.0;
    } else if (model['description'] != null &&
        model['description'].length < 19 &&
        (model['remark'] == null || model['remark'] == '')) {
      ///备注为空 描述字符少于一行 调整高度为60.0
      calHeight = 60.0;
    } else if (model['remark'] != null) {
      ///计算备注气泡区域
      int len = model['remark'].length;
      if (len < 19) {
        calHeight = 60.0;
      } else if (len > 19 && len < 38) {
        calHeight = 78.0;
      } else {
        calHeight = 90.0;
      }
    } else if (height != null) {
      calHeight = height!;
    } else {
      calHeight = 80.0;
    }
    return calHeight;
  }

  @override
  Widget build(BuildContext context) {
    return _buildRow(context);
  }
}
