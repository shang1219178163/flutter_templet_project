import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 视图类型
enum _ViewKind { int8, uint8, uint16, uint32 }

class Uint8ListDemo extends StatefulWidget {
  Uint8ListDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Uint8ListDemo> createState() => _Uint8ListDemoState();
}

class _Uint8ListDemoState extends State<Uint8ListDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 源字节，原 Demo [63, 158, 184, 82]
  List<int> source = [63, 158, 184, 82];
  /// 视图类型
  _ViewKind viewKind = _ViewKind.int8;
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
                        NLangEnum.en: 'TypedData Uint8List',
                        NLangEnum.zh: '类型 Uint8List',
                      },
                      items: [
                        {
                          NLangEnum.en: 'fromList([63, 158, 184, 82]) then buffer.asInt8List was the original onPress.',
                          NLangEnum.zh: '原来 onPress 是 Uint8List.fromList([63, 158, 184, 82]) 再 buffer.asInt8List。',
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
    final bytes = Uint8List.fromList(source);
    final viewed = viewOf(bytes);
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
              'Uint8List $source',
              style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 8),
            Text(
              'view $viewed',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lastEvent,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onPress,
              child: const Text('buffer 视图'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NStyleCard(
      icon: const Icon(Icons.memory_rounded),
      title: '视图',
      subtitle: 'buffer.asXxxList',
      child: buildChoiceChips(
        values: _ViewKind.values,
        isSelected: (e) => viewKind == e,
        labelOf: (e) => e.name,
        onChanged: onViewKind,
      ),
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

  List<int> viewOf(Uint8List bytes) {
    switch (viewKind) {
      case _ViewKind.int8:
        return bytes.buffer.asInt8List();
      case _ViewKind.uint8:
        return bytes.buffer.asUint8List();
      case _ViewKind.uint16:
        return bytes.buffer.asUint16List();
      case _ViewKind.uint32:
        return bytes.buffer.asUint32List();
    }
  }

  void onPress() {
    final bytes = Uint8List.fromList(source);
    final viewed = viewOf(bytes);
    lastEvent = '${viewKind.name} $viewed';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onViewKind(_ViewKind value) {
    viewKind = value;
    setState(() {});
  }

  void onReset() {
    source = [63, 158, 184, 82];
    viewKind = _ViewKind.int8;
    lastEvent = '—';
    setState(() {});
  }
}
