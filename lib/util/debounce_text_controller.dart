import 'dart:async';

import 'package:flutter/material.dart';

/// 防抖 TextEditingController
class DebounceTextController {
  DebounceTextController({
    required this.controller,
    this.debounce = const Duration(milliseconds: 300),
    required this.onChanged,
  }) {
    controller.addListener(_onTextChanged);
  }

  final TextEditingController controller;
  final Duration debounce;
  final ValueChanged<String> onChanged;

  Timer? _timer;
  String _lastEmitted = '';

  void _onTextChanged() {
    final text = controller.text.trim();
    // 去重
    if (text == _lastEmitted) {
      return;
    }

    _timer?.cancel();
    _timer = Timer(debounce, () {
      // 二次校验（防止 timer 期间又变了）
      final latest = controller.text.trim();
      if (latest.isNotEmpty && latest != _lastEmitted) {
        _lastEmitted = latest;
        onChanged(latest);
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    controller.removeListener(_onTextChanged);
  }
}

extension TextEditingControllerDebounce on TextEditingController {
  /// 防抖,去重
  TextEditingController debounce({
    Duration duration = const Duration(milliseconds: 300),
    required ValueChanged<String> onChanged,
  }) {
    final deboubce = DebounceTextController(
      controller: this,
      debounce: duration,
      onChanged: onChanged,
    );
    return this;
  }
}
