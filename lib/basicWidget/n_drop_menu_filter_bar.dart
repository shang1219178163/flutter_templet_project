//
//  PatientFilterBar.dart
//  projects
//
//  Created by shang on 2024/8/28 10:20.
//  Copyright © 2024/8/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 搜索框加 dropMenu
class NDropMenuFilterBar<E> extends StatelessWidget {
  const NDropMenuFilterBar({
    super.key,
    this.margin,
    this.padding,
    required this.values,
    this.selectedItemVN,
    required this.cbName,
    required this.equal,
    this.placeholder = "请选择",
    required this.onChanged,
    this.hideDropMenu = false,
    this.searchPlaceholder = "请输入筛选号",
    this.search,
    this.onSearchChanged,
    this.radius = 4,
    this.onItemName,
    this.constraints,
  });

  /// 外边距
  final EdgeInsets? margin;

  /// 内边距
  final EdgeInsets? padding;

  /// 下拉菜单数据源
  final List<E> values;

  /// 下拉菜单默认选项
  final ValueNotifier<E?>? selectedItemVN;

  /// 下拉菜单标题回调
  final String Function(E? e) cbName;

  /// 相等对比
  final bool Function(E a, E? b) equal;

  /// 下拉菜单默认标题
  final String placeholder;

  /// 下拉框约束
  final BoxConstraints? constraints;

  /// 下拉菜单选择回调
  final ValueChanged<E> onChanged;

  /// 隐藏下拉列表
  final bool hideDropMenu;

  /// 输入框提示
  final String searchPlaceholder;

  /// 输入框回调
  final String? search;

  /// 输入框回调
  final ValueChanged<String>? onSearchChanged;

  /// 圆角
  final double radius;

  /// 名称二次处理
  final String Function(String name)? onItemName;

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final controller = TextEditingController(text: search);

    return Container(
      margin: margin,
      padding: padding,
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          if (onSearchChanged != null)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: lineColor),
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                ),
                // padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
                child: NSearchTextField(
                  padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                  backgroundColor: white,
                  hidePrefixIcon: true,
                  autofocus: false,
                  placeholder: searchPlaceholder,
                  controller: controller,
                  onChanged: onSearchChanged!,
                ),
              ),
            ),
          if (!hideDropMenu)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NText(data: "分组: "),
                  Expanded(
                    child: NMenuAnchor<E>(
                      values: values,
                      initialItem: selectedItemVN?.value,
                      equal: equal,
                      cbName: cbName,
                      onChanged: (e) {
                        selectedItemVN?.value = e;
                        onChanged(e);
                      },
                      dropButtonStyle: ButtonStyle(
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize:
                            const MaterialStatePropertyAll(Size(20, 18)),
                        backgroundColor: MaterialStateProperty.all(bgColor),
                      ),
                      constraints: constraints,
                      builder: (controller, selectedItem) {
                        final name = getName(selectedItem);
                        final nameStyle = getNameStyle(name: name);
                        return InkWell(
                          onTap: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: lineColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(radius)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    name ?? placeholder,
                                    style: nameStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                      "assets/images/icon_arrow_down.png"),
                                  width: 16,
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemBuilder: (e, bool isSelected) {
                        final textColor = isSelected ? primary : fontColor;
                        final iconColor =
                            isSelected ? primary : Colors.transparent;

                        var name = getName(e) ?? "";
                        name = onItemName?.call(name) ?? name;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.check, color: iconColor),
                            ),
                            Flexible(
                              child: NText(
                                name,
                                color: textColor,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String? getName(E? e) {
    if (e == null) {
      return null;
    }
    return cbName(e);
  }

  TextStyle getNameStyle({String? name}) {
    if (name?.isNotEmpty != true) {
      return const TextStyle(
        fontSize: 15,
        color: fontColorB3B3B3,
        fontWeight: FontWeight.w400,
      );
    }
    return const TextStyle(
      fontSize: 15,
      color: fontColor,
      fontWeight: FontWeight.w400,
    );
  }
}
