//
//  SearchBarPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/8/31.
//  Copyright © 2026/8/31 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// SDK 搜索框构造
enum _SearchKind {
  searchBar(label: 'SearchBar'),
  searchAnchor(label: 'SearchAnchor'),
  searchAnchorBar(label: 'SearchAnchor.bar'),
  cupertino(label: 'Cupertino'),
  showSearch(label: 'showSearch');
  const _SearchKind({required this.label});
  final String label;
}

/// SearchAnchor.builder 返回值
enum _AnchorBuilderKind {
  searchBar(label: 'searchBar'),
  icon(label: 'icon');
  const _AnchorBuilderKind({required this.label});
  final String label;
}

/// SearchDelegate 输入框外观
enum _SearchFieldLook {
  none(label: 'none'),
  style(label: 'style'),
  decoration(label: 'decoration');
  const _SearchFieldLook({required this.label});
  final String label;
}

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
  late final theme = Theme.of(context);

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
  bool get showBarSurface =>
      isSearchBar || isAnchorBar || (isAnchor && anchorBuilderKind == _AnchorBuilderKind.searchBar);

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
                              'SearchBar, SearchAnchor / .bar, CupertinoSearchTextField, showSearch + SearchDelegate.',
                          NLangEnum.zh:
                              '覆盖 Flutter SDK 全部搜索框：SearchBar、SearchAnchor / .bar、CupertinoSearchTextField、showSearch + SearchDelegate。',
                        },
                      ],
                    ),
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
      trailing: useTrailing ? micButtons('trailing') : null,
      onTap: useOnTap ? onTap : null,
      onTapOutside: useOnTapOutside ? (_) => onMark('onTapOutside') : null,
      onChanged: useOnChanged ? (v) => onMark('onChanged $v') : null,
      onSubmitted: useOnSubmitted ? (v) => onMark('onSubmitted $v') : null,
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
      viewTrailing: useViewTrailing ? micButtons('viewTrailing') : null,
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
      viewOnChanged: useOnChanged ? (v) => onMark('onChanged $v') : null,
      viewOnSubmitted: useOnSubmitted ? (v) => onMark('onSubmitted $v') : null,
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
      barTrailing: useTrailing ? micButtons('barTrailing') : null,
      barHintText: hintText,
      onTap: useOnTap ? onTap : null,
      onSubmitted: useOnSubmitted ? (v) => onMark('onSubmitted $v') : null,
      onChanged: useOnChanged ? (v) => onMark('onChanged $v') : null,
      barElevation: elevationProp(),
      barBackgroundColor: colorProp(backgroundColor),
      barOverlayColor: colorProp(overlayColor),
      barSide: sideProp(),
      barShape: shapeProp(),
      barPadding: paddingProp(),
      barTextStyle: textStyleProp(),
      barHintStyle: hintStyleProp(),
      viewLeading: useViewLeading ? const Icon(Icons.arrow_back) : null,
      viewTrailing: useViewTrailing ? micButtons('viewTrailing') : null,
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
        onChanged: useOnChanged ? (v) => onMark('onChanged $v') : null,
        onSubmitted: useOnSubmitted ? (v) => onMark('onSubmitted $v') : null,
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
        suffixIcon: useSuffixIcon ? const Icon(Icons.cancel) : const Icon(CupertinoIcons.xmark_circle_fill),
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
    final scheme = theme.colorScheme;
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

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: '构造  hintText  enabled  keyboard  callbacks  SearchDelegate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem(
            title: const Text('构造'),
            values: _SearchKind.values,
            value: kind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('kind ${e.label}', () => kind = e),
          ),
          if (isAnchor) ...[
            NChoiceChipListItem(
              title: const Text('builder'),
              values: _AnchorBuilderKind.values,
              value: anchorBuilderKind,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('builder ${e.label}', () => anchorBuilderKind = e),
            ),
          ],
          if (isSearchBar || isAnchorBar)
            buildStringChips('hintText', hintText, const [null, 'Search', '搜索', 'Hint'], (e) => hintText = e),
          if (isCupertino)
            buildStringChips('placeholder', placeholder, const [null, 'Search', '搜索'], (e) => placeholder = e),
          if (isAnchor || isAnchorBar) ...[
            buildStringChips('viewHintText', viewHintText, const [null, 'Search', '搜索'], (e) => viewHintText = e),
            NChoiceChipListItem(
              title: const Text('isFullScreen'),
              values: const [null, true, false],
              value: isFullScreen,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('isFullScreen ${e ?? 'null'}', () => isFullScreen = e),
            ),
            NSwitchListItem(
              title: const Text('viewBuilder'),
              value: useViewBuilder,
              onChanged: (v) => onMark('viewBuilder ${v ? 'on' : 'null'}', () => useViewBuilder = v),
            ),
            NSwitchListItem(
              title: const Text('viewLeading'),
              value: useViewLeading,
              onChanged: (v) => onMark('viewLeading ${v ? 'on' : 'null'}', () => useViewLeading = v),
            ),
            NSwitchListItem(
              title: const Text('viewTrailing'),
              value: useViewTrailing,
              onChanged: (v) => onMark('viewTrailing ${v ? 'on' : 'null'}', () => useViewTrailing = v),
            ),
            NSwitchListItem(
              title: const Text('viewConstraints'),
              value: useViewConstraints,
              onChanged: (v) => onMark('viewConstraints ${v ? 'on' : 'null'}', () => useViewConstraints = v),
            ),
            if (useViewConstraints)
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('viewMaxHeight'),
                min: 120,
                max: 480,
                value: viewMaxHeight.clamp(120, 480),
                onChanged: (v) => onMark('viewMaxHeight ${v.round()}', () => viewMaxHeight = v),
                activeColor: theme.colorScheme.primary,
              ),
            NSwitchListItem(
              title: const Text('headerHeight'),
              value: useHeaderHeight,
              onChanged: (v) => onMark('headerHeight ${v ? 'on' : 'null'}', () => useHeaderHeight = v),
            ),
            if (useHeaderHeight)
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('headerHeight'),
                min: 40,
                max: 88,
                value: headerHeight.clamp(40, 88),
                onChanged: (v) => onMark('headerHeight ${v.round()}', () => headerHeight = v),
                activeColor: theme.colorScheme.primary,
              ),
          ],
          if (isSearchBar || isCupertino) ...[
            NSwitchListItem(
              title: const Text('controller'),
              value: useController,
              onChanged: (v) => onMark('controller ${v ? 'on' : 'null'}', () => useController = v),
            ),
            NSwitchListItem(
              title: const Text('focusNode'),
              value: useFocusNode,
              onChanged: (v) => onMark('focusNode ${v ? 'on' : 'null'}', () => useFocusNode = v),
            ),
          ],
          if (isSearchBar || isAnchorBar) ...[
            NSwitchListItem(
              title: const Text('leading'),
              value: useLeading,
              onChanged: (v) => onMark('leading ${v ? 'on' : 'null'}', () => useLeading = v),
            ),
            NSwitchListItem(
              title: const Text('trailing'),
              value: useTrailing,
              onChanged: (v) => onMark('trailing ${v ? 'on' : 'null'}', () => useTrailing = v),
            ),
          ],
          if (!isShowSearch) ...[
            NSwitchListItem(
              title: const Text('onChanged'),
              value: useOnChanged,
              onChanged: (v) => onMark('onChanged ${v ? 'on' : 'null'}', () => useOnChanged = v),
            ),
            NSwitchListItem(
              title: const Text('onSubmitted'),
              value: useOnSubmitted,
              onChanged: (v) => onMark('onSubmitted ${v ? 'on' : 'null'}', () => useOnSubmitted = v),
            ),
          ],
          if (isSearchBar || isAnchorBar || isCupertino)
            NSwitchListItem(
              title: const Text('onTap'),
              value: useOnTap,
              onChanged: (v) => onMark('onTap ${v ? 'on' : 'null'}', () => useOnTap = v),
            ),
          if (isSearchBar)
            NSwitchListItem(
              title: const Text('onTapOutside'),
              value: useOnTapOutside,
              onChanged: (v) => onMark('onTapOutside ${v ? 'on' : 'null'}', () => useOnTapOutside = v),
            ),
          if (isSearchBar || isAnchor)
            NSwitchListItem(
              title: const Text('enabled'),
              value: enabled,
              onChanged: (v) => onMark('enabled $v', () => enabled = v),
            ),
          if (isSearchBar || isCupertino)
            NSwitchListItem(
              title: Text(isCupertino ? 'autofocus' : 'autoFocus'),
              value: autoFocus,
              onChanged: (v) => onMark('autoFocus $v', () => autoFocus = v),
            ),
          if (!isShowSearch) ...[
            NChoiceChipListItem(
              title: const Text('textCapitalization'),
              values: [null, ...TextCapitalization.values],
              value: textCapitalization,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('textCapitalization ${e?.name ?? 'null'}', () => textCapitalization = e),
            ),
          ],
          NChoiceChipListItem(
            title: const Text('textInputAction'),
            values: isShowSearch
                ? const <TextInputAction?>[TextInputAction.search, TextInputAction.done, TextInputAction.go]
                : const <TextInputAction?>[
                    null,
                    TextInputAction.search,
                    TextInputAction.done,
                    TextInputAction.next,
                    TextInputAction.go
                  ],
            value: isShowSearch ? (textInputAction ?? TextInputAction.search) : textInputAction,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('textInputAction ${e?.name ?? 'null'}', () => textInputAction = e),
          ),
          NChoiceChipListItem(
            title: const Text('keyboardType'),
            values: isShowSearch
                ? const [null, TextInputType.text, TextInputType.number, TextInputType.emailAddress]
                : const [
                    null,
                    TextInputType.text,
                    TextInputType.number,
                    TextInputType.emailAddress,
                    TextInputType.url,
                    TextInputType.phone
                  ],
            value: keyboardType,
            labelOf: nameOfKeyboard,
            onChanged: (e) => onMark('keyboardType ${nameOfKeyboard(e)}', () => keyboardType = e),
          ),
          if (isSearchBar || isAnchorBar) ...[
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('scrollPadding'),
              min: 0,
              max: 40,
              value: scrollPaddingAll.clamp(0, 40),
              onChanged: (v) => onMark('scrollPadding ${v.round()}', () => scrollPaddingAll = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSwitchListItem(
              title: const Text('contextMenuBuilder'),
              value: useContextMenuBuilder,
              onChanged: (v) => onMark('contextMenuBuilder ${v ? 'on' : 'off'}', () => useContextMenuBuilder = v),
            ),
          ],
          if (isCupertino) ...[
            NChoiceChipListItem(
              title: const Text('suffixMode'),
              values: OverlayVisibilityMode.values,
              value: suffixMode,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('suffixMode ${e.name}', () => suffixMode = e),
            ),
            NSwitchListItem(
              title: const Text('onSuffixTap'),
              value: useOnSuffixTap,
              onChanged: (v) => onMark('onSuffixTap ${v ? 'on' : 'null'}', () => useOnSuffixTap = v),
            ),
            NSwitchListItem(
              title: const Text('prefixIcon'),
              value: usePrefixIcon,
              onChanged: (v) => onMark('prefixIcon ${v ? 'Icons.search' : 'default'}', () => usePrefixIcon = v),
            ),
            NSwitchListItem(
              title: const Text('suffixIcon'),
              value: useSuffixIcon,
              onChanged: (v) => onMark('suffixIcon ${v ? 'Icons.cancel' : 'default'}', () => useSuffixIcon = v),
            ),
            NSwitchListItem(
              title: const Text('restorationId'),
              value: useRestorationId,
              onChanged: (v) => onMark('restorationId ${v ? 'on' : 'null'}', () => useRestorationId = v),
            ),
            NChoiceChipListItem(
              title: const Text('smartQuotesType'),
              values: [null, ...SmartQuotesType.values],
              value: smartQuotesType,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('smartQuotesType ${e?.name ?? 'null'}', () => smartQuotesType = e),
            ),
            NChoiceChipListItem(
              title: const Text('smartDashesType'),
              values: [null, ...SmartDashesType.values],
              value: smartDashesType,
              labelOf: (e) => e?.name ?? '默',
              onChanged: (e) => onMark('smartDashesType ${e?.name ?? 'null'}', () => smartDashesType = e),
            ),
            NSwitchListItem(
              title: const Text('enableIMEPersonalizedLearning'),
              value: enableIMEPersonalizedLearning,
              onChanged: (v) => onMark('enableIMEPersonalizedLearning $v', () => enableIMEPersonalizedLearning = v),
            ),
            NSwitchListItem(
              title: const Text('autocorrect'),
              value: autocorrect,
              onChanged: (v) => onMark('autocorrect $v', () => autocorrect = v),
            ),
            NChoiceChipListItem(
              title: const Text('enabled'),
              values: const [null, true, false],
              value: cupertinoEnabled,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('enabled ${e ?? 'null'}', () => cupertinoEnabled = e),
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('prefixInsets'),
              min: 0,
              max: 16,
              value: prefixStart.clamp(0, 16),
              onChanged: (v) => onMark('prefixInsets ${v.round()}', () => prefixStart = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('suffixInsets'),
              min: 0,
              max: 16,
              value: suffixEnd.clamp(0, 16),
              onChanged: (v) => onMark('suffixInsets ${v.round()}', () => suffixEnd = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding'),
              min: 0,
              max: 16,
              value: cupertinoPadV.clamp(0, 16),
              onChanged: (v) => onMark('padding ${v.round()}', () => cupertinoPadV = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          if (isShowSearch) ...[
            NChoiceChipListItem(
              title: const Text('query'),
              values: const ['', 'Apple', '搜索'],
              value: query,
              labelOf: (e) => e.isEmpty ? "''" : e,
              onChanged: (e) => onMark('query $e', () => query = e),
            ),
            NSwitchListItem(
              title: const Text('useRootNavigator'),
              value: useRootNavigator,
              onChanged: (v) => onMark('useRootNavigator $v', () => useRootNavigator = v),
            ),
            NSwitchListItem(
              title: const Text('maintainState'),
              value: maintainState,
              onChanged: (v) => onMark('maintainState $v', () => maintainState = v),
            ),
            buildStringChips(
                'searchFieldLabel', searchFieldLabel, const [null, 'Search', '搜索'], (e) => searchFieldLabel = e),
            NChoiceChipListItem(
              title: const Text('searchFieldLook'),
              values: _SearchFieldLook.values,
              value: searchFieldLook,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('searchFieldLook ${e.label}', () => searchFieldLook = e),
            ),
            NSwitchListItem(
              title: const Text('autocorrect'),
              value: autocorrect,
              onChanged: (v) => onMark('autocorrect $v', () => autocorrect = v),
            ),
            NSwitchListItem(
              title: const Text('enableSuggestions'),
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
            NSwitchListItem(
              title: const Text('constraints'),
              value: useConstraints,
              onChanged: (v) => onMark('constraints ${v ? 'on' : 'null'}', () => useConstraints = v),
            ),
            if (useConstraints) ...[
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('minHeight'),
                min: 40,
                max: 80,
                value: minHeight.clamp(40, 80),
                onChanged: (v) => onMark('minHeight ${v.round()}', () => minHeight = v),
                activeColor: theme.colorScheme.primary,
              ),
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('maxWidth'),
                min: 200,
                max: 800,
                value: maxWidth.clamp(200, 800),
                onChanged: (v) => onMark('maxWidth ${v.round()}', () => maxWidth = v),
                activeColor: theme.colorScheme.primary,
              ),
            ],
            NSwitchListItem(
              title: const Text('padding'),
              value: usePadding,
              onChanged: (v) => onMark('padding ${v ? 'on' : 'null'}', () => usePadding = v),
            ),
            if (usePadding) ...[
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('paddingH'),
                min: 0,
                max: 32,
                value: paddingH.clamp(0, 32),
                onChanged: (v) => onMark('paddingH ${v.round()}', () => paddingH = v),
                activeColor: theme.colorScheme.primary,
              ),
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('paddingV'),
                min: 0,
                max: 16,
                value: paddingV.clamp(0, 16),
                onChanged: (v) => onMark('paddingV ${v.round()}', () => paddingV = v),
                activeColor: theme.colorScheme.primary,
              ),
            ],
            NChoiceChipListItem(
              title: const Text('shape'),
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('shape ${e.label}', () => shapeKind = e),
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
              title: const Text('side'),
              value: useSide,
              onChanged: (v) => onMark('side ${v ? 'on' : 'null'}', () => useSide = v),
            ),
            if (useSide) ...[
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('sideWidth'),
                min: 0.5,
                max: 4,
                value: sideWidth.clamp(0.5, 4),
                onChanged: (v) => onMark('sideWidth ${v.toStringAsFixed(1)}', () => sideWidth = v),
                activeColor: theme.colorScheme.primary,
              ),
              NChoiceColorListItem(
                title: const Text('sideColor'),
                value: sideColor,
                onChanged: (v) => onMark('sideColor ${v ?? 'null'}', () => sideColor = v),
              ),
            ],
            NChoiceColorListItem(
              title: const Text('backgroundColor'),
              value: backgroundColor,
              onChanged: (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v),
            ),
            if (isSearchBar) ...[
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
            ],
            NChoiceColorListItem(
              title: const Text('overlayColor'),
              value: overlayColor,
              onChanged: (v) => onMark('overlayColor ${v ?? 'null'}', () => overlayColor = v),
            ),
            ...buildStyleToggles(
              styleTitle: 'textStyle',
              hintTitle: 'hintStyle',
              colorLabel: 'textStyle.color',
              hintColorLabel: 'hintStyle.color',
            ),
          ],
          if (isAnchor || isAnchorBar) ...[
            NSwitchListItem(
              title: const Text('viewElevation'),
              value: useViewElevation,
              onChanged: (v) => onMark('viewElevation ${v ? 'on' : 'null'}', () => useViewElevation = v),
            ),
            if (useViewElevation)
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('viewElevation'),
                min: 0,
                max: 16,
                value: viewElevation.clamp(0, 16),
                onChanged: (v) => onMark('viewElevation ${v.toStringAsFixed(1)}', () => viewElevation = v),
                activeColor: theme.colorScheme.primary,
              ),
            NChoiceColorListItem(
              title: const Text('viewBackgroundColor'),
              value: viewBackgroundColor,
              onChanged: (v) => onMark('viewBackgroundColor ${v ?? 'null'}', () => viewBackgroundColor = v),
            ),
            if (isAnchor)
              NChoiceColorListItem(
                title: const Text('viewSurfaceTintColor'),
                value: viewSurfaceTintColor,
                onChanged: (v) => onMark('viewSurfaceTintColor ${v ?? 'null'}', () => viewSurfaceTintColor = v),
              ),
            NChoiceColorListItem(
              title: const Text('dividerColor'),
              value: dividerColor,
              onChanged: (v) => onMark('dividerColor ${v ?? 'null'}', () => dividerColor = v),
            ),
            NChoiceChipListItem(
              title: const Text('viewShape'),
              values: ShapeKind.values,
              value: viewShapeKind,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('viewShape ${e.label}', () => viewShapeKind = e),
            ),
            if (viewShapeKind == ShapeKind.rounded)
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('viewShapeRadius'),
                min: 0,
                max: 32,
                value: viewShapeRadius.clamp(0, 32),
                onChanged: (v) => onMark('viewShapeRadius ${v.round()}', () => viewShapeRadius = v),
                activeColor: theme.colorScheme.primary,
              ),
            NSwitchListItem(
              title: const Text('viewSide'),
              value: useViewSide,
              onChanged: (v) => onMark('viewSide ${v ? 'on' : 'null'}', () => useViewSide = v),
            ),
          ],
          if (isCupertino) ...[
            NSwitchListItem(
              title: const Text('decoration'),
              value: useDecoration,
              onChanged: (v) => onMark('decoration ${v ? 'on' : 'null'}', () => useDecoration = v),
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('borderRadius'),
              min: 0,
              max: 24,
              value: borderRadius.clamp(0, 24),
              onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('itemSize'),
              min: 12,
              max: 32,
              value: itemSize.clamp(12, 32),
              onChanged: (v) => onMark('itemSize ${v.round()}', () => itemSize = v),
              activeColor: theme.colorScheme.primary,
            ),
            NChoiceColorListItem(
              title: const Text('backgroundColor'),
              value: backgroundColor,
              onChanged: (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v),
            ),
            NChoiceColorListItem(
              title: const Text('itemColor'),
              value: itemColor,
              onChanged: (v) => onMark('itemColor ${v ?? 'null'}', () => itemColor = v ?? CupertinoColors.secondaryLabel),
            ),
            ...buildStyleToggles(
              styleTitle: 'style',
              hintTitle: 'placeholderStyle',
              colorLabel: 'style.color',
              hintColorLabel: 'placeholderStyle',
            ),
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
          trailing: useTrailing ? micButtons('trailing') : null,
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
    return useContextMenuBuilder
        ? AdaptiveTextSelectionToolbar.editableText(editableTextState: state)
        : const SizedBox.shrink();
  }

  BoxConstraints? constraintsOf() {
    return useConstraints ? BoxConstraints(minWidth: 0, minHeight: minHeight, maxWidth: maxWidth) : null;
  }

  BoxConstraints? viewConstraintsOf() {
    return useViewConstraints ? BoxConstraints.loose(Size.fromHeight(viewMaxHeight)) : null;
  }

  WidgetStateProperty<double?>? elevationProp() {
    return useElevation ? WidgetStatePropertyAll(elevation) : null;
  }

  WidgetStateProperty<Color?>? colorProp(Color? color) {
    return color == null ? null : WidgetStatePropertyAll(color);
  }

  WidgetStateProperty<BorderSide?>? sideProp() {
    return useSide ? WidgetStatePropertyAll(BorderSide(color: sideColor ?? Colors.blue, width: sideWidth)) : null;
  }

  WidgetStateProperty<OutlinedBorder?>? shapeProp() {
    final shape = shapeKind.outlinedBorder(roundedRadius: shapeRadius);
    return shape == null ? null : WidgetStatePropertyAll(shape);
  }

  WidgetStateProperty<EdgeInsetsGeometry?>? paddingProp() {
    return usePadding
        ? WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV))
        : null;
  }

  WidgetStateProperty<TextStyle?>? textStyleProp() {
    return useTextStyle ? WidgetStatePropertyAll(TextStyle(color: textStyleColor, fontSize: fontSize)) : null;
  }

  WidgetStateProperty<TextStyle?>? hintStyleProp() {
    return useHintStyle ? WidgetStatePropertyAll(TextStyle(color: hintStyleColor)) : null;
  }

  TextStyle? headerTextStyleOf() {
    return useTextStyle ? TextStyle(color: textStyleColor, fontSize: fontSize) : null;
  }

  TextStyle? headerHintStyleOf() {
    return useHintStyle ? TextStyle(color: hintStyleColor) : null;
  }

  BorderSide? viewSideOf() {
    return useViewSide ? BorderSide(color: sideColor ?? Colors.blue, width: sideWidth) : null;
  }

  OutlinedBorder? viewShapeOf() {
    return viewShapeKind.outlinedBorder(roundedRadius: viewShapeRadius);
  }

  String nameOfKeyboard(TextInputType? value) {
    return switch (value) {
      null => '默',
      final v when v == TextInputType.text => 'text',
      final v when v == TextInputType.number => 'number',
      final v when v == TextInputType.emailAddress => 'email',
      final v when v == TextInputType.url => 'url',
      final v when v == TextInputType.phone => 'phone',
      _ => '$value',
    };
  }

  List<Widget> micButtons(String event) {
    return [
      IconButton(
        icon: const Icon(Icons.mic),
        onPressed: () => onMark(event),
      ),
    ];
  }

  Widget buildStringChips(String label, String? value, List<String?> values, ValueChanged<String?> onApply) {
    return NChoiceChipListItem<String?>(
      title: Text(label),
      values: values,
      value: value,
      labelOf: (e) => e ?? '默',
      onChanged: (e) => onMark('$label ${e ?? 'null'}', () => onApply(e)),
    );
  }

  List<Widget> buildStyleToggles({
    required String styleTitle,
    required String hintTitle,
    required String colorLabel,
    required String hintColorLabel,
  }) {
    return [
      NSwitchListItem(
        title: Text(styleTitle),
        value: useTextStyle,
        onChanged: (v) => onMark('$styleTitle ${v ? 'on' : 'null'}', () => useTextStyle = v),
      ),
      if (useTextStyle) ...[
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('fontSize'),
          min: 12,
          max: 22,
          value: fontSize.clamp(12, 22),
          onChanged: (v) => onMark('fontSize ${v.round()}', () => fontSize = v),
          activeColor: theme.colorScheme.primary,
        ),
        NChoiceColorListItem(
          title: Text(colorLabel),
          value: textStyleColor,
          onChanged: (v) => onMark('$colorLabel ${v ?? 'null'}', () => textStyleColor = v),
        ),
      ],
      NSwitchListItem(
        title: Text(hintTitle),
        value: useHintStyle,
        onChanged: (v) => onMark('$hintTitle ${v ? 'on' : 'null'}', () => useHintStyle = v),
      ),
      if (useHintStyle)
        NChoiceColorListItem(
          title: Text(hintColorLabel),
          value: hintStyleColor,
          onChanged: (v) => onMark('$hintColorLabel ${v ?? 'null'}', () => hintStyleColor = v),
        ),
    ];
  }



  Widget? colorDotChild(Color? color, bool selected, ColorScheme scheme) {
    if (color == null) {
      return Text('默', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600));
    }
    if (!selected) {
      return null;
    }
    final dark = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    return Icon(Icons.check_rounded, size: 16, color: dark ? Colors.white : Colors.black87);
  }


  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onTap() {
    onMark('onTap');
    SnackUtil.show('onTap');
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
        searchFieldStyle: switch (searchFieldLook) {
          _SearchFieldLook.style => TextStyle(color: textStyleColor ?? Colors.white, fontSize: fontSize),
          _ => null,
        },
        searchFieldDecorationTheme: switch (searchFieldLook) {
          _SearchFieldLook.decoration => const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white24,
              border: InputBorder.none,
            ),
          _ => null,
        },
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
