//
//  DurationExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/11 20:01.
//  Copyright © 2024/5/11 shang. All rights reserved.
//

// const duration = Duration(seconds: 123);
// print('Days: ${duration.inDaysRest}'); // 0
// print('Hours: ${duration.inHoursRest}'); // 0
// print('Minutes: ${duration.inMinutesRest}'); // 2
// print('Seconds: ${duration.inSecondsRest}'); // 3
// print('Milliseconds: ${duration.inMillisecondsRest}'); // 0
// print('Microseconds: ${duration.inMicrosecondsRest}'); // 0

/// Duration 字符串格式化枚举类型
enum DurationFormatEnum {
  HMMSS("H:MM:SS"),
  HHMMSS("HH:MM:SS"),
  MMSS("MM:SS"),
  ;

  const DurationFormatEnum(this.value);

  final String value;
}

extension DurationExt on Duration {
  int get inDaysRest => inDays;
  int get inHoursRest => inHours - (inDays * 24);
  int get inMinutesRest => inMinutes - (inHours * 60);
  int get inSecondsRest => inSeconds - (inMinutes * 60);
  int get inMillisecondsRest => inMilliseconds - (inSeconds * 1000);
  int get inMicrosecondsRest => inMicroseconds - (inMilliseconds * 1000);

  /// 格式化显示
  String toStringFormat({DurationFormatEnum format = DurationFormatEnum.HMMSS}) {
    var microseconds = inMicroseconds;
    var sign = "";
    var negative = microseconds < 0;

    var hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    // Correcting for being negative after first division, instead of before,
    // to avoid negating min-int, -(2^31-1), of a native int64.
    if (negative) {
      hours = 0 - hours; // Not using `-hours` to avoid creating -0.0 on web.
      microseconds = 0 - microseconds;
      sign = "-";
    }

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? "0" : "";

    var result = "";
    switch (format) {
      case DurationFormatEnum.HHMMSS:
        {
          var hoursPadding = hours < 10 ? "0" : "";
          if (hoursPadding == "0") {
            hoursPadding = "00";
          }
          result = "$sign$hoursPadding:"
              "$minutesPadding$minutes:"
              "$secondsPadding$seconds";
        }
        break;
      case DurationFormatEnum.MMSS:
        {
          result = "$sign"
              "$minutesPadding$minutes:"
              "$secondsPadding$seconds";
        }
        break;
      default:
        {
          result = "$sign$hours:"
              "$minutesPadding$minutes:"
              "$secondsPadding$seconds";
        }
        break;
    }
    return result;
  }

  /// 含天
  @Deprecated("已弃用,请使用 toStringFormatted")
  String formatedString() {
    final prefix = isNegative ? "-" : "";
    final day = inDays > 0 ? '$inDays天' : "";
    final hh = '${inHours % 24}'.padLeft(2, '0');
    final mm = '${inMinutes % 60}'.padLeft(2, '0');
    final ss = '${inSeconds % 60}'.padLeft(2, '0');
    var hms = '$hh:$mm:$ss';
    var result = '$prefix$day$hms';
    return result;
  }

  /// 转为 00:00:00
  @Deprecated("已弃用,请使用 toStringFormatted")
  String toTimeNew() {
    String _twoDigits(int n) {
      if (n >= 10) {
        return "$n";
      }
      return "0$n";
    }

    var duration = this;
    final prefix = duration.isNegative ? "-" : "";
    final durationNew = duration.abs();

    var line = prefix;
    if (duration.inDays != 0) {
      line += "${durationNew.inDays}天";
    }
    if (duration.inHours != 0) {
      line += "${_twoDigits(durationNew.inHours.remainder(24))}:";
    }
    line += "${_twoDigits(durationNew.inMinutes.remainder(60))}:";
    line += _twoDigits(durationNew.inSeconds.remainder(60));
    return line;
  }
}
