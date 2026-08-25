//
//  AnimatedSwitcherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 10:08 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// transitionBuilder 预设
enum _TransitionKind { slide, fade, scale }

/// layoutBuilder 预设
enum _LayoutKind { defaults, stack }

class AnimatedSwitcherDemo extends StatefulWidget {
  const AnimatedSwitcherDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
                                  'Original transition is NSlideTransition. fade is AnimatedSwitcher.defaultTransitionBuilder.',
                              NLangEnum.zh: '原过渡是 NSlideTransition。fade 即 AnimatedSwitcher.defaultTransitionBuilder。',
                            },
                            {
                              NLangEnum.en:
                                  'layoutBuilder defaults to a centered Stack. reverseDuration is null unless enabled.',
                              NLangEnum.zh: 'layoutBuilder 默认居中 Stack。未开启时 reverseDuration 为 null。',
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
              style: Theme.of(context).textTheme.titleMedium,
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
    return NStyleCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'child · transitionBuilder · layoutBuilder',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'child',
            value: useChild,
            onChanged: onUseChild,
          ),
          buildField(
            label: 'transitionBuilder',
            showTopGap: true,
            child: buildChoiceChips(
              values: _TransitionKind.values,
              isSelected: (e) => transitionKind == e,
              labelOf: (e) => e.name,
              onChanged: onTransitionKind,
            ),
          ),
          if (transitionKind == _TransitionKind.slide)
            buildField(
              label: 'NSlideTransition.direction',
              showTopGap: true,
              child: buildChoiceChips(
                values: AxisDirection.values,
                isSelected: (e) => slideDirection == e,
                labelOf: (e) => e.name,
                onChanged: onSlideDirection,
              ),
            ),
          buildField(
            label: 'layoutBuilder',
            showTopGap: true,
            child: buildChoiceChips(
              values: _LayoutKind.values,
              isSelected: (e) => layoutKind == e,
              labelOf: (e) => e.name,
              onChanged: onLayoutKind,
            ),
          ),
          if (layoutKind == _LayoutKind.stack)
            buildField(
              label: 'Stack.alignment',
              showTopGap: true,
              child: buildChoiceChips(
                values: AlignmentExt.allCases,
                isSelected: (e) => layoutAlignment == e,
                labelOf: (e) => e.toString().split('.').last,
                onChanged: onLayoutAlignment,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NStyleCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'duration · reverseDuration · switchInCurve · switchOutCurve',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'duration',
            value: durationMs,
            min: 100,
            max: 3000,
            onChanged: onDurationMs,
            durationLabel: true,
          ),
          buildSwitch(
            title: 'reverseDuration',
            value: useReverseDuration,
            onChanged: onUseReverseDuration,
          ),
          if (useReverseDuration)
            buildSlider(
              label: 'reverseDuration',
              value: reverseDurationMs,
              min: 100,
              max: 3000,
              onChanged: onReverseDurationMs,
              durationLabel: true,
            ),
          buildField(
            label: 'switchInCurve',
            showTopGap: true,
            child: buildChoiceChips(
              values: NStyleCard.curvePresets,
              isSelected: (e) => identical(switchInCurve, e),
              labelOf: NStyleCard.nameOfCurve,
              onChanged: onSwitchInCurve,
            ),
          ),
          buildField(
            label: 'switchOutCurve',
            showTopGap: true,
            child: buildChoiceChips(
              values: NStyleCard.curvePresets,
              isSelected: (e) => identical(switchOutCurve, e),
              labelOf: NStyleCard.nameOfCurve,
              onChanged: onSwitchOutCurve,
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
    bool durationLabel = false,
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
      trailingBuilder: durationLabel
          ? (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
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

  void onPlus() {
    count += 1;
    lastEvent = 'onPlus $count';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onUseChild(bool value) {
    useChild = value;
    setState(() {});
  }

  void onTransitionKind(_TransitionKind value) {
    transitionKind = value;
    setState(() {});
  }

  void onSlideDirection(AxisDirection value) {
    slideDirection = value;
    setState(() {});
  }

  void onLayoutKind(_LayoutKind value) {
    layoutKind = value;
    setState(() {});
  }

  void onLayoutAlignment(Alignment value) {
    layoutAlignment = value;
    setState(() {});
  }

  void onDurationMs(double value) {
    durationMs = value;
    setState(() {});
  }

  void onUseReverseDuration(bool value) {
    useReverseDuration = value;
    setState(() {});
  }

  void onReverseDurationMs(double value) {
    reverseDurationMs = value;
    setState(() {});
  }

  void onSwitchInCurve(Curve value) {
    switchInCurve = value;
    setState(() {});
  }

  void onSwitchOutCurve(Curve value) {
    switchOutCurve = value;
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
