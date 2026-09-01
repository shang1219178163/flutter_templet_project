//
//  AnimatedContainerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 12:19 PM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class AnimatedContainerDemo extends StatefulWidget {
  const AnimatedContainerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final searchVN = ValueNotifier('');
  final searchWidthVN = ValueNotifier(28.0);

  /// 原 Demo 起始 200×200 lightBlue topLeft
  double width = 200;
  /// 高度
  double height = 200;
  /// 填充色
  Color? color = Colors.lightBlue;
  /// 对齐
  Alignment alignment = Alignment.topLeft;
  /// 动画曲线
  Curve curve = Curves.fastOutSlowIn;
  /// 动画时长（毫秒）
  double durationMs = 1000;
  /// 裁剪
  Clip clipBehavior = Clip.none;
  /// 是否显示 child
  bool useChild = true;
  /// 是否传入 padding
  bool usePadding = false;
  /// 水平内边距
  double padH = 12;
  /// 垂直内边距
  double padV = 12;
  /// 是否传入 margin
  bool useMargin = false;
  /// 水平外边距
  double marginH = 8;
  /// 垂直外边距
  double marginV = 8;
  /// 是否用 decoration 代替 color
  bool useDecoration = false;
  /// 外形
  ShapeKind shapeKind = ShapeKind.rounded;
  /// 外形圆角
  double shapeRadius = 16;
  /// 是否传入前景装饰
  bool useForeground = false;
  /// 前景色
  Color? foregroundColor;
  /// 是否传入 transform
  bool useTransform = false;
  /// 旋转角度
  double rotateDeg = 0;
  /// transform 对齐
  Alignment transformAlignment = Alignment.center;
  /// 搜索条是否展开
  bool searchExpanded = false;
  /// 最近事件
  String lastEvent = '—';

  @override
  void dispose() {
    searchController.dispose();
    searchVN.dispose();
    searchWidthVN.dispose();
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
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.42).clamp(240.0, 400.0);
          return Column(
            children: [
              buildPreview(previewHeight),
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
                            NLangEnum.en: 'Widget AnimatedContainer',
                            NLangEnum.zh: '组件 AnimatedContainer',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Changing constructor values animates to the new layout. Tap 更新宽高 for the original 200↔400 toggle. color and decoration cannot both be set.',
                              NLangEnum.zh: '改构造参数会动画过渡到新布局。点「更新宽高」即原来的 200↔400。color 与 decoration 不能同时传。',
                            },
                            {
                              NLangEnum.en:
                                  'The search pill below the box is the original second AnimatedContainer example. onEnd fires when the animation finishes.',
                              NLangEnum.zh: '色块下方的搜索条是原 Demo 的第二个 AnimatedContainer。动画结束会触发 onEnd。',
                            },
                          ],
                        ),
                        buildLayoutCard(),
                        buildBehaviorCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: previewHeight,
            width: double.infinity,
            child: ClipRect(
              child: ColoredBox(
                color: scheme.surface,
                child: Center(
                  child: buildAnimatedBox(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.tonal(
              onPressed: onToggleSize,
              child: const Text('更新宽高'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: searchContainer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedBox() {
    return AnimatedContainer(
      duration: Duration(milliseconds: durationMs.round()),
      curve: curve,
      width: width,
      height: height,
      alignment: alignment,
      padding: usePadding ? EdgeInsets.symmetric(horizontal: padH, vertical: padV) : null,
      margin: useMargin ? EdgeInsets.symmetric(horizontal: marginH, vertical: marginV) : null,
      color: useDecoration ? null : color,
      decoration: useDecoration ? decorationOf() : null,
      foregroundDecoration: useForeground ? BoxDecoration(color: foregroundColor ?? Colors.white24) : null,
      transform: useTransform ? Matrix4.rotationZ(rotateDeg * math.pi / 180) : null,
      transformAlignment: useTransform ? transformAlignment : null,
      clipBehavior: clipBehavior,
      onEnd: () => onMark('onEnd'),
      child: useChild
          ? TextButton(
              onPressed: () => onMark('onChild'),
              child: const Text(
                'AnimatedContainer',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  Decoration decorationOf() {
    return switch (shapeKind) {
      ShapeKind.none => BoxDecoration(color: color),
      ShapeKind.rounded => BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(shapeRadius),
        ),
      ShapeKind.stadium => ShapeDecoration(
          color: color,
          shape: const StadiumBorder(),
        ),
    };
  }

  Widget searchContainer() {
    final fontColor = const Color(0xFF1A1A1A);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: NText(
            '全部标签',
            fontWeight: FontWeight.w400,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: searchWidthVN,
          builder: (context, searchWidth, child) {
            return GestureDetector(
              onTap: onSearchToggle,
              child: AnimatedContainer(
                height: 28,
                width: searchWidth,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onSearchToggle,
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage(Assets.imagesIconSearch),
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: searchController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: fontColor,
                        ),
                        maxLength: 15,
                        maxLines: 1,
                        onChanged: onSearchChanged,
                        onSubmitted: onSearchChanged,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.green,
                          hintStyle: TextStyle(color: fontColor.withValues(alpha: 0.2)),
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                          counterText: '',
                          hintText: '搜索',
                          suffixIcon: ValueListenableBuilder(
                            valueListenable: searchVN,
                            builder: (context, value, child) {
                              if (value.isEmpty) {
                                return const SizedBox();
                              }
                              return InkWell(
                                onTap: onSearchClear,
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildLayoutCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'alignment · color · decoration · child · width · height · padding · margin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'child 显示按钮',
            value: useChild,
            onChanged: (v) => onMark('useChild $v', () => useChild = v),
          ),
          const Text('alignment'),
          buildChoiceChips(
            values: AlignmentExt.allCases,
            value: alignment,
            labelOf: (e) => e.toString().split('.').last,
            onChanged: (e) => onMark('alignment $e', () => alignment = e),
          ),
          buildSwitch(
            title: 'decoration 代替 color',
            value: useDecoration,
            onChanged: (v) => onMark('useDecoration $v', () => useDecoration = v),
          ),
          if (useDecoration) ...[
            const Text('shape'),
            buildChoiceChips(
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('shapeKind ${e.name}', () => shapeKind = e),
            ),
            if (shapeKind == ShapeKind.rounded)
              buildSlider(
                label: 'shapeRadius',
                value: shapeRadius,
                min: 0,
                max: 48,
                onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
              ),
          ],
          const Text('color'),
          buildColorDots(value: color, onChanged: (e) => onMark('color ${e ?? 'null'}', () => color = e)),
          buildSlider(
            label: 'width',
            value: width,
            min: 80,
            max: 400,
            onChanged: (v) => onMark('width ${v.round()}', () => width = v),
          ),
          buildSlider(
            label: 'height',
            value: height,
            min: 80,
            max: 400,
            onChanged: (v) => onMark('height ${v.round()}', () => height = v),
          ),
          buildSwitch(
            title: 'padding 指定内边距',
            value: usePadding,
            onChanged: (v) => onMark('usePadding $v', () => usePadding = v),
          ),
          if (usePadding) ...[
            buildSlider(
              label: 'padding H',
              value: padH,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('padH ${v.round()}', () => padH = v),
            ),
            buildSlider(
              label: 'padding V',
              value: padV,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('padV ${v.round()}', () => padV = v),
            ),
          ],
          buildSwitch(
            title: 'margin 指定外边距',
            value: useMargin,
            onChanged: (v) => onMark('useMargin $v', () => useMargin = v),
          ),
          if (useMargin) ...[
            buildSlider(
              label: 'margin H',
              value: marginH,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('marginH ${v.round()}', () => marginH = v),
            ),
            buildSlider(
              label: 'margin V',
              value: marginV,
              min: 0,
              max: 32,
              onChanged: (v) => onMark('marginV ${v.round()}', () => marginV = v),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'clipBehavior · foregroundDecoration · transform · duration · curve · onEnd',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('clipBehavior'),
          buildChoiceChips(
            values: Clip.values,
            value: clipBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
          ),
          buildSwitch(
            title: 'foregroundDecoration',
            value: useForeground,
            onChanged: (v) => onMark('useForeground $v', () => useForeground = v),
          ),
          if (useForeground) ...[
            const Text('foregroundColor'),
            buildColorDots(
              value: foregroundColor,
              onChanged: (e) => onMark('foregroundColor ${e ?? 'null'}', () => foregroundColor = e),
            ),
          ],
          buildSwitch(
            title: 'transform 旋转',
            value: useTransform,
            onChanged: (v) => onMark('useTransform $v', () => useTransform = v),
          ),
          if (useTransform) ...[
            buildSlider(
              label: 'rotateDeg',
              value: rotateDeg,
              min: 0,
              max: 360,
              onChanged: (v) => onMark('rotateDeg ${v.round()}', () => rotateDeg = v),
            ),
            const Text('transformAlignment'),
            buildChoiceChips(
              values: AlignmentExt.allCases,
              value: transformAlignment,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: (e) => onMark('transformAlignment $e', () => transformAlignment = e),
            ),
          ],
          buildSlider(
            label: 'duration',
            value: durationMs,
            min: 100,
            max: 3000,
            onChanged: (v) => onMark('durationMs ${v.round()}', () => durationMs = v),
            durationLabel: true,
          ),
          const Text('curve'),
          buildChoiceChips(
            values: NDecorationCard.curvePresets,
            value: curve,
            labelOf: NDecorationCard.nameOfCurve,
            onChanged: (e) => onMark('curve ${NDecorationCard.nameOfCurve(e)}', () => curve = e),
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required T value,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = theme.colorScheme;
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
    final scheme = theme.colorScheme;
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
    bool durationLabel = false,
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
      valueBuilder: durationLabel
          ? (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
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

  void onToggleSize() {
    final toEnd = width == 200 && height == 200;
    width = toEnd ? 400 : 200;
    height = toEnd ? 400 : 200;
    color = toEnd ? Colors.green : Colors.lightBlue;
    alignment = toEnd ? Alignment.center : Alignment.topLeft;
    lastEvent = 'onToggleSize';
    DLog.d('onToggleSize');
    setState(() {});
  }

  void onSearchToggle() {
    searchExpanded = !searchExpanded;
    searchWidthVN.value = searchExpanded ? 160.0 : 28.0;
    lastEvent = 'onSearchToggle ${searchWidthVN.value}';
    DLog.d(lastEvent);
  }

  void onSearchChanged(String val) {
    searchVN.value = val;
    lastEvent = 'onSearchChanged';
    DLog.d('onSearchChanged $val');
  }

  void onSearchClear() {
    searchController.clear();
    searchVN.value = '';
    onSearchToggle();
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    width = 200;
    height = 200;
    color = Colors.lightBlue;
    alignment = Alignment.topLeft;
    curve = Curves.fastOutSlowIn;
    durationMs = 1000;
    clipBehavior = Clip.none;
    useChild = true;
    usePadding = false;
    padH = 12;
    padV = 12;
    useMargin = false;
    marginH = 8;
    marginV = 8;
    useDecoration = false;
    shapeKind = ShapeKind.rounded;
    shapeRadius = 16;
    useForeground = false;
    foregroundColor = null;
    useTransform = false;
    rotateDeg = 0;
    transformAlignment = Alignment.center;
    searchExpanded = false;
    searchWidthVN.value = 28;
    searchController.clear();
    searchVN.value = '';
    lastEvent = '—';
    setState(() {});
  }
}
