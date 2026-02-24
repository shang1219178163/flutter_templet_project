import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_controller.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_layer.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_rain.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_spawner.dart';

class RedPacketRainDemo extends StatefulWidget {
  const RedPacketRainDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<RedPacketRainDemo> createState() => _RedPacketRainDemoState();
}

class _RedPacketRainDemoState extends State<RedPacketRainDemo> {
  final scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant RedPacketRainDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: Stack(
        children: [
          buildBody(),
          const RedPacketRain(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }
}
