//
//  NSingleWrap.dart
//  yl_health_manage_app_v2.20.5
//
//  Created by shang on 2024/4/8 16:32.
//  Copyright © 2024/4/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 筛选
class NChoiceExpansion<T> extends StatefulWidget {
  NChoiceExpansion({
    super.key,
    this.controller,
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

  /// 控制器
  final NChoiceExpansionController? controller;

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
  final Widget? Function(T e, bool isSelected)? itemBuilder;

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
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    widget.controller?._attach(this);
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant NChoiceExpansion<T> oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   final tmp = oldWidget.items.map((e) => "${widget.titleCb(e)}_${widget.selectedCb(e)}").join(",");
  //   final tmpNew = widget.items.map((e) => "${widget.titleCb(e)}_${widget.selectedCb(e)}").join(",");
  //   // if (tmp != tmpNew) {
  //   //   setState(() {});
  //   // }
  //
  //   DLog.d("tmp: $tmp");
  //   DLog.d("tmpNew: $tmpNew");
  // }

  @override
  Widget build(BuildContext context) {
    final items = isExpand ? widget.items : widget.items.take(6).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headerBuilder?.call(onToggle) ??
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: widget.titleStyle,
                    ),
                  ),
                  buildExpandButton(),
                ],
              ),
            ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((e) {
            return buildItem(e);
          }).toList(),
        ),
        widget.footerBuilder?.call(onToggle) ?? SizedBox(),
      ],
    );
  }

  Widget buildItem(T e) {
    final title = widget.titleCb(e);
    final isSelected = widget.selectedCb(e);
    // DLog.d("buildItem: ${title}, $isSelected");

    return InkWell(
      onTap: () {
        widget.onSelected(e);
        setState(() {});
      },
      child: widget.itemBuilder?.call(e, isSelected) ??
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? context.primaryColor.withOpacity(0.1) : AppColor.bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(width: 0.5, color: isSelected ? context.primaryColor : AppColor.bgColor),
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

  /// 折叠展开按钮
  Widget buildExpandButton() {
    final hideExpandButton = (widget.items.length <= widget.collapseCount);

    final expandButton = Offstage(
      offstage: hideExpandButton,
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 4,
            bottom: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border: Border.all(color: Colors.blue),
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
                isExpand ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: weChatSubTitleColor,
              ),
            ],
          ),
        ),
      ),
    );
    return expandButton;
  }

  void onToggle() {
    isExpand = !isExpand;
    widget.onExpand?.call(isExpand);
    setState(() {});
  }
}

/// NFilterDropBox 组件控制器,将 State 的私有属性或者方法暴漏出去
class NChoiceExpansionController {
  _NChoiceExpansionState? _anchor;

  void onToggle() {
    assert(_anchor != null);
    _anchor!.onToggle();
  }

  Widget buildExpandButton() {
    assert(_anchor != null);
    return _anchor!.buildExpandButton();
  }

  void _attach(_NChoiceExpansionState anchor) {
    _anchor = anchor;
  }

  void _detach(_NChoiceExpansionState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
