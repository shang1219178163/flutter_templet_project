//
//  BackdropFilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:13 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// ImageFilter 预设，映射到 BackdropFilter.filter
enum _FilterKind {
  blur(label: 'blur'),
  dilate(label: 'dilate'),
  erode(label: 'erode');

  const _FilterKind({required this.label});

  /// Chip 文案
  final String label;

  /// 构造 [ImageFilter]；参数由页面状态注入
  ImageFilter filter({
    required double sigmaX,
    required double sigmaY,
    required TileMode tileMode,
    required double radiusX,
    required double radiusY,
  }) {
    return switch (this) {
      _FilterKind.blur => ImageFilter.blur(
          sigmaX: sigmaX,
          sigmaY: sigmaY,
          tileMode: tileMode,
        ),
      _FilterKind.dilate => ImageFilter.dilate(radiusX: radiusX, radiusY: radiusY),
      _FilterKind.erode => ImageFilter.erode(radiusX: radiusX, radiusY: radiusY),
    };
  }
}

/// child 预设
enum _ChildKind {
  overlay(label: 'overlay'),
  hello(label: 'hello'),
  none(label: 'none');

  const _ChildKind({required this.label});
  final String label;
}

class BackdropFilterDemo extends StatefulWidget {
  const BackdropFilterDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<BackdropFilterDemo> createState() => _BackdropFilterDemoState();
}

class _BackdropFilterDemoState extends State<BackdropFilterDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 原 Demo createBlurView(blur: 5) / ImageFilter.blur(5, 5)
  _FilterKind filterKind = _FilterKind.blur;
  double sigmaX = 5;
  double sigmaY = 5;
  TileMode tileMode = TileMode.clamp;
  double radiusX = 2;
  double radiusY = 2;
  BlendMode blendMode = BlendMode.srcOver;
  bool enabled = true;
  _ChildKind childKind = _ChildKind.overlay;
  String lastEvent = '—';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.42).clamp(220.0, 380.0);
          return Column(
            children: [
              buildPreview(previewHeight),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const NDescriptionCard(
                          initialLang: NLangEnum.zh,
                          title: {
                            NLangEnum.en: 'Description',
                            NLangEnum.zh: '说明',
                          },
                          subtitle: {
                            NLangEnum.en: 'Widget BackdropFilter',
                            NLangEnum.zh: '组件 BackdropFilter',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'BackdropFilter only has filter, child, blendMode, and enabled. It blurs content already painted behind it. Default matches the live demo: full-image blur via StackExt.createBlurView(blur: 5).',
                              NLangEnum.zh:
                                  'BackdropFilter 只有 filter、child、blendMode、enabled。它模糊的是已经画在后面的内容。默认对齐当前页：整图模糊，等同 StackExt.createBlurView(blur: 5)。',
                            },
                            {
                              NLangEnum.en:
                                  'child hello is the unused frosted 200×200 Hello World square from buildBody.',
                              NLangEnum.zh: 'child 选 hello 是原文件未启用的 200×200 Hello World 毛玻璃方块。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildBehaviorCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: previewHeight,
            width: double.infinity,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: AssetImage(Assets.imagesBg),
                    fit: BoxFit.cover,
                  ),
                  buildFilterLayer(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              '${filterKind.label} · ${blendMode.name} · enabled $enabled · $lastEvent',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterLayer() {
    switch (childKind) {
      case _ChildKind.overlay:
        return Positioned.fill(
          child: ClipRRect(
            child: buildFilter(
              child: Container(
                color: Colors.black.withValues(alpha: 0),
              ),
            ),
          ),
        );
      case _ChildKind.hello:
        return Center(
          child: ClipRRect(
            child: buildFilter(
              child: Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                child: const Text('Hello World'),
              ),
            ),
          ),
        );
      case _ChildKind.none:
        return Positioned.fill(
          child: ClipRRect(
            child: buildFilter(child: null),
          ),
        );
    }
  }

  Widget buildFilter({required Widget? child}) {
    return BackdropFilter(
      filter: filterKind.filter(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        tileMode: tileMode,
        radiusX: radiusX,
        radiusY: radiusY,
      ),
      blendMode: blendMode,
      enabled: enabled,
      child: child,
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'filter · child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<_FilterKind>(
            title: const Text('filter'),
            values: _FilterKind.values,
            value: filterKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('filter ${e.label}', () => filterKind = e),
          ),
          if (filterKind == _FilterKind.blur) ...[
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('sigmaX'),
              min: 0,
              max: 20,
              value: sigmaX.clamp(0, 20),
              onChanged: (v) => onMark('sigmaX ${v.toStringAsFixed(1)}', () => sigmaX = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                );
              },
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('sigmaY'),
              min: 0,
              max: 20,
              value: sigmaY.clamp(0, 20),
              onChanged: (v) => onMark('sigmaY ${v.toStringAsFixed(1)}', () => sigmaY = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            NChoiceChipListItem<TileMode>(
              title: const Text('tileMode'),
              values: TileMode.values,
              value: tileMode,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('tileMode ${e.name}', () => tileMode = e),
            ),
          ],
          if (filterKind != _FilterKind.blur) ...[
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('radiusX'),
              min: 0,
              max: 12,
              value: radiusX.clamp(0, 12),
              onChanged: (v) => onMark('radiusX ${v.toStringAsFixed(1)}', () => radiusX = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                );
              },
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('radiusY'),
              min: 0,
              max: 12,
              value: radiusY.clamp(0, 12),
              onChanged: (v) => onMark('radiusY ${v.toStringAsFixed(1)}', () => radiusY = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 8),
          NChoiceChipListItem<_ChildKind>(
            title: const Text('child'),
            values: _ChildKind.values,
            value: childKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('child ${e.label}', () => childKind = e),
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'blendMode · enabled',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListItem(
              title: const Text('enabled 应用滤镜'),
              value: enabled,
              onChanged: (v) => onMark('enabled $v', () => enabled = v)),
          const SizedBox(height: 8),
          NChoiceChipListItem<BlendMode>(
            title: const Text('blendMode'),
            values: BlendMode.values,
            value: blendMode,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('blendMode ${e.name}', () => blendMode = e),
          ),
        ],
      ),
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    filterKind = _FilterKind.blur;
    sigmaX = 5;
    sigmaY = 5;
    tileMode = TileMode.clamp;
    radiusX = 2;
    radiusY = 2;
    blendMode = BlendMode.srcOver;
    enabled = true;
    childKind = _ChildKind.overlay;
    lastEvent = '—';
    setState(() {});
  }
}
