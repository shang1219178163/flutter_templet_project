import 'package:get/get.dart';

/// GetxController
mixin SafeGetxControllerMixin on GetxController {
  bool _mounted = true;
  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  /// 查
  @override
  Future<void> update([List<Object>? ids, bool condition = true]) async {
    if (!_mounted) {
      return;
    }
    super.update(ids, condition);
  }
}
