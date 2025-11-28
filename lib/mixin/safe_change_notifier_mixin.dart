import 'package:flutter/material.dart';

/// ChangeNotifier
mixin SafeChangeNotifierMixin on ChangeNotifier {
  bool _mounted = true;
  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_mounted) {
      return;
    }
    super.notifyListeners();
  }
}
