// circle_layout.dart

import 'dart:math';

import 'package:flutter/material.dart';

class CircleLayout extends StatelessWidget {
  final List<Widget> children;

  /// 初始角度
  final double initAngle;

  /// 排列方向
  final bool reverse;

  /// 缩放子部件圆心到容器圆心的距离
  final double radiusRatio;

  /// 一个使子组件呈现圆状布局的Layout
  ///
  /// * [reverse] 用来控制子部件的排列方向 false表示顺时针排列 true表示逆时针排列
  ///
  /// * [initAngle] 用来来设置第一个子部件的位置 0 ~ 360之间
  ///
  /// * [radiusRatio] 用来调节子部件圆心与容器圆心的距离
  ///
  const CircleLayout({
    Key? key,
    required this.children,
    this.reverse = false,
    this.radiusRatio = 1.0,
    this.initAngle = 0,
  })  : assert(0.0 <= radiusRatio && radiusRatio <= 1.0),
        assert(0 <= initAngle && initAngle <= 360),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _RingDelegate(
          count: children.length,
          initAngle: initAngle,
          reverse: reverse,
          radiusRatio: radiusRatio),
      children: [
        for (int i = 0; i < children.length; i++)
          LayoutId(id: i, child: children[i])
      ],
    );
  }
}

class _RingDelegate extends MultiChildLayoutDelegate {
  final double initAngle;
  final bool reverse;
  final int count;
  final double radiusRatio;

  _RingDelegate({
    required this.initAngle,
    required this.reverse,
    required this.count,
    required this.radiusRatio,
  });

  @override
  void performLayout(Size size) {
    /// 中心点坐标
    Offset centralPoint = Offset(size.width / 2, size.height / 2);

    /// 容器半径参考值
    double fatherRadius = min(size.width, size.height) / 2;

    double childRadius = _getChildRadius(fatherRadius, 360 / count);

    Size constraintsSize = Size(childRadius * 2, childRadius * 2);

    /// 遍历child获取他们所需的空间,得到最宽child的宽度以及最高child的高度
    /// 用来计算一个可用半径r
    /// r = 父容器给定的半径 - 最大子部件的"半径"
    List<Size> sizeCache = [];
    double largersRadius = 0;
    for (int i = 0; i < count; i++) {
      if (!hasChild(i)) break;

      Size childSize = layoutChild(i, BoxConstraints.loose(constraintsSize));
      // 缓存所有子部件尺寸 备用
      sizeCache.add(Size.copy(childSize));

      double _radius = max(childSize.width, childSize.height) / 2;
      largersRadius = _radius > largersRadius ? _radius : largersRadius;
    }
    fatherRadius -= largersRadius;

    /// 摆放组件
    for (int i = 0; i < count; i++) {
      if (!hasChild(i)) break;

      Offset offset = _getChildCenterOffset(
          centerPoint: centralPoint,
          radius: fatherRadius * radiusRatio,
          which: i,
          count: count,
          initAngle: initAngle,
          direction: reverse ? -1 : 1);
      // 由于绘制方向是lt-rb, 为了避免绘制时超出父容器边界所以还需要去掉子控件自身的"半径"
      double cr = max(sizeCache[i].width, sizeCache[i].height) / 2;
      offset -= Offset(cr, cr);

      positionChild(i, offset);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}

/// 获得子部件中心点在容器中的偏移量
///
///  [centerPoint] 容器中心点
///
/// * [radius] 容器半径
///
/// * [which] 第几个child
///
/// * [count] 子部件总数
///
/// * [initAngle] 用来决定起始位置,建议取值范围0-360
///
/// * [direction] 用来决定排列方向 1顺时针,-1逆时针
///
Offset _getChildCenterOffset({
  required Offset centerPoint,
  required double radius,
  required int which,
  required int count,
  required double initAngle,
  required int direction,
}) {
  /// 圆心坐标(a, b)
  /// 半径: r
  /// 弧度: radian (π / 180 * 角度)
  ///
  /// 求圆上任一点为(x, y)
  /// 则
  /// x = a + r * cos(radian)
  /// y = b + r * sin(radian)
  double radian = _radian(360 / count);
  double radianOffset = _radian(360 + initAngle * direction);
  double x = centerPoint.dx + radius * cos(radian * which + radianOffset);
  double y = centerPoint.dy + radius * sin(radian * which + radianOffset);
  return Offset(x, y);
}

/// 获取child半径
/// 根据扇形半径内最大圆公式计算
double _getChildRadius(double r, double a) {
  /// 大于180因为只放了一个child，因为公式无法计算钝角直接return容器半径算了。
  if (a > 180) return r;

  /// 扇形的半径为R，扇形的圆心角为A，扇形的内切圆的半径为r。
  /// SIN(A/2)=r/(R-r)
  /// r=(R-r)*SIN(A/2)
  /// r=R*SIN(A/2)-r*SIN(A/2)
  /// r+r*SIN(A/2)=R*SIN(A/2)
  /// r=(R*SIN(A/2))/(1+SIN(A/2))
  return (r * sin(_radian(a / 2))) / (1 + sin(_radian(a / 2)));
}

/// 角度转换弧度
double _radian(double angle) {
  return pi / 180 * angle;
}
