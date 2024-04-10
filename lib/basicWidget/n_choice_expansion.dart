//
//  NSingleWrap.dart
//  yl_health_manage_app_v2.20.5
//
//  Created by shang on 2024/4/8 16:32.
//  Copyright © 2024/4/8 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/util/color_util.dart';


/// 筛选
class NChoiceExpansion<T> extends StatefulWidget {

  NChoiceExpansion({
    super.key,
    required this.title,
    this.titleStyle = const TextStyle(
      color: Color(0xff737373),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    required this.items,
    required this.titleCb,
    required this.selectedCb,
    required this.onSelected,
    this.isExpand = false,
    this.collapseCount = 6,
    this.onExpand,
    this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  /// 标题
  final String title;
  /// 标题字体样式
  final TextStyle? titleStyle;
  /// 组数据
  final List<T> items;
  /// 选择判断
  final bool Function(T e) selectedCb;
  /// 标题显示
  final String Function(T e) titleCb;

  /// 选择事件
  final ValueChanged<T> onSelected;
  /// 初始展开还是关闭
  final bool isExpand;
  /// 最小折叠值
  final int collapseCount;
  /// 折叠展开
  final ValueChanged<bool>? onExpand;
  /// 子项样式自定义
  final Widget Function(T e)? itemBuilder;
  /// 头部项目自定义
  final Widget Function(VoidCallback onToggle)? headerBuilder;
  /// 尾部自定义
  final Widget Function(VoidCallback onToggle)? footerBuilder;

  @override
  _NChoiceExpansionState<T> createState() => _NChoiceExpansionState<T>();
}

class _NChoiceExpansionState<T> extends State<NChoiceExpansion<T>> {

  late bool isExpand = widget.isExpand;

  final weChatSubTitleColor = Color(0xff737373);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hideExpandButton = (widget.items.length <= widget.collapseCount);

    final expandButton = Offstage(
      offstage: hideExpandButton,
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.only(
            left: 12,
            right: 6,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpand ? "收起" : "展开",
                style: TextStyle(
                  color: weChatSubTitleColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              Icon(
                isExpand? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: weChatSubTitleColor,
              ),
            ],
          ),
        ),
      ),
    );

    final items = isExpand
        ? widget.items
        : widget.items.take(6).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headerBuilder?.call(onToggle) ?? Padding(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 12,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: widget.titleStyle,
                ),
              ),
              expandButton,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            children: items.map((e) {
              return buildItem(e);
            }).toList(),
          ),
        ),
        widget.footerBuilder?.call(onToggle) ?? SizedBox(),
      ],
    );
  }

  Widget buildItem(T e) {
    final title = widget.titleCb(e);
    final isSelected = widget.selectedCb(e);

    return InkWell(
      onTap: () {
        widget.onSelected(e);
        setState(() {});
      },
      child: widget.itemBuilder?.call(e) ?? Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor.withOpacity(0.1) : bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
              width: 0.5,
              color: isSelected ? context.primaryColor : bgColor),
        ),
        child: NText(
          title,
          fontSize: 14,
          color: isSelected ? context.primaryColor : weChatSubTitleColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void onToggle() {
    isExpand = !isExpand;
    widget.onExpand?.call(isExpand);
    setState(() {});
  }
}
