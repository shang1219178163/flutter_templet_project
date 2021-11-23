//
//  button_extension.dart
//  fluttertemplet
//
//  Created by shang on 7/1/21 5:44 PM.
//  Copyright © 7/1/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

extension ButtonStyleExt on ButtonStyle {

  ///边框线加圆角
  static outline({BorderRadius borderRadius = BorderRadius.zero, required Color borderColor}) {
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide(color: borderColor)
            )
        )
    );
  }
}