import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:tuple/tuple.dart';

/// 长按黑色菜单
class NLongPressMenu extends StatelessWidget {
  const NLongPressMenu({
    Key? key,
    required this.items,
    required this.onItem,
  }) : super(key: key);

  /// 标题和本地图片
  final List<Tuple2<String, AssetImage>> items;

  /// 点击菜单回调
  final ValueChanged<Tuple2<String, AssetImage>> onItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      // height: 100,
      padding: const EdgeInsets.only(top: 14, right: 20, bottom: 12, left: 20),
      decoration: const BoxDecoration(
        color: Color(0xff4d4d4d),
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
        minWidth: 0,
        maxHeight: 400,
      ),
      child: Wrap(
        spacing: 34,
        runSpacing: 16,
        children: items.map((e) {
          final child = NPair(
            direction: Axis.vertical,
            icon: Image(
              image: e.item2,
              width: 18,
              height: 18,
              fit: BoxFit.fill,
            ),
            child: NText(
              e.item1,
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          );

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onItem(e);
              },
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 长按黑色菜单(中间有横线版本)
class NLongPressMenuOne extends StatelessWidget {
  const NLongPressMenuOne({
    Key? key,
    required this.items,
    this.hideAssetImage = false,
    required this.onItem,
    this.itemWidth = 65,
    this.itemHeight,
  }) : super(key: key);

  /// 标题和本地图片
  final List<Tuple2<String, AssetImage>> items;

  final bool hideAssetImage;

  // 子项宽度
  final double itemWidth;
  final double? itemHeight;

  /// 点击菜单回调
  final ValueChanged<Tuple2<String, AssetImage>> onItem;

  @override
  Widget build(BuildContext context) {
    final itemWidthNew = itemWidth.truncateToDouble();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: const BoxDecoration(
        color: Color(0xff4d4d4d),
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        minWidth: 0,
        maxHeight: 400,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 获取 Wrap 父容器的宽度
          double containerWidth = constraints.maxWidth;
          // 计算每行可以显示的组件数
          int crossAxisCount = (containerWidth / (itemWidthNew + 0)).floor();
          // 计算行数
          final rowCount = items.length % crossAxisCount == 0
              ? items.length / crossAxisCount
              : items.length ~/ crossAxisCount + 1;

          DLog.d([crossAxisCount, rowCount, itemWidthNew]);
          return Wrap(
            // spacing: 16,
            // runSpacing: 16,
            alignment: WrapAlignment.start,
            children: items.map((e) {
              final index = items.indexOf(e);

              final isFirtRow = index < crossAxisCount;
              final isLastRow = index > ((rowCount - 1) * crossAxisCount - 1);
              // DLog.d([
              //   index,
              //   e.item1,
              //   rowCount,
              //   isFirtRow,
              //   isLastRow,
              //   ((rowCount - 1) * crossAxisCount - 1)
              // ]);

              final borderSideColor = isLastRow
                  ? Colors.transparent
                  : const Color(0xffE5E5E5).withOpacity(0.2);

              final child = Container(
                width: itemWidthNew,
                height: itemHeight,
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // color: ColorExt.random,
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: borderSideColor,
                    ),
                  ),
                ),
                child: NPair(
                  direction: Axis.vertical,
                  icon: hideAssetImage
                      ? null
                      : Image(
                          image: e.item2,
                          width: 18,
                          height: 18,
                          fit: BoxFit.fill,
                        ),
                  child: NText(
                    e.item1,
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              );

              return Material(
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                    // side: BorderSide(color: Colors.red),
                    ),
                child: InkWell(
                  onTap: () {
                    onItem(e);
                  },
                  child: child,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
