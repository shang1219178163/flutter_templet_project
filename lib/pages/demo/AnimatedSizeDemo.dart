import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class AnimatedSizeDemo extends StatefulWidget {
  AnimatedSizeDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AnimatedSizeDemo> createState() => _AnimatedSizeDemoState();
}

class _AnimatedSizeDemoState extends State<AnimatedSizeDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 原 Demo 琥珀色区域 100 ↔ 250，FlutterLogo 固定 100
  bool large = false;
  double containerSize = 100;
  double logoSize = 100;
  bool useChild = true;
  Alignment alignment = Alignment.center;
  Curve curve = Curves.easeIn;
  double durationMs = 1000;
  bool useReverseDuration = false;
  double reverseDurationMs = 1000;
  Clip clipBehavior = Clip.hardEdge;
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
          final previewHeight = (constraints.maxHeight * 0.42).clamp(280.0, 400.0);
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
                            NLangEnum.en: 'Widget AnimatedSize',
                            NLangEnum.zh: '组件 AnimatedSize',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Tap the amber box (or 切换尺寸) to toggle the container 100 ↔ 250. FlutterLogo stays 100. alignment places the logo in the box and during the size animation.',
                              NLangEnum.zh:
                                  '点琥珀色容器或「切换尺寸」只改容器 100 ↔ 250，FlutterLogo 固定 100。alignment 决定 Logo 在容器内及尺寸动画过程中的对齐。',
                            },
                            {
                              NLangEnum.en:
                                  'Original curve is Curves.easeIn, duration 1s, clipBehavior Clip.hardEdge. onEnd fires when the size animation finishes; reverseDuration is null unless enabled.',
                              NLangEnum.zh: '原 Demo 为 Curves.easeIn、duration 1s、clipBehavior Clip.hardEdge。尺寸动画结束触发 onEnd；未开启时 reverseDuration 为 null。',
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
                  child: buildAnimatedSize(),
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
            child: FilledButton.tonal(
              onPressed: onToggleSize,
              child: const Text('切换尺寸'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedSize() {
    return GestureDetector(
      onTap: onToggleSize,
      child: AnimatedSize(
        alignment: alignment,
        curve: curve,
        duration: Duration(milliseconds: durationMs.round()),
        reverseDuration: useReverseDuration ? Duration(milliseconds: reverseDurationMs.round()) : null,
        clipBehavior: clipBehavior,
        onEnd: onEnd,
        child: useChild
            ? Container(
                width: containerSize,
                height: containerSize,
                color: Colors.amberAccent,
                alignment: alignment,
                child: FlutterLogo(
                  size: logoSize,
                  duration: Duration.zero,
                ),
              )
            : null,
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'child · alignment · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListItem(
            title: const Text('child'),
            value: useChild,
            onChanged: (v) => onMark('child $v', () => useChild = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<Alignment>(
            title: const Text('alignment'),
            values: AlignmentExt.allCases,
            value: alignment,
            labelOf: (e) => e.toString().split('.').last,
            onChanged: (e) => onMark('alignment ${e.toString().split('.').last}', () => alignment = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<Clip>(
            title: const Text('clipBehavior'),
            values: Clip.values,
            value: clipBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'duration · reverseDuration · curve · onEnd',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSliderListItem(
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
          NSwitchListItem(
            title: const Text('reverseDuration'),
            value: useReverseDuration,
            onChanged: (v) => onMark('reverseDuration $v', () => useReverseDuration = v),
          ),
          if (useReverseDuration)
            NSliderListItem(
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
            title: const Text('curve'),
            values: NDecorationCard.curvePresets,
            onEqual: (e) => identical(curve, e),
            labelOf: NDecorationCard.nameOfCurve,
            onChanged: (e) => onMark('curve ${NDecorationCard.nameOfCurve(e)}', () => curve = e),
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

  void onToggleSize() {
    large = !large;
    containerSize = large ? 250 : 100;
    onMark('onToggleSize $containerSize');
  }

  void onEnd() {
    onMark('onEnd');
  }

  void onReset() {
    large = false;
    containerSize = 100;
    logoSize = 100;
    useChild = true;
    alignment = Alignment.center;
    curve = Curves.easeIn;
    durationMs = 1000;
    useReverseDuration = false;
    reverseDurationMs = 1000;
    clipBehavior = Clip.hardEdge;
    lastEvent = '—';
    setState(() {});
  }
}
