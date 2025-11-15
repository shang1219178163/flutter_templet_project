import 'package:flutter/material.dart';

import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/basicWidget/page_indicator_widget.dart';
import 'package:flutter_templet_project/extension/src/edge_insets_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
// import 'package:tuple/tuple.dart';

// typedef HomeSwiperBGWidgetBuilder = Widget Function(double itemWidth, int index);
// typedef HomeSwiperItemWidgetBuilder = Widget Function(int index);

/// 轮播样式2(3.2.4)
// ignore: must_be_immutable
class NHorizontalScrollWidget extends StatefulWidget {
  NHorizontalScrollWidget({
    Key? key,
    this.title,
    required this.items,
    this.width = double.infinity,
    this.height = double.infinity,
    this.gap = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.isSwiper = false,
    this.showCount = 2.5,
  }) : super(key: key);

  String? title;

  List<AttrCarouseItem> items = [];

  double width;
  double height;

  double showCount;

  double gap;

  // final Radius radius;
  BorderRadius? borderRadius;

  /// 阴影
  List<BoxShadow>? boxShadows;

  bool isSwiper;

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<NHorizontalScrollWidget> {
  final List<AttrCarouseItem> _items = [];

  /// 根据 maxWidth 计算 item 宽度
  double getItemWidth(double maxWidth) {
    var result = (maxWidth - widget.gap * (widget.showCount.ceil() - 1)) / widget.showCount;
    return result;
  }

  /// 是否显示滚动条
  bool get showScrollbar {
    final result = (widget.showCount != _items.length);
    return result;
  }

  final _scrollController = ScrollController();

  ///标准轮播页码监听
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  ///滚动条监听
  ValueNotifier<double> scrollerOffset = ValueNotifier(0.0);

  ///滚动中监听
  ValueNotifier<bool> isScrolling = ValueNotifier(false);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      var position = _scrollController.position;
      //滚动进度
      var progress = position.pixels / position.maxScrollExtent;
      scrollerOffset.value = progress;
      // print("scrollerOffset.value:${scrollerOffset.value}_${progress}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSwiper) {
      return _buildSwiper();
    }
    return _buildListView();
  }

  _buildListView() {
    final child = LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification n) {
                  if (n is! UserScrollNotification) {
                    isScrolling.value = n is! ScrollEndNotification;
                  }
                  return false; //为 true，则事件会阻止向上冒泡，不推荐(除非有必要)
                },
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0),
                  itemCount: _items.length,
                  // cacheExtent: 10,
                  itemBuilder: (context, index) => _buildItem(context, index, constraints.maxWidth),
                  separatorBuilder: (context, index) => _buildSeparator(context, index),
                ),
              ),
            ),
            // if (showScrollbar)
            // Positioned(
            //   bottom: 0,
            //   child: ValueListenableBuilder(
            //     valueListenable: isScrolling,
            //     builder: (context, bool value, child) {
            //       // print('isScrolling:${isScrolling.value} value: ${value.toString()}');
            //       return Offstage(
            //         offstage: !value,
            //         child: _scrollerBar(
            //           maxWidth: constraints.maxWidth,
            //           itemWidth: itemWidth,
            //         ),
            //       );
            //     }
            //   ),
            // ),
          ],
        );
      },
    );
    return child;
  }

  ///创建子项
  Widget _buildItem(BuildContext context, int index, double maxWidth) {
    var model = _items[index];
    var blur = 0.0;

    var margin = EdgeInsets.zero;
    var boxShadows = widget.boxShadows;
    if (boxShadows != null && boxShadows.isNotEmpty) {
      var shadow = boxShadows[0];

      /// 留出阴影空间
      margin = margin.mergeShadow(shadow: shadow);

      blur = shadow.blurRadius;
    }

    final itemWidth = getItemWidth(maxWidth);

    return InkWell(
      onTap: () => _onClick(model, index),
      child: Container(
        // color: Colors.green,
        width: itemWidth,
        padding: EdgeInsets.only(bottom: blur), //为了显示阴影
        decoration: _buildDecoration(),
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Container(
                margin: margin,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.red),
                  boxShadow: boxShadows,
                ),
                child: FadeInImage(
                  placeholder: 'img_placeholder.png'.toAssetImage(),
                  image: NetworkImage(model.icon ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
              if ([3, 4].contains(model.contentType))
                Positioned(
                  top: 1,
                  bottom: 1,
                  child: Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      'icon_play.png'.toPath(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  _buildSwiper() {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = getItemWidth(constraints.maxWidth);

      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: Stack(
              children: [
                Swiper(
                    itemBuilder: (context, index) => _buildItem(context, index, constraints.maxWidth),
                    // indicatorLayout: PageIndicatorLayout.COLOR,
                    autoplay: _items.length > 1,
                    loop: _items.length > 1,
                    itemCount: _items.length,
                    // pagination: items.length <= 1 ? null : SwiperPagination(),
                    // control: SwiperControl(),
                    itemWidth: itemWidth,
                    // viewportFraction: 0.6,
                    onIndexChanged: (index) {
                      currentIndex.value = index;
                    }),
                if (_items.length > 1)
                  PageIndicatorWidget(
                    currentPage: currentIndex,
                    itemCount: _items.length,
                    itemSize: Size(72 / _items.length, 2),
                    // itemBuilder: (isSelected, itemSize) {
                    //   return Container(
                    //     width: itemSizeidth,
                    //     height: itemSize.height,
                    //     color: isSelected ? Colors.red : Colors.green,
                    //   );
                    // },
                  )
              ],
            )),
      );
    });
  }

  //分割区间
  _buildSeparator(context, index) {
    // return Container(
    //   width: gap,
    //   color: Colors.blue,
    // );
    return Divider(
      // height: 8,
      indent: widget.gap,
      // color: Colors.blue,
    );
  }

  _buildDecoration() {
    return BoxDecoration(
      // color: Colors.green,
      // border: Border.all(width: 3, color: Colors.red),
      borderRadius: widget.borderRadius,
      // boxShadow: boxShadows,
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.redithOpacity(0.5),
      //     // spreadRadius: 5,
      //     blurRadius: 5,
      //     offset: Offset(0, 3), // changes position of shadow
      //   ),
      // ],
    );
  }

  /// 水平滚动条
  Widget _scrollerBar({
    required double maxWidth,
    required double itemWidth,
    double barHeight = 3,
    Color barColor = const Color(0xFFBE965A),
  }) {
    if (_items.length <= 1) {
      return SizedBox();
    }

    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(1)),
          child: Container(
            height: barHeight,
            width: maxWidth,
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        ValueListenableBuilder<double>(
            valueListenable: scrollerOffset,
            builder: (context, value, child) {
              // print("value:$value");
              var indicatorWidth = 80.0;
              var left = value * (maxWidth - indicatorWidth);
              return Positioned(
                  left: left,
                  child: Container(
                    height: barHeight,
                    width: indicatorWidth,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ));
            }),
      ],
    );
  }

  /// 点击事件
  _onClick(AttrCarouseItem model, int index) {
    debugPrint(model.detailName ?? "");
  }
}

class AttrCarouseItem {
  AttrCarouseItem({
    this.contentType,
    this.detailName,
    this.detailsUrl,
    this.entryIntoForceTime,
    this.id,
    this.liveBroadcast,
    this.icon,
    this.title,
    this.type,
    this.region,
    this.subTitle,
  });
  // 轮播类型
  // 轮播广告ID
  int? id;
  // 1-图片轮播 2-文字轮播
  int? type;
  // 图片
  String? icon;
  // 内容标题
  String? title;
  // 内容副标题
  String? subTitle;
  // 生效时间
  List<int>? entryIntoForceTime;
  // 详情类型// 1-详情地址、2-详情图片、3-详情视频； 4-详情直播；
  int? contentType;
  // 详情地址/详情图片/详情视频/直播详情地址
  String? detailsUrl;
  // 上传的资源名称，配置时回填要用， 三翼鸟用不到，可以忽略
  String? detailName;
  // 直播时段 // 轮播接口生效时间
  List<int>? liveBroadcast;
  // 适用地域 100000--全国  选择省只有省的regioncode
  List<String>? region;

  static AttrCarouseItem fromJson(json) {
    return AttrCarouseItem(
        contentType: json['contentType'] as int?,
        detailName: json['detailName'] as String?,
        detailsUrl: json['detailsUrl'] as String?,
        entryIntoForceTime: (json['entryIntoForceTime'] as List?)?.map((e) {
          try {
            return int.parse(e.toString());
          } catch (e) {
            return -1;
          }
        }).toList(),
        id: json['id'] as int?,
        liveBroadcast: (json['liveBroadcast'] as List?)?.map((e) {
          try {
            return int.parse(e.toString());
          } catch (e) {
            return -1;
          }
        }).toList(),
        icon: json['pictureUrl'] as String?,
        region: (json['region'] as List?)?.map((e) => e.toString()).toList(),
        subTitle: json['subTitle'] as String?,
        title: json['title'] as String?,
        type: json['type'] as int?);
  }
}
