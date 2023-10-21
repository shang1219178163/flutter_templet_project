


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NContextMenuRegion.dart';

class NContextMenu extends StatelessWidget{
  const NContextMenu({
    super.key,
    this.items = const [
      '保存',
      '分享',
      '编辑',
    ],
    required this.onItem,
    required this.child,
  });

  final List<String> items;

  final ValueChanged<String> onItem;

  final Widget child;


  @override
  Widget build(BuildContext context) {
    return NContextMenuRegion(
      contextMenuBuilder: (BuildContext context, Offset offset) {
        return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: TextSelectionToolbarAnchors(
              primaryAnchor: offset,
            ),
            buttonItems: items.map((e) => ContextMenuButtonItem(
              onPressed: () {
                onItem(e);
                ContextMenuController.removeAny();
              },
              label: e,
            )).toList()
        );
      },
      child: child,
    );
  }

}