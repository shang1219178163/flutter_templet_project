//
//  NTextFieldListItem.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 效果展示用的标签 + [TextField] 行；右侧有清除按钮。
class NTextFieldListItem extends StatefulWidget {
  const NTextFieldListItem({
    super.key,
    required this.title,
    required this.controller,
    this.onChanged,
    this.hintText = "请输入",
    this.showTopGap = false,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.onTapOutside,
  });

  /// 标签
  final Widget title;

  /// 输入控制器
  final TextEditingController controller;

  /// 文本变化
  final ValueChanged<String>? onChanged;

  /// 占位
  final String? hintText;

  /// 是否在顶部插入 8pt 间距
  final bool showTopGap;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 键盘动作
  final TextInputAction? textInputAction;

  /// 密文
  final bool obscureText;

  /// 最大行数
  final int maxLines;

  /// 只读
  final bool readOnly;

  /// 是否启用
  final bool enabled;

  /// 焦点；未传时使用内部 [FocusNode]
  final FocusNode? focusNode;

  /// 点击输入框外；默认 [_NTextFieldListItemState._onTapOutside] 会失焦
  final TapRegionCallback? onTapOutside;

  @override
  State<NTextFieldListItem> createState() => _NTextFieldListItemState();
}

class _NTextFieldListItemState extends State<NTextFieldListItem> {
  FocusNode? _focusNode;

  FocusNode get effectiveFocusNode => widget.focusNode ?? _focusNode!;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode == null ? FocusNode() : null;
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  void _onTapOutside(PointerDownEvent event) {
    effectiveFocusNode.unfocus();
    widget.onTapOutside?.call(event);
  }

  void _onClear() {
    widget.controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
      fontFamily: 'monospace',
      fontSize: 12.5,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTopGap) const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DefaultTextStyle.merge(
            style: labelStyle,
            child: widget.title,
          ),
        ),
        TextField(
          controller: widget.controller,
          focusNode: effectiveFocusNode,
          onTapOutside: _onTapOutside,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            suffixIcon: widget.enabled && !widget.readOnly
                ? ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, _) {
                      if (widget.controller.text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        tooltip: '清除',
                        onPressed: _onClear,
                        icon: const Icon(Icons.clear),
                      );
                    },
                  )
                : null,
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
