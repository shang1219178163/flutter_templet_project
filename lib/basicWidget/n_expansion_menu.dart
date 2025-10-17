import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/en_expansion_tile.dart';
import 'package:flutter_templet_project/util/app_color.dart';

/// 业务折叠菜单
class NExpansionMenu extends StatefulWidget {
  const NExpansionMenu({
    Key? key,
    required this.title,
    this.children,
    this.isExpand = true,
    this.onExpansionChanged,
    this.color = const Color(0xffFF7E6E),
    this.disable = false,
    this.header,
    this.indicatorBuilder,
    this.trailingBuilder,
    this.childrenHeader,
    this.childrenFooter,
  }) : super(key: key);

  final String title;

  final List<Widget>? children;

  final bool isExpand;

  final ValueChanged<bool>? onExpansionChanged;

  final Color color;

  /// 是否不可收起 isExpand 应为 true
  final bool disable;

  /// 标题前指示器
  final Widget Function(bool isExpand)? indicatorBuilder;

  /// 尾部折叠标志
  final Widget Function(bool isExpand)? trailingBuilder;

  /// 头部组件
  final ExpansionWidgetBuilder? header;

  /// 折叠区域头部
  final ExpansionWidgetBuilder? childrenHeader;

  /// 折叠区域尾部
  final ExpansionWidgetBuilder? childrenFooter;

  @override
  NExpansionMenuState createState() => NExpansionMenuState();
}

class NExpansionMenuState extends State<NExpansionMenu> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnExpansionTile(
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.circular(4),
        header: widget.header,
        childrenHeader: widget.childrenHeader,
        childrenFooter: widget.childrenFooter,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        trailing: widget.disable
            ? const SizedBox()
            : buildExpandMenuTrailing(
                isExpand: widget.isExpand,
                color: widget.color,
              ),
        collapsedTextColor: AppColor.fontColor,
        textColor: AppColor.fontColor,
        iconColor: widget.color,
        collapsedIconColor: widget.color,
        title: Row(
          children: [
            widget.indicatorBuilder?.call(widget.isExpand) ?? SizedBox(),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: AppColor.fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        initiallyExpanded: widget.disable ? false : widget.isExpand,
        onExpansionChanged: widget.onExpansionChanged,
        children: widget.children ??
            <Widget>[
              Container(),
            ],
      ),
    );
  }

  Widget buildExpandMenuTrailing({
    bool isExpand = true,
    Color? color = Colors.blueAccent,
  }) {
    if (widget.trailingBuilder != null) {
      return widget.trailingBuilder!(isExpand);
    }

    // final title = isExpand ? "收起" : "展开";
    final icon =
        isExpand ? Icon(Icons.expand_less, size: 24, color: color) : Icon(Icons.expand_more, size: 24, color: color);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: icon,
    );
  }
}
