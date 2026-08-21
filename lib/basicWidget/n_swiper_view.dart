import 'dart:async';
import 'package:flutter/material.dart';

/// 走马灯
class NSwiperView extends StatefulWidget {
  const NSwiperView({
    super.key,
    this.physics = const NeverScrollableScrollPhysics(),
    this.scrollDirection = Axis.vertical,
    required this.itemBuilder,
    required this.initIndex,
    required this.itemCount,
    this.duration = const Duration(seconds: 5),
  });

  final ScrollPhysics? physics;

  final Axis scrollDirection;

  final NullableIndexedWidgetBuilder itemBuilder;

  final int initIndex;

  final int itemCount;

  final Duration duration;

  @override
  State<NSwiperView> createState() => _NSwiperViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(EnumProperty<Axis>('scrollDirection', scrollDirection));
    properties.add(ObjectFlagProperty<NullableIndexedWidgetBuilder>.has('itemBuilder', itemBuilder));
    properties.add(IntProperty('initIndex', initIndex));
    properties.add(IntProperty('itemCount', itemCount));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
  }
}

class _NSwiperViewState extends State<NSwiperView> {
  late PageController _pageController;

  late int currentIndex = 0;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initIndex + (widget.itemCount * 1000);
    _pageController = PageController(
      initialPage: widget.initIndex,
      viewportFraction: 1,
    );

    Future.microtask(() {
      _timer = Timer.periodic(widget.duration, (timer) {
        _pageController.nextPage(
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutQuad,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: PageView.builder(
        controller: _pageController,
        physics: widget.physics,
        scrollDirection: widget.scrollDirection,
        itemBuilder: (context, index) {
          var realIndex = index % widget.itemCount;
          return widget.itemBuilder(context, realIndex);
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('currentIndex', currentIndex));
  }
}
