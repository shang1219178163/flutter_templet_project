//
//  NBackButton.dart
//  projects
//
//  Created by shang on 2025/12/18 18:18.
//  Copyright © 2025/12/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 全局返回按钮
class NBackButton extends StatelessWidget {
  const NBackButton({
    super.key,
    this.size = 18,
    this.color,
    this.onPressed,
  });

  final double? size;

  final Color? color;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.transparent,
          // border: Border.all(color: Colors.blue),
          ),
      child: IconButton(
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            },
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
