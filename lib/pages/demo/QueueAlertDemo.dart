import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';

/// 队列弹窗
class QueueAlertDemo extends StatefulWidget {
  const QueueAlertDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<QueueAlertDemo> createState() => _QueueAlertDemoState();
}

class _QueueAlertDemoState extends State<QueueAlertDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            TextButton(
              onPressed: () {
                showQueueAlert();
              },
              child: Text("队列弹窗"),
            ),
          ],
        ),
      ),
    );
  }

  void showQueueAlert() {
    final intercepts = InterceptChainHandler<DialogPass>();
    intercepts.add(TipsIntercept());
    intercepts.add(VerifyIntercept());
    intercepts.add(VerifyAgainIntercept());

    intercepts.intercept(DialogPass('你确定你要阅读全部协议吗1？', 1));
  }
}

class InterceptChain<T> {
  InterceptChain? next;

  void intercept(T data) {
    next?.intercept(data);
  }
}

class InterceptChainHandler<T> {
  InterceptChain? _interceptFirst;

  void add(InterceptChain interceptChain) {
    if (_interceptFirst == null) {
      _interceptFirst = interceptChain;
      return;
    }

    var node = _interceptFirst;

    while (true) {
      if (node!.next == null) {
        node.next = interceptChain;
        break;
      }
      node = node.next;
    }
  }

  void intercept(T data) {
    _interceptFirst?.intercept(data);
  }
}

class DialogPass {
  String? msg;
  int passType = 0;

  DialogPass(this.msg, this.passType);
}

class TipsIntercept extends InterceptChain<DialogPass> {
  @override
  void intercept(DialogPass data) {
    CupertinoAlertDialog(
      title: Text("$this"),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            super.intercept(data);
          },
          child: Text("确定"),
        ),
      ],
    ).toShowCupertinoDialog(context: Get.context!);
  }
}

class VerifyIntercept extends InterceptChain<DialogPass> {
  @override
  void intercept(DialogPass data) {
    CupertinoAlertDialog(
      title: Text("$this"),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            super.intercept(data);
          },
          child: Text("确定"),
        ),
      ],
    ).toShowCupertinoDialog(context: Get.context!);
  }
}

class VerifyAgainIntercept extends InterceptChain<DialogPass> {
  @override
  void intercept(DialogPass data) {
    CupertinoAlertDialog(
      title: Text("$this"),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            super.intercept(data);
          },
          child: Text("确定"),
        ),
      ],
    ).toShowCupertinoDialog(context: Get.context!);
  }
}
