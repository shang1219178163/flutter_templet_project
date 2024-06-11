//
//  ddlog.dart
//  ddlog
//
//  Created by shang on 7/4/21 3:53 PM.
//  Copyright © 7/4/21 shang. All rights reserved.
//

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kReleaseMode;
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names, unnecessary_question_mark
void ddlog(dynamic obj, {bool hasTime = true, String prefix = "ddlog"}) {
  if (kReleaseMode) {
    return;
  }
  developer.log("$prefix ${hasTime ? DateTime.now() : ""} $obj");

  // var model = DDTraceModel(StackTrace.current);
  //
  // var items = [
  //   DateTime.now().toString(),
  //   model.fileName,
  //   model.className,
  //   model.selectorName,
  //   "[${model.lineNumber}:${model.columnNumber}]"
  // ].where((element) => element != "");
  // debugPrint("${items.join(" ")}: $obj");
}

/// DLog 日志打印
class DLog {
  /// 防止日志被截断
  static void d(
    dynamic obj, {
    String prefix = "DLog",
    bool hasTime = true,
  }) {
    ddlog(obj, prefix: prefix, hasTime: hasTime);
  }

  /// 函数执行时间
  static void codeExecution({
    required DateTime stime,
    String? funcName,
  }) {
    var etime = DateTime.now();
    final inMilliseconds = etime.difference(stime).inMilliseconds;
    DLog.d("$funcName 执行时长：$inMilliseconds 毫秒.");
  }

  static void center(List<String> list) {
    String line(String text, {String fill = "", required int maxLength}) {
      final fillCount = maxLength - text.length;
      final left = List.filled(fillCount ~/ 2, fill);
      final right = List.filled(fillCount - left.length, fill);
      return left.join() + text + right.join();
    }

    final listNew = [...list];
    listNew.sort((a, b) => b.length.compareTo(a.length));
    final maxLength = listNew.first.length;

    for (final e in list) {
      d(line(e, fill: ' ', maxLength: maxLength), hasTime: false);
    }
  }
}

/// TraceModel
class DDTraceModel {
  final StackTrace _trace;

  String fileName = "";
  String className = "";
  String selectorName = "";
  int lineNumber = 0;
  int columnNumber = 0;

  DDTraceModel(this._trace) {
    _parseTrace();
  }

  /// parse trace
  void _parseTrace() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        {
          var traceString2 = _trace.toString().split("\n")[2];
          // print(traceString2);

          var list = traceString2
              .split(" ")
              .where((element) => element != "")
              .toList();
          selectorName =
              list.last.replaceAll("[", "").replaceAll("]", "()").trim();

          _parseClassName(path: list.first);
          _parseLineAndcolumn(location: list[1]);
        }
        break;
      default:
        {
          var traceString1 = _trace.toString().split("\n")[1];
          // print(traceString1);

          var list = traceString1
              .replaceAll("#1", "")
              .replaceAll(".<anonymous closure>", "")
              .replaceAll(")", "")
              .replaceAll("(", "")
              .replaceAll(".dart:", ".dart ")
              .split(" ")
              .where((element) => element != "")
              .toList();

          var fileInfo = list.first.split(".").toList();
          className = fileInfo.first;
          selectorName = "${fileInfo.last}()";

          _parseClassName(path: list[1]);
          _parseLineAndcolumn(location: list.last);
        }
        break;
    }
  }

  /// parse className
  void _parseClassName({required String path}) {
    if (path.contains("/") == false) {
      debugPrint("[DateTime.now(), path]");
      return;
    }
    assert(path.contains("/"));
    var list = path
        .split("/")
        .last
        .split(" ")
        .where((element) => element != "")
        .toList();
    fileName = list.first.trim();
  }

  /// parse Line and column
  void _parseLineAndcolumn({required String location}) {
    if (location.contains(":")) {
      var list = location.split(":");
      lineNumber = int.parse(list.first.trim());
      columnNumber = int.parse(list.last.trim());
    }
  }
}
