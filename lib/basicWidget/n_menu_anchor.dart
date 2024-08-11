//
//  NMenuAnchor.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/31 19:29.
//  Copyright © 2023/10/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// MenuAnchor 简易封装,方便代码复用
class NMenuAnchor<E> extends StatelessWidget {
  const NMenuAnchor({
    super.key,
    this.style,
    required this.values,
    required this.initialItem,
    this.builder,
    this.itemBuilder,
    required this.onChanged,
    required this.cbName,
  });

  final MenuStyle? style;

  /// 数据源
  final List<E> values;

  /// 初始化数据
  final E initialItem;

  /// item 子视图构建器
  final Widget Function(MenuController controller, E? selectedItem)? builder;

  /// item 子视图构建器
  final Widget Function(E e, bool isSelected)? itemBuilder;

  /// 选择回调
  final ValueChanged<E> onChanged;

  /// 标题回调
  final String Function(E e) cbName;

  @override
  Widget build(BuildContext context) {
    var selectedItem = initialItem;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        // 点击子项
        onItem(E e) {
          selectedItem = e;
          setState(() {});
          onChanged.call(e);
        }

        return MenuTheme(
          data: MenuThemeData(
            style: style ??
                MenuStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                  // backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(8),
                  shadowColor: MaterialStateProperty.all(Colors.black54),
                ),
          ),
          child: MenuAnchor(
            builder: (context, MenuController controller, Widget? child) {
              return builder?.call(controller, selectedItem) ??
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      // backgroundColor: Color(0xff5690F4).withOpacity(0.1),
                      // foregroundColor: Color(0xff5690F4),
                      elevation: 0,
                      // shape: StadiumBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // minimumSize: Size(64, 32),
                      padding:
                          EdgeInsets.only(left: 8, right: 2, top: 6, bottom: 6),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cbName(selectedItem)),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
            },
            menuChildren: values.map((e) {
              return MenuItemButton(
                onPressed: () {
                  onItem(e);
                },
                child:
                    itemBuilder?.call(e, e == selectedItem) ?? Text(cbName(e)),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// class NEnumMenuAnchor<E extends Enum> extends StatelessWidget {
//
//   NEnumMenuAnchor({
//     super.key,
//     required this.values,
//     // this.selectedItem,
//     this.initialItem,
//     this.defaultValue = "-",
//     this.itemBuilder,
//     required this.onChanged,
//   });
//
//   final List<E> values;
//   // E? selectedItem;
//   final E? initialItem;
//   final String defaultValue;
//   final Widget Function(MenuController controller, E? selectedItem)? itemBuilder;
//   final ValueChanged<E> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     var selectedItem = initialItem;
//
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//
//           return MenuAnchor(
//             builder: (context, MenuController controller, Widget? child) {
//
//               return itemBuilder?.call(controller, selectedItem) ?? OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   // backgroundColor: Color(0xff5690F4).withOpacity(0.1),
//                   // foregroundColor: Color(0xff5690F4),
//                   elevation: 0,
//                   // shape: StadiumBorder(),
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   // minimumSize: Size(64, 32),
//                   padding: EdgeInsets.only(left: 8, right: 2, top: 6, bottom: 6),
//                 ),
//                 onPressed: (){
//                   if (controller.isOpen) {
//                     controller.close();
//                   } else {
//                     controller.open();
//                   }
//                 },
//                 // child: Text(selectedItem?.name ?? defaultValue),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(selectedItem?.name ?? defaultValue),
//                     Icon(Icons.arrow_drop_down),
//                   ],
//                 ),
//               );
//             },
//             menuChildren: values.map((e) {
//               return MenuItemButton(
//                 onPressed: () {
//                   selectedItem = e;
//                   setState(() {});
//                   onChanged.call(e);
//                 },
//                 child: Text(e.name),
//               );
//             }).toList(),
//           );
//         }
//     );
//   }
// }
