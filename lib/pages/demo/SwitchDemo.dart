import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_resize.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// 构造方式
enum _SwitchKind { material, adaptive }

/// thumbIcon 预设
enum _ThumbIconKind { none, checkClose, add }

class SwitchDemo extends StatefulWidget {
  const SwitchDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
    return switch (thumbIconKind) {
      _ThumbIconKind.none => null,
      _ThumbIconKind.checkClose => WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check);
          }
          return const Icon(Icons.close);
        }),
      _ThumbIconKind.add => WidgetStateProperty.all(const Icon(Icons.add)),
    };
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_outlined),
      title: '行为',
      subtitle: 'Switch / .adaptive  value  onChanged  thumbIcon  dragStartBehavior  padding  focus',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('构造'),
          buildChoiceChips(
            values: _SwitchKind.values,
            value: kind,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('kind ${e.name}', () => kind = e),
          ),
          buildSwitch(
            title: 'value',
            value: value,
            onChanged: onValue,
          ),
          buildSwitch(
            title: 'onChanged',
            value: useOnChanged,
            onChanged: (v) => onMark('onChanged ${v ? 'on' : 'null'}', () => useOnChanged = v),
          ),
          const Text('thumbIcon'),
          buildChoiceChips(
            values: _ThumbIconKind.values,
            value: thumbIconKind,
            labelOf: (e) => e == _ThumbIconKind.checkClose ? 'check/close' : e.name,
            onChanged: (e) => onMark('thumbIcon ${e.name}', () => thumbIconKind = e),
          ),
          buildSwitch(
            title: 'thumbImage',
            value: useThumbImage,
            onChanged: (v) => onMark('thumbImage ${v ? 'on' : 'null'}', () => useThumbImage = v),
          ),
          const Text('dragStartBehavior'),
          buildChoiceChips(
            values: DragStartBehavior.values,
            value: dragStartBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('dragStartBehavior ${e.name}', () => dragStartBehavior = e),
          ),
          const Text('materialTapTargetSize'),
          buildChoiceChips(
            values: [null, ...MaterialTapTargetSize.values],
            value: materialTapTargetSize,
            labelOf: (e) => e?.name ?? '默',
            onChanged: (e) => onMark('materialTapTargetSize ${e?.name ?? 'null'}', () => materialTapTargetSize = e),
          ),
          const Text('mouseCursor'),
          buildChoiceChips(
            values: const [null, SystemMouseCursors.click, SystemMouseCursors.basic, SystemMouseCursors.forbidden],
            value: mouseCursor,
            labelOf: nameOfMouse,
            onChanged: (e) => onMark('mouseCursor ${nameOfMouse(e)}', () => mouseCursor = e),
          ),
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
              max: 16,
              onChanged: (v) => onMark('padding ${v.round()}', () => paddingAll = v),
            ),
          buildSwitch(
            title: 'autofocus',
            value: autofocus,
            onChanged: (v) => onMark('autofocus $v', () => autofocus = v),
          ),
          buildSwitch(
            title: 'focusNode',
            value: useFocusNode,
            onChanged: (v) => onMark('focusNode ${v ? 'on' : 'null'}', () => useFocusNode = v),
          ),
          buildSwitch(
            title: 'onFocusChange',
            value: useOnFocusChange,
            onChanged: (v) => onMark('onFocusChange ${v ? 'on' : 'null'}', () => useOnFocusChange = v),
          ),
          if (kind == _SwitchKind.adaptive) ...[
            const Text('applyCupertinoTheme'),
            buildChoiceChips(
              values: const [null, true, false],
              value: applyCupertinoTheme,
              labelOf: (e) => e == null ? '默' : '$e',
              onChanged: (e) => onMark('applyCupertinoTheme ${e ?? 'null'}', () => applyCupertinoTheme = e),
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
      subtitle: 'activeColor  trackColor  thumbColor  overlayColor  splashRadius  trackOutlineWidth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColorRow('activeColor', activeColor, (v) => onMark('activeColor ${v ?? 'null'}', () => activeColor = v)),
          buildColorRow('activeTrackColor', activeTrackColor, (v) => onMark('activeTrackColor ${v ?? 'null'}', () => activeTrackColor = v)),
          buildColorRow('inactiveThumbColor', inactiveThumbColor, (v) => onMark('inactiveThumbColor ${v ?? 'null'}', () => inactiveThumbColor = v)),
          buildColorRow('inactiveTrackColor', inactiveTrackColor, (v) => onMark('inactiveTrackColor ${v ?? 'null'}', () => inactiveTrackColor = v)),
          buildColorRow('thumbColor', thumbColor, (v) => onMark('thumbColor ${v ?? 'null'}', () => thumbColor = v)),
          buildColorRow('trackColor', trackColor, (v) => onMark('trackColor ${v ?? 'null'}', () => trackColor = v)),
          buildColorRow('trackOutlineColor', trackOutlineColor, (v) => onMark('trackOutlineColor ${v ?? 'null'}', () => trackOutlineColor = v)),
          buildColorRow('focusColor', focusColor, (v) => onMark('focusColor ${v ?? 'null'}', () => focusColor = v)),
          buildColorRow('hoverColor', hoverColor, (v) => onMark('hoverColor ${v ?? 'null'}', () => hoverColor = v)),
          buildColorRow('overlayColor', overlayColor, (v) => onMark('overlayColor ${v ?? 'null'}', () => overlayColor = v)),
          buildSwitch(
            title: 'splashRadius',
            value: useSplashRadius,
            onChanged: (v) => onMark('splashRadius ${v ? 'on' : 'null'}', () => useSplashRadius = v),
          ),
          if (useSplashRadius)
            buildSlider(
              label: 'splashRadius',
              value: splashRadius,
              min: 8,
              max: 40,
              onChanged: (v) => onMark('splashRadius ${v.round()}', () => splashRadius = v),
            ),
          buildSwitch(
            title: 'trackOutlineWidth',
            value: useTrackOutlineWidth,
            onChanged: (v) => onMark('trackOutlineWidth ${v ? 'on' : 'null'}', () => useTrackOutlineWidth = v),
          ),
          if (useTrackOutlineWidth)
            buildSlider(
              label: 'trackOutlineWidth',
              value: trackOutlineWidth,
              min: 0,
              max: 4,
              onChanged: (v) => onMark('trackOutlineWidth ${v.toStringAsFixed(1)}', () => trackOutlineWidth = v),
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
    return NSliderListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
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
