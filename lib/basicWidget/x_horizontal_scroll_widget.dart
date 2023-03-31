/// 轮播样式2
/// http://101.200.241.211/repos/app_project/uplus/dev_doc/05-UI/%E4%B8%89%E7%BF%BC%E9%B8%9F/V3.2.3/%E9%A6%96%E9%A1%B5%E6%9C%80%E6%96%B0%E6%A0%87%E6%B3%A8-%E6%96%B0%E5%A2%9E%E8%A7%86%E9%A2%91%E6%A8%A1%E5%9D%97/%E9%A6%96%E9%A1%B5%E6%9C%80%E6%96%B0%E6%A0%87%E6%B3%A8/index.html#s4

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tuple/tuple.dart';

typedef XHomeSwiperBGWidgetBuilder = Widget Function(double itemWidth, int index);
typedef XHomeSwiperItemWidgetBuilder = Widget Function(int index);


class XHorizontalScrollWidget extends StatelessWidget {

  final String? title;
  final List<Tuple4<String, String, String, bool>> items;

  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;

  final ImageProvider? bg;
  final XHomeSwiperItemWidgetBuilder? itemBuilder;
  final XHomeSwiperBGWidgetBuilder? bgBuilder;

  final double showCount;
  final double startLeft;
  final double endRight;
  final double gap;
  final Radius radius;
  final bool isSwiper;
  List<BoxShadow>? boxShadow;

  final void Function(Tuple4<String, String, String, bool> e) onTap;

   XHorizontalScrollWidget({
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
    this.boxShadow,
    this.isSwiper = false,
    required this.onTap,
  }) : super(key: key);

  double getItemWidth() {
    var w = width - padding.left - padding.right;
    if (showCount == 2.5) {
      w = (w - 2 * gap - startLeft)/2.7;
    } else if ([1, 2, 3].contains(showCount)) {
      w = (w - startLeft - endRight - (showCount - 1) * gap - 16)/showCount;
      if (showCount == 1 && isSwiper) {
        w = width - padding.left - padding.right - 12;
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
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        // color: Colors.green,
        // border: Border.all(width: 3, color: Colors.red),
        // borderRadius:const BorderRadius.all(Radius.circular(8)),
        image: bg == null ? null : DecorationImage(
          image: bg!,
          fit: BoxFit.fill
        ),
        boxShadow: boxShadow,
      //  boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items.map((e) => _buildChildrenItem(e: e)).toList(),
      )
    );
  }


  Widget _buildChildrenItem({
    required Tuple4<String, String, String, bool> e,
  }) {
      var itemWidth = getItemWidth();
      // double width = 150;
      final url = e.item1;
      final text = e.item2;
      final isVideo = e.item4;

      var index = items.indexOf(e);
      var padding = EdgeInsets.zero;

      if (showCount == 2.5) {
        if (index == 0) {
          padding = EdgeInsets.only(left: startLeft, right: gap);
        } else if (index == items.length - 1) {
          padding = EdgeInsets.only(left: 0, right: endRight);
        } else {
          padding = EdgeInsets.only(left: 0, right: gap);
        }
      }
      else {
        var itemLeft = 0.0;
        var itemRight = gap;
        if (index == 0) {
          itemLeft = startLeft;
        }
        if (index == items.length - 1) {
          itemRight = 0;
        }
        padding = EdgeInsets.only(left: itemLeft, right: itemRight);
        if (showCount == 1) {
          padding = EdgeInsets.only(left: 0, right: 0);
        }
      }

      return InkWell(
        onTap: (){ onTap(e); },
        child: Padding(
          padding: padding,
          child: itemBuilder != null ? itemBuilder!(index) : _buildItem(
            isVideo: isVideo,
            itemWidth: itemWidth,
            text: text,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4,),
            bg: ClipRRect(
              borderRadius: BorderRadius.all(radius),
              child: bgBuilder != null ? bgBuilder!(itemWidth, index) : FadeInImage.assetNetwork(
                placeholder: 'images/img_placeholder.png',
                image: url,
                fit: BoxFit.cover,
                width: itemWidth,
                height: double.infinity
              ),
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
          borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
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
        bg,
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
    var begin = isVertical ? Alignment.topCenter : Alignment.centerLeft;
    var end = isVertical ? Alignment.bottomCenter : Alignment.centerRight;
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }


  _buildBodySwiper() {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.green,
        // border: Border.all(width: 3, color: Colors.red),
        // borderRadius:const BorderRadius.all(Radius.circular(8)),
        image: bg == null ? null : DecorationImage(
          image: bg!,
          fit: BoxFit.fill
        ), //设置图片
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(radius),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            final e = items[index];
            return _buildChildrenItem(e: e,);
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplay: true,
          loop: false,
          itemCount: items.length,
          // pagination: SwiperPagination(),
          // control: SwiperControl(),
          // itemWidth: screenSize.width * 0.5,
          // viewportFraction: 0.6,
        ),
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
      text: text,
      maxLines: text,
      style: style ?? const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'PingFangSC-Regular,PingFang SC',
        color: Color(0xFFFFFFFF),
      ),
      padding: padding ?? const EdgeInsets.all(0),
      alignment: alignment ?? Alignment.centerLeft,
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

Map<String, double> itemMap = {
  '1': 327,
  '2': 160,
  '2.5': 125,
  '3': 104,
};

class HorizontalScrollWidget extends StatelessWidget {

  HorizontalScrollWidget({
  	Key? key,
  	this.title,
    this.width = double.infinity,
    this.height = 187,
    this.showCount = 3,
    this.isSwiper = false,
    this.gap = 8,
    this.radius = const Radius.circular(8),
    required this.items,
    this.isVideo = true,
  }) : super(key: key);


  String? title;
  List<Tuple4<String, String, String, bool>> items;

  double width;
  double height;

  double gap;

  bool isSwiper;
  double showCount;

  Radius radius;

  bool isVideo;
  /// 获取 item 宽
  // double get itemWidth => itemMap['${this.showCount}'] ?? 225;
  double get itemWidth{
    if (showCount == 1) {
      return 327;
    }
    if (showCount == 2) {
      return 160;
    }
    if (showCount == 2.5) {
      return 125;
    }
    if (showCount == 3) {
      return 104;
    }
    return 125;
  }

  @override
  Widget build(BuildContext context) {
    if (isSwiper) {
      return _buildSwiper();
    }
    return _buildListView();
  }

  _buildListView({
    bool addToSliverBox = false,
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
  }) {
    // final items = List.generate(3, (index) => "${index}");

    final child = Container(
      width: width,
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        // cacheExtent: 10,
        itemBuilder: itemBuilder ?? (context, index) => _buildItem(context, index),
        separatorBuilder: (context, index) => _buildSeparator(context, index),
      ),
    );


    if (addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }

  _buildItem(context, index) {
    final e = items[index];

    return InkWell(
      onTap: () => debugPrint(e.toString()),
      child: Container(
        // color: Colors.green,
        width: itemWidth,
        padding: EdgeInsets.only(bottom: 5),//为了显示阴影
        decoration: _buildDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.all(radius),
          child: e.item1.startsWith('http') ? Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              FadeInImage(
                placeholder: AssetImage('images/img_placeholder.png'),
                image: NetworkImage(e.item1),
                fit: BoxFit.fill,
                height: double.infinity,
              ),
              if (isVideo) SizedBox(
                width: 24,
                height: 24,
                child: Image.asset('images/icon_play.png'),
              ),
            ],
          ) : Center(child: Text('Index:${e.item1}')),
        ),
      ),
    );
  }

  _buildSwiper() {
    return Container(
      width: width,
      height: height,
      // decoration: BoxDecoration(
      //   color: Colors.green,
      //   // border: Border.all(width: 3, color: Colors.red),
      //   // borderRadius:const BorderRadius.all(Radius.circular(8)),
      //   image: this.bg == null ? null : DecorationImage(
      //       image: this.bg!,
      //       fit: BoxFit.fill
      //   ), //设置图片
      // ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(radius),
        child: Swiper(
          itemBuilder: (context, index) => _buildItem(context, index),
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplay: items.length > 1,
          loop: items.length > 1,
          itemCount: items.length,
          pagination: items.length <= 1 ? null : SwiperPagination(),
          // control: SwiperControl(),
          itemWidth: itemWidth,
          // viewportFraction: 0.6,
        ),
      ),
    );
  }

  //分割区间
  _buildSeparator(context, index) {
    // return Container(
    //   width: gap,
    //   color: Colors.blue,
    // );
    return Divider(
      // height: 8,
      indent: gap,
      // color: Colors.blue,
    );
  }
  
  _buildDecoration() {
    return BoxDecoration(
      // color: Colors.green,
      // border: Border.all(width: 3, color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(0.5),
          // spreadRadius: 5,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }
}
