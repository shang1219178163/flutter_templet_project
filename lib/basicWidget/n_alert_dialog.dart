//
//  n_alert_dialog.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:03 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NAlertDialog extends StatelessWidget {

  NAlertDialog({
    Key? key,
    this.header,
    this.content,
    this.footer,
    this.margin = const EdgeInsets.symmetric(horizontal: 30),
    this.actions,
    this.cancelButton,
    this.confirmButton,
    this.dividerColor,
  }) : assert(header != null || content != null),
        assert((actions != null || cancelButton != null || confirmButton != null)),
        super(key: key);

  Widget? header;

  Widget? content;

  Widget? footer;


  EdgeInsets margin;

  List<Widget>? actions;

  Widget? cancelButton;

  Widget? confirmButton;

  Color? dividerColor;


  @override
  Widget build(BuildContext context) {
    dividerColor ??= Theme.of(context).dividerColor;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular((10.0)), // 圆角度
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header!,
          if (content != null) content!,
          if (footer != null) footer!,
          Container(
            height: 0.5,
            color: dividerColor,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions?.map((e) => Expanded(child: e,),).toList()
                ?? [
              if (cancelButton != null) Expanded(child: cancelButton!,),
              Container(height: 55, child: VerticalDivider(color: dividerColor)),
              if (confirmButton != null) Expanded(child: confirmButton!,),
            ],
          ),
        ],
      ),
    );
  }

}
