import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 视图类型
enum _ViewKind {
  int8(label: 'int8'),
  uint8(label: 'uint8'),
  uint16(label: 'uint16'),
  uint32(label: 'uint32'),
  ;
  const _ViewKind({required this.label});
  final String label;
  List<int> view(Uint8List bytes) {
    return switch (this) {
      _ViewKind.int8 => bytes.buffer.asInt8List(),
      _ViewKind.uint8 => bytes.buffer.asUint8List(),
      _ViewKind.uint16 => bytes.buffer.asUint16List(),
      _ViewKind.uint32 => bytes.buffer.asUint32List(),
    };
  }
}

class Uint8ListDemo extends StatefulWidget {
  Uint8ListDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Uint8ListDemo> createState() => _Uint8ListDemoState();
}

class _Uint8ListDemoState extends State<Uint8ListDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

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
    final scheme = theme.colorScheme;
    final bytes = Uint8List.fromList(source);
    final viewed = viewKind.view(bytes);
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
    return NDecorationCard(
      icon: const Icon(Icons.memory_rounded),
      title: '视图',
      subtitle: 'buffer.asXxxList',
      child: NChoiceChipListItem<_ViewKind>(
        title: const Text('buffer.asXxxList'),
        values: _ViewKind.values,
        value: viewKind,
        labelOf: (e) => e.label,
        onChanged: onViewKind,
      ),
    );
  }

  void onPress() {
    final bytes = Uint8List.fromList(source);
    final viewed = viewKind.view(bytes);
    lastEvent = '${viewKind.label} $viewed';
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
