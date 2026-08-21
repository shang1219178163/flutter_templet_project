//
//  NCupertinoSliverRefreshIndicator.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/8 15:58.
//  Copyright © 2026/1/8 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/cupertino.dart';

/// CupertinoSliverRefreshControl 显示自定义
class NCupertinoSliverRefreshIndicator extends StatelessWidget {
  const NCupertinoSliverRefreshIndicator({
    super.key,
    required this.refreshState,
    required this.pulledExtent,
    required this.refreshTriggerPullDistance,
    required this.refreshIndicatorExtent,
  });

  final RefreshIndicatorMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;

  @override
  Widget build(BuildContext context) {
    return buildRefreshIndicator(
      context,
      refreshState,
      pulledExtent,
      refreshTriggerPullDistance,
      refreshIndicatorExtent,
    );
  }

  Widget buildRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    const _kActivityIndicatorRadius = 14.0;
    const _kActivityIndicatorMargin = 16.0;

    final percentageComplete = clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: _kActivityIndicatorMargin,
            left: 0.0,
            right: 0.0,
            child: buildIndicatorForRefreshState(refreshState, _kActivityIndicatorRadius, percentageComplete),
          ),
        ],
      ),
    );
  }

  Widget buildIndicatorForRefreshState(RefreshIndicatorMode refreshState, double radius, double percentageComplete) {
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<RefreshIndicatorMode>('refreshState', refreshState));
    properties.add(DoubleProperty('pulledExtent', pulledExtent));
    properties.add(DoubleProperty('refreshTriggerPullDistance', refreshTriggerPullDistance));
    properties.add(DoubleProperty('refreshIndicatorExtent', refreshIndicatorExtent));
  }
}
