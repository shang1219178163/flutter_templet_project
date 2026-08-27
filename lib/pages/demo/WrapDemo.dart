import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class WrapDemo extends StatefulWidget {
  const WrapDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<WrapDemo> createState() => _WrapDemoState();
}

class _WrapDemoState extends State<WrapDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 仅取阿里云图，便于服务端缩略
  late final List<String> imageUrls = AppRes.image.urls.where((e) => e.contains('.aliyuncs.com')).take(16).toList();

  /// 最近事件
  String lastEvent = '—';

  /// 子项数量
  int childCount = 12;

  /// 主轴方向
  Axis direction = Axis.horizontal;

  /// 主轴对齐
  WrapAlignment alignment = WrapAlignment.start;

  /// 主轴间距
  double spacing = 8;

  /// 交叉轴 run 对齐
  WrapAlignment runAlignment = WrapAlignment.start;

  /// 交叉轴间距
  double runSpacing = 8;

  /// run 内交叉轴对齐
  WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start;

  /// 文字方向
  TextDirection? textDirection;

  /// 垂直方向
  VerticalDirection verticalDirection = VerticalDirection.down;

  /// 裁剪
  ClipKind clipKind = ClipKind.none;

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
                        NLangEnum.en: 'Widget Wrap',
                        NLangEnum.zh: '组件 Wrap',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'Image tiles labeled 选项_index are the original children. spacing / runSpacing default to 8.',
                          NLangEnum.zh: '图片和 选项_index 是原内容。spacing / runSpacing 默认 8。',
                        },
                      ],
                    ),
                    buildLayoutCard(),
                    buildAlignCard(),
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
    final previewHeight = direction == Axis.vertical ? 280.0 : 240.0;
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
              height: previewHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: direction == Axis.vertical ? Axis.horizontal : Axis.vertical,
                  child: Wrap(
                    key: ValueKey(direction),
                    direction: direction,
                    alignment: alignment,
                    spacing: spacing,
                    runAlignment: runAlignment,
                    runSpacing: runSpacing,
                    crossAxisAlignment: crossAxisAlignment,
                    textDirection: textDirection,
                    verticalDirection: verticalDirection,
                    clipBehavior: clipOf(),
                    children: List.generate(childCount, (index) {
                      final url = imageUrls[index % imageUrls.length];
                      return GestureDetector(
                        onTap: () => onTap('选项_$index'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NNetworkImage(
                                width: 50,
                                height: 60,
                                url: url,
                                fit: BoxFit.cover,
                              ),
                              Text('选项_$index'),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
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

  Clip clipOf() {
    return switch (clipKind) {
      ClipKind.hardEdge => Clip.hardEdge,
      ClipKind.antiAlias => Clip.antiAlias,
      ClipKind.antiAliasWithSaveLayer => Clip.antiAliasWithSaveLayer,
      ClipKind.nil || ClipKind.none => Clip.none,
    };
  }

  Widget buildLayoutCard() {
    return NDecorationCard(
      icon: const Icon(Icons.wrap_text),
      title: '布局',
      subtitle: 'direction  spacing  runSpacing  children  clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('direction'),
          buildChoiceChips(
            values: Axis.values,
            value: direction,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('direction ${e.name}', () => direction = e),
          ),
          buildSlider(
            label: 'children',
            value: childCount.toDouble(),
            min: 1,
            max: 16,
            onChanged: (v) => onMark('children ${v.round()}', () => childCount = v.round()),
          ),
          buildSlider(
            label: 'spacing',
            value: spacing,
            min: 8,
            max: 32,
            onChanged: (v) => onMark('spacing ${v.round()}', () => spacing = v),
          ),
          buildSlider(
            label: 'runSpacing',
            value: runSpacing,
            min: 8,
            max: 32,
            onChanged: (v) => onMark('runSpacing ${v.round()}', () => runSpacing = v),
          ),
          const Text('clipBehavior'),
          buildChoiceChips(
            values: ClipKind.values.where((e) => e != ClipKind.nil).toList(),
            value: clipKind == ClipKind.nil ? ClipKind.none : clipKind,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipKind = e),
          ),
        ],
      ),
    );
  }

  Widget buildAlignCard() {
    return NDecorationCard(
      icon: const Icon(Icons.align_horizontal_left),
      title: '对齐',
      subtitle: 'alignment  runAlignment  crossAxisAlignment  textDirection  verticalDirection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('alignment'),
          buildChoiceChips(
            values: WrapAlignment.values,
            value: alignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('alignment ${e.name}', () => alignment = e),
          ),
          const Text('runAlignment'),
          buildChoiceChips(
            values: WrapAlignment.values,
            value: runAlignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('runAlignment ${e.name}', () => runAlignment = e),
          ),
          const Text('crossAxisAlignment'),
          buildChoiceChips(
            values: WrapCrossAlignment.values,
            value: crossAxisAlignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('crossAxisAlignment ${e.name}', () => crossAxisAlignment = e),
          ),
          const Text('textDirection'),
          buildChoiceChips(
            values: const [null, TextDirection.ltr, TextDirection.rtl],
            value: textDirection,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('textDirection ${e?.name ?? 'null'}', () => textDirection = e),
          ),
          const Text('verticalDirection'),
          buildChoiceChips(
            values: VerticalDirection.values,
            value: verticalDirection,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('verticalDirection ${e.name}', () => verticalDirection = e),
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
    return NSlider(
      leading: SizedBox(
        width: 108,
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
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
    childCount = 12;
    direction = Axis.horizontal;
    alignment = WrapAlignment.start;
    spacing = 8;
    runAlignment = WrapAlignment.start;
    runSpacing = 8;
    crossAxisAlignment = WrapCrossAlignment.start;
    textDirection = null;
    verticalDirection = VerticalDirection.down;
    clipKind = ClipKind.none;
    setState(() {});
  }

  void onTap(String name) {
    lastEvent = 'onTap $name';
    DLog.d(lastEvent);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(lastEvent), duration: const Duration(milliseconds: 800)),
    );
    setState(() {});
  }
}
