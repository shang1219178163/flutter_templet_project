import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
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
