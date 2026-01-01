//
//  SearchControllerMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/1 17:28.
//  Copyright © 2026/1/1 shang. All rights reserved.
//

import 'dart:async';
import 'package:flutter/material.dart';

/// 搜索框 mixin
@Deprecated("已弃用,请使用 DebounceTextController")
mixin SearchControllerMixin<T extends StatefulWidget> on State<T> {
  final _searchStreamController = StreamController<String>();

  /// 搜索框 Stream<String>
  Stream<String> get searchStream => _searchStreamController.stream.map((e) => e.trim()).distinct().transform(
        DebounceTransformer(debounceDuration),
      );

  @protected
  TextEditingController get searchController;

  @protected
  Duration get debounceDuration => const Duration(milliseconds: 300);

  @override
  void dispose() {
    // print([runtimeType, "dispose", searchController.hashCode]);
    searchController.removeListener(_textControllerLtr);
    _searchStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // print([runtimeType, "initState", searchController.hashCode]);
    searchController.addListener(_textControllerLtr);
    searchStream.listen(onSearchChanged);
  }

  _textControllerLtr() {
    // print([runtimeType, searchController.text]);
    _searchStreamController.add(searchController.text);
  }

  @protected
  void onSearchChanged(String v) {
    throw UnimplementedError("❌$this Not implemented onSearchChanged");
  }
}

class DebounceTransformer<T> extends StreamTransformerBase<T, T> {
  DebounceTransformer(this.duration);

  final Duration duration;

  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamController<T> controller;
    Timer? timer;
    T? lastValue;

    controller = StreamController<T>(
      onListen: () {
        final sub = stream.listen(
          (value) {
            timer?.cancel();
            lastValue = value;
            timer = Timer(duration, () {
              if (!controller.isClosed) {
                controller.add(lastValue as T);
              }
            });
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );

        controller.onCancel = () {
          timer?.cancel();
          sub.cancel();
        };
      },
    );

    return controller.stream;
  }
}
