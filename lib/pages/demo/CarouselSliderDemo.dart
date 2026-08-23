//
//  CarouselSliderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 5:00 PM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

// import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
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

  final curvePresets = <(String, Curve)>[
    ('fastOutSlowIn', Curves.fastOutSlowIn),
    ('linear', Curves.linear),
    ('easeInOut', Curves.easeInOut),
    ('easeOut', Curves.easeOut),
    ('bounceOut', Curves.bounceOut),
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
  double aspectRatio = 1.20;
  double viewportFraction = 0.8;
  double enlargeFactor = 0.3;
  double autoPlayIntervalSec = 4;
  double autoPlayAnimationMs = 800;
  int initialPage = 0;
  int currentPage = 0;
  CarouselPageChangedReason? pageChangedReason;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: const Text('重置', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
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
                  buildChoiceChips(
                    title: '构造方式',
                    items: _SliderKind.values,
                    value: kind,
                    nameOf: (e) => e == _SliderKind.items ? 'CarouselSlider' : 'CarouselSlider.builder',
                    onChanged: onKind,
                  ),
                  buildChoiceChips(
                    title: 'scrollDirection 滚动方向',
                    items: Axis.values,
                    value: scrollDirection,
                    nameOf: (e) => e.name,
                    onChanged: onScrollDirection,
                  ),
                  buildChoiceChips(
                    title: 'enlargeStrategy 中间放大',
                    items: CenterPageEnlargeStrategy.values,
                    value: enlargeStrategy,
                    nameOf: (e) => e.name,
                    onChanged: onEnlargeStrategy,
                  ),
                  buildChoiceChips(
                    title: 'autoPlayCurve 动画曲线',
                    items: curvePresets,
                    value: curvePresets.firstWhere((e) => e.$2 == autoPlayCurve, orElse: () => curvePresets.first),
                    nameOf: (e) => e.$1,
                    onChanged: onAutoPlayCurve,
                  ),
                  buildChoiceChips(
                    title: 'clipBehavior 裁剪',
                    items: const [Clip.none, Clip.hardEdge, Clip.antiAlias, Clip.antiAliasWithSaveLayer],
                    value: clipBehavior,
                    nameOf: (e) => e.name,
                    onChanged: onClipBehavior,
                  ),
                  buildChoiceChips(
                    title: 'scrollPhysics 滚动物理',
                    items: _PhysicsKind.values,
                    value: physicsKind,
                    nameOf: (e) => e.name,
                    onChanged: onPhysicsKind,
                  ),
                  buildSwitch(title: 'useHeight 使用 height（覆盖 aspectRatio）', value: useHeight, onChanged: onUseHeight),
                  if (useHeight)
                    buildSlider(label: 'height', value: height, min: 120, max: 400, onChanged: onHeight)
                  else
                    buildSlider(
                      label: 'aspectRatio',
                      value: aspectRatio,
                      min: 0.5,
                      max: 2.5,
                      onChanged: onAspectRatio,
                      format: (v) => v.toStringAsFixed(2),
                    ),
                  buildSlider(
                    label: 'viewportFraction',
                    value: viewportFraction,
                    min: 0.3,
                    max: 1.0,
                    onChanged: onViewportFraction,
                    format: (v) => v.toStringAsFixed(2),
                  ),
                  buildSlider(
                    label: 'enlargeFactor',
                    value: enlargeFactor,
                    min: 0,
                    max: 1,
                    onChanged: onEnlargeFactor,
                    format: (v) => v.toStringAsFixed(2),
                  ),
                  buildSlider(
                    label: 'autoPlayInterval',
                    value: autoPlayIntervalSec,
                    min: 1,
                    max: 10,
                    onChanged: onAutoPlayIntervalSec,
                    format: (v) => '${v.round()}s',
                  ),
                  buildSlider(
                    label: 'autoPlayAnim',
                    value: autoPlayAnimationMs,
                    min: 200,
                    max: 2000,
                    onChanged: onAutoPlayAnimationMs,
                    format: (v) => '${v.round()}ms',
                  ),
                  buildSlider(
                    label: 'initialPage',
                    value: initialPage.toDouble(),
                    min: 0,
                    max: (imgList.length - 1).toDouble(),
                    onChanged: onInitialPage,
                  ),
                  buildSwitch(title: 'autoPlay 自动播放', value: autoPlay, onChanged: onAutoPlay),
                  buildSwitch(
                      title: 'enlargeCenterPage 中间放大', value: enlargeCenterPage, onChanged: onEnlargeCenterPage),
                  buildSwitch(
                      title: 'enableInfiniteScroll 无限循环',
                      value: enableInfiniteScroll,
                      onChanged: onEnableInfiniteScroll),
                  buildSwitch(title: 'animateToClosest 滚到最近页', value: animateToClosest, onChanged: onAnimateToClosest),
                  buildSwitch(title: 'reverse 反向', value: reverse, onChanged: onReverse),
                  buildSwitch(title: 'pageSnapping 整页吸附', value: pageSnapping, onChanged: onPageSnapping),
                  buildSwitch(
                      title: 'pauseAutoPlayOnTouch 触摸暂停',
                      value: pauseAutoPlayOnTouch,
                      onChanged: onPauseAutoPlayOnTouch),
                  buildSwitch(
                    title: 'pauseAutoPlayOnManualNavigate 手动切换暂停',
                    value: pauseAutoPlayOnManualNavigate,
                    onChanged: onPauseAutoPlayOnManualNavigate,
                  ),
                  buildSwitch(
                    title: 'pauseAutoPlayInFiniteScroll 有限滚动到底暂停',
                    value: pauseAutoPlayInFiniteScroll,
                    onChanged: onPauseAutoPlayInFiniteScroll,
                  ),
                  buildSwitch(title: 'disableCenter 取消居中', value: disableCenter, onChanged: onDisableCenter),
                  buildSwitch(title: 'padEnds 两端留白', value: padEnds, onChanged: onPadEnds),
                  buildSwitch(title: 'disableGesture 禁用手势', value: disableGesture, onChanged: onDisableGesture),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPreview() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        border: Border(bottom: BorderSide(color: Colors.blue.withValues(alpha: 0.25))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCarousel(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'onPageChanged: $currentPage  ${pageChangedReason?.name ?? ''}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel() {
    final options = CarouselOptions(
      height: useHeight ? height : null,
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

  Widget buildChoiceChips<T>({
    required String title,
    required List<T> items,
    required T value,
    required String Function(T e) nameOf,
    required ValueChanged<T> onChanged,
  }) {
    return NSectionBox(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((e) {
          return ChoiceChip(
            label: Text(nameOf(e)),
            selected: value == e,
            onSelected: (selected) {
              if (selected) {
                onChanged(e);
              }
            },
          );
        }).toList(),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: NSlider(
        leading: SizedBox(width: 120, child: Text(label)),
        min: min,
        max: max,
        value: value,
        onChanged: onChanged,
        inactiveColor: Colors.black12,
        trailingBuilder: format == null
            ? null
            : (context, v) => SizedBox(width: 48, child: Text(format(v), textAlign: TextAlign.end)),
      ),
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      title: Text(title),
      value: value,
      onChanged: onChanged,
      inactiveTrackColor: Colors.black12,
    );
  }

  void onResetCarouselController() {
    carouselController = CarouselSliderController();
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
    onResetCarouselController();
    setState(() {});
  }

  void onKind(_SliderKind value) {
    kind = value;
    onResetCarouselController();
    setState(() {});
  }

  void onScrollDirection(Axis value) {
    scrollDirection = value;
    if (value == Axis.vertical && !useHeight) {
      useHeight = true;
      height = 360;
    }
    onResetCarouselController();
    setState(() {});
  }

  void onEnlargeStrategy(CenterPageEnlargeStrategy value) {
    enlargeStrategy = value;
    setState(() {});
  }

  void onAutoPlayCurve((String, Curve) value) {
    autoPlayCurve = value.$2;
    setState(() {});
  }

  void onClipBehavior(Clip value) {
    clipBehavior = value;
    setState(() {});
  }

  void onPhysicsKind(_PhysicsKind value) {
    physicsKind = value;
    setState(() {});
  }

  void onUseHeight(bool value) {
    useHeight = value;
    onResetCarouselController();
    setState(() {});
  }

  void onHeight(double value) {
    height = value;
    setState(() {});
  }

  void onAspectRatio(double value) {
    aspectRatio = value;
    setState(() {});
  }

  void onViewportFraction(double value) {
    viewportFraction = value;
    setState(() {});
  }

  void onEnlargeFactor(double value) {
    enlargeFactor = value;
    setState(() {});
  }

  void onAutoPlayIntervalSec(double value) {
    autoPlayIntervalSec = value;
    setState(() {});
  }

  void onAutoPlayAnimationMs(double value) {
    autoPlayAnimationMs = value;
    setState(() {});
  }

  void onInitialPage(double value) {
    initialPage = value.round().clamp(0, imgList.length - 1);
    currentPage = initialPage;
    onResetCarouselController();
    setState(() {});
  }

  void onAutoPlay(bool value) {
    autoPlay = value;
    setState(() {});
  }

  void onEnlargeCenterPage(bool value) {
    enlargeCenterPage = value;
    setState(() {});
  }

  void onEnableInfiniteScroll(bool value) {
    enableInfiniteScroll = value;
    onResetCarouselController();
    setState(() {});
  }

  void onAnimateToClosest(bool value) {
    animateToClosest = value;
    setState(() {});
  }

  void onReverse(bool value) {
    reverse = value;
    onResetCarouselController();
    setState(() {});
  }

  void onPageSnapping(bool value) {
    pageSnapping = value;
    setState(() {});
  }

  void onPauseAutoPlayOnTouch(bool value) {
    pauseAutoPlayOnTouch = value;
    setState(() {});
  }

  void onPauseAutoPlayOnManualNavigate(bool value) {
    pauseAutoPlayOnManualNavigate = value;
    setState(() {});
  }

  void onPauseAutoPlayInFiniteScroll(bool value) {
    pauseAutoPlayInFiniteScroll = value;
    setState(() {});
  }

  void onDisableCenter(bool value) {
    disableCenter = value;
    setState(() {});
  }

  void onPadEnds(bool value) {
    padEnds = value;
    setState(() {});
  }

  void onDisableGesture(bool value) {
    disableGesture = value;
    setState(() {});
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    currentPage = index;
    pageChangedReason = reason;
    setState(() {});
  }

  void onItemTap(int index) {
    DLog.d('CarouselSlider onTap: $index');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('onTap No. $index image'), duration: const Duration(milliseconds: 800)),
    );
  }
}
