//
//  BlurViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 9:42 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_blur_view.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_style_card.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:get/get.dart';

/// clipper 预设
enum _ClipperKind { none, inset }

class BlurViewDemo extends StatefulWidget {
  const BlurViewDemo({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  State<BlurViewDemo> createState() => _BlurViewDemoState();
}

class _BlurViewDemoState extends State<BlurViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 原 Demo BorderRadius.circular(16)、blur 25、Clip.antiAlias
  ShapeKind shapeKind = ShapeKind.rounded;
  double shapeRadius = 16;
  _ClipperKind clipperKind = _ClipperKind.none;
  Clip clipBehavior = Clip.antiAlias;
  double blur = 25;
  bool useBackdropFilter = false;
  BlendMode blendMode = BlendMode.srcOver;
  bool filterEnabled = true;

  static const _title = 'BackdropFilter class';
  static const _message =
      'A widget that applies a filter to the existing painted content and then paints child.'
      'The filter will be applied to all the area within its parent or ancestor widget\'s clip. If there\'s no clip, the filter will be applied to the full screen.';

  @override
  void dispose() {
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
                            NLangEnum.en: 'Widget NBlurView',
                            NLangEnum.zh: '组件 NBlurView',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'NBlurView clips with ClipRRect then applies BackdropFilter. Default blur is 25 over Assets.imagesBg.',
                              NLangEnum.zh: 'NBlurView 先 ClipRRect 再套 BackdropFilter。默认 blur 25，背景仍是 Assets.imagesBg。',
                            },
                            {
                              NLangEnum.en:
                                  'If backdropFilter is set, blur is unused and the passed BackdropFilter must include its own child.',
                              NLangEnum.zh: '传入 backdropFilter 时 blur 不生效，且该 BackdropFilter 必须自带 child。',
                            },
                            {
                              NLangEnum.en:
                                  'A non-null clipper replaces borderRadius for the clip path.',
                              NLangEnum.zh: 'clipper 非空时用它裁剪，不再用 borderRadius。',
                            },
                          ],
                        ),
                        buildConstructCard(),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Image(
                    image: AssetImage(Assets.imagesBg),
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SingleChildScrollView(
                        child: buildBlurView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              'blur ${blur.toStringAsFixed(0)} · ${shapeKind.name} · ${clipBehavior.name}',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBlurView() {
    final frost = buildFrostChild();
    return NBlurView(
      borderRadius: borderRadiusOf(),
      clipper: clipperOf(),
      clipBehavior: clipBehavior,
      blur: blur,
      backdropFilter: useBackdropFilter
          ? BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              blendMode: blendMode,
              enabled: filterEnabled,
              child: frost,
            )
          : null,
      child: frost,
    );
  }

  Widget buildFrostChild() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              _message,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadiusGeometry borderRadiusOf() {
    switch (shapeKind) {
      case ShapeKind.none:
        return BorderRadius.zero;
      case ShapeKind.rounded:
        return BorderRadius.circular(shapeRadius);
      case ShapeKind.stadium:
        return BorderRadius.circular(999);
    }
  }

  CustomClipper<RRect>? clipperOf() {
    switch (clipperKind) {
      case _ClipperKind.none:
        return null;
      case _ClipperKind.inset:
        return const _InsetRRectClipper();
    }
  }

  Widget buildConstructCard() {
    return NStyleCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'borderRadius · clipper · clipBehavior · child · backdropFilter · blur',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (clipperKind == _ClipperKind.none) ...[
            buildField(
              label: 'borderRadius',
              child: buildChoiceChips(
                values: ShapeKind.values,
                isSelected: (e) => shapeKind == e,
                labelOf: (e) => e.name,
                onChanged: onShapeKind,
              ),
            ),
            if (shapeKind == ShapeKind.rounded)
              buildSlider(
                label: 'radius',
                value: shapeRadius,
                min: 0,
                max: 48,
                onChanged: onShapeRadius,
              ),
          ],
          buildField(
            label: 'clipper',
            showTopGap: clipperKind == _ClipperKind.none,
            child: buildChoiceChips(
              values: _ClipperKind.values,
              isSelected: (e) => clipperKind == e,
              labelOf: (e) => e.name,
              onChanged: onClipperKind,
            ),
          ),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: Clip.values,
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onClipBehavior,
            ),
          ),
          buildSwitch(
            title: 'backdropFilter',
            value: useBackdropFilter,
            onChanged: onUseBackdropFilter,
          ),
          if (!useBackdropFilter)
            buildSlider(
              label: 'blur',
              value: blur,
              min: 0,
              max: 50,
              onChanged: onBlur,
              fractionDigits: 1,
            ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    if (!useBackdropFilter) {
      return const SizedBox.shrink();
    }
    return NStyleCard(
      icon: const Icon(Icons.tune_rounded),
      title: 'backdropFilter',
      subtitle: 'filter · blendMode · enabled',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'blur',
            value: blur,
            min: 0,
            max: 50,
            onChanged: onBlur,
            fractionDigits: 1,
          ),
          buildSwitch(
            title: 'enabled',
            value: filterEnabled,
            onChanged: onFilterEnabled,
          ),
          buildField(
            label: 'blendMode',
            showTopGap: true,
            child: buildChoiceChips(
              values: BlendMode.values,
              isSelected: (e) => blendMode == e,
              labelOf: (e) => e.name,
              onChanged: onBlendMode,
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

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    int fractionDigits = 0,
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
      inactiveColor: Colors.black12,
      trailingBuilder: fractionDigits > 0
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

  void onShapeKind(ShapeKind value) {
    shapeKind = value;
    setState(() {});
  }

  void onShapeRadius(double value) {
    shapeRadius = value;
    setState(() {});
  }

  void onClipperKind(_ClipperKind value) {
    clipperKind = value;
    setState(() {});
  }

  void onClipBehavior(Clip value) {
    clipBehavior = value;
    setState(() {});
  }

  void onUseBackdropFilter(bool value) {
    useBackdropFilter = value;
    setState(() {});
  }

  void onBlur(double value) {
    blur = value;
    setState(() {});
  }

  void onFilterEnabled(bool value) {
    filterEnabled = value;
    setState(() {});
  }

  void onBlendMode(BlendMode value) {
    blendMode = value;
    setState(() {});
  }

  void onReset() {
    shapeKind = ShapeKind.rounded;
    shapeRadius = 16;
    clipperKind = _ClipperKind.none;
    clipBehavior = Clip.antiAlias;
    blur = 25;
    useBackdropFilter = false;
    blendMode = BlendMode.srcOver;
    filterEnabled = true;
    setState(() {});
  }
}

class _InsetRRectClipper extends CustomClipper<RRect> {
  const _InsetRRectClipper();

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(12, 12, size.width - 24, size.height - 24),
      const Radius.circular(16),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
