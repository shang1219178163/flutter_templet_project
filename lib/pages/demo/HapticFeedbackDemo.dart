//
//  HapticFeedbackDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/3 22:06.
//  Copyright © 2024/10/3 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// HapticFeedback 静态方法
enum _HapticKind { vibrate, lightImpact, mediumImpact, heavyImpact, selectionClick }

class HapticFeedbackDemo extends StatefulWidget {
  const HapticFeedbackDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<HapticFeedbackDemo> createState() => _HapticFeedbackDemoState();
}

class _HapticFeedbackDemoState extends State<HapticFeedbackDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  /// 当前方法
  _HapticKind kind = _HapticKind.vibrate;
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
              title: Text("$widget"),
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
                        NLangEnum.en: 'HapticFeedback',
                        NLangEnum.zh: 'HapticFeedback',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'HapticFeedback is an abstract final class with five parameterless static methods. The original five buttons stay in the preview.',
                          NLangEnum.zh: 'HapticFeedback 是 abstract final，只有五个无参静态方法。上方五个按钮是原预览。',
                        },
                        {
                          NLangEnum.en: 'Feel it on a real device; simulators and desktop often have no haptics.',
                          NLangEnum.zh: '真机才能感觉到震动；模拟器与桌面端通常没有触感。',
                        },
                      ],
                    ),
                    buildApiCard(),
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
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _HapticKind.values.map((e) {
                  return ElevatedButton(
                    onPressed: () => onHaptic(e),
                    child: Text(e.name),
                  );
                }).toList(),
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

  Widget buildApiCard() {
    return NDecorationCard(
      icon: const Icon(Icons.vibration_outlined),
      title: '方法',
      subtitle: 'vibrate  lightImpact  mediumImpact  heavyImpact  selectionClick',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HapticFeedback'),
          buildChoiceChips(
            values: _HapticKind.values,
            value: kind,
            labelOf: (e) => e.name,
            onChanged: onHaptic,
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

  Future<void> onHaptic(_HapticKind value) async {
    kind = value;
    lastEvent = 'HapticFeedback.${value.name}()';
    DLog.d(lastEvent);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lastEvent), duration: const Duration(milliseconds: 800)),
    );
    switch (value) {
      case _HapticKind.vibrate:
        await HapticFeedback.vibrate();
      case _HapticKind.lightImpact:
        await HapticFeedback.lightImpact();
      case _HapticKind.mediumImpact:
        await HapticFeedback.mediumImpact();
      case _HapticKind.heavyImpact:
        await HapticFeedback.heavyImpact();
      case _HapticKind.selectionClick:
        await HapticFeedback.selectionClick();
    }
  }

  void onReset() {
    kind = _HapticKind.vibrate;
    lastEvent = '—';
    setState(() {});
  }
}
