import 'dart:async';

import 'package:flutter/material.dart';

///自定义轮播
class CustomSwipper extends StatefulWidget {
  const CustomSwipper({
    Key? key,
    required this.images,
    required this.onTap,
    this.itemBuilder,
    this.height = 200,
    this.curve = Curves.linear,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  final List<String> images;
  final double height;
  final ValueChanged<int> onTap;
  final Curve curve;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration? duration;

  @override
  _CustomSwipperState createState() => _CustomSwipperState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('images', images));
    properties.add(DoubleProperty('height', height));
    properties.add(ObjectFlagProperty<ValueChanged<int>>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder?>.has('itemBuilder', itemBuilder));
    properties.add(DiagnosticsProperty<Duration?>('duration', duration));
  }
}

class _CustomSwipperState extends State<CustomSwipper> {
  int _curIndex = 0;
  late PageController _pageController;

  Timer? _timer;
  Timer? _jumpTimer;

  @override
  void initState() {
    super.initState();
    final length = widget.images.length;
    _curIndex = length > 0 ? length * 5 : 0;
    _pageController = PageController(initialPage: _curIndex);
    if (length > 0) {
      _initTimer();
    }
  }

  @override
  void dispose() {
    _cancelTimer(restart: false);
    _jumpTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        buildPageView(),
        Positioned(
          bottom: 10,
          child: buildIndicatorNew(),
        ),
      ],
    );
  }

  Widget buildIndicator() {
    var length = widget.images.length;

    return Row(
      children: widget.images.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: ClipOval(
            child: Container(
              width: 8,
              height: 8,
              color: e == widget.images[_curIndex % length] ? Colors.white : Colors.grey,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildIndicatorNew() {
    var length = widget.images.length;
    return Row(
      children: widget.images.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: 28,
            height: 2,
            color: e == widget.images[_curIndex % length] ? Colors.white : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  Widget buildPageView() {
    var length = widget.images.length;
    return Container(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          _curIndex = index;
          if (index == 0) {
            _curIndex = length;
            _changePage();
          }
          debugPrint("_curIndex:$_curIndex");
          setState(() {});
        },
        itemBuilder: (context, index) {
          final screenSize = MediaQuery.sizeOf(context);
          final dpr = MediaQuery.devicePixelRatioOf(context);
          final imageCacheWidth = (screenSize.width * dpr).round().clamp(1, 1024);

          return GestureDetector(
            onPanDown: (details) {
              _cancelTimer();
            },
            onTap: () {
              final currIdx = index % length;
              debugPrint('onTap 当前 page 为 $index,$length,$currIdx');

              widget.onTap(currIdx);
            },
            child: widget.itemBuilder != null
                ? widget.itemBuilder!(context, index)
                : FadeInImage.assetNetwork(
                    placeholder: 'images/img_placeholder.png',
                    image: widget.images[index % length],
                    fit: BoxFit.cover,
                    height: widget.height,
                    imageCacheWidth: imageCacheWidth,
                  ),
          );
        },
      ),
    );
  }

  /// 点击到图片的时候取消定时任务，随后重新开始
  void _cancelTimer({bool restart = true}) {
    _timer?.cancel();
    _timer = null;
    if (restart) {
      _initTimer();
    }
  }

  /// 初始化定时任务
  void _initTimer() {
    if (widget.images.isEmpty) {
      return;
    }
    _timer ??= Timer.periodic(widget.duration ?? Duration(seconds: 3), (t) {
      if (!mounted) {
        return;
      }
      _curIndex++;
      _pageController.animateToPage(
        _curIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.linear,
      );
    });
  }

  /// 切换页面，并刷新小圆点
  void _changePage() {
    debugPrint("_changePage:$_curIndex");

    _jumpTimer?.cancel();
    _jumpTimer = Timer(Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }
      _pageController.jumpToPage(_curIndex);
    });
  }
}
