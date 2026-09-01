//
//  BottomAppBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 5:47 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// shape 预设
enum _ShapeKind {
  none(label: 'none', shape: null),
  circular(label: 'circular', shape: CircularNotchedRectangle()),
  automatic(
    label: 'automatic',
    shape: AutomaticNotchedShape(RoundedRectangleBorder(), StadiumBorder()),
  ),
  ;
  const _ShapeKind({required this.label, required this.shape});
  final String label;
  final NotchedShape? shape;
}

class BottomAppBarDemo extends StatefulWidget {
  const BottomAppBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<BottomAppBarDemo> createState() => _BottomAppBarDemoState();
}

class _BottomAppBarDemoState extends State<BottomAppBarDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final locations = FloatingActionButtonLocationExt.allCases;

  /// 原 Demo 默认蓝色
  Color? color = Colors.blue;
  /// 是否指定 elevation
  bool useElevation = false;
  /// 海拔阴影
  double elevation = 8;
  /// 缺口外形
  _ShapeKind shapeKind = _ShapeKind.circular;
  /// 裁剪
  Clip clipBehavior = Clip.none;
  /// 缺口边距
  double notchMargin = 4;
  /// 是否显示 child
  bool useChild = true;
  /// 是否传入 padding
  bool usePadding = false;
  /// 水平内边距
  double padH = 16;
  /// 垂直内边距
  double padV = 12;
  /// 表面色调
  Color? surfaceTintColor;
  /// 阴影色
  Color? shadowColor;
  /// 是否指定高度
  bool useHeight = false;
  /// 栏高度
  double height = 80;
  /// 是否显示 FAB
  bool showFab = true;
  /// FAB 停靠位置
  FloatingActionButtonLocation fabLocation = FloatingActionButtonLocation.endDocked;
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.42).clamp(240.0, 380.0);
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
                            NLangEnum.en: 'Widget BottomAppBar',
                            NLangEnum.zh: '组件 BottomAppBar',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Tune every BottomAppBar constructor argument. Original menu / photo / search / favorite icons are kept. shape cuts a notch for a docked FAB.',
                              NLangEnum.zh: '可调节 BottomAppBar 全部构造参数；保留原图标。shape 为停靠 FAB 挖缺口。',
                            },
                            {
                              NLangEnum.en:
                                  'showFab and fabLocation are Scaffold fields used to preview the notch. circular is the original CircularNotchedRectangle.',
                              NLangEnum.zh: 'showFab 与 fabLocation 用来观察缺口。circular 即原 Demo 的 CircularNotchedRectangle。',
                            },
                          ],
                        ),
                        buildSurfaceCard(),
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
              child: Scaffold(
                body: Center(
                  child: Text(
                    'BottomAppBar',
                    style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                  ),
                ),
                floatingActionButton: showFab
                    ? FloatingActionButton(
                        onPressed: () => onMark('onFab'),
                        tooltip: 'Create',
                        child: const Icon(Icons.add),
                      )
                    : null,
                floatingActionButtonLocation: fabLocation,
                bottomNavigationBar: buildDemoBar(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
    );
  }

  BottomAppBar buildDemoBar() {
    return BottomAppBar(
      color: color,
      elevation: useElevation ? elevation : null,
      shape: shapeKind.shape,
      clipBehavior: clipBehavior,
      notchMargin: notchMargin,
      padding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      height: useHeight ? height : null,
      child: useChild ? buildBarChild() : null,
    );
  }

  Widget buildBarChild() {
    return IconTheme(
      data: IconThemeData(color: theme.colorScheme.onPrimary),
      child: Row(
        children: [
          if (fabLocation == FloatingActionButtonLocation.startDocked) const Spacer(),
          IconButton(
            tooltip: 'Open navigation menu',
            icon: const Icon(Icons.menu),
            onPressed: () => onMark('onMenu'),
          ),
          IconButton(
            tooltip: 'Open navigation menu',
            icon: const Icon(Icons.photo),
            onPressed: () => onMark('onPhoto'),
          ),
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => onMark('onSearch'),
          ),
          IconButton(
            tooltip: 'Favorite',
            icon: const Icon(Icons.favorite),
            onPressed: () => onMark('onFavorite'),
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'color · shape · child · elevation · shadowColor · surfaceTintColor · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceColorListItem(
            title: const Text('color'),
            value: color,
            onChanged: (e) => onMark('color ${e ?? 'null'}', () => color = e),
          ),
          NChoiceChipListItem(
            title: const Text('shape'),
            values: _ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('shapeKind ${e.label}', () => shapeKind = e),
          ),
          NSwitchListTile(
            title: const Text('child 显示图标'),
            value: useChild,
            onChanged: (v) => onMark('useChild $v', () => useChild = v),
          ),
          NSwitchListTile(
            title: const Text('elevation 指定高度'),
            value: useElevation,
            onChanged: (v) => onMark('useElevation $v', () => useElevation = v),
          ),
          if (useElevation)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('elevation'),
              min: 0,
              max: 16,
              value: elevation.clamp(0, 16),
              onChanged: (v) => onMark('elevation ${v.round()}', () => elevation = v),
              activeColor: theme.colorScheme.primary,
            ),
          NChoiceColorListItem(
            title: const Text('shadowColor'),
            value: shadowColor,
            onChanged: (e) => onMark('shadowColor ${e ?? 'null'}', () => shadowColor = e),
          ),
          NChoiceColorListItem(
            title: const Text('surfaceTintColor'),
            value: surfaceTintColor,
            onChanged: (e) => onMark('surfaceTintColor ${e ?? 'null'}', () => surfaceTintColor = e),
          ),
          NChoiceChipListItem(
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
      subtitle: 'height · padding · notchMargin · showFab · fabLocation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListTile(
            title: const Text('height 指定高度'),
            value: useHeight,
            onChanged: (v) => onMark('useHeight $v', () => useHeight = v),
          ),
          if (useHeight)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('height'),
              min: 40,
              max: 120,
              value: height.clamp(40, 120),
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListTile(
            title: const Text('padding 指定内边距'),
            value: usePadding,
            onChanged: (v) => onMark('usePadding $v', () => usePadding = v),
          ),
          if (usePadding) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding H'),
              min: 0,
              max: 32,
              value: padH.clamp(0, 32),
              onChanged: (v) => onMark('padH ${v.round()}', () => padH = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding V'),
              min: 0,
              max: 24,
              value: padV.clamp(0, 24),
              onChanged: (v) => onMark('padV ${v.round()}', () => padV = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          if (shapeKind != _ShapeKind.none)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('notchMargin'),
              min: 0,
              max: 16,
              value: notchMargin.clamp(0, 16),
              onChanged: (v) => onMark('notchMargin ${v.round()}', () => notchMargin = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListTile(
            title: const Text('showFab 显示浮动按钮'),
            value: showFab,
            onChanged: (v) => onMark('showFab $v', () => showFab = v),
          ),
          NChoiceChipListItem(
            title: const Text('fabLocation'),
            values: locations,
            value: fabLocation,
            labelOf: (e) => e.toString().split('.').last,
            onChanged: (e) => onMark('fabLocation $e', () => fabLocation = e),
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
    color = Colors.blue;
    useElevation = false;
    elevation = 8;
    shapeKind = _ShapeKind.circular;
    clipBehavior = Clip.none;
    notchMargin = 4;
    useChild = true;
    usePadding = false;
    padH = 16;
    padV = 12;
    surfaceTintColor = null;
    shadowColor = null;
    useHeight = false;
    height = 80;
    showFab = true;
    fabLocation = FloatingActionButtonLocation.endDocked;
    lastEvent = '—';
    setState(() {});
  }
}
