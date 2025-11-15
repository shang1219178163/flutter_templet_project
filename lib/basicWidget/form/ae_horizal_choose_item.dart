//
//  AeHorizalChooseItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 10:37.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

/// AE 横向多选组件
class AeHorizalChooseItem extends StatelessWidget {
  const AeHorizalChooseItem({
    super.key,
    this.title,
    required this.dataList,
    required this.selectVN,
    this.onChanged,
    this.enable = true,
    this.header,
    this.footer,
    this.disableTextColor = AppColor.fontColor,
    this.disableBgColor,
  });

  /// 选择项标题
  final String? title;

  /// 选择项列表
  final List<List<String>> dataList;

  /// 选择项
  final ValueNotifier<List<String>?> selectVN;

  /// 修改回调
  final ValueChanged<List<String>>? onChanged;

  /// 组件头
  final Widget? header;

  /// 组件尾
  final Widget? footer;

  /// 是否禁用
  final bool enable;

  /// 禁用文字颜色
  final Color? disableTextColor;
  final Color? disableBgColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header ?? const SizedBox(),
        if (header != null) const SizedBox(height: 5),
        buildBody(),
        footer ?? const SizedBox(),
      ],
    );
  }

  Widget buildBody() {
    final bgColor = enable ? AppColor.white : disableBgColor ?? AppColor.bgColorEDEDED;

    return GestureDetector(
      onTap: onPicker,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 36),
        // margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: bgColor,
          border: Border.all(color: const Color(0xFFE6E6E6), width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 16,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: selectVN,
                builder: (context, value, child) {
                  var name = value?.isNotEmpty != true ? '请选择' : value?.join("");
                  final color = enable
                      ? (value != null ? AppColor.fontColor : AppColor.fontColorB3B3B3)
                      : (disableTextColor ?? AppColor.fontColorB3B3B3);
                  if (value == null && !enable) {
                    name = "--";
                  }
                  return NText(
                    name ?? "",
                    fontSize: 14,
                    color: color,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            if (enable)
              Image(
                image: 'assets/images/icon_arrow_down.png'.toAssetImage(),
                width: 12,
                height: 12,
                color: AppColor.fontColorB3B3B3,
                // color: primary,
              ),
          ],
        ),
      ),
    );
  }

  void onPicker() {
    if (!enable) {
      DLog.d("$this 组件已禁用");
      return;
    }
    if (dataList.isEmpty) {
      ToastUtil.show('暂无数据');
      return;
    }
    ToolUtil.removeInputFocus();

    FlutterPickerUtil.showMultiPicker(
      dataList: dataList,
      selectData: (selectVN.value ?? []),
      confirm: (List value, List<int> indexs) {
        // DLog.d("value: $value, indexs: $indexs");
        final val = value.map((e) => e.toString()).toList();
        selectVN.value = val;
        onChanged?.call(val);
      },
    );
  }
}
