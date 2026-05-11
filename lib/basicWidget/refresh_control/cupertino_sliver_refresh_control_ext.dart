//
//  CupertinoSliverRefreshControlExt.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/8 16:10.
//  Copyright © 2026/1/8 shang. All rights reserved.
//

import 'dart:ui';
import 'package:flutter/cupertino.dart';

extension CupertinoSliverRefreshControlExt on CupertinoSliverRefreshControl {
  /// 自定义刷新指示器
  static Widget customRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    const _kActivityIndicatorRadius = 14.0;
    const _kActivityIndicatorMargin = 16.0;

    final percentageComplete = clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

    // Place the indicator at the top of the sliver that opens up. We're using a
    // Stack/Positioned widget because the CupertinoActivityIndicator does some
    // internal translations based on the current size (which grows as the user drags)
    // that makes Padding calculations difficult. Rather than be reliant on the
    // internal implementation of the activity indicator, the Positioned widget allows
    // us to be explicit where the widget gets placed. The indicator should appear
    // over the top of the dragged widget, hence the use of Clip.none.
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: _kActivityIndicatorMargin,
            left: 0.0,
            right: 0.0,
            child: _buildIndicatorForRefreshState(refreshState, _kActivityIndicatorRadius, percentageComplete),
          ),
        ],
      ),
    );
  }

  static Widget _buildIndicatorForRefreshState(
      RefreshIndicatorMode refreshState, double radius, double percentageComplete) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. The opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator.partiallyRevealed(
                  radius: radius,
                  progress: percentageComplete,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text("下拉刷新", style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(radius: radius),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("刷新中...", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(radius: radius * percentageComplete),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("刷新成功", style: TextStyle(fontSize: 16 * percentageComplete)),
            ),
          ],
        );
      case RefreshIndicatorMode.inactive:
        return const SizedBox.shrink();
    }
  }
}
