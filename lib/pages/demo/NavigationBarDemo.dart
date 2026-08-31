import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class NavigationBarDemo extends StatefulWidget {
  const NavigationBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NavigationBarDemo> createState() => _NavigationBarDemoState();
}

class _NavigationBarDemoState extends State<NavigationBarDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  static const _dest = [
    (icon: Icons.explore, selected: null, label: 'Explore', color: Colors.red, page: 'Page 1'),
    (icon: Icons.commute, selected: null, label: 'Commute', color: Colors.green, page: 'Page 2'),
    (icon: Icons.bookmark_border, selected: Icons.bookmark, label: 'Saved', color: Colors.blue, page: 'Page 3'),
    (
      icon: Icons.notifications,
      selected: Icons.notifications,
      label: 'notifications',
      color: Colors.yellow,
      page: 'Page 4'
    ),
    (icon: Icons.settings, selected: Icons.settings, label: 'settings', color: Colors.deepOrangeAccent, page: 'Page 5'),
  ];

  /// 最近事件
  String lastEvent = '—';
  /// 选中项
  int currentPageIndex = 0;
  /// 目的地数量
  int destinationCount = 5;
  /// 是否传入 onDestinationSelected
  bool useOnSelected = true;
  /// 是否传入 animationDuration
  bool useAnim = false;
  /// 切换动画时长（毫秒）
  double animMs = 500;
  /// 是否传入 elevation
  bool useElevation = false;
  /// 海拔阴影
  double elevation = 3;
  /// 是否传入 height
  bool useHeight = false;
  /// 栏高度
  double height = 80;
  /// 是否传入 overlayColor
  bool useOverlay = false;
  /// 标签显示行为
  NavigationDestinationLabelBehavior? labelBehavior;
  /// 背景色
  Color? backgroundColor;
  /// 阴影色
  Color? shadowColor;
  /// 表面色调
  Color? surfaceTintColor;
  /// 指示器颜色
  Color? indicatorColor;
  /// 水波纹覆盖色
  Color? overlayColor;
  /// 指示器形状
  ShapeKind shapeKind = ShapeKind.none;
  /// 圆角半径
  double shapeRadius = 16;

  List<({IconData icon, IconData? selected, String label, Color color, String page})> get items =>
      _dest.take(destinationCount).toList();

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
        Expanded(child: buildPage()),
        buildBar(),
      ],
    );
  }

  Widget buildPage() {
    if (currentPageIndex == 0) {
      return buildPanelPage();
    }
    final item = items[currentPageIndex.clamp(0, items.length - 1)];
    return ColoredBox(
      color: item.page == 'Page 4' ? item.color.withValues(alpha: 0.5) : item.color,
      child: Center(child: Text(item.page)),
    );
  }

  Widget buildPanelPage() {
    final theme = Theme.of(context);
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
                  NLangEnum.en: 'Widget NavigationBar',
                  NLangEnum.zh: '组件 NavigationBar',
                },
                items: [
                  {
                    NLangEnum.en:
                        'Explore / Commute / Saved / notifications / settings and the five colored pages are the original destinations.',
                    NLangEnum.zh: 'Explore、Commute、Saved、notifications、settings 与五色页面是原 Demo 目的地。',
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

  Widget buildBar() {
    return NavigationBar(
      animationDuration: useAnim ? Duration(milliseconds: animMs.round()) : null,
      selectedIndex: currentPageIndex.clamp(0, items.length - 1),
      destinations: [
        for (final e in items)
          NavigationDestination(
            icon: Icon(e.icon),
            selectedIcon: e.selected == null ? null : Icon(e.selected),
            label: e.label,
          ),
      ],
      onDestinationSelected: useOnSelected ? onSelected : null,
      backgroundColor: backgroundColor,
      elevation: useElevation ? elevation : null,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      indicatorColor: indicatorColor,
      indicatorShape: buildIndicatorShape(),
      height: useHeight ? height : null,
      labelBehavior: labelBehavior,
      overlayColor: useOverlay ? WidgetStatePropertyAll(overlayColor) : null,
    );
  }

  ShapeBorder? buildIndicatorShape() {
    switch (shapeKind) {
      case ShapeKind.none:
        return null;
      case ShapeKind.rounded:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius));
      case ShapeKind.stadium:
        return const StadiumBorder();
    }
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'destinations  selectedIndex  onDestinationSelected  animationDuration  labelBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'destinations',
            value: destinationCount.toDouble(),
            min: 2,
            max: 5,
            onChanged: (v) => onMark('destinations ${v.round()}', () {
              destinationCount = v.round();
              if (currentPageIndex >= destinationCount) {
                currentPageIndex = destinationCount - 1;
              }
            }),
          ),
          buildSlider(
            label: 'selectedIndex',
            value: currentPageIndex.toDouble().clamp(0, destinationCount - 1),
            min: 0,
            max: (destinationCount - 1).toDouble(),
            onChanged: (v) => onMark('selectedIndex ${v.round()}', () => currentPageIndex = v.round()),
          ),
          buildSwitch(
            title: 'onDestinationSelected',
            value: useOnSelected,
            onChanged: (v) => onMark('onDestinationSelected ${v ? 'on' : 'null'}', () => useOnSelected = v),
          ),
          buildSwitch(
            title: 'animationDuration',
            value: useAnim,
            onChanged: (v) => onMark('animationDuration ${v ? 'on' : 'null'}', () => useAnim = v),
          ),
          if (useAnim)
            buildSlider(
              label: 'animationDuration',
              value: animMs,
              min: 100,
              max: 1000,
              durationLabel: true,
              onChanged: (v) => onMark('animationDuration ${v.round()}ms', () => animMs = v),
            ),
          const Text('labelBehavior'),
          buildChoiceChips(
            values: [null, ...NavigationDestinationLabelBehavior.values],
            value: labelBehavior,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('labelBehavior ${e?.name ?? 'null'}', () => labelBehavior = e),
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
          'backgroundColor  elevation  shadowColor  surfaceTintColor  indicatorColor  indicatorShape  height  overlayColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColorRow('backgroundColor', backgroundColor,
              (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v)),
          buildSwitch(
            title: 'elevation',
            value: useElevation,
            onChanged: (v) => onMark('elevation ${v ? 'on' : 'null'}', () => useElevation = v),
          ),
          if (useElevation)
            buildSlider(
              label: 'elevation',
              value: elevation,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v),
            ),
          buildColorRow('shadowColor', shadowColor, (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v)),
          buildColorRow('surfaceTintColor', surfaceTintColor,
              (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v)),
          buildColorRow('indicatorColor', indicatorColor,
              (v) => onMark('indicatorColor ${v ?? 'null'}', () => indicatorColor = v)),
          const Text('indicatorShape'),
          buildChoiceChips(
            values: ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e == ShapeKind.none ? 'null' : e.name,
            onChanged: (e) => onMark('indicatorShape ${e == ShapeKind.none ? 'null' : e.name}', () => shapeKind = e),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(
              label: 'shapeRadius',
              value: shapeRadius,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
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
              min: 56,
              max: 96,
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
            ),
          buildSwitch(
            title: 'overlayColor',
            value: useOverlay,
            onChanged: (v) => onMark('overlayColor ${v ? 'on' : 'null'}', () => useOverlay = v),
          ),
          if (useOverlay)
            buildColorRow(
                'overlayColor', overlayColor, (v) => onMark('overlayColor ${v ?? 'null'}', () => overlayColor = v)),
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
                        color:
                            ThemeData.estimateBrightnessForColor(e) == Brightness.dark ? Colors.white : Colors.black87,
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
    bool durationLabel = false,
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
      valueBuilder: durationLabel
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

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    currentPageIndex = 0;
    destinationCount = 5;
    useOnSelected = true;
    useAnim = false;
    animMs = 500;
    useElevation = false;
    elevation = 3;
    useHeight = false;
    height = 80;
    useOverlay = false;
    labelBehavior = null;
    backgroundColor = null;
    shadowColor = null;
    surfaceTintColor = null;
    indicatorColor = null;
    overlayColor = null;
    shapeKind = ShapeKind.none;
    shapeRadius = 16;
    setState(() {});
  }

  void onSelected(int index) {
    currentPageIndex = index;
    lastEvent = 'onDestinationSelected $index';
    DLog.d(lastEvent);
    setState(() {});
  }
}
