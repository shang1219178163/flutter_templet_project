import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class NavigationBarDemo extends StatefulWidget {
  const NavigationBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NavigationBarDemo> createState() => _NavigationBarDemoState();
}

class _NavigationBarDemoState extends State<NavigationBarDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

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
    final indicatorShape = shapeKind.shape(roundedRadius: shapeRadius);
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
      indicatorShape: indicatorShape,
      height: useHeight ? height : null,
      labelBehavior: labelBehavior,
      overlayColor: useOverlay ? WidgetStatePropertyAll(overlayColor) : null,
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'destinations  selectedIndex  onDestinationSelected  animationDuration  labelBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('destinations'),
            min: 2,
            max: 5,
            value: destinationCount.toDouble().clamp(2, 5),
            onChanged: (v) => onMark('destinations ${v.round()}', () {
              destinationCount = v.round();
              if (currentPageIndex >= destinationCount) {
                currentPageIndex = destinationCount - 1;
              }
            }),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('selectedIndex'),
            min: 0,
            max: (destinationCount - 1).toDouble(),
            value: currentPageIndex.toDouble().clamp(0.0, (destinationCount - 1).toDouble()),
            onChanged: (v) => onMark('selectedIndex ${v.round()}', () => currentPageIndex = v.round()),
            activeColor: theme.colorScheme.primary,
          ),
          NSwitchListItem(
            title: const Text('onDestinationSelected'),
            value: useOnSelected,
            onChanged: (v) => onMark('onDestinationSelected ${v ? 'on' : 'null'}', () => useOnSelected = v),
          ),
          NSwitchListItem(
            title: const Text('animationDuration'),
            value: useAnim,
            onChanged: (v) => onMark('animationDuration ${v ? 'on' : 'null'}', () => useAnim = v),
          ),
          if (useAnim)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('animationDuration'),
              min: 100,
              max: 1000,
              value: animMs.clamp(100, 1000),
              onChanged: (v) => onMark('animationDuration ${v.round()}ms', () => animMs = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                final ms = v.round();
                final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
                return Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
                );
              },
            ),
          NChoiceChipListItem<NavigationDestinationLabelBehavior?>(
            title: const Text('labelBehavior'),
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
          NChoiceColorListItem(
            title: const Text('backgroundColor'),
            value: backgroundColor,
            onChanged: (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v),
          ),
          NSwitchListItem(
            title: const Text('elevation'),
            value: useElevation,
            onChanged: (v) => onMark('elevation ${v ? 'on' : 'null'}', () => useElevation = v),
          ),
          if (useElevation)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('elevation'),
              min: 0,
              max: 16,
              value: elevation.clamp(0, 16),
              onChanged: (v) => onMark('elevation ${v.toStringAsFixed(1)}', () => elevation = v),
              activeColor: theme.colorScheme.primary,
            ),
          NChoiceColorListItem(
            title: const Text('shadowColor'),
            value: shadowColor,
            onChanged: (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('surfaceTintColor'),
            value: surfaceTintColor,
            onChanged: (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('indicatorColor'),
            value: indicatorColor,
            onChanged: (v) => onMark('indicatorColor ${v ?? 'null'}', () => indicatorColor = v),
          ),
          NChoiceChipListItem<ShapeKind>(
            title: const Text('indicatorShape'),
            values: ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('indicatorShape ${e.label}', () {
              shapeKind = e;
              if (e == ShapeKind.rounded) {
                shapeRadius = e.radius;
              }
            }),
          ),
          if (shapeKind == ShapeKind.rounded)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('shapeRadius'),
              min: 0,
              max: 32,
              value: shapeRadius.clamp(0, 32),
              onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('height'),
            value: useHeight,
            onChanged: (v) => onMark('height ${v ? 'on' : 'null'}', () => useHeight = v),
          ),
          if (useHeight)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('height'),
              min: 56,
              max: 96,
              value: height.clamp(56, 96),
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('overlayColor'),
            value: useOverlay,
            onChanged: (v) => onMark('overlayColor ${v ? 'on' : 'null'}', () => useOverlay = v),
          ),
          if (useOverlay)
            NChoiceColorListItem(
              title: const Text('overlayColor'),
              value: overlayColor,
              onChanged: (v) => onMark('overlayColor ${v ?? 'null'}', () => overlayColor = v),
            ),
        ],
      ),
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
