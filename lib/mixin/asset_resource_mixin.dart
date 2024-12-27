//
//  AssetResourceMixin.dart
//  AssetResourceMixin
//
//  Created by shang on 2024/6/12 11:12.
//  Copyright © 2024/6/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// 滚动方向改变监听
mixin AssetResourceMixin<T extends StatefulWidget> on State<T> {
  /// 宽容序曲
  var kuanRong = "";

  @override
  void initState() {
    super.initState();

    _initData();
  }

  _initData() async {
    kuanRong = await _loadData();
  }

  Future<String> _loadData() async {
    final response = await rootBundle.loadString('assets/data/kuan_rong.txt');
    return response;
  }
}
