import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
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
      leading: leadingOf(),
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
      shape: shapeOf(),
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

  Widget? leadingOf() => switch (leadingKind) {
        _LeadingKind.imply => null,
        _LeadingKind.back => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onLeadingBack,
          ),
        _LeadingKind.menu => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onLeading,
          ),
      };

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

  ShapeBorder? shapeOf() => switch (shapeKind) {
        ShapeKind.none => null,
        ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(shapeRadius)),
        ShapeKind.stadium => const StadiumBorder(),
      };

  Clip? clipOf() => switch (clipKind) {
        ClipKind.nil => null,
        ClipKind.none => Clip.none,
        ClipKind.hardEdge => Clip.hardEdge,
        ClipKind.antiAlias => Clip.antiAlias,
        ClipKind.antiAliasWithSaveLayer => Clip.antiAliasWithSaveLayer,
      };

  SystemUiOverlayStyle? overlayOf() => switch (overlayKind) {
        OverlayKind.none => null,
        OverlayKind.light => SystemUiOverlayStyle.light,
        OverlayKind.dark => SystemUiOverlayStyle.dark,
      };

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造与行为',
      subtitle: 'leading · title · actions · bottom · centerTitle',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'leading',
            child: buildChoiceChips(
              values: _LeadingKind.values,
              isSelected: (e) => leadingKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('leading ${e.name}', () => leadingKind = e),
            ),
          ),
          if (leadingKind == _LeadingKind.imply)
            buildSwitch(
              title: 'automaticallyImplyLeading',
              value: automaticallyImplyLeading,
              onChanged: (v) => onMark('automaticallyImplyLeading $v', () => automaticallyImplyLeading = v),
            ),
          buildSwitch(
            title: 'title 显示标题',
            value: useTitle,
            onChanged: (v) => onMark('title ${v ? 'on' : 'null'}', () => useTitle = v),
          ),
          buildField(
            label: 'actions',
            showTopGap: true,
            child: buildChoiceChips(
              values: _ActionsKind.values,
              isSelected: (e) => actionsKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('actions ${e.name}', () => actionsKind = e),
            ),
          ),
          buildField(
            label: 'flexibleSpace',
            showTopGap: true,
            child: buildChoiceChips(
              values: _FlexibleKind.values,
              isSelected: (e) => flexibleKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('flexibleSpace ${e.name}', () => flexibleKind = e),
            ),
          ),
          buildField(
            label: 'bottom',
            showTopGap: true,
            child: buildChoiceChips(
              values: _BottomKind.values,
              isSelected: (e) => bottomKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('bottom ${e.name}', () => bottomKind = e),
            ),
          ),
          buildSwitch(
            title: 'primary 预留状态栏',
            value: primary,
            onChanged: (v) => onMark('primary $v', () => primary = v),
          ),
          buildField(
            label: 'centerTitle',
            showTopGap: true,
            child: buildChoiceChips(
              values: const <bool?>[null, true, false],
              isSelected: (e) => centerTitle == e,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('centerTitle ${e ?? 'null'}', () => centerTitle = e),
            ),
          ),
          buildSwitch(
            title: 'excludeHeaderSemantics',
            value: excludeHeaderSemantics,
            onChanged: (v) => onMark('excludeHeaderSemantics $v', () => excludeHeaderSemantics = v),
          ),
          buildSwitch(
            title: 'forceMaterialTransparency',
            value: forceMaterialTransparency,
            onChanged: (v) => onMark('forceMaterialTransparency $v', () => forceMaterialTransparency = v),
          ),
          buildField(
            label: 'notificationPredicate',
            showTopGap: true,
            child: buildChoiceChips(
              values: _NotifyKind.values,
              isSelected: (e) => notifyKind == e,
              labelOf: (e) => e == _NotifyKind.defaults ? 'default' : e.name,
              onChanged: (e) => onMark('notificationPredicate ${e == _NotifyKind.defaults ? 'default' : e.name}', () => notifyKind = e),
            ),
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
          buildField(
            label: 'backgroundColor',
            child: buildColorDots(
              value: backgroundColor,
              onChanged: (e) => onMark('backgroundColor ${e ?? 'null'}', () => backgroundColor = e),
            ),
          ),
          buildField(
            label: 'foregroundColor',
            showTopGap: true,
            child: buildColorDots(
              value: foregroundColor,
              onChanged: (e) => onMark('foregroundColor ${e ?? 'null'}', () => foregroundColor = e),
            ),
          ),
          buildField(
            label: 'shadowColor',
            showTopGap: true,
            child: buildColorDots(
              value: shadowColor,
              onChanged: (e) => onMark('shadowColor ${e ?? 'null'}', () => shadowColor = e),
            ),
          ),
          buildField(
            label: 'surfaceTintColor',
            showTopGap: true,
            child: buildColorDots(
              value: surfaceTintColor,
              onChanged: (e) => onMark('surfaceTintColor ${e ?? 'null'}', () => surfaceTintColor = e),
            ),
          ),
          buildField(
            label: 'shape',
            showTopGap: true,
            child: buildChoiceChips(
              values: ShapeKind.values,
              isSelected: (e) => shapeKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('shape ${e.name}', () => shapeKind = e),
            ),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(
              label: 'shapeRadius',
              value: shapeRadius,
              min: 0,
              max: 28,
              onChanged: (v) => onMark('shapeRadius ${v.toStringAsFixed(0)}', () => shapeRadius = v),
            ),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: ClipKind.values,
              isSelected: (e) => clipKind == e,
              labelOf: (e) => e == ClipKind.nil ? 'null' : e.name,
              onChanged: (e) => onMark('clipBehavior ${e == ClipKind.nil ? 'null' : e.name}', () => clipKind = e),
            ),
          ),
          buildField(
            label: 'systemOverlayStyle',
            showTopGap: true,
            child: buildChoiceChips(
              values: OverlayKind.values,
              isSelected: (e) => overlayKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('systemOverlayStyle ${e.name}', () => overlayKind = e),
            ),
          ),
          buildSwitch(
            title: 'elevation 指定高度',
            value: useElevation,
            onChanged: (v) => onMark('elevation ${v ? 'on' : 'null'}', () => useElevation = v),
          ),
          if (useElevation)
            buildSlider(
              label: 'elevation',
              value: elevation,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('elevation ${v.toStringAsFixed(0)}', () => elevation = v),
            ),
          buildSwitch(
            title: 'scrolledUnderElevation 指定高度',
            value: useScrolledUnder,
            onChanged: (v) => onMark('scrolledUnderElevation ${v ? 'on' : 'null'}', () => useScrolledUnder = v),
          ),
          if (useScrolledUnder)
            buildSlider(
              label: 'scrolledUnder',
              value: scrolledUnderElevation,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('scrolledUnder ${v.toStringAsFixed(0)}', () => scrolledUnderElevation = v),
            ),
          buildSwitch(
            title: 'iconTheme 自定义',
            value: useIconTheme,
            onChanged: (v) => onMark('iconTheme ${v ? 'on' : 'null'}', () => useIconTheme = v),
          ),
          if (useIconTheme) ...[
            buildField(
              label: 'iconTheme.color',
              showTopGap: true,
              child: buildColorDots(
                value: iconColor,
                onChanged: (e) => onMark('iconTheme.color ${e ?? 'null'}', () => iconColor = e),
              ),
            ),
            buildSlider(
              label: 'iconTheme.size',
              value: iconSize,
              min: 16,
              max: 36,
              onChanged: (v) => onMark('iconTheme.size ${v.toStringAsFixed(0)}', () => iconSize = v),
            ),
          ],
          if (actionsKind == _ActionsKind.pair)
            buildSwitch(
              title: 'actionsIconTheme 自定义',
              value: useActionsIconTheme,
              onChanged: (v) => onMark('actionsIconTheme ${v ? 'on' : 'null'}', () => useActionsIconTheme = v),
            ),
          if (actionsKind == _ActionsKind.pair && useActionsIconTheme) ...[
            buildField(
              label: 'actionsIconTheme.color',
              showTopGap: true,
              child: buildColorDots(
                value: actionsIconColor,
                onChanged: (e) => onMark('actionsIconTheme.color ${e ?? 'null'}', () => actionsIconColor = e),
              ),
            ),
            buildSlider(
              label: 'actionsIcon.size',
              value: actionsIconSize,
              min: 16,
              max: 36,
              onChanged: (v) => onMark('actionsIcon.size ${v.toStringAsFixed(0)}', () => actionsIconSize = v),
            ),
          ],
          buildSwitch(
            title: 'toolbarTextStyle 自定义',
            value: useToolbarTextStyle,
            onChanged: (v) => onMark('toolbarTextStyle ${v ? 'on' : 'null'}', () => useToolbarTextStyle = v),
          ),
          if (useToolbarTextStyle)
            buildSlider(
              label: 'toolbarFontSize',
              value: toolbarFontSize,
              min: 10,
              max: 22,
              onChanged: (v) => onMark('toolbarFontSize ${v.toStringAsFixed(0)}', () => toolbarFontSize = v),
            ),
          buildSwitch(
            title: 'titleTextStyle 自定义',
            value: useTitleTextStyle,
            onChanged: (v) => onMark('titleTextStyle ${v ? 'on' : 'null'}', () => useTitleTextStyle = v),
          ),
          if (useTitleTextStyle)
            buildSlider(
              label: 'titleFontSize',
              value: titleFontSize,
              min: 12,
              max: 28,
              onChanged: (v) => onMark('titleFontSize ${v.toStringAsFixed(0)}', () => titleFontSize = v),
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
          buildSwitch(
            title: 'toolbarHeight 指定高度',
            value: useToolbarHeight,
            onChanged: (v) => onMark('toolbarHeight ${v ? 'on' : 'null'}', () => useToolbarHeight = v),
          ),
          if (useToolbarHeight)
            buildSlider(
              label: 'toolbarHeight',
              value: toolbarHeight,
              min: 40,
              max: 120,
              onChanged: (v) => onMark('toolbarHeight ${v.toStringAsFixed(0)}', () => toolbarHeight = v),
            ),
          buildSwitch(
            title: 'leadingWidth 指定宽度',
            value: useLeadingWidth,
            onChanged: (v) => onMark('leadingWidth ${v ? 'on' : 'null'}', () => useLeadingWidth = v),
          ),
          if (useLeadingWidth)
            buildSlider(
              label: 'leadingWidth',
              value: leadingWidth,
              min: 24,
              max: 120,
              onChanged: (v) => onMark('leadingWidth ${v.toStringAsFixed(0)}', () => leadingWidth = v),
            ),
          buildSwitch(
            title: 'titleSpacing 指定间距',
            value: useTitleSpacing,
            onChanged: (v) => onMark('titleSpacing ${v ? 'on' : 'null'}', () => useTitleSpacing = v),
          ),
          if (useTitleSpacing)
            buildSlider(
              label: 'titleSpacing',
              value: titleSpacing,
              min: 0,
              max: 72,
              onChanged: (v) => onMark('titleSpacing ${v.toStringAsFixed(0)}', () => titleSpacing = v),
            ),
          buildSlider(
            label: 'toolbarOpacity',
            value: toolbarOpacity,
            min: 0,
            max: 1,
            onChanged: (v) => onMark('toolbarOpacity ${v.toStringAsFixed(2)}', () => toolbarOpacity = v),
            fractionDigits: 2,
          ),
          if (bottomKind == _BottomKind.tabBar)
            buildSlider(
              label: 'bottomOpacity',
              value: bottomOpacity,
              min: 0,
              max: 1,
              onChanged: (v) => onMark('bottomOpacity ${v.toStringAsFixed(2)}', () => bottomOpacity = v),
              fractionDigits: 2,
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
    int fractionDigits = 0,
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
      valueBuilder: fractionDigits > 0
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
    clipKind = ClipKind.nil;
    lastTabIndex = 0;
    lastEvent = '—';
    if (tabController.index != 0) {
      tabController.animateTo(0);
    }
    setState(() {});
  }
}
