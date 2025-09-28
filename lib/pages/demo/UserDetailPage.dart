//
//  UserDetailPage.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/20 09:18.
//  Copyright © 2025/9/20 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_fixed_width_indicator.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/util/Resource.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var height = 30;
    return _HeadView(height);
  }
}

class _HeadView extends StatefulWidget {
  const _HeadView(this.height);

  final int height;

  @override
  State<_HeadView> createState() => _HeadViewState();
}

class _HeadViewState extends State<_HeadView> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  ValueNotifier<bool> isCheckPrediction = ValueNotifier(true);

  ValueNotifier<double?> maxHeight = ValueNotifier(400);
  final GlobalKey _headerKey = GlobalKey();

  final ValueNotifier<double> _opacity = ValueNotifier(1);

  final tabList = ["向左", "向右"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight(overlapHeight: widget.height));
  }

  @override
  void didUpdateWidget(covariant _HeadView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.height != widget.height && widget.height > oldWidget.height) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight(overlapHeight: widget.height));
    }
  }

  final avatar = Resource.image.urls[3];

  Widget? buildHeader;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var minHeight = data.padding.top + 56;
    buildHeader ??= buildHeaderView();

    _opacity.value = 1.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder(
        valueListenable: maxHeight,
        builder: (context, value, child) {
          // return buildHeader!;
          return value == null ? buildHeader! : child!;
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: minHeight,
                  maxHeight: maxHeight.value ?? 400,
                  onHeightChanged: (value) {
                    _opacity.value = value / maxHeight.value!;
                  },
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ValueListenableBuilder(
                      // valueListenable: _opacity,
                      valueListenable: _opacity,
                      builder: (context, value, child) {
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            child!,
                            Opacity(
                              opacity: value,
                              child: Container(
                                padding: EdgeInsets.only(top: data.padding.top, left: 60),
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    // border: Border.all(color: Colors.blue),
                                    ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        border: Border.all(color: Colors.blue),
                                      ),
                                      child: AvatarView(
                                        isDark: false,
                                        avatar: avatar,
                                        isAnchor: true,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "意难平",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      child: buildHeader,
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: SliverAppBarDelegate(
                  minHeight: 48,
                  maxHeight: 48,
                  child: Container(
                    height: 48,
                    // color: Color(0xFF161625),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blue,
                        ], //
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    // padding: const EdgeInsets.only(bottom: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: tabList.map((v) => Tab(text: v)).toList(),

                        // dividerColor: Colors.transparent,
                        indicator: const NTabBarFixedWidthIndicator(
                          width: 16,
                          gradient: LinearGradient(
                            colors: [Color(0xffE44554), Color(0xff6040FF)], //
                          ),
                          borderRadius: 10,
                          topMargin: 5,
                        ),
                        unselectedLabelStyle: const TextStyle(fontSize: 16),
                        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                      ),
                    ),
                  ),
                ),
              ),
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverToBoxAdapter(
                  child: Container(
                      // height: 0,
                      ),
                ),
              ),
            ];
          },
          body: Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              decoration: BoxDecoration(
                // color: Color(0xFFF3F4F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                        ),
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _measureHeaderHeight({int overlapHeight = 30}) {
    if (!mounted || _headerKey.currentContext == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _headerKey.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && mounted) {
          final height = renderBox.size.height;
          if (height > 0) {
            maxHeight.value = height;

            setState(() {});
          } else {
            // 如果测量失败，使用默认值或重新尝试
            WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
          }
        }
      }
    });
  }

  Widget buildHeaderView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _headerView(
          onPop: () {
            DLog.d("_headerView");
            Navigator.pop(context);
          },
          avatarUrl: avatar,
          isFollow: true,
          onFollow: () async {},
          onPersonalLetter: () {},
          onReport: () {},
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _nameInfoView(
              name: "意难平1",
              level: 90,
              follow: 91,
              vermicelli: 92,
              userCode: "userCode",
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue),
                        ),
                    child: Text("其他组件"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerView({
    required void Function() onPop,
    required String avatarUrl,
    required bool isFollow,
    VoidCallback? onFollow,
    VoidCallback? onPersonalLetter,
    VoidCallback? onReport,
  }) {
    return Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(avatarUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  height: 220,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            SafeArea(
              child: InkWell(
                onTap: onPop,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _actionView(
                isFollow: isFollow,
                followCallback: onFollow,
                personalLetterCallback: onPersonalLetter,
                reportCallback: onReport,
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {},
                child: UserHeaderWidget(
                  anchorAvatar: avatarUrl,
                  isAnchor: true,
                  level: 99,
                  widthBorder: 80,
                  levelSize: 13,
                  anchorIdentify: "1",
                  actionStatus: 2,
                  widthInner: 80,
                  big: true,
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: '复制成功'));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '看比赛号：${'99999999'}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      Image(
                        image: AssetImage("assets/images/icon_copy.png"),
                        width: 12,
                        height: 12,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _actionView({
    required bool isFollow,
    void Function()? followCallback,
    void Function()? personalLetterCallback,
    void Function()? reportCallback,
  }) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: followCallback,
            child: Container(
              width: 60,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffE44554), Color(0xff6040FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "关注",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: personalLetterCallback,
            child: Container(
              width: 60,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffE44554), Color(0xff6040FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(1),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.message, size: 16, color: Colors.white),
                  ),
                  Text(
                    '私信',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: reportCallback,
            child: Container(
              alignment: Alignment.center,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFFDEDEDE),
                ),
              ),
              child: Transform.translate(
                offset: const Offset(0, -1),
                child: Icon(
                  Icons.warning_amber_outlined,
                  size: 16,
                  color: Color(0xFF313135),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 信息视图
  ///
  /// [name] 主播昵称
  /// [level] 等级
  /// [follow] 关注量
  /// [vermicelli] 粉丝数量
  Widget _nameInfoView({
    required String name,
    required int level,
    required int follow,
    required int vermicelli,
    required userCode,
  }) {
    final titleColor = Color(0xFF313135);
    final subtitleColor = Color(0xFF7C7C85);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "AutoScrollWidget",
                      style: TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '$follow',
                    style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '关注',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                width: 0.5,
                height: 26,
                color: Colors.white.withOpacity(0.05),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Column(
                children: [
                  Text(
                    '$vermicelli',
                    style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '粉丝',
                    style: TextStyle(color: titleColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "description",
              style: TextStyle(color: titleColor, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.isDark = true});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: CupertinoActivityIndicator(
            color: isDark ? Colors.white : Color(0xff313135),
          ),
        ),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  final ValueChanged<double>? onHeightChanged;

  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    this.onHeightChanged,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    onHeightChanged?.call(shrinkOffset);

    double rawHeight = maxExtent - shrinkOffset;
    double currentHeight = rawHeight.clamp(minExtent, maxExtent);
    return SizedBox(height: currentHeight, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight || oldDelegate.minHeight != minHeight;
  }
}

class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    this.isDark = true,
    required this.avatar,
    required this.isAnchor,
    this.level,
    this.avatarSize = 45,
    this.levelSize,
  });

  final bool isDark;

  final String avatar;

  final bool isAnchor;

  final int? level;

  final double avatarSize;

  final double? levelSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE44554), Color(0xFF4847A3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: ColoredBox(
              color: isDark ? const Color(0xffFEEFEF) : Colors.white,
              child: NNetworkImage(
                url: avatar,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: -5,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff676EC9),
                    Color(0xff40308F),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Lv99',
                style: TextStyle(
                  fontSize: levelSize ?? 8 / 36 * avatarSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isAnchor)
            Positioned(
              // top: -2,
              bottom: 0,
              left: 8,
              right: 8,
              child: Container(
                child: Image(
                  image: AssetImage("assets/images/icon_authoration_status.png"),
                  width: avatarSize,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({
    super.key,
    required this.anchorAvatar,
    this.anchorIdentify,
    required this.actionStatus,
    required this.widthBorder,
    this.widthInner,
    this.isAnchor = true,
    this.level,
    this.levelSize,
    this.big = false,
  });

  final String anchorAvatar;
  final String? anchorIdentify; // 认证标识
  final int actionStatus; //用户状态 0-空 1-(暂时没)正在看比赛 2-正在直播中
  final double widthBorder;
  final double? widthInner;
  final bool isAnchor;
  final int? level;
  final double? levelSize;
  final bool? big;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthBorder,
      height: widthBorder,
      decoration: BoxDecoration(
        color: Color(0xFF181829),
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE44554), Color(0xFF4847A3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          actionStatus == 2
              ? Positioned(
                  bottom: (big ?? false) ? -8 : -4,
                  left: (big ?? false) ? -8 : -4,
                  right: (big ?? false) ? -8 : -4,
                  top: (big ?? false) ? -8 : -4,
                  child: Image.asset(
                    "assets/images/icon_onliving.png",
                  ))
              : Container(),
          AvatarView(
            isDark: false,
            avatarSize: widthBorder,
            avatar: anchorAvatar,
            isAnchor: isAnchor,
            level: level,
            levelSize: levelSize,
          ),
        ],
      ),
    );
  }
}
