import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SynHomeSwiperWidget extends StatelessWidget {

  final String? title;
   double width;
   double height;
  final EdgeInsets padding;
  final EdgeInsets margin;

  final ImageProvider? bg;
  final IndexedWidgetBuilder? itemBuilder;

  final double showCount;
  final double startLeft;
  final double endRight;
  final double gap;

   SynHomeSwiperWidget({
  	Key? key,
  	this.title,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.bg,
    this.itemBuilder,
    this.showCount = 2.5,
    this.startLeft = 12,
    this.endRight = 12,
    this.gap = 8,
  }) : super(key: key);

  double getItemWidth() {
    double w = this.width - this.padding.left - this.padding.right;
    if (this.showCount == 2.5) {
      w = (w - 2 * this.gap - this.startLeft)/2.8;
    } else if ([1, 2, 3].contains(this.showCount)) {
      w = (w - this.startLeft - this.endRight - (this.showCount - 1) * this.gap )/this.showCount;
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.green,
        // border: Border.all(width: 3, color: Colors.red),
        // borderRadius:const BorderRadius.all(Radius.circular(6)),
        image: bg == null ? null : DecorationImage(
            image: bg!,
            fit: BoxFit.fill
        ), //设置图片
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _buildChildren(),
      )
    );
  }

  _buildChildren() {
    final items = [
      Tuple3(
        150.0,
        'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
        '海尔｜无边界厨房',
      ),
      Tuple3(
        150.0,
        'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
        '海尔｜无边界客厅',
      ),
      Tuple3(
        150.0,
        'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
        '海尔｜无边界卧室',
      ),
      Tuple3(
        150.0,
        'https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg',
        '海尔｜无边界其他',
      ),
    ];

    return items.map((e) {
      double width = getItemWidth();
      // double width = 150;

      final url = e.item2;
      final text = e.item3;

      int index = items.indexOf(e);
      var padding = EdgeInsets.zero;

      if (this.showCount == 2.5) {
        if (index == 0) {
          padding = EdgeInsets.only(left: this.startLeft, right: this.gap);
        } else if (index == items.length - 1) {
          padding = EdgeInsets.only(left: 0, right: this.endRight);
        } else {
          padding = EdgeInsets.only(left: 0, right: this.gap);
        }
      } else {
        var itemLeft = 0.0;
        var itemRight = this.gap;
        if (index == 0) {
          itemLeft = this.startLeft;
        }
        if (index == items.length - 1) {
          itemRight = 0;
        }
        padding = EdgeInsets.only(left: itemLeft, right: itemRight);
      }

      return Padding(
        padding: padding,
        child: _buildItem1(
          text: text,
          padding: EdgeInsets.only(left: 6, bottom: 4),
          bgBuilder: () {
            return FadeInImage.assetNetwork(
              placeholder: 'images/img_placeholder.png',
              image: url,
              fit: BoxFit.cover,
              width: width,
              // height: double.infinity
            );
          },
        ),
      );
    }).toList();
  }


  _buildText({
    text = '-',
    maxLines = 1,
    style = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'PingFangSC-Regular,PingFang SC',
      color: Color(0xFFFFFFFF),
    ),
    padding = const EdgeInsets.all(0),
    alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
          style: style,
        ),
      ),
    );
  }


  _buildItem1({
    text = '',
    padding = const EdgeInsets.all(0),
    isVideo = true,
    required Widget Function() bgBuilder,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            bgBuilder(),
            _buildText(
              alignment: Alignment.bottomLeft,
              padding: padding,
              text: text,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular,PingFang SC',
                color: Color(0xFFFFFFFF),
              ),
            )
          ],
        ),
        if (isVideo) SizedBox(
          width: 24,
          height: 24,
          child: Image.asset('images/icon_play.png',),
        ),
      ],
    );
  }

}


class _SynHomeSwiperTitleWidget extends StatelessWidget {

  const _SynHomeSwiperTitleWidget({
  	Key? key,
  	this.title,
    this.text,
    this.maxLines,
    this.style,
    this.padding,
    this.alignment,
  }) : super(key: key);

  final String? text;
  final int? maxLines;
  final TextStyle? style;
  final String? title;
  final EdgeInsets? padding;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return _buildText(
      text: this.text,
      maxLines: this.text,
      style: this.style ?? const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'PingFangSC-Regular,PingFang SC',
        color: Color(0xFFFFFFFF),
      ),
      padding: this.padding ?? const EdgeInsets.all(0),
      alignment: this.alignment ?? Alignment.centerLeft,
    );
  }

  _buildText({
    text = '-',
    maxLines = 1,
    style = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'PingFangSC-Regular,PingFang SC',
      color: Color(0xFFFFFFFF),
    ),
    padding = const EdgeInsets.all(0),
    alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
          style: style,
        ),
      ),
    );
  }
}

class _SynHomeSwiperItemWidget extends StatelessWidget {

  const _SynHomeSwiperItemWidget({
    Key? key,
    this.text,
    this.isVideo = true,
    this.padding,
    required this.bgBuilder,
  }) : super(key: key);

  final String? text;
  final bool isVideo;
  final EdgeInsets? padding;
  final Widget Function() bgBuilder;

  @override
  Widget build(BuildContext context) {
    return _buildItem(
      text: this.text,
      padding: this.text,
      isVideo: this.isVideo,
      bgBuilder: this.bgBuilder,
    );
  }

  _buildItem({
    text = '',
    padding = const EdgeInsets.all(0),
    isVideo = true,
    required Widget Function() bgBuilder,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            bgBuilder(),
            _SynHomeSwiperTitleWidget(
              alignment: Alignment.bottomLeft,
              padding: padding,
              text: text,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular,PingFang SC',
                color: Color(0xFFFFFFFF),
              ),
            )
          ],
        ),
        if (isVideo) SizedBox(
          width: 24,
          height: 24,
          child: Image.asset('images/icon_play.png',),
        ),
      ],
    );
  }

}