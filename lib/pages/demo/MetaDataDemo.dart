//
//  MetaDataDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/27 09:07.
//  Copyright © 2025/3/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// metaData 预设
enum _MetaKind {
  map(label: '{key, value}', metaData: {'key': 'MetaData', 'value': 'MetaData自定义数据'}),
  text(label: 'String', metaData: 'MetaData自定义数据'),
  nil(label: 'null', metaData: null);
  const _MetaKind({required this.label, required this.metaData});
  final String label;
  final dynamic metaData;
}

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

  late final theme = Theme.of(context);

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
    final scheme = theme.colorScheme;
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
              metaData: metaKind.metaData,
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
          NChoiceChipListItem<_MetaKind>(
            title: const Text('metaData'),
            values: _MetaKind.values,
            value: metaKind,
            labelOf: (e) => e.label,
            onChanged: onMetaKind,
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<HitTestBehavior>(
            title: const Text('behavior'),
            values: HitTestBehavior.values,
            value: behavior,
            labelOf: (e) => e.name,
            onChanged: onBehavior,
          ),
        ],
      ),
    );
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
