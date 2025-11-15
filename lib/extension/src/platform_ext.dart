//
//  PlatformExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 15:00.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

import 'dart:io';

extension PlatformExt on Platform {
  static Map<String, dynamic> toJson() {
    return {
      "numberOfProcessors": Platform.numberOfProcessors,
      "pathSeparator": Platform.pathSeparator,
      "operatingSystem": Platform.operatingSystem,
      "operatingSystemVersion": Platform.operatingSystemVersion,
      "localHostname": Platform.localHostname,
      "version": Platform.version,
      "localeName": Platform.localeName,
      "isLinux": Platform.isLinux,
      "isMacOS": Platform.isMacOS,
      "isWindows": Platform.isWindows,
      "isAndroid": Platform.isAndroid,
      "isIOS": Platform.isIOS,
      "isFuchsia": Platform.isFuchsia,
      "environment": Platform.environment,
      "executable": Platform.executable,
      "resolvedExecutable": Platform.resolvedExecutable,
      "script": Platform.script.toString(),
      "executableArguments": Platform.executableArguments,
      "packageConfig": Platform.packageConfig,
      "lineTerminator": Platform.lineTerminator,
    };
  }
}
