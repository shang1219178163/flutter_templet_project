import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:get/get.dart';

class ConcurrentExecutorDemo extends StatefulWidget {
  const ConcurrentExecutorDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ConcurrentExecutorDemo> createState() => _ConcurrentExecutorDemoState();
}

class _ConcurrentExecutorDemoState extends State<ConcurrentExecutorDemo> {
  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// 任务数
  var taskCount = 10;

  /// 并发数量
  var maxConcurrent = 3;

  /// 执行描述
  final descVN = ValueNotifier("");

  String get timeStr => DateTime.now().toString();

  @override
  void didUpdateWidget(covariant ConcurrentExecutorDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("并发执行(总数:$taskCount, 最大并发数: $maxConcurrent):"),
            ElevatedButton(onPressed: onTest, child: Text("开始执行")),
            ValueListenableBuilder(
              valueListenable: descVN,
              builder: (context, value, child) {
                return Text(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTest() async {
    descVN.value = "";

    final executor = ConcurrentExecutor(maxConcurrent: maxConcurrent);

    for (var i = 0; i < taskCount; i++) {
      final id = i;
      executor.add(() async {
        DLog.d('Start $id');
        descVN.value += "[$timeStr]Start $id\n";
        await Future.delayed(Duration(seconds: 1));
        DLog.d('Done $id');
        descVN.value += "[$timeStr]Done $id\n";
      });
    }
    await executor.waitForEmpty();
    DLog.d('All tasks complete');
    descVN.value += "[$timeStr]All tasks complete ${executor.isComplete}\n";
  }
}

/// 并发执行器
class ConcurrentExecutor {
  ConcurrentExecutor({this.maxConcurrent = 3});

  final int maxConcurrent;
  final Queue<Future<void> Function()> _taskQueue = Queue();
  int _running = 0;

  /// 是否完成所有任务
  bool get isComplete => _running == 0;

  void add(Future<void> Function() task) {
    _taskQueue.add(task);
    _tryExecuteNext();
  }

  void _tryExecuteNext() {
    while (_running < maxConcurrent && _taskQueue.isNotEmpty) {
      final task = _taskQueue.removeFirst();
      _running++;
      task().whenComplete(() {
        _running--;
        _tryExecuteNext();
      });
    }
  }

  Future<void> waitForEmpty() async {
    while (_taskQueue.isNotEmpty || _running > 0) {
      await Future.delayed(Duration(milliseconds: 50));
    }
  }
}
