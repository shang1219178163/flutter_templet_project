//
//  TapTrack.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/9 21:59.
//  Copyright © 2026/5/9 shang. All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TapTrack {
  static void init({required ValueChanged<Map<String, dynamic>> onReport}) {
    GestureBinding.instance.pointerRouter.addGlobalRoute((event) {
      return _handlePointer(event: event, onReport: onReport);
    });
  }

  static void _handlePointer({
    required PointerEvent event,
    required ValueChanged<Map<String, dynamic>> onReport,
  }) {
    if (event is! PointerDownEvent) {
      return;
    }

    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(
      result,
      event.position,
      event.viewId,
    );

    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderMetaData) {
        final data = target.metaData;
        if (data is Map<String, dynamic>) {
          onReport(data);
          break;
        }
      }
    }
  }
}

class TapTrackWidget extends StatelessWidget {
  const TapTrackWidget({
    super.key,
    required this.child,
    required this.data,
  });

  final Map<String, dynamic> data;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MetaData(
      metaData: data,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
