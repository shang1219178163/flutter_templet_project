//
//  color_opacity_compare_demo.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/11.
//  Copyright © 2026/7/11 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';

/// 对比 Color.withOpacity 与 Color.withValues(alpha:) 在同参数下的渲染效果
class ColorOpacityCompareDemo extends StatefulWidget {
  const ColorOpacityCompareDemo({super.key, this.title});

  final String? title;

  @override
  State<ColorOpacityCompareDemo> createState() => _ColorOpacityCompareDemoState();
}

class _ColorOpacityCompareDemoState extends State<ColorOpacityCompareDemo> {
  /// 主题色候选，使用 Material 主色板
  final colors = Colors.primaries;

  final selectedColor = ValueNotifier(Colors.primaries.first);

  /// 固定透明度档位，便于观察同参数差异
  final alphaValues = <double>[0.1, 0.3, 0.5, 0.7, 0.9, 1.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '颜色透明度对比'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          NSectionBox(
            title: '颜色选择',
            child: buildExpandColorMenu(),
          ),
          NSectionBox(
            title: 'withOpacity vs withValues',
            crossAxisAlignment: CrossAxisAlignment.start,
            child: ValueListenableBuilder<Color>(
              valueListenable: selectedColor,
              builder: (context, color, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCompareHeader(color: color),
                    const SizedBox(height: 12),
                    ...alphaValues.map((alpha) => buildAlphaCompareRow(color: color, alpha: alpha)),
                  ],
                );
              },
            ),
          ),
          NSectionBox(
            title: '棋盘格背景对比',
            crossAxisAlignment: CrossAxisAlignment.start,
            child: ValueListenableBuilder<Color>(
              valueListenable: selectedColor,
              builder: (context, color, child) {
                return Column(
                  children: alphaValues
                      .map((alpha) => buildAlphaCompareRow(
                            color: color,
                            alpha: alpha,
                            background: buildCheckerboardBackground(),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 颜色扩展菜单，复用 ExpandIconDemo 交互
  Widget buildExpandColorMenu() {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: selectedColor.value,
          collapsedIconColor: selectedColor.value,
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.color_lens,
          color: selectedColor.value,
        ),
        title: Text(
          '颜色主题',
          style: TextStyle(color: selectedColor.value),
        ),
        initiallyExpanded: false,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((color) {
                return InkWell(
                  onTap: () {
                    selectedColor.value = color;
                    DLog.d(color.nameDes);
                    setState(() {});
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: color,
                    child: selectedColor.value == color
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompareHeader({required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '当前颜色：${color.nameDes}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          '左侧 withOpacity，右侧 withValues(alpha:)，参数相同',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: buildMethodLabel('withOpacity')),
            const SizedBox(width: 12),
            Expanded(child: buildMethodLabel('withValues')),
          ],
        ),
      ],
    );
  }

  Widget buildMethodLabel(String title) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildAlphaCompareRow({
    required Color color,
    required double alpha,
    Widget? background,
  }) {
    // 演示页保留 withOpacity，用于与 withValues 做同参数视觉对比
    // ignore: deprecated_member_use
    final opacityColor = color.withOpacity(alpha);
    final valuesColor = color.withValues(alpha: alpha);
    final isSameColor = opacityColor == valuesColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'alpha = ${alpha.toStringAsFixed(1)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Text(
                isSameColor ? '颜色值一致' : '颜色值不同',
                style: TextStyle(
                  fontSize: 12,
                  color: isSameColor ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: buildColorSample(
                  color: opacityColor,
                  label: 'withOpacity($alpha)',
                  background: background,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildColorSample(
                  color: valuesColor,
                  label: 'withValues(alpha: $alpha)',
                  background: background,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'opacity: ${opacityColor.argbInt.toRadixString(16).padLeft(8, '0')}  |  values: ${valuesColor.argbInt.toRadixString(16).padLeft(8, '0')}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  Widget buildColorSample({
    required Color color,
    required String label,
    Widget? background,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                background ?? Container(color: Colors.white),
                Container(color: color),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  /// 棋盘格背景，便于观察半透明差异
  Widget buildCheckerboardBackground() {
    return CustomPaint(
      painter: _CheckerboardPainter(),
    );
  }
}

/// 棋盘格绘制
class _CheckerboardPainter extends CustomPainter {
  static const int _cellCount = 8;
  static const Color _lightColor = Color(0xFFE0E0E0);
  static const Color _darkColor = Color(0xFFBDBDBD);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / _cellCount;
    final cellHeight = size.height / _cellCount;
    for (var row = 0; row < _cellCount; row++) {
      for (var col = 0; col < _cellCount; col++) {
        final paint = Paint()
          ..color = (row + col).isEven ? _lightColor : _darkColor;
        canvas.drawRect(
          Rect.fromLTWH(col * cellWidth, row * cellHeight, cellWidth, cellHeight),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
