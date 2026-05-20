import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/countdown/n_countdown_bar.dart';
import 'package:flutter_templet_project/basicWidget/countdown/n_rolling_count_down.dart';
import 'package:flutter_templet_project/basicWidget/countdown/n_rolling_digit.dart';
import 'package:flutter_templet_project/mixin/date_time_count_down_mixin.dart';
import 'package:get/get.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  final scrollController = ScrollController();

  var targetTime = DateTime(2026, 6, 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final duration = targetTime.difference(DateTime.now());
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 30,
              child: NCountdownBar(
                startTime: targetTime,
                onCountdownFinished: () {
                  // setState(() {});
                },
              ),
            ),
            NRollingCountDown(
              duration: duration,
              dayBuilder: (v) => buildText(value: v, unit: "天"),
              hourBuilder: (v) => buildText(value: v, unit: "时"),
              minuteBuilder: (v) => buildText(value: v, unit: "分"),
              secondBuilder: (v) => buildText(value: v, unit: "秒"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText({required String value, required String unit}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        NRollingDigit(
          value: value,
          builder: (String v) {
            return Text(
              value,
              style: const TextStyle(
                // color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        Text(
          unit,
          style: const TextStyle(
            // color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
