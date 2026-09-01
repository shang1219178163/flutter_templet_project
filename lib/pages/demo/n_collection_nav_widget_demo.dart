//
//  NnCollectionNavWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/13/23 3:21 PM.
//  Copyright © 2/13/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_collection_nav_widget.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class NCollectionNavWidgetDemo extends StatefulWidget {
  const NCollectionNavWidgetDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NCollectionNavWidgetDemo> createState() => _NCollectionNavWidgetDemoState();
}

class _NCollectionNavWidgetDemoState extends State<NCollectionNavWidgetDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final imgUrls = AppRes.image.urls;

  /// 滚动方式
  PageViewScrollType scrollType = PageViewScrollType.full;
  /// 每页行数
  int pageRowNum = 2;
  /// 每页列数
  int pageColumnNum = 5;
  /// 图标高度
  double iconSize = 68;
  /// 标题高度
  double textHeight = 16;
  /// 图标与文字间距
  double textGap = 5;
  /// 垂直间距
  double columnSpacing = 16;
  /// 水平间距
  double rowSpacing = 8;
  /// 是否自适应高度
  bool autoAdjustHeight = true;
  /// 指示器高度
  double indicatorItemHeight = 2;
  /// 指示器宽度
  double indicatorItemWidth = 12;
  /// 指示器与标题间距
  double indicatorGap = 8;
  /// 是否显示阴影
  bool useBoxShadows = false;
  /// 阴影色
  Color? shadowColor;
  /// 调试色块
  bool isDebug = true;
  /// 子项数量
  late int itemCount = imgUrls.length;
  /// 最近事件
  String lastEvent = '—';
  int remountEpoch = 0;

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
          final previewMax = (constraints.maxHeight * 0.48).clamp(220.0, 400.0);
          return Column(
            children: [
              buildPreview(previewMax),
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
                            NLangEnum.en: 'Widget NCollectionNavWidget',
                            NLangEnum.zh: '组件 NCollectionNavWidget',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Original demo used 2 rows, 5 columns, iconSize 68, textGap 5, isDebug true.',
                              NLangEnum.zh: '原 Demo 为 2 行 5 列、iconSize 68、textGap 5、isDebug true。',
                            },
                            {
                              NLangEnum.en: 'Tap an item to fire onItem. scrollType none keeps a single page.',
                              NLangEnum.zh: '点击格子触发 onItem。scrollType 为 none 时仅一页不可滑。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildCellCard(),
                        buildSurfaceCard(),
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

  Widget buildPreview(double maxHeight) {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: previewExtent > maxHeight ? maxHeight : previewExtent,
              width: double.infinity,
              child: previewExtent > maxHeight ? SingleChildScrollView(child: buildNav()) : buildNav(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                lastEvent,
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

  Widget buildNav() {
    final child = NCollectionNavWidget(
      key: ValueKey('nav-$remountEpoch-$scrollType-$pageRowNum-$pageColumnNum-$itemCount-$autoAdjustHeight'),
      items: buildItems(),
      onItem: onItem,
      scrollType: scrollType,
      pageRowNum: pageRowNum,
      pageColumnNum: pageColumnNum,
      iconSize: iconSize,
      textHeight: textHeight,
      textGap: textGap,
      columnSpacing: columnSpacing,
      rowSpacing: rowSpacing,
      autoAdjustHeight: autoAdjustHeight,
      indicatorItemHeight: indicatorItemHeight,
      indicatorItemWidth: indicatorItemWidth,
      indicatorGap: indicatorGap,
      boxShadows: buildBoxShadows(),
      isDebug: isDebug,
    );
    if (autoAdjustHeight) {
      return child;
    }
    return SizedBox(height: previewExtent, child: child);
  }

  List<AttrNavItem> buildItems() {
    final urls = imgUrls;
    final count = itemCount.clamp(1, urls.length);
    return List.generate(count, (index) {
      return AttrNavItem(
        icon: urls[index],
        name: '测试标题啊',
      );
    });
  }

  List<BoxShadow>? buildBoxShadows() {
    if (!useBoxShadows) {
      return null;
    }
    return [
      BoxShadow(
        color: (shadowColor ?? Colors.black).withValues(alpha: 0.28),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  double get previewExtent {
    final rows = pageRowNum;
    final itemH = iconSize + textGap + textHeight;
    final gapCount = rows > 0 ? rows - 1 : 0;
    return itemH * rows + columnSpacing * gapCount + indicatorGap + indicatorItemHeight;
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'scrollType · items · pageRowNum · pageColumnNum',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'scrollType',
            child: buildChoiceChips(
              values: PageViewScrollType.values,
              isSelected: (e) => scrollType == e,
              labelOf: (e) => e.name,
              onChanged: onScrollType,
            ),
          ),
          buildSlider(
            label: 'itemCount',
            value: itemCount.toDouble(),
            min: 1,
            max: imgUrls.length.toDouble(),
            divisions: imgUrls.length - 1,
            onChanged: onItemCount,
          ),
          buildSlider(
            label: 'pageRowNum',
            value: pageRowNum.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onPageRowNum,
          ),
          buildSlider(
            label: 'pageColumnNum',
            value: pageColumnNum.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onPageColumnNum,
          ),
        ],
      ),
    );
  }

  Widget buildCellCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'iconSize · textHeight · spacing · indicator',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'iconSize',
            value: iconSize,
            min: 24,
            max: 80,
            onChanged: (v) => onMark('iconSize ${v.toStringAsFixed(1)}', () => iconSize = v),
          ),
          buildSlider(
            label: 'textHeight',
            value: textHeight,
            min: 10,
            max: 28,
            onChanged: (v) => onMark('textHeight ${v.toStringAsFixed(1)}', () => textHeight = v),
          ),
          buildSlider(
            label: 'textGap',
            value: textGap,
            min: 0,
            max: 16,
            onChanged: (v) => onMark('textGap ${v.toStringAsFixed(1)}', () => textGap = v),
          ),
          buildSlider(
            label: 'columnSpacing',
            value: columnSpacing,
            min: 0,
            max: 32,
            onChanged: (v) => onMark('columnSpacing ${v.toStringAsFixed(1)}', () => columnSpacing = v),
          ),
          buildSlider(
            label: 'rowSpacing',
            value: rowSpacing,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('rowSpacing ${v.toStringAsFixed(1)}', () => rowSpacing = v),
          ),
          buildSlider(
            label: 'indicatorItemHeight',
            value: indicatorItemHeight,
            min: 1,
            max: 8,
            onChanged: (v) => onMark('indicatorItemHeight ${v.toStringAsFixed(1)}', () => indicatorItemHeight = v),
          ),
          buildSlider(
            label: 'indicatorItemWidth',
            value: indicatorItemWidth,
            min: 4,
            max: 24,
            onChanged: (v) => onMark('indicatorItemWidth ${v.toStringAsFixed(1)}', () => indicatorItemWidth = v),
          ),
          buildSlider(
            label: 'indicatorGap',
            value: indicatorGap,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('indicatorGap ${v.toStringAsFixed(1)}', () => indicatorGap = v),
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'isDebug · boxShadows · autoAdjustHeight',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'isDebug', value: isDebug, onChanged: (v) => onMark('isDebug $v', () => isDebug = v)),
          buildSwitch(
            title: 'boxShadows',
            value: useBoxShadows,
            onChanged: (v) => onMark('boxShadows ${v ? 'on' : 'null'}', () => useBoxShadows = v),
          ),
          if (useBoxShadows)
            buildField(
              label: 'boxShadows.color',
              showTopGap: true,
              child: buildColorDots(
                value: shadowColor,
                onChanged: (e) => onMark('boxShadows.color ${e ?? 'null'}', () => shadowColor = e),
              ),
            ),
          buildSwitch(
            title: 'autoAdjustHeight',
            value: autoAdjustHeight,
            onChanged: onAutoAdjustHeight,
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
    final scheme = theme.colorScheme;
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

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(e),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e ?? scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.65),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: e == null
                  ? Text(
                      '默',
                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    )
                  : selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
            ),
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
    int? divisions,
  }) {
    final scheme = theme.colorScheme;
    return NSliderListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      min: min,
      max: max,
      value: value.clamp(min, max),
      divisions: divisions ?? 100,
      onChanged: onChanged,
      activeColor: scheme.primary,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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

  void bumpRemount() {
    remountEpoch++;
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onScrollType(PageViewScrollType value) {
    onMark('scrollType ${value.name}', () {
      scrollType = value;
      bumpRemount();
    });
  }

  void onItemCount(double value) {
    onMark('itemCount ${value.round()}', () {
      itemCount = value.round().clamp(1, imgUrls.length);
      bumpRemount();
    });
  }

  void onPageRowNum(double value) {
    onMark('pageRowNum ${value.round()}', () {
      pageRowNum = value.round().clamp(1, 5);
      bumpRemount();
    });
  }

  void onPageColumnNum(double value) {
    onMark('pageColumnNum ${value.round()}', () {
      pageColumnNum = value.round().clamp(1, 5);
      bumpRemount();
    });
  }

  void onAutoAdjustHeight(bool value) {
    onMark('autoAdjustHeight $value', () {
      autoAdjustHeight = value;
      bumpRemount();
    });
  }

  void onItem(AttrNavItem e) {
    lastEvent = 'onItem ${e.name ?? e.icon ?? ''}';
    DLog.d(lastEvent);
    setState(() {});
    final scheme = theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lastEvent),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void onReset() {
    scrollType = PageViewScrollType.full;
    pageRowNum = 2;
    pageColumnNum = 5;
    iconSize = 68;
    textHeight = 16;
    textGap = 5;
    columnSpacing = 16;
    rowSpacing = 8;
    autoAdjustHeight = true;
    indicatorItemHeight = 2;
    indicatorItemWidth = 12;
    indicatorGap = 8;
    useBoxShadows = false;
    shadowColor = null;
    isDebug = true;
    itemCount = imgUrls.length;
    lastEvent = '—';
    bumpRemount();
    setState(() {});
  }
}
