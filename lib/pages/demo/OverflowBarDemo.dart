//
//  OverflowBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:34 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class OverflowBarDemo extends StatefulWidget {
  const OverflowBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<OverflowBarDemo> createState() => _OverflowBarDemoState();
}

class _OverflowBarDemoState extends State<OverflowBarDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 最近事件
  String lastEvent = '—';
  /// 水平子项间距
  double spacing = 8;
  /// 水平主轴对齐，null 表示按内容宽度
  MainAxisAlignment? alignment;
  /// overflow 垂直间距
  double overflowSpacing = 0;
  /// overflow 水平对齐
  OverflowBarAlignment overflowAlignment = OverflowBarAlignment.end;
  /// overflow 垂直方向
  VerticalDirection overflowDirection = VerticalDirection.down;
  /// 文字方向
  TextDirection? textDirection;

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
                        NLangEnum.en: 'Widget OverflowBar',
                        NLangEnum.zh: '组件 OverflowBar',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'Placeholder plus Cancel / Really Really Cancel / OK are the original children. Horizontal layout uses spacing; if they do not fit, overflowAlignment applies.',
                          NLangEnum.zh: '占位图与 Cancel、Really Really Cancel、OK 是原内容。能放下走 spacing，放不下走 overflowAlignment。',
                        },
                      ],
                    ),
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
    final previewHeight = (248 + overflowSpacing * 2).clamp(248.0, 400.0);
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
              height: previewHeight,
              width: double.infinity,
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.15),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Material(
                      color: Colors.white,
                      elevation: 24,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 128, child: Placeholder()),
                              const SizedBox(height: 5),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: OverflowBar(
                                  spacing: spacing,
                                  alignment: alignment,
                                  overflowSpacing: overflowSpacing,
                                  overflowAlignment: overflowAlignment,
                                  overflowDirection: overflowDirection,
                                  textDirection: textDirection,
                                  children: [
                                    TextButton(
                                      onPressed: () => onTap('Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => onTap('Really Really Cancel'),
                                      child: const Text('Really Really Cancel'),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => onTap('OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'lastEvent: $lastEvent',
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

  Widget buildBehaviorCard() {
    return NStyleCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'spacing  alignment  overflowSpacing  overflowAlignment  overflowDirection  textDirection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'spacing',
            value: spacing,
            min: 0,
            max: 32,
            onChanged: (v) => onMark('spacing ${v.round()}', () => spacing = v),
          ),
          const Text('alignment'),
          buildChoiceChips(
            values: [null, ...MainAxisAlignment.values],
            value: alignment,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('alignment ${e?.name ?? 'null'}', () => alignment = e),
          ),
          buildSlider(
            label: 'overflowSpacing',
            value: overflowSpacing,
            min: 0,
            max: 32,
            onChanged: (v) => onMark('overflowSpacing ${v.round()}', () => overflowSpacing = v),
          ),
          const Text('overflowAlignment'),
          buildChoiceChips(
            values: OverflowBarAlignment.values,
            value: overflowAlignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('overflowAlignment ${e.name}', () => overflowAlignment = e),
          ),
          const Text('overflowDirection'),
          buildChoiceChips(
            values: VerticalDirection.values,
            value: overflowDirection,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('overflowDirection ${e.name}', () => overflowDirection = e),
          ),
          const Text('textDirection'),
          buildChoiceChips(
            values: const [null, TextDirection.ltr, TextDirection.rtl],
            value: textDirection,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('textDirection ${e?.name ?? 'null'}', () => textDirection = e),
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required T value,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((e) {
        final selected = e == value;
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
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
      inactiveColor: Colors.black12,
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    spacing = 8;
    alignment = null;
    overflowSpacing = 0;
    overflowAlignment = OverflowBarAlignment.end;
    overflowDirection = VerticalDirection.down;
    textDirection = null;
    setState(() {});
  }

  void onTap(String name) {
    lastEvent = 'onPressed $name';
    DLog.d(lastEvent);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lastEvent), duration: const Duration(milliseconds: 800)),
    );
    setState(() {});
  }
}
