//
//  NDateStartEnd.dart
//  yl_ylgcp_app
//
//  Created by shang on 2023/12/29 15:16.
//  Copyright © 2023/12/29 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/flutter_picker_util.dart';

/// 日期起止选择器(截止到天)
class NDateStartEnd extends StatefulWidget {
  const NDateStartEnd({
    super.key,
    this.startDate,
    this.endDate,
    this.onStart,
    this.onEnd,
  });

  /// 默认开始值
  final String? Function()? startDate;

  /// 默认结束值
  final String? Function()? endDate;

  /// 开始日期回调
  final void Function(String dateStr)? onStart;

  /// 结束日期回调
  final void Function(String dateStr)? onEnd;

  @override
  State<NDateStartEnd> createState() => _NDateStartEndState();
}

class _NDateStartEndState extends State<NDateStartEnd> {
  late final now = DateTime.now();

  late String? startDate = widget.startDate?.call();
  late String? endDate = widget.endDate?.call();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onPickStart,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF3F3F3),
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: NText(
                startDate == null
                    ? "开始时间"
                    : (startDate ?? "").split(" ").firstOrNull ?? "",
                color: startDate == null ? fontColorB3B3B3 : fontColor737373,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: NText(
            "－",
            color: fontColor999999,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onPickEnd,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF3F3F3),
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: NText(
                endDate == null
                    ? "结束时间"
                    : (endDate ?? "").split(" ").firstOrNull ?? "",
                color: endDate == null ? fontColorB3B3B3 : fontColor737373,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onPickStart() {
    pickerDate(
      selectDateStr: startDate,
      onConfirm: (date) {
        startDate = DateTimeExt.stringFromDate(
          date: date,
          format: DATE_FORMAT_DAY_START,
        );
        widget.onStart?.call(startDate ?? "");
        setState(() {});
      },
    );
  }

  void onPickEnd() {
    final bDate = startDate == null
        ? null
        : DateTimeExt.dateFromString(dateStr: startDate!);
    pickerDate(
      minDateTime: bDate,
      selectDateStr: endDate,
      onConfirm: (date) {
        endDate = DateTimeExt.stringFromDate(
          date: date,
          format: DATE_FORMAT_DAY_END,
        );
        widget.onEnd?.call(endDate ?? "");
        setState(() {});
      },
    );
  }

  pickerDate({
    DateTime? minDateTime,
    String? selectDateStr,
    required ValueChanged<DateTime> onConfirm,
  }) async {
    final minDateTimeNew =
        minDateTime == null ? null : PDuration.parse(minDateTime);
    final selectDate = selectDateStr == null
        ? null
        : DateTimeExt.dateFromString(dateStr: selectDateStr);
    FlutterPickerUtil.showDatePicker(
      title: '日期选择',
      selectDate: selectDate == null ? null : PDuration.parse(selectDate),
      minDateTime: minDateTimeNew,
      maxDateTime: PDuration.now(),
      confirm: (PDuration pDate, String date) {
        // debugPrint('日期选择：$date');
        onConfirm(pDate.toDate());
      },
    );
  }
}
