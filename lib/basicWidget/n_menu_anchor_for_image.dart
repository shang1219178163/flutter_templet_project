//
//  NMenuAnchor.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/31 19:29.
//  Copyright © 2023/10/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 图标弹出菜单 简易封装,方便代码复用
class NMenuAnchorForImage extends StatefulWidget {
  NMenuAnchorForImage({
    super.key,
    required this.values,
    required this.initialItem,
    required this.onChanged,
    this.itemPadding = const EdgeInsets.all(16.0),
    this.itemSpacing = 8,
  });

  /// 数据源
  final List<String> values;

  /// 初始化数据
  final String initialItem;

  /// 选择回调
  final ValueChanged<String> onChanged;

  final EdgeInsets itemPadding;

  final double itemSpacing;

  @override
  State<NMenuAnchorForImage> createState() => _NMenuAnchorForImageState();
}

class _NMenuAnchorForImageState extends State<NMenuAnchorForImage> {
  late var selectedItem = widget.initialItem;

  late final menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          menuTheme: MenuThemeData(
              style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            // surfaceTintColor: MaterialStateProperty.all(Colors.red),
            shape: WidgetStateProperty.all<OutlinedBorder?>(const RoundedRectangleBorder()),
            elevation: WidgetStateProperty.all<double?>(0.0),
          )),
          menuButtonTheme: MenuButtonThemeData(
              style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
          ))),
      child: MenuAnchor(
        controller: menuController,
        builder: (context, MenuController controller, Widget? child) {
          return buildItem(
            imgName: selectedItem,
            padding: widget.itemPadding,
            onPressed: () {
              if (menuController.isOpen) {
                menuController.close();
              } else {
                menuController.open();
              }
            },
          );
        },
        menuChildren: widget.values.map((e) {
          return Padding(
            padding: EdgeInsets.only(bottom: widget.itemSpacing),
            child: buildItem(
              imgName: e,
              padding: widget.itemPadding,
              onPressed: () {
                selectedItem = e;
                setState(() {});
                widget.onChanged.call(e);
                if (menuController.isOpen) {
                  menuController.close();
                } else {
                  menuController.open();
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildItem({
    required String imgName,
    VoidCallback? onPressed,
    padding = const EdgeInsets.all(16.0),
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Image(
          image: imgName.toAssetImage(),
          color: Colors.white,
          width: 20,
          height: 20,
        ),
      ),
    );

    // return Theme(
    //   data: ThemeData(
    //     floatingActionButtonTheme: FloatingActionButtonThemeData(
    //       backgroundColor: Theme.of(context).indicatorColor,
    //       splashColor: Colors.transparent,
    //     )
    //   ),
    //   child: FloatingActionButton(
    //     onPressed: onPressed,
    //     child: Padding(
    //       padding: padding,
    //       child: Image(
    //         image: imgName.toAssetImage(),
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    // );
  }
}
