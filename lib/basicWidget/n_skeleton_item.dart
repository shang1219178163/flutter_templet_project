//
//  NSkeletonItem.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/2 00:40.
//  Copyright © 2024/3/2 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NSkeletonItem extends StatelessWidget {
  /// Scrollable direction.
  final Axis direction;

  const NSkeletonItem({
    super.key,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    // final backgroundColor = themeData.colorScheme.surfaceVariant;
    final foregroundColor = themeData.colorScheme.surface;

    final backgroundColor = Colors.black.withOpacity(0.05);

    if (direction == Axis.vertical) {
      return Card(
        elevation: 0,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                height: 80,
                width: 80,
                color: foregroundColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 24),
                      height: 12,
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      color: foregroundColor,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      height: 12,
                      width: 80,
                      color: foregroundColor,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 12,
                      width: 80,
                      color: foregroundColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      elevation: 0,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 80,
              width: 80,
              color: foregroundColor,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8, bottom: 24),
                    width: 12,
                    height: double.infinity,
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    color: foregroundColor,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    width: 12,
                    height: 80,
                    color: foregroundColor,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 12,
                    height: 80,
                    color: foregroundColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
