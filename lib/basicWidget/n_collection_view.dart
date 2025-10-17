import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:tuple/tuple.dart';

class NCollectionView extends StatefulWidget {
  const NCollectionView({
    Key? key,
    required this.items,
    this.spacing = 8.0,
    this.runSpacing = 16.0,
    // this.itemWidth,
    this.itemStyle,
    this.contentPadding,
    this.decoration,
  }) : super(key: key);

  /// 装饰器
  final BoxDecoration? decoration;

  /// 第一个参数: 标题
  /// 第二个参数: 本地图片路径
  /// 第三个参数: 回调方法
  final List<Tuple3<String, String, VoidCallback>> items;

  /// 水平间距
  final double spacing;

  /// 竖直间距
  final double runSpacing;

  // /// item 宽度
  // final double? itemWidth;

  /// item 字体样式
  final TextStyle? itemStyle;

  final EdgeInsets? contentPadding;

  @override
  _NCollectionViewState createState() => _NCollectionViewState();
}

class _NCollectionViewState extends State<NCollectionView> with SingleTickerProviderStateMixin {
  final indexVN = ValueNotifier(0);

  late final _pageController = PageController(initialPage: indexVN.value, keepPage: true);

  ///每页行数
  int rowNum = 2;

  ///每页列数
  int numPerRow = 4;

  ///每页数
  int get numPerPage => rowNum * numPerRow;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      decoration: widget.decoration,
      child: buildPageView(
        items: widget.items,
        // itemWidth: widget.itemWidth ?? 64,
        itemStyle: widget.itemStyle,
        contentPadding: widget.contentPadding,
      ),
    );
  }

  Widget buildPageView({
    required List<Tuple3<String, String, VoidCallback>> items,
    // double itemWidth = 64,
    TextStyle? itemStyle,
    EdgeInsets? contentPadding,
  }) {
    final num = items.length ~/ numPerPage;
    final pageCount = items.length % numPerPage == 0 ? num : num + 1;
    final array = List.generate(pageCount.toInt(), (index) => index).toList();
    // debugPrint("pageCount: $pageCount, array: $array");

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: pageCount,
          pageSnapping: true,
          physics: pageCount == 1 ? const NeverScrollableScrollPhysics() : null,
          onPageChanged: (index) {
            indexVN.value = index;
            // setState(() {});
          },
          itemBuilder: (BuildContext context, int pageIndex) {
            return Container(
              // height: 200,
              padding: contentPadding ?? EdgeInsets.only(left: 4, right: 4, top: 20, bottom: 16),
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                // border: Border.all(color: Colors.blue),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                // final spacing = (constraints.maxWidth - itemWidth * numPerRow) /
                //     (numPerRow - 1).truncateToDouble();

                final spacing = widget.spacing;
                final itemWidth = (constraints.maxWidth - (spacing * (numPerRow - 1))) / numPerRow.truncateToDouble();
                final runSpacing = widget.runSpacing;

                return Wrap(
                  spacing: spacing,
                  runSpacing: runSpacing,
                  // alignment: WrapAlignment.start,
                  children: List.generate(numPerPage, (i) {
                    // final i = items.indexOf(e);
                    final itemIndex = numPerPage * pageIndex + i;
                    // debugPrint("items.length: ${items.length} itemIndex: $itemIndex");
                    if (itemIndex >= items.length) {
                      return SizedBox();
                    }

                    final e = items[itemIndex];

                    return InkWell(
                      onTap: () {
                        e.item3();
                      },
                      child: Container(
                        width: itemWidth,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          // border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                                // border: Border.all(),
                              ),
                              child: Image(
                                image: AssetImage(e.item2),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                e.item1,
                                style: itemStyle ??
                                    TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.fontColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            );
          },
        ),
        if (array.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            // height: 40,
            child: buildIndiactor(count: array.length),
          ),
      ],
    );
  }

  Widget buildIndiactor({required int count}) {
    if (count <= 1) {
      return SizedBox();
    }

    return Container(
      // color: Colors.black12,
      child: ValueListenableBuilder<int>(
        valueListenable: indexVN,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              count,
              (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: index == value ? Color(0xff7C7C7C) : Color(0xffDDDDDD),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
