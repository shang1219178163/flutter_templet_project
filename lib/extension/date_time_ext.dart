//
//  date_time_ext.dart
//  flutter_templet_project
//
//  Created by shang on 9/21/21 7:10 PM.
//  Copyright © 9/21/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// yyyyMMddHHmmss
const String DATE_FORMAT_INT = 'yyyyMMddHHmmss';

/// yyyy-dd-MM HH:mm:ss
const String DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss';

/// yyyy-dd-MM
const String DATE_FORMAT_DAY = 'yyyy-MM-dd';

/// yyyy-dd-MM 00:00:00
const String DATE_FORMAT_DAY_START = 'yyyy-MM-dd 00:00:00';

/// yyyy-dd-MM 23:59:59
const String DATE_FORMAT_DAY_END = 'yyyy-MM-dd 23:59:59';

/// HH:mm:
const String DATE_FORMAT_H_M = 'HH:mm';

/// HH:mm:ss
const String DATE_FORMAT_H_M_S = 'HH:mm:ss';

extension DateTimeExt on DateTime {
  /// 时间戳(秒)
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  /// yyyy-MM-dd 00:00:00
  DateTime get dayStart {
    return DateTime(year, month, day, 0, 0, 0);
  }

  /// yyyy-MM-dd 23:59:59
  DateTime get dayEnd {
    return DateTime(year, month, day, 23, 59, 59);
  }

  /// 时间戳 转 DateTime
  static DateTime? dateFromTimestamp({
    required int? timestamp,
    bool isUtc = false,
  }) {
    if (timestamp == null) {
      return null;
    }
    var isMilliseconds = ("$timestamp".length == 13);
    var timeSampNew = isMilliseconds ? timestamp : timestamp * 1000;
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeSampNew);
    if (isUtc) {
      return dateTime.toUtc();
    }
    return dateTime;
  }

  /// 字符串 转 时间戳(秒)
  static int? timestampFromDateStr({
    required String? dateStr,
    String format = DATE_FORMAT,
    bool isUtc = false,
  }) {
    final date = dateFromString(dateStr: dateStr, format: format, isUtc: isUtc);
    var result = date?.secondsSinceEpoch;
    return result;
  }

  /// DateTime 转 字符串
  static String? stringFromDate({
    required DateTime? date,
    String format = DATE_FORMAT,
  }) {
    try {
      if (date == null) {
        return null;
      }

      final dataFormat = DateFormat(format);
      var result = dataFormat.format(date);
      return result;
    } catch (e) {
      debugPrint("❌stringFromDate $e");
    }
    return null;
  }

  /// 字符串 转 DateTime
  static DateTime? dateFromString({
    required String? dateStr,
    String format = DATE_FORMAT,
    bool isUtc = false,
  }) {
    try {
      if (dateStr?.isNotEmpty != true) {
        return null;
      }
      var dateFormat = DateFormat(format);
      var dateTime = dateFormat.parse(dateStr!);
      if (isUtc) {
        return dateTime.toUtc();
      }
      return dateTime;
    } catch (e) {
      debugPrint("dateFromString $e");
    }
    return null;
  }

  /// 时间戳 转 字符串
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static String? stringFromTimestamp({
    required int? timestamp,
    String format = DATE_FORMAT,
    bool isUtc = false,
  }) {
    if (timestamp == null) {
      return null;
    }

    var dateTime =
        DateTimeExt.dateFromTimestamp(timestamp: timestamp, isUtc: isUtc);
    var result = stringFromDate(date: dateTime, format: format);
    return result;
  }

  bool isSameDay(DateTime? date) {
    if (date == null) {
      return false;
    }
    final result = year == date.year && month == date.month && day == date.day;
    return result;
  }

  String toString19() => toString().split(".").first;

  DateTime offsetDay({required int count}) {
    final timstamp =
        DateTime.now().millisecondsSinceEpoch + count * 24 * 60 * 60 * 1000;
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timstamp);
    return dateTime;
  }

  /// 当前月份第一天
  DateTime monthFisrtDay() {
    var result = DateTime(year, month, 1);
    return result;
  }

  ///获取当前月的第一天
  String monthFisrtDayStr({String format = DATE_FORMAT}) {
    var dateTime = monthFisrtDay();
    var result = DateTimeExt.stringFromDate(date: dateTime, format: format);
    return result ?? "";
  }

  ///获取当前月的最后一天。
  DateTime monthLastDay() {
    var nextMonthFist = DateTime(year, month + 1, 1);
    var timeSamp = nextMonthFist.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
    //取得了下一个月1号码时间戳
    var result = DateTime.fromMillisecondsSinceEpoch(timeSamp);
    return result;
  }

  ///获取当前月的最后一天。
  String monthLastDayStr({
    String format = DATE_FORMAT,
  }) {
    var dateTime = monthLastDay();
    var result = DateTimeExt.stringFromDate(date: dateTime, format: format);
    return result ?? "";
  }

  ///获取当前日历月份的第一天
  String calenderMonthPageFisrtDayStr({String format = DATE_FORMAT}) {
    var dateTime = this;
    if (dateTime.weekday != 7) {
      final monthFisrtDay = DateTime(year, month, 1);
      final timestamp = monthFisrtDay.millisecondsSinceEpoch -
          monthFisrtDay.weekday * 24 * 60 * 60 * 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    var result = DateTimeExt.stringFromDate(date: dateTime, format: format);
    return result ?? "";
  }

  ///获取当前日历月份页的最后一天
  String calenderMonthPageLastDayStr({
    String format = DATE_FORMAT,
  }) {
    final day = monthLastDay();

    var dateTime = day;
    if (day.weekday == 7) {
      final timestamp =
          day.millisecondsSinceEpoch + (7 - 1) * 24 * 60 * 60 * 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      final timestamp =
          day.millisecondsSinceEpoch + (6 - day.weekday) * 24 * 60 * 60 * 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    var result = DateTimeExt.stringFromDate(date: dateTime, format: format);
    return result ?? "";
  }

  // void describe() {
  //   var now = DateTime.now();
  //   var diff = this.difference(DateTime(now.year, now.month, now.day));
  //   var result = switch (diff) {
  //     Duration(inDays: -1 ) => '昨天',
  //     Duration(inDays: 0 ) => '今天',
  //     Duration(inDays: 1 ) => '明天',
  //     Duration(inDays: int d) => d < 0 ? '${d.abs()} 天前' : '$d 天后',
  //   };
  //   debugPrint("$year/$month/$day 是 $result");
  // }
}

extension DateTimeIntExt on int {
  /// 转为秒时间戳
  int toTimeStamp() {
    var value = this;
    if (value < 0) {
      return 0;
    }

    if ("$value".length == 13) {
      value = value ~/ 1000;
      return value.toInt();
    }

    return value;
  }
}
