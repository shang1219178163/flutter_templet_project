//
//  ClickTrack.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/9 10:03.
//  Copyright © 2026/5/9 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// 全局埋点(需要配合 TapTrackWidget 使用)
class ClickTrack {
  /// tap track init
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
    // debugPrint("_handlePointer PointerDown: ${event.position}");

    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(
      result,
      event.position,
      event.viewId,
    );

    for (final item in result.path) {
      final target = item.target;
      if (target is RenderObject) {
        final element = _findElement(target);
        if (element != null) {
          final inherited = element.dependOnInheritedWidgetOfExactType<_ClickTrackInherited>();
          if (inherited != null) {
            onReport(inherited.data);
            break;
          }
        }
      }
    }
  }

  static Element? _findElement(RenderObject renderObject) {
    Element? result;
    void visitor(Element element) {
      if (element.renderObject == renderObject) {
        result = element;
      } else {
        element.visitChildren(visitor);
      }
    }

    WidgetsBinding.instance.rootElement?.visitChildren(visitor);
    return result;
  }
}

/// 日志追踪组件
class ClickTrackWidget extends StatelessWidget {
  const ClickTrackWidget({
    super.key,
    required this.child,
    required this.data,
  });

  final Widget child;

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return _ClickTrackInherited(
      data: data,
      child: child,
    );
  }
}

class _ClickTrackInherited extends InheritedWidget {
  const _ClickTrackInherited({
    required this.data,
    required super.child,
  });

  final Map<String, dynamic> data;

  @override
  bool updateShouldNotify(covariant _ClickTrackInherited oldWidget) {
    return !mapEquals(oldWidget.data, data);
  }
}
