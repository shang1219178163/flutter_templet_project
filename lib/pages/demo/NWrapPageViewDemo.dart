import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_wrap_page_view.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class NWrapPageViewDemo extends StatefulWidget {
  const NWrapPageViewDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NWrapPageViewDemo> createState() => _NWrapPageViewDemoState();
}

class _NWrapPageViewDemoState extends State<NWrapPageViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

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
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('items'),
            min: 1,
            max: 16,
            value: itemCount.toDouble().clamp(1, 16),
            onChanged: (v) => onMark('items ${v.round()}', () => itemCount = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('crossAxisCount'),
            min: 1,
            max: 6,
            value: crossAxisCount.toDouble().clamp(1, 6),
            onChanged: (v) => onMark('crossAxisCount ${v.round()}', () => crossAxisCount = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('rowCount'),
            min: 1,
            max: 4,
            value: rowCount.toDouble().clamp(1, 4),
            onChanged: (v) => onMark('rowCount ${v.round()}', () => rowCount = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('spacing'),
            min: 0,
            max: 24,
            value: spacing.clamp(0, 24),
            onChanged: (v) => onMark('spacing ${v.round()}', () => spacing = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('runSpacing'),
            min: 0,
            max: 24,
            value: runSpacing.clamp(0, 24),
            onChanged: (v) => onMark('runSpacing ${v.round()}', () => runSpacing = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSwitchListTile(
            title: const Text('height'),
            value: useHeight,
            onChanged: (v) => onMark('height ${v ? 'on' : 'null'}', () => useHeight = v),
          ),
          if (useHeight)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('height'),
              min: 80,
              max: 360,
              value: height.clamp(80, 360),
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListTile(
            title: const Text('padding'),
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'on' : 'zero'}', () => usePadding = v),
          ),
          if (usePadding)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding'),
              min: 0,
              max: 24,
              value: paddingAll.clamp(0, 24),
              onChanged: (v) => onMark('padding ${v.round()}', () => paddingAll = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListTile(
            title: const Text('onPageChanged'),
            value: useOnPageChanged,
            onChanged: (v) => onMark('onPageChanged ${v ? 'on' : 'null'}', () => useOnPageChanged = v),
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('indicatorMargin.top'),
            min: 0,
            max: 32,
            value: indicatorMarginTop.clamp(0, 32),
            onChanged: (v) => onMark('indicatorMargin.top ${v.round()}', () => indicatorMarginTop = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('indicatorItemSize.w'),
            min: 2,
            max: 24,
            value: indicatorW.clamp(2, 24),
            onChanged: (v) => onMark('indicatorItemSize.w ${v.round()}', () => indicatorW = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('indicatorItemSize.h'),
            min: 1,
            max: 12,
            value: indicatorH.clamp(1, 12),
            onChanged: (v) => onMark('indicatorItemSize.h ${v.round()}', () => indicatorH = v),
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('indicatorNormalColor'),
            value: indicatorNormalColor,
            onChanged: (v) => onMark('indicatorNormalColor ${v ?? 'null'}', () => indicatorNormalColor = v),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('indicatorSelectedColor'),
            value: indicatorSelectedColor,
            onChanged: (v) => onMark('indicatorSelectedColor ${v ?? 'null'}', () => indicatorSelectedColor = v),
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
