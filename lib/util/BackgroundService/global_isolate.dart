import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';

//https://www.jianshu.com/p/4df251c134f0

class GlobalIsolate {
  static Isolate? _newIsolate;
  static SendPort? _newIsolateSendPort;

  static int _i = 0;

  static final Map<int, dynamic> _works = {};

  static Future isolateDo({
    required Future Function(Map<String, dynamic> params) work,
    required Map<String, dynamic> params,
  }) async {
    if (_newIsolate == null) {
      await _initNewIsolate();
    }
    var message = SendMessage(id: _i, params: params, work: work);
    _newIsolateSendPort?.send(message);
    var c = Completer();
    _works[_i] = c;
    _i++;
    try {
      final result = await c.future;
      return result;
    } catch (e) {
      return null;
    }
  }

  static Future _initNewIsolate() async {
    if (_newIsolate != null) {
      return;
    }
    //第1步: 默认执行环境下是rootIsolate，所以创建的是一个rootIsolateReceivePort
    var rootIsolateReceivePort = ReceivePort();
    //第2步: 获取rootIsolateSendPort
    var rootIsolateSendPort = rootIsolateReceivePort.sendPort;
    //第3步: 创建一个newIsolate实例，并把rootIsolateSendPort作为参数传入到newIsolate中，为的是让newIsolate中持有rootIsolateSendPort, 这样在newIsolate中就能向rootIsolate发送消息了
    _newIsolate = await Isolate.spawn(_createNewIsolateContext,
        rootIsolateSendPort); //注意createNewIsolateContext这个函数执行环境就会变为newIsolate, rootIsolateSendPort就是createNewIsolateContext回调函数的参数
    //第7步: 通过rootIsolateReceivePort接收到来自newIsolate的消息，所以可以注意到这里是await 因为是异步消息
    //只不过这个接收到的消息是newIsolateSendPort, 最后赋值给全局newIsolateSendPort，这样rootIsolate就持有newIsolate的SendPort
    // var message = await rootIsolateReceivePort.first;
    //第8步，建立连接成功
    // print(messageList[0] as String);
    // newIsolateSendPort = message as SendPort;
    // print("newIsolateSendPort $message");
    rootIsolateReceivePort.listen((message) {
      if (message is SendPort) {
        debugPrint("newIsolateSendPort $message");
        _newIsolateSendPort = message;
      } else if (message is ReceiveMessage) {
        if (_works[message.id] is Completer) {
          Completer c = _works[message.id];
          c.complete(message.result);
          _works.remove(message.id);
        }
      }
    });
  }

//特别需要注意:createNewIsolateContext执行环境是newIsolate
  static Future<void> _createNewIsolateContext(
      SendPort rootIsolateSendPort) async {
    //第4步: 注意callback这个函数执行环境就会变为newIsolate, 所以创建的是一个newIsolateReceivePort
    var newIsolateReceivePort = ReceivePort();
    //第5步: 获取newIsolateSendPort, 有人可能疑问这里为啥不是直接让全局newIsolateSendPort赋值，注意这里执行环境不是rootIsolate
    var newIsolateSendPort = newIsolateReceivePort.sendPort;
    //第6步: 特别需要注意这里，这里是利用rootIsolateSendPort向rootIsolate发送消息，只不过发送消息是newIsolate的SendPort, 这样rootIsolate就能拿到newIsolate的SendPort
    rootIsolateSendPort.send(newIsolateSendPort);
    newIsolateReceivePort.listen((message) {
      if (message is SendMessage) {
        message.work(message.params).then((value) => rootIsolateSendPort
            .send(ReceiveMessage(id: message.id, result: value)));
      }
    });
  }
}

///通知子isolate工作
class SendMessage {
  int id;
  Map<String, dynamic> params;
  Future Function(Map<String, dynamic> params) work;

  SendMessage({
    required this.id,
    required this.params,
    required this.work,
  });
}

///通知main isolate,活干完了,给你结果
class ReceiveMessage {
  int id;
  dynamic result;

  ReceiveMessage({
    required this.id,
    this.result,
  });
}
