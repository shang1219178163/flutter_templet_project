//
//  ScrollDirectionMixin.dart
//  yl_patient_app
//
//  Created by shang on 2024/6/12 11:12.
//  Copyright © 2024/6/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

/// 滚动方向改变监听
mixin ScrollDirectionMixin<T extends StatefulWidget> on State<T> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final oldScrolledUnder = _scrolledUnder;
      final metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis, and should
          // not be altered based on horizontal notifications of the same
          // predicate since it could be a 2D scroller.
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        onScrollDirectionChanged(notification);
      }
    }
  }

  /// 滚动方向改变回调
  late ValueChanged<ScrollNotification> onScrollDirectionChanged;
}
