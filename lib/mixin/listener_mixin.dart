/// 监听订阅
mixin ListenerMixin {
  final List<void Function()> _listeners = [];

  /// 添加监听器（页面级别订阅）
  void addListener(void Function() ltr) {
    _listeners.add(ltr);
  }

  /// 移除监听器（避免内存泄漏）
  void removeListener(void Function() ltr) {
    _listeners.remove(ltr);
  }

  /// 触发订阅通知
  void notifyLtrs() {
    for (final ltr in _listeners) {
      ltr();
    }
  }
}
