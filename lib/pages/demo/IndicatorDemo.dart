//
//  IndicatorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/7/21 3:21 PM.
//  Copyright © 6/7/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_linear_gradient_progress_indicator.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class IndicatorDemo extends StatefulWidget {
  const IndicatorDemo({super.key});

  @override
  _IndicatorDemoState createState() => _IndicatorDemoState();
}

class _IndicatorDemoState extends State<IndicatorDemo> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    // controller.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(0.8);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            NSectionBox(
              title: "CupertinoActivityIndicator",
              child: CupertinoActivityIndicator(
                radius: 24,
                color: primaryColor,
              ),
            ),
            NSectionBox(
              title: "CircularProgressIndicator",
              child: SizedBox(
                width: 60,
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.withAlpha(30),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NText(
                        controller.value.toStringAsPercent(2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NSectionBox(
              title: "NLinearGradientProgressIndicator - Axis.horizontal",
              child: NLinearGradientProgressIndicator(
                value: controller.value,
                start: (v) => Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text("温度计"),
                ),
              ),
            ),
            NSectionBox(
              title: "NLinearGradientProgressIndicator - Axis.vertical",
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: NLinearGradientProgressIndicator(
                  value: controller.value,
                  direction: Axis.vertical,
                ),
              ),
            ),
            // NSectionBox(
            //   title: "buildLinearProgressIndicator",
            //   child: buildLinearProgressIndicator(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildLinearProgressIndicator() {
    final progressVN = ValueNotifier(0.0);
    progressVN.value = controller.value;
    return ValueListenableBuilder(
      valueListenable: progressVN,
      builder: (context, value, child) {
        if (value == 0) {
          return const SizedBox();
        }

        final precentStr = '${(value * 100).toStringAsFixed(0)}%';

        return Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.pink],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                precentStr,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
