//
//  BottomAppBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 5:47 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
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

  final scrollController = ScrollController();
  final locations = FloatingActionButtonLocationExt.allCases;

  /// 原 Demo 默认蓝色
  Color? color = Colors.blue;
  bool useElevation = false;
  double elevation = 8;
  _ShapeKind shapeKind = _ShapeKind.circular;
  Clip clipBehavior = Clip.none;
  double notchMargin = 4;
  bool useChild = true;
  bool usePadding = false;
  double padH = 16;
  double padV = 12;
  Color? surfaceTintColor;
  Color? shadowColor;
  bool useHeight = false;
  double height = 80;
  bool showFab = true;
  FloatingActionButtonLocation fabLocation = FloatingActionButtonLocation.endDocked;
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
                                  'Tune every BottomAppBar constructor argument. Original menu / photo / search / favorite icons are kept.',
                              NLangEnum.zh: '可调节 BottomAppBar 全部构造参数；保留原 Demo 的菜单、图片、搜索、收藏图标。',
                            },
                            {
                              NLangEnum.en:
                                  'shape cuts a notch for a docked FAB. circular is the original CircularNotchedRectangle.',
                              NLangEnum.zh: 'shape 为停靠 FAB 挖缺口。circular 即原 Demo 的 CircularNotchedRectangle。',
                            },
                            {
                              NLangEnum.en:
                                  'showFab and fabLocation are Scaffold fields used to preview the notch, same as the original demo.',
                              NLangEnum.zh: 'showFab 与 fabLocation 是 Scaffold 属性，用来观察缺口，与原 Demo 一致。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildSurfaceCard(),
                        buildSizeCard(),
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
              child: Scaffold(
                body: Center(
                  child: Text(
                    'BottomAppBar',
                    style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                  ),
                ),
                floatingActionButton: showFab
                    ? FloatingActionButton(
                        onPressed: onFab,
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
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
        children: [
            if (fabLocation == FloatingActionButtonLocation.startDocked) const Spacer(),
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
            onPressed: onMenu,
            ),
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.photo),
            onPressed: onPhoto,
            ),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
            onPressed: onSearch,
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
            onPressed: onFavorite,
          ),
        ],
      ),
    );
  }

  NotchedShape? shapeOf() {
    switch (shapeKind) {
      case _ShapeKind.none:
        return null;
      case _ShapeKind.circular:
        return const CircularNotchedRectangle();
      case _ShapeKind.automatic:
        return const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(),
        );
    }
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'color · shape · child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'color',
            child: buildColorDots(value: color, onChanged: onColor),
          ),
          buildField(
            label: 'shape',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ShapeKind.values,
              isSelected: (e) => shapeKind == e,
              labelOf: (e) => e.name,
              onChanged: onShapeKind,
            ),
          ),
          buildSwitch(title: 'child 显示图标', value: useChild, onChanged: onUseChild),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'elevation · shadowColor · surfaceTintColor · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'elevation 指定高度', value: useElevation, onChanged: onUseElevation),
          if (useElevation)
            buildSlider(label: 'elevation', value: elevation, min: 0, max: 16, onChanged: onElevation),
          buildField(
            label: 'shadowColor',
            showTopGap: true,
            child: buildColorDots(value: shadowColor, onChanged: onShadowColor),
          ),
          buildField(
            label: 'surfaceTintColor',
            showTopGap: true,
            child: buildColorDots(value: surfaceTintColor, onChanged: onSurfaceTintColor),
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

  Widget buildSizeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'height · padding · notchMargin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'height 指定高度', value: useHeight, onChanged: onUseHeight),
          if (useHeight) buildSlider(label: 'height', value: height, min: 40, max: 120, onChanged: onHeight),
          buildSwitch(title: 'padding 指定内边距', value: usePadding, onChanged: onUsePadding),
          if (usePadding) ...[
            buildSlider(label: 'padding H', value: padH, min: 0, max: 32, onChanged: onPadH),
            buildSlider(label: 'padding V', value: padV, min: 0, max: 24, onChanged: onPadV),
          ],
          if (shapeKind != _ShapeKind.none)
            buildSlider(label: 'notchMargin', value: notchMargin, min: 0, max: 16, onChanged: onNotchMargin),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'showFab · floatingActionButtonLocation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'showFab 显示浮动按钮', value: showFab, onChanged: onShowFab),
          buildField(
            label: 'fabLocation',
            showTopGap: true,
            child: buildChoiceChips(
              values: locations,
              isSelected: (e) => fabLocation == e,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: onFabLocation,
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
      inactiveColor: Colors.black12,
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

  void onMenu() {
    lastEvent = 'onMenu';
    DLog.d('onMenu');
    setState(() {});
  }

  void onPhoto() {
    lastEvent = 'onPhoto';
    DLog.d('onPhoto');
    setState(() {});
  }

  void onSearch() {
    lastEvent = 'onSearch';
    DLog.d('onSearch');
    setState(() {});
  }

  void onFavorite() {
    lastEvent = 'onFavorite';
    DLog.d('onFavorite');
    setState(() {});
  }

  void onFab() {
    lastEvent = 'onFab';
    DLog.d('onFab');
    setState(() {});
  }

  void onColor(Color? value) {
    color = value;
    setState(() {});
  }

  void onShapeKind(_ShapeKind value) {
    shapeKind = value;
    setState(() {});
  }

  void onUseChild(bool value) {
    useChild = value;
    setState(() {});
  }

  void onUseElevation(bool value) {
    useElevation = value;
    setState(() {});
  }

  void onElevation(double value) {
    elevation = value;
    setState(() {});
  }

  void onShadowColor(Color? value) {
    shadowColor = value;
    setState(() {});
  }

  void onSurfaceTintColor(Color? value) {
    surfaceTintColor = value;
    setState(() {});
  }

  void onClipBehavior(Clip value) {
    clipBehavior = value;
    setState(() {});
  }

  void onUseHeight(bool value) {
    useHeight = value;
    setState(() {});
  }

  void onHeight(double value) {
    height = value;
    setState(() {});
  }

  void onUsePadding(bool value) {
    usePadding = value;
    setState(() {});
  }

  void onPadH(double value) {
    padH = value;
    setState(() {});
  }

  void onPadV(double value) {
    padV = value;
    setState(() {});
  }

  void onNotchMargin(double value) {
    notchMargin = value;
    setState(() {});
  }

  void onShowFab(bool value) {
    showFab = value;
    setState(() {});
  }

  void onFabLocation(FloatingActionButtonLocation value) {
    fabLocation = value;
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
