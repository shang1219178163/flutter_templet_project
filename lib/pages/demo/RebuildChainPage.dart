//
//  RebuildChainPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/24.
//  Copyright © 2026/7/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

/// Widget 重建链路演示：观察父/子 build、didUpdateWidget 触发时机
class RebuildChainPage extends StatefulWidget {
  const RebuildChainPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<RebuildChainPage> createState() => _RebuildChainPageState();
}

class _RebuildChainPageState extends State<RebuildChainPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final logsVN = ValueNotifier<List<String>>([]);
  var parentCount = 0;
  var childValue = 0;

  void appendLog(String message) {
    void apply() {
      if (!mounted) {
        return;
      }
      final next = [message, ...logsVN.value];
      if (next.length > 50) {
        next.removeRange(50, next.length);
      }
      logsVN.value = next;
    }
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle || phase == SchedulerPhase.postFrameCallbacks) {
      apply();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => apply());
  }

  @override
  void dispose() {
    logsVN.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    appendLog('Parent.initState');
  }

  @override
  void didUpdateWidget(covariant RebuildChainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    appendLog('Parent.didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    appendLog('Parent.build count=$parentCount childValue=$childValue');
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text('$widget'),
              actions: [
                TextButton(
                  onPressed: clearLogs,
                  child: const Text('清空', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildActions(),
        const Divider(height: 1),
        Expanded(child: buildLogList()),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: _RebuildChainChild(
            value: childValue,
            onLog: appendLog,
          ),
        ),
      ],
    );
  }

  Widget buildActions() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton(
            onPressed: onParentSetState,
            child: Text('父 setState ($parentCount)'),
          ),
          FilledButton.tonal(
            onPressed: onUpdateChildValue,
            child: Text('改子属性 ($childValue)'),
          ),
        ],
      ),
    );
  }

  Widget buildLogList() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: logsVN,
      builder: (_, logs, __) {
        return Scrollbar(
          controller: scrollController,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              return Text(logs[i], style: const TextStyle(fontSize: 13));
            },
          ),
        );
      },
    );
  }

  void onParentSetState() {
    parentCount++;
    appendLog('触发 Parent.setState → count=$parentCount');
    setState(() {});
  }

  void onUpdateChildValue() {
    childValue++;
    appendLog('触发更新 childValue=$childValue');
    setState(() {});
  }

  void clearLogs() {
    logsVN.value = [];
  }
}

class _RebuildChainChild extends StatefulWidget {
  const _RebuildChainChild({
    required this.value,
    required this.onLog,
  });

  final int value;
  final ValueChanged<String> onLog;

  @override
  State<_RebuildChainChild> createState() => _RebuildChainChildState();
}

class _RebuildChainChildState extends State<_RebuildChainChild> {
  var localCount = 0;

  @override
  void initState() {
    super.initState();
    widget.onLog('Child.initState value=${widget.value}');
  }

  @override
  void didUpdateWidget(covariant _RebuildChainChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onLog('Child.didUpdateWidget old=${oldWidget.value} new=${widget.value}');
  }

  @override
  Widget build(BuildContext context) {
    widget.onLog('Child.build value=${widget.value} local=$localCount');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Child value=${widget.value}'),
            Text('Child localCount=$localCount'),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onChildSetState,
              child: const Text('子 setState'),
            ),
            const SizedBox(height: 8),
            _RebuildChainGrandChild(
              value: widget.value,
              onLog: widget.onLog,
            ),
          ],
        ),
      ),
    );
  }

  void onChildSetState() {
    localCount++;
    widget.onLog('触发 Child.setState → local=$localCount');
    setState(() {});
  }
}

class _RebuildChainGrandChild extends StatefulWidget {
  const _RebuildChainGrandChild({
    required this.value,
    required this.onLog,
  });

  final int value;
  final ValueChanged<String> onLog;

  @override
  State<_RebuildChainGrandChild> createState() => _RebuildChainGrandChildState();
}

class _RebuildChainGrandChildState extends State<_RebuildChainGrandChild> {
  @override
  void didUpdateWidget(covariant _RebuildChainGrandChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onLog('GrandChild.didUpdateWidget old=${oldWidget.value} new=${widget.value}');
  }

  @override
  Widget build(BuildContext context) {
    widget.onLog('GrandChild.build value=${widget.value}');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('GrandChild value=${widget.value}'),
    );
  }
}
