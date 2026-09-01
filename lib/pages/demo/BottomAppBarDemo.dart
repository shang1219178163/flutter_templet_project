//
//  BottomAppBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 5:47 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// shape 预设
enum _ShapeKind { none, circular, automatic }

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
      shape: shapeOf(),
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

  NotchedShape? shapeOf() {
    return switch (shapeKind) {
      _ShapeKind.none => null,
      _ShapeKind.circular => const CircularNotchedRectangle(),
      _ShapeKind.automatic => const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(),
        ),
    };
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'color · shape · child · elevation · shadowColor · surfaceTintColor · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('color'),
          buildColorDots(value: color, onChanged: (e) => onMark('color ${e ?? 'null'}', () => color = e)),
          const Text('shape'),
          buildChoiceChips(
            values: _ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('shapeKind ${e.name}', () => shapeKind = e),
          ),
          buildSwitch(
            title: 'child 显示图标',
            value: useChild,
            onChanged: (v) => onMark('useChild $v', () => useChild = v),
          ),
          buildSwitch(
            title: 'elevation 指定高度',
            value: useElevation,
            onChanged: (v) => onMark('useElevation $v', () => useElevation = v),
          ),
          if (useElevation)
            buildSlider(
              label: 'elevation',
              value: elevation,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('elevation ${v.round()}', () => elevation = v),
            ),
          const Text('shadowColor'),
          buildColorDots(value: shadowColor, onChanged: (e) => onMark('shadowColor ${e ?? 'null'}', () => shadowColor = e)),
          const Text('surfaceTintColor'),
          buildColorDots(
            value: surfaceTintColor,
            onChanged: (e) => onMark('surfaceTintColor ${e ?? 'null'}', () => surfaceTintColor = e),
          ),
          const Text('clipBehavior'),
          buildChoiceChips(
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
          buildSwitch(
            title: 'height 指定高度',
            value: useHeight,
            onChanged: (v) => onMark('useHeight $v', () => useHeight = v),
          ),
          if (useHeight)
            buildSlider(
              label: 'height',
              value: height,
              min: 40,
              max: 120,
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
            ),
          buildSwitch(
            title: 'padding 指定内边距',
            value: usePadding,
            onChanged: (v) => onMark('usePadding $v', () => usePadding = v),
          ),
          if (usePadding) ...[
            buildSlider(
              label: 'padding H',
              value: padH,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('padH ${v.round()}', () => padH = v),
            ),
            buildSlider(
              label: 'padding V',
              value: padV,
              min: 0,
              max: 24,
              onChanged: (v) => onMark('padV ${v.round()}', () => padV = v),
            ),
          ],
          if (shapeKind != _ShapeKind.none)
            buildSlider(
              label: 'notchMargin',
              value: notchMargin,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('notchMargin ${v.round()}', () => notchMargin = v),
            ),
          buildSwitch(
            title: 'showFab 显示浮动按钮',
            value: showFab,
            onChanged: (v) => onMark('showFab $v', () => showFab = v),
          ),
          const Text('fabLocation'),
          buildChoiceChips(
            values: locations,
            value: fabLocation,
            labelOf: (e) => e.toString().split('.').last,
            onChanged: (e) => onMark('fabLocation $e', () => fabLocation = e),
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
    final scheme = theme.colorScheme;
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
