//
//  DurationExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/11 20:01.
//  Copyright © 2024/5/11 shang. All rights reserved.
//

extension DurationExt on Duration {
  /// 秒转计时器格式 00:00:00
  String toTime() {
    final duration = this;
    final result = "$duration".split(".").first;
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
    String line = "";
    if (duration.inHours != 0) {
      line = "${_twoDigits(duration.inHours.remainder(24))}:";
    }
    line += "${_twoDigits(duration.inMinutes.remainder(60))}:";
    line += _twoDigits(duration.inSeconds.remainder(60));
    return line;
  }
}
