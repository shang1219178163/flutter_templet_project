//
//  WeatherHome.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/4 12:27.
//  Copyright © 2025/3/4 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/weather/models/weather_type.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_card.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final double _animationSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('天气特效演示'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Row(
          //     children: [
          //       const Text(
          //         '动画速度',
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       ),
          //       Expanded(
          //         child: Slider(
          //           value: _animationSpeed,
          //           min: 0.1,
          //           max: 2.0,
          //           divisions: 19,
          //           label: _animationSpeed.toStringAsFixed(1),
          //           onChanged: (value) {
          //             setState(() {
          //               _animationSpeed = value;
          //             });
          //           },
          //         ),
          //       ),
          //       Text('${_animationSpeed.toStringAsFixed(1)}x'),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  '天气特效卡片',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: WeatherType.values.length,
                  itemBuilder: (context, index) {
                    final weatherType = WeatherType.values[index];
                    return WeatherCard(
                      weatherType: weatherType,
                      animationSpeed: _animationSpeed,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
