//
//  GradientPlaygroundPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/14 10:03.
//  Copyright © 2026/1/14 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class GradientPlaygroundPage extends StatefulWidget {
  const GradientPlaygroundPage({super.key});

  @override
  State<GradientPlaygroundPage> createState() => _GradientPlaygroundPageState();
}

class _GradientPlaygroundPageState extends State<GradientPlaygroundPage> {
  double beginX = 0.1;
  double beginY = -0.6;
  double endX = 0.5;
  double endY = 0.6;

  @override
  Widget build(BuildContext context) {
    Color mainColor = Colors.red;
    mainColor = Color(0xffFFB800);

    return Scaffold(
      appBar: AppBar(title: const Text('LinearGradient 调参面板')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 164 / 64,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            gradient: LinearGradient(
                              begin: Alignment(beginX, beginY),
                              end: Alignment(endX, endY),
                              colors: [
                                // Colors.red,
                                // Colors.green,
                                mainColor.withOpacity(0.3),
                                mainColor.withOpacity(0.0),
                              ],
                            ),
                          ),
                          child: buildText(),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            gradient: LinearGradient(
                              begin: Alignment(beginX, beginY),
                              end: Alignment(endX, endY),
                              colors: [
                                // Colors.red,
                                // Colors.green,
                                mainColor.withOpacity(0.3),
                                mainColor.withOpacity(0.0),
                              ],
                            ),
                          ),
                          child: buildText(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 渐变预览区
              AspectRatio(
                aspectRatio: 370 / 78,
                child: Container(
                  // alignment: Alignment.bottomLeft,
                  // padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    gradient: LinearGradient(
                      begin: Alignment(beginX, beginY),
                      end: Alignment(endX, endY),
                      colors: [
                        // Colors.red,
                        // Colors.green,
                        mainColor.withOpacity(0.3),
                        mainColor.withOpacity(0.0),
                      ],
                    ),
                  ),

                  child: buildText(),
                ),
              ),

              /// 控制面板
              _slider(
                label: 'begin.x',
                value: beginX,
                onChanged: (v) {
                  beginX = v;
                  setState(() {});
                },
              ),
              _slider(
                label: 'begin.y',
                value: beginY,
                onChanged: (v) {
                  beginY = v;
                  setState(() {});
                },
              ),
              _slider(
                label: 'end.x',
                value: endX,
                onChanged: (v) {
                  endX = v;
                  setState(() {});
                },
              ),
              _slider(
                label: 'end.y',
                value: endY,
                onChanged: (v) {
                  endY = v;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    final desc = [
      'begin: Alignment(${beginX.toStringAsFixed(2)}, ${beginY.toStringAsFixed(2)})',
      'end:   Alignment(${endX.toStringAsFixed(2)}, ${endY.toStringAsFixed(2)})',
    ].join("\n");
    return Text(
      desc,
      style: const TextStyle(
        fontSize: 11,
      ),
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.toStringAsFixed(2)}'),
          Slider(
            value: value,
            min: -1,
            max: 1,
            divisions: 100,
            label: value.toStringAsFixed(2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
