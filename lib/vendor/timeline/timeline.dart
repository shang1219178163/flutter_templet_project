import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/timeline/timeline_element.dart';

class TimelineComponent extends StatefulWidget {
  ///timeline 数据实体list
  final List timelineList;

  ///时间轴颜色
  final Color lineColor;
  final double? height;

  ///组件背景颜色 默认white
  final Color backgroundColor;

  ///标题样式
  final TextStyle? titleStyle;

  ///副标题样式
  final TextStyle? subtitleStyle;

  ///描述样式
  final TextStyle? descriptionStyle;

  ///时间轴左侧是否展示
  final bool? leftContent;

  ///参数实例化
  const TimelineComponent({
    Key? key,
    required this.timelineList,
    this.lineColor = Colors.black12,
    this.backgroundColor = Colors.white,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.leftContent,
    this.height,
  }) : super(key: key);

  @override
  TimelineComponentState createState() {
    return TimelineComponentState();
  }
}

class TimelineComponentState extends State<TimelineComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  double fraction = 0.0;

  @override
  void initState() {
    super.initState();

    ///初始化timeline线条动画效果
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///构建timeline Widget实体
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      child: ListView.builder(
        ///ListView嵌套使用时shrinkWrap必须设置为true 否则页面白屏
        shrinkWrap: true,

        ///禁用滚动 避免影响父页面滚动事件
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.timelineList.length,
        itemBuilder: (_, index) {
          return TimelineElement(
            lineColor: widget.lineColor,
            backgroundColor: widget.backgroundColor,
            model: widget.timelineList[index],
            firstElement: index == 0,
            lastElement: widget.timelineList.length == index + 1,
            controller: controller,
            titleStyle: widget.titleStyle,
            subtitleStyle: widget.subtitleStyle,
            leftContent: widget.leftContent,
            height: widget.height,
            descriptionStyle: widget.descriptionStyle,
          );
        },
      ),
    );
  }
}
