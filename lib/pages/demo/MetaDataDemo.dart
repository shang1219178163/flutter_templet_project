//
//  MetaDataDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/27 09:07.
//  Copyright © 2025/3/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// metaData 预设
enum _MetaKind { map, text, nil }

class MetaDataDemo extends StatefulWidget {
  const MetaDataDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<MetaDataDemo> createState() => _MetaDataDemoState();
}

class _MetaDataDemoState extends State<MetaDataDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// metaData 预设，原 Demo 为自定义 Map
  _MetaKind metaKind = _MetaKind.map;
  /// 命中测试行为
  HitTestBehavior behavior = HitTestBehavior.deferToChild;
  /// 最近事件
  String lastEvent = '—';

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
              title: Text('$widget'),
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
                        NLangEnum.en: 'Widget MetaData',
                        NLangEnum.zh: '组件 MetaData',
                      },
                      items: [
                        {
                          NLangEnum.en: 'metaData is opaque to the render tree. Read it with findAncestorWidgetOfExactType.',
                          NLangEnum.zh: 'metaData 对渲染树透明。用 findAncestorWidgetOfExactType 读取。',
                        },
                        {
                          NLangEnum.en: 'The print button is the original Demo child.',
                          NLangEnum.zh: '「打印 MetaData」就是原来 Demo 的 child。',
                        },
                      ],
                    ),
                    buildConstructCard(),
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
          children: [
            Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
            if (widget.arguments != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('${widget.arguments}'),
              ),
            const SizedBox(height: 12),
            MetaData(
              metaData: metaDataOf(),
              behavior: behavior,
              child: Builder(
                builder: (context) {
                  final metaData = context.findAncestorWidgetOfExactType<MetaData>()?.metaData;
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onPrint(metaData);
                        },
                        child: const Text('打印 MetaData'),
                      ),
                      const SizedBox(height: 12),
                      Text('MetaData: ${metaData ?? "-"}'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'metaData · behavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'metaData',
            child: buildChoiceChips(
              values: _MetaKind.values,
              isSelected: (e) => metaKind == e,
              labelOf: (e) {
                switch (e) {
                  case _MetaKind.map:
                    return '{key, value}';
                  case _MetaKind.text:
                    return 'String';
                  case _MetaKind.nil:
                    return 'null';
                }
              },
              onChanged: onMetaKind,
            ),
          ),
          buildField(
            label: 'behavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: HitTestBehavior.values,
              isSelected: (e) => behavior == e,
              labelOf: (e) => e.name,
              onChanged: onBehavior,
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

  dynamic metaDataOf() {
    switch (metaKind) {
      case _MetaKind.map:
        return {'key': 'MetaData', 'value': 'MetaData自定义数据'};
      case _MetaKind.text:
        return 'MetaData自定义数据';
      case _MetaKind.nil:
        return null;
    }
  }

  void onPrint(dynamic metaData) {
    lastEvent = 'onPressed $metaData';
    DLog.d('MetaData 参数: $metaData');
    setState(() {});
  }

  void onMetaKind(_MetaKind value) {
    metaKind = value;
    setState(() {});
  }

  void onBehavior(HitTestBehavior value) {
    behavior = value;
    setState(() {});
  }

  void onReset() {
    metaKind = _MetaKind.map;
    behavior = HitTestBehavior.deferToChild;
    lastEvent = '—';
    setState(() {});
  }
}
