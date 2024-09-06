//
//  NSearchBar.dart
//  projects
//
//  Created by shang on 2024/8/26 10:44.
//  Copyright © 2024/8/26 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 带搜索框和取消按钮
class NSearchBar extends StatelessWidget {
  const NSearchBar({
    super.key,
    this.placeholder = "搜索",
    this.backgroundColor,
    required this.onChanged,
    this.onCancel,
  });

  final String placeholder;
  final Color? backgroundColor;

  final ValueChanged<String> onChanged;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final textfield = NSearchTextField(
      autofocus: false,
      backgroundColor: backgroundColor ?? Colors.white,
      placeholder: placeholder,
      onChanged: onChanged,
    );
    if (onCancel == null) {
      return textfield;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: textfield,
        ),
        InkWell(
          onTap: onCancel,
          child: Container(
            height: 36,
            padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
            alignment: Alignment.center,
            child: const NText(
              '取消',
              fontSize: 15,
              color: fontColor,
            ),
          ),
        ),
      ],
    );
  }
}
