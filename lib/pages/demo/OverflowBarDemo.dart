//
//  OverflowBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:34 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

class OverflowBarDemo extends StatefulWidget {
  const OverflowBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<OverflowBarDemo> createState() => _OverflowBarDemoState();
}

class _OverflowBarDemoState extends State<OverflowBarDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

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
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'spacing  alignment  overflowSpacing  overflowAlignment  overflowDirection  textDirection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('spacing'),
            min: 0,
            max: 32,
            value: spacing.clamp(0, 32),
            onChanged: (v) => onMark('spacing ${v.round()}', () => spacing = v),
            activeColor: theme.colorScheme.primary,
          ),
          NChoiceChipListItem(
            title: const Text('alignment'),
            values: [null, ...MainAxisAlignment.values],
            value: alignment,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('alignment ${e?.name ?? 'null'}', () => alignment = e),
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('overflowSpacing'),
            min: 0,
            max: 32,
            value: overflowSpacing.clamp(0, 32),
            onChanged: (v) => onMark('overflowSpacing ${v.round()}', () => overflowSpacing = v),
            activeColor: theme.colorScheme.primary,
          ),
          NChoiceChipListItem(
            title: const Text('overflowAlignment'),
            values: OverflowBarAlignment.values,
            value: overflowAlignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('overflowAlignment ${e.name}', () => overflowAlignment = e),
          ),
          NChoiceChipListItem(
            title: const Text('overflowDirection'),
            values: VerticalDirection.values,
            value: overflowDirection,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('overflowDirection ${e.name}', () => overflowDirection = e),
          ),
          NChoiceChipListItem(
            title: const Text('textDirection'),
            values: const [null, TextDirection.ltr, TextDirection.rtl],
            value: textDirection,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('textDirection ${e?.name ?? 'null'}', () => textDirection = e),
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
    SnackUtil.show(lastEvent);
    setState(() {});
  }
}
