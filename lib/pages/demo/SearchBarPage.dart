//
//  SearchBarPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/8/31.
//  Copyright © 2026/8/31 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// SDK 搜索框构造
enum _SearchKind { searchBar, searchAnchor, searchAnchorBar, cupertino, showSearch }

/// SearchAnchor.builder 返回值
enum _AnchorBuilderKind { searchBar, icon }

/// SearchDelegate 输入框外观
enum _SearchFieldLook { none, style, decoration }

const _kWords = <String>['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape', 'Honeydew'];

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({
    super.key,
    this.title,
    this.arguments,
  });

  final String? title;
  final Map<String, dynamic>? arguments;

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final searchController = SearchController();
  final textController = TextEditingController();
  final focusNode = FocusNode();

  /// 最近事件
  String lastEvent = '—';
  /// 构造方式
  _SearchKind kind = _SearchKind.searchBar;
  /// SearchAnchor.builder
  _AnchorBuilderKind anchorBuilderKind = _AnchorBuilderKind.searchBar;
  /// 提示文案
  String? hintText = 'Search';
  /// 视图提示
  String? viewHintText;
  /// 是否启用
  bool enabled = true;
  /// 自动聚焦
  bool autoFocus = false;
  /// 是否传入 controller
  bool useController = true;
  /// 是否传入 focusNode
  bool useFocusNode = false;
  /// 是否传入 onTap
  bool useOnTap = true;
  /// 是否传入 onTapOutside
  bool useOnTapOutside = true;
  /// 是否传入 onChanged
  bool useOnChanged = true;
  /// 是否传入 onSubmitted
  bool useOnSubmitted = true;
  /// 是否传入 leading
  bool useLeading = true;
  /// 是否传入 trailing
  bool useTrailing = true;
  /// 是否传入 elevation
  bool useElevation = false;
  /// 海拔
  double elevation = 6;
  /// 是否传入 constraints
  bool useConstraints = true;
  /// 最小高度
  double minHeight = 56;
  /// 最大宽度
  double maxWidth = 800;
  /// 是否传入 padding
  bool usePadding = false;
  /// 水平内边距
  double paddingH = 16;
  /// 垂直内边距
  double paddingV = 0;
  /// 是否传入 side
  bool useSide = false;
  /// 描边宽度
  double sideWidth = 1;
  /// 描边色
  Color? sideColor;
  /// 形状
  ShapeKind shapeKind = ShapeKind.none;
  /// 圆角
  double shapeRadius = 28;
  /// 背景色
  Color? backgroundColor;
  /// 阴影色
  Color? shadowColor;
  /// 表面色调
  Color? surfaceTintColor;
  /// 水波纹色
  Color? overlayColor;
  /// 是否传入 textStyle
  bool useTextStyle = false;
  /// 字号
  double fontSize = 16;
  /// 文字色
  Color? textStyleColor;
  /// 是否传入 hintStyle
  bool useHintStyle = false;
  /// 提示色
  Color? hintStyleColor;
  /// 大小写
  TextCapitalization? textCapitalization;
  /// 键盘动作
  TextInputAction? textInputAction;
  /// 键盘类型
  TextInputType? keyboardType;
  /// 滚动内边距
  double scrollPaddingAll = 20;
  /// 是否传入系统菜单
  bool useContextMenuBuilder = true;
  /// 是否全屏
  bool? isFullScreen;
  /// 是否传入 viewBuilder
  bool useViewBuilder = false;
  /// 是否传入 viewLeading
  bool useViewLeading = false;
  /// 是否传入 viewTrailing
  bool useViewTrailing = false;
  /// 是否传入 viewConstraints
  bool useViewConstraints = true;
  /// 视图最大高度
  double viewMaxHeight = 280;
  /// 是否传入 headerHeight
  bool useHeaderHeight = false;
  /// 头部高度
  double headerHeight = 56;
  /// 是否传入 viewElevation
  bool useViewElevation = false;
  /// 视图海拔
  double viewElevation = 6;
  /// 视图背景
  Color? viewBackgroundColor;
  /// 视图色调
  Color? viewSurfaceTintColor;
  /// 分割线色
  Color? dividerColor;
  /// 视图描边
  bool useViewSide = false;
  /// 视图形状
  ShapeKind viewShapeKind = ShapeKind.none;
  /// 视图圆角
  double viewShapeRadius = 28;
  /// Cupertino 占位
  String? placeholder = 'Search';
  /// 图标色
  Color itemColor = CupertinoColors.secondaryLabel;
  /// 图标尺寸
  double itemSize = 20;
  /// 圆角
  double borderRadius = 9;
  /// 是否传入 decoration
  bool useDecoration = false;
  /// suffix 可见
  OverlayVisibilityMode suffixMode = OverlayVisibilityMode.editing;
  /// 是否传入 onSuffixTap
  bool useOnSuffixTap = false;
  /// 是否传入 restorationId
  bool useRestorationId = false;
  /// 智能引号
  SmartQuotesType? smartQuotesType;
  /// 智能破折号
  SmartDashesType? smartDashesType;
  /// IME 个性化
  bool enableIMEPersonalizedLearning = true;
  /// 自动纠正
  bool autocorrect = true;
  /// Cupertino enabled
  bool? cupertinoEnabled;
  /// 自定义 prefix
  bool usePrefixIcon = false;
  /// 自定义 suffix
  bool useSuffixIcon = false;
  /// prefix 起始内边距
  double prefixStart = 6;
  /// suffix 末尾内边距
  double suffixEnd = 5;
  /// 内边距垂直
  double cupertinoPadV = 8;
  /// showSearch 初始 query
  String query = '';
  /// 根导航
  bool useRootNavigator = false;
  /// 保活
  bool maintainState = false;
  /// 搜索框标签
  String? searchFieldLabel = 'Search';
  /// Delegate 外观
  _SearchFieldLook searchFieldLook = _SearchFieldLook.none;
  /// 联想
  bool enableSuggestions = true;

  bool get isSearchBar => kind == _SearchKind.searchBar;
  bool get isAnchor => kind == _SearchKind.searchAnchor;
  bool get isAnchorBar => kind == _SearchKind.searchAnchorBar;
  bool get isCupertino => kind == _SearchKind.cupertino;
  bool get isShowSearch => kind == _SearchKind.showSearch;
  bool get showBarSurface => isSearchBar || isAnchorBar || (isAnchor && anchorBuilderKind == _AnchorBuilderKind.searchBar);

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    textController.dispose();
    focusNode.dispose();
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
                        NLangEnum.en: 'SearchBar  SearchAnchor  CupertinoSearchTextField  showSearch',
                        NLangEnum.zh: 'SearchBar  SearchAnchor  CupertinoSearchTextField  showSearch',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'All Flutter SDK search fields: SearchBar, SearchAnchor / .bar, CupertinoSearchTextField, and showSearch + SearchDelegate.',
                          NLangEnum.zh: '覆盖 Flutter SDK 全部搜索框：SearchBar、SearchAnchor / .bar、CupertinoSearchTextField，以及 showSearch + SearchDelegate。',
                        },
                      ],
                    ),
                    buildKindCard(),
                    buildBehaviorCard(),
                    if (!isShowSearch) buildSurfaceCard(),
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
    final previewHeight = isShowSearch ? 168.0 : 132.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: previewHeight,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: buildPlayground(),
              ),
            ),
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
          ],
        ),
      ),
    );
  }

  Widget buildPlayground() {
    return switch (kind) {
      _SearchKind.searchBar => buildMaterialSearchBar(),
      _SearchKind.searchAnchor => buildSearchAnchor(),
      _SearchKind.searchAnchorBar => buildSearchAnchorBar(),
      _SearchKind.cupertino => buildCupertinoSearch(),
      _SearchKind.showSearch => buildShowSearchPreview(),
    };
  }

  Widget buildMaterialSearchBar() {
    return SearchBar(
      key: const ValueKey(_SearchKind.searchBar),
      controller: useController ? textController : null,
      focusNode: useFocusNode ? focusNode : null,
      hintText: hintText,
      leading: useLeading ? const Icon(Icons.search) : null,
      trailing: useTrailing
          ? [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () => onMark('trailing'),
              ),
            ]
          : null,
      onTap: useOnTap ? onTap : null,
      onTapOutside: useOnTapOutside ? onTapOutside : null,
      onChanged: useOnChanged ? onChanged : null,
      onSubmitted: useOnSubmitted ? onSubmitted : null,
      constraints: constraintsOf(),
      elevation: elevationProp(),
      backgroundColor: colorProp(backgroundColor),
      shadowColor: colorProp(shadowColor),
      surfaceTintColor: colorProp(surfaceTintColor),
      overlayColor: colorProp(overlayColor),
      side: sideProp(),
      shape: shapeProp(),
      padding: paddingProp(),
      textStyle: textStyleProp(),
      hintStyle: hintStyleProp(),
      textCapitalization: textCapitalization,
      enabled: enabled,
      autoFocus: autoFocus,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      scrollPadding: EdgeInsets.all(scrollPaddingAll),
      contextMenuBuilder: onContextMenu,
    );
  }

  Widget buildSearchAnchor() {
    return SearchAnchor(
      key: ValueKey(anchorBuilderKind),
      isFullScreen: isFullScreen,
      searchController: searchController,
      viewBuilder: useViewBuilder ? onViewBuilder : null,
      viewLeading: useViewLeading ? const Icon(Icons.arrow_back) : null,
      viewTrailing: useViewTrailing
          ? [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () => onMark('viewTrailing'),
              ),
            ]
          : null,
      viewHintText: viewHintText,
      viewBackgroundColor: viewBackgroundColor,
      viewElevation: useViewElevation ? viewElevation : null,
      viewSurfaceTintColor: viewSurfaceTintColor,
      viewSide: viewSideOf(),
      viewShape: viewShapeOf(),
      headerHeight: useHeaderHeight ? headerHeight : null,
      headerTextStyle: headerTextStyleOf(),
      headerHintStyle: headerHintStyleOf(),
      dividerColor: dividerColor,
      viewConstraints: viewConstraintsOf(),
      textCapitalization: textCapitalization,
      viewOnChanged: useOnChanged ? onChanged : null,
      viewOnSubmitted: useOnSubmitted ? onSubmitted : null,
      builder: onAnchorBuilder,
      suggestionsBuilder: onSuggestions,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      enabled: enabled,
    );
  }

  Widget buildSearchAnchorBar() {
    return SearchAnchor.bar(
      barLeading: useLeading ? const Icon(Icons.search) : null,
      barTrailing: useTrailing
          ? [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () => onMark('barTrailing'),
              ),
            ]
          : null,
      barHintText: hintText,
      onTap: useOnTap ? onTap : null,
      onSubmitted: useOnSubmitted ? onSubmitted : null,
      onChanged: useOnChanged ? onChanged : null,
      barElevation: elevationProp(),
      barBackgroundColor: colorProp(backgroundColor),
      barOverlayColor: colorProp(overlayColor),
      barSide: sideProp(),
      barShape: shapeProp(),
      barPadding: paddingProp(),
      barTextStyle: textStyleProp(),
      barHintStyle: hintStyleProp(),
      viewLeading: useViewLeading ? const Icon(Icons.arrow_back) : null,
      viewTrailing: useViewTrailing
          ? [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () => onMark('viewTrailing'),
              ),
            ]
          : null,
      viewHintText: viewHintText,
      viewBackgroundColor: viewBackgroundColor,
      viewElevation: useViewElevation ? viewElevation : null,
      viewSide: viewSideOf(),
      viewShape: viewShapeOf(),
      viewHeaderHeight: useHeaderHeight ? headerHeight : null,
      viewHeaderTextStyle: headerTextStyleOf(),
      viewHeaderHintStyle: headerHintStyleOf(),
      dividerColor: dividerColor,
      constraints: constraintsOf(),
      viewConstraints: viewConstraintsOf(),
      isFullScreen: isFullScreen,
      searchController: searchController,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      suggestionsBuilder: onSuggestions,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      scrollPadding: EdgeInsets.all(scrollPaddingAll),
      contextMenuBuilder: onContextMenu,
    );
  }

  Widget buildCupertinoSearch() {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: Brightness.light),
      child: CupertinoSearchTextField(
        key: const ValueKey(_SearchKind.cupertino),
        controller: useController ? textController : null,
        onChanged: useOnChanged ? onChanged : null,
        onSubmitted: useOnSubmitted ? onSubmitted : null,
        style: useTextStyle ? TextStyle(color: textStyleColor, fontSize: fontSize) : null,
        placeholder: placeholder,
        placeholderStyle: useHintStyle ? TextStyle(color: hintStyleColor) : null,
        decoration: useDecoration
            ? BoxDecoration(
                color: backgroundColor ?? CupertinoColors.tertiarySystemFill,
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : null,
        backgroundColor: useDecoration ? null : backgroundColor,
        borderRadius: useDecoration ? null : BorderRadius.circular(borderRadius),
        keyboardType: keyboardType ?? TextInputType.text,
        padding: EdgeInsetsDirectional.fromSTEB(5.5, cupertinoPadV, 5.5, cupertinoPadV),
        itemColor: itemColor,
        itemSize: itemSize,
        prefixInsets: EdgeInsetsDirectional.fromSTEB(prefixStart, 0, 0, 3),
        prefixIcon: usePrefixIcon ? const Icon(Icons.search) : const Icon(CupertinoIcons.search),
        suffixInsets: EdgeInsetsDirectional.fromSTEB(0, 0, suffixEnd, 2),
        suffixIcon: useSuffixIcon
            ? const Icon(Icons.cancel)
            : const Icon(CupertinoIcons.xmark_circle_fill),
        suffixMode: suffixMode,
        onSuffixTap: useOnSuffixTap ? onSuffixTap : null,
        restorationId: useRestorationId ? 'searchBarPage' : null,
        focusNode: useFocusNode ? focusNode : null,
        smartQuotesType: smartQuotesType,
        smartDashesType: smartDashesType,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        autofocus: autoFocus,
        onTap: useOnTap ? onTap : null,
        autocorrect: autocorrect,
        enabled: cupertinoEnabled,
      ),
    );
  }

  Widget buildShowSearchPreview() {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 148,
        child: Column(
          children: [
            AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              title: const Text('Home'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: onShowSearch,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: FilledButton.icon(
                  onPressed: onShowSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('showSearch'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKindCard() {
    return NDecorationCard(
      icon: const Icon(Icons.search),
      title: '样式',
      subtitle: 'SearchBar  SearchAnchor  SearchAnchor.bar  CupertinoSearchTextField  showSearch',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('构造'),
          buildChoiceChips(
            values: _SearchKind.values,
            value: kind,
            labelOf: nameOfKind,
            onChanged: (e) => onMark('kind ${nameOfKind(e)}', () => kind = e),
          ),
          if (isAnchor) ...[
            const Text('builder'),
            buildChoiceChips(
              values: _AnchorBuilderKind.values,
              value: anchorBuilderKind,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('builder ${e.name}', () => anchorBuilderKind = e),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'hintText  enabled  keyboard  callbacks  SearchDelegate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearchBar || isAnchorBar) ...[
            const Text('hintText'),
            buildChoiceChips(
              values: const [null, 'Search', '搜索', 'Hint'],
              value: hintText,
              labelOf: (e) => e ?? '默',
              onChanged: (e) => onMark('hintText ${e ?? 'null'}', () => hintText = e),
            ),
          ],
          if (isCupertino) ...[
            const Text('placeholder'),
            buildChoiceChips(
              values: const [null, 'Search', '搜索'],
              value: placeholder,
              labelOf: (e) => e ?? '默',
              onChanged: (e) => onMark('placeholder ${e ?? 'null'}', () => placeholder = e),
            ),
          ],
          if (isAnchor || isAnchorBar) ...[
            const Text('viewHintText'),
            buildChoiceChips(
              values: const [null, 'Search', '搜索'],
              value: viewHintText,
              labelOf: (e) => e ?? '默',
              onChanged: (e) => onMark('viewHintText ${e ?? 'null'}', () => viewHintText = e),
            ),
            const Text('isFullScreen'),
            buildChoiceChips(
              values: const [null, true, false],
              value: isFullScreen,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('isFullScreen ${e ?? 'null'}', () => isFullScreen = e),
            ),
            buildSwitch(
              title: 'viewBuilder',
              value: useViewBuilder,
              onChanged: (v) => onMark('viewBuilder ${v ? 'on' : 'null'}', () => useViewBuilder = v),
            ),
            buildSwitch(
              title: 'viewLeading',
              value: useViewLeading,
              onChanged: (v) => onMark('viewLeading ${v ? 'on' : 'null'}', () => useViewLeading = v),
            ),
            buildSwitch(
              title: 'viewTrailing',
              value: useViewTrailing,
              onChanged: (v) => onMark('viewTrailing ${v ? 'on' : 'null'}', () => useViewTrailing = v),
            ),
            buildSwitch(
              title: 'viewConstraints',
              value: useViewConstraints,
              onChanged: (v) => onMark('viewConstraints ${v ? 'on' : 'null'}', () => useViewConstraints = v),
            ),
            if (useViewConstraints)
              buildSlider(
                label: 'viewMaxHeight',
                value: viewMaxHeight,
                min: 120,
                max: 480,
                onChanged: (v) => onMark('viewMaxHeight ${v.round()}', () => viewMaxHeight = v),
              ),
            buildSwitch(
              title: 'headerHeight',
              value: useHeaderHeight,
              onChanged: (v) => onMark('headerHeight ${v ? 'on' : 'null'}', () => useHeaderHeight = v),
            ),
            if (useHeaderHeight)
              buildSlider(
                label: 'headerHeight',
                value: headerHeight,
                min: 40,
                max: 88,
                onChanged: (v) => onMark('headerHeight ${v.round()}', () => headerHeight = v),
              ),
          ],
          if (isSearchBar || isCupertino)
            buildSwitch(
              title: 'controller',
              value: useController,
              onChanged: (v) => onMark('controller ${v ? 'on' : 'null'}', () => useController = v),
            ),
          if (isSearchBar || isCupertino)
            buildSwitch(
              title: 'focusNode',
              value: useFocusNode,
              onChanged: (v) => onMark('focusNode ${v ? 'on' : 'null'}', () => useFocusNode = v),
            ),
          if (isSearchBar || isAnchorBar)
            buildSwitch(
              title: 'leading',
              value: useLeading,
              onChanged: (v) => onMark('leading ${v ? 'on' : 'null'}', () => useLeading = v),
            ),
          if (isSearchBar || isAnchorBar)
            buildSwitch(
              title: 'trailing',
              value: useTrailing,
              onChanged: (v) => onMark('trailing ${v ? 'on' : 'null'}', () => useTrailing = v),
            ),
          if (!isShowSearch)
            buildSwitch(
              title: 'onChanged',
              value: useOnChanged,
              onChanged: (v) => onMark('onChanged ${v ? 'on' : 'null'}', () => useOnChanged = v),
            ),
          if (!isShowSearch)
            buildSwitch(
              title: 'onSubmitted',
              value: useOnSubmitted,
              onChanged: (v) => onMark('onSubmitted ${v ? 'on' : 'null'}', () => useOnSubmitted = v),
            ),
          if (isSearchBar || isAnchorBar || isCupertino)
            buildSwitch(
              title: 'onTap',
              value: useOnTap,
              onChanged: (v) => onMark('onTap ${v ? 'on' : 'null'}', () => useOnTap = v),
            ),
          if (isSearchBar)
            buildSwitch(
              title: 'onTapOutside',
              value: useOnTapOutside,
              onChanged: (v) => onMark('onTapOutside ${v ? 'on' : 'null'}', () => useOnTapOutside = v),
            ),
          if (isSearchBar || isAnchor)
            buildSwitch(
              title: 'enabled',
              value: enabled,
              onChanged: (v) => onMark('enabled $v', () => enabled = v),
            ),
          if (isSearchBar || isCupertino)
            buildSwitch(
              title: isCupertino ? 'autofocus' : 'autoFocus',
              value: autoFocus,
              onChanged: (v) => onMark('autoFocus $v', () => autoFocus = v),
            ),
          if (!isShowSearch) ...[
            const Text('textCapitalization'),
            buildChoiceChips(
              values: [null, ...TextCapitalization.values],
              value: textCapitalization,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('textCapitalization ${e?.name ?? 'null'}', () => textCapitalization = e),
            ),
            const Text('textInputAction'),
            buildChoiceChips(
              values: const [null, TextInputAction.search, TextInputAction.done, TextInputAction.next, TextInputAction.go],
              value: textInputAction,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('textInputAction ${e?.name ?? 'null'}', () => textInputAction = e),
            ),
            const Text('keyboardType'),
            buildChoiceChips(
              values: const [null, TextInputType.text, TextInputType.number, TextInputType.emailAddress, TextInputType.url, TextInputType.phone],
              value: keyboardType,
              labelOf: nameOfKeyboard,
              onChanged: (e) => onMark('keyboardType ${nameOfKeyboard(e)}', () => keyboardType = e),
            ),
          ],
          if (isSearchBar || isAnchorBar)
            buildSlider(
              label: 'scrollPadding',
              value: scrollPaddingAll,
              min: 0,
              max: 40,
              onChanged: (v) => onMark('scrollPadding ${v.round()}', () => scrollPaddingAll = v),
            ),
          if (isSearchBar || isAnchorBar)
            buildSwitch(
              title: 'contextMenuBuilder',
              value: useContextMenuBuilder,
              onChanged: (v) => onMark('contextMenuBuilder ${v ? 'on' : 'off'}', () => useContextMenuBuilder = v),
            ),
          if (isCupertino) ...[
            const Text('suffixMode'),
            buildChoiceChips(
              values: OverlayVisibilityMode.values,
              value: suffixMode,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('suffixMode ${e.name}', () => suffixMode = e),
            ),
            buildSwitch(
              title: 'onSuffixTap',
              value: useOnSuffixTap,
              onChanged: (v) => onMark('onSuffixTap ${v ? 'on' : 'null'}', () => useOnSuffixTap = v),
            ),
            buildSwitch(
              title: 'prefixIcon',
              value: usePrefixIcon,
              onChanged: (v) => onMark('prefixIcon ${v ? 'Icons.search' : 'default'}', () => usePrefixIcon = v),
            ),
            buildSwitch(
              title: 'suffixIcon',
              value: useSuffixIcon,
              onChanged: (v) => onMark('suffixIcon ${v ? 'Icons.cancel' : 'default'}', () => useSuffixIcon = v),
            ),
            buildSwitch(
              title: 'restorationId',
              value: useRestorationId,
              onChanged: (v) => onMark('restorationId ${v ? 'on' : 'null'}', () => useRestorationId = v),
            ),
            const Text('smartQuotesType'),
            buildChoiceChips(
              values: [null, ...SmartQuotesType.values],
              value: smartQuotesType,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('smartQuotesType ${e?.name ?? 'null'}', () => smartQuotesType = e),
            ),
            const Text('smartDashesType'),
            buildChoiceChips(
              values: [null, ...SmartDashesType.values],
              value: smartDashesType,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('smartDashesType ${e?.name ?? 'null'}', () => smartDashesType = e),
            ),
            buildSwitch(
              title: 'enableIMEPersonalizedLearning',
              value: enableIMEPersonalizedLearning,
              onChanged: (v) => onMark('enableIMEPersonalizedLearning $v', () => enableIMEPersonalizedLearning = v),
            ),
            buildSwitch(
              title: 'autocorrect',
              value: autocorrect,
              onChanged: (v) => onMark('autocorrect $v', () => autocorrect = v),
            ),
            const Text('enabled'),
            buildChoiceChips(
              values: const [null, true, false],
              value: cupertinoEnabled,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('enabled ${e ?? 'null'}', () => cupertinoEnabled = e),
            ),
            buildSlider(
              label: 'prefixInsets',
              value: prefixStart,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('prefixInsets ${v.round()}', () => prefixStart = v),
            ),
            buildSlider(
              label: 'suffixInsets',
              value: suffixEnd,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('suffixInsets ${v.round()}', () => suffixEnd = v),
            ),
            buildSlider(
              label: 'padding',
              value: cupertinoPadV,
              min: 0,
              max: 16,
              onChanged: (v) => onMark('padding ${v.round()}', () => cupertinoPadV = v),
            ),
          ],
          if (isShowSearch) ...[
            const Text('query'),
            buildChoiceChips(
              values: const ['', 'Apple', '搜索'],
              value: query,
              labelOf: (e) => e.isEmpty ? "''" : e,
              onChanged: (e) => onMark('query $e', () => query = e),
            ),
            buildSwitch(
              title: 'useRootNavigator',
              value: useRootNavigator,
              onChanged: (v) => onMark('useRootNavigator $v', () => useRootNavigator = v),
            ),
            buildSwitch(
              title: 'maintainState',
              value: maintainState,
              onChanged: (v) => onMark('maintainState $v', () => maintainState = v),
            ),
            const Text('searchFieldLabel'),
            buildChoiceChips(
              values: const [null, 'Search', '搜索'],
              value: searchFieldLabel,
              labelOf: (e) => e ?? '默',
              onChanged: (e) => onMark('searchFieldLabel ${e ?? 'null'}', () => searchFieldLabel = e),
            ),
            const Text('searchFieldLook'),
            buildChoiceChips(
              values: _SearchFieldLook.values,
              value: searchFieldLook,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('searchFieldLook ${e.name}', () => searchFieldLook = e),
            ),
            const Text('keyboardType'),
            buildChoiceChips(
              values: const [null, TextInputType.text, TextInputType.number, TextInputType.emailAddress],
              value: keyboardType,
              labelOf: nameOfKeyboard,
              onChanged: (e) => onMark('keyboardType ${nameOfKeyboard(e)}', () => keyboardType = e),
            ),
            const Text('textInputAction'),
            buildChoiceChips(
              values: const [TextInputAction.search, TextInputAction.done, TextInputAction.go],
              value: textInputAction ?? TextInputAction.search,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('textInputAction ${e.name}', () => textInputAction = e),
            ),
            buildSwitch(
              title: 'autocorrect',
              value: autocorrect,
              onChanged: (v) => onMark('autocorrect $v', () => autocorrect = v),
            ),
            buildSwitch(
              title: 'enableSuggestions',
              value: enableSuggestions,
              onChanged: (v) => onMark('enableSuggestions $v', () => enableSuggestions = v),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: '表面',
      subtitle: 'elevation  color  shape  padding  constraints  viewShape',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBarSurface) ...[
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
            buildSwitch(
              title: 'constraints',
              value: useConstraints,
              onChanged: (v) => onMark('constraints ${v ? 'on' : 'null'}', () => useConstraints = v),
            ),
            if (useConstraints) ...[
              buildSlider(
                label: 'minHeight',
                value: minHeight,
                min: 40,
                max: 80,
                onChanged: (v) => onMark('minHeight ${v.round()}', () => minHeight = v),
              ),
              buildSlider(
                label: 'maxWidth',
                value: maxWidth,
                min: 200,
                max: 800,
                onChanged: (v) => onMark('maxWidth ${v.round()}', () => maxWidth = v),
              ),
            ],
            buildSwitch(
              title: 'padding',
              value: usePadding,
              onChanged: (v) => onMark('padding ${v ? 'on' : 'null'}', () => usePadding = v),
            ),
            if (usePadding) ...[
              buildSlider(
                label: 'paddingH',
                value: paddingH,
                min: 0,
                max: 32,
                onChanged: (v) => onMark('paddingH ${v.round()}', () => paddingH = v),
              ),
              buildSlider(
                label: 'paddingV',
                value: paddingV,
                min: 0,
                max: 16,
                onChanged: (v) => onMark('paddingV ${v.round()}', () => paddingV = v),
              ),
            ],
            const Text('shape'),
            buildChoiceChips(
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('shape ${e.name}', () => shapeKind = e),
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
              title: 'side',
              value: useSide,
              onChanged: (v) => onMark('side ${v ? 'on' : 'null'}', () => useSide = v),
            ),
            if (useSide) ...[
              buildSlider(
                label: 'sideWidth',
                value: sideWidth,
                min: 0.5,
                max: 4,
                onChanged: (v) => onMark('sideWidth ${v.toStringAsFixed(1)}', () => sideWidth = v),
              ),
              buildColorRow('sideColor', sideColor, (v) => onMark('sideColor ${v ?? 'null'}', () => sideColor = v)),
            ],
            buildColorRow('backgroundColor', backgroundColor, (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v)),
            if (isSearchBar)
              buildColorRow('shadowColor', shadowColor, (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v)),
            if (isSearchBar)
              buildColorRow('surfaceTintColor', surfaceTintColor, (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v)),
            buildColorRow('overlayColor', overlayColor, (v) => onMark('overlayColor ${v ?? 'null'}', () => overlayColor = v)),
            buildSwitch(
              title: 'textStyle',
              value: useTextStyle,
              onChanged: (v) => onMark('textStyle ${v ? 'on' : 'null'}', () => useTextStyle = v),
            ),
            if (useTextStyle) ...[
              buildSlider(
                label: 'fontSize',
                value: fontSize,
                min: 12,
                max: 22,
                onChanged: (v) => onMark('fontSize ${v.round()}', () => fontSize = v),
              ),
              buildColorRow('textStyle.color', textStyleColor, (v) => onMark('textStyle.color ${v ?? 'null'}', () => textStyleColor = v)),
            ],
            buildSwitch(
              title: 'hintStyle',
              value: useHintStyle,
              onChanged: (v) => onMark('hintStyle ${v ? 'on' : 'null'}', () => useHintStyle = v),
            ),
            if (useHintStyle)
              buildColorRow('hintStyle.color', hintStyleColor, (v) => onMark('hintStyle.color ${v ?? 'null'}', () => hintStyleColor = v)),
          ],
          if (isAnchor || isAnchorBar) ...[
            buildSwitch(
              title: 'viewElevation',
              value: useViewElevation,
              onChanged: (v) => onMark('viewElevation ${v ? 'on' : 'null'}', () => useViewElevation = v),
            ),
            if (useViewElevation)
              buildSlider(
                label: 'viewElevation',
                value: viewElevation,
                min: 0,
                max: 16,
                onChanged: (v) => onMark('viewElevation ${v.toStringAsFixed(1)}', () => viewElevation = v),
              ),
            buildColorRow('viewBackgroundColor', viewBackgroundColor, (v) => onMark('viewBackgroundColor ${v ?? 'null'}', () => viewBackgroundColor = v)),
            if (isAnchor)
              buildColorRow('viewSurfaceTintColor', viewSurfaceTintColor, (v) => onMark('viewSurfaceTintColor ${v ?? 'null'}', () => viewSurfaceTintColor = v)),
            buildColorRow('dividerColor', dividerColor, (v) => onMark('dividerColor ${v ?? 'null'}', () => dividerColor = v)),
            const Text('viewShape'),
            buildChoiceChips(
              values: ShapeKind.values,
              value: viewShapeKind,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('viewShape ${e.name}', () => viewShapeKind = e),
            ),
            if (viewShapeKind == ShapeKind.rounded)
              buildSlider(
                label: 'viewShapeRadius',
                value: viewShapeRadius,
                min: 0,
                max: 32,
                onChanged: (v) => onMark('viewShapeRadius ${v.round()}', () => viewShapeRadius = v),
              ),
            buildSwitch(
              title: 'viewSide',
              value: useViewSide,
              onChanged: (v) => onMark('viewSide ${v ? 'on' : 'null'}', () => useViewSide = v),
            ),
          ],
          if (isCupertino) ...[
            buildSwitch(
              title: 'decoration',
              value: useDecoration,
              onChanged: (v) => onMark('decoration ${v ? 'on' : 'null'}', () => useDecoration = v),
            ),
            buildSlider(
              label: 'borderRadius',
              value: borderRadius,
              min: 0,
              max: 24,
              onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
            ),
            buildSlider(
              label: 'itemSize',
              value: itemSize,
              min: 12,
              max: 32,
              onChanged: (v) => onMark('itemSize ${v.round()}', () => itemSize = v),
            ),
            buildColorRow('backgroundColor', backgroundColor, (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v)),
            buildColorRow('itemColor', itemColor, (v) => onMark('itemColor ${v ?? 'null'}', () => itemColor = v ?? CupertinoColors.secondaryLabel)),
            buildSwitch(
              title: 'style',
              value: useTextStyle,
              onChanged: (v) => onMark('style ${v ? 'on' : 'null'}', () => useTextStyle = v),
            ),
            if (useTextStyle) ...[
              buildSlider(
                label: 'fontSize',
                value: fontSize,
                min: 12,
                max: 22,
                onChanged: (v) => onMark('fontSize ${v.round()}', () => fontSize = v),
              ),
              buildColorRow('style.color', textStyleColor, (v) => onMark('style.color ${v ?? 'null'}', () => textStyleColor = v)),
            ],
            buildSwitch(
              title: 'placeholderStyle',
              value: useHintStyle,
              onChanged: (v) => onMark('placeholderStyle ${v ? 'on' : 'null'}', () => useHintStyle = v),
            ),
            if (useHintStyle)
              buildColorRow('placeholderStyle', hintStyleColor, (v) => onMark('placeholderStyle ${v ?? 'null'}', () => hintStyleColor = v)),
          ],
        ],
      ),
    );
  }

  Widget onAnchorBuilder(BuildContext context, SearchController controller) {
    return switch (anchorBuilderKind) {
      _AnchorBuilderKind.icon => IconButton(
          icon: const Icon(Icons.search),
          onPressed: controller.openView,
        ),
      _AnchorBuilderKind.searchBar => SearchBar(
          controller: controller,
          hintText: hintText,
          leading: useLeading ? const Icon(Icons.search) : null,
          trailing: useTrailing
              ? [
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () => onMark('trailing'),
                  ),
                ]
              : null,
          onTap: controller.openView,
          elevation: elevationProp(),
          backgroundColor: colorProp(backgroundColor),
          overlayColor: colorProp(overlayColor),
          side: sideProp(),
          shape: shapeProp(),
          padding: paddingProp(),
          textStyle: textStyleProp(),
          hintStyle: hintStyleProp(),
          enabled: enabled,
        ),
    };
  }

  Iterable<Widget> onSuggestions(BuildContext context, SearchController controller) {
    final q = controller.text.toLowerCase();
    return _kWords.where((e) => e.toLowerCase().contains(q)).map((e) {
      return ListTile(
        title: Text(e),
        onTap: () {
          controller.closeView(e);
          onMark('suggestion $e');
        },
      );
    });
  }

  Widget onViewBuilder(Iterable<Widget> suggestions) {
    return ListView(children: [...suggestions]);
  }

  Widget onContextMenu(BuildContext context, EditableTextState state) {
    if (!useContextMenuBuilder) {
      return const SizedBox.shrink();
    }
    return AdaptiveTextSelectionToolbar.editableText(editableTextState: state);
  }

  BoxConstraints? constraintsOf() {
    if (!useConstraints) {
      return null;
    }
    return BoxConstraints(minWidth: 0, minHeight: minHeight, maxWidth: maxWidth);
  }

  BoxConstraints? viewConstraintsOf() {
    if (!useViewConstraints) {
      return null;
    }
    return BoxConstraints.loose(Size.fromHeight(viewMaxHeight));
  }

  WidgetStateProperty<double?>? elevationProp() {
    return useElevation ? WidgetStatePropertyAll(elevation) : null;
  }

  WidgetStateProperty<Color?>? colorProp(Color? color) {
    return color == null ? null : WidgetStatePropertyAll(color);
  }

  WidgetStateProperty<BorderSide?>? sideProp() {
    if (!useSide) {
      return null;
    }
    return WidgetStatePropertyAll(BorderSide(color: sideColor ?? Colors.blue, width: sideWidth));
  }

  WidgetStateProperty<OutlinedBorder?>? shapeProp() {
    final shape = outlinedOf(shapeKind, shapeRadius);
    return shape == null ? null : WidgetStatePropertyAll(shape);
  }

  WidgetStateProperty<EdgeInsetsGeometry?>? paddingProp() {
    if (!usePadding) {
      return null;
    }
    return WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV));
  }

  WidgetStateProperty<TextStyle?>? textStyleProp() {
    if (!useTextStyle) {
      return null;
    }
    return WidgetStatePropertyAll(TextStyle(color: textStyleColor, fontSize: fontSize));
  }

  WidgetStateProperty<TextStyle?>? hintStyleProp() {
    if (!useHintStyle) {
      return null;
    }
    return WidgetStatePropertyAll(TextStyle(color: hintStyleColor));
  }

  TextStyle? headerTextStyleOf() {
    if (!useTextStyle) {
      return null;
    }
    return TextStyle(color: textStyleColor, fontSize: fontSize);
  }

  TextStyle? headerHintStyleOf() {
    if (!useHintStyle) {
      return null;
    }
    return TextStyle(color: hintStyleColor);
  }

  BorderSide? viewSideOf() {
    if (!useViewSide) {
      return null;
    }
    return BorderSide(color: sideColor ?? Colors.blue, width: sideWidth);
  }

  OutlinedBorder? viewShapeOf() {
    return outlinedOf(viewShapeKind, viewShapeRadius);
  }

  OutlinedBorder? outlinedOf(ShapeKind kind, double radius) {
    return switch (kind) {
      ShapeKind.none => null,
      ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ShapeKind.stadium => const StadiumBorder(),
    };
  }

  String nameOfKind(_SearchKind value) {
    return switch (value) {
      _SearchKind.searchBar => 'SearchBar',
      _SearchKind.searchAnchor => 'SearchAnchor',
      _SearchKind.searchAnchorBar => 'SearchAnchor.bar',
      _SearchKind.cupertino => 'Cupertino',
      _SearchKind.showSearch => 'showSearch',
    };
  }

  String nameOfKeyboard(TextInputType? value) {
    if (value == null) {
      return '默';
    }
    if (value == TextInputType.text) {
      return 'text';
    }
    if (value == TextInputType.number) {
      return 'number';
    }
    if (value == TextInputType.emailAddress) {
      return 'email';
    }
    if (value == TextInputType.url) {
      return 'url';
    }
    if (value == TextInputType.phone) {
      return 'phone';
    }
    return '$value';
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
    DLog.d(event);
    setState(() {});
  }

  void onTap() {
    onMark('onTap');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('onTap'), duration: Duration(milliseconds: 800)),
    );
  }

  void onTapOutside(PointerDownEvent event) {
    onMark('onTapOutside');
  }

  void onChanged(String value) {
    onMark('onChanged $value');
  }

  void onSubmitted(String value) {
    onMark('onSubmitted $value');
  }

  void onSuffixTap() {
    textController.clear();
    onMark('onSuffixTap');
  }

  Future<void> onShowSearch() async {
    final result = await showSearch<String>(
      context: context,
      query: query,
      useRootNavigator: useRootNavigator,
      maintainState: maintainState,
      delegate: _DemoSearchDelegate(
        words: _kWords,
        searchFieldLabel: searchFieldLabel,
        searchFieldStyle: searchFieldLook == _SearchFieldLook.style
            ? TextStyle(color: textStyleColor ?? Colors.white, fontSize: fontSize)
            : null,
        searchFieldDecorationTheme: searchFieldLook == _SearchFieldLook.decoration
            ? const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white24,
                border: InputBorder.none,
              )
            : null,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.search,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
      ),
    );
    onMark('showSearch ${result ?? 'null'}');
  }

  void onReset() {
    lastEvent = '—';
    kind = _SearchKind.searchBar;
    anchorBuilderKind = _AnchorBuilderKind.searchBar;
    hintText = 'Search';
    viewHintText = null;
    enabled = true;
    autoFocus = false;
    useController = true;
    useFocusNode = false;
    useOnTap = true;
    useOnTapOutside = true;
    useOnChanged = true;
    useOnSubmitted = true;
    useLeading = true;
    useTrailing = true;
    useElevation = false;
    elevation = 6;
    useConstraints = true;
    minHeight = 56;
    maxWidth = 800;
    usePadding = false;
    paddingH = 16;
    paddingV = 0;
    useSide = false;
    sideWidth = 1;
    sideColor = null;
    shapeKind = ShapeKind.none;
    shapeRadius = 28;
    backgroundColor = null;
    shadowColor = null;
    surfaceTintColor = null;
    overlayColor = null;
    useTextStyle = false;
    fontSize = 16;
    textStyleColor = null;
    useHintStyle = false;
    hintStyleColor = null;
    textCapitalization = null;
    textInputAction = null;
    keyboardType = null;
    scrollPaddingAll = 20;
    useContextMenuBuilder = true;
    isFullScreen = null;
    useViewBuilder = false;
    useViewLeading = false;
    useViewTrailing = false;
    useViewConstraints = true;
    viewMaxHeight = 280;
    useHeaderHeight = false;
    headerHeight = 56;
    useViewElevation = false;
    viewElevation = 6;
    viewBackgroundColor = null;
    viewSurfaceTintColor = null;
    dividerColor = null;
    useViewSide = false;
    viewShapeKind = ShapeKind.none;
    viewShapeRadius = 28;
    placeholder = 'Search';
    itemColor = CupertinoColors.secondaryLabel;
    itemSize = 20;
    borderRadius = 9;
    useDecoration = false;
    suffixMode = OverlayVisibilityMode.editing;
    useOnSuffixTap = false;
    useRestorationId = false;
    smartQuotesType = null;
    smartDashesType = null;
    enableIMEPersonalizedLearning = true;
    autocorrect = true;
    cupertinoEnabled = null;
    usePrefixIcon = false;
    useSuffixIcon = false;
    prefixStart = 6;
    suffixEnd = 5;
    cupertinoPadV = 8;
    query = '';
    useRootNavigator = false;
    maintainState = false;
    searchFieldLabel = 'Search';
    searchFieldLook = _SearchFieldLook.none;
    enableSuggestions = true;
    textController.clear();
    searchController.clear();
    setState(() {});
  }
}

class _DemoSearchDelegate extends SearchDelegate<String> {
  _DemoSearchDelegate({
    required this.words,
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    super.autocorrect,
    super.enableSuggestions,
  });

  final List<String> words;

  List<String> get hits {
    final q = query.toLowerCase();
    return words.where((e) => e.toLowerCase().contains(q)).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildHits(context, closeOnTap: true);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildHits(context, closeOnTap: false);
  }

  Widget buildHits(BuildContext context, {required bool closeOnTap}) {
    final items = hits;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final e = items[i];
        return ListTile(
          title: Text(e),
          onTap: () {
            query = e;
            if (closeOnTap) {
              close(context, e);
              return;
            }
            showResults(context);
          },
        );
      },
    );
  }
}
