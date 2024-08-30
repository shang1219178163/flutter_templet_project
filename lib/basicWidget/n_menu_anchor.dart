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
    this.controller,
    this.style,
    this.dropButtonStyle,
    this.constraints,
    this.decoration,
    required this.values,
    required this.initialItem,
    this.builder,
    this.itemBuilder,
    required this.onChanged,
    required this.equal,
    required this.cbName,
    this.placeholder = "请选择",
  });

  final MenuController? controller;
  final MenuStyle? style;
  final ButtonStyle? dropButtonStyle;

  /// 下拉框约束
  final BoxConstraints? constraints;

  /// 下拉框装饰
  final BoxDecoration? decoration;

  /// 数据源
  final List<E> values;

  /// 初始化数据
  final E? initialItem;

  /// item 子视图构建器
  final Widget Function(MenuController controller, E? selectedItem)? builder;

  /// item 子视图构建器
  final Widget Function(E e, bool isSelected)? itemBuilder;

  /// 选择回调
  final ValueChanged<E> onChanged;

  /// 相等对比
  final bool Function(E a, E? b) equal;

  /// 标题回调
  final String Function(E? e) cbName;
  final String placeholder;

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

        final menuItems = values.map((e) {
          final isSelected = equal(e, selectedItem);

          return MenuItemButton(
            style: dropButtonStyle,
            // style: ButtonStyle(
            //   padding: MaterialStatePropertyAll(EdgeInsets.all(8)),
            //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   // backgroundColor: MaterialStateProperty.all(Colors.yellow),
            // ),
            onPressed: () {
              onItem(e);
            },
            child: itemBuilder?.call(e, isSelected) ?? Text(cbName(e)),
          );
        }).toList();

        return MenuTheme(
          data: MenuThemeData(
            style: style ??
                MenuStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  elevation: MaterialStateProperty.all(8),
                  shadowColor: MaterialStateProperty.all(Colors.black54),
                ),
          ),
          child: MenuAnchor(
            controller: controller,
            builder: (context, MenuController controller, Widget? child) {
              final defaultName =
                  selectedItem == null ? placeholder : cbName(selectedItem);

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
                        Text(defaultName),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
            },
            menuChildren: [
              if (constraints != null)
                buildMenu(
                  constraints: constraints!,
                  decoration: decoration,
                  children: menuItems,
                ),
              if (constraints == null) ...menuItems,
            ],
          ),
        );
      },
    );
  }

  Widget buildMenu({
    required BoxConstraints constraints,
    required BoxDecoration? decoration,
    required List<Widget> children,
  }) {
    final scrollController = ScrollController();

    return Container(
      constraints: constraints,
      decoration: decoration,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
