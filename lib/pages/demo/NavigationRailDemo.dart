//
//  NavigationRailDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/14/23 8:56 AM.
//  Copyright © 3/14/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class NavigationRailDemo extends StatefulWidget {
  const NavigationRailDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NavigationRailDemo> createState() => _NavigationRailDemoState();
}

class _NavigationRailDemoState extends State<NavigationRailDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final pageController = PageController();

  static const _dest = [
    (icon: Icons.message, label: '消息', color: Colors.red),
    (icon: Icons.video_camera_back, label: '视频会议', color: Colors.green),
    (icon: Icons.book_outlined, label: '通讯录', color: Colors.blue),
    (icon: Icons.cloud_upload, label: '云文档', color: Colors.orange),
    (icon: Icons.games_sharp, label: '工作台', color: Colors.purple),
    (icon: Icons.camera, label: '日历', color: Colors.teal),
  ];

  /// 最近事件
  String lastEvent = '—';
  /// 选中项
  int selectedIndex = 0;
  /// 目的地数量
  int destinationCount = 6;
  /// 是否传入 selectedIndex
  bool useSelected = true;
  /// 是否传入 onDestinationSelected
  bool useOnSelected = true;
  /// 是否展开
  bool extended = false;
  /// 是否显示 leading
  bool useLeading = true;
  /// 是否显示 trailing
  bool useTrailing = true;
  /// 是否传入 elevation
  bool useElevation = false;
  /// 海拔阴影
  double elevation = 4;
  /// 是否传入 groupAlignment
  bool useGroupAlignment = false;
  /// 目的地组垂直对齐，-1 顶 / 0 中 / 1 底
  double groupAlignment = -1;
  /// 标签类型
  NavigationRailLabelType? labelType;
  /// 背景色
  Color? backgroundColor;
  /// 选中标签色
  Color? selectedLabelColor;
  /// 未选中标签色
  Color? unselectedLabelColor;
  /// 选中图标色
  Color? selectedIconColor;
  /// 未选中图标色
  Color? unselectedIconColor;
  /// 是否传入图标尺寸
  bool useIconSize = false;
  /// 图标尺寸
  double iconSize = 24;
  /// 是否传入 minWidth
  bool useMinWidth = false;
  /// 收起最小宽度
  double minWidth = 80;
  /// 是否传入 minExtendedWidth
  bool useMinExtendedWidth = true;
  /// 展开最小宽度
  double minExtendedWidth = 150;
  /// 是否显示指示器
  bool? useIndicator;
  /// 指示器颜色
  Color? indicatorColor;
  /// 指示器形状
  ShapeKind shapeKind = ShapeKind.none;
  /// 圆角半径
  double shapeRadius = 16;

  List<({IconData icon, String label, Color color})> get items => _dest.take(destinationCount).toList();

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRail(),
        Expanded(child: buildPages()),
      ],
    );
  }

  Widget buildRail() {
    final index = selectedIndex.clamp(0, items.length - 1);
    return NavigationRail(
      backgroundColor: backgroundColor,
      extended: extended,
      leading: useLeading
          ? IconButton(
              icon: Icon(extended ? Icons.menu_open : Icons.menu),
              onPressed: () => onExtended(!extended),
            )
          : null,
      trailing: useTrailing
          ? const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: FlutterLogo(),
              ),
            )
          : null,
      destinations: [
        for (final e in items)
          NavigationRailDestination(
            icon: Icon(e.icon),
            label: Text(e.label),
          ),
      ],
      selectedIndex: useSelected ? index : null,
      onDestinationSelected: useOnSelected ? onSelected : null,
      elevation: useElevation ? elevation : null,
      groupAlignment: useGroupAlignment ? groupAlignment : null,
      labelType: labelType,
      unselectedLabelTextStyle: unselectedLabelColor == null ? null : TextStyle(color: unselectedLabelColor),
      selectedLabelTextStyle: selectedLabelColor == null ? null : TextStyle(color: selectedLabelColor),
      unselectedIconTheme: buildIconTheme(unselectedIconColor),
      selectedIconTheme: buildIconTheme(selectedIconColor),
      minWidth: useMinWidth ? minWidth : null,
      minExtendedWidth: useMinExtendedWidth ? minExtendedWidth : null,
      useIndicator: useIndicator,
      indicatorColor: indicatorColor,
      indicatorShape: buildIndicatorShape(),
    );
  }

  IconThemeData? buildIconTheme(Color? color) {
    if (color == null && !useIconSize) {
      return null;
    }
    return IconThemeData(color: color, size: useIconSize ? iconSize : null);
  }

  ShapeBorder? buildIndicatorShape() {
    return switch (shapeKind) {
      ShapeKind.none => null,
      ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius)),
      ShapeKind.stadium => const StadiumBorder(),
    };
  }

  Widget buildPages() {
    return PageView(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (i) => onMark('onPageChanged $i', () => selectedIndex = i),
      children: [
        for (var i = 0; i < items.length; i++) i == 0 ? buildPanelPage() : buildDataPage(items[i].color),
      ],
    );
  }

  Widget buildPanelPage() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
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
              const NDescriptionCard(
                initialLang: NLangEnum.zh,
                title: {
                  NLangEnum.en: 'Description',
                  NLangEnum.zh: '说明',
                },
                subtitle: {
                  NLangEnum.en: 'Widget NavigationRail',
                  NLangEnum.zh: '组件 NavigationRail',
                },
                items: [
                  {
                    NLangEnum.en:
                        'Menu toggles extended (needs labelType none). Label color is selectedLabelTextStyle / unselectedLabelTextStyle.',
                    NLangEnum.zh:
                        '菜单按钮切换 extended（需 labelType 为 none）。标签色走 selectedLabelTextStyle / unselectedLabelTextStyle。',
                  },
                ],
              ),
              buildBehaviorCard(),
              buildSurfaceCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataPage(Color color) {
    return ColoredBox(
      color: color,
      child: ListView(
        children: List.generate(199, (i) => Text('data_$i')),
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle:
          'destinations  selectedIndex  onDestinationSelected  extended  leading  trailing  labelType  groupAlignment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'destinations',
            value: destinationCount.toDouble(),
            min: 2,
            max: 6,
            onChanged: (v) => onMark('destinations ${v.round()}', () {
              destinationCount = v.round();
              if (selectedIndex >= destinationCount) {
                selectedIndex = destinationCount - 1;
              }
            }),
          ),
          buildSwitch(title: 'selectedIndex', value: useSelected, onChanged: (v) => onMark('selectedIndex ${v ? 'on' : 'null'}', () => useSelected = v)),
          if (useSelected)
            buildSlider(
              label: 'selectedIndex',
              value: selectedIndex.toDouble().clamp(0, destinationCount - 1),
              min: 0,
              max: (destinationCount - 1).toDouble(),
              onChanged: (v) => onSelected(v.round()),
            ),
          buildSwitch(title: 'onDestinationSelected', value: useOnSelected, onChanged: (v) => onMark('onDestinationSelected ${v ? 'on' : 'null'}', () => useOnSelected = v)),
          buildSwitch(title: 'extended', value: extended, onChanged: onExtended),
          buildSwitch(title: 'leading', value: useLeading, onChanged: (v) => onMark('leading ${v ? 'on' : 'null'}', () => useLeading = v)),
          buildSwitch(title: 'trailing', value: useTrailing, onChanged: (v) => onMark('trailing ${v ? 'on' : 'null'}', () => useTrailing = v)),
          const Text('labelType'),
          buildChoiceChips(
            values: [null, ...NavigationRailLabelType.values],
            value: labelType,
            labelOf: (e) => e?.name ?? '默',
            onChanged: onLabelType,
          ),
          buildSwitch(title: 'groupAlignment', value: useGroupAlignment, onChanged: (v) => onMark('groupAlignment ${v ? 'on' : 'null'}', () => useGroupAlignment = v)),
          if (useGroupAlignment)
            buildSlider(
              label: 'groupAlignment',
              value: groupAlignment,
              min: -1,
              max: 1,
              fraction: true,
              onChanged: (v) => onMark('groupAlignment ${v.toStringAsFixed(2)}', () => groupAlignment = v),
            ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: '表面',
      subtitle:
          'backgroundColor  elevation  minWidth  minExtendedWidth  useIndicator  indicatorColor  indicatorShape  label / icon',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColorRow('backgroundColor', backgroundColor, (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v)),
          buildSwitch(title: 'elevation', value: useElevation, onChanged: (v) => onMark('elevation ${v ? 'on' : 'null'}', () => useElevation = v)),
          if (useElevation)
            buildSlider(label: 'elevation', value: elevation, min: 1, max: 16, onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v)),
          buildSwitch(title: 'minWidth', value: useMinWidth, onChanged: (v) => onMark('minWidth ${v ? 'on' : 'null'}', () => useMinWidth = v)),
          if (useMinWidth)
            buildSlider(label: 'minWidth', value: minWidth, min: 56, max: 120, onChanged: onMinWidth),
          buildSwitch(title: 'minExtendedWidth', value: useMinExtendedWidth, onChanged: (v) => onMark('minExtendedWidth ${v ? 'on' : 'null'}', () => useMinExtendedWidth = v)),
          if (useMinExtendedWidth)
            buildSlider(label: 'minExtendedWidth', value: minExtendedWidth, min: 150, max: 400, onChanged: (v) => onMark('minExtendedWidth ${v.round()}', () => minExtendedWidth = v)),
          const Text('useIndicator'),
          buildChoiceChips(
            values: const [null, true, false],
            value: useIndicator,
            labelOf: (e) => e == null ? '默' : '$e',
            onChanged: (e) => onMark('useIndicator ${e ?? 'null'}', () => useIndicator = e),
          ),
          buildColorRow('indicatorColor', indicatorColor, (v) => onMark('indicatorColor ${v ?? 'null'}', () => indicatorColor = v)),
          const Text('indicatorShape'),
          buildChoiceChips(
            values: ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e == ShapeKind.none ? 'null' : e.name,
            onChanged: (e) => onMark('indicatorShape ${e == ShapeKind.none ? 'null' : e.name}', () => shapeKind = e),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(label: 'shapeRadius', value: shapeRadius, min: 0, max: 32, onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v)),
          buildColorRow('selectedLabelTextStyle', selectedLabelColor, (v) => onMark('selectedLabelTextStyle ${v ?? 'null'}', () => selectedLabelColor = v)),
          buildColorRow('unselectedLabelTextStyle', unselectedLabelColor, (v) => onMark('unselectedLabelTextStyle ${v ?? 'null'}', () => unselectedLabelColor = v)),
          buildColorRow('selectedIconTheme', selectedIconColor, (v) => onMark('selectedIconTheme ${v ?? 'null'}', () => selectedIconColor = v)),
          buildColorRow('unselectedIconTheme', unselectedIconColor, (v) => onMark('unselectedIconTheme ${v ?? 'null'}', () => unselectedIconColor = v)),
          buildSwitch(title: 'iconTheme.size', value: useIconSize, onChanged: (v) => onMark('iconTheme.size ${v ? 'on' : 'null'}', () => useIconSize = v)),
          if (useIconSize)
            buildSlider(label: 'iconSize', value: iconSize, min: 16, max: 36, onChanged: (v) => onMark('iconSize ${v.round()}', () => iconSize = v)),
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
        Widget? mark;
        if (e == null) {
          mark = Text('默', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600));
        } else if (selected) {
          mark = Icon(
            Icons.check_rounded,
            size: 16,
            color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark ? Colors.white : Colors.black87,
          );
        }
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
            child: mark,
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
    bool fraction = false,
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
      valueBuilder: fraction
          ? (context, v) => Text(
                v.toStringAsFixed(2),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              )
          : null,
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
    lastEvent = '—';
    selectedIndex = 0;
    destinationCount = 6;
    useSelected = true;
    useOnSelected = true;
    extended = false;
    useLeading = true;
    useTrailing = true;
    useElevation = false;
    elevation = 4;
    useGroupAlignment = false;
    groupAlignment = -1;
    labelType = null;
    backgroundColor = null;
    selectedLabelColor = null;
    unselectedLabelColor = null;
    selectedIconColor = null;
    unselectedIconColor = null;
    useIconSize = false;
    iconSize = 24;
    useMinWidth = false;
    minWidth = 80;
    useMinExtendedWidth = true;
    minExtendedWidth = 150;
    useIndicator = null;
    indicatorColor = null;
    shapeKind = ShapeKind.none;
    shapeRadius = 16;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    setState(() {});
  }

  void onExtended(bool value) {
    onMark('extended $value', () {
      extended = value;
      if (value && labelType != null && labelType != NavigationRailLabelType.none) {
        labelType = NavigationRailLabelType.none;
      }
    });
  }

  void onLabelType(NavigationRailLabelType? value) {
    onMark('labelType ${value?.name ?? 'null'}', () {
      labelType = value;
      if (value != null && value != NavigationRailLabelType.none) {
        extended = false;
      }
    });
  }

  void onMinWidth(double value) {
    onMark('minWidth ${value.round()}', () {
      minWidth = value;
      if (useMinExtendedWidth && minExtendedWidth < minWidth) {
        minExtendedWidth = minWidth;
      }
    });
  }

  void onSelected(int index) {
    onMark('onDestinationSelected $index', () {
      selectedIndex = index;
      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }
    });
  }
}
