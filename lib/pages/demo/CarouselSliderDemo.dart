//
//  CarouselSliderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 5:00 PM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

// import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// 构造方式
enum _SliderKind { items, builder }

/// 滚动物理
enum _PhysicsKind { platform, bouncing, clamping, never }

class CarouselSliderDemo extends StatefulWidget {
  const CarouselSliderDemo({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<CarouselSliderDemo> createState() => _CarouselSliderDemoState();
}

class _CarouselSliderDemoState extends State<CarouselSliderDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  CarouselSliderController carouselController = CarouselSliderController();

  final imgList = <String>[
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  ];

  _SliderKind kind = _SliderKind.items;
  Axis scrollDirection = Axis.horizontal;
  CenterPageEnlargeStrategy enlargeStrategy = CenterPageEnlargeStrategy.height;
  Clip clipBehavior = Clip.hardEdge;
  _PhysicsKind physicsKind = _PhysicsKind.platform;
  Curve autoPlayCurve = Curves.fastOutSlowIn;

  bool useHeight = false;
  bool reverse = false;
  bool autoPlay = true;
  bool enlargeCenterPage = true;
  bool enableInfiniteScroll = true;
  bool animateToClosest = true;
  bool pageSnapping = true;
  bool pauseAutoPlayOnTouch = true;
  bool pauseAutoPlayOnManualNavigate = true;
  bool pauseAutoPlayInFiniteScroll = false;
  bool disableCenter = false;
  bool padEnds = true;
  bool disableGesture = false;

  double height = 200;
  double aspectRatio = 2.0;
  double viewportFraction = 0.8;
  double enlargeFactor = 0.3;
  double autoPlayIntervalSec = 4;
  double autoPlayAnimationMs = 800;
  int initialPage = 0;
  int currentPage = 0;
  CarouselPageChangedReason? pageChangedReason;
  String lastEvent = '—';

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
          return Column(
            children: [
              buildPreview(constraints),
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
                            NLangEnum.en: 'Widget CarouselSlider',
                            NLangEnum.zh: '组件 CarouselSlider',
                          },
                          items: [
                            {
                              NLangEnum.en: 'Pin a live preview while you tune every CarouselOptions argument below.',
                              NLangEnum.zh: '上方固定预览，下方调节全部 CarouselOptions 参数并即时生效。',
                            },
                            {
                              NLangEnum.en:
                                  'Switch between CarouselSlider and CarouselSlider.builder without losing the original images.',
                              NLangEnum.zh: '可切换 CarouselSlider 与 CarouselSlider.builder，保留原 Demo 图片。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildSurfaceCard(),
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

  double previewCarouselHeight(BoxConstraints constraints) {
    const statusExtent = 52.0;
    const minPanel = 180.0;
    final maxCarousel = math.max(120.0, constraints.maxHeight - statusExtent - minPanel);
    final wanted = useHeight ? height : constraints.maxWidth / aspectRatio;
    return wanted.clamp(120.0, maxCarousel);
  }

  Widget buildPreview(BoxConstraints constraints) {
    final scheme = theme.colorScheme;
    final carouselHeight = previewCarouselHeight(constraints);
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
            height: carouselHeight,
            width: double.infinity,
            child: buildCarousel(carouselHeight),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'onPageChanged: $currentPage  ${pageChangedReason?.name ?? ''} · $lastEvent',
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

  Widget buildCarousel(double carouselHeight) {
    final options = CarouselOptions(
      height: carouselHeight,
      aspectRatio: aspectRatio,
      viewportFraction: viewportFraction,
      initialPage: initialPage,
      enableInfiniteScroll: enableInfiniteScroll,
      animateToClosest: animateToClosest,
      reverse: reverse,
      autoPlay: autoPlay,
      autoPlayInterval: Duration(seconds: autoPlayIntervalSec.round()),
      autoPlayAnimationDuration: Duration(milliseconds: autoPlayAnimationMs.round()),
      autoPlayCurve: autoPlayCurve,
      enlargeCenterPage: enlargeCenterPage,
      enlargeStrategy: enlargeStrategy,
      enlargeFactor: enlargeFactor,
      scrollDirection: scrollDirection,
      pageSnapping: pageSnapping,
      pauseAutoPlayOnTouch: pauseAutoPlayOnTouch,
      pauseAutoPlayOnManualNavigate: pauseAutoPlayOnManualNavigate,
      pauseAutoPlayInFiniteScroll: pauseAutoPlayInFiniteScroll,
      disableCenter: disableCenter,
      padEnds: padEnds,
      clipBehavior: clipBehavior,
      scrollPhysics: buildScrollPhysics(),
      onPageChanged: onPageChanged,
    );
    final key = ValueKey('$kind-$scrollDirection-$reverse-$initialPage-$useHeight');
    if (kind == _SliderKind.builder) {
      return CarouselSlider.builder(
        key: key,
        carouselController: carouselController,
        disableGesture: disableGesture,
        itemCount: imgList.length,
        options: options,
        itemBuilder: (context, index, realIndex) {
          return buildSlide(url: imgList[index], index: index);
        },
      );
    }
    return CarouselSlider(
      key: key,
      carouselController: carouselController,
      disableGesture: disableGesture,
      options: options,
      items: List<Widget>.generate(imgList.length, (index) {
        return buildSlide(url: imgList[index], index: index);
      }),
    );
  }

  ScrollPhysics? buildScrollPhysics() {
    switch (physicsKind) {
      case _PhysicsKind.platform:
        return null;
      case _PhysicsKind.bouncing:
        return const BouncingScrollPhysics();
      case _PhysicsKind.clamping:
        return const ClampingScrollPhysics();
      case _PhysicsKind.never:
        return const NeverScrollableScrollPhysics();
    }
  }

  Widget buildSlide({required String url, required int index}) {
    return InkWell(
      onTap: () => onItemTap(index),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeInImage(
                image: NetworkImage(url),
                placeholder: const AssetImage('assets/images/img_placeholder.png'),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'No. $index image',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造与尺寸',
      subtitle: 'constructor · height · aspectRatio · viewportFraction',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: '构造方式',
            child: buildChoiceChips(
              values: _SliderKind.values,
              isSelected: (e) => kind == e,
              labelOf: (e) => e == _SliderKind.items ? 'CarouselSlider' : 'CarouselSlider.builder',
              onChanged: onKind,
            ),
          ),
          buildField(
            label: 'scrollDirection',
            showTopGap: true,
            child: buildChoiceChips(
              values: Axis.values,
              isSelected: (e) => scrollDirection == e,
              labelOf: (e) => e.name,
              onChanged: onScrollDirection,
            ),
          ),
          buildSwitch(title: 'useHeight 使用 height（覆盖 aspectRatio）', value: useHeight, onChanged: onUseHeight),
          if (useHeight)
            buildSlider(
              label: 'height',
              value: height,
              min: 120,
              max: 400,
              onChanged: (v) => onMark('height ${v.round()}', () => height = v),
            )
          else
            buildSlider(
              label: 'aspectRatio',
              value: aspectRatio,
              min: 0.5,
              max: 2.5,
              onChanged: (v) => onMark('aspectRatio ${v.toStringAsFixed(2)}', () => aspectRatio = v),
              format: (v) => v.toStringAsFixed(2),
            ),
          buildSlider(
            label: 'viewportFraction',
            value: viewportFraction,
            min: 0.3,
            max: 1.0,
            onChanged: (v) => onMark('viewportFraction ${v.toStringAsFixed(2)}', () => viewportFraction = v),
            format: (v) => v.toStringAsFixed(2),
          ),
          buildSlider(
            label: 'initialPage',
            value: initialPage.toDouble(),
            min: 0,
            max: (imgList.length - 1).toDouble(),
            onChanged: onInitialPage,
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面与播放',
      subtitle: 'enlargeCenterPage · autoPlay · clipBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'enlargeCenterPage 中间放大',
            value: enlargeCenterPage,
            onChanged: (v) => onMark('enlargeCenterPage $v', () => enlargeCenterPage = v),
          ),
          if (enlargeCenterPage) ...[
            buildField(
              label: 'enlargeStrategy',
              showTopGap: true,
              child: buildChoiceChips(
                values: CenterPageEnlargeStrategy.values,
                isSelected: (e) => enlargeStrategy == e,
                labelOf: (e) => e.name,
                onChanged: (e) => onMark('enlargeStrategy ${e.name}', () => enlargeStrategy = e),
              ),
            ),
            buildSlider(
              label: 'enlargeFactor',
              value: enlargeFactor,
              min: 0,
              max: 1,
              onChanged: (v) => onMark('enlargeFactor ${v.toStringAsFixed(2)}', () => enlargeFactor = v),
              format: (v) => v.toStringAsFixed(2),
            ),
          ],
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [Clip.none, Clip.hardEdge, Clip.antiAlias, Clip.antiAliasWithSaveLayer],
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
            ),
          ),
          buildSwitch(
            title: 'autoPlay 自动播放',
            value: autoPlay,
            onChanged: (v) => onMark('autoPlay $v', () => autoPlay = v),
          ),
          if (autoPlay) ...[
            buildSlider(
              label: 'autoPlayInterval',
              value: autoPlayIntervalSec,
              min: 1,
              max: 10,
              onChanged: (v) => onMark('autoPlayInterval ${v.round()}s', () => autoPlayIntervalSec = v),
              format: (v) => '${v.round()}s',
            ),
            buildSlider(
              label: 'autoPlayAnim',
              value: autoPlayAnimationMs,
              min: 200,
              max: 2000,
              onChanged: (v) => onMark('autoPlayAnim ${v.round()}ms', () => autoPlayAnimationMs = v),
              format: (v) => '${(v / 1000).round().toStringAsFixed(1)}s',
            ),
            buildField(
              label: 'autoPlayCurve',
              showTopGap: true,
              child: buildChoiceChips(
                values: NDecorationCard.curvePresets,
                isSelected: (e) => e == autoPlayCurve,
                labelOf: (e) => NDecorationCard.nameOfCurve(e),
                onChanged: (e) => onMark('autoPlayCurve ${NDecorationCard.nameOfCurve(e)}', () => autoPlayCurve = e),
              ),
            ),
            buildSwitch(
              title: 'pauseAutoPlayOnTouch 触摸暂停',
              value: pauseAutoPlayOnTouch,
              onChanged: (v) => onMark('pauseAutoPlayOnTouch $v', () => pauseAutoPlayOnTouch = v),
            ),
            buildSwitch(
              title: 'pauseAutoPlayOnManualNavigate 手动切换暂停',
              value: pauseAutoPlayOnManualNavigate,
              onChanged: (v) => onMark('pauseAutoPlayOnManualNavigate $v', () => pauseAutoPlayOnManualNavigate = v),
            ),
            buildSwitch(
              title: 'pauseAutoPlayInFiniteScroll 有限滚动到底暂停',
              value: pauseAutoPlayInFiniteScroll,
              onChanged: (v) => onMark('pauseAutoPlayInFiniteScroll $v', () => pauseAutoPlayInFiniteScroll = v),
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
      subtitle: 'scrollPhysics · reverse · pageSnapping · padEnds',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'scrollPhysics',
            child: buildChoiceChips(
              values: _PhysicsKind.values,
              isSelected: (e) => physicsKind == e,
              labelOf: (e) => e.name,
              onChanged: (e) => onMark('scrollPhysics ${e.name}', () => physicsKind = e),
            ),
          ),
          buildSwitch(title: 'enableInfiniteScroll 无限循环', value: enableInfiniteScroll, onChanged: onEnableInfiniteScroll),
          buildSwitch(
            title: 'animateToClosest 滚到最近页',
            value: animateToClosest,
            onChanged: (v) => onMark('animateToClosest $v', () => animateToClosest = v),
          ),
          buildSwitch(title: 'reverse 反向', value: reverse, onChanged: onReverse),
          buildSwitch(
            title: 'pageSnapping 整页吸附',
            value: pageSnapping,
            onChanged: (v) => onMark('pageSnapping $v', () => pageSnapping = v),
          ),
          buildSwitch(
            title: 'disableCenter 取消居中',
            value: disableCenter,
            onChanged: (v) => onMark('disableCenter $v', () => disableCenter = v),
          ),
          buildSwitch(
            title: 'padEnds 两端留白',
            value: padEnds,
            onChanged: (v) => onMark('padEnds $v', () => padEnds = v),
          ),
          buildSwitch(
            title: 'disableGesture 禁用手势',
            value: disableGesture,
            onChanged: (v) => onMark('disableGesture $v', () => disableGesture = v),
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
    final scheme = theme.colorScheme;
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
    String Function(double value)? format,
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
      valueBuilder: format == null
          ? null
          : (context, v) => SizedBox(
                width: 36,
                child: Text(
                  format(v),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
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

  void onResetCarouselController() {
    carouselController = CarouselSliderController();
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    kind = _SliderKind.items;
    scrollDirection = Axis.horizontal;
    enlargeStrategy = CenterPageEnlargeStrategy.height;
    clipBehavior = Clip.hardEdge;
    physicsKind = _PhysicsKind.platform;
    autoPlayCurve = Curves.fastOutSlowIn;
    useHeight = false;
    reverse = false;
    autoPlay = true;
    enlargeCenterPage = true;
    enableInfiniteScroll = true;
    animateToClosest = true;
    pageSnapping = true;
    pauseAutoPlayOnTouch = true;
    pauseAutoPlayOnManualNavigate = true;
    pauseAutoPlayInFiniteScroll = false;
    disableCenter = false;
    padEnds = true;
    disableGesture = false;
    height = 200;
    aspectRatio = 1.20;
    viewportFraction = 0.8;
    enlargeFactor = 0.3;
    autoPlayIntervalSec = 4;
    autoPlayAnimationMs = 800;
    initialPage = 0;
    currentPage = 0;
    pageChangedReason = null;
    lastEvent = '—';
    onResetCarouselController();
    setState(() {});
  }

  void onKind(_SliderKind value) {
    onMark('kind ${value.name}', () {
      kind = value;
      onResetCarouselController();
    });
  }

  void onScrollDirection(Axis value) {
    onMark('scrollDirection ${value.name}', () {
      scrollDirection = value;
      if (value == Axis.vertical && !useHeight) {
        useHeight = true;
        height = 360;
      }
      onResetCarouselController();
    });
  }

  void onUseHeight(bool value) {
    onMark('useHeight $value', () {
      useHeight = value;
      onResetCarouselController();
    });
  }

  void onInitialPage(double value) {
    onMark('initialPage ${value.round()}', () {
      initialPage = value.round().clamp(0, imgList.length - 1);
      currentPage = initialPage;
      onResetCarouselController();
    });
  }

  void onEnableInfiniteScroll(bool value) {
    onMark('enableInfiniteScroll $value', () {
      enableInfiniteScroll = value;
      onResetCarouselController();
    });
  }

  void onReverse(bool value) {
    onMark('reverse $value', () {
      reverse = value;
      onResetCarouselController();
    });
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    currentPage = index;
    pageChangedReason = reason;
    setState(() {});
  }

  void onItemTap(int index) {
    lastEvent = 'onTap $index';
    DLog.d('CarouselSlider onTap: $index');
    SnackUtil.show('onTap No. $index image');
    setState(() {});
  }
}
