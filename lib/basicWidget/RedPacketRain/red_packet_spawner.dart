import 'dart:math';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_model.dart';

abstract class RedPacketSpawner {
  RedPacketModel spawn();
}

/// 微信风格：中间多、两边少
class WeChatRedPacketSpawner implements RedPacketSpawner {
  final Random _random = Random();

  @override
  RedPacketModel spawn() {
    var size = 36 + _random.nextDouble() * 18;
    var bias = (_random.nextDouble() - 0.5) * 0.6;
    var x = (0.5 + bias).clamp(0.05, 0.95);
    var milliseconds = 5600 + _random.nextInt(1400);

    size = 55;
    // milliseconds = 5600;

    return RedPacketModel(
      x: x,
      size: 55,
      duration: Duration(
        milliseconds: milliseconds,
      ),
      startY: -size - _random.nextDouble() * 40, // ⭐ 屏幕外
    );
  }
}
