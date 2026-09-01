//
//  NnCollectionNavWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/13/23 3:21 PM.
//  Copyright © 2/13/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_collection_nav_widget.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
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
    final boxShadows = useBoxShadows
        ? [
            BoxShadow(
              color: (shadowColor ?? Colors.black).withValues(alpha: 0.28),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
        : null;
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
      boxShadows: boxShadows,
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
          NChoiceChipListItem<PageViewScrollType>(
            title: const Text('scrollType'),
            values: PageViewScrollType.values,
            value: scrollType,
            labelOf: (e) => e.name,
            onChanged: onScrollType,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('itemCount'),
            min: 1,
            max: imgUrls.length.toDouble(),
            value: itemCount.toDouble().clamp(1, imgUrls.length.toDouble()),
            onChanged: onItemCount,
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('pageRowNum'),
            min: 1,
            max: 5,
            value: pageRowNum.toDouble().clamp(1, 5),
            onChanged: onPageRowNum,
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('pageColumnNum'),
            min: 1,
            max: 5,
            value: pageColumnNum.toDouble().clamp(1, 5),
            onChanged: onPageColumnNum,
            activeColor: theme.colorScheme.primary,
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
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('iconSize'),
            min: 24,
            max: 80,
            value: iconSize.clamp(24, 80),
            onChanged: (v) => onMark('iconSize ${v.toStringAsFixed(1)}', () => iconSize = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('textHeight'),
            min: 10,
            max: 28,
            value: textHeight.clamp(10, 28),
            onChanged: (v) => onMark('textHeight ${v.toStringAsFixed(1)}', () => textHeight = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('textGap'),
            min: 0,
            max: 16,
            value: textGap.clamp(0, 16),
            onChanged: (v) => onMark('textGap ${v.toStringAsFixed(1)}', () => textGap = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('columnSpacing'),
            min: 0,
            max: 32,
            value: columnSpacing.clamp(0, 32),
            onChanged: (v) => onMark('columnSpacing ${v.toStringAsFixed(1)}', () => columnSpacing = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('rowSpacing'),
            min: 0,
            max: 24,
            value: rowSpacing.clamp(0, 24),
            onChanged: (v) => onMark('rowSpacing ${v.toStringAsFixed(1)}', () => rowSpacing = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('indicatorItemHeight'),
            min: 1,
            max: 8,
            value: indicatorItemHeight.clamp(1, 8),
            onChanged: (v) => onMark('indicatorItemHeight ${v.toStringAsFixed(1)}', () => indicatorItemHeight = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('indicatorItemWidth'),
            min: 4,
            max: 24,
            value: indicatorItemWidth.clamp(4, 24),
            onChanged: (v) => onMark('indicatorItemWidth ${v.toStringAsFixed(1)}', () => indicatorItemWidth = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('indicatorGap'),
            min: 0,
            max: 24,
            value: indicatorGap.clamp(0, 24),
            onChanged: (v) => onMark('indicatorGap ${v.toStringAsFixed(1)}', () => indicatorGap = v),
            activeColor: theme.colorScheme.primary,
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
          NSwitchListItem(title: const Text('isDebug'), value: isDebug, onChanged: (v) => onMark('isDebug $v', () => isDebug = v)),
          NSwitchListItem(
            title: const Text('boxShadows'),
            value: useBoxShadows,
            onChanged: (v) => onMark('boxShadows ${v ? 'on' : 'null'}', () => useBoxShadows = v),
          ),
          if (useBoxShadows) ...[
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('boxShadows.color'),
              value: shadowColor,
              onChanged: (e) => onMark('boxShadows.color ${e ?? 'null'}', () => shadowColor = e),
            ),
          ],
          NSwitchListItem(
            title: const Text('autoAdjustHeight'),
            value: autoAdjustHeight,
            onChanged: onAutoAdjustHeight,
          ),
        ],
      ),
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
    SnackUtil.show(lastEvent);
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
