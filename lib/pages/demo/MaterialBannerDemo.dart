import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class MaterialBannerDemo extends StatefulWidget {
  const MaterialBannerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MaterialBannerDemo> createState() => _MaterialBannerDemoState();
}

class _MaterialBannerDemoState extends State<MaterialBannerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final contentController = TextEditingController(text: 'Your account has been deleted.');

  /// 页面级 Messenger，避免 Banner 挂到 MaterialApp 全局后路由退出仍残留。
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static const _bannerDismissDuration = Duration(milliseconds: 250);

  /// 正在退出路由
  bool _isLeaving = false;
  /// 最近事件
  String lastEvent = '—';
  /// 是否显示 leading
  bool useLeading = true;
  /// 是否传入 contentTextStyle
  bool useContentTextStyle = false;
  /// 是否传入 elevation
  bool useElevation = false;
  /// 是否传入 padding
  bool usePadding = false;
  /// 是否传入 margin
  bool useMargin = false;
  /// 是否传入 leadingPadding
  bool useLeadingPadding = false;
  /// 操作按钮强制换行
  bool forceActionsBelow = false;
  /// 只显示一个操作按钮
  bool singleAction = false;
  /// 溢出操作栏对齐
  OverflowBarAlignment overflowAlignment = OverflowBarAlignment.end;
  /// 海拔阴影
  double elevation = 0;
  /// 操作栏最小高度
  double minActionBarHeight = 52;
  /// 内边距
  double paddingAll = 16;
  /// 外边距
  double marginAll = 10;
  /// leading 右侧间距
  double leadingPaddingEnd = 16;
  /// 正文文字字号
  double contentFontSize = 14;
  /// 背景色
  Color? backgroundColor;
  /// 表面色调
  Color? surfaceTintColor;
  /// 阴影色
  Color? shadowColor;
  /// 分割线颜色
  Color? dividerColor;
  /// 正文文字颜色
  Color? contentTextColor;

  ScaffoldMessengerState? get pageMessenger => _scaffoldMessengerKey.currentState;

  @override
  void dispose() {
    pageMessenger?.hideCurrentMaterialBanner();
    pageMessenger?.clearMaterialBanners();
    scrollController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        popAfterDismissBanner(result);
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: scheme.surfaceContainerLowest,
          appBar: hideApp
              ? null
              : AppBar(
                  title: Text(widget.title ?? "$widget"),
                  leading: IconButton(
                    icon: const BackButtonIcon(),
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () => popAfterDismissBanner(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: onReset,
                      child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                    ),
                  ],
                ),
          body: buildBody(),
        ),
      ),
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
                        NLangEnum.en: 'Widget MaterialBanner',
                        NLangEnum.zh: '组件 MaterialBanner',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'Preview embeds MaterialBanner. Messenger 显示 uses ScaffoldMessenger and hides it before leaving. animation is injected by ScaffoldMessenger; the static preview keeps it null.',
                          NLangEnum.zh: '预览区嵌入 Banner；Messenger 显示走 ScaffoldMessenger，退出路由前先收起。animation 由 ScaffoldMessenger 注入，静态预览保持 null。',
                        },
                      ],
                    ),
                    buildContentCard(),
                    buildSurfaceCard(),
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: buildBanner(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                FilledButton(
                  onPressed: onShowMessenger,
                  child: const Text('Messenger 显示'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onHideMessenger,
                  child: const Text('隐藏'),
                ),
              ],
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

  MaterialBanner buildBanner() {
    return MaterialBanner(
      content: Text(contentController.text),
      contentTextStyle: useContentTextStyle
          ? TextStyle(
              fontSize: contentFontSize,
              color: contentTextColor,
            )
          : null,
      actions: [
        if (!singleAction)
          TextButton(
            onPressed: () => onAction('NO'),
            child: const Text('NO'),
          ),
        TextButton(
          onPressed: () => onAction('YES'),
          child: const Text('YES'),
        ),
      ],
      elevation: useElevation ? elevation : null,
      leading: useLeading
          ? const CircleAvatar(
              child: Icon(Icons.account_box),
            )
          : null,
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      dividerColor: dividerColor,
      padding: usePadding ? EdgeInsets.all(paddingAll) : null,
      margin: useMargin ? EdgeInsets.all(marginAll) : null,
      leadingPadding: useLeadingPadding ? EdgeInsetsDirectional.only(end: leadingPaddingEnd) : null,
      forceActionsBelow: forceActionsBelow,
      overflowAlignment: overflowAlignment,
      onVisible: onBannerVisible,
      minActionBarHeight: minActionBarHeight,
    );
  }

  Widget buildContentCard() {
    return NDecorationCard(
      icon: const Icon(Icons.notes_outlined),
      title: '内容',
      subtitle: 'content  leading  actions  overflowAlignment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: contentController,
            onChanged: (_) => onMark('content'),
            decoration: const InputDecoration(
              labelText: 'content',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          NSwitchListTile(
            title: const Text('contentTextStyle'),
            value: useContentTextStyle,
            onChanged: (v) => onMark('contentTextStyle ${v ? 'on' : 'null'}', () => useContentTextStyle = v),
          ),
          if (useContentTextStyle) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('fontSize'),
              min: 12,
              max: 22,
              value: contentFontSize.clamp(12, 22),
              onChanged: (v) => onMark('fontSize ${v.toStringAsFixed(1)}', () => contentFontSize = v),
              activeColor: theme.colorScheme.primary,
            ),
            NChoiceColorListItem(
              title: const Text('color'),
              value: contentTextColor,
              onChanged: (v) => onMark('contentTextStyle.color ${v ?? 'null'}', () => contentTextColor = v),
            ),
          ],
          NSwitchListTile(
            title: const Text('leading'),
            value: useLeading,
            onChanged: (v) => onMark('leading ${v ? 'on' : 'null'}', () => useLeading = v),
          ),
          NSwitchListTile(
            title: const Text('leadingPadding'),
            value: useLeadingPadding,
            onChanged: (v) => onMark('leadingPadding ${v ? 'on' : 'null'}', () => useLeadingPadding = v),
          ),
          if (useLeadingPadding)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('end'),
              min: 0,
              max: 32,
              value: leadingPaddingEnd.clamp(0, 32),
              onChanged: (v) => onMark('leadingPadding.end ${v.round()}', () => leadingPaddingEnd = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListTile(
            title: const Text('单按钮 actions'),
            value: singleAction,
            onChanged: (v) => onMark('actions ${v ? 1 : 2}', () => singleAction = v),
          ),
          NSwitchListTile(
            title: const Text('forceActionsBelow'),
            value: forceActionsBelow,
            onChanged: (v) => onMark('forceActionsBelow $v', () => forceActionsBelow = v),
          ),
          NChoiceChipListItem<OverflowBarAlignment>(
            title: const Text('overflowAlignment'),
            values: OverflowBarAlignment.values,
            value: overflowAlignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('overflowAlignment ${e.name}', () => overflowAlignment = e),
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('minActionBarHeight'),
            min: 36,
            max: 80,
            value: minActionBarHeight.clamp(36, 80),
            onChanged: (v) => onMark('minActionBarHeight ${v.round()}', () => minActionBarHeight = v),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: '表面',
      subtitle: 'elevation  backgroundColor  surfaceTintColor  shadowColor  dividerColor  padding  margin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListTile(
            title: const Text('elevation'),
            value: useElevation,
            onChanged: (v) => onMark('elevation ${v ? 'on' : 'null'}', () => useElevation = v),
          ),
          if (useElevation)
            NSliderListTile(
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
            title: const Text('backgroundColor'),
            value: backgroundColor,
            onChanged: (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('surfaceTintColor'),
            value: surfaceTintColor,
            onChanged: (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('shadowColor'),
            value: shadowColor,
            onChanged: (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('dividerColor'),
            value: dividerColor,
            onChanged: (v) => onMark('dividerColor ${v ?? 'null'}', () => dividerColor = v),
          ),
          NSwitchListTile(
            title: const Text('padding'),
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'on' : 'null'}', () => usePadding = v),
          ),
          if (usePadding)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding'),
              min: 0,
              max: 32,
              value: paddingAll.clamp(0, 32),
              onChanged: (v) => onMark('padding ${v.round()}', () => paddingAll = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListTile(
            title: const Text('margin'),
            value: useMargin,
            onChanged: (v) => onMark('margin ${v ? 'on' : 'null'}', () => useMargin = v),
          ),
          if (useMargin)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('margin'),
              min: 0,
              max: 24,
              value: marginAll.clamp(0, 24),
              onChanged: (v) => onMark('margin ${v.round()}', () => marginAll = v),
              activeColor: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }


  Future<void> popAfterDismissBanner([Object? result]) async {
    if (_isLeaving) {
      return;
    }
    _isLeaving = true;
    final messenger = pageMessenger;
    if (messenger != null) {
      messenger.hideCurrentMaterialBanner();
      await Future<void>.delayed(_bannerDismissDuration);
      if (!mounted) {
        return;
      }
      messenger.clearMaterialBanners();
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(result);
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onReset() {
    contentController.text = 'Your account has been deleted.';
    lastEvent = '—';
    useLeading = true;
    useContentTextStyle = false;
    useElevation = false;
    usePadding = false;
    useMargin = false;
    useLeadingPadding = false;
    forceActionsBelow = false;
    singleAction = false;
    overflowAlignment = OverflowBarAlignment.end;
    elevation = 0;
    minActionBarHeight = 52;
    paddingAll = 16;
    marginAll = 10;
    leadingPaddingEnd = 16;
    contentFontSize = 14;
    backgroundColor = null;
    surfaceTintColor = null;
    shadowColor = null;
    dividerColor = null;
    contentTextColor = null;
    pageMessenger?.hideCurrentMaterialBanner();
    pageMessenger?.clearMaterialBanners();
    setState(() {});
  }

  void onShowMessenger() {
    final messenger = pageMessenger;
    if (messenger == null) {
      return;
    }
    messenger.hideCurrentMaterialBanner();
    messenger.showMaterialBanner(buildBanner());
    lastEvent = 'showMaterialBanner';
    setState(() {});
  }

  void onHideMessenger() {
    pageMessenger?.hideCurrentMaterialBanner();
    lastEvent = 'hideCurrentMaterialBanner';
    setState(() {});
  }

  void onBannerVisible() {
    lastEvent = 'onVisible';
    DLog.d('onVisible');
    if (mounted) {
      setState(() {});
    }
  }

  void onAction(String name) {
    lastEvent = name;
    DLog.d(name);
    pageMessenger?.hideCurrentMaterialBanner();
    setState(() {});
  }
}
