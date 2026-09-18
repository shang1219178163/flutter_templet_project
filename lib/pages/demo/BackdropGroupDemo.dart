//
//  BackdropGroupDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/18.
//  Copyright © 2026/9/18 shang. All rights reserved.
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
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// 子滤镜是否走 [BackdropFilter.grouped]
enum _FilterCtor {
  grouped(label: 'grouped'),
  plain(label: 'BackdropFilter');

  const _FilterCtor({required this.label});
  final String label;
}

/// BackdropGroup 示例：多个 BackdropFilter 共享一层背景采样
class BackdropGroupDemo extends StatefulWidget {
  const BackdropGroupDemo({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<BackdropGroupDemo> createState() => _BackdropGroupDemoState();
}

class _BackdropGroupDemoState extends State<BackdropGroupDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);
  final scrollController = ScrollController();
  final listController = ScrollController();

  String lastEvent = '—';

  bool useGroup = true;
  bool passBackdropKey = false;
  BackdropKey? customKey;
  _FilterCtor filterCtor = _FilterCtor.grouped;

  double sigma = 16;
  bool enabled = true;
  int itemCount = 8;

  BackdropKey? get backdropKey => passBackdropKey ? customKey : null;

  @override
  void dispose() {
    scrollController.dispose();
    listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? '$widget'),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: Column(
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
                      title: {NLangEnum.en: 'Description', NLangEnum.zh: '说明'},
                      subtitle: {
                        NLangEnum.en: 'Widget BackdropGroup',
                        NLangEnum.zh: '组件 BackdropGroup',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'BackdropGroup shares one backdrop sample among BackdropFilter.grouped children, so the engine blurs once. Overlapping filters must not share a key.',
                          NLangEnum.zh:
                              'BackdropGroup 让 BackdropFilter.grouped 子节点共用一次背景采样，引擎只模糊一层。互相重叠的滤镜不要共用同一个 key。',
                        },
                      ],
                    ),
                    buildGroupCard(),
                    buildFilterCard(),
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
              height: 280,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(Assets.imagesBgGlassmophism, fit: BoxFit.cover),
                    buildGroupedList(),
                  ],
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

  Widget buildGroupedList() {
    final list = ListView.separated(
      controller: listController,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: buildFilter(
            child: Material(
              color: Colors.white.withValues(alpha: 0.18),
              child: ListTile(
                title: Text('Blur item $index', style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  filterCtor == _FilterCtor.grouped ? 'BackdropFilter.grouped' : 'BackdropFilter',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                ),
                onTap: () {
                  DLog.d(index);
                  SnackUtil.show('item $index');
                },
              ),
            ),
          ),
        );
      },
    );

    if (!useGroup) {
      return list;
    }
    return BackdropGroup(
      key: ValueKey('group-${identityHashCode(backdropKey)}-$passBackdropKey'),
      backdropKey: backdropKey,
      child: list,
    );
  }

  Widget buildFilter({required Widget child}) {
    final filter = ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
    if (filterCtor == _FilterCtor.grouped) {
      return BackdropFilter.grouped(
        filter: filter,
        enabled: enabled,
        child: child,
      );
    }
    return BackdropFilter(
      filter: filter,
      enabled: enabled,
      child: child,
    );
  }

  Widget buildGroupCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: 'BackdropGroup',
      subtitle: 'child · backdropKey',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListItem(
            title: const Text('wrap BackdropGroup'),
            value: useGroup,
            onChanged: (v) => onMark('useGroup $v', () => useGroup = v),
          ),
          NSwitchListItem(
            title: const Text('pass backdropKey'),
            value: passBackdropKey,
            onChanged: (v) => onMark('passBackdropKey $v', () {
              passBackdropKey = v;
              customKey = v ? (customKey ?? BackdropKey()) : customKey;
            }),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => onMark('new BackdropKey', () {
                customKey = BackdropKey();
                passBackdropKey = true;
              }),
              child: const Text('new BackdropKey()'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterCard() {
    return NDecorationCard(
      icon: const Icon(Icons.blur_on),
      title: 'BackdropFilter',
      subtitle: 'grouped · filter · enabled',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<_FilterCtor>(
            title: const Text('constructor'),
            values: _FilterCtor.values,
            value: filterCtor,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('ctor ${e.label}', () => filterCtor = e),
          ),
          NSwitchListItem(
            title: const Text('enabled'),
            value: enabled,
            onChanged: (v) => onMark('enabled $v', () => enabled = v),
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('sigma'),
            min: 0,
            max: 40,
            value: sigma.clamp(0, 40),
            onChanged: (v) => onMark('sigma ${v.toStringAsFixed(0)}', () => sigma = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('itemCount'),
            min: 3,
            max: 20,
            value: itemCount.clamp(3, 20).toDouble(),
            onChanged: (v) => onMark('itemCount ${v.round()}', () => itemCount = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onReset() {
    useGroup = true;
    passBackdropKey = false;
    customKey = null;
    filterCtor = _FilterCtor.grouped;
    sigma = 16;
    enabled = true;
    itemCount = 8;
    lastEvent = 'reset';
    setState(() {});
  }
}
