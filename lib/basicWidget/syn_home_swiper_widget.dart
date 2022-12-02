
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

typedef SynHomeSwiperBGWidgetBuilder = Widget Function(double itemWidth, int index);
typedef SynHomeSwiperItemWidgetBuilder = Widget Function(int index);

class SynHomeSwiperWidget extends StatelessWidget {

  final String? title;
  final List<Tuple3<String, String, String>> items;

  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;

  final ImageProvider? bg;
  final SynHomeSwiperItemWidgetBuilder? itemBuilder;
  final SynHomeSwiperBGWidgetBuilder? bgBuilder;

  final double showCount;
  final double startLeft;
  final double endRight;
  final double gap;

   SynHomeSwiperWidget({
  	Key? key,
  	this.title,
    required this.width,
    this.height = double.infinity,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.bg,
    this.bgBuilder,
    this.itemBuilder,
    this.showCount = 2.5,
    this.startLeft = 12,
    this.endRight = 12,
    this.gap = 8,
     this.items = const [],
  }) : super(key: key);

  double getItemWidth() {
    double w = this.width - this.padding.left - this.padding.right;
    if (this.showCount == 2.5) {
      w = (w - 2 * this.gap - this.startLeft)/2.7;
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
      width: this.width,
      height: this.height,
      padding: this.padding,
      margin: this.margin,
      decoration: BoxDecoration(
        color: Colors.green,
        // border: Border.all(width: 3, color: Colors.red),
        // borderRadius:const BorderRadius.all(Radius.circular(6)),
        image: this.bg == null ? null : DecorationImage(
            image: this.bg!,
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

    return this.items.map((e) {
      double itemWidth = getItemWidth();
      // double width = 150;

      final url = e.item1;
      final text = e.item2;

      int index = this.items.indexOf(e);
      var padding = EdgeInsets.zero;

      if (this.showCount == 2.5) {
        if (index == 0) {
          padding = EdgeInsets.only(left: this.startLeft, right: this.gap);
        } else if (index == items.length - 1) {
          padding = EdgeInsets.only(left: 0, right: this.endRight);
        } else {
          padding = EdgeInsets.only(left: 0, right: this.gap);
        }
      }
      else {
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
        child: this.itemBuilder != null ? this.itemBuilder!(index) : _buildItem(
          text: text,
          padding: EdgeInsets.only(left: 6, bottom: 4),
          bg: this.bgBuilder != null ? this.bgBuilder!(itemWidth, index) : FadeInImage.assetNetwork(
              placeholder: 'images/img_placeholder.png',
              image: url,
              fit: BoxFit.cover,
              width: itemWidth,
              height: double.infinity
            ),
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


  _buildItem({
    text = '',
    padding = const EdgeInsets.all(0),
    isVideo = true,
    required Widget bg,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            bg,
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
