import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_controller.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_item.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_model.dart';

class RedPacketLayer extends StatelessWidget {
  const RedPacketLayer({
    super.key,
    required this.controller,
    required this.screenSize,
    required this.onSelected,
  });

  final RedPacketController controller;
  final Size screenSize;
  final void Function(RedPacketModel model, Offset global) onSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          children: controller.packets.map((model) {
            return RedPacketItem(
              key: ValueKey(model),
              model: model,
              screenSize: screenSize,
              onFinish: () => controller.remove(model),
              onTap: (offset) {
                controller.remove(model);
                onSelected(model, offset);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
