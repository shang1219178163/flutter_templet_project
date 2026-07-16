//
//  NShimmerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/16.
//  Copyright © 2026/7/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_shimmer.dart';
import 'package:get/get.dart';

/// NShimmer 微光效果演示
class NShimmerDemo extends StatefulWidget {
  const NShimmerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NShimmerDemo> createState() => _NShimmerDemoState();
}

class _NShimmerDemoState extends State<NShimmerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  var duration = const Duration(seconds: 2);
  var direction = Axis.horizontal;
  var angle = -20.0;
  var baseColor = Colors.white54;
  var highlightColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NSectionBox(
              title: "文本微光",
              child: buildTextShimmer(),
            ),
            NSectionBox(
              title: "骨架占位",
              child: buildSkeletonShimmer(),
            ),
            NSectionBox(
              title: "按钮 / 图标",
              child: buildIconShimmer(),
            ),
            NSectionBox(
              title: "参数调节",
              child: buildControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: NShimmer(
        duration: duration,
        direction: direction,
        angle: angle,
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: const Text(
          "NShimmer 微光文字效果",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildSkeletonShimmer() {
    return NShimmer(
      duration: duration,
      direction: direction,
      angle: angle,
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPlaceholderBox(double.infinity, 120),
          const SizedBox(height: 12),
          buildPlaceholderBox(200, 18),
          const SizedBox(height: 8),
          buildPlaceholderBox(double.infinity, 14),
          const SizedBox(height: 8),
          buildPlaceholderBox(160, 14),
        ],
      ),
    );
  }

  Widget buildIconShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: NShimmer(
        duration: duration,
        direction: direction,
        angle: angle,
        baseColor: Colors.red.withValues(alpha: 0.4),
        highlightColor: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 36, color: Colors.white),
            SizedBox(width: 12),
            Text(
              "会员专属权益",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.star, size: 36, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("流动方向"),
        const SizedBox(height: 8),
        SegmentedButton<Axis>(
          segments: const [
            ButtonSegment(value: Axis.horizontal, label: Text("水平"), icon: Icon(Icons.swap_horiz)),
            ButtonSegment(value: Axis.vertical, label: Text("垂直"), icon: Icon(Icons.swap_vert)),
          ],
          selected: {direction},
          onSelectionChanged: (Set<Axis> selected) {
            direction = selected.first;
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        Text("倾斜角度 ${angle.toStringAsFixed(0)}°"),
        Slider(
          value: angle,
          min: -90,
          max: 90,
          divisions: 36,
          label: "${angle.toStringAsFixed(0)}°",
          onChanged: (value) {
            angle = value;
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        Text("动画时长 ${duration.inMilliseconds}ms"),
        Slider(
          value: duration.inMilliseconds.toDouble(),
          min: 500,
          max: 5000,
          divisions: 9,
          label: "${duration.inMilliseconds}ms",
          onChanged: (value) {
            duration = Duration(milliseconds: value.round());
            setState(() {});
          },
        ),
        const SizedBox(height: 8),
        const Text("基础色 / 高亮色（文本场景）"),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            buildColorChip(
              label: "白",
              base: Colors.white54,
              highlight: Colors.white,
            ),
            buildColorChip(
              label: "蓝",
              base: Colors.blue.withValues(alpha: 0.4),
              highlight: Colors.lightBlueAccent,
            ),
            buildColorChip(
              label: "金",
              base: Colors.amber.withValues(alpha: 0.4),
              highlight: Colors.amber,
            ),
            buildColorChip(
              label: "粉",
              base: Colors.pink.withValues(alpha: 0.4),
              highlight: Colors.pinkAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildColorChip({
    required String label,
    required Color base,
    required Color highlight,
  }) {
    final isSelected = baseColor == base && highlightColor == highlight;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        baseColor = base;
        highlightColor = highlight;
        setState(() {});
      },
    );
  }

  Widget buildPlaceholderBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
