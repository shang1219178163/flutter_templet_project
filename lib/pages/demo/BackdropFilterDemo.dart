//
//  BackdropFilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:13 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:get/get.dart';

/// ImageFilter 预设，映射到 BackdropFilter.filter
enum _FilterKind { blur, dilate, erode }

/// child 预设
enum _ChildKind { overlay, hello, none }

class BackdropFilterDemo extends StatefulWidget {
  const BackdropFilterDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<BackdropFilterDemo> createState() => _BackdropFilterDemoState();
}

class _BackdropFilterDemoState extends State<BackdropFilterDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
    final scheme = Theme.of(context).colorScheme;
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
                                  'BackdropFilter only has filter, child, blendMode, and enabled. It blurs content already painted behind it.',
                              NLangEnum.zh: 'BackdropFilter 只有 filter、child、blendMode、enabled。它模糊的是已经画在后面的内容。',
                            },
                            {
                              NLangEnum.en:
                                  'Default matches the live demo: full-image blur via StackExt.createBlurView(blur: 5).',
                              NLangEnum.zh: '默认对齐当前页：整图模糊，等同 StackExt.createBlurView(blur: 5)。',
                            },
                            {
                              NLangEnum.en:
                                  'child hello is the unused frosted 200×200 Hello World square from buildBody.',
                              NLangEnum.zh: 'child 选 hello 是原文件未启用的 200×200 Hello World 毛玻璃方块。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildFilterCard(),
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
    final theme = Theme.of(context);
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
              '${filterKind.name} · ${blendMode.name} · enabled $enabled',
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
      filter: filterOf(),
      blendMode: blendMode,
      enabled: enabled,
      child: child,
    );
  }

  ImageFilter filterOf() {
    switch (filterKind) {
      case _FilterKind.blur:
        return ImageFilter.blur(
          sigmaX: sigmaX,
          sigmaY: sigmaY,
          tileMode: tileMode,
        );
      case _FilterKind.dilate:
        return ImageFilter.dilate(radiusX: radiusX, radiusY: radiusY);
      case _FilterKind.erode:
        return ImageFilter.erode(radiusX: radiusX, radiusY: radiusY);
    }
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'filter · child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'filter',
            child: buildChoiceChips(
              values: _FilterKind.values,
              isSelected: (e) => filterKind == e,
              labelOf: (e) => e.name,
              onChanged: onFilterKind,
            ),
          ),
          buildField(
            label: 'child',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ChildKind.values,
              isSelected: (e) => childKind == e,
              labelOf: (e) => e.name,
              onChanged: onChildKind,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterCard() {
    return NDecorationCard(
      icon: const Icon(Icons.blur_on_rounded),
      title: '滤镜',
      subtitle: 'ImageFilter.blur / dilate / erode',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filterKind == _FilterKind.blur) ...[
            buildSlider(
              label: 'sigmaX',
              value: sigmaX,
              min: 0,
              max: 20,
              onChanged: onSigmaX,
              fractionDigits: 1,
            ),
            buildSlider(
              label: 'sigmaY',
              value: sigmaY,
              min: 0,
              max: 20,
              onChanged: onSigmaY,
              fractionDigits: 1,
            ),
            buildField(
              label: 'tileMode',
              showTopGap: true,
              child: buildChoiceChips(
                values: TileMode.values,
                isSelected: (e) => tileMode == e,
                labelOf: (e) => e.name,
                onChanged: onTileMode,
              ),
            ),
          ],
          if (filterKind != _FilterKind.blur) ...[
            buildSlider(
              label: 'radiusX',
              value: radiusX,
              min: 0,
              max: 12,
              onChanged: onRadiusX,
              fractionDigits: 1,
            ),
            buildSlider(
              label: 'radiusY',
              value: radiusY,
              min: 0,
              max: 12,
              onChanged: onRadiusY,
              fractionDigits: 1,
            ),
          ],
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
          buildSwitch(title: 'enabled 应用滤镜', value: enabled, onChanged: onEnabled),
          buildField(
            label: 'blendMode',
            showTopGap: true,
            child: buildChoiceChips(
              values: BlendMode.values,
              isSelected: (e) => blendMode == e,
              labelOf: (e) => e.name,
              onChanged: onBlendMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required String label,
    required Widget child,
    bool showTopGap = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopGap) const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              fontSize: 12.5,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required bool Function(T value) isSelected,
    required String Function(T value) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((e) {
        final selected = isSelected(e);
        return ChoiceChip(
          label: Text(labelOf(e)),
          selected: selected,
          showCheckmark: false,
          selectedColor: scheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'monospace',
            fontSize: 12.5,
          ),
          side: BorderSide(
            color: selected ? scheme.primary.withValues(alpha: 0.35) : scheme.outlineVariant.withValues(alpha: 0.65),
          ),
          onSelected: (on) {
            if (on) {
              onChanged(e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    int fractionDigits = 0,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return NSlider(
      leading: SizedBox(
        width: 108,
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface,
            fontFamily: 'monospace',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      min: min,
      max: max,
      value: value,
      onChanged: onChanged,
      activeColor: scheme.primary,
      trailingBuilder: fractionDigits > 0
          ? (context, v) {
              return Text(
                v.toStringAsFixed(fractionDigits),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            }
          : null,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
          fontSize: 13.5,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  void onFilterKind(_FilterKind value) {
    filterKind = value;
    setState(() {});
  }

  void onChildKind(_ChildKind value) {
    childKind = value;
    setState(() {});
  }

  void onSigmaX(double value) {
    sigmaX = value;
    setState(() {});
  }

  void onSigmaY(double value) {
    sigmaY = value;
    setState(() {});
  }

  void onTileMode(TileMode value) {
    tileMode = value;
    setState(() {});
  }

  void onRadiusX(double value) {
    radiusX = value;
    setState(() {});
  }

  void onRadiusY(double value) {
    radiusY = value;
    setState(() {});
  }

  void onEnabled(bool value) {
    enabled = value;
    setState(() {});
  }

  void onBlendMode(BlendMode value) {
    blendMode = value;
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
    setState(() {});
  }
}
