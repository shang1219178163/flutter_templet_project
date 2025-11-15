//
//  ServiceProtocolInfoExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/19 10:58.
//  Copyright © 2024/11/19 shang. All rights reserved.
//

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/src/string_ext.dart';

import 'package:isar/isar.dart';

extension ServiceProtocolInfoExt on ServiceProtocolInfo {
  /// 获取 isar 链接
  String? getIsarUrl({required bool isCommunityVersion}) {
    if (serverUri == null) {
      return null;
    }

    final port = serverUri!.port;
    var path = serverUri!.path;
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    if (path.endsWith('=')) {
      path = path.substring(0, path.length - 1);
    }
    var url = 'https://inspect.isar-community.dev/${Isar.version}/#/$port$path';
    if (!isCommunityVersion) {
      url = 'https://inspect.isar.dev/${Isar.version}/#/$port$path';
    }
    return url;
  }

  void printIsarLink() {
    final isarUrl = getIsarUrl(isCommunityVersion: true);
    if (isarUrl?.isNotEmpty != true) {
      return;
    }

    var url = isarUrl ?? "";
    final maxLength = url.length;
    final lines = [
      ''.filledLine(maxLength: maxLength, fill: "═"),
      'ISAR CONNECT STARTED'.filledLine(maxLength: maxLength),
      ''.filledLine(maxLength: maxLength, fill: "─"),
      'Open the link to connect to the Isar'.filledLine(maxLength: maxLength),
      'Inspector while this build is running.'.filledLine(maxLength: maxLength),
      ''.filledLine(maxLength: maxLength, fill: "─"),
      url,
      ''.filledLine(maxLength: maxLength, fill: "═"),
    ];
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (i == 0) {
        debugPrint('╔$line╗');
      } else if (i == lines.length - 1) {
        debugPrint('╚$line╝');
      } else {
        debugPrint('║$line║');
      }
    }
  }
}
