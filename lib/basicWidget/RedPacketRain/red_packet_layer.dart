import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_controller.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_widget.dart';

class RedPacketLayer extends StatelessWidget {
  const RedPacketLayer({
    super.key,
    required this.controller,
    required this.screenSize,
  });

  final RedPacketController controller;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          children: controller.packets.map((model) {
            return RedPacketWidget(
              key: ValueKey(model),
              model: model,
              screenSize: screenSize,
              onFinish: () => controller.remove(model),
              onTap: () {
                // TODO: 点击红包（爆炸 / 记分 / 音效）
                debugPrint([runtimeType, DateTime.now(), model.toJson()].join(" "));
              },
            );
          }).toList(),
        );
      },
    );
  }
}
