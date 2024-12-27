import 'package:flutter/material.dart';

/// 图片指示器
class NImageIndicator extends StatelessWidget {
  final PageController controller;
  final int itemCount;
  final Color indicatorColor;
  final Color indicatorOtherColor;
  final double maxSize;
  final double minSize;
  final double space;

  const NImageIndicator(
      {Key? key,
      required this.controller,
      required this.itemCount,
      this.indicatorColor = Colors.white70,
      this.indicatorOtherColor = Colors.white30,
      this.maxSize = 6,
      this.space = 16.0,
      this.minSize = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: _buildAnimatedItem);
  }

  Widget _buildAnimatedItem(BuildContext context, Widget? child) {
    //当前页数
    int index;
    //偏移量
    double? offset;

    //如果获取不了，则使用初始化的值,一般第一次渲染的时候无法获取到
    if (!controller.hasClients || controller.page == null) {
      index = controller.initialPage;
      offset = controller.initialPage.toDouble();
    } else {
      index = controller.page! ~/ 1;
      offset = controller.page;
    }
    return CustomPaint(
      size: Size(maxSize * _kMaxCircleCount + space * (_kMaxCircleCount - 1), maxSize),
      painter: ImageIndicatorPainter(
          itemCount: itemCount,
          indicatorColor: indicatorColor,
          indicatorOtherColor: indicatorOtherColor,
          maxSize: maxSize,
          minSize: minSize,
          pageIndex: index,
          space: space,
          pageOffset: offset! - index,
          isStart: (offset > index) && (index + _kMaxCircleCount - 1 < itemCount),
          isEnd: index + _kMaxCircleCount - 2 >= itemCount),
    );
  }
}

const _kMaxCircleCount = 3;

class ImageIndicatorPainter extends CustomPainter {
  final int? itemCount;
  final Color? indicatorColor;
  final Color? indicatorOtherColor;
  final double? maxSize;
  final double? minSize;
  final int? pageIndex;
  final double? pageOffset;
  final double? space;
  final bool? isStart;
  final bool? isEnd;

  const ImageIndicatorPainter(
      {this.itemCount,
      this.indicatorColor,
      this.indicatorOtherColor,
      this.maxSize,
      this.space,
      this.minSize,
      this.pageIndex,
      this.pageOffset,
      this.isStart,
      this.isEnd});

  @override
  void paint(Canvas canvas, Size size) {
    //初始化画笔
    Paint mPaint = Paint();
    //获取中间的圆点为第几个
    final _centerCircleIndex = _kMaxCircleCount ~/ 2;
    //获取每个圆点占据的大小，把widget分为3份
    double childWidth = size.width / _kMaxCircleCount;

    //遍历画圆点
    for (int i = 0; i < _kMaxCircleCount; i++) {
      // 当页数为0的时候，也就是第一页，不画第一个圆点
      if (pageIndex == 0 && i == 0) {
        continue;
      }
      if (isEnd! && i == _kMaxCircleCount - 1) {
        continue;
      }
      //画中心圆
      if (_centerCircleIndex == i) {
        mPaint = Paint()
          ..color = indicatorColor!
          ..isAntiAlias = true;
        canvas.drawCircle(Offset((i * childWidth) + (childWidth / 2) - childWidth * pageOffset!, childWidth / 2),
            maxSize! - (maxSize! - minSize!) * pageOffset!, mPaint..color = indicatorColor!);
      }
      //画左边的圆
      else if (i <= _centerCircleIndex) {
        mPaint = Paint()
          ..color = indicatorOtherColor!
          ..isAntiAlias = true;
        canvas.drawCircle(Offset((i * childWidth) + (childWidth / 2) - childWidth * pageOffset!, childWidth / 2),
            minSize! * (1 - pageOffset!), mPaint..color = indicatorOtherColor!);
      }
      //话右边的圆
      else {
        mPaint = Paint()
          ..color = indicatorOtherColor!
          ..isAntiAlias = true;
        canvas.drawCircle(Offset((i * childWidth) + (childWidth / 2) - childWidth * pageOffset!, childWidth / 2),
            minSize! + (maxSize! - minSize!) * pageOffset!, mPaint..color = indicatorOtherColor!);
      }
    }
    //向左移的时候画后面的圆
    if (isStart! && !isEnd!) {
      mPaint = Paint()
        ..color = indicatorOtherColor!
        ..isAntiAlias = true;
      canvas.drawCircle(
          Offset((_kMaxCircleCount * childWidth) + (childWidth / 2) - childWidth * pageOffset!, childWidth / 2),
          minSize! * pageOffset!,
          mPaint..color = indicatorOtherColor!);
    }
  }

  @override
  bool shouldRepaint(covariant ImageIndicatorPainter oldDelegate) {
    return itemCount != oldDelegate.itemCount ||
        indicatorColor != oldDelegate.indicatorColor ||
        indicatorOtherColor != oldDelegate.indicatorOtherColor ||
        maxSize != oldDelegate.maxSize ||
        minSize != oldDelegate.minSize ||
        space != oldDelegate.space ||
        pageIndex != oldDelegate.pageIndex ||
        pageOffset != oldDelegate.pageOffset ||
        isStart != oldDelegate.isStart ||
        isEnd != oldDelegate.isEnd;
  }
}
