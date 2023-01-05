//
//  NNAlertDialog.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:03 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NNAlertDialog extends StatelessWidget {

  NNAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.margin = const EdgeInsets.symmetric(horizontal: 30),
    this.actions,
    this.actionCancell,
    this.actionConfirm,
  }) : assert(title != null || content != null),
        assert((actions != null || actionCancell != null || actionConfirm != null)),
        super(key: key);

  Widget? title;
  Widget? content;

  EdgeInsets margin;
  List<Widget>? actions;
  Widget? actionCancell;
  Widget? actionConfirm;


  @override
  Widget build(BuildContext context) {
    double spacingVer = 8;
    double spacingHor = 15;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((10.0)), // 圆角度
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) Padding(
            padding: EdgeInsets.only(
              top: spacingVer,
              left: spacingHor,
              bottom: spacingVer,
              right: spacingHor
            ),
            child: title,
          ),
          if (content != null) Container(
            padding: EdgeInsets.only(
              left: spacingHor,
              bottom: spacingVer,
              right: spacingHor
            ),
            child: content,
          ),
          Container(
            height: 0.5,
            color: Colors.grey[400],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions != null ? actions!.map((e) => Expanded(child: e,),).toList()
                : [
              if (actionCancell != null) Expanded(child: actionCancell!,),
              Container(height: 55, child: VerticalDivider(color: Colors.grey[400])),
              if (actionConfirm != null) Expanded(child: actionConfirm!,),
            ],
          ),
        ],
      ),
    );
  }
}
