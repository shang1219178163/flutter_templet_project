//
//  AppLifecycleStateMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/14 09:18.
//  Copyright © 2024/9/14 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 搜索栏防抖
mixin SearchDebounceMixin<T extends StatefulWidget, E> on State<T> {
  /// searchStreamController
  StreamController<E> _searchStreamController = StreamController<E>();
  StreamController<E> get searchStreamController => _searchStreamController;
  set searchStreamController(StreamController<E> value) {
    _searchStreamController = value;
  }

  /// 搜索去重时间区间
  Duration _searchDebounceTime = Duration(milliseconds: 500);
  Duration get searchDebounceTime => _searchDebounceTime;
  set searchDebounceTime(Duration value) {
    _searchDebounceTime = value;
  }

  @override
  void dispose() {
    searchStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchStreamController.stream.debounceTime(searchDebounceTime).distinct().listen(onSearchChanged);
  }

  /// 加入新值
  void searchStreamSink(E v) {
    searchStreamController.add(v);
  }

  /// 搜索去重回调
  void onSearchStreamChanged(E v) => throw UnimplementedError("❌$this onSearchChanged");
}
