//
//  AeChooseItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 10:37.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_choice_view.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// AE 多选组件
class AeChooseItem<T> extends StatelessWidget {
  const AeChooseItem({
    super.key,
    this.title,
    required this.dataList,
    required this.selectVN,
    required this.convertCb,
    this.onChanged,
    this.enable = true,
    this.header,
    this.footer,
    this.disableTextColor = fontColor,
    this.disableBgColor,
  });

  /// 选择项标题
  final String? title;

  /// 选择项列表
  final List<T> dataList;

  /// 选择项
  final ValueNotifier<List<T>?> selectVN;

  /// 类型转字符串
  final String Function(T e) convertCb;

  /// 修改回调
  final ValueChanged<List<T>?>? onChanged;

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
        buildBody(context),
        footer ?? const SizedBox(),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final bgColor = enable ? white : disableBgColor ?? bgColorEDEDED;

    return GestureDetector(
      onTap: () => onPicker(context),
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
                  final names =
                      (value ?? []).map((e) => convertCb(e)).join(",");

                  var name = value == null ? '请选择' : names;
                  final color = enable
                      ? (value != null ? fontColor : fontColorB3B3B3)
                      : (disableTextColor ?? fontColorB3B3B3);
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
                color: fontColorB3B3B3,
                // color: primary,
              ),
          ],
        ),
      ),
    );
  }

  void onPicker(BuildContext context) {
    if (!enable) {
      DLog.d("$this 组件已禁用");
      return;
    }
    if (dataList.isEmpty) {
      ToastUtil.show('暂无数据');
      return;
    }
    ToolUtil.removeInputFocus();

    final pickerView = ValueListenableBuilder(
      valueListenable: selectVN,
      builder: (context, value, child) {
        return NPickerChoiceView(
          title: '请选择',
          divider: SizedBox(),
          onConfirm: () {
            onChanged?.call(selectVN.value);
            Navigator.of(context).pop();
          },
          items: dataList,
          itemBuilder: (BuildContext context, idx) {
            final e = dataList[idx];

            final name = convertCb(e);

            final isSame = selectVN.value != null
                ? selectVN.value!.map((e) => convertCb(e)).contains(name)
                : false;
            final textColor = isSame ? Colors.blue : Colors.black87;
            final checkColor = isSame ? Colors.blue : Colors.transparent;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    name,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                  trailing: Icon(Icons.check, color: checkColor),
                  onTap: () {
                    // Navigator.of(context).pop(idx);
                    final list = <T>[...selectVN.value ?? []];
                    if (selectVN.value?.contains(e) != true) {
                      list.add(e);
                    } else {
                      list.remove(e);
                    }
                    selectVN.value = list;
                    // DLog.d(
                    //     "$this selectVN.value${selectVN.value.hashCode}: ${selectVN.value}");
                  },
                ),
                Divider(height: 0.5, indent: 15),
              ],
            );
          },
        );
      },
    );

    pickerView.toShowModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
    );
  }
}
