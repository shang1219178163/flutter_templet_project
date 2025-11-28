import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 倒计时
mixin CountDownTimer<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  DateTime? _endTime;
  Timer? _timer;

  int get limitSecond => 60;

  final isCountingDownVN = ValueNotifier(false);
  late final countdownVN = ValueNotifier(limitSecond);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // 处理 app 暂停/恢复（确保从后台回来能立即刷新）
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // app 回到前台，立刻重算一次
      _updateRemaining();
    }
  }

  /// 开始倒计时
  void startCountdown() {
    isCountingDownVN.value = true;
    countdownVN.value = limitSecond;

    _endTime = DateTime.now().add(Duration(seconds: limitSecond));
    _updateRemaining(); // 立即计算一次（避免 UI 延迟）
    _timer?.cancel();
    // 周期短一点以保证恢复后能尽快反映（但 setState 只有在秒数变化才触发）
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    if (_endTime == null) {
      return;
    }
    final secondsLeft = _endTime!.difference(DateTime.now()).inSeconds.clamp(0, limitSecond);
    DLog.d(["secondsLeft: $secondsLeft"]);
    if (secondsLeft <= 0) {
      isCountingDownVN.value = false;
      _timer?.cancel();
      _endTime = null;
    } else {
      countdownVN.value = secondsLeft;
    }
  }
}

// 验证码收入款
class TimerButton extends StatefulWidget {
  const TimerButton({
    super.key,
    required this.onRequest,
  });

  final Future<bool> Function() onRequest;

  @override
  State<TimerButton> createState() => TimerButtonState();
}

/// 倒计时
class TimerButtonState extends State<TimerButton> with WidgetsBindingObserver, CountDownTimer {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isCountingDownVN,
      builder: (context, isCountingDown, child) {
        // final disabledBackgroundColor = themeProvider.isDark ? const Color(0xFF3A3A48) : const Color(0xFFDEDEDE);
        // final disabledForegroundColor = themeProvider.isDark ? const Color(0xFF7C7C85) : const Color(0xFFA7A7AE);

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(60, 30),
            maximumSize: Size(100, 30),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.red,
            // disabledBackgroundColor: disabledBackgroundColor,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // 设置圆角半径
            ),
            elevation: 0,
          ),
          onPressed: isCountingDown
              ? null
              : () async {
                  var res = await widget.onRequest();
                  if (res) {
                    startCountdown();
                  }
                },
          child: ValueListenableBuilder(
            valueListenable: countdownVN,
            builder: (context, value, child) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  isCountingDown ? '$value秒后重试' : '发送验证码',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
