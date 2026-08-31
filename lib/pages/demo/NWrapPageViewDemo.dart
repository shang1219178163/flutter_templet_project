import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_wrap_page_view.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class NWrapPageViewDemo extends StatefulWidget {
  const NWrapPageViewDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NWrapPageViewDemo> createState() => _NWrapPageViewDemoState();
}

class _NWrapPageViewDemoState extends State<NWrapPageViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 仅取阿里云图，便于服务端缩略
  late final List<String> imageUrls = AppRes.image.urls.where((e) => e.contains('.aliyuncs.com')).take(16).toList();

  /// 最近事件
  String lastEvent = '—';
  /// 数据条数
  int itemCount = 16;
  /// 每页列数
  int crossAxisCount = 4;
  /// 每页行数
  int rowCount = 2;
  /// Wrap 主轴间距
  double spacing = 8;
  /// Wrap 交叉轴间距
  double runSpacing = 8;
  /// 是否传入 height
  bool useHeight = true;
  /// PageView 区域高度
  double height = 200;
  /// 是否传入 padding
  bool usePadding = false;
  /// 内边距
  double paddingAll = 8;
  /// 指示器上边距
  double indicatorMarginTop = 12;
  /// 指示器宽
  double indicatorW = 8;
  /// 指示器高
  double indicatorH = 3;
  /// 指示器未选中色
  Color? indicatorNormalColor;
  /// 指示器选中色
  Color? indicatorSelectedColor;
  /// 是否传入 onPageChanged
  bool useOnPageChanged = true;

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
    return Column(
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
                      NLangEnum.en: 'Widget NWrapPageView',
                      NLangEnum.zh: '组件 NWrapPageView',
                    },
                    items: [
                      {
                        NLangEnum.en:
                            'Aliyun thumbnails with 选项_index labels are the original children. Each page is crossAxisCount × rowCount.',
                        NLangEnum.zh: '阿里云缩略图和 选项_index 是原内容。每页容量 = 列数 × 行数。',
                      },
                    ],
                  ),
                  buildPropCard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPreview() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final urls = imageUrls.take(itemCount).toList();
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
            NWrapPageView<String>(
              key: ValueKey('$crossAxisCount-$rowCount-$itemCount-$useHeight'),
              items: urls,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: NNetworkImage(
                        url: urls[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        radius: 4,
                      ),
                    ),
                    Text('选项_$index', style: const TextStyle(fontSize: 12)),
                  ],
                );
              },
              crossAxisCount: crossAxisCount,
              rowCount: rowCount,
              spacing: spacing,
              runSpacing: runSpacing,
              height: useHeight ? height : null,
              padding: usePadding ? EdgeInsets.all(paddingAll) : EdgeInsets.zero,
              indicatorMargin: EdgeInsets.only(top: indicatorMarginTop),
              indicatorItemSize: Size(indicatorW, indicatorH),
              indicatorNormalColor: indicatorNormalColor ?? const Color(0x332196F3),
              indicatorSelectedColor: indicatorSelectedColor ?? const Color(0xFF2196F3),
              onPageChanged: useOnPageChanged ? (i) => onMark('onPageChanged $i') : null,
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

  Widget buildPropCard() {
    return NDecorationCard(
      icon: const Icon(Icons.grid_view_outlined),
      title: '属性',
      subtitle: 'items  crossAxisCount  height  padding  indicator  onPageChanged',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'items',
            value: itemCount.toDouble(),
            min: 1,
            max: 16,
            onChanged: (v) => onMark('items ${v.round()}', () => itemCount = v.round()),
          ),
          buildSlider(
            label: 'crossAxisCount',
            value: crossAxisCount.toDouble(),
            min: 1,
            max: 6,
            onChanged: (v) => onMark('crossAxisCount ${v.round()}', () => crossAxisCount = v.round()),
          ),
          buildSlider(
            label: 'rowCount',
            value: rowCount.toDouble(),
            min: 1,
            max: 4,
            onChanged: (v) => onMark('rowCount ${v.round()}', () => rowCount = v.round()),
          ),
          buildSlider(
            label: 'spacing',
            value: spacing,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('spacing ${v.round()}', () => spacing = v),
          ),
          buildSlider(
            label: 'runSpacing',
            value: runSpacing,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('runSpacing ${v.round()}', () => runSpacing = v),
          ),
          buildSwitch(
            title: 'height',
            value: useHeight,
            onChanged: (v) => onMark('height ${v ? 'on' : 'null'}', () => useHeight = v),
          ),
          if (useHeight)
            buildSlider(
              label: 'height',
              value: height,
              min: 80,
              max: 360,
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
            ),
          buildSwitch(
            title: 'padding',
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'on' : 'zero'}', () => usePadding = v),
          ),
          if (usePadding)
            buildSlider(
              label: 'padding',
              value: paddingAll,
              min: 0,
              max: 24,
              onChanged: (v) => onMark('padding ${v.round()}', () => paddingAll = v),
            ),
          buildSwitch(
            title: 'onPageChanged',
            value: useOnPageChanged,
            onChanged: (v) => onMark('onPageChanged ${v ? 'on' : 'null'}', () => useOnPageChanged = v),
          ),
          buildSlider(
            label: 'indicatorMargin.top',
            value: indicatorMarginTop,
            min: 0,
            max: 32,
            onChanged: (v) => onMark('indicatorMargin.top ${v.round()}', () => indicatorMarginTop = v),
          ),
          buildSlider(
            label: 'indicatorItemSize.w',
            value: indicatorW,
            min: 2,
            max: 24,
            onChanged: (v) => onMark('indicatorItemSize.w ${v.round()}', () => indicatorW = v),
          ),
          buildSlider(
            label: 'indicatorItemSize.h',
            value: indicatorH,
            min: 1,
            max: 12,
            onChanged: (v) => onMark('indicatorItemSize.h ${v.round()}', () => indicatorH = v),
          ),
          buildColorRow(
            'indicatorNormalColor',
            indicatorNormalColor,
            (v) => onMark('indicatorNormalColor ${v ?? 'null'}', () => indicatorNormalColor = v),
          ),
          buildColorRow(
            'indicatorSelectedColor',
            indicatorSelectedColor,
            (v) => onMark('indicatorSelectedColor ${v ?? 'null'}', () => indicatorSelectedColor = v),
          ),
        ],
      ),
    );
  }

  Widget buildColorRow(String label, Color? value, ValueChanged<Color?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        buildColorDots(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        return GestureDetector(
          onTap: () => onChanged(e),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: e ?? scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: e == null
                ? Text('默', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600))
                : selected
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark ? Colors.white : Colors.black87,
                      )
                    : null,
          ),
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
    itemCount = 16;
    crossAxisCount = 4;
    rowCount = 2;
    spacing = 8;
    runSpacing = 8;
    useHeight = true;
    height = 200;
    usePadding = false;
    paddingAll = 8;
    indicatorMarginTop = 12;
    indicatorW = 8;
    indicatorH = 3;
    indicatorNormalColor = null;
    indicatorSelectedColor = null;
    useOnPageChanged = true;
    setState(() {});
  }
}
