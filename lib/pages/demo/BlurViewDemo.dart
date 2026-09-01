//
//  BlurViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 9:42 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_blur_view.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 内缩圆角裁剪
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

/// clipper 预设
enum _ClipperKind {
  none(label: 'none', clipper: null),
  inset(label: 'inset', clipper: _InsetRRectClipper()),
  ;
  const _ClipperKind({required this.label, required this.clipper});
  final String label;
  final CustomClipper<RRect>? clipper;
}

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

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 原 Demo BorderRadius.circular(16)、blur 25、Clip.antiAlias
  ShapeKind shapeKind = ShapeKind.rounded;
  double shapeRadius = ShapeKind.rounded.radius;
  _ClipperKind clipperKind = _ClipperKind.none;
  Clip clipBehavior = Clip.antiAlias;
  double blur = 25;
  bool useBackdropFilter = false;
  BlendMode blendMode = BlendMode.srcOver;
  bool filterEnabled = true;
  String lastEvent = '—';

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
                            NLangEnum.en: 'Widget NBlurView',
                            NLangEnum.zh: '组件 NBlurView',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'NBlurView clips with ClipRRect then applies BackdropFilter. Default blur is 25 over Assets.imagesBg. A non-null clipper replaces borderRadius for the clip path.',
                              NLangEnum.zh:
                                  'NBlurView 先 ClipRRect 再套 BackdropFilter。默认 blur 25，背景仍是 Assets.imagesBg。clipper 非空时用它裁剪，不再用 borderRadius。',
                            },
                            {
                              NLangEnum.en:
                                  'If backdropFilter is set, blur is unused and the passed BackdropFilter must include its own child.',
                              NLangEnum.zh: '传入 backdropFilter 时 blur 不生效，且该 BackdropFilter 必须自带 child。',
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
              'blur ${blur.toStringAsFixed(0)} · ${shapeKind.label} · ${clipBehavior.name} · $lastEvent',
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
      borderRadius: shapeKind.borderRadius(roundedRadius: shapeRadius),
      clipper: clipperKind.clipper,
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

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'borderRadius · clipper · clipBehavior · blur',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (clipperKind == _ClipperKind.none) ...[
            NChoiceChipListItem<ShapeKind>(
              title: const Text('borderRadius'),
              values: ShapeKind.values,
              value: shapeKind,
              labelOf: (e) => e.label,
              onChanged: (e) => onMark('borderRadius ${e.label}', () {
                shapeKind = e;
                if (e == ShapeKind.rounded) {
                  shapeRadius = e.radius;
                }
              }),
            ),
            if (shapeKind == ShapeKind.rounded)
              NSliderListItem(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('radius'),
                min: 0,
                max: 48,
                value: shapeRadius.clamp(0, 48),
                onChanged: (v) => onMark('radius ${v.round()}', () => shapeRadius = v),
                activeColor: theme.colorScheme.primary,
              ),
            const SizedBox(height: 8),
          ],
          NChoiceChipListItem<_ClipperKind>(
            title: const Text('clipper'),
            values: _ClipperKind.values,
            value: clipperKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('clipper ${e.label}', () => clipperKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<Clip>(
            title: const Text('clipBehavior'),
            values: Clip.values,
            value: clipBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('blur'),
            min: 0,
            max: 50,
            value: blur.clamp(0, 50),
            onChanged: (v) => onMark('blur ${v.toStringAsFixed(1)}', () => blur = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'backdropFilter · blendMode · enabled',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListItem(
            title: const Text('backdropFilter'),
            value: useBackdropFilter,
            onChanged: (v) => onMark('backdropFilter $v', () => useBackdropFilter = v),
          ),
          if (useBackdropFilter) ...[
            NSwitchListItem(
              title: const Text('enabled'),
              value: filterEnabled,
              onChanged: (v) => onMark('enabled $v', () => filterEnabled = v),
            ),
            const SizedBox(height: 8),
            NChoiceChipListItem<BlendMode>(
              title: const Text('blendMode'),
              values: BlendMode.values,
              value: blendMode,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('blendMode ${e.name}', () => blendMode = e),
            ),
          ],
        ],
      ),
    );
  }


  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    shapeKind = ShapeKind.rounded;
    shapeRadius = ShapeKind.rounded.radius;
    clipperKind = _ClipperKind.none;
    clipBehavior = Clip.antiAlias;
    blur = 25;
    useBackdropFilter = false;
    blendMode = BlendMode.srcOver;
    filterEnabled = true;
    lastEvent = '—';
    setState(() {});
  }
}
