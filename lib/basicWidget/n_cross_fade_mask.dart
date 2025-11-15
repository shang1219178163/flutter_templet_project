//
//  NCrossFadeMask.dart
//  projects
//
//  Created by shang on 2025/9/28 14:42.
//  Copyright © 2025/9/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cross_fade.dart';

/// 遮罩折叠器
class NCrossFadeMask<T> extends StatelessWidget {
  const NCrossFadeMask({
    super.key,
    required this.items,
    this.max = 3,
    this.isExpand = false,
    this.expandTitle = "展开",
    this.collapseTitle = "收起",
    required this.first,
    required this.secondChild,
  });

  final List<T> items;

  /// 最多显示数量
  final int max;

  final bool isExpand;
  final String expandTitle;
  final String collapseTitle;

  /// 未展开时
  final Widget Function(int limit) first;

  /// 展开时
  final Widget Function(VoidCallback onToggle) secondChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final expandColor = Color(0xff5871F5);

    return NCrossFade(
      isFirst: true,
      onChanged: (v) {
        DLog.d("onChanged: $v");
      },
      firstChild: (onToggle) {
        final limit = items.length.clamp(0, max);

        return Stack(
          children: [
            first(limit),
            // if (items.length > max)
            //   Positioned.fill(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         // border: Border.all(color: Colors.blue),
            //         gradient: LinearGradient(
            //           begin: Alignment.topCenter, // CSS 90deg 相当于从左到右
            //           end: Alignment.bottomCenter,
            //           colors: [Colors.transparent,Color(0xff242434],
            //         ),
            //       ),
            //     ),
            //   ),
            if (items.length > max)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.blue),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, // CSS 90deg 相当于从左到右
                      end: Alignment.bottomCenter,
                      colors: [
                        (isDark ? Color(0xff242434) : const Color(0xffF9F9F9)).withOpacity(0),
                        (isDark ? Color(0xff242434) : const Color(0xffF9F9F9)).withOpacity(0),
                        (isDark ? Color(0xff242434) : const Color(0xffF9F9F9)).withOpacity(0),
                      ],
                      stops: [0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
            if (items.length > max)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.blue),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, // CSS 90deg 相当于从左到右
                        end: Alignment.bottomCenter,
                        colors: [
                          (isDark ? Color(0xff28283B) : Color(0xffF9F9F9)).withOpacity(0),
                          (isDark ? Color(0xff28283B) : Color(0xffF9F9F9)).withOpacity(1.0),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          expandTitle,
                          style: TextStyle(fontSize: 12, color: expandColor),
                        ),
                        SizedBox(width: 4),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 9,
                            color: expandColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      secondChild: (onToggle) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          secondChild(onToggle),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                // border: Border.all(color: Colors.blue),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    collapseTitle,
                    style: TextStyle(fontSize: 12, color: expandColor),
                  ),
                  const SizedBox(width: 4),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 9,
                      color: expandColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
