import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_controller.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_model.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_rain.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_spawner.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/selected_red_packet_widget.dart';

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

  final RedPacketController _controller = RedPacketController(WeChatRedPacketSpawner());
  final List<Widget> _selectedPackets = [];

  @override
  void initState() {
    super.initState();
    _controller.start();
  }

  void _onPacketSelected(
    RedPacketModel model,
    Offset globalPosition,
  ) {
    setState(() {
      _selectedPackets.add(
        SelectedRedPacketWidget(
          from: globalPosition,
          size: model.size,
          onFinish: () {
            _selectedPackets.clear();
            setState(() {});
          },
        ),
      );
    });
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
                onSelected: _onPacketSelected,
              ),
            ),
          ),
          ..._selectedPackets,
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
