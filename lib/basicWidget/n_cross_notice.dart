//
//  NCrossNotice.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/17 21:27.
//  Copyright © 2025/1/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cross_fade.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

/// 提示信息
class NCrossNotice extends StatelessWidget {
  const NCrossNotice({
    super.key,
    required this.childBuilder,
    this.arrowHeight = 20,
  });

  final Widget Function(bool isExpand) childBuilder;
  final double arrowHeight;

  @override
  Widget build(BuildContext context) {
    return NCrossFade(
      firstChild: (onToggle) => buildCrossChild(onTap: onToggle, isExpand: false),
      secondChild: (onToggle) => buildCrossChild(onTap: onToggle, isExpand: true),
      isFirst: true,
    );
  }

  Widget buildCrossChild({
    VoidCallback? onTap,
    required bool isExpand,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: arrowHeight / 2 + 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // border: Border.all(color: Colors.blue),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          // mainAxisSize: MainAxisSize.min,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.blue),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44CCCCCC),
                    blurRadius: 6,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: childBuilder(isExpand),
            ),
            Positioned(
              left: 150,
              right: 150,
              bottom: -arrowHeight / 2,
              child: Container(
                height: arrowHeight,
                // clipBehavior: Clip.none,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(arrowHeight / 2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x44CCCCCC),
                      blurRadius: 6,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: Icon(isExpand ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
