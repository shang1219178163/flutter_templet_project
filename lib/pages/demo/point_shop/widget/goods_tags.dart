//
//  GoodsTags.dart
//  projects
//
//  Created by shang on 2026/4/21 12:09.
//  Copyright © 2026/4/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 商品标签
class GoodsTags<T> extends StatelessWidget {
  const GoodsTags({
    super.key,
    required this.items,
    required this.nameCb,
  });

  final List<T> items;
  final String Function(T e) nameCb;

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...items.map((e) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: ShapeDecoration(
              color: Color(0xFFEFEFEF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            ),
            child: Text(
              nameCb(e),
              style: TextStyle(
                color: themeProvider.subtitleColor,
                fontSize: 12,
                fontFamily: 'PingFang SC',
                height: 0,
              ),
            ),
          );
        }),
      ],
    );
  }
}
