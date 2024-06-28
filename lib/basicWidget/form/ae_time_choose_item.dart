//
//  AeDateChooseItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 10:37.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_templet_project/basicWidget/form/ae_date_choose_item.dart';

/// AE 日期时间选择组件
class AeTimeChooseItem extends StatelessWidget {
  const AeTimeChooseItem({
    super.key,
    this.title,
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
  });

  /// 选择项标题
  final String? title;

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

  @override
  Widget build(BuildContext context) {
    return AeDateChooseItem(
      title: title,
      mode: DateMode.YMDHM,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      selectVN: selectVN,
      convertCb: convertCb,
      onChanged: onChanged,
      header: header,
      footer: footer,
      enable: enable,
      disableBgColor: disableBgColor,
      disableTextColor: disableTextColor,
      rightIconPath: "assets/images/icon_time_long_one.png",
    );
  }
}
