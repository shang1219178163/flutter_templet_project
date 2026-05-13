//
//  GoodsBuy.dart
//  projects
//
//  Created by shang on 2026/4/21 16:59.
//  Copyright © 2026/4/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/elevated_btn.dart';
import 'package:flutter_templet_project/basicWidget/n_chat_bubble.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_category_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_status_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/ShopGoodsDetailModel.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/goods_tags.dart';
import 'package:flutter_templet_project/util/bottom_sheet_util.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:provider/provider.dart';

/// 商品购买弹窗内容组件
class GoodsDetailPopup extends StatefulWidget {
  GoodsDetailPopup({
    super.key,
    required this.categoryEnum,
    required this.model,
    required this.onEquip,
  });

  final GoodsCategoryEnum categoryEnum;
  final ShopGoodsDetailModel model;

  /// 装扮成功回调
  final VoidCallback onEquip;

  /// 展示商品弹窗
  static Future<dynamic> show({
    BuildContext? context,
    required GoodsCategoryEnum categoryEnum,
    required ShopGoodsDetailModel model,
    required VoidCallback onEquip,
  }) {
    // DLog.d(model.toJson());
    return BottomSheetUtil.show(
      context: ToolUtil.globalContext,
      child: GoodsDetailPopup(
        categoryEnum: categoryEnum,
        model: model,
        onEquip: onEquip,
      ),
    );
  }

  static void dismiss() {
    Navigator.of(ToolUtil.globalContext).pop();
  }

  @override
  State<GoodsDetailPopup> createState() => _GoodsDetailPopupState();
}

class _GoodsDetailPopupState extends State<GoodsDetailPopup> {
  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    final name = widget.model.goodsName ?? "";
    final desc = widget.model.description?.trim() ?? "";

    final priceStr = widget.model.price?.toString() ?? "";
    final tags = widget.model.attributes ?? [];

    // final sportType = '足球';
    // final priceStr = "288";
    // final tags = ['永久有效', '可装扮至所有会话'];
    // model.goodsStatus = GoodsStatusEnum.equipped.name;
    var imagePath = widget.model.bubblePath ?? Assets.messageBubble1;

    Widget buildDisplay() {
      Widget child = const SizedBox();
      switch (widget.categoryEnum) {
        case GoodsCategoryEnum.gift:
          {
            child = NNetworkImage(
              url: widget.model.thumbUrl ?? "",
              width: 100,
              height: 100,
            );
          }
          break;
        case GoodsCategoryEnum.bubble:
          {
            child = NChatBubble(
              imagePath: imagePath,
              metrics: const NChatBubbleMetrics(
                imageSize: Size(58, 44),
                safeInset: EdgeInsets.fromLTRB(23, 19, 19, 11 + 4),
              ),
              child: Text(
                'hi 一起看球吧',
                style: TextStyle(
                  // color: themeProvider.titleColor,
                  color: themeProvider.titleColor,
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                ),
              ),
            );
          }
          break;
        case GoodsCategoryEnum.enter_effect:
          {
            imagePath = widget.model.thumbUrl ?? widget.model.animationUrl ?? "";
            child = NChatBubble(
              imagePath: imagePath,
              metrics: const NChatBubbleMetrics(
                imageSize: Size(166, 38),
                safeInset: EdgeInsets.fromLTRB(25, 11, 37, 11),
                adjust: EdgeInsets.only(top: 0),
              ),
              child: const Text(
                '小明同学进入直播间',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                ),
              ),
            );
          }
          break;
        default:
          break;
      }

      return child;
    }

    Widget buildBtn() {
      final lightGradient = LinearGradient(colors: [
        Color(0xFFE91025).withOpacity(0.1),
        Color(0xFFE91025).withOpacity(0.1),
      ]);

      final gradient = LinearGradient(colors: [
        Color(0xFFE91025),
        Color(0xFFE91025),
      ]);

      // 跳转至首页热门直播列表
      void onLiveTab() {}

      if (widget.categoryEnum == GoodsCategoryEnum.gift) {
        // final enable = (UserInfoController.instance.balance ?? 0) > (widget.model.price ?? 0);
        final enable = true;
        final btnTitle = !enable ? "熊猫币不足 去赚熊猫币" : "可在直播间赠送该礼物";
        return ElevatedBtn(
          radius: 8,
          gradient: lightGradient,
          // disabledBgColor: Color(0xFFE91025).withOpacity(0.1),
          // disabledFgColor: Colors.white,
          title: btnTitle,
          titleColor: Color(0xFFE91025),
          onPressed: onLiveTab,
        );
      }

      Widget child = const SizedBox();
      switch (widget.model.goodsStatusEnum) {
        case GoodsStatusEnum.not_owned:
          {
            // final enable = (UserInfoController.instance.balance ?? 0) > (widget.model.price ?? 0);
            final enable = true;
            if (!enable) {
              child = ElevatedBtn(
                radius: 8,
                gradient: lightGradient,
                // disabledBgColor: Color(0xFFE91025).withOpacity(0.1),
                // disabledFgColor: Colors.white,
                title: "熊猫币不足 去赚熊猫币",
                titleColor: Color(0xFFE91025),
                onPressed: onLiveTab,
              );
            } else {
              child = ElevatedBtn(
                radius: 8,
                gradient: gradient,
                // disabledBgColor: const Color(0xFFF38791),
                // disabledFgColor: Colors.white,
                title: "兑换",
                onPressed: () async {
                  DLog.d("兑换");
                  // final orderResultModel = await requestGoodsExchange(
                  //   categoryCode: widget.categoryEnum.code,
                  //   goodsId: widget.model.goodsId,
                  // );
                  // final isSuccess = orderResultModel?.balance != null;
                  // if (isSuccess == true) {
                  //   if (widget.model.goodsStatus == GoodsStatusEnum.not_owned.name) {
                  //     widget.model.goodsStatus = GoodsStatusEnum.owned.name;
                  //   }
                  //   ToastUtil.show("兑换成功");
                  //   UserInfoController.instance.balance = orderResultModel?.balance;
                  //   // GoodsDetailPopup.dismiss();
                  //   setState(() {});
                  // }
                },
              );
            }
          }
          break;
        case GoodsStatusEnum.owned:
          {
            child = ElevatedBtn(
              radius: 8,
              gradient: LinearGradient(colors: [
                Color(0xFFE91025),
                Color(0xFFE91025),
              ]),
              disabledBgColor: Color(0xFFE91025).withOpacity(0.1),
              disabledFgColor: Colors.white,
              title: widget.categoryEnum.ownedDesc,
              titleColor: Colors.white,
              onPressed: () async {
                DLog.d("装扮");
                // final isSuccess = await requestGoodsEquip(
                //   categoryCode: widget.categoryEnum.code,
                //   goodsId: widget.model.goodsId,
                // );
                // if (isSuccess == true) {
                //   if (widget.model.goodsStatus == GoodsStatusEnum.owned.name) {
                //     widget.model.goodsStatus = GoodsStatusEnum.equipped.name;
                //   }
                //   widget.onEquip();
                //   ToastUtil.show(widget.categoryEnum.equippedTips);
                //   // GoodsDetailPopup.dismiss();
                //   setState(() {});
                // }
              },
            );
          }
          break;
        case GoodsStatusEnum.equipped:
          {
            child = ElevatedBtn(
              radius: 8,
              gradient: LinearGradient(colors: [Color(0xFFE91025), Color(0xFFE91025)]),
              disabledBgColor: Color(0xFFE91025).withOpacity(0.1),
              disabledFgColor: Color(0xFFE91025),
              title: "已装扮",
              // titleColor: Color(0xFFE91025),
              onPressed: null,
            );
          }
          break;
        default:
          break;
      }
      return child;
    }

    return Container(
      padding: EdgeInsets.only(bottom: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              decoration: BoxDecoration(
                // color: Colors.red,
                // border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                gradient: LinearGradient(
                  begin: const Alignment(0.00, -1.00),
                  end: const Alignment(0, 1),
                  colors: [const Color(0xFFFDE7E9), const Color(0xFFFDE7E9).withOpacity(0.0)],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 48),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  gradient: LinearGradient(
                    begin: const Alignment(0.00, -1.00),
                    end: const Alignment(0, 1),
                    colors: [const Color(0xFFFFFFFF), const Color(0xFFF8F1F2)],
                  ),
                ),
                child: buildDisplay(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 36).copyWith(
                  top: 16,
                  bottom: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          // border: Border.all(color: Colors.blue),
                          ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage(Assets.shopIcPandaCoin30),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 4),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  priceStr,
                                  style: TextStyle(
                                    color: Color(0xFFE91025),
                                    fontSize: 24,
                                    fontFamily: 'PingFang SC',
                                    fontWeight: FontWeight.w600,
                                    height: 0.9,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '熊猫币',
                                  style: TextStyle(
                                    color: themeProvider.titleColor,
                                    fontSize: 14,
                                    fontFamily: 'PingFang SC',
                                    // height: 0.08,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: const BoxDecoration(
                          // border: Border.all(color: Colors.blue),
                          ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: themeProvider.titleColor,
                              fontSize: 18,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GoodsTags(
                            items: tags,
                            nameCb: (e) => e,
                          ),
                        ],
                      ),
                    ),
                    if (desc.isNotEmpty)
                      Container(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: Text(
                          desc,
                          style: TextStyle(
                            color: themeProvider.subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: buildBtn(),
              ),
              // if (kDebugMode) Text(UserInfoController.instance.balance?.toString() ?? ""),
              // if (kDebugMode) Text(widget.model.toJson().convertByIndent()),
            ],
          ),
        ],
      ),
    );
  }
}
