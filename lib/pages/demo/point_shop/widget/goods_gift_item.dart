import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/PointGoodsRootModel.dart';

/// 商品 - 直播礼物
class GoodsGiftItem extends StatelessWidget {
  const GoodsGiftItem({
    super.key,
    required this.model,
    required this.color,
    this.borderColor,
    this.fontWeight,
  });

  final ShopGoodsDetailModel model;

  final Color? color;
  final Color? borderColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: model.thumbUrl ?? "",
            width: 40,
            height: 40,
          ),
          SizedBox(height: 4),
          Text(
            model.goodsName ?? "-",
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontFamily: 'PingFang SC',
            ),
          ),
          NPair(
            spacing: 4,
            icon: const Image(
              image: AssetImage(Assets.shopIcPandaCoin30),
              width: 10,
              height: 10,
            ),
            child: Text(
              model.price?.toString() ?? "-",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
