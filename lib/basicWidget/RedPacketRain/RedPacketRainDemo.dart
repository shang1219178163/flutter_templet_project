import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_controller.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_layer.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_rain.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_spawner.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(color: Colors.blue),
              ),
              child: RedPacketRain(
                onTap: (model) {
                  // TODO: 点击红包（爆炸 / 记分 / 音效）
                  debugPrint([runtimeType, DateTime.now(), model.toJson()].join(" "));
                  ToastUtil.show("${model.toJson()}");
                },
              ),
            ),
          ),
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
            Container(
              height: 700,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
