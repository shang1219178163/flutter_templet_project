//
//  NFilterDropBox.dart
//  yl_health_app_v2.20.5
//
//  Created by shang on 2024/4/9 18:28.
//  Copyright © 2024/4/9 shang. All rights reserved.
//

// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class NFilterDropBox extends StatefulWidget {
  NFilterDropBox({
    super.key,
    this.controller,
    required this.sections,
    required this.onCancel,
    required this.onReset,
    required this.onConfirm,
    this.onVisible,
    this.stackAlignment = AlignmentDirectional.topStart,
    this.stackTextDirection,
    this.stackFit = StackFit.loose,
    this.stackClipBehavior = Clip.hardEdge,
    this.contentAlignment = Alignment.topCenter,
    this.width,
    this.heightFactor = 0.6,
    this.barrierColor,
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    required this.child,
    this.header,
    this.footer,
    this.buttonBar,
  });

  /// 控制器
  final NFilterDropBoxController? controller;

  /// 筛选项
  final List<Widget> sections;
  final VoidCallback onCancel;
  final VoidCallback onReset;
  final VoidCallback onConfirm;

  /// stack alignment
  final AlignmentGeometry stackAlignment;

  /// stack textDirection
  final TextDirection? stackTextDirection;

  /// stack fit
  final StackFit stackFit;

  /// stack clipBehavior
  final Clip stackClipBehavior;

  /// 对齐方式
  final Alignment contentAlignment;

  /// 宽度
  final double? width;

  /// 高度比例
  final double? heightFactor;

  /// 背景色
  final Color? barrierColor;

  /// 圆角
  final BorderRadius borderRadius;

  /// 折叠展开
  final ValueChanged<bool>? onVisible;

  final Widget Function(BuildContext context)? header;
  final Widget Function(BuildContext context)? footer;

  final Widget Function(BuildContext context, Widget buttonBar)? buttonBar;

  final Widget child;

  @override
  State<NFilterDropBox> createState() => _NFilterDropBoxState();
}

class _NFilterDropBoxState extends State<NFilterDropBox> {
  final scrollController = ScrollController();

  var isVisible = ValueNotifier(false);

  @override
  void dispose() {
    widget.controller?._detach(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.controller?._attach(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.stackAlignment,
      textDirection: widget.stackTextDirection,
      fit: widget.stackFit,
      clipBehavior: widget.stackClipBehavior,
      children: [
        widget.child,
        ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (context, bool value, child) {
            if (!value) {
              return SizedBox();
            }

            return Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: child ?? SizedBox(),
            );
          },
          child: buildDropBox(),
        ),
      ],
    );
  }

  Widget buildDropBox() {
    final buttonBar = buildDropBoxButtonBar(
      borderRadius: widget.borderRadius,
      onCancel: widget.onReset,
      onConfirm: widget.onConfirm,
    );

    return GestureDetector(
      onTap: widget.onCancel,
      child: Container(
        alignment: widget.contentAlignment,
        decoration: BoxDecoration(
          color: widget.barrierColor ??
              Theme.of(context).bottomSheetTheme.modalBarrierColor ??
              Colors.black.withOpacity(0.2),
        ),
        child: InkWell(
          onTap: () {
            // debugPrint("拦截展示内容背景事件");
          },
          child: FractionallySizedBox(
            heightFactor: widget.heightFactor,
            child: Container(
              // width: double.maxFinite,
              width: widget.width,
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.blue),
                borderRadius: widget.borderRadius,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              widget.header?.call(context) ?? const Divider(height: 1, color: AppColor.lineColor),
                              ...widget.sections,
                              widget.footer?.call(context) ?? const Divider(height: 1, color: AppColor.lineColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.buttonBar?.call(context, buttonBar) ?? buttonBar,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildDvider() {
  //   return Container(
  //     height: 8,
  //     margin: const EdgeInsets.only(top: 15),
  //     color: Color(0xffF3F3F3),
  //   );
  // }

  /// 筛选弹窗 取消确认菜单
  Widget buildDropBoxButtonBar({
    BorderRadius? borderRadius,
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ??
          const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
      child: NFooterButtonBar(
        padding: EdgeInsets.only(
          top: 12,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xffE5E5E5), width: 0.5)),
        ),
        cancelTitle: "重置",
        confirmTitle: "确定",
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
    );
  }

  void onToggle() {
    isVisible.value = !isVisible.value;
    widget.onVisible?.call(isVisible.value);
  }
}

/// NFilterDropBox 组件控制器,将 State 的私有属性或者方法暴漏出去
class NFilterDropBoxController {
  _NFilterDropBoxState? _anchor;

  void onToggle() {
    assert(_anchor != null);
    _anchor!.onToggle();
  }

  bool get isVisible {
    assert(_anchor != null);
    return _anchor!.isVisible.value;
  }

  void _attach(_NFilterDropBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(_NFilterDropBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
