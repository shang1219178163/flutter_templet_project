import 'dart:async';
import 'package:flutter/widgets.dart';

/// 日期倒计时
mixin DateTimeCountDownMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  Timer? _timer;

  Duration countdown = Duration.zero;

  /// 目标时间
  DateTime get targetTime;

  /// 刷新频率
  Duration get interval => const Duration(seconds: 1);

  /// 倒计时变化
  ValueChanged<Duration>? onCountdownChanged;

  /// 倒计时结束
  VoidCallback? onCountdownFinished;

  /// 开始
  VoidCallback? onCountdownStarted;

  /// 暂停
  VoidCallback? onCountdownPaused;

  /// App 回前台
  VoidCallback? onAppResumed;

  /// App 进入后台
  VoidCallback? onAppPaused;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  void _startTimer() {
    _updateCountdown();

    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      _updateCountdown();
    });

    onCountdownStarted?.call();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    onCountdownPaused?.call();
  }

  void _updateCountdown() {
    if (!mounted) {
      return;
    }
    final diff = targetTime.difference(DateTime.now());
    if (diff.isNegative) {
      _stopTimer();
      countdown = Duration.zero;
      onCountdownFinished?.call();
      return;
    }

    countdown = diff;
    onCountdownChanged?.call(diff);
  }

  /// App 生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      /// 前台恢复
      case AppLifecycleState.resumed:
        onAppResumed?.call();
        _startTimer();
        break;

      /// 后台暂停
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        onAppPaused?.call();
        _stopTimer();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
