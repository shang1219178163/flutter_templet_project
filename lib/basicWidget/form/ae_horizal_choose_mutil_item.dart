//
//  AeHorizalChooseMutilItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 10:37.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/app_service.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

/// AE 同类型数据横向多选组件
class AeHorizalChooseMutilItem<T> extends StatelessWidget {
  const AeHorizalChooseMutilItem({
    super.key,
    this.title,
    required this.dataList,
    required this.selectVN,
    required this.convertCb,
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
  final List<List<T>> dataList;

  /// 选择项
  final ValueNotifier<List<T>?> selectVN;

  /// 类型转字符串
  final List<String> Function(List<T> e) convertCb;

  /// 修改回调
  final ValueChanged<List<T>>? onChanged;

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
                  var name = value == null ? '请选择' : convertCb(value).join(" ");
                  final color = enable
                      ? (value != null ? AppColor.fontColor : AppColor.fontColorB3B3B3)
                      : (disableTextColor ?? AppColor.fontColorB3B3B3);
                  if (value == null && !enable) {
                    name = "--";
                  }
                  return NText(
                    name,
                    fontSize: 14,
                    color: color,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            if (enable)
              Image(
                image: AssetImage(Assets.imagesIconArrowDown),
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
    AppService.unfocus();

    FlutterPickerUtil.showMultiPicker(
      dataList: dataList.map((e1) => convertCb(e1)).toList(),
      // selectData: (selectVN.value ?? []).map((e) => convertCb(e)).toList(),
      selectData: (selectVN.value ?? []).map((e) => convertCb(e as List<T>)).toList(),
      confirm: (value, indexs) {
        DLog.d("value: $value");
        DLog.d("indexs: $indexs");
        // final val = value
        // final current = dataList[index];
        // selectVN.value = current;
        // onChanged?.call(current);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(IterableProperty<List<T>>('dataList', dataList));
    properties.add(DiagnosticsProperty<ValueNotifier<List<T>?>>('selectVN', selectVN));
    properties.add(ObjectFlagProperty<List<String> Function(List<T> e)>.has('convertCb', convertCb));
    properties.add(ObjectFlagProperty<ValueChanged<List<T>>?>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<bool>('enable', enable));
    properties.add(ColorProperty('disableTextColor', disableTextColor));
    properties.add(ColorProperty('disableBgColor', disableBgColor));
  }
}
