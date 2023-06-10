//
//  date_time_ext.dart
//  flutter_templet_project
//
//  Created by shang on 9/21/21 7:10 PM.
//  Copyright © 9/21/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// yyyy-dd-MM HH:mm:ss
const String DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss';
/// yyyy-dd-MM
const String DATE_FORMAT_DAY = 'yyyy-MM-dd';
/// yyyy-dd-MM 00:00:00
const String DATE_FORMAT_DAY_START = 'yyyy-MM-dd 00:00:00';
/// yyyy-dd-MM 23:59:59
const String DATE_FORMAT_DAY_END = 'yyyy-MM-dd 23:59:59';


const String DATE_FORMAT_H_M = 'HH:mm';


extension DateTimeExt on DateTime {
  /// 打印代码执行时间
  static double logDifference(DateTime before) {
    final now = DateTime.now();
    final gap = now.difference(before).inMilliseconds;
    final seconds = gap / 1000;
    return seconds;
  }

  bool isSameDay(DateTime? date){
    if (date == null) {
      return false;
    }
    final result = year == date.year
        && month == date.month
        && day == date.day;
    return result;
  }

  String toString19() => toString().split(".").first;


  /// 时间戳 转 DateTime
  static DateTime dateFromTimestamp({required int timeSamp, bool isMilliseconds = true}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeSamp);
    if (!isMilliseconds) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timeSamp*1000);
    }
    return dateTime;
  }

  /// DateTime 转 时间戳
  static int timestampFromDate({required DateTime date, bool isMilliseconds = true}) {
    var result = date.millisecondsSinceEpoch;
    if (!isMilliseconds) {
      result = result~/1000;
    }
    return result;
  }


  /// 字符串 转 DateTime
  static DateTime dateFromString({
    required String dateStr,
    String format = DATE_FORMAT,
    bool isUtc = false
  }) {
    var dateFormat = DateFormat(format);
    var dateTime = dateFormat.parse(dateStr);
    if (isUtc) {
      var timezoneOffset = dateTime.timeZoneOffset.inHours;
      dateTime = dateTime.add(Duration(hours: timezoneOffset));
    }
    return dateTime;
  }

  /// DateTime 转 字符串
  static String stringFromDate({required DateTime dateTime, String format = DATE_FORMAT, }) {
    final dataFormat = DateFormat(format);
    var result = dataFormat.format(dateTime);
    return result;
  }

  /// 时间戳 转 字符串
  ///timeSamp:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static String stringFromTimestamp({required int timeSamp, String format = DATE_FORMAT, bool isMilliseconds = true}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeSamp);
    if (!isMilliseconds) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timeSamp*1000);
    }

    var result = stringFromDate(dateTime: dateTime, format: format);
    return result;
  }

  /// 字符串 转 时间戳
  static int timestampFromDateStr({
    required String dateStr,
    String format = DATE_FORMAT,
    bool isUtc = false,
    bool isMilliseconds = true,
  }) {
    final date = dateFromString(dateStr: dateStr, format: format, isUtc: isUtc);
    var result = date.millisecondsSinceEpoch;
    if (!isMilliseconds) {
      result = result~/1000;
    }
    return result;
  }

  /// 当前月份第一天
  DateTime monthFisrtDay() {
    var result = DateTime(year, month, 1);
    return result;
  }

  ///获取当前月的第一天
  String monthFisrtDayStr({String format = DATE_FORMAT}) {
    var dateTime = monthFisrtDay();

    var result = DateTimeExt.stringFromDate(dateTime: dateTime, format: format);
    return result;
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
  String monthLastDayStr({String format = DATE_FORMAT,}) {
    var dateTime = monthLastDay();

    var result = DateTimeExt.stringFromDate(dateTime: dateTime, format: format);
    return result;
  }

  ///获取当前日历月份的第一天
  String calenderMonthPageFisrtDayStr({String format = DATE_FORMAT}) {
    var dateTime = this;
    if (dateTime.weekday != 7) {
      final monthFisrtDay = DateTime(year, month, 1);
      final timestamp = monthFisrtDay.millisecondsSinceEpoch - monthFisrtDay.weekday * 24 * 60 * 60 * 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    var result = DateTimeExt.stringFromDate(dateTime: dateTime, format: format);
    return result;
  }

  ///获取当前日历月份页的最后一天
  String calenderMonthPageLastDayStr({String format = DATE_FORMAT,}) {
    final day = monthLastDay();

    var dateTime = day;
    if (day.weekday == 7) {
      final timestamp = day.millisecondsSinceEpoch +  (7 - 1) * 24 * 60 * 60 * 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      final timestamp = day.millisecondsSinceEpoch +  (6 - day.weekday) * 24 * 60 * 60 * 1000;
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    var result = DateTimeExt.stringFromDate(dateTime: dateTime, format: format);
    return result;
  }
}


// const duration = Duration(seconds: 123);
// print('Days: ${duration.inDaysRest}'); // 0
// print('Hours: ${duration.inHoursRest}'); // 0
// print('Minutes: ${duration.inMinutesRest}'); // 2
// print('Seconds: ${duration.inSecondsRest}'); // 3
// print('Milliseconds: ${duration.inMillisecondsRest}'); // 0
// print('Microseconds: ${duration.inMicrosecondsRest}'); // 0

extension DurationExt on Duration {
  int get inDaysRest => inDays;
  int get inHoursRest => inHours - (inDays * 24);
  int get inMinutesRest => inMinutes - (inHours * 60);
  int get inSecondsRest => inSeconds - (inMinutes * 60);
  int get inMillisecondsRest => inMilliseconds - (inSeconds * 1000);
  int get inMicrosecondsRest => inMicroseconds - (inMilliseconds * 1000);
}


// String _formatTime(String dateTimeStr)
//   DateTime dateTime = DateTime.parse(dateTimeStr);
//   return DateFormat("MM-dd HH:mm").format(dateTime);
// }