import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

class AsyncDemo extends StatefulWidget {
  AsyncDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AsyncDemo> createState() => _AsyncDemoState();
}

class _AsyncDemoState extends State<AsyncDemo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final resultVN = ValueNotifier("");

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
                  .map(
                    (e) => TextButton(
                      child: Text(
                        e,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: onPressed,
                    ),
                  )
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: resultVN,
                builder: (context, value, child) {
                  return Text("$value");
                }),
          ],
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    resultVN.value = await asyncMethod();
    await Future.delayed(Duration(milliseconds: 1000));
    resultVN.value = await asyncMethod1(handOut: (val) async {
      ddlog("asyncMethod1: $val");
      ddlog("asyncMethod2: ${await val}");
    });

    String data = ' ';

    var original = utf8.encode(data);
    var compressed = gzip.encode(original);
    var decompressed = gzip.decode(compressed);
  }

  Future<String> asyncMethod() {
    var completer = Completer<String>();
    Timer(Duration(seconds: 1), () => completer.complete("done"));
    return completer.future;
  }

  Future<dynamic> asyncMethod1({
    required ValueChanged<dynamic> handOut,
  }) {
    var completer = Completer();
    handOut(completer.future);

    completer.complete('completion value');
    return completer.future;
  }
}
