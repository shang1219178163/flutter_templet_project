//
//  AnimatedSwitcherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 10:08 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// transitionBuilder 预设
enum _TransitionKind {
  slide(label: 'slide'),
  fade(label: 'fade'),
  scale(label: 'scale');
  const _TransitionKind({required this.label});
  final String label;
}

/// layoutBuilder 预设
enum _LayoutKind {
  defaults(label: 'defaults'),
  stack(label: 'stack');
  const _LayoutKind({required this.label});
  final String label;
}

class AnimatedSwitcherDemo extends StatefulWidget {
  const AnimatedSwitcherDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 原 Demo 文字 + NSlideTransition 上入
  int count = 0;
  bool useChild = true;
  _TransitionKind transitionKind = _TransitionKind.slide;
  AxisDirection slideDirection = AxisDirection.up;
  _LayoutKind layoutKind = _LayoutKind.defaults;
  Alignment layoutAlignment = Alignment.center;
  double durationMs = 200;
  bool useReverseDuration = false;
  double reverseDurationMs = 200;
  Curve switchInCurve = Curves.linear;
  Curve switchOutCurve = Curves.linear;
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
          final previewHeight = (constraints.maxHeight * 0.36).clamp(200.0, 320.0);
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
                            NLangEnum.en: 'Widget AnimatedSwitcher',
                            NLangEnum.zh: '组件 AnimatedSwitcher',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Child must change Key or type to animate. Tap +1 to bump the original counter text.',
                              NLangEnum.zh: 'child 必须换 Key 或类型才会切换。点「+1」即原来的计数文字。',
                            },
                            {
                              NLangEnum.en:
                                  'Original transition is NSlideTransition. reverseDuration is null unless enabled.',
                              NLangEnum.zh: '原过渡是 NSlideTransition。未开启时 reverseDuration 为 null。',
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
              child: ColoredBox(
                color: scheme.surface,
                child: Center(
                  child: buildSwitcher(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: OutlinedButton(
              onPressed: onPlus,
              child: const Text('+1'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitcher() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: durationMs.round()),
      reverseDuration: useReverseDuration ? Duration(milliseconds: reverseDurationMs.round()) : null,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: onTransition,
      layoutBuilder: onLayout,
      child: useChild
          ? Text(
              '第 $count 相很长长长',
              key: ValueKey<int>(count),
              style: theme.textTheme.titleMedium,
            )
          : null,
    );
  }

  Widget onTransition(Widget child, Animation<double> animation) {
    switch (transitionKind) {
      case _TransitionKind.slide:
        return NSlideTransition(
          direction: slideDirection,
          position: animation,
          child: child,
        );
      case _TransitionKind.fade:
        return AnimatedSwitcher.defaultTransitionBuilder(child, animation);
      case _TransitionKind.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );
    }
  }

  Widget onLayout(Widget? currentChild, List<Widget> previousChildren) {
    switch (layoutKind) {
      case _LayoutKind.defaults:
        return AnimatedSwitcher.defaultLayoutBuilder(currentChild, previousChildren);
      case _LayoutKind.stack:
        return Stack(
          alignment: layoutAlignment,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
    }
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'child · transitionBuilder · layoutBuilder',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListTile(
            title: const Text('child'),
            value: useChild,
            onChanged: (v) => onMark('child $v', () => useChild = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<_TransitionKind>(
            title: const Text('transitionBuilder'),
            values: _TransitionKind.values,
            value: transitionKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('transitionBuilder ${e.label}', () => transitionKind = e),
          ),
          if (transitionKind == _TransitionKind.slide) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem<AxisDirection>(
              title: const Text('NSlideTransition.direction'),
              values: AxisDirection.values,
              value: slideDirection,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('direction ${e.name}', () => slideDirection = e),
            ),
          ],
          const SizedBox(height: 8),
          NChoiceChipListItem<_LayoutKind>(
            title: const Text('layoutBuilder'),
            values: _LayoutKind.values,
            value: layoutKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('layoutBuilder ${e.label}', () => layoutKind = e),
          ),
          if (layoutKind == _LayoutKind.stack) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem<Alignment>(
              title: const Text('Stack.alignment'),
              values: AlignmentExt.allCases,
              value: layoutAlignment,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: (e) => onMark('alignment ${e.toString().split('.').last}', () => layoutAlignment = e),
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
      subtitle: 'duration · reverseDuration · switchInCurve · switchOutCurve',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('duration'),
            min: 100,
            max: 3000,
            value: durationMs.clamp(100, 3000),
            onChanged: (v) => onMark('duration ${v.round()}ms', () => durationMs = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          NSwitchListTile(
            title: const Text('reverseDuration'),
            value: useReverseDuration,
            onChanged: (v) => onMark('reverseDuration $v', () => useReverseDuration = v),
          ),
          if (useReverseDuration)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('reverseDuration'),
              min: 100,
              max: 3000,
              value: reverseDurationMs.clamp(100, 3000),
              onChanged: (v) => onMark('reverseDuration ${v.round()}ms', () => reverseDurationMs = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                final ms = v.round();
                final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
                return Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
                );
              },
            ),
          const SizedBox(height: 8),
          NChoiceChipListItem<Curve>(
            title: const Text('switchInCurve'),
            values: NDecorationCard.curvePresets,
            onEqual: (e) => identical(switchInCurve, e),
            labelOf: NDecorationCard.nameOfCurve,
            onChanged: (e) => onMark('switchInCurve ${NDecorationCard.nameOfCurve(e)}', () => switchInCurve = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<Curve>(
            title: const Text('switchOutCurve'),
            values: NDecorationCard.curvePresets,
            onEqual: (e) => identical(switchOutCurve, e),
            labelOf: NDecorationCard.nameOfCurve,
            onChanged: (e) => onMark('switchOutCurve ${NDecorationCard.nameOfCurve(e)}', () => switchOutCurve = e),
          ),
        ],
      ),
    );
  }


  void onPlus() {
    onMark('onPlus ${count + 1}', () => count += 1);
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    count = 0;
    useChild = true;
    transitionKind = _TransitionKind.slide;
    slideDirection = AxisDirection.up;
    layoutKind = _LayoutKind.defaults;
    layoutAlignment = Alignment.center;
    durationMs = 200;
    useReverseDuration = false;
    reverseDurationMs = 200;
    switchInCurve = Curves.linear;
    switchOutCurve = Curves.linear;
    lastEvent = '—';
    setState(() {});
  }
}

///移动动画
class LineSlideTransition extends AnimatedWidget {
  const LineSlideTransition({
    Key? key,
    required Animation<Offset> position,
    this.transformHitTests = true,
    required this.child,
  }) : super(key: key, listenable: position);

  final bool transformHitTests;

  final Widget child;

  Animation<Offset> get position => listenable as Animation<Offset>;

  @override
  Widget build(BuildContext context) {
    var offset = position.value;
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, -offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}
