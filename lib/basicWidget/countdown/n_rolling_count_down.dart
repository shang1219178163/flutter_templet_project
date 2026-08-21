import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/countdown/n_rolling_digit.dart';

/// 滚动倒计时
class NRollingCountDown extends StatefulWidget {
  const NRollingCountDown({
    super.key,
    required this.duration,
    this.dayBuilder,
    this.hourBuilder,
    this.minuteBuilder,
    this.secondBuilder,
  });

  final Duration duration;

  final Widget Function(String v)? dayBuilder;
  final Widget Function(String v)? hourBuilder;
  final Widget Function(String v)? minuteBuilder;
  final Widget Function(String v)? secondBuilder;

  @override
  State<NRollingCountDown> createState() => _NRollingCountDownState();
}

class _NRollingCountDownState extends State<NRollingCountDown> {
  late Duration duration = widget.duration;

  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    duration = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (duration.inSeconds <= 0) {
          timer?.cancel();
          return;
        }
        duration -= const Duration(seconds: 1);
        setState(() {});
      },
    );
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  void didUpdateWidget(covariant NRollingCountDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours % 24);
    final minutes = twoDigits(duration.inMinutes % 60);
    final seconds = twoDigits(duration.inSeconds % 60);

    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.transparent,
      //   border: Border.all(color: Colors.blue),
      // ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (duration.inDays > 0) widget.dayBuilder?.call(days) ?? buildText(digit: days, unit: " "),
          widget.hourBuilder?.call(hours) ?? buildText(digit: hours, unit: ":"),
          widget.minuteBuilder?.call(minutes) ?? buildText(digit: minutes, unit: ":"),
          widget.secondBuilder?.call(seconds) ?? buildText(digit: seconds, unit: ""),
        ],
      ),
    );
  }

  Widget buildText({required String digit, String unit = ':'}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NRollingDigit(
          value: digit,
          builder: (v) {
            return Text(
              v,
              style: const TextStyle(
                // color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Text(
            unit,
            style: TextStyle(
              // color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
