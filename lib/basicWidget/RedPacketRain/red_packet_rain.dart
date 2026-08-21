import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_controller.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_layer.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_model.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_spawner.dart';

class RedPacketRain extends StatefulWidget {
  const RedPacketRain({
    super.key,
    required this.onSelected,
  });

  final void Function(RedPacketModel model, Offset global) onSelected;

  @override
  State<RedPacketRain> createState() => _RedPacketRainState();
}

class _RedPacketRainState extends State<RedPacketRain> {
  late final RedPacketController _controller;
  Size _screenSize = Size.zero;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = RedPacketController(
      WeChatRedPacketSpawner(),
    )..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.sizeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    var enabled = ModalRoute.of(context)?.isCurrent ?? true;
    // enabled = false;
    return TickerMode(
      enabled: enabled,
      child: RedPacketLayer(
        controller: _controller,
        screenSize: _screenSize,
        onSelected: widget.onSelected,
      ),
    );
  }
}
