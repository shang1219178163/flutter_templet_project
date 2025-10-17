import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class NSlidableTabbar extends StatefulWidget {
  const NSlidableTabbar({
    super.key,
    required this.items,
    required this.onChanged,
    this.height = 36,
    this.backgroudColor = const Color(0xffF6F6F6),
    this.color = AppColor.cancelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
  });

  final List<String> items;
  final ValueChanged<int> onChanged;
  final double height;
  final Color backgroudColor;
  final Color color;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  State<NSlidableTabbar> createState() => _NSlidableTabbarState();
}

class _NSlidableTabbarState extends State<NSlidableTabbar> with TickerProviderStateMixin {
  late final items = widget.items;
  late final controller = TabController(length: items.length, vsync: this);
  int index = 0;

  @override
  void initState() {
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        widget.onChanged(controller.index);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.height * 0.5;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroudColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TabBar(
        controller: controller,
        dividerHeight: 0,
        labelColor: widget.color,
        labelStyle: widget.labelStyle ?? TextStyle(fontSize: 12),
        unselectedLabelStyle: widget.unselectedLabelStyle ?? TextStyle(fontSize: 12, color: AppColor.fontColor333333),
        tabAlignment: TabAlignment.fill,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        indicator: BoxDecoration(
          color: widget.color.withOpacity(0.1),
          border: Border.all(color: widget.color, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        tabs: items.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
