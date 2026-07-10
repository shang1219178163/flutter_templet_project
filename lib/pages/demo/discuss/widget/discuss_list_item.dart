//
//  DiscussListItem.dart
//  projects
//
//  Created by shang on 2026/1/29 14:27.
//  Copyright © 2026/1/29 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cached_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/pages/demo/discuss/model/NewsDiscussRootModel.dart';
import 'package:flutter_templet_project/pages/demo/discuss/widget/discuss_like_btn.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:provider/provider.dart';

/// 讨论列表item
class DiscussListItem extends StatelessWidget {
  const DiscussListItem({
    super.key,
    required this.model,
    this.hideFollow = false,
    this.hideReplyOther = false,
    this.hideReplyText = false,
    this.hideScore = false,
    this.likeTop = true,
    this.onTap,
    this.onTapParent,
    this.onTapFollow,
    this.onRely,
    this.onMakeHot,
    required this.onLike,
    required this.onParentLink,
    required this.onLink,
    this.isDebug = false,
  });

  final NewsDiscussDetailModel model;

  /// 隐藏他人回复
  final bool hideFollow;

  /// 隐藏父回复
  final bool hideReplyOther;

  // 时间后的回复提示是否显示
  final bool hideReplyText;

  /// 隐藏评分
  final bool hideScore;

  // 点赞显示在顶部
  final bool likeTop;

  final VoidCallback? onTap;
  final VoidCallback? onTapParent;
  final VoidCallback? onTapFollow;

  final VoidCallback? onRely;

  final VoidCallback? onMakeHot;

  final Future<Map<String, dynamic>> Function() onLike;

  /// 父图片
  final ValueChanged<List<String>>? onParentLink;

  /// 子评论图片
  final ValueChanged<List<String>>? onLink;

  final bool isDebug;

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    const nameLimit = 7;

    final avatar = model.avatar ?? "";
    final name = model.nickName?.ellipsis(max: nameLimit) ?? "";
    // var score = model.score ?? 0;
    // score = 0; //add test
    // final hasScoreBar = score > 0 && !hideScore;
    var likeNumber = model.likeNumber ?? 0;

    final isLike = model.like ?? false;
    // final likeIcon = isLike == true ? Assets.dataIcLikeHighlighted : Assets.dataIcLike;
    // likeNumber = 10000;
    // final likeNumberStr = likeNumber < 10000 ? "$likeNumber" : "9999+";

    final message = model.message ?? "";
    final urls = model.imageUrls ?? [];

    var replyOther = model.parent != null ? [model.parent!] : <NewsDiscussDetailModel>[];

    var followItems = <NewsDiscussDetailModel>[...(model.replyList ?? [])];
    final maxLength = followItems.length.clamp(0, 1);
    followItems = followItems.sublist(0, maxLength);

    var replyTimeStr = model.showTime ?? "";

    const nameStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColor.fontColor999999,
    );

    final messageStyle = TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w400,
      fontFamily: "PingFang SC",
      color: themeProvider.titleColor,
    );

    final linkStyle = messageStyle.copyWith(color: AppColor.fontColor666666);

    Border? border = Border.all(color: Colors.blue, width: 0.5);
    border = null;

    /// 生产环境隐藏(点赞超多一千自动热门)
    var showMakeHot = RequestConfig.current != AppEnv.prod;
    showMakeHot = false;

    if (hideReplyOther) {
      // replyOther.clear();
      replyOther = [];
    }

    if (hideFollow) {
      followItems = [];
    }

    // final disable = (model.userId == Global.userInfo?.id);
    final disable = (model.userId == 1000); //不为自己
    // DLog.d([disable, model.userId, Global.userInfo?.id]);
    final likeButton = DiscussLikeBtn(
      like: isLike,
      likeNumber: likeNumber,
      onLike: onLike,
      disable: disable,
      onDisable: () {
        ToastUtil.show("不能给自己的评论评分");
      },
    );

    onTapAvatar() {
      // 因为缺少字段,暂时点击头像无效
      DLog.d([model.customerInfo?.toJson()]);
      // DLog.d([model.debugRightsMap()]);
      // if (model.hadAuthStatus) {
      //   AnchorHomePage.push(context, model.anchorCustomId ?? 0);
      // }
    }

    return GestureDetector(
      onTap: onTap,
      child: DefaultTextStyle(
        style: messageStyle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: themeProvider.color242434OrWhite,
            border: border,
            borderRadius: const BorderRadius.all(Radius.circular(0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTapAvatar,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: buildUserAvatar(avatar: avatar),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: border,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: border,
                                  ),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: themeProvider.subtitleColor,
                                      // height: 1.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (showMakeHot && onMakeHot != null)
                                GestureDetector(
                                  onTap: onMakeHot,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      border: border,
                                    ),
                                    child: const Image(
                                      image: AssetImage(Assets.discussIcHotSpot),
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              if (likeTop)
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: border,
                                  ),
                                  child: likeButton,
                                ),
                            ],
                          ),
                          // if (hasScoreBar)
                          //   Container(
                          //     padding: const EdgeInsets.only(top: 2, bottom: 2),
                          //     child: DiscussRatingStars(
                          //       value: score,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    if (replyOther.isNotEmpty)
                      GestureDetector(
                        onTap: onTapParent,
                        child: buildOtherReply<NewsDiscussDetailModel>(
                          context: context,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          border: border,
                          items: replyOther,
                          nameStyle: nameStyle.copyWith(fontSize: 13.5),
                          nameCb: (e) => e.nickName.ellipsis(max: nameLimit) ?? '',
                          messageStyle: messageStyle.copyWith(fontSize: 13.5),
                          messageCb: (e) => e.message ?? "",
                          linkStyle: linkStyle,
                          linkCb: (e) => e.imageUrls ?? [],
                          onLink: onParentLink,
                          hasReplyArrow: false,
                          hasReplyTotal: false,
                          prefix: "@",
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.only(
                        top: replyOther.isNotEmpty ? 0 : 4,
                        bottom: followItems.isNotEmpty ? 0 : 2,
                      ),
                      decoration: BoxDecoration(
                        border: border,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(message, style: messageStyle),
                      ),
                    ),
                    buildImage(context: context, urls: urls),
                    // SizedBox(height: 4),
                    //别人回复
                    if (followItems.isNotEmpty)
                      GestureDetector(
                        onTap: onTapFollow,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 4),
                          child: buildOtherReply<NewsDiscussDetailModel>(
                            context: context,
                            border: border,
                            items: followItems,
                            nameStyle: nameStyle.copyWith(fontSize: 13.5),
                            nameCb: (e) => e.nickName.ellipsis(max: nameLimit) ?? '',
                            messageStyle: messageStyle.copyWith(fontSize: 13.5),
                            messageCb: (e) => e.message ?? "",
                            linkStyle: linkStyle,
                            linkCb: (e) => e.imageUrls ?? [],
                            onLink: onLink,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onRely,
                            child: Text.rich(
                              TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: replyTimeStr, style: nameStyle),
                                  if (!hideReplyText)
                                    TextSpan(
                                      text: " · 回复",
                                      style: messageStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "PingFang SC",
                                        color: AppColor.fontColor666666,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            DLog.d("举报");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.blue),
                            // ),
                            child: const Icon(Icons.more_vert, size: 13, color: AppColor.fontColor999999),
                          ),
                        ),
                      ],
                    ),
                    if (kDebugMode && isDebug)
                      Text(
                        model.toJson().convertByIndent(),
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserAvatar({required String avatar}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        // color: Colors.transparent,
        // border: border,
        shape: CircleBorder(),
      ),
      child: NCachedNetworkImage(
        imageUrl: avatar,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildOtherReply<E>({
    required BuildContext context,
    EdgeInsets? margin,
    required Border? border,
    required List<E> items,
    required String Function(E e) nameCb,
    required TextStyle? nameStyle,
    required String Function(E e) messageCb,
    required TextStyle? messageStyle,
    required List<String> Function(E e) linkCb,
    required ValueChanged<List<String>>? onLink,
    required TextStyle? linkStyle,
    bool hasReplyArrow = true,
    bool hasReplyTotal = true,
    String prefix = "",
  }) {
    late final themeProvider = context.read<ThemeProvider>();

    return Container(
      margin: margin,
      // decoration: BoxDecoration(
      //   color: Colors.transparent,
      //   border: border,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasReplyArrow)
            Container(
              margin: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Image(
                image: AssetImage(Assets.discussIcArrow),
                width: 9,
                height: 8,
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // color: themeProvider.color181829OrF6F6F6,
              color: Color(0xFFF6F6F6),
              border: border,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.map((e) {
                  final name = nameCb(e);
                  final message = messageCb(e);
                  final urls = linkCb(e);

                  final index = items.indexOf(e);
                  final isLast = items.last == e;
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: isLast ? 0 : 8,
                    ),
                    decoration: BoxDecoration(
                      border: border,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "$prefix$name: ", style: nameStyle),
                          TextSpan(text: message, style: messageStyle),
                          if (urls.isNotEmpty)
                            TextSpan(
                              text: "[图片*${urls.length}]",
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  onLink?.call(urls);
                                },
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                if (hasReplyTotal && (model.replyCount ?? 0) > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: NPair(
                      isReverse: true,
                      // spacing: 4,
                      icon: Container(
                        margin: EdgeInsets.only(left: 0),
                        // decoration: BoxDecoration(
                        //   border: border,
                        // ),
                        child: Image(
                          image: AssetImage(Assets.discussIcArrowRatings),
                          width: 4,
                          height: 8,
                          color: AppColor.cancelColor,
                        ),
                        // child: const Image.asset(
                        //   Assets.dataIcArrowRatings,
                        //   width: 4,
                        //   height: 8,
                        //   color: AppColor.cancelColor,
                        // ),
                      ),
                      child: Text(
                        "${model.replyCount}条回复",
                        style: const TextStyle(
                          color: AppColor.cancelColor,
                          fontSize: 11.5,
                          // fontWeight: FontWeight.w500,
                          // fontFamily: "PingFang SC",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示图片
  Widget buildImage({required BuildContext context, required List<String> urls}) {
    return Container(
      // decoration: BoxDecoration(
      // color: Colors.transparent,
      // border: Border.all(color: Colors.blue),
      // borderRadius: BorderRadius.all(Radius.circular(0)),
      //     ),
      child: Wrap(
        spacing: 8,
        children: [
          ...urls.map((e) {
            final index = urls.indexOf(e);
            return GestureDetector(
              onTap: () {
                AssetUploadBox.jumpImagePreview(urls: urls, index: index);
              },
              child: NCachedNetworkImage(
                imageUrl: e,
                width: 60,
                height: 60,
                radius: 4,
              ),
            );
          }),
        ],
      ),
    );
  }
}
