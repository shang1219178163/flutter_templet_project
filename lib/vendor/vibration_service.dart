import 'package:flutter/cupertino.dart';
import 'package:vibration/vibration.dart';

/// 震动
class VibrationService {
  /// 震动
  static Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
  }) async {
    try {
      Vibration.vibrate(amplitude: 128, duration: 100);

      // final hasVibrator = await Vibration.hasVibrator();
      // if (hasVibrator != true) {
      //   return;
      // }

      // final hasCustomVibrationsSupport = await Vibration.hasCustomVibrationsSupport();
      // if (hasCustomVibrationsSupport == true) {
      //   Vibration.vibrate(
      //     duration: duration,
      //     pattern: pattern,
      //     repeat: repeat,
      //     intensities: intensities,
      //     amplitude: amplitude,
      //   );
      // } else {
      //   Vibration.vibrate(duration: duration,);
      // }
    } catch (e) {
      debugPrint("VibrationService: $e");
    }
  }
}
