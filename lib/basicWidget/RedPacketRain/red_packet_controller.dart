import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_model.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_spawner.dart';

class RedPacketController extends ChangeNotifier {
  RedPacketController(this.spawner);

  final RedPacketSpawner spawner;
  final List<RedPacketModel> packets = [];

  Timer? _timer;

  void start({
    Duration interval = const Duration(milliseconds: 180),
    int maxCount = 120,
  }) {
    stop();
    _timer = Timer.periodic(interval, (_) {
      if (packets.length >= maxCount) {
        return;
      }
      packets.add(spawner.spawn());
      notifyListeners();
    });
  }

  void remove(RedPacketModel model) {
    packets.remove(model);
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
