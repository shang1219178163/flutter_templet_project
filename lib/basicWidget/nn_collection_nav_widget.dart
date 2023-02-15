import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/edge_insets_ext.dart';

/// 默认图标大小
const double DEFALUT_ICON_SIZE = 44;
/// 默认间距
const double SPACING = 10;


/// 图文导航
class NNCollectionNavWidget extends StatefulWidget {
  NNCollectionNavWidget({
    Key? key,
    this.title,
    required this.items,
    this.scrollType = PageViewScrollType.full,
    this.pageRowNum = 2,
    this.pageColumnNum = 5,
    this.iconSize = DEFALUT_ICON_SIZE,
    this.textHeight = 16,
    this.textGap = 0,
    this.columnSpacing = 16,
    this.rowSpacing = SPACING,
    this.autoAdjustHeight = true,
    this.indicatorItemHeight = 2,
    this.indicatorItemWidth = 12,
    this.indicatorGap = 8,
    this.boxShadows,
    this.isDebug = false,
  }) : super(key: key);

  String? title;

  /// 当前页面数据
  List<AttrNavItem> items;
  /// 滚动方式
  PageViewScrollType scrollType;

  ///金刚区每页行数
  int pageRowNum;
  ///金刚区每页列数
  int pageColumnNum;
  /// 图标默认高度
  double iconSize;
  /// 子项标题高度
  double textHeight;
  /// 文字间距
  double textGap;
  /// 垂直间距
  double columnSpacing;
  /// 水平间距
  double rowSpacing;
  /// 边界
  // EdgeInsets padding;
  /// 是否自适应高度
  bool autoAdjustHeight;
  /// 指示器高度
  double indicatorItemHeight;
  /// 指示器子项宽度
  double indicatorItemWidth;
  /// 指示器与最后一样的标题间距
  double indicatorGap;
  /// 阴影
  List<BoxShadow>? boxShadows;

  /// 提示模式会展示颜色
  bool isDebug;

  @override
  _NNCollectionNavWidgetState createState() => _NNCollectionNavWidgetState();
}

class _NNCollectionNavWidgetState extends State<NNCollectionNavWidget> {
  
  // /// 初始传值数据
  // List<AttrNavItem> _initilItems = [];
  /// 当前页面数据
  List<AttrNavItem> _items = [];

  ///金刚区页数
  int pageCount = 1;

  /// 滑动控制器
  PageController? controller;
  /// 监听滚动偏移量
  var scrollOffset = new ValueNotifier(0.0);
  /// 子项高度
  double get itemHeight => widget.iconSize + widget.textGap + widget.textHeight;
  /// 传入的每页最大数量
  int get pageNum => widget.pageRowNum * widget.pageColumnNum;

  // /// 整个视图总高度
  // double get totalHeight {
  //   var height = itemHeight * widget.pageRowNum + widget.columnSpacing * (widget.pageRowNum - 1) + widget.indicatorGap + widget.indicatorItemHeight;
  //   return height;
  // }

  ///是否支持整屏滑动
  bool get pageSnap {
    return (widget.scrollType == PageViewScrollType.full);
  }

  /// 包含外观 margin + BoxShadow 的 margin 总和
  EdgeInsets get marginTotal {
    var edge = EdgeInsets.zero;

    if (widget.boxShadows != null && widget.boxShadows!.length > 0) {
      BoxShadow shadow = widget.boxShadows![0];
      /// 留出阴影空间
      edge = edge.mergeShadow(shadow: shadow);
    }
    return edge;
  }

  /// item行间距(和h5渲染原理不同,需预留阴影外壳的外间距)
  double get runSpacing {
    final vertical = (marginTotal.top + marginTotal.bottom);
    if (widget.rowSpacing <= vertical) {
      return 8;
    }
    final result = (widget.rowSpacing - vertical).truncateToDouble();
    return result;
  }

  @override
  void dispose() {
    controller?.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    controller = PageController();
    controller!.addListener(() {
      scrollOffset.value = controller!.offset;
      // print("scrollOffset:${scrollOffset.value}");
    });

    initailData();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int totalCount = _items.length; //展示总数

    if (widget.scrollType == PageViewScrollType.none) {
      pageCount = 1;
      totalCount = min(totalCount, pageNum);
    } else {
      pageCount = (totalCount / pageNum).ceil();
    }
    // 整个视图总高度
    var totalHeight = itemHeight * widget.pageRowNum + widget.columnSpacing * (widget.pageRowNum - 1) + widget.indicatorGap + widget.indicatorItemHeight;
    if (pageNum >= _items.length) {
      /// 实际 pageRowNum
      final num = (totalCount % widget.pageColumnNum) == 0 ? totalCount ~/ widget.pageColumnNum : totalCount ~/ widget.pageColumnNum + 1;
      totalHeight = itemHeight * num + widget.columnSpacing * (num - 1) + widget.indicatorGap + widget.indicatorItemHeight;
    }

    var margin = EdgeInsets.zero;

    var container = Container(
      // color: widget.isDebug ? Colors.green : null,
      height: widget.autoAdjustHeight ? totalHeight : null,
      child: LayoutBuilder(
          builder: (context, constraints) {
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                color: widget.isDebug ? ColorExt.random : null,
                margin: margin,
                width: constraints.maxWidth,
                child: _pageContent(),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: widget.indicatorItemHeight,
                  child: Center(
                    child: _scrollerIndicator(
                      width: constraints.maxWidth,
                      indicatorItemHeight: widget.indicatorItemHeight,
                      indicatorItemWidth: widget.indicatorItemWidth,
                    ),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
    return container;
  }

  /// 数据初始化
  initailData() {
    _items = widget.items;
  }

  /// 每页的内容容器
  Widget _pageContent() {
    return LayoutBuilder(
      builder: (context, constraints) {

        double edgeHorizontal = widget.rowSpacing*0.5;
        var itemWidth = (constraints.maxWidth - widget.rowSpacing * (widget.pageColumnNum - 1) - edgeHorizontal*2) / widget.pageColumnNum;

        return PageView.builder(
          key: const PageStorageKey('CollectionNavWidget'),
          itemCount: pageCount,
          controller: controller,
          pageSnapping: pageSnap,
          physics: pageCount == 1 ? NeverScrollableScrollPhysics() : null,
          // clipBehavior: Clip.none,
          itemBuilder: (context, pageIndex) {

            return Container(
              // color: ColorExt.random,//add test
              padding: EdgeInsets.only(left: edgeHorizontal),
              child: Wrap(
                key: Key("Wrap_$pageIndex"),
                spacing: widget.rowSpacing,
                runSpacing: widget.columnSpacing,
                children: _getChildren(
                  pageIndex: pageIndex,
                  pageTotal: widget.pageRowNum * widget.pageColumnNum,
                  width: itemWidth,
                ),
              ),
            );
          },
        );
      }
    );
  }

  /// item 数组集合
  List<Widget> _getChildren({
    required int pageIndex,
    required int pageTotal,
    required double width
  }) {
    return List.generate(pageTotal, (i) => Container(
      // color: i % 2 == 0 ? Colors.green : Colors.yellow,
      constraints: BoxConstraints(maxWidth: width),
      child: _getItem(
          ctx: context,
          index: pageTotal * pageIndex + i,
          imgWidth: width
      ),
    )).toList();
  }

  /// item 组件
  Widget _getItem({
    required BuildContext ctx,
    required int index,
    required double imgWidth
  }) {
    if (index >= _items.length) {
      return SizedBox();
    }

    AttrNavItem model = _items[index];

    String iconUrl = model.icon ?? '';

    var imgBorderRadius = BorderRadius.all(Radius.circular(10));//add test

    // var imgBoxShadow = widget.attr?.itemImg?.shadow?.boxShadows;//图文导航子项没有阴影设置

    final child = Container(
      color: widget.isDebug ? ColorExt.random : null,//add test
      // width: imgWidth,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              // color: Colors.green,//add test
              // boxShadow: imgBoxShadow,
            ),
            child: ClipRRect(
              borderRadius: imgBorderRadius,
              child: FadeInImage(
                placeholder: AssetImage('images/img_placeholder.png'),
                image: NetworkImage(iconUrl),
                fit: BoxFit.fill,
                width: widget.iconSize,
                height: widget.iconSize,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: widget.textGap),
            height: widget.textHeight,
            child: Center(
              child: _getItemTitle(
                model: model,
                imgWidth: imgWidth,
                index: index,
                addFittedBox: true,
              ),
            )
          ),
          // Container(
          //   height: 16,
          //   margin: EdgeInsets.only(top: textOffset),
          //   color: Colors.blue,//add test
          //   child: OverflowBox(
          //     alignment: Alignment.center,
          //     maxWidth: imgWidth + 18,
          //     maxHeight: 16,
          //     child: _getItemTitle(
          //       model: model,
          //       imgWidth: imgWidth,
          //       index: index,
          //     )
          //   ),
          // ),
        ],
      ),
    );

    return InkWell(
      child: child,
      onTap: (){
        print("InkWell: ${model.name}");
      },
    );
  }

  /// 标题
  Widget _getItemTitle({
    required AttrNavItem model,
    required double imgWidth,
    required int index,
    bool addFittedBox = false,
  }) {
    String name = model.name ?? '';
    if (name.isEmpty) {
      return Container();
    }

    int textLimit = 5.toInt();
    if (textLimit < name.length) {
      name = name.substring(0, textLimit);
    }

    // if (index <= 1) {//add test
    //   name += "啊";
    // }
    Widget textWidget = Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.visible,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
    );

    if (widget.isDebug) {
      textWidget = ColoredBox(
        color: ColorExt.random,
        child: textWidget
      );
    }

    if (addFittedBox) {
      return FittedBox(
        fit: BoxFit.none,
        child: textWidget,
      );
    }
    return textWidget;
  }

  /// 自定义滚动条
  Widget _scrollerIndicator({
    required double width,
    double indicatorItemHeight = 2,
    double indicatorItemWidth = 120,

  }) {
    if (pageCount < 2) {
      return Container();
    }
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(1)),
          child: Container(
            height: indicatorItemHeight,
            width: indicatorItemWidth.toDouble() * pageCount,
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: scrollOffset,
          builder: (context, value, child) {
            final offset = (value / width) * indicatorItemWidth;
            // print("ValueListenableBuilder: ${value}_${offset}");

            return Positioned(
              left: offset,
              child: Container(
                height: indicatorItemHeight,
                width: indicatorItemWidth,
                decoration: BoxDecoration(
                  color: Color(0xFFBE965A),
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(1),
                ),
              )
            );
          }
        ),
      ],
    );
  }

}


class AttrNavItem {
  // 唯一标识
  int? id;
  // 图片
  String? icon;
  // 导航名称
  String? name;
  // 绑定事件
  String? url;
  // 角标类型
  int? cornerMarker;

  AttrNavItem({
    this.id,
    this.icon,
    this.name,
    this.url,
    this.cornerMarker,
  });

  static AttrNavItem? fromJson(json) {
    if (!(json is Map)) {
      return null;
    }
    return AttrNavItem(
      icon: json['icon'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      cornerMarker: json['cornerMarker'] as int?,
    );
  }
}


/// PageView 滚动方式
enum PageViewScrollType {
  /// 整屏滑动
  full, // 0
  /// 拖拽滑动
  drag, // 1
  /// 禁用滑动
  none, // 2
}

extension PageViewScrollType_IntExt on int{
  /// int 转枚举
  PageViewScrollType? toPageViewScrollType([bool isClamp = true]){
    final allCases = PageViewScrollType.values;
    if (!isClamp) {
      if (this < 0 || this > allCases.length - 1) {
        return null;
      }
      return allCases[this];
    }
    final index = this.clamp(0, allCases.length - 1);
    return allCases[index];
  }

  /// int 转枚举
  PageViewScrollType get pageViewScrollType{
    final allCases = PageViewScrollType.values;
    // final index = this.clamp(0, allCases.length - 1);
    // return allCases[index];
    return this.toPageViewScrollType(true) ?? allCases.first;
  }

}
