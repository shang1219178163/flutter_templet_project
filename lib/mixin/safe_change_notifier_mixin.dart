import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

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
    // super.notifyListeners();
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_mounted) {
          super.notifyListeners();
        }
      });
    } else {
      super.notifyListeners();
    }
  }
}
