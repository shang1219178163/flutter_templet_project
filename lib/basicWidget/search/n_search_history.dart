//
//  NSearchHistory.dart
//  projects
//
//  Created by shang on 2026/4/13 17:24.
//  Copyright © 2026/4/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 搜索历史 keyword 集合
class NSearchHistory extends StatefulWidget {
  const NSearchHistory({
    super.key,
    required this.items,
    required this.onSelected,
    required this.onClear,
  });

  /// 历史
  final List<String> items;

  /// 选择
  final void Function(String v) onSelected;

  /// 清除全部
  final void Function() onClear;

  @override
  State<NSearchHistory> createState() => _NSearchHistoryState();
}

class _NSearchHistoryState extends State<NSearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.items.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "搜索历史",
                  ),
                ),
                IconButton(
                  onPressed: widget.onClear,
                  icon: Icon(Icons.delete_outline),
                )
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(
                widget.items.length,
                (int index) {
                  final item = widget.items[index];
                  return GestureDetector(
                    onTap: () {
                      widget.onSelected(item);
                    },
                    child: IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F7F7),
                          borderRadius: const BorderRadius.all(Radius.circular(28)),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: Text(
                          widget.items[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7C7C85),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
