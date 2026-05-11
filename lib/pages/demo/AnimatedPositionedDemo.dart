//
//  AnimatedPositionedDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/12/2 09:42.
//  Copyright © 2025/12/2 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AnimatedPositionedDemo extends StatefulWidget {
  const AnimatedPositionedDemo({super.key});

  @override
  State<AnimatedPositionedDemo> createState() => _AnimatedPositionedDemoState();
}

class _AnimatedPositionedDemoState extends State<AnimatedPositionedDemo> {
// 多种位置状态
  int _currentPosition = 0;
  double _animationDuration = 1.0;
  Curve _selectedCurve = Curves.easeInOut;

// 位置预设
  final List<Map<String, dynamic>> _positionPresets = [
    {'left': 10, 'top': 10, 'label': '左上角', 'color': Colors.red},
    {'left': 200, 'top': 10, 'label': '右上角', 'color': Colors.blue},
    {'left': 10, 'top': 200, 'label': '左下角', 'color': Colors.green},
    {'left': 200, 'top': 200, 'label': '右下角', 'color': Colors.orange},
    {'left': 100, 'top': 100, 'label': '中心', 'color': Colors.purple},
  ];

// 动画曲线选项
  final List<Curve> _curves = [
    Curves.linear,
    Curves.easeInOut,
    Curves.bounceOut,
    Curves.elasticOut,
    Curves.fastOutSlowIn,
  ];

  final Map<Curve, String> _curveNames = {
    Curves.linear: '线性',
    Curves.easeInOut: '缓入缓出',
    Curves.bounceOut: '弹跳',
    Curves.elasticOut: '弹性',
    Curves.fastOutSlowIn: '快出慢入',
  };

  @override
  Widget build(BuildContext context) {
    final currentPreset = _positionPresets[_currentPosition];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedPositioned 高级示例'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              // 演示区域
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    _buildGridBackground(),

                    // 主要的 AnimatedPositioned 组件
                    AnimatedPositioned(
                      left: currentPreset['left'].toDouble(),
                      top: currentPreset['top'].toDouble(),
                      width: 60,
                      height: 60,
                      duration: Duration(milliseconds: (_animationDuration * 1000).round()),
                      curve: _selectedCurve,
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentPreset['color'],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.animation, color: Colors.white, size: 24),
                            Text(
                              currentPreset['label'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 控制面板
              _buildControlPanel(currentPreset),
            ],
          ),
        ),
      ),
    );
  }

// 构建控制面板
  Widget _buildControlPanel(Map<String, dynamic> currentPreset) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // 当前位置信息
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: currentPreset['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem('位置', currentPreset['label']),
                _buildInfoItem('坐标', '(${currentPreset['left']}, ${currentPreset['top']})'),
                _buildInfoItem('持续时间', '${_animationDuration}s'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 位置选择按钮
          const Text(
            '选择目标位置:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_positionPresets.length, (index) {
              final preset = _positionPresets[index];
              return ElevatedButton(
                onPressed: () {
                  _currentPosition = index;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: preset['color'],
                  foregroundColor: Colors.white,
                ),
                child: Text(preset['label']),
              );
            }),
          ),

          const SizedBox(height: 20),

          // 动画持续时间控制
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '动画持续时间:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _animationDuration,
                min: 0.5,
                max: 3.0,
                divisions: 5,
                label: '${_animationDuration.toStringAsFixed(1)}秒',
                onChanged: (value) {
                  _animationDuration = value;
                  setState(() {});
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 动画曲线选择
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '动画曲线:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _curves.map((curve) {
                  return FilterChip(
                    label: Text(_curveNames[curve]!),
                    selected: _selectedCurve == curve,
                    onSelected: (selected) {
                      _selectedCurve = curve;

                      setState(() {});
                    },
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 说明文本
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 提示：AnimatedPositioned 会自动在位置变化时创建平滑动画。'
              '确保父容器 Stack 有明确的大小约束。',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

// 构建信息项
  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

// 构建网格背景
  Widget _buildGridBackground() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomPaint(
          painter: _GridPainter(),
        ),
      ),
    );
  }
}

// 网格绘制类
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // 绘制网格线
    for (var x = 0; x <= size.width; x += 50) {
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x.toDouble(), size.height), paint);
    }
    for (var y = 0; y <= size.height; y += 50) {
      canvas.drawLine(Offset(0, y.toDouble()), Offset(size.width, y.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
