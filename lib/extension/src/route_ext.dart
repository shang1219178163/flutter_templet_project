//
//  RoutingExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/12 10:48.
//  Copyright © 2025/3/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';

extension RouteExt on Route<dynamic> {}

extension RouteSettingsExt on RouteSettings {
  static RouteSettings fromJson(Map<String, dynamic> json) {
    return RouteSettings(
      name: json?["name"],
      arguments: json?["arguments"],
    );
  }

  /// json
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "arguments": arguments,
    };
  }
}

extension RoutingExt on Routing {
  /// json
  Map<String, dynamic> toJson() {
    return {
      "current": current,
      "previous": previous,
      "args": args,
      "removed": removed,
      "route": route,
      "isBack": isBack,
      "isBottomSheet": isBottomSheet,
      "isDialog": isDialog,
    };
  }
}
