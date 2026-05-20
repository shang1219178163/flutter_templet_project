import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/countdown/n_rolling_count_down.dart';
import 'package:flutter_templet_project/basicWidget/countdown/n_rolling_digit.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/mixin/date_time_count_down_mixin.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';

/// 倒计时
class NCountdownBar extends StatefulWidget {
  const NCountdownBar({
    super.key,
    required this.startTime,
    required this.onCountdownFinished,
  });

  final DateTime startTime;

  /// 倒计时结束
  final VoidCallback onCountdownFinished;

  @override
  State<NCountdownBar> createState() => _NCountdownBarState();
}

class _NCountdownBarState extends State<NCountdownBar>
    with SafeSetStateMixin, WidgetsBindingObserver, DateTimeCountDownMixin {
  @override
  DateTime get targetTime => widget.startTime;

  /// 倒计时变化
  @override
  ValueChanged<Duration>? get onCountdownChanged => (v) {
        setState(() {});
      };

  @override
  VoidCallback? get onCountdownFinished => widget.onCountdownFinished;

  @override
  Widget build(BuildContext context) {
    final segments = countdown.segments();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...segments.map((e) {
          return Flexible(
            child: buildCountDownItem(
              value: "${e.value}".padLeft(2, '0'),
              unit: e.unit,
            ),
          );
        }),
      ],
    );
  }

  Widget buildCountDownItem({required String value, required String unit}) {
    Widget buildDigit(String value) {
      return Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w600,
          fontFamily: 'PingFang SC',
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: Colors.black,
            // border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: NRollingDigit(
            value: value,
            builder: buildDigit,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            unit,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 7,
              fontWeight: FontWeight.w600,
              fontFamily: 'PingFang SC',
            ),
          ),
        )
      ],
    );
  }
}
