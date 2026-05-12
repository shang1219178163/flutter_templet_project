//
//  DebounceStreamMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/11 17:16.
//  Copyright © 2026/5/11 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// stream 防抖去重
///
/// with DebounceStreamMixin<NInputAccessoryViewNew, double>
mixin DebounceStreamMixin<T extends StatefulWidget, E> on State<T> {
  /// debounceStreamController
  StreamController<E> _debounceStreamController = StreamController<E>();
  StreamController<E> get debounceStreamController => _debounceStreamController;
  set debounceStreamController(StreamController<E> value) {
    _debounceStreamController = value;
  }

  /// 防抖区间
  Duration _debounceDuration = Duration(milliseconds: 500);
  Duration get debounceDuration => _debounceDuration;
  set debounceDuration(Duration value) {
    _debounceDuration = value;
  }

  Stream<E> get debounceStream {
    return debounceStreamController.stream.debounceTime(debounceDuration).distinct();
  }

  @override
  void dispose() {
    debounceStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    debounceStream.listen(onDebounceStreamChanged);
  }

  /// 搜索去重回调
  void onDebounceStreamChanged(E v) => throw UnimplementedError("❌$this onDebounceStreamChanged");

  /// 加入新值
  void debounceStreamSink(E v) {
    if (debounceStreamController.isClosed) {
      // debugPrint("debounceStreamSink debounceStreamController已关闭");
      return;
    }
    debounceStreamController.add(v);
  }
}
