import 'dart:async';

import 'package:flutter/material.dart';

class CustomSwipper extends StatefulWidget {
  final List<String> images;
  final double height;
  final ValueChanged<int> onTap;
  final Curve curve;
  // final IndexedWidgetBuilder itemBuilder;

  CustomSwipper({
    required this.images,
    required this.onTap,
    // required this.itemBuilder,
    this.height = 200,
    this.curve = Curves.linear,
  }) : assert(images != null);

  @override
  _CustomSwipperState createState() => _CustomSwipperState();
}

class _CustomSwipperState extends State<CustomSwipper> {
   int _curIndex = 0;
   PageController _pageController = PageController(initialPage: 0);

   Timer? _timer;

  @override
  void initState() {
    super.initState();
    _curIndex = widget.images.length * 5;
    _pageController = PageController(initialPage: _curIndex);
    // _initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildPageView(),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildIndicator() {
    var length = widget.images.length;
    return Positioned(
      bottom: 10,
      child: Row(
        children: widget.images.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: ClipOval(
              child: Container(
                width: 8,
                height: 8,
                color: s == widget.images[_curIndex % length]
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
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
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onPanDown: (details) {
              _cancelTimer();
            },
            onTap: () {

              final currIdx = index % length;
              print('onTap 当前 page 为 ${index},${length},${currIdx}');

              widget.onTap(currIdx);
            },
            child: Image.network(
              widget.images[index % length],
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
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 3), (t) {
        _curIndex++;
        _pageController.animateToPage(
          _curIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      });
    }
  }

  /// 切换页面，并刷新小圆点
  _changePage() {
    Timer(Duration(milliseconds: 350), () {
      _pageController.jumpToPage(_curIndex);
    });
  }
}
