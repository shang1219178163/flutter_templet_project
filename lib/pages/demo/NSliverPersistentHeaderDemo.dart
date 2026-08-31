//
//  NnSliverPersistentHeaderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 10:30.
//  Copyright © 2023/3/25 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 构造方式
enum _HeaderKind { builder, delegate }

class NSliverPersistentHeaderDemo extends StatefulWidget {
  const NSliverPersistentHeaderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NSliverPersistentHeaderDemo> createState() => _NSliverPersistentHeaderDemoState();
}

class _NSliverPersistentHeaderDemoState extends State<NSliverPersistentHeaderDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final previewController = ScrollController();
  final tailColor = ColorExt.random;

  /// 最近事件
  String lastEvent = '—';

  /// 构造方式
  _HeaderKind kind = _HeaderKind.builder;

  /// 最小高度
  double min = 48;

  /// 最大高度
  double max = 48;

  /// 是否钉在顶部
  bool pinned = false;

  /// 是否反向滚动时立刻展开
  bool floating = false;

  @override
  void dispose() {
    scrollController.dispose();
    previewController.dispose();
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
                        NLangEnum.en: 'Widget NSliverPersistentHeaderBuilder',
                        NLangEnum.zh: '组件 NSliverPersistentHeaderBuilder',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'Green 200 / lightBlue header / 1000 tail are the original slivers. Builder wraps SliverPersistentHeader + NSliverPersistentHeaderDelegate.',
                          NLangEnum.zh:
                              '绿色 200、浅蓝 header、1000 尾部是原 sliver。Builder 封装 SliverPersistentHeader + Delegate。',
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 320,
                child: CustomScrollView(
                  controller: previewController,
                  slivers: [
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      color: Colors.green,
                      child: Text("$widget"),
                    ).toSliverToBoxAdapter(),
                    buildHeader(),
                    SliverList.separated(
                      itemBuilder: (_, i) {
                        return ListTile(title: Text("标题$i"));
                      },
                      separatorBuilder: (_, i) => Divider(
                        indent: 16,
                      ),
                      itemCount: 20,
                    ),
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

  Widget buildHeader() {
    final key = ValueKey('$kind-$min-$max-$pinned-$floating');
    return switch (kind) {
      _HeaderKind.builder => NSliverPersistentHeaderBuilder(
          key: key,
          min: min,
          max: max,
          pinned: pinned,
          floating: floating,
          builder: onHeaderBuild,
        ),
      _HeaderKind.delegate => SliverPersistentHeader(
          key: key,
          pinned: pinned,
          floating: floating,
          delegate: NSliverPersistentHeaderDelegate(
            min: min,
            max: max,
            builder: onHeaderBuild,
          ),
        ),
    };
  }

  Widget onHeaderBuild(BuildContext context, double offset, bool overlapsContent) {
    final event = 'shrinkOffset ${offset.toStringAsFixed(1)}  overlapsContent $overlapsContent';
    if (event != lastEvent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || event == lastEvent) {
          return;
        }
        lastEvent = event;
        setState(() {});
      });
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(116)),
      ),
      child: const Center(
        child: Text("NSliverPersistentHeader"),
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'builder / delegate  min  max  pinned  floating',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('构造'),
          buildChoiceChips(
            values: _HeaderKind.values,
            value: kind,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('kind ${e.name}', () => kind = e),
          ),
          buildSlider(
            label: 'min',
            value: min,
            min: 24,
            max: 120,
            onChanged: onMin,
          ),
          buildSlider(
            label: 'max',
            value: max,
            min: 24,
            max: 200,
            onChanged: onMax,
          ),
          buildSwitch(
            title: 'pinned',
            value: pinned,
            onChanged: (v) => onMark('pinned $v', () => pinned = v),
          ),
          buildSwitch(
            title: 'floating',
            value: floating,
            onChanged: (v) => onMark('floating $v', () => floating = v),
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
    return NSliderListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
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

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    kind = _HeaderKind.builder;
    min = 48;
    max = 48;
    pinned = false;
    floating = false;
    if (previewController.hasClients) {
      previewController.jumpTo(0);
    }
    setState(() {});
  }

  void onMin(double value) {
    onMark('min ${value.round()}', () {
      min = value;
      if (max < min) {
        max = min;
      }
    });
  }

  void onMax(double value) {
    onMark('max ${value.round()}', () {
      max = value;
      if (min > max) {
        min = max;
      }
    });
  }
}
