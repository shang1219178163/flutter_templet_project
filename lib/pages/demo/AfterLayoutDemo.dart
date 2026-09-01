//
//  AfterLayoutDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 6:39 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/after_layout_builder.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
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
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  static const _seed = 'flutter 实战 ';

  String _text = _seed;
  Size? measuredSize;
  Rect? ancestorRect;
  int measureEpoch = 0;
  String lastEvent = '—';

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
      ),
    );
  }

  Widget buildPreview() {
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
                '$lastEvent\nsize: ${measuredSize?.toStringAsFixed(fractionDigits: 1, separator: ' × ') ?? '—'}  ·  A in Container: ${ancestorRect?.toStringAsFixed(fractionDigits: 1) ?? '—'}',
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
    final scheme = theme.colorScheme;
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
    final scheme = theme.colorScheme;
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
    final scheme = theme.colorScheme;
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
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'child · padding · fontSize · maxWidth · backgroundColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<bool>(
            title: const Text('child'),
            values: const [true, false],
            value: useChild,
            labelOf: (e) => e ? 'Text' : 'null',
            onChanged: (e) => onMark('child ${e ? 'Text' : 'null'}', () => useChild = e),
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('padding'),
            min: 0,
            max: 32,
            value: padding.clamp(0, 32),
            onChanged: (v) => onMark('padding ${v.round()}', () => padding = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('fontSize'),
            min: 12,
            max: 28,
            value: fontSize.clamp(12, 28),
            onChanged: (v) => onMark('fontSize ${v.round()}', () => fontSize = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('maxWidth'),
            min: 80,
            max: 320,
            value: maxWidth.clamp(80, 320),
            onChanged: (v) => onMark('maxWidth ${v.round()}', () => maxWidth = v),
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('backgroundColor'),
            value: backgroundColor,
            onChanged: (e) => onMark('backgroundColor $e', () => backgroundColor = e),
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: '追加字符串 · 点击读取 context.size',
      child: Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonal(
          onPressed: () => onMark('append', () => _text += _seed),
          child: const Text('追加字符串'),
        ),
      ),
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

  void onTapSample(BuildContext context) {
    final size = context.size;
    final sizeText = size?.toStringAsFixed(fractionDigits: 1, separator: ' × ') ?? '—';
    onMark('onTap $sizeText');
    SnackUtil.show('context.size: $sizeText');
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    if (apply != null) {
      bumpMeasure();
    }
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    _text = _seed;
    useChild = true;
    padding = 12;
    fontSize = 16;
    maxWidth = 220;
    backgroundColor = null;
    lastEvent = '—';
    bumpMeasure();
    setState(() {});
  }
}
