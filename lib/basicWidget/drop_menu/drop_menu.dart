//
//  DropMenu.dart
//  projects
//
//  Created by shang on 2026/1/30 10:01.
//  Copyright © 2026/1/30 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 下拉菜单
class DropMenu {
  static final DropMenu _instance = DropMenu._();
  DropMenu._();
  factory DropMenu() => _instance;
  static DropMenu get instance => _instance;

  final LayerLink _layerLink = LayerLink();
  LayerLink get layerLink => _layerLink;

  OverlayEntry? _overlayEntry;

  /// 溢出图层
  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 展示图层
  void showFollower({
    required BuildContext context,
    required List<String> items,
    Widget? child,
    NullableIndexedWidgetBuilder? itemBuilder,
    required ValueChanged<int> onSelected,
    VoidCallback? onCancel,
    Alignment targetAnchor = Alignment.bottomCenter,
    Alignment followerAnchor = Alignment.topCenter,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color242434OrWhite = isDark ? Color(0xFF242434) : Colors.white;
    final inverseColor = isDark ? Colors.white : Colors.black;

    if (_overlayEntry != null) {
      removeOverlay();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Center(
          child: CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            child: child ??
                GestureDetector(
                  onTap: removeOverlay,
                  child: Container(
                    width: 70,
                    // height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color242434OrWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: inverseColor.withOpacity(0.12),
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: itemBuilder ??
                          (context, index) {
                            return Center(
                              child: TextButton(
                                onPressed: () {
                                  removeOverlay();
                                  onSelected(index);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(70, 38),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  items[index],
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 1,
                                ),
                              ),
                            );
                          },
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                    ),
                  ),
                ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget buildTarget({required Widget child}) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: child,
    );
  }
}
