import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/locations_data.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

// 地址选择器模型
class AddressPickerModel {
  AddressPickerModel({
    this.province,
    this.provinceCode,
    this.city,
    this.cityCode,
    this.town,
    this.townCode,
  });

  String? province;
  String? provinceCode;
  String? city;
  String? cityCode;
  String? town;
  String? townCode;

  /// 描述
  String? get desc {
    final result = [
      province,
      city,
      town,
    ].where((e) => e != null).join("");
    return result;
  }

  AddressPickerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    province = json['province'];
    provinceCode = json['provinceCode'];
    city = json['city'];
    cityCode = json['cityCode'];
    town = json['town'];
    townCode = json['townCode'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['province'] = province;
    data['provinceCode'] = provinceCode;
    data['city'] = city;
    data['cityCode'] = cityCode;
    data['town'] = town;
    data['townCode'] = townCode;
    return data;
  }

  @override
  String toString() {
    return "$runtimeType: ${toJson()}";
  }
}

/// 第三方 flutter_pickers 功能封装
class FlutterPickerUtil {
  // 日期选择器
  static void showDatePicker({
    String title = '',
    DateMode mode = DateMode.YMD,
    PDuration? minDateTime,
    PDuration? maxDateTime,
    PDuration? selectDate,
    required Function(PDuration, String) confirm,
  }) {
    Pickers.showDatePicker(
      Get.context!,
      mode: mode,
      minDate: minDateTime,
      maxDate: maxDateTime,
      selectDate: selectDate,
      pickerStyle: getPickerStyle(title),
      onConfirm: (pDate) {
        final dateTime = DateTime(pDate.year!, pDate.month!, pDate.day!);
        final date = DateTimeExt.stringFromDate(date: dateTime, format: 'Y-D');
        confirm(pDate, date!);
      },
    );
  }

  // 日期选择器(以 DateTime 传值)
  static void showDatePickerNew({
    String title = '请选择',
    DateMode mode = DateMode.YMD,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    DateTime? selectDate,
    required ValueChanged<DateTime> onConfirm,
  }) {
    showDatePicker(
      title: title,
      mode: mode,
      minDateTime: minDateTime?.toPDuration(),
      maxDateTime: maxDateTime?.toPDuration(),
      selectDate: selectDate?.toPDuration(),
      confirm: (pDate, dateStr) {
        final now = DateTime.now();
        final pDateNew = PDuration(
          year: pDate.year,
          month: pDate.month,
          day: pDate.day,
          hour: pDate.hour ?? now.hour,
          minute: pDate.minute ?? now.minute,
          second: pDate.second ?? now.second,
        );
        onConfirm(pDateNew.toDate());
      },
    );
  }

  // 单项选择器
  static void showSinglePicker({
    String title = '请选择',
    String selectData = '',
    required dynamic dataList,
    ValueChanged<bool>? onCancel,
    required Function(dynamic data, int position) confirm,
  }) {
    Pickers.showSinglePicker(
      Get.context!,
      data: dataList,
      selectData: selectData,
      pickerStyle: getPickerStyle(title),
      onCancel: onCancel,
      onConfirm: confirm,
    );
  }

  // 多项选择器
  static void showMultiPicker({
    String title = '请选择',
    List selectData = const [],
    required List<List<dynamic>> dataList,
    List suffixList = const ['', ''],
    required Function(List res, List<int> p) confirm,
  }) {
    Pickers.showMultiPicker(
      Get.context!,
      data: dataList,
      pickerStyle: getPickerStyle(title),
      selectData: selectData,
      suffix: suffixList,
      onConfirm: confirm,
    );
  }

  /// 地址选择器
  ///
  /// initTown 为 null 时, 仅显示省市
  static void showAddressPicker({
    String title = '',
    String? initProvince,
    String? initCity,
    String? initTown,
    required ValueChanged<AddressPickerModel> confirm,
  }) {
    Pickers.showAddressPicker(
      Get.context!,
      initProvince: initProvince ?? '',
      initCity: initCity ?? '',
      initTown: initTown,
      addAllItem: false,
      pickerStyle: getPickerStyle(title),
      onConfirm: (province, city, town) {
        if (initProvince == province && initCity == city && initTown == town) {
          return;
        }
        var c1 = city;
        var t1 = town ?? '';
        var codes = Address.getCityCodeByName(
          provinceName: province,
          cityName: city,
          townName: town,
        );
        var cCode = codes[1];
        var tCode = '';
        if (codes.length > 2) {
          tCode = codes[2];
        } else {
          tCode = '';
        }
        if (codes[0] == '820000' || codes[0] == '810000') {
          c1 = province;
          t1 = city;
          cCode = (int.parse(codes[0]) + 100).toString();
          tCode = (int.parse(codes[1]) + 100).toString();
          if (initProvince == province && initCity == t1 && initTown == t1) {
            return;
          }
        }
        final addressModel = AddressPickerModel(
          province: province,
          city: c1,
          town: t1,
          provinceCode: codes[0],
          cityCode: cCode,
          townCode: tCode,
        );
        confirm(addressModel);
      },
    );
  }

  // Pickers - PickerStyle
  static PickerStyle getPickerStyle(String title) {
    return PickerStyle(
      headDecoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: AppColor.white,
      ),
      itemOverlay: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 0.5, color: AppColor.lineColor),
          Expanded(child: Container()),
          const Divider(height: 0.5, color: AppColor.lineColor),
        ],
      ),
      cancelButton: buildTextButton(title: "取消"),
      commitButton: buildTextButton(
        title: '确定',
        textColor: Get.context?.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      pickerTitleHeight: 54,
      pickerItemHeight: 54,
      pickerHeight: 289,
      textSize: 16,
    );
  }

  static Widget buildTextButton({
    required String title,
    Color? textColor = AppColor.fontColor737373,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

extension PDurationExt on PDuration {
  /// 转为 DateTime
  DateTime toDate() {
    final date = DateTime(
      year ?? 0,
      month ?? 0,
      day ?? 0,
      hour ?? 0,
      minute ?? 0,
      second ?? 0,
    );
    return date;
  }

  /// copyWith 覆盖当前值
  PDuration copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) {
    return PDuration(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }
}

extension DateTimePickerExt on DateTime {
  /// 转 PDuration
  PDuration toPDuration() {
    return PDuration.parse(this);
  }
}
