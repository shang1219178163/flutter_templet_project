

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/color_util.dart';
import 'package:tuple/tuple.dart';


class NCollectionView extends StatefulWidget {

  NCollectionView({
    Key? key,
    required this.items,
    this.contentPadding,
    this.onBefore,
    this.onAfter,
  }) : super(key: key);

  /// 第一个参数: 标题
  /// 第二个参数: 本地图路径
  /// 第三个参数: 回调方法
  List<Tuple3<String, String, VoidCallback>> items;

  EdgeInsets? contentPadding;

  ValueChanged<int>? onBefore;
  ValueChanged<int>? onAfter;

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
      height: 216.w,
      child: buildPageView(
        items: widget.items,
        contentPadding: widget.contentPadding,
        onBefore: widget.onBefore,
        onAfter: widget.onAfter,
      ),
    );
  }

  Widget buildPageView({
    required List<Tuple3<String, String, VoidCallback>> items,
    EdgeInsets? contentPadding,
    ValueChanged<int>? onBefore,
    ValueChanged<int>? onAfter,
  }) {
    // debugPrint("rowNum: $rowNum, numPerRow: $numPerRow, numPerPage: $numPerPage");

    final pageCount = items.length % numPerPage == 0 ? items.length/numPerPage
        : items.length/numPerPage + 1;
    final array = List.generate(pageCount.toInt(), (index) => index).toList();
    // debugPrint("pageCount: $pageCount, array: $array");

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            indexVN.value = index;
            // setState(() {});
          },
          itemBuilder: (BuildContext context, int pageIndex) {

            return Container(
              // height: 200.w,
              padding: contentPadding ?? EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: 16.h,
              ),
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                // border: Border.all(color: Colors.blue),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                final itemWidth = 64.w;
                final spacing =
                    (constraints.maxWidth - itemWidth * numPerRow) / (numPerRow - 1).truncateToDouble();
                final runSpacing = 16.w;

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
                      onTap: (){
                        onBefore?.call(i);
                        e.item3();
                        onAfter?.call(i);
                      },
                      child: SizedBox(
                        width: itemWidth,
                        child: Column(
                          children: [
                            Container(
                              width: 54.w,
                              height: 54.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(14.w)),
                                // border: Border.all(),
                              ),
                              child: Image(
                                image: AssetImage(e.item2),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.w),
                              child: Text(
                                e.item1,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: fontColor,
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
        Positioned(
          bottom: 8.w,
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
          builder: (context, value, child){

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(count, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CircleAvatar(
                    radius: 4.w,
                    backgroundColor: index == value
                        ? Color(0xff7C7C7C)
                        : Color(0xffDDDDDD),
                  ),
                );
              },),
            );
          }
      ),
    );
  }


}