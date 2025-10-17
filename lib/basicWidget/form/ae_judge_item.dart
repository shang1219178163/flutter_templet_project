//
//  AeJudgeItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 10:37.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box_one.dart';
import 'package:flutter_templet_project/basicWidget/n_indicator_point.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:flutter_templet_project/util/app_color.dart';

/// AE 判断组件
class AeJudgeItem extends StatelessWidget {
  const AeJudgeItem({
    super.key,
    this.title,
    this.keyName,
    required this.isYes,
    this.onChanged,
    this.numPerRow = 4,
    this.itemPadding,
    this.enable = true,
    this.header,
    this.footer,
  });

  /// 选择项标题
  final String? title;

  final String? keyName;

  /// 每列数
  final int numPerRow;

  final EdgeInsets? itemPadding;

  final ValueNotifier<bool?> isYes;

  /// 修改回调
  // final ValueChanged<T>? onChanged;
  final void Function(String? keyName, bool value)? onChanged;

  /// 是否禁用
  final bool enable;

  /// 组件头
  final Widget? header;

  /// 组件尾
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header ?? const SizedBox(),
        if (header != null) const SizedBox(height: 5),
        buildBody(context),
        footer ?? const SizedBox(),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final dataList = <ChooseItemRecord<bool>>[
      (title: '是', key: "", value: true),
      (title: '否', key: "", value: false),
    ];

    var selectVN = ValueNotifier<ChooseItemRecord<bool>?>(null);
    if (isYes.value != null) {
      final result = isYes.value == true ? dataList.first : dataList.last;
      selectVN = ValueNotifier<ChooseItemRecord<bool>>(result);
    }

    // if (!enable) {
    //   return buildDisableItem(title: selectVN.value?.title ?? "");
    // }

    return NChoiceBoxOne<ChooseItemRecord<bool>>(
      enable: enable,
      items: dataList,
      selectedItem: selectVN,
      itemNameCb: (e) => e.title,
      primaryColor: context.primaryColor,
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      numPerRow: numPerRow,
      itemPadding: itemPadding,
      style: const TextStyle(
        color: AppColor.fontColorB3B3B3,
        fontSize: 14,
      ),
      styleSelected: TextStyle(
        color: context.primaryColor,
        fontSize: 14,
      ),
      canChanged: (val, onSelect) {
        final result = (selectVN.value != val);
        // YLog.d("canChanged: $result");
        return result;
      },
      onChanged: (e) {
        isYes.value = e.value;
        // YLog.d("${hashCode} onChanged keyName: $keyName");
        onChanged?.call(keyName, e.value);
      },
    );
  }

  Widget buildDisableItem({required String title}) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: NIndicatorCircle(
              isSelected: true,
              colorSelected: AppColor.fontColorB3B3B3,
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.fontColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
