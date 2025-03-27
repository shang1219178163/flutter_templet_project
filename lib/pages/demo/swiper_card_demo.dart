//
//  SwiperCardDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/22 17:53.
//  Copyright © 2025/1/22 shang. All rights reserved.
//

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/mixin/debug_bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/mixin/equal_identical_mixin.dart';
import 'package:flutter_templet_project/mixin/equal_identical_mixin.dart';
import 'package:flutter_templet_project/pages/demo/OcrPhotoDemo.dart';
import 'package:flutter_templet_project/service/ocr_text_recognition_manager.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:get/get.dart';

class SwiperCardDemo extends StatefulWidget {
  const SwiperCardDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SwiperCardDemo> createState() => _SwiperCardDemoState();
}

class _SwiperCardDemoState extends State<SwiperCardDemo> with DebugBottomSheetMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final AppinioSwiperController controller = AppinioSwiperController();

  late List<_CandidateModel> candidates = R.image.urls.map((e) {
    final i = R.image.urls.indexOf(e);
    return _CandidateModel(
      avatar: e,
      name: '用户 $i',
      job: ['Manager', 'Member'].randomOne,
      city: 'Town',
    );
  }).toList();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      _shakeCard();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .75,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 50,
                  bottom: 40,
                ),
                child: AppinioSwiper(
                  invertAngleOnBottomDrag: true,
                  backgroundCardCount: 2,
                  swipeOptions: const SwipeOptions.all(),
                  controller: controller,
                  // onCardPositionChanged: (SwiperPosition position) {
                  //   debugPrint('${position.offset.toAxisDirection()}, '
                  //       '${position.offset}, '
                  //       '${position.angle}');
                  // },
                  onSwipeEnd: _swipeEnd,
                  onEnd: _onEnd,
                  cardCount: candidates.length,
                  cardBuilder: (BuildContext context, int index) {
                    final e = candidates[index];
                    e.color ??= LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorExt.random,
                        ColorExt.random,
                      ],
                    );
                    return GestureDetector(
                      onTap: () {
                        onOCRSheet(index: index);
                      },
                      child: _CandidateCard(
                        key: ValueKey(e),
                        model: e,
                      ),
                    );
                  },
                ),
              ),
            ),
            IconTheme.merge(
              data: const IconThemeData(size: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildIconButton(
                    onTap: _shakeCard,
                    child: const Icon(
                      Icons.question_mark,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  swipeHorizalButton(
                    controller: controller,
                    isLeft: true,
                    bgColor: const Color(0xFFFF3868),
                    child: const Icon(
                      Icons.close,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  swipeHorizalButton(
                    isLeft: false,
                    controller: controller,
                    child: const Icon(
                      Icons.check,
                      color: CupertinoColors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  buildIconButton(
                    onTap: () => controller.unswipe(),
                    child: const Icon(
                      Icons.rotate_left_rounded,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    switch (activity) {
      case Swipe():
        DLog.d('The card was swiped to the : ${activity.direction}');
        DLog.d('previous index: $previousIndex, target index: $targetIndex');
        break;
      case Unswipe():
        DLog.d('A ${activity.direction.name} swipe was undone.');
        DLog.d('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        DLog.d('A swipe was cancelled');
        break;
      case DrivenActivity():
        DLog.d('Driven Activity');
        break;
    }
  }

  void _onEnd() {
    DLog.d('end reached!');
  }

  // Animates the card back and forth to teach the user that it is swipable.
  Future<void> _shakeCard() async {
    const double distance = 30;
    // We can animate back and forth by chaining different animations.
    await controller.animateTo(
      const Offset(-distance, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await controller.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // We need to animate back to the center because `animateTo` does not center
    // the card for us.
    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget swipeHorizalButton({
    bool isLeft = false,
    Color bgColor = CupertinoColors.activeGreen,
    required AppinioSwiperController controller,
    required Widget child,
  }) {
    return ListenableBuilder(
      listenable: controller,
      child: child,
      builder: (context, child) {
        final SwiperPosition? position = controller.position;
        final SwiperActivity? activity = controller.swipeActivity;
        final direction = isLeft ? -1 : 1;
        final double progress = (activity is Swipe || activity == null) &&
                position != null &&
                position.offset.toAxisDirection().isHorizontal
            ? direction * position.progressRelativeToThreshold.clamp(-1, 1)
            : 0;
        final Color color = Color.lerp(
          bgColor,
          CupertinoColors.systemGrey2,
          (-1 * progress).clamp(0, 1),
        )!;
        return GestureDetector(
          onTap: () {
            if (isLeft) {
              controller.swipeLeft();
            } else {
              controller.swipeRight();
            }
          },
          child: Transform.scale(
            scale: 1 + .1 * progress.clamp(0, 1),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.9),
                    spreadRadius: -10,
                    blurRadius: 20,
                    offset: const Offset(0, 20), // changes position of shadow
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget buildIconButton({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  /// OCR 识别
  void onOCRSheet({int index = 0}) {
    Widget buildPageView({int index = 0}) {
      final urls = candidates.map((e) => e.avatar).toList();
      final pageController = PageController(initialPage: index);
      final indexVN = ValueNotifier(index);

      return Container(
        constraints: BoxConstraints(
          minHeight: 400,
          maxHeight: 600,
        ),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: indexVN,
              builder: (context, value, child) {
                return Text("${value}/${urls.length}");
              },
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  indexVN.value = index;
                },
                children: urls.map((e) {
                  return OCRNetImageCard(
                    key: ValueKey(e),
                    avatar: e,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    onDebugBottomSheet(
      title: "文字识别",
      content: buildPageView(index: index),
    );
  }
}

class _CandidateModel with EqualIdenticalMixin {
  _CandidateModel({
    this.avatar,
    this.name,
    this.job,
    this.city,
    this.color,
  });

  String? avatar;
  String? name;
  String? job;
  String? city;
  LinearGradient? color;

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['avatar'] = avatar;
    data['name'] = name;
    data['job'] = job;
    data['city'] = city;
    data['color'] = color;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _CandidateModel && other.toJson() == toJson();
  }

  @override
  int get hashCode {
    return Object.hash(
      avatar,
      name,
      job,
      city,
      color,
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    super.key,
    required this.model,
  });

  final _CandidateModel model;

  @override
  Widget build(BuildContext context) {
    final avatar = model.avatar ?? "";
    final name = model.name ?? "";
    final job = model.job ?? "";
    final city = model.city ?? "";
    final color = model.color;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                gradient: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    avatar,
                    cache: true,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      job,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      city,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
