import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
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
                                  'Tap the amber box (or 切换尺寸) to toggle the container 100 ↔ 250. FlutterLogo stays 100. alignment places the logo in the box and the box during the size animation.',
                              NLangEnum.zh:
                                  '点琥珀色容器或「切换尺寸」只改容器 100 ↔ 250，FlutterLogo 固定 100。alignment 决定 Logo 在容器内的位置，以及尺寸动画过程中的对齐。',
                            },
                            {
                              NLangEnum.en:
                                  'Original curve is Curves.easeIn and duration is 1s. clipBehavior defaults to Clip.hardEdge.',
                              NLangEnum.zh: '原 Demo 为 Curves.easeIn、duration 1s。clipBehavior 默认 Clip.hardEdge。',
                            },
                            {
                              NLangEnum.en:
                                  'onEnd fires when the size animation finishes. reverseDuration is null unless enabled.',
                              NLangEnum.zh: '尺寸动画结束会触发 onEnd。未开启时 reverseDuration 为 null。',
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
          buildSwitch(
            title: 'child',
            value: useChild,
            onChanged: onUseChild,
          ),
          buildField(
            label: 'alignment',
            showTopGap: true,
            child: buildChoiceChips(
              values: AlignmentExt.allCases,
              isSelected: (e) => alignment == e,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: onAlignment,
            ),
          ),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: Clip.values,
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onClipBehavior,
            ),
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
            label: 'curve',
            showTopGap: true,
            child: buildChoiceChips(
              values: NDecorationCard.curvePresets,
              isSelected: (e) => identical(curve, e),
              labelOf: NDecorationCard.nameOfCurve,
              onChanged: onCurve,
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

  void onToggleSize() {
    large = !large;
    containerSize = large ? 250 : 100;
    lastEvent = 'onToggleSize $containerSize';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onEnd() {
    lastEvent = 'onEnd';
    DLog.d('onEnd');
    setState(() {});
  }

  void onUseChild(bool value) {
    useChild = value;
    setState(() {});
  }

  void onAlignment(Alignment value) {
    alignment = value;
    setState(() {});
  }

  void onClipBehavior(Clip value) {
    clipBehavior = value;
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

  void onCurve(Curve value) {
    curve = value;
    setState(() {});
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
