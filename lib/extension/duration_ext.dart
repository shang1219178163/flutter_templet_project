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

extension DurationExt on Duration {
  int get inDaysRest => inDays;
  int get inHoursRest => inHours - (inDays * 24);
  int get inMinutesRest => inMinutes - (inHours * 60);
  int get inSecondsRest => inSeconds - (inMinutes * 60);
  int get inMillisecondsRest => inMilliseconds - (inSeconds * 1000);
  int get inMicrosecondsRest => inMicroseconds - (inMilliseconds * 1000);

  /// 秒转计时器格式 00:00:00
  String toTime() {
    final duration = this;
    final result = "$duration".split(".").first;
    return result;
  }

  /// 天
  String formatedString() {
    final hh = '${inHours % 24}'.padLeft(2, '0');
    final mm = '${inMinutes % 60}'.padLeft(2, '0');
    final ss = '${inSeconds % 60}'.padLeft(2, '0');
    var hms = '$hh:$mm:$ss';
    final result = inDays > 0 ? '$inDays天$hms' : hms;
    return result;
  }

  /// 转为 00:00:00
  String toTimeNew() {
    String _twoDigits(int n) {
      if (n >= 10) {
        return "$n";
      }
      return "0$n";
    }

    Duration duration = this;
    final prefix = duration.isNegative ? "-" : "";
    final durationNew = duration.abs();

    String line = "";
    if (duration.inHours != 0) {
      line = "$prefix${durationNew.inHours}天";
      line += "${_twoDigits(durationNew.inHours.remainder(24))}:";
    }
    line += "${_twoDigits(durationNew.inMinutes.remainder(60))}:";
    line += _twoDigits(durationNew.inSeconds.remainder(60));
    return line;
  }
}
