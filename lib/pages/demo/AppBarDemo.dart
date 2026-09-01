import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';

/// leading 预设
enum _LeadingKind {
  imply(label: 'imply', icon: null),
  back(label: 'back', icon: Icons.arrow_back),
  menu(label: 'menu', icon: Icons.menu);

  const _LeadingKind({required this.label, required this.icon});

  /// Chip 文案
  final String label;

  /// leading 图标；[imply] 为 null
  final IconData? icon;

  /// 构造 AppBar.leading；回调由页面注入
  Widget? leading({
    required VoidCallback onBack,
    required VoidCallback onMenu,
  }) {
    return switch (this) {
      _LeadingKind.imply => null,
      _LeadingKind.back => IconButton(icon: Icon(icon), onPressed: onBack),
      _LeadingKind.menu => IconButton(icon: Icon(icon), onPressed: onMenu),
    };
  }
}

/// actions 预设
enum _ActionsKind {
  none(label: 'none'),
  pair(label: 'pair'),
  ;

  const _ActionsKind({required this.label});
  final String label;
}

/// flexibleSpace 预设
enum _FlexibleKind {
  none(label: 'none'),
  image(label: 'image'),
  ;

  const _FlexibleKind({required this.label});
  final String label;
}

/// bottom 预设
enum _BottomKind {
  none(label: 'none'),
  tabBar(label: 'tabBar'),
  ;

  const _BottomKind({required this.label});
  final String label;
}

/// notificationPredicate 预设
enum _NotifyKind {
  defaults(label: 'default'),
  always(label: 'always'),
  ;

  const _NotifyKind({required this.label});
  final String label;
}

class AppBarDemo extends StatefulWidget {
  AppBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AppBarDemo> createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo> with SingleTickerProviderStateMixin {
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  late final items = <String>[
    'AppBar隐藏',
    'AppBar背景',
    'Tabview',
  ];

  late final pageColors = List<Color>.generate(items.length, (i) => ColorExt.random);

  late final tabController = TabController(length: items.length, vsync: this);

  _LeadingKind leadingKind = _LeadingKind.imply;
  bool automaticallyImplyLeading = true;
  bool useTitle = true;
  _ActionsKind actionsKind = _ActionsKind.none;
  _FlexibleKind flexibleKind = _FlexibleKind.none;
  _BottomKind bottomKind = _BottomKind.none;
  bool useElevation = false;
  double elevation = 4;
  bool useScrolledUnder = false;
  double scrolledUnderElevation = 4;
  _NotifyKind notifyKind = _NotifyKind.defaults;
  Color? shadowColor;
  Color? surfaceTintColor;
  ShapeKind shapeKind = ShapeKind.none;
  double shapeRadius = 12;
  Color? backgroundColor;
  Color? foregroundColor;
  bool useIconTheme = false;
  Color? iconColor;
  double iconSize = 24;
  bool useActionsIconTheme = false;
  Color? actionsIconColor;
  double actionsIconSize = 24;
  bool primary = true;

  /// 标题是否居中
  bool? centerTitle;
  bool excludeHeaderSemantics = false;
  bool useTitleSpacing = false;
  double titleSpacing = 16;
  double toolbarOpacity = 1;
  double bottomOpacity = 1;
  bool useToolbarHeight = false;
  double toolbarHeight = 56;
  bool useLeadingWidth = false;
  double leadingWidth = 56;
  bool useToolbarTextStyle = false;
  double toolbarFontSize = 14;
  bool useTitleTextStyle = false;
  double titleFontSize = 20;
  OverlayKind overlayKind = OverlayKind.none;
  bool forceMaterialTransparency = false;
  ClipKind? clipKind;
  int lastTabIndex = 0;
  String lastEvent = '—';

  @override
  void initState() {
    super.initState();
    tabController.addListener(onTabIndex);
  }

  @override
  void dispose() {
    tabController.removeListener(onTabIndex);
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: buildDemoAppBar(),
      drawer: Drawer(
        child: Builder(
          builder: (ctx) {
            return SafeArea(
              child: ListTile(
                title: const Text('Drawer'),
                onTap: () => onDrawer(ctx),
              ),
            );
          },
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: Column(
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
                        NLangEnum.en: 'Widget AppBar',
                        NLangEnum.zh: '组件 AppBar',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'The page Scaffold.appBar is the AppBar being tuned. Reset stays as the last action.',
                          NLangEnum.zh: '页面 Scaffold.appBar 就是正在调节的 AppBar。「重置」固定在 actions 末尾。',
                        },
                        {
                          NLangEnum.en:
                              'Enable bottom to put the original TabBar on AppBar. Scroll the panel to see scrolledUnderElevation.',
                          NLangEnum.zh: '打开 bottom 会把原 Demo 的 TabBar 放到 AppBar 上。滚动面板可看 scrolledUnderElevation。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSurfaceCard(),
                    buildSizeCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreview() {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          lastEvent,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  AppBar buildDemoAppBar() {
    return AppBar(
      leading: leadingKind.leading(onBack: onLeadingBack, onMenu: onLeading),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: useTitle ? Text(widget.title ?? "$widget") : null,
      actions: [
        ...?actionsOf(),
        TextButton(
          onPressed: onReset,
          child: Text(
            '重置',
            style: TextStyle(color: foregroundColor ?? theme.colorScheme.onPrimary),
          ),
        ),
      ],
      flexibleSpace: flexibleKind == _FlexibleKind.image ? buildFlexibleSpace() : null,
      bottom: bottomKind == _BottomKind.tabBar ? buildAppBarBottom() : null,
      elevation: useElevation ? elevation : null,
      scrolledUnderElevation: useScrolledUnder ? scrolledUnderElevation : null,
      notificationPredicate: notifyKind == _NotifyKind.always ? (n) => true : defaultScrollNotificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shapeKind.shape(roundedRadius: shapeRadius),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: useIconTheme ? IconThemeData(color: iconColor, size: iconSize) : null,
      actionsIconTheme: useActionsIconTheme ? IconThemeData(color: actionsIconColor, size: actionsIconSize) : null,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: useTitleSpacing ? titleSpacing : null,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: useToolbarHeight ? toolbarHeight : null,
      leadingWidth: useLeadingWidth ? leadingWidth : null,
      toolbarTextStyle: useToolbarTextStyle ? TextStyle(fontSize: toolbarFontSize, color: foregroundColor) : null,
      titleTextStyle: useTitleTextStyle
          ? TextStyle(fontSize: titleFontSize, color: foregroundColor, fontWeight: FontWeight.w600)
          : null,
      systemOverlayStyle: overlayKind.style,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipKind?.clip,
    );
  }

  Widget buildFlexibleSpace() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(AppRes.image.urls[5]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBarBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: ColoredBox(
        color: theme.primaryColor,
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: theme.scaffoldBackgroundColor,
          tabs: items.map((e) => Tab(text: e)).toList(),
          onTap: onTab,
        ),
      ),
    );
  }

  List<Widget>? actionsOf() {
    if (actionsKind == _ActionsKind.none) {
      return null;
    }
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: onActionSearch,
      ),
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: onActionMore,
      ),
    ];
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造与行为',
      subtitle: 'leading · title · actions · bottom · centerTitle',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem(
            title: const Text('leading'),
            values: _LeadingKind.values,
            value: leadingKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('leading ${e.label}', () => leadingKind = e),
          ),
          if (leadingKind == _LeadingKind.imply)
            NSwitchListItem(
              title: const Text('automaticallyImplyLeading'),
              value: automaticallyImplyLeading,
              onChanged: (v) => onMark('automaticallyImplyLeading $v', () => automaticallyImplyLeading = v),
            ),
          NSwitchListItem(
            title: const Text('title 显示标题'),
            value: useTitle,
            onChanged: (v) => onMark('title ${v ? 'on' : 'null'}', () => useTitle = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('actions'),
            values: _ActionsKind.values,
            value: actionsKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('actions ${e.label}', () => actionsKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('flexibleSpace'),
            values: _FlexibleKind.values,
            value: flexibleKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('flexibleSpace ${e.label}', () => flexibleKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('bottom'),
            values: _BottomKind.values,
            value: bottomKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('bottom ${e.label}', () => bottomKind = e),
          ),
          NSwitchListItem(
            title: const Text('primary 预留状态栏'),
            value: primary,
            onChanged: (v) => onMark('primary $v', () => primary = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('centerTitle'),
            values: const <bool?>[null, true, false],
            value: centerTitle,
            labelOf: (e) => e == null ? '默' : '$e',
            onChanged: (e) => onMark('centerTitle ${e ?? 'null'}', () => centerTitle = e),
          ),
          NSwitchListItem(
            title: const Text('excludeHeaderSemantics'),
            value: excludeHeaderSemantics,
            onChanged: (v) => onMark('excludeHeaderSemantics $v', () => excludeHeaderSemantics = v),
          ),
          NSwitchListItem(
            title: const Text('forceMaterialTransparency'),
            value: forceMaterialTransparency,
            onChanged: (v) => onMark('forceMaterialTransparency $v', () => forceMaterialTransparency = v),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('notificationPredicate'),
            values: _NotifyKind.values,
            value: notifyKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('notificationPredicate ${e.label}', () => notifyKind = e),
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'color · shape · elevation · overlay',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceColorListItem(
            title: const Text('backgroundColor'),
            value: backgroundColor,
            onChanged: (e) => onMark('backgroundColor ${e ?? 'null'}', () => backgroundColor = e),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('foregroundColor'),
            value: foregroundColor,
            onChanged: (e) => onMark('foregroundColor ${e ?? 'null'}', () => foregroundColor = e),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('shadowColor'),
            value: shadowColor,
            onChanged: (e) => onMark('shadowColor ${e ?? 'null'}', () => shadowColor = e),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('surfaceTintColor'),
            value: surfaceTintColor,
            onChanged: (e) => onMark('surfaceTintColor ${e ?? 'null'}', () => surfaceTintColor = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('shape'),
            values: ShapeKind.values,
            value: shapeKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('shape ${e.label}', () {
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
              max: 28,
              value: shapeRadius.clamp(0, 28),
              onChanged: (v) => onMark('shapeRadius ${v.toStringAsFixed(0)}', () => shapeRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
          const SizedBox(height: 8),
          NChoiceChipListItem<ClipKind?>(
            title: const Text('clipBehavior'),
            values: const [null, ...ClipKind.values],
            value: clipKind,
            labelOf: (e) => e?.label ?? 'null',
            onChanged: (e) => onMark('clipBehavior ${e?.label ?? 'null'}', () => clipKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('systemOverlayStyle'),
            values: OverlayKind.values,
            value: overlayKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('systemOverlayStyle ${e.label}', () => overlayKind = e),
          ),
          NSwitchListItem(
            title: const Text('elevation 指定高度'),
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
              onChanged: (v) => onMark('elevation ${v.toStringAsFixed(0)}', () => elevation = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('scrolledUnderElevation 指定高度'),
            value: useScrolledUnder,
            onChanged: (v) => onMark('scrolledUnderElevation ${v ? 'on' : 'null'}', () => useScrolledUnder = v),
          ),
          if (useScrolledUnder)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('scrolledUnder'),
              min: 0,
              max: 16,
              value: scrolledUnderElevation.clamp(0, 16),
              onChanged: (v) => onMark('scrolledUnder ${v.toStringAsFixed(0)}', () => scrolledUnderElevation = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('iconTheme 自定义'),
            value: useIconTheme,
            onChanged: (v) => onMark('iconTheme ${v ? 'on' : 'null'}', () => useIconTheme = v),
          ),
          if (useIconTheme) ...[
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('iconTheme.color'),
              value: iconColor,
              onChanged: (e) => onMark('iconTheme.color ${e ?? 'null'}', () => iconColor = e),
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('iconTheme.size'),
              min: 16,
              max: 36,
              value: iconSize.clamp(16, 36),
              onChanged: (v) => onMark('iconTheme.size ${v.toStringAsFixed(0)}', () => iconSize = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          if (actionsKind == _ActionsKind.pair)
            NSwitchListItem(
              title: const Text('actionsIconTheme 自定义'),
              value: useActionsIconTheme,
              onChanged: (v) => onMark('actionsIconTheme ${v ? 'on' : 'null'}', () => useActionsIconTheme = v),
            ),
          if (actionsKind == _ActionsKind.pair && useActionsIconTheme) ...[
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('actionsIconTheme.color'),
              value: actionsIconColor,
              onChanged: (e) => onMark('actionsIconTheme.color ${e ?? 'null'}', () => actionsIconColor = e),
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('actionsIcon.size'),
              min: 16,
              max: 36,
              value: actionsIconSize.clamp(16, 36),
              onChanged: (v) => onMark('actionsIcon.size ${v.toStringAsFixed(0)}', () => actionsIconSize = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          NSwitchListItem(
            title: const Text('toolbarTextStyle 自定义'),
            value: useToolbarTextStyle,
            onChanged: (v) => onMark('toolbarTextStyle ${v ? 'on' : 'null'}', () => useToolbarTextStyle = v),
          ),
          if (useToolbarTextStyle)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('toolbarFontSize'),
              min: 10,
              max: 22,
              value: toolbarFontSize.clamp(10, 22),
              onChanged: (v) => onMark('toolbarFontSize ${v.toStringAsFixed(0)}', () => toolbarFontSize = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('titleTextStyle 自定义'),
            value: useTitleTextStyle,
            onChanged: (v) => onMark('titleTextStyle ${v ? 'on' : 'null'}', () => useTitleTextStyle = v),
          ),
          if (useTitleTextStyle)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('titleFontSize'),
              min: 12,
              max: 28,
              value: titleFontSize.clamp(12, 28),
              onChanged: (v) => onMark('titleFontSize ${v.toStringAsFixed(0)}', () => titleFontSize = v),
              activeColor: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget buildSizeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'toolbarHeight · leadingWidth · titleSpacing · opacity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListItem(
            title: const Text('toolbarHeight 指定高度'),
            value: useToolbarHeight,
            onChanged: (v) => onMark('toolbarHeight ${v ? 'on' : 'null'}', () => useToolbarHeight = v),
          ),
          if (useToolbarHeight)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('toolbarHeight'),
              min: 40,
              max: 120,
              value: toolbarHeight.clamp(40, 120),
              onChanged: (v) => onMark('toolbarHeight ${v.toStringAsFixed(0)}', () => toolbarHeight = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('leadingWidth 指定宽度'),
            value: useLeadingWidth,
            onChanged: (v) => onMark('leadingWidth ${v ? 'on' : 'null'}', () => useLeadingWidth = v),
          ),
          if (useLeadingWidth)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('leadingWidth'),
              min: 24,
              max: 120,
              value: leadingWidth.clamp(24, 120),
              onChanged: (v) => onMark('leadingWidth ${v.toStringAsFixed(0)}', () => leadingWidth = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('titleSpacing 指定间距'),
            value: useTitleSpacing,
            onChanged: (v) => onMark('titleSpacing ${v ? 'on' : 'null'}', () => useTitleSpacing = v),
          ),
          if (useTitleSpacing)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('titleSpacing'),
              min: 0,
              max: 72,
              value: titleSpacing.clamp(0, 72),
              onChanged: (v) => onMark('titleSpacing ${v.toStringAsFixed(0)}', () => titleSpacing = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('toolbarOpacity'),
            min: 0,
            max: 1,
            value: toolbarOpacity.clamp(0, 1),
            onChanged: (v) => onMark('toolbarOpacity ${v.toStringAsFixed(2)}', () => toolbarOpacity = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(2),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          if (bottomKind == _BottomKind.tabBar)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('bottomOpacity'),
              min: 0,
              max: 1,
              value: bottomOpacity.clamp(0, 1),
              onChanged: (v) => onMark('bottomOpacity ${v.toStringAsFixed(2)}', () => bottomOpacity = v),
              activeColor: theme.colorScheme.primary,
              valueBuilder: (context, v) {
                return Text(
                  v.toStringAsFixed(2),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void onTabIndex() {
    if (tabController.indexIsChanging) {
      return;
    }
    lastTabIndex = tabController.index;
    lastEvent = 'tabController:$lastTabIndex';
    DLog.d('tabController:$lastTabIndex');
    setState(() {});
  }

  void onTab(int index) {
    lastTabIndex = index;
    lastEvent = 'onTap $index';
    DLog.d('onTap $index');
    setState(() {});
  }

  void onLeadingBack() {
    lastEvent = 'onLeading';
    DLog.d('onLeading');
    Navigator.of(context).maybePop();
  }

  void onLeading() {
    lastEvent = 'onLeading';
    DLog.d('onLeading');
    setState(() {});
  }

  void onActionSearch() {
    lastEvent = 'onAction search';
    DLog.d('onAction search');
    setState(() {});
  }

  void onActionMore() {
    lastEvent = 'onAction more';
    DLog.d('onAction more');
    setState(() {});
  }

  void onDrawer(BuildContext ctx) {
    lastEvent = 'onDrawer';
    DLog.d('onDrawer');
    Navigator.pop(ctx);
    setState(() {});
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onReset() {
    leadingKind = _LeadingKind.imply;
    automaticallyImplyLeading = true;
    useTitle = true;
    actionsKind = _ActionsKind.none;
    flexibleKind = _FlexibleKind.none;
    bottomKind = _BottomKind.none;
    useElevation = false;
    elevation = 4;
    useScrolledUnder = false;
    scrolledUnderElevation = 4;
    notifyKind = _NotifyKind.defaults;
    shadowColor = null;
    surfaceTintColor = null;
    shapeKind = ShapeKind.none;
    shapeRadius = 12;
    backgroundColor = null;
    foregroundColor = null;
    useIconTheme = false;
    iconColor = null;
    iconSize = 24;
    useActionsIconTheme = false;
    actionsIconColor = null;
    actionsIconSize = 24;
    primary = true;
    centerTitle = null;
    excludeHeaderSemantics = false;
    useTitleSpacing = false;
    titleSpacing = 16;
    toolbarOpacity = 1;
    bottomOpacity = 1;
    useToolbarHeight = false;
    toolbarHeight = 56;
    useLeadingWidth = false;
    leadingWidth = 56;
    useToolbarTextStyle = false;
    toolbarFontSize = 14;
    useTitleTextStyle = false;
    titleFontSize = 20;
    overlayKind = OverlayKind.none;
    forceMaterialTransparency = false;
    clipKind = null;
    lastTabIndex = 0;
    lastEvent = '—';
    if (tabController.index != 0) {
      tabController.animateTo(0);
    }
    setState(() {});
  }
}
