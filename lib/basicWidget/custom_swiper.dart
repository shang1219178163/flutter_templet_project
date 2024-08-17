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
}

class _CustomSwipperState extends State<CustomSwipper> {
  int _curIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  Timer? _timer;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _curIndex = widget.images.length * 5;
    _pageController = PageController(initialPage: _curIndex);
    _initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildPageView(),
        // Positioned(
        //   bottom: 10,
        //   child: _buildIndicator(),
        // ),
        Positioned(
          bottom: 10,
          child: _buildIndicatorNew(),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    var length = widget.images.length;

    return Row(
      children: widget.images.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: ClipOval(
            child: Container(
              width: 8,
              height: 8,
              color: e == widget.images[_curIndex % length]
                  ? Colors.white
                  : Colors.grey,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIndicatorNew() {
    var length = widget.images.length;
    return Row(
      children: widget.images.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: 28,
            height: 2,
            color: e == widget.images[_curIndex % length]
                ? Colors.white
                : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPageView() {
    var length = widget.images.length;
    return Container(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _curIndex = index;
            if (index == 0) {
              _curIndex = length;
              _changePage();
            }
            debugPrint("_curIndex:$_curIndex");
          });
        },
        itemBuilder: (context, index) {
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
                  ),
          );
        },
      ),
    );
  }

  /// 点击到图片的时候取消定时任务
  _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      // _timer = null;
      _initTimer();
    }
  }

  /// 初始化定时任务
  _initTimer() {
    _timer ??= Timer.periodic(widget.duration ?? Duration(seconds: 3), (t) {
      _curIndex++;
      _pageController.animateToPage(
        _curIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.linear,
      );
    });
  }

  /// 切换页面，并刷新小圆点
  _changePage() {
    debugPrint("_changePage:$_curIndex");

    Timer(Duration(milliseconds: 350), () {
      _pageController.jumpToPage(_curIndex);
    });
  }
}
