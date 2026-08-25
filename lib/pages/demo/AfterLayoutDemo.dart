//
//  AfterLayoutDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 6:39 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/after_layout_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class AfterLayoutDemo extends StatefulWidget {
  const AfterLayoutDemo({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<AfterLayoutDemo> createState() => _AfterLayoutDemoState();
}

class _AfterLayoutDemoState extends State<AfterLayoutDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  static const _seed = 'flutter 实战 ';

  String _text = _seed;
  Size? measuredSize;
  Rect? ancestorRect;
  int measureEpoch = 0;

  bool useChild = true;
  double padding = 12;
  double fontSize = 16;
  double maxWidth = 220;
  Color? backgroundColor;

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
      child: Column(
        children: [
          buildPreview(),
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
                        NLangEnum.en: 'Widget AfterLayoutBuilder',
                        NLangEnum.zh: '组件 AfterLayoutBuilder',
                      },
                      items: [
                        {
                          NLangEnum.en: 'AfterLayoutBuilder reports context.size on the first frame after layout.',
                          NLangEnum.zh: 'AfterLayoutBuilder 在首帧布局完成后回传 context.size。',
                        },
                        {
                          NLangEnum.en: 'Tap the sample to read size via Builder; A is measured inside a 100×100 ancestor.',
                          NLangEnum.zh: '点击样例可通过 Builder 读取尺寸；右侧 A 在 100×100 祖先中测量相对范围。',
                        },
                        {
                          NLangEnum.en: 'Append text or change padding / fontSize / maxWidth to relayout and remount.',
                          NLangEnum.zh: '追加字符串或调节 padding、fontSize、maxWidth 会重新布局并再次测量。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSizeCard(),
                    buildSurfaceCard(),
                    buildBehaviorCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreview() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 168,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRect(
                      child: Center(
                        child: SingleChildScrollView(
                          child: buildMeasuredSample(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  buildAncestorSample(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                [
                  'size: ${formatSize(measuredSize)}',
                  'A in Container: ${formatRect(ancestorRect)}',
                ].join('  ·  '),
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMeasuredSample() {
    return AfterLayoutBuilder(
      key: ValueKey('sample-$measureEpoch-$useChild'),
      builder: (context, child, size) {
        onMeasured(size);
        return child ?? buildNullChild();
      },
      child: useChild ? buildSampleChild() : null,
    );
  }

  Widget buildSampleChild() {
    final scheme = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        return Material(
          color: backgroundColor ?? scheme.primaryContainer.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => onTapSample(context),
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: scheme.onPrimaryContainer,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNullChild() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 160,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant, style: BorderStyle.solid),
      ),
      child: Text(
        'child: null',
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          fontFamily: 'monospace',
          fontSize: 12.5,
        ),
      ),
    );
  }

  Widget buildAncestorSample() {
    final scheme = Theme.of(context).colorScheme;
    return Builder(
      builder: (parentContext) {
        return Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.65)),
          ),
          child: AfterLayoutBuilder(
            key: ValueKey('ancestor-$measureEpoch'),
            builder: (context, child, size) {
              onAncestorMeasured(parentContext, context);
              return child ?? const SizedBox.shrink();
            },
            child: Text(
              'A',
              style: TextStyle(
                fontSize: fontSize.clamp(12, 28),
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildConstructCard() {
    return NStyleCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'child',
      child: buildField(
        label: 'child',
        child: buildChoiceChips(
          values: const [true, false],
          isSelected: (e) => useChild == e,
          labelOf: (e) => e ? 'Text' : 'null',
          onChanged: onUseChild,
        ),
      ),
    );
  }

  Widget buildSizeCard() {
    return NStyleCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'padding · fontSize · maxWidth',
      child: Column(
        children: [
          buildSlider(label: 'padding', value: padding, min: 0, max: 32, onChanged: onPadding),
          buildSlider(label: 'fontSize', value: fontSize, min: 12, max: 28, onChanged: onFontSize),
          buildSlider(label: 'maxWidth', value: maxWidth, min: 80, max: 320, onChanged: onMaxWidth),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NStyleCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'backgroundColor',
      child: buildField(
        label: 'backgroundColor',
        child: buildColorDots(value: backgroundColor, onChanged: onBackgroundColor),
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NStyleCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: '追加字符串 · 点击读取 context.size',
      child: Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonal(
          onPressed: onAppendText,
          child: const Text('追加字符串'),
        ),
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

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(e),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e ?? scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.65),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: e == null
                  ? Text(
                      '默',
                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    )
                  : selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
            ),
          ),
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
      inactiveColor: Colors.black12,
    );
  }

  void bumpMeasure() {
    measureEpoch++;
    measuredSize = null;
    ancestorRect = null;
  }

  void onMeasured(Size? size) {
    if (size == measuredSize) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || size == measuredSize) {
        return;
      }
      measuredSize = size;
      setState(() {});
    });
  }

  void onAncestorMeasured(BuildContext parent, BuildContext child) {
    final childBox = child.findRenderObject();
    final parentBox = parent.findRenderObject();
    if (childBox is! RenderBox || parentBox is! RenderBox || !childBox.hasSize) {
      return;
    }
    final offset = childBox.localToGlobal(Offset.zero, ancestor: parentBox);
    final rect = offset & childBox.size;
    if (rect == ancestorRect) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || rect == ancestorRect) {
        return;
      }
      ancestorRect = rect;
      setState(() {});
    });
  }

  void onUseChild(bool value) {
    useChild = value;
    bumpMeasure();
    setState(() {});
  }

  void onPadding(double value) {
    padding = value;
    bumpMeasure();
    setState(() {});
  }

  void onFontSize(double value) {
    fontSize = value;
    bumpMeasure();
    setState(() {});
  }

  void onMaxWidth(double value) {
    maxWidth = value;
    bumpMeasure();
    setState(() {});
  }

  void onBackgroundColor(Color? value) {
    backgroundColor = value;
    bumpMeasure();
    setState(() {});
  }

  void onAppendText() {
    _text += _seed;
    bumpMeasure();
    setState(() {});
  }

  void onTapSample(BuildContext context) {
    final size = context.size;
    DLog.d('Text1: $size');
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('context.size: ${formatSize(size)}'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void onReset() {
    _text = _seed;
    useChild = true;
    padding = 12;
    fontSize = 16;
    maxWidth = 220;
    backgroundColor = null;
    bumpMeasure();
    setState(() {});
  }

  String formatSize(Size? size) {
    if (size == null) {
      return '—';
    }
    return '${size.width.toStringAsFixed(1)} × ${size.height.toStringAsFixed(1)}';
  }

  String formatRect(Rect? rect) {
    if (rect == null) {
      return '—';
    }
    return 'Offset(${rect.left.toStringAsFixed(1)}, ${rect.top.toStringAsFixed(1)}) & '
        '${rect.width.toStringAsFixed(1)}×${rect.height.toStringAsFixed(1)}';
  }
}
