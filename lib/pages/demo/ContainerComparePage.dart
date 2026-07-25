//
//  ContainerComparePage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/24.
//  Copyright © 2026/7/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_container.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:get/get.dart';

/// [Container] 与 [NSliverContainer] 同参效果对比
class ContainerComparePage extends StatefulWidget {
  const ContainerComparePage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ContainerComparePage> createState() => _ContainerComparePageState();
}

class _ContainerComparePageState extends State<ContainerComparePage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  ThemeData get theme => Theme.of(context);

  static const margin = EdgeInsets.all(8);
  static const padding = EdgeInsets.all(8);
  static const borderRadius = BorderRadius.all(Radius.circular(8));
  static const foregroundRadius = BorderRadius.all(Radius.circular(24));

  final labels = const [
    'Item 0',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];

  Decoration get decoration => BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.blue),
      );

  Decoration get foregroundDecoration => BoxDecoration(
        color: Colors.green.withValues(alpha: 0.55),
        borderRadius: foregroundRadius,
        border: Border.all(color: Colors.blue),
        image: const DecorationImage(
          image: AssetImage(Assets.imagesBgJiguang),
          fit: BoxFit.cover,
          opacity: 0.35,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text('$widget'),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Text(
            '相同参数：margin / padding / decoration / foregroundDecoration',
            style: TextStyle(fontSize: 13),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: buildContainerSide()),
              const VerticalDivider(width: 1),
              Expanded(child: buildSliverSide()),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildContainerSide() {
    return Column(
      children: [
        buildSideTitle('Container'),
        Expanded(
          child: ColoredBox(
            color: Colors.grey.shade100,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: margin,
                  padding: padding,
                  decoration: decoration,
                  foregroundDecoration: foregroundDecoration,
                  child: buildContentColumn(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSliverSide() {
    return Column(
      children: [
        buildSideTitle('NSliverContainer'),
        Expanded(
          child: ColoredBox(
            color: Colors.grey.shade100,
            child: CustomScrollView(
              slivers: [
                NSliverContainer(
                  margin: margin,
                  padding: padding,
                  decoration: decoration,
                  foregroundDecoration: foregroundDecoration,
                  sliver: SliverList.list(
                    children: labels.map(buildItemText).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSideTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget buildContentColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: labels.map(buildItemText).toList(),
    );
  }

  Widget buildItemText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }
}
