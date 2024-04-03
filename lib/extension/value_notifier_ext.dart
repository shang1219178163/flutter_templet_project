//
//  ValueNotifierExt.dart
//  yl_health_app
//
//  Created by shang on 2024/4/3 12:28.
//  Copyright © 2024/4/3 shang. All rights reserved.
//


import 'package:flutter/material.dart';

extension ValueNotifierExt on ValueNotifier<List> {

  /// 更新 List
  void update(){
    value = [...value];
  }
}

extension ValueNotifierMapExt on ValueNotifier<Map> {

  /// 更新 map
  void update(){
    value = {...value};
  }
}