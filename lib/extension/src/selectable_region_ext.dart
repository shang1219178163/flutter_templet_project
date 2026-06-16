//
//  SelectableRegionExt.dart
//  flutter_templet_project
//
//  Created by shang on 2026/6/16 18:36.
//  Copyright © 2026/6/16 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension SelectableRegionExt on SelectableRegion {
  /// 文字消息上下文菜单
  static Widget editableTextContextMenu(BuildContext context, EditableTextState state) {
    final anchors = state.contextMenuAnchors;
    final style = TextStyle(color: context.themeData.colorScheme.primary);
    final children = [
      TextButton(
        onPressed: () {
          state.copySelection(SelectionChangedCause.toolbar);
        },
        child: Text('复制', style: style),
      ),
      TextButton(
        onPressed: () {
          state.selectAll(SelectionChangedCause.toolbar);
        },
        child: Text('全选', style: style),
      ),
      TextButton(
        onPressed: () {
          state.searchWebForSelection(SelectionChangedCause.toolbar);
        },
        child: Text('搜索', style: style),
      ),
      TextButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          state.hideToolbar();
        },
        child: Text('取消', style: style),
      ),
    ];
    return CupertinoTextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor == null ? anchors.primaryAnchor : anchors.secondaryAnchor!,
      children: children,
    );
    // return AdaptiveTextSelectionToolbar(
    //   anchors: editableTextState.contextMenuAnchors,
    //   children: children
    // );
  }

  /// 文字消息上下文菜单
  static Widget selectableRegionContextMenu(BuildContext context, SelectableRegionState state) {
    final anchors = state.contextMenuAnchors;
    return CupertinoTextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
      children: [
        CupertinoTextSelectionToolbarButton.text(
          onPressed: () {
            state.copySelection(SelectionChangedCause.toolbar);
          },
          text: '复制',
        ),
        CupertinoTextSelectionToolbarButton.text(
          onPressed: () {
            state.selectAll(SelectionChangedCause.toolbar);
          },
          text: '全选',
        ),
        CupertinoTextSelectionToolbarButton.text(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            state.hideToolbar();
          },
          text: '取消',
        ),
      ],
    );
  }
}
