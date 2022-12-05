/// 轮播样式2
/// http://101.200.241.211/repos/app_project/uplus/dev_doc/05-UI/%E4%B8%89%E7%BF%BC%E9%B8%9F/V3.2.3/%E9%A6%96%E9%A1%B5%E6%9C%80%E6%96%B0%E6%A0%87%E6%B3%A8-%E6%96%B0%E5%A2%9E%E8%A7%86%E9%A2%91%E6%A8%A1%E5%9D%97/%E9%A6%96%E9%A1%B5%E6%9C%80%E6%96%B0%E6%A0%87%E6%B3%A8/index.html#s4

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/vendor/flutter_swiper_demo.dart';
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
  final Radius radius;
  final bool isSwiper;

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
    this.radius = const Radius.circular(8),
     this.isSwiper = false,
  }) : super(key: key);

  double getItemWidth() {
    double w = this.width - this.padding.left - this.padding.right;
    if (this.showCount == 2.5) {
      w = (w - 2 * this.gap - this.startLeft)/2.7;
    } else if ([1, 2, 3].contains(this.showCount)) {
      w = (w - this.startLeft - this.endRight - (this.showCount - 1) * this.gap - 16)/this.showCount;
      if (this.showCount == 1 && this.isSwiper) {
        w = this.width - this.padding.left - this.padding.right - 12;
      }
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    if (isSwiper) {
      return _buildBodySwiper();
    }
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
        children: this.items.map((e) => _buildChildrenItem(e: e, isVideo: false)).toList(),
      )
    );
  }


  Widget _buildChildrenItem({
    required Tuple3<String, String, String> e,
    bool isVideo = false,
  }) {
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
          isVideo: isVideo,
          itemWidth: itemWidth,
          text: text,
          padding: EdgeInsets.only(left: 6, bottom: 4),
          bg: ClipRRect(
            borderRadius: BorderRadius.all(this.radius),
            child: this.bgBuilder != null ? this.bgBuilder!(itemWidth, index) : FadeInImage.assetNetwork(
              placeholder: 'images/img_placeholder.png',
              image: url,
              fit: BoxFit.cover,
              width: itemWidth,
              height: double.infinity
            ),
          ),
        ),
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
    double? itemWidth,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: padding,
        width: itemWidth,
        // constraints: BoxConstraints(maxWidth: itemWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: this.radius, bottomRight: this.radius),
          gradient: _buildLinearGradient(isVertical: true),
        ),
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
    double? itemWidth,
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
              itemWidth: itemWidth,
            ),
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

  _buildLinearGradient({
    bool isVertical = false,
    List<Color> colors = const [Color(0x19000000), Color(0x7f000000), ],
  }) {
    Alignment begin = isVertical ? Alignment.topCenter : Alignment.centerLeft;
    Alignment end = isVertical ? Alignment.bottomCenter : Alignment.centerRight;
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }


  _buildBodySwiper() {
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
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          // final e = this.items[index];
          // final url = e.item1;
          // final text = e.item2;

          return _buildChildrenItem(e: this.items[index], isVideo: false);
        },
        indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        itemCount: this.items.length,
        pagination: SwiperPagination(),
        // control: SwiperControl(),
        // itemWidth: screenSize.width * 0.5,
        // viewportFraction: 0.6,
      ),
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
