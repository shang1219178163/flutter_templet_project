import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_resize.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 构造方式
enum _SwitchKind {
  material(label: 'material'),
  adaptive(label: 'adaptive');
  const _SwitchKind({required this.label});
  final String label;
}

/// thumbIcon 预设
enum _ThumbIconKind {
  none(label: 'none', fixedIcon: null, selectedIcon: null, unselectedIcon: null),
  checkClose(label: 'check/close', fixedIcon: null, selectedIcon: Icons.check, unselectedIcon: Icons.close),
  add(label: 'add', fixedIcon: Icons.add, selectedIcon: null, unselectedIcon: null),
  ;
  const _ThumbIconKind({
    required this.label,
    required this.fixedIcon,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
  final String label;
  final IconData? fixedIcon;
  final IconData? selectedIcon;
  final IconData? unselectedIcon;
}

class SwitchDemo extends StatefulWidget {
  const SwitchDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final focusNode = FocusNode();

  /// 最近事件
  String lastEvent = '—';
  /// 构造方式
  _SwitchKind kind = _SwitchKind.material;
  /// 是否打开
  bool value = false;
  /// 是否传入 onChanged
  bool useOnChanged = true;
  /// 是否自动聚焦
  bool autofocus = false;
  /// 是否传入 focusNode
  bool useFocusNode = false;
  /// 是否传入 onFocusChange
  bool useOnFocusChange = false;
  /// 拖动手势起点
  DragStartBehavior dragStartBehavior = DragStartBehavior.start;
  /// 点击目标尺寸
  MaterialTapTargetSize? materialTapTargetSize;
  /// 指针样式
  MouseCursor? mouseCursor;
  /// 滑块图标
  _ThumbIconKind thumbIconKind = _ThumbIconKind.checkClose;
  /// 是否传入滑块图片
  bool useThumbImage = false;
  /// 是否传入 padding
  bool usePadding = false;
  /// 内边距
  double paddingAll = 4;
  /// 是否传入 splashRadius
  bool useSplashRadius = false;
  /// 水波纹半径
  double splashRadius = 24;
  /// 是否传入 trackOutlineWidth
  bool useTrackOutlineWidth = false;
  /// 轨道描边宽度
  double trackOutlineWidth = 2;
  /// adaptive 是否应用 Cupertino 主题
  bool? applyCupertinoTheme;
  /// 打开时滑块色
  Color? activeColor;
  /// 打开时轨道色
  Color? activeTrackColor;
  /// 关闭时滑块色
  Color? inactiveThumbColor;
  /// 关闭时轨道色
  Color? inactiveTrackColor;
  /// 滑块色
  Color? thumbColor;
  /// 轨道色
  Color? trackColor;
  /// 轨道描边色
  Color? trackOutlineColor;
  /// 聚焦色
  Color? focusColor;
  /// 悬停色
  Color? hoverColor;
  /// 水波纹覆盖色
  Color? overlayColor;

  @override
  void dispose() {
    scrollController.dispose();
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
                        NLangEnum.en: 'Widget Switch',
                        NLangEnum.zh: '组件 Switch',
                      },
                      items: [
                        {
                          NLangEnum.en:
                              'Check/close Switch, asset-thumb Switch, NResizeSwitch and CupertinoSwitch are the original children. Tune the first Switch.',
                          NLangEnum.zh: '勾叉 Switch、资源图 Switch、NResizeSwitch、CupertinoSwitch 是原内容。调参作用在第一个 Switch。',
                        },
                      ],
                    ),
                    buildBehaviorCard(),
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
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPlaySwitch(),
                  Switch(
                    thumbIcon: WidgetStateProperty.all(const Icon(Icons.add)),
                    activeThumbImage: const AssetImage(Assets.imagesIconCheckCircleSelected),
                    inactiveThumbImage: const AssetImage(Assets.imagesIconClear),
                    value: value,
                    onChanged: useOnChanged ? onValue : null,
                  ),
                  NResizeSwitch(
                    width: 40,
                    height: 25,
                    value: value,
                    onChanged: useOnChanged ? onValue : null,
                  ),
                  NResize(
                    width: 40,
                    height: 25,
                    child: CupertinoSwitch(
                      value: value,
                      onChanged: useOnChanged ? onValue : null,
                    ),
                  ),
                ],
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

  Widget buildPlaySwitch() {
    final onChanged = useOnChanged ? onValue : null;
    final activeImage = useThumbImage ? const AssetImage(Assets.imagesIconCheckCircleSelected) : null;
    final inactiveImage = useThumbImage ? const AssetImage(Assets.imagesIconClear) : null;
    final padding = usePadding ? EdgeInsets.all(paddingAll) : null;
    final key = ValueKey(kind);
    return switch (kind) {
      _SwitchKind.material => Switch(
          key: key,
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          activeTrackColor: activeTrackColor,
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveTrackColor,
          activeThumbImage: activeImage,
          onActiveThumbImageError: activeImage == null ? null : onActiveThumbImageError,
          inactiveThumbImage: inactiveImage,
          onInactiveThumbImageError: inactiveImage == null ? null : onInactiveThumbImageError,
          thumbColor: thumbColor == null ? null : WidgetStatePropertyAll(thumbColor),
          trackColor: trackColor == null ? null : WidgetStatePropertyAll(trackColor),
          trackOutlineColor: trackOutlineColor == null ? null : WidgetStatePropertyAll(trackOutlineColor),
          trackOutlineWidth: useTrackOutlineWidth ? WidgetStatePropertyAll(trackOutlineWidth) : null,
          thumbIcon: buildThumbIcon(),
          materialTapTargetSize: materialTapTargetSize,
          dragStartBehavior: dragStartBehavior,
          mouseCursor: mouseCursor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor == null ? null : WidgetStatePropertyAll(overlayColor),
          splashRadius: useSplashRadius ? splashRadius : null,
          focusNode: useFocusNode ? focusNode : null,
          onFocusChange: useOnFocusChange ? onFocusChange : null,
          autofocus: autofocus,
          padding: padding,
        ),
      _SwitchKind.adaptive => Switch.adaptive(
          key: key,
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          activeTrackColor: activeTrackColor,
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveTrackColor,
          activeThumbImage: activeImage,
          onActiveThumbImageError: activeImage == null ? null : onActiveThumbImageError,
          inactiveThumbImage: inactiveImage,
          onInactiveThumbImageError: inactiveImage == null ? null : onInactiveThumbImageError,
          thumbColor: thumbColor == null ? null : WidgetStatePropertyAll(thumbColor),
          trackColor: trackColor == null ? null : WidgetStatePropertyAll(trackColor),
          trackOutlineColor: trackOutlineColor == null ? null : WidgetStatePropertyAll(trackOutlineColor),
          trackOutlineWidth: useTrackOutlineWidth ? WidgetStatePropertyAll(trackOutlineWidth) : null,
          thumbIcon: buildThumbIcon(),
          materialTapTargetSize: materialTapTargetSize,
          dragStartBehavior: dragStartBehavior,
          mouseCursor: mouseCursor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor == null ? null : WidgetStatePropertyAll(overlayColor),
          splashRadius: useSplashRadius ? splashRadius : null,
          focusNode: useFocusNode ? focusNode : null,
          onFocusChange: useOnFocusChange ? onFocusChange : null,
          autofocus: autofocus,
          padding: padding,
          applyCupertinoTheme: applyCupertinoTheme,
        ),
    };
  }

  WidgetStateProperty<Icon?>? buildThumbIcon() {
    final kind = thumbIconKind;
    if (kind.fixedIcon != null) {
      return WidgetStateProperty.all(Icon(kind.fixedIcon));
    }
    if (kind.selectedIcon != null) {
      return WidgetStateProperty.resolveWith(
        (states) => Icon(states.contains(WidgetState.selected) ? kind.selectedIcon : kind.unselectedIcon),
      );
    }
    return null;
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'Switch / .adaptive  value  onChanged  thumbIcon  dragStartBehavior  padding  focus',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<_SwitchKind>(
            title: const Text('构造'),
            values: _SwitchKind.values,
            value: kind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('kind ${e.label}', () => kind = e),
          ),
          NSwitchListItem(
            title: const Text('value'),
            value: value,
            onChanged: onValue,
          ),
          NSwitchListItem(
            title: const Text('onChanged'),
            value: useOnChanged,
            onChanged: (v) => onMark('onChanged ${v ? 'on' : 'null'}', () => useOnChanged = v),
          ),
          NChoiceChipListItem<_ThumbIconKind>(
            title: const Text('thumbIcon'),
            values: _ThumbIconKind.values,
            value: thumbIconKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('thumbIcon ${e.label}', () => thumbIconKind = e),
          ),
          NSwitchListItem(
            title: const Text('thumbImage'),
            value: useThumbImage,
            onChanged: (v) => onMark('thumbImage ${v ? 'on' : 'null'}', () => useThumbImage = v),
          ),
          NChoiceChipListItem<DragStartBehavior>(
            title: const Text('dragStartBehavior'),
            values: DragStartBehavior.values,
            value: dragStartBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('dragStartBehavior ${e.name}', () => dragStartBehavior = e),
          ),
          NChoiceChipListItem<MaterialTapTargetSize?>(
            title: const Text('materialTapTargetSize'),
            values: [null, ...MaterialTapTargetSize.values],
            value: materialTapTargetSize,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('materialTapTargetSize ${e?.name ?? 'null'}', () => materialTapTargetSize = e),
          ),
          NChoiceChipListItem<MouseCursor?>(
            title: const Text('mouseCursor'),
            values: const [null, SystemMouseCursors.click, SystemMouseCursors.basic, SystemMouseCursors.forbidden],
            value: mouseCursor,
            labelOf: nameOfMouse,
            onChanged: (e) => onMark('mouseCursor ${nameOfMouse(e)}', () => mouseCursor = e),
          ),
          NSwitchListItem(
            title: const Text('padding'),
            value: usePadding,
            onChanged: (v) => onMark('padding ${v ? 'on' : 'null'}', () => usePadding = v),
          ),
          if (usePadding)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding'),
              min: 0,
              max: 16,
              value: paddingAll.clamp(0, 16),
              onChanged: (v) => onMark('padding ${v.round()}', () => paddingAll = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('autofocus'),
            value: autofocus,
            onChanged: (v) => onMark('autofocus $v', () => autofocus = v),
          ),
          NSwitchListItem(
            title: const Text('focusNode'),
            value: useFocusNode,
            onChanged: (v) => onMark('focusNode ${v ? 'on' : 'null'}', () => useFocusNode = v),
          ),
          NSwitchListItem(
            title: const Text('onFocusChange'),
            value: useOnFocusChange,
            onChanged: (v) => onMark('onFocusChange ${v ? 'on' : 'null'}', () => useOnFocusChange = v),
          ),
          if (kind == _SwitchKind.adaptive)
            NChoiceChipListItem<bool?>(
              title: const Text('applyCupertinoTheme'),
              values: const [null, true, false],
              value: applyCupertinoTheme,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('applyCupertinoTheme ${e ?? 'null'}', () => applyCupertinoTheme = e),
            ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.layers_outlined),
      title: '表面',
      subtitle: 'activeColor  trackColor  thumbColor  overlayColor  splashRadius  trackOutlineWidth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceColorListItem(
            title: const Text('activeColor'),
            value: activeColor,
            onChanged: (v) => onMark('activeColor ${v ?? 'null'}', () => activeColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('activeTrackColor'),
            value: activeTrackColor,
            onChanged: (v) => onMark('activeTrackColor ${v ?? 'null'}', () => activeTrackColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('inactiveThumbColor'),
            value: inactiveThumbColor,
            onChanged: (v) => onMark('inactiveThumbColor ${v ?? 'null'}', () => inactiveThumbColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('inactiveTrackColor'),
            value: inactiveTrackColor,
            onChanged: (v) => onMark('inactiveTrackColor ${v ?? 'null'}', () => inactiveTrackColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('thumbColor'),
            value: thumbColor,
            onChanged: (v) => onMark('thumbColor ${v ?? 'null'}', () => thumbColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('trackColor'),
            value: trackColor,
            onChanged: (v) => onMark('trackColor ${v ?? 'null'}', () => trackColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('trackOutlineColor'),
            value: trackOutlineColor,
            onChanged: (v) => onMark('trackOutlineColor ${v ?? 'null'}', () => trackOutlineColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('focusColor'),
            value: focusColor,
            onChanged: (v) => onMark('focusColor ${v ?? 'null'}', () => focusColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('hoverColor'),
            value: hoverColor,
            onChanged: (v) => onMark('hoverColor ${v ?? 'null'}', () => hoverColor = v),
          ),
          NChoiceColorListItem(
            title: const Text('overlayColor'),
            value: overlayColor,
            onChanged: (v) => onMark('overlayColor ${v ?? 'null'}', () => overlayColor = v),
          ),
          NSwitchListItem(
            title: const Text('splashRadius'),
            value: useSplashRadius,
            onChanged: (v) => onMark('splashRadius ${v ? 'on' : 'null'}', () => useSplashRadius = v),
          ),
          if (useSplashRadius)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('splashRadius'),
              min: 8,
              max: 40,
              value: splashRadius.clamp(8, 40),
              onChanged: (v) => onMark('splashRadius ${v.round()}', () => splashRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSwitchListItem(
            title: const Text('trackOutlineWidth'),
            value: useTrackOutlineWidth,
            onChanged: (v) => onMark('trackOutlineWidth ${v ? 'on' : 'null'}', () => useTrackOutlineWidth = v),
          ),
          if (useTrackOutlineWidth)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('trackOutlineWidth'),
              min: 0,
              max: 4,
              value: trackOutlineWidth.clamp(0, 4),
              onChanged: (v) => onMark('trackOutlineWidth ${v.toStringAsFixed(1)}', () => trackOutlineWidth = v),
              activeColor: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  String nameOfMouse(MouseCursor? value) {
    return switch (value) {
      null => '默',
      SystemMouseCursors.click => 'click',
      SystemMouseCursors.basic => 'basic',
      SystemMouseCursors.forbidden => 'forbidden',
      _ => '$value',
    };
  }


  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    kind = _SwitchKind.material;
    value = false;
    useOnChanged = true;
    autofocus = false;
    useFocusNode = false;
    useOnFocusChange = false;
    dragStartBehavior = DragStartBehavior.start;
    materialTapTargetSize = null;
    mouseCursor = null;
    thumbIconKind = _ThumbIconKind.checkClose;
    useThumbImage = false;
    usePadding = false;
    paddingAll = 4;
    useSplashRadius = false;
    splashRadius = 24;
    useTrackOutlineWidth = false;
    trackOutlineWidth = 2;
    applyCupertinoTheme = null;
    activeColor = null;
    activeTrackColor = null;
    inactiveThumbColor = null;
    inactiveTrackColor = null;
    thumbColor = null;
    trackColor = null;
    trackOutlineColor = null;
    focusColor = null;
    hoverColor = null;
    overlayColor = null;
    setState(() {});
  }

  void onValue(bool v) {
    onMark('onChanged $v', () => value = v);
  }

  void onFocusChange(bool v) {
    onMark('onFocusChange $v');
  }

  void onActiveThumbImageError(Object error, StackTrace? stackTrace) {
    onMark('onActiveThumbImageError');
  }

  void onInactiveThumbImageError(Object error, StackTrace? stackTrace) {
    onMark('onInactiveThumbImageError');
  }
}
