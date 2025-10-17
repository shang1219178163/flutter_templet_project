//
//  AeDateChooseItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 10:37.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';

/// AE 日期选择组件
class AeDateChooseItem extends StatelessWidget {
  const AeDateChooseItem({
    super.key,
    this.title,
    this.mode = DateMode.YMD,
    this.minDateTime,
    this.maxDateTime,
    required this.selectVN,
    this.convertCb,
    this.onChanged,
    this.header,
    this.footer,
    this.enable = true,
    this.disableBgColor,
    this.disableTextColor,
    this.rightIconPath,
  });

  /// 选择项标题
  final String? title;

  final DateMode mode;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  // final DateTime? selectDate;

  /// 选择项
  final ValueNotifier<DateTime?> selectVN;

  /// 类型转字符串
  final String Function(DateTime e)? convertCb;

  /// 修改回调
  final ValueChanged<DateTime>? onChanged;

  /// 组件头
  final Widget? header;

  /// 组件尾
  final Widget? footer;

  /// 是否禁用
  final bool enable;

  /// 禁用背景色
  final Color? disableBgColor;

  /// 禁用文字颜色
  final Color? disableTextColor;

  final String? rightIconPath;

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
    var endIndex = 19;
    if (mode == DateMode.YMD) {
      endIndex = 10;
    } else if (mode == DateMode.YMDHM) {
      endIndex = 16;
    }
    convert(DateTime e) => e.toString().substring(0, endIndex);

    return GestureDetector(
      onTap: onPickerDate,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 36),
        // margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: enable ? AppColor.white : disableBgColor ?? AppColor.bgColorEDEDED,
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
                  var name = value == null ? '请选择' : convertCb?.call(value) ?? convert(value);
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
                image: (rightIconPath ??
                        'assets/images/icon_date_calender'
                            '.png')
                    .toAssetImage(),
                width: 16,
                height: 16,
                // color: primary,
              ),
          ],
        ),
      ),
    );
  }

  void onPickerDate() {
    if (!enable) {
      DLog.d("$this 组件已禁用");
      return;
    }
    ToolUtil.removeInputFocus();
    FlutterPickerUtil.showDatePickerNew(
      title: '请选择${title ?? ""}',
      mode: mode,
      selectDate: selectVN.value,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      onConfirm: (DateTime dateTime) {
        selectVN.value = dateTime;
        onChanged?.call(dateTime);
        DLog.d("$this ${title ?? ""} $dateTime");
      },
    );
  }
}
