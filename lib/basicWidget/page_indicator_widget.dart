
import 'package:flutter/material.dart';

typedef PageIndicatorItemWidgetBuilder = Widget Function(bool isSelected, Size itemSize);

/// 轮播图指示器
class PageIndicatorWidget extends StatelessWidget {

  PageIndicatorWidget({ 
    Key? key, 
    this.margin = const EdgeInsets.only(bottom: 10),
    required this.currentPage,
    required this.itemCount,
    this.normalColor = const Color(0x25ffffff), 
    this.selectedColor = Colors.white,
    this.itemSize = const Size(8, 2),
    this.itemBuilder,
    this.hidesForSinglePage = true
  }) : super(key: key);

  /// 当前页面索引
  ValueNotifier<int> currentPage;

  EdgeInsetsGeometry? margin;

  /// item数量
  int itemCount;
  /// 每个item尺寸(最好用固定宽度除以个数,避免总宽度溢出)
  Size itemSize;
  /// 自定义每个 item
  PageIndicatorItemWidgetBuilder? itemBuilder;
  /// 默认颜色
  Color? normalColor;
  /// 选中颜色
  Color? selectedColor;
  /// 单页隐藏
  bool hidesForSinglePage;

  @override
  Widget build(BuildContext context) {
    if (this.hidesForSinglePage && this.itemCount == 1) {
      return SizedBox();
    }
    return buildPageIndicator();
  }

  Widget buildPageIndicator() {
    return Container(
      margin: this.margin,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ValueListenableBuilder(
          valueListenable: this.currentPage,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: buildPageIndicatorItem(
                currentIndex: this.currentPage.value,
                normalColor: this.normalColor,
                selectedColor: this.selectedColor,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildPageIndicatorItem({
    currentIndex: 0,
    normalColor: const Color(0x25ffffff), 
    selectedColor: Colors.white,
  }) {
    List<Widget> list = List.generate(this.itemCount, (index) {
      return this.itemBuilder != null ? this.itemBuilder!(currentIndex == index, this.itemSize) : ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(1)),
        child: Container(
          width: this.itemSize.width,
          height: this.itemSize.height,
          color: currentIndex == index ? selectedColor : normalColor,
        ),
      );
    });
    return list;
  }
}