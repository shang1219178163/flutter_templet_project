import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// leading 预设
enum _LeadingKind { imply, back, menu }

/// actions 预设
enum _ActionsKind { none, pair }

/// flexibleSpace 预设
enum _FlexibleKind { none, image }

/// bottom 预设
enum _BottomKind { none, tabBar }

/// notificationPredicate 预设
enum _NotifyKind { defaults, always }

/// 三态 bool?
enum _Tri { nil, yes, no }

class AppBarDemo extends StatefulWidget {
  AppBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AppBarDemo> createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo> with SingleTickerProviderStateMixin {
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
  _Tri centerTitleKind = _Tri.nil;
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
  ClipKind clipKind = ClipKind.nil;
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
    final scheme = Theme.of(context).colorScheme;
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
    final scheme = Theme.of(context).colorScheme;
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
                        {
                          NLangEnum.en: 'The page has a Drawer, so automaticallyImplyLeading can show a menu button.',
                          NLangEnum.zh: '页面带 Drawer，automaticallyImplyLeading 为 true 时会显示菜单按钮。',
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
      ),
    );
  }

  Widget buildPreview() {
    final theme = Theme.of(context);
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
      leading: leadingOf(),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: useTitle ? Text(widget.title ?? "$widget") : null,
      actions: [
        ...?actionsOf(),
        TextButton(
          onPressed: onReset,
          child: Text(
            '重置',
            style: TextStyle(color: foregroundColor ?? Theme.of(context).colorScheme.onPrimary),
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
      shape: shapeOf(),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: useIconTheme ? IconThemeData(color: iconColor, size: iconSize) : null,
      actionsIconTheme: useActionsIconTheme ? IconThemeData(color: actionsIconColor, size: actionsIconSize) : null,
      primary: primary,
      centerTitle: centerTitleOf(),
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
      systemOverlayStyle: overlayOf(),
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipOf(),
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
    final theme = Theme.of(context);
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

  Widget? leadingOf() {
    switch (leadingKind) {
      case _LeadingKind.imply:
        return null;
      case _LeadingKind.back:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onLeadingBack,
        );
      case _LeadingKind.menu:
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onLeading,
        );
    }
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

  ShapeBorder? shapeOf() {
    switch (shapeKind) {
      case ShapeKind.none:
        return null;
      case ShapeKind.rounded:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius));
      case ShapeKind.stadium:
        return const StadiumBorder();
    }
  }

  bool? centerTitleOf() {
    switch (centerTitleKind) {
      case _Tri.nil:
        return null;
      case _Tri.yes:
        return true;
      case _Tri.no:
        return false;
    }
  }

  Clip? clipOf() {
    switch (clipKind) {
      case ClipKind.nil:
        return null;
      case ClipKind.none:
        return Clip.none;
      case ClipKind.hardEdge:
        return Clip.hardEdge;
      case ClipKind.antiAlias:
        return Clip.antiAlias;
      case ClipKind.antiAliasWithSaveLayer:
        return Clip.antiAliasWithSaveLayer;
    }
  }

  SystemUiOverlayStyle? overlayOf() {
    switch (overlayKind) {
      case OverlayKind.none:
        return null;
      case OverlayKind.light:
        return SystemUiOverlayStyle.light;
      case OverlayKind.dark:
        return SystemUiOverlayStyle.dark;
    }
  }

  Widget buildConstructCard() {
    return NStyleCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'leading · title · actions · flexibleSpace · bottom',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'leading',
            child: buildChoiceChips(
              values: _LeadingKind.values,
              isSelected: (e) => leadingKind == e,
              labelOf: (e) => e.name,
              onChanged: onLeadingKind,
            ),
          ),
          if (leadingKind == _LeadingKind.imply)
            buildSwitch(
              title: 'automaticallyImplyLeading',
              value: automaticallyImplyLeading,
              onChanged: onAutomaticallyImplyLeading,
            ),
          buildSwitch(title: 'title 显示标题', value: useTitle, onChanged: onUseTitle),
          buildField(
            label: 'actions',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ActionsKind.values,
              isSelected: (e) => actionsKind == e,
              labelOf: (e) => e.name,
              onChanged: onActionsKind,
            ),
          ),
          buildField(
            label: 'flexibleSpace',
            showTopGap: true,
            child: buildChoiceChips(
              values: _FlexibleKind.values,
              isSelected: (e) => flexibleKind == e,
              labelOf: (e) => e.name,
              onChanged: onFlexibleKind,
            ),
          ),
          buildField(
            label: 'bottom',
            showTopGap: true,
            child: buildChoiceChips(
              values: _BottomKind.values,
              isSelected: (e) => bottomKind == e,
              labelOf: (e) => e.name,
              onChanged: onBottomKind,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NStyleCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'color · shape · elevation · overlay',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'backgroundColor',
            child: buildColorDots(value: backgroundColor, onChanged: onBackgroundColor),
          ),
          buildField(
            label: 'foregroundColor',
            showTopGap: true,
            child: buildColorDots(value: foregroundColor, onChanged: onForegroundColor),
          ),
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
            label: 'shape',
            showTopGap: true,
            child: buildChoiceChips(
              values: ShapeKind.values,
              isSelected: (e) => shapeKind == e,
              labelOf: (e) => e.name,
              onChanged: onShapeKind,
            ),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(label: 'shapeRadius', value: shapeRadius, min: 0, max: 28, onChanged: onShapeRadius),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: ClipKind.values,
              isSelected: (e) => clipKind == e,
              labelOf: (e) => e == ClipKind.nil ? 'null' : e.name,
              onChanged: onClipKind,
            ),
          ),
          buildField(
            label: 'systemOverlayStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: OverlayKind.values,
              isSelected: (e) => overlayKind == e,
              labelOf: (e) => e.name,
              onChanged: onOverlayKind,
            ),
          ),
          buildSwitch(title: 'elevation 指定高度', value: useElevation, onChanged: onUseElevation),
          if (useElevation) buildSlider(label: 'elevation', value: elevation, min: 0, max: 16, onChanged: onElevation),
          buildSwitch(
            title: 'scrolledUnderElevation 指定高度',
            value: useScrolledUnder,
            onChanged: onUseScrolledUnder,
          ),
          if (useScrolledUnder)
            buildSlider(
              label: 'scrolledUnder',
              value: scrolledUnderElevation,
              min: 0,
              max: 16,
              onChanged: onScrolledUnderElevation,
            ),
          buildSwitch(title: 'iconTheme 自定义', value: useIconTheme, onChanged: onUseIconTheme),
          if (useIconTheme) ...[
            buildField(
              label: 'iconTheme.color',
              showTopGap: true,
              child: buildColorDots(value: iconColor, onChanged: onIconColor),
            ),
            buildSlider(label: 'iconTheme.size', value: iconSize, min: 16, max: 36, onChanged: onIconSize),
          ],
          if (actionsKind == _ActionsKind.pair)
            buildSwitch(
              title: 'actionsIconTheme 自定义',
              value: useActionsIconTheme,
              onChanged: onUseActionsIconTheme,
            ),
          if (actionsKind == _ActionsKind.pair && useActionsIconTheme) ...[
            buildField(
              label: 'actionsIconTheme.color',
              showTopGap: true,
              child: buildColorDots(value: actionsIconColor, onChanged: onActionsIconColor),
            ),
            buildSlider(
              label: 'actionsIcon.size',
              value: actionsIconSize,
              min: 16,
              max: 36,
              onChanged: onActionsIconSize,
            ),
          ],
          buildSwitch(title: 'toolbarTextStyle 自定义', value: useToolbarTextStyle, onChanged: onUseToolbarTextStyle),
          if (useToolbarTextStyle)
            buildSlider(
              label: 'toolbarFontSize',
              value: toolbarFontSize,
              min: 10,
              max: 22,
              onChanged: onToolbarFontSize,
            ),
          buildSwitch(title: 'titleTextStyle 自定义', value: useTitleTextStyle, onChanged: onUseTitleTextStyle),
          if (useTitleTextStyle)
            buildSlider(label: 'titleFontSize', value: titleFontSize, min: 12, max: 28, onChanged: onTitleFontSize),
        ],
      ),
    );
  }

  Widget buildSizeCard() {
    return NStyleCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'toolbarHeight · leadingWidth · titleSpacing · opacity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'toolbarHeight 指定高度', value: useToolbarHeight, onChanged: onUseToolbarHeight),
          if (useToolbarHeight)
            buildSlider(label: 'toolbarHeight', value: toolbarHeight, min: 40, max: 120, onChanged: onToolbarHeight),
          buildSwitch(title: 'leadingWidth 指定宽度', value: useLeadingWidth, onChanged: onUseLeadingWidth),
          if (useLeadingWidth)
            buildSlider(label: 'leadingWidth', value: leadingWidth, min: 24, max: 120, onChanged: onLeadingWidth),
          buildSwitch(title: 'titleSpacing 指定间距', value: useTitleSpacing, onChanged: onUseTitleSpacing),
          if (useTitleSpacing)
            buildSlider(label: 'titleSpacing', value: titleSpacing, min: 0, max: 72, onChanged: onTitleSpacing),
          buildSlider(
            label: 'toolbarOpacity',
            value: toolbarOpacity,
            min: 0,
            max: 1,
            onChanged: onToolbarOpacity,
            fractionDigits: 2,
          ),
          if (bottomKind == _BottomKind.tabBar)
            buildSlider(
              label: 'bottomOpacity',
              value: bottomOpacity,
              min: 0,
              max: 1,
              onChanged: onBottomOpacity,
              fractionDigits: 2,
            ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NStyleCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'primary · centerTitle · notificationPredicate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'primary 预留状态栏', value: primary, onChanged: onPrimary),
          buildField(
            label: 'centerTitle',
            showTopGap: true,
            child: buildChoiceChips(
              values: _Tri.values,
              isSelected: (e) => centerTitleKind == e,
              labelOf: (e) {
                switch (e) {
                  case _Tri.nil:
                    return 'null';
                  case _Tri.yes:
                    return 'true';
                  case _Tri.no:
                    return 'false';
                }
              },
              onChanged: onCenterTitleKind,
            ),
          ),
          buildSwitch(
            title: 'excludeHeaderSemantics',
            value: excludeHeaderSemantics,
            onChanged: onExcludeHeaderSemantics,
          ),
          buildSwitch(
            title: 'forceMaterialTransparency',
            value: forceMaterialTransparency,
            onChanged: onForceMaterialTransparency,
          ),
          buildField(
            label: 'notificationPredicate',
            showTopGap: true,
            child: buildChoiceChips(
              values: _NotifyKind.values,
              isSelected: (e) => notifyKind == e,
              labelOf: (e) => e == _NotifyKind.defaults ? 'default' : e.name,
              onChanged: onNotifyKind,
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
    int fractionDigits = 0,
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
      trailingBuilder: fractionDigits > 0
          ? (context, v) {
              return Text(
                v.toStringAsFixed(fractionDigits),
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

  void onLeadingKind(_LeadingKind value) {
    leadingKind = value;
    setState(() {});
  }

  void onAutomaticallyImplyLeading(bool value) {
    automaticallyImplyLeading = value;
    setState(() {});
  }

  void onUseTitle(bool value) {
    useTitle = value;
    setState(() {});
  }

  void onActionsKind(_ActionsKind value) {
    actionsKind = value;
    setState(() {});
  }

  void onFlexibleKind(_FlexibleKind value) {
    flexibleKind = value;
    setState(() {});
  }

  void onBottomKind(_BottomKind value) {
    bottomKind = value;
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

  void onUseScrolledUnder(bool value) {
    useScrolledUnder = value;
    setState(() {});
  }

  void onScrolledUnderElevation(double value) {
    scrolledUnderElevation = value;
    setState(() {});
  }

  void onNotifyKind(_NotifyKind value) {
    notifyKind = value;
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

  void onShapeKind(ShapeKind value) {
    shapeKind = value;
    setState(() {});
  }

  void onShapeRadius(double value) {
    shapeRadius = value;
    setState(() {});
  }

  void onBackgroundColor(Color? value) {
    backgroundColor = value;
    setState(() {});
  }

  void onForegroundColor(Color? value) {
    foregroundColor = value;
    setState(() {});
  }

  void onUseIconTheme(bool value) {
    useIconTheme = value;
    setState(() {});
  }

  void onIconColor(Color? value) {
    iconColor = value;
    setState(() {});
  }

  void onIconSize(double value) {
    iconSize = value;
    setState(() {});
  }

  void onUseActionsIconTheme(bool value) {
    useActionsIconTheme = value;
    setState(() {});
  }

  void onActionsIconColor(Color? value) {
    actionsIconColor = value;
    setState(() {});
  }

  void onActionsIconSize(double value) {
    actionsIconSize = value;
    setState(() {});
  }

  void onPrimary(bool value) {
    primary = value;
    setState(() {});
  }

  void onCenterTitleKind(_Tri value) {
    centerTitleKind = value;
    setState(() {});
  }

  void onExcludeHeaderSemantics(bool value) {
    excludeHeaderSemantics = value;
    setState(() {});
  }

  void onUseTitleSpacing(bool value) {
    useTitleSpacing = value;
    setState(() {});
  }

  void onTitleSpacing(double value) {
    titleSpacing = value;
    setState(() {});
  }

  void onToolbarOpacity(double value) {
    toolbarOpacity = value;
    setState(() {});
  }

  void onBottomOpacity(double value) {
    bottomOpacity = value;
    setState(() {});
  }

  void onUseToolbarHeight(bool value) {
    useToolbarHeight = value;
    setState(() {});
  }

  void onToolbarHeight(double value) {
    toolbarHeight = value;
    setState(() {});
  }

  void onUseLeadingWidth(bool value) {
    useLeadingWidth = value;
    setState(() {});
  }

  void onLeadingWidth(double value) {
    leadingWidth = value;
    setState(() {});
  }

  void onUseToolbarTextStyle(bool value) {
    useToolbarTextStyle = value;
    setState(() {});
  }

  void onToolbarFontSize(double value) {
    toolbarFontSize = value;
    setState(() {});
  }

  void onUseTitleTextStyle(bool value) {
    useTitleTextStyle = value;
    setState(() {});
  }

  void onTitleFontSize(double value) {
    titleFontSize = value;
    setState(() {});
  }

  void onOverlayKind(OverlayKind value) {
    overlayKind = value;
    setState(() {});
  }

  void onForceMaterialTransparency(bool value) {
    forceMaterialTransparency = value;
    setState(() {});
  }

  void onClipKind(ClipKind value) {
    clipKind = value;
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
    centerTitleKind = _Tri.nil;
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
    clipKind = ClipKind.nil;
    lastTabIndex = 0;
    lastEvent = '—';
    if (tabController.index != 0) {
      tabController.animateTo(0);
    }
    setState(() {});
  }
}
