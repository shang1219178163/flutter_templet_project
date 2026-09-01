//
//  AnimatedContainerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 12:19 PM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
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

  /// decoration 模式：stadium 用 ShapeDecoration，其余用 BoxDecoration
  Decoration decorationOf() {
    if (shapeKind == ShapeKind.stadium) {
      return ShapeDecoration(color: color, shape: shapeKind.shape()!);
    }
    return BoxDecoration(
      color: color,
      borderRadius: shapeKind == ShapeKind.none ? null : shapeKind.borderRadius(roundedRadius: shapeRadius),
    );
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
          NSwitchListTile(
            title: const Text('child 显示按钮'),
            value: useChild,
            onChanged: (v) => onMark('useChild $v', () => useChild = v),
          ),
          NChoiceChipListItem(
            title: const Text('alignment'),
            values: AlignmentExt.allCases,
            value: alignment,
            labelOf: (e) => e.toString().split('.').last,
            onChanged: (e) => onMark('alignment $e', () => alignment = e),
          ),
          NSwitchListTile(
            title: const Text('decoration 代替 color'),
            value: useDecoration,
            onChanged: (v) => onMark('useDecoration $v', () => useDecoration = v),
          ),
          if (useDecoration) ...[
            NChoiceChipListItem(
              title: const Text('shape'),
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('shapeKind ${e.label}', () => shapeKind = e),
            ),
            if (shapeKind == ShapeKind.rounded)
              NSliderListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('shapeRadius'),
                min: 0,
                max: 48,
                value: shapeRadius.clamp(0, 48),
                onChanged: (v) => onMark('shapeRadius ${v.round()}', () => shapeRadius = v),
                activeColor: theme.colorScheme.primary,
              ),
          ],
          NChoiceColorListItem(
            title: const Text('color'),
            value: color,
            onChanged: (e) => onMark('color ${e ?? 'null'}', () => color = e),
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('width'),
            min: 80,
            max: 400,
            value: width.clamp(80, 400),
            onChanged: (v) => onMark('width ${v.round()}', () => width = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('height'),
            min: 80,
            max: 400,
            value: height.clamp(80, 400),
            onChanged: (v) => onMark('height ${v.round()}', () => height = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSwitchListTile(
            title: const Text('padding 指定内边距'),
            value: usePadding,
            onChanged: (v) => onMark('usePadding $v', () => usePadding = v),
          ),
          if (usePadding) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding H'),
              min: 0,
              max: 32,
              value: padH.clamp(0, 32),
              onChanged: (v) => onMark('padH ${v.round()}', () => padH = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('padding V'),
              min: 0,
              max: 32,
              value: padV.clamp(0, 32),
              onChanged: (v) => onMark('padV ${v.round()}', () => padV = v),
              activeColor: theme.colorScheme.primary,
            ),
          ],
          NSwitchListTile(
            title: const Text('margin 指定外边距'),
            value: useMargin,
            onChanged: (v) => onMark('useMargin $v', () => useMargin = v),
          ),
          if (useMargin) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('margin H'),
              min: 0,
              max: 32,
              value: marginH.clamp(0, 32),
              onChanged: (v) => onMark('marginH ${v.round()}', () => marginH = v),
              activeColor: theme.colorScheme.primary,
            ),
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('margin V'),
              min: 0,
              max: 32,
              value: marginV.clamp(0, 32),
              onChanged: (v) => onMark('marginV ${v.round()}', () => marginV = v),
              activeColor: theme.colorScheme.primary,
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
          NChoiceChipListItem(
            title: const Text('clipBehavior'),
            values: Clip.values,
            value: clipBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
          ),
          NSwitchListTile(
            title: const Text('foregroundDecoration'),
            value: useForeground,
            onChanged: (v) => onMark('useForeground $v', () => useForeground = v),
          ),
          if (useForeground) ...[
            NChoiceColorListItem(
              title: const Text('foregroundColor'),
              value: foregroundColor,
              onChanged: (e) => onMark('foregroundColor ${e ?? 'null'}', () => foregroundColor = e),
            ),
          ],
          NSwitchListTile(
            title: const Text('transform 旋转'),
            value: useTransform,
            onChanged: (v) => onMark('useTransform $v', () => useTransform = v),
          ),
          if (useTransform) ...[
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('rotateDeg'),
              min: 0,
              max: 360,
              value: rotateDeg.clamp(0, 360),
              onChanged: (v) => onMark('rotateDeg ${v.round()}', () => rotateDeg = v),
              activeColor: theme.colorScheme.primary,
            ),
            NChoiceChipListItem(
              title: const Text('transformAlignment'),
              values: AlignmentExt.allCases,
              value: transformAlignment,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: (e) => onMark('transformAlignment $e', () => transformAlignment = e),
            ),
          ],
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('duration'),
            min: 100,
            max: 3000,
            value: durationMs.clamp(100, 3000),
            onChanged: (v) => onMark('durationMs ${v.round()}', () => durationMs = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          NChoiceChipListItem(
            title: const Text('curve'),
            values: NDecorationCard.curvePresets,
            value: curve,
            labelOf: NDecorationCard.nameOfCurve,
            onChanged: (e) => onMark('curve ${NDecorationCard.nameOfCurve(e)}', () => curve = e),
          ),
        ],
      ),
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
