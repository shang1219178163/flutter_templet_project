import 'dart:isolate';

import 'package:flutter/cupertino.dart';

class IoslateWorker {
  late SendPort _sendPort;
  late ReceivePort _receivePort;

  Future<void> spawn() async {
    // 1. 创建接收端口
    _receivePort = ReceivePort();

    // 2. 启动Isolate
    await Isolate.spawn(_entryPoint, _receivePort.sendPort);

    // 3. 等待worker发送它的SendPort
    _sendPort = await _receivePort.first;

    // 4. 设置消息监听
    _receivePort.listen((message) {
      debugPrint('收到worker消息: $message');
    });
  }

  static void _entryPoint(SendPort mainSendPort) {
    // 1. 创建worker自己的接收端口
    final workerReceivePort = ReceivePort();

    // 2. 将自己的SendPort发送给主isolate
    mainSendPort.send(workerReceivePort.sendPort);

    // 3. 监听主isolate发来的消息
    workerReceivePort.listen((message) {
      debugPrint('worker收到: $message');

      // 执行计算...
      final result = '处理结果';

      // 发送结果回主isolate
      mainSendPort.send(result);
    });
  }

  void sendTask(String task) {
    _sendPort.send(task);
  }
}
