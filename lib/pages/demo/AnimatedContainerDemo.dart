//
//  AnimatedContainerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 12:19 PM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
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

  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final searchVN = ValueNotifier('');
  final searchWidthVN = ValueNotifier(28.0);

  /// 原 Demo 起始 200×200 lightBlue topLeft
  double width = 200;
  double height = 200;
  Color? color = Colors.lightBlue;
  Alignment alignment = Alignment.topLeft;
  Curve curve = Curves.fastOutSlowIn;
  double durationMs = 1000;
  Clip clipBehavior = Clip.none;
  bool useChild = true;
  bool usePadding = false;
  double padH = 12;
  double padV = 12;
  bool useMargin = false;
  double marginH = 8;
  double marginV = 8;
  bool useDecoration = false;
  ShapeKind shapeKind = ShapeKind.rounded;
  double shapeRadius = 16;
  bool useForeground = false;
  Color? foregroundColor;
  bool useTransform = false;
  double rotateDeg = 0;
  Alignment transformAlignment = Alignment.center;
  bool searchExpanded = false;
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
                                  'Changing constructor values animates to the new layout. Tap 更新宽高 for the original 200↔400 toggle.',
                              NLangEnum.zh: '改构造参数会动画过渡到新布局。点「更新宽高」即原来的 200↔400、颜色和对齐切换。',
                            },
                            {
                              NLangEnum.en:
                                  'color and decoration cannot both be set. onEnd fires when the animation finishes.',
                              NLangEnum.zh: 'color 与 decoration 不能同时传。动画结束会触发 onEnd。',
                            },
                            {
                              NLangEnum.en:
                                  'The search pill below the box is the original second AnimatedContainer example.',
                              NLangEnum.zh: '色块下方的搜索条是原 Demo 的第二个 AnimatedContainer 示例。',
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
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final theme = Theme.of(context);
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
      onEnd: onEnd,
      child: useChild
          ? TextButton(
              onPressed: onChild,
              child: const Text(
                'AnimatedContainer',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  Decoration decorationOf() {
    switch (shapeKind) {
      case ShapeKind.none:
        return BoxDecoration(color: color);
      case ShapeKind.rounded:
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(shapeRadius),
        );
      case ShapeKind.stadium:
        return ShapeDecoration(
          color: color,
          shape: const StadiumBorder(),
        );
    }
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

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'alignment · color · decoration · child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(title: 'child 显示按钮', value: useChild, onChanged: onUseChild),
          buildField(
            label: 'alignment',
            showTopGap: true,
            child: buildChoiceChips(
              values: AlignmentExt.allCases,
              isSelected: (e) => alignment == e,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: onAlignment,
            ),
          ),
          buildSwitch(title: 'decoration 代替 color', value: useDecoration, onChanged: onUseDecoration),
          if (useDecoration) ...[
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
              buildSlider(label: 'shapeRadius', value: shapeRadius, min: 0, max: 48, onChanged: onShapeRadius),
          ],
          buildField(
            label: 'color',
            showTopGap: true,
            child: buildColorDots(value: color, onChanged: onColor),
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面',
      subtitle: 'foregroundDecoration · clipBehavior · transform',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'clipBehavior',
            child: buildChoiceChips(
              values: Clip.values,
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onClipBehavior,
            ),
          ),
          buildSwitch(title: 'foregroundDecoration', value: useForeground, onChanged: onUseForeground),
          if (useForeground)
            buildField(
              label: 'foregroundColor',
              showTopGap: true,
              child: buildColorDots(value: foregroundColor, onChanged: onForegroundColor),
            ),
          buildSwitch(title: 'transform 旋转', value: useTransform, onChanged: onUseTransform),
          if (useTransform) ...[
            buildSlider(label: 'rotateDeg', value: rotateDeg, min: 0, max: 360, onChanged: onRotateDeg),
            buildField(
              label: 'transformAlignment',
              showTopGap: true,
              child: buildChoiceChips(
                values: AlignmentExt.allCases,
                isSelected: (e) => transformAlignment == e,
                labelOf: (e) => e.toString().split('.').last,
                onChanged: onTransformAlignment,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildSizeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'width · height · padding · margin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(label: 'width', value: width, min: 80, max: 400, onChanged: onWidth),
          buildSlider(label: 'height', value: height, min: 80, max: 400, onChanged: onHeight),
          buildSwitch(title: 'padding 指定内边距', value: usePadding, onChanged: onUsePadding),
          if (usePadding) ...[
            buildSlider(label: 'padding H', value: padH, min: 0, max: 32, onChanged: onPadH),
            buildSlider(label: 'padding V', value: padV, min: 0, max: 32, onChanged: onPadV),
          ],
          buildSwitch(title: 'margin 指定外边距', value: useMargin, onChanged: onUseMargin),
          if (useMargin) ...[
            buildSlider(label: 'margin H', value: marginH, min: 0, max: 32, onChanged: onMarginH),
            buildSlider(label: 'margin V', value: marginV, min: 0, max: 32, onChanged: onMarginV),
          ],
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'duration · curve · onEnd',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'duration',
            value: durationMs,
            min: 100,
            max: 3000,
            onChanged: onDurationMs,
            durationLabel: true,
          ),
          buildField(
            label: 'curve',
            showTopGap: true,
            child: buildChoiceChips(
              values: NDecorationCard.curvePresets,
              isSelected: (e) => identical(curve, e),
              labelOf: NDecorationCard.nameOfCurve,
              onChanged: onCurve,
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
    bool durationLabel = false,
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
      trailingBuilder: durationLabel
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

  void onChild() {
    lastEvent = 'onChild';
    DLog.d('onChild');
    setState(() {});
  }

  void onEnd() {
    lastEvent = 'onEnd';
    DLog.d('onEnd');
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

  void onUseChild(bool value) {
    useChild = value;
    setState(() {});
  }

  void onAlignment(Alignment value) {
    alignment = value;
    setState(() {});
  }

  void onUseDecoration(bool value) {
    useDecoration = value;
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

  void onColor(Color? value) {
    color = value;
    setState(() {});
  }

  void onClipBehavior(Clip value) {
    clipBehavior = value;
    setState(() {});
  }

  void onUseForeground(bool value) {
    useForeground = value;
    setState(() {});
  }

  void onForegroundColor(Color? value) {
    foregroundColor = value;
    setState(() {});
  }

  void onUseTransform(bool value) {
    useTransform = value;
    setState(() {});
  }

  void onRotateDeg(double value) {
    rotateDeg = value;
    setState(() {});
  }

  void onTransformAlignment(Alignment value) {
    transformAlignment = value;
    setState(() {});
  }

  void onWidth(double value) {
    width = value;
    setState(() {});
  }

  void onHeight(double value) {
    height = value;
    setState(() {});
  }

  void onUsePadding(bool value) {
    usePadding = value;
    setState(() {});
  }

  void onPadH(double value) {
    padH = value;
    setState(() {});
  }

  void onPadV(double value) {
    padV = value;
    setState(() {});
  }

  void onUseMargin(bool value) {
    useMargin = value;
    setState(() {});
  }

  void onMarginH(double value) {
    marginH = value;
    setState(() {});
  }

  void onMarginV(double value) {
    marginV = value;
    setState(() {});
  }

  void onDurationMs(double value) {
    durationMs = value;
    setState(() {});
  }

  void onCurve(Curve value) {
    curve = value;
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
