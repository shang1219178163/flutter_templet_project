import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class MaterialBannerDemo extends StatefulWidget {
  const MaterialBannerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MaterialBannerDemo> createState() => _MaterialBannerDemoState();
}

class _MaterialBannerDemoState extends State<MaterialBannerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
    final scheme = Theme.of(context).colorScheme;
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
                        NLangEnum.en: 'Widget MaterialBanner',
                        NLangEnum.zh: '组件 MaterialBanner',
                      },
                      items: [
                        {
                          NLangEnum.en: 'Preview embeds MaterialBanner. Messenger 显示 uses ScaffoldMessenger; leaving hides it first.',
                          NLangEnum.zh: '预览区嵌入 Banner；Messenger 显示走 ScaffoldMessenger，退出路由前先收起。',
                        },
                        {
                          NLangEnum.en: 'animation is injected by ScaffoldMessenger; the static preview keeps it null.',
                          NLangEnum.zh: 'animation 由 ScaffoldMessenger 注入，静态预览保持 null。',
                        },
                      ],
                    ),
                    buildContentCard(),
                    buildActionsCard(),
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
            onPressed: onNo,
            child: const Text('NO'),
          ),
        TextButton(
          onPressed: onYes,
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
      subtitle: 'content  contentTextStyle  leading  leadingPadding',
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
          buildSwitch(
            title: 'contentTextStyle',
            value: useContentTextStyle,
            onChanged: (v) => onMark('contentTextStyle ${v ? 'on' : 'null'}', () => useContentTextStyle = v),
          ),
          if (useContentTextStyle) ...[
            buildSlider(
              label: 'fontSize',
              value: contentFontSize,
              min: 12,
              max: 22,
              onChanged: (v) => onMark('fontSize ${v.toStringAsFixed(1)}', () => contentFontSize = v),
            ),
            buildColorRow('color', contentTextColor, (v) => onMark('contentTextStyle.color ${v ?? 'null'}', () => contentTextColor = v)),
          ],
          buildSwitch(
            title: 'leading',
            value: useLeading,
            onChanged: (v) => onMark('leading ${v ? 'on' : 'null'}', () => useLeading = v),
          ),
          buildSwitch(
            title: 'leadingPadding',
            value: useLeadingPadding,
            onChanged: (v) => onMark('leadingPadding ${v ? 'on' : 'null'}', () => useLeadingPadding = v),
          ),
          if (useLeadingPadding)
            buildSlider(
              label: 'end',
              value: leadingPaddingEnd,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('leadingPadding.end ${v.round()}', () => leadingPaddingEnd = v),
            ),
        ],
      ),
    );
  }

  Widget buildActionsCard() {
    return NDecorationCard(
      icon: const Icon(Icons.smart_button_outlined),
      title: '操作',
      subtitle: 'actions  forceActionsBelow  overflowAlignment  minActionBarHeight',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: '单按钮 actions',
            value: singleAction,
            onChanged: (v) => onMark('actions ${v ? 1 : 2}', () => singleAction = v),
          ),
          buildSwitch(
            title: 'forceActionsBelow',
            value: forceActionsBelow,
            onChanged: (v) => onMark('forceActionsBelow $v', () => forceActionsBelow = v),
          ),
          const Text('overflowAlignment'),
          buildChoiceChips(
            values: OverflowBarAlignment.values,
            value: overflowAlignment,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('overflowAlignment ${e.name}', () => overflowAlignment = e),
          ),
          buildSlider(
            label: 'minActionBarHeight',
            value: minActionBarHeight,
            min: 36,
            max: 80,
            onChanged: (v) => onMark('minActionBarHeight ${v.round()}', () => minActionBarHeight = v),
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
          buildColorRow('backgroundColor', backgroundColor, (v) => onMark('backgroundColor ${v ?? 'null'}', () => backgroundColor = v)),
          buildColorRow('surfaceTintColor', surfaceTintColor, (v) => onMark('surfaceTintColor ${v ?? 'null'}', () => surfaceTintColor = v)),
          buildColorRow('shadowColor', shadowColor, (v) => onMark('shadowColor ${v ?? 'null'}', () => shadowColor = v)),
          buildColorRow('dividerColor', dividerColor, (v) => onMark('dividerColor ${v ?? 'null'}', () => dividerColor = v)),
          buildSwitch(
            title: 'padding',
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'on' : 'null'}', () => usePadding = v),
          ),
          if (usePadding)
            buildSlider(
              label: 'padding',
              value: paddingAll,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('padding ${v.round()}', () => paddingAll = v),
            ),
          buildSwitch(
            title: 'margin',
            value: useMargin,
            onChanged: (v) => onMark('margin ${v ? 'on' : 'null'}', () => useMargin = v),
          ),
          if (useMargin)
            buildSlider(
              label: 'margin',
              value: marginAll,
              min: 0,
              max: 24,
              onChanged: (v) => onMark('margin ${v.round()}', () => marginAll = v),
            ),
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

  void onNo() => onAction('NO');

  void onYes() => onAction('YES');
}
