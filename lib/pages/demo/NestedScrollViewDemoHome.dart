//
//  NestedScrollViewPageDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/1 17:00.
//  Copyright © 2024/11/1 shang. All rights reserved.
//

import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_app_bar/en_app_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_grid_view.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/app_tab_bar_controller.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 嵌套滚动
class NestedScrollViewDemoHome extends StatefulWidget {
  const NestedScrollViewDemoHome({super.key});

  @override
  NestedScrollViewDemoHomeState createState() => NestedScrollViewDemoHomeState();
}

class NestedScrollViewDemoHomeState extends AppTabBarState<NestedScrollViewDemoHome> {
  final _homeController = Get.put(HomeController(), permanent: true);

  /// 嵌套滚动
  final scrollControllerNew = ScrollController();
  final scrollProgress = ValueNotifier(0.0);

  /// 用于记录页面可见度变化
  double _visibleFraction = 0.0;

  @override
  void onBarTap(int index) {
    // TODO: implement onBarTap
  }

  @override
  void dispose() {
    scrollControllerNew.removeListener(onScrollerLtr);
    super.dispose();
  }

  @override
  void initState() {
    scrollControllerNew.addListener(onScrollerLtr);
    super.initState();
  }

  onScrollerLtr() {
    scrollProgress.value = scrollControllerNew.position.progress;
  }

  refresh() {
    DLog.d("$this refresh");
  }

  final topKey = GlobalKey(debugLabel: "topKey");

  @override
  Widget build(BuildContext context) {
    const collapsedHeight = kToolbarHeight;
    var expandedHeight = 338.0 + 13;

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: buildNestedScrollViewPage(
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        collapsedBackgroundColor: const Color(0xff299ef0),
        collapsed: buildUserBar(),
        header: buildTopBox(),
        body: buildScheduleBox(),
      ),
    );
  }

  /// 交互页面构建
  Widget buildNestedScrollViewPage({
    required double expandedHeight,
    required double collapsedHeight,
    required Widget collapsed,
    required Color collapsedBackgroundColor,
    required Widget header,
    required Widget body,
  }) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   DLog.d([
    //     "$this topKey",
    //     topKey.currentContext?.size,
    //     ((topKey.currentContext?.size?.height ?? 0) - context.paddingTop)
    //   ].asMap());
    // });

    return NestedScrollView(
      controller: scrollControllerNew,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: EnSliverAppBar(
              centerTitle: false,
              pinned: true,
              floating: false,
              snap: false,
              primary: true,
              backgroundColor: () {
                final color = scrollProgress.value > 0.65 ? collapsedBackgroundColor : AppColor.bgColor;
                return color;
              },
              title: ListenableBuilder(
                listenable: scrollControllerNew,
                builder: (context, child) {
                  try {
                    final value = scrollControllerNew.offset;
                    final opacity = scrollControllerNew.position.progress > 0.9 ? 1.0 : 0.0;
                    return AnimatedOpacity(
                      opacity: opacity,
                      duration: const Duration(milliseconds: 100),
                      child: collapsed,
                    );
                  } catch (e) {
                    debugPrint("$this $e");
                  }
                  return const SizedBox();
                },
              ),
              toolbarHeight: collapsedHeight,
              collapsedHeight: collapsedHeight,
              expandedHeight: expandedHeight,
              elevation: 0,
              scrolledUnderElevation: 0,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                // key: topKey,
                background: SizedBox(
                  height: expandedHeight,
                  child: header,
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        margin: EdgeInsets.only(top: collapsedHeight + context.paddingTop),
        child: body,
      ),
    );
  }

  Widget buildTopBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
        image: DecorationImage(
          image: AssetImage('assets/images/image_header_bg2.webp'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.only(top: context.paddingTop),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: buildUserBar(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: buildProjectBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _headerCountWidget(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: buildSystemMessage(),
              ),
            ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Image.asset(
          'assets/images/image_header_bg2.webp',
          fit: BoxFit.fitWidth,
        ),
        Positioned.fill(
          child: VisibilityDetector(
            key: const ValueKey('HomePiPage'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 1.0 && _visibleFraction != 1.0) {
                refresh();
              }
              if (info.visibleFraction == 1.0 || info.visibleFraction == 0.0) {
                _visibleFraction = info.visibleFraction;
              }
            },
            child: GetBuilder<HomeController>(builder: (controller) {
              return EasyRefresh(
                onRefresh: refresh,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(top: context.paddingTop),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 13),
                        buildUserBar(),
                        const SizedBox(height: 6),
                        buildProjectBox(),
                        const SizedBox(height: 11),
                        _headerCountWidget(),
                        const SizedBox(height: 10),
                        buildSystemMessage(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget buildUserBar() {
    var realNameAndTypeText = "SoaringHeart，您好";

    return Container(
      height: 28,
      // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: NText(
              realNameAndTypeText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColor.white,
              ),
              maxLines: 1,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Image(
                image: "assets/images/icon_qr.png".toAssetImage(),
                width: 18,
                height: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 项目信息
  Widget buildProjectBox() {
    var projectNo = "0123456789";
    var projectCustomName = "项目名称";

    return Container(
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF).withOpacity(0.16),
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      DLog.d(projectCustomName);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: NText(
                            projectNo,
                            maxLines: 1,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image(
                            image: 'assets/images/icon_switch.png'.toAssetImage(),
                            width: 14,
                            height: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ProjectGreyButton(
                  text: '|',
                  onPressed: () {},
                ),
              ],
            ),
          ),
          NText(
            projectCustomName,
            maxLines: 1,
            fontSize: 14,
            color: Color(0xffFFFFFF).withOpacity(.8),
          ),
        ],
      ),
    );
  }

  /// 顶部功能模块
  Widget _headerCountWidget() {
    final children = [
      _menuItemCard(
        asyncNumber: Future(() => 1),
        color: const Color(0xFFE65F55),
        subText: '件事情待处理',
        textImage: '事情',
        iconImage: 'assets/images/icon_adverse_event.png',
        onTap: () {},
      ),
      _menuItemCard(
        count: 1,
        color: const Color(0xFFFF8F3E),
        subText: '条记录待处理',
        textImage: '记录',
        iconImage: 'assets/images/icon_wait_reply.png',
        onTap: () {},
      ),
      _menuItemCard(
        asyncNumber: Future(() => 3),
        color: const Color(0xFF2277E5),
        subText: '项方案待审核',
        textImage: '方案',
        iconImage: 'assets/images/icon_reviewed.png',
        onTap: () {
          //待审核
        },
      ),
      _menuItemCard(
        asyncNumber: Future(() => 4),
        color: const Color(0xFF00B451),
        subText: '个样本待处理',
        textImage: '样本',
        iconImage: 'assets/images/icon_arranged.png',
        onTap: () {
          //待安排
        },
      ),
    ];
    return SizedBox(
      height: 170,
      child: NGridView(
        crossAxisCount: 2,
        mainAxisSpacing: 11,
        crossAxisSpacing: 10,
        radius: 8,
        children: children,
      ),
    );
  }

  Widget buildSystemMessage() {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FlutterLogo(
              size: 32,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NText(
                  "消息提醒",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                Expanded(
                  child: NText(
                    "你收到一条新的消息…",
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 底部 待办事项
  Widget buildHeader() {
    return InkWell(
      onTap: () {
        DLog.d("待办事项");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 17,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const NText(
                  '待办事项',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
            Row(
              children: [
                NText(
                  DateTime.now().toString().split(" ").first,
                  fontSize: 14,
                  color: AppColor.fontColor737373,
                ),
                const SizedBox(
                  width: 6,
                ),
                Image(
                  image: 'assets/images/icon_arrow_right.png'.toAssetImage(),
                  width: 14,
                  height: 14,
                  color: AppColor.fontColor737373,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 顶部功能模块子条目卡片
  Widget _menuItemCard({
    required Color color,
    required String textImage,
    required String iconImage,
    required String subText,
    Future<int>? asyncNumber,
    int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(top: 13, left: 15, right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.white),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(.8),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform(
                  alignment: Alignment.topRight,
                  transform: Matrix4.skewX(-0.15), //字体倾斜15度
                  child: NText(
                    textImage,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  iconImage,
                  height: 28,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        asyncNumber != null
                            ? asyncNumber.maybeWhen(
                                orElse: () => const Text('0'),
                                loading: () => Align(
                                  alignment: Alignment.centerLeft,
                                  child: CupertinoActivityIndicator(radius: 8, color: color),
                                ),
                                data: (number) => number > 99
                                    ? const Text.rich(
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                        TextSpan(
                                          text: '99',
                                          children: [
                                            TextSpan(
                                              text: '+',
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text('$number',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              )
                            : count != null
                                ? count > 99
                                    ? const Text.rich(
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                        TextSpan(
                                          text: '99',
                                          children: [
                                            TextSpan(
                                              text: '+',
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text('$count', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
                                : const SizedBox(),
                        const SizedBox(width: 2),
                        NText(
                          subText,
                          fontSize: 12,
                          color: AppColor.fontColor737373,
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(width: 6),
                // DefaultTextStyle(
                //   style: TextStyle(
                //     color: color,
                //     fontSize: 12,
                //   ),
                //   child: arrowText,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 待办事项
  Widget buildScheduleBox() {
    return Container(
      height: context.screenHeight - context.paddingTop - 40,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          buildHeader(),
          Expanded(
            child: buildListView(),
          ),
        ],
      ),
    );
  }

  /// 待办事项列表
  Widget buildListView() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: EasyRefresh(
        onRefresh: () {
          DLog.d("onRefresh");
        },
        onLoad: () {
          DLog.d("onLoad");
        },
        child: ListView.separated(
          itemBuilder: (_, index) {
            final random = IntExt.random(max: AppRes.image.urls.length);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.8),
                  child: NNetworkImage(
                    url: AppRes.image.urls[random],
                    width: 48,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                title: NText("用户 $index"),
                subtitle: NText(
                  80.generateChars(),
                  fontSize: 12,
                  maxLines: 1,
                ),
              ),
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: 8);
            return Divider(height: 0.5, color: AppColor.lineColor);
          },
          itemCount: 20,
        ),
      ),
    );
  }
}

/// 项目名称修改按钮
class ProjectGreyButton extends StatelessWidget {
  const ProjectGreyButton({
    super.key,
    required this.onPressed,
    this.image,
    required this.text,
  });

  final Widget? image;
  final String text;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 6,
        //   vertical: 1.5,
        // ),
        decoration: BoxDecoration(
            // color: Colors.black.withOpacity(0.16),
            // border: Border.all(color: Colors.blue),
            // borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
        child: NPair(
          betweenGap: 7,
          isReverse: true,
          icon: image ??
              Image(
                image: 'assets/images/icon_edit.png'.toAssetImage(),
                width: 12,
                height: 12,
              ),
          child: NText(
            text ?? "修改名称",
            color: Color(0xffFFFFFF).withOpacity(0.5),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  /// 已选项目模型

  /// 刷新页面
  Future<void> reset() async {
    update();
  }

  void clear() {}
}
