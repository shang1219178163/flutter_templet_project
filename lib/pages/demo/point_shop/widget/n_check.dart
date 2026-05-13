//
//  NCheck.dart
//  projects
//
//  Created by shang on 2026/4/22 11:03.
//  Copyright © 2026/4/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 勾选组件
class NCheck extends StatelessWidget {
  const NCheck({
    super.key,
    required this.isSelected,
    this.size = 18,
  });

  /// 是否勾选
  final bool isSelected;

  /// 尺寸
  final double size;

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    final assetName = isSelected
        ? Assets.imagesIcCircleSelected
        : (themeProvider.isDark ? Assets.imagesIcCircleUnselected : Assets.imagesIcCircleSelected);

    return Image(
      image: AssetImage(assetName),
      width: size,
      height: size,
    );
  }
}
