//
//  ServiceProtocolInfoExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/19 10:58.
//  Copyright © 2024/11/19 shang. All rights reserved.
//

import 'dart:developer';
import 'package:isar/isar.dart';

extension ServiceProtocolInfoExt on ServiceProtocolInfo {
  /// 获取 isar 链接
  String? get isarUrl {
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
    final url = ' https://inspect.isar-community.dev/${Isar.version}/#/$port$path ';
    return url;
  }
}
