import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/CupertinoSliverLoadMoreControl.dart';
import 'package:flutter_templet_project/basicWidget/placehorlder/activity_indicator_placehorlder.dart';
import 'package:flutter_templet_project/basicWidget/placehorlder/list_footer_no_more_placehorlder.dart';

class SliverRefreshControlDemo extends StatefulWidget {
  const SliverRefreshControlDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SliverRefreshControlDemo> createState() => _SliverRefreshControlDemoState();
}

class _SliverRefreshControlDemoState extends State<SliverRefreshControlDemo> {
  final scrollController = ScrollController();

  var list = List.generate(20, (i) => "item_$i");

  var hasMoreVN = ValueNotifier(true);

  @override
  void didUpdateWidget(covariant SliverRefreshControlDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        CupertinoSliverRefreshControl(
          builder: buildRefreshIndicator,
          onRefresh: onRefresh,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, int i) {
              final e = list[i];
              return Container(
                height: 45,
                child: ListTile(
                  leading: Icon(Icons.place),
                  title: Text(e),
                ),
              );
            },
            childCount: list.length,
          ),
        ),
        CupertinoSliverLoadMoreControl(
          // controller: scrollController,
          onLoadMore: onMore,
          hasMore: hasMoreVN.value,
          // triggerDistance: 60,
          placehorlderBuilder: (_, hasMore, isLoading) {
            if (!hasMore) {
              // return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverToBoxAdapter(
                child: ListFooterNoMorePlacehorlder(),
              );
            }

            return SliverToBoxAdapter(
              child: isLoading ? ActivityIndicatorPlacehorlder() : const SizedBox(height: 16),
            );
          },
        ),
      ],
    );
  }

  Widget buildRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    const double _kActivityIndicatorRadius = 14.0;
    const double _kActivityIndicatorMargin = 16.0;

    final double percentageComplete = clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

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

  Widget _buildIndicatorForRefreshState(RefreshIndicatorMode refreshState, double radius, double percentageComplete) {
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

  Future<void> onRefresh() async {
    await fetchPage(isRefresh: true);
  }

  Future<bool> onMore() async {
    final hasMore = await fetchPage(isRefresh: false);
    return hasMore;
  }

  Future<bool> fetchPage({required bool isRefresh}) async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (isRefresh) {
      list = List.generate(20, (i) => "item_${i}");
    } else {
      if (list.length > 59) {
        hasMoreVN.value = false;
      } else {
        var items = List.generate(20, (i) => "item_${list.length + i}");
        list.addAll(items);
        hasMoreVN.value = list.length % 20 == 0;
      }
    }

    debugPrint("hasMoreVN.value: ${hasMoreVN.value}");
    setState(() {});
    return hasMoreVN.value;
  }
}
