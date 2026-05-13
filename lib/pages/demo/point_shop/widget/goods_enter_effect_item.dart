import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_status_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/PointGoodsRootModel.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/n_check.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 商品 - 直播礼物
class GoodsEnterEffectItem extends StatelessWidget {
  const GoodsEnterEffectItem({
    super.key,
    required this.model,
    required this.color,
  });

  final ShopGoodsDetailModel model;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    var isSelected = model.goodsStatus == GoodsStatusEnum.equipped.name;
    // isSelected = true; //add test
    final borderColor = isSelected ? Color(0xFFE91025) : Colors.transparent;
    final bgColor = isSelected ? (themeProvider.isDark ? Colors.white.withOpacity(0.1) : Color(0xFFFEF7E5)) : color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            model.goodsName ?? "-",
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang SC',
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: CachedNetworkImage(
                    imageUrl: model.animationUrl ?? "",
                    // height: 28,
                    width: 180,
                    // fit: BoxFit.contain,
                  ),
                ),
                // if (kDebugMode) Text([model.goodsId, model.goodsStatus].join(", ")),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     ImageView(
          //       model.thumbUrl ?? "",
          //       width: 28,
          //       height: 28,
          //       fit: BoxFit.fitWidth,
          //     ),
          //     Expanded(child: buildEnterLive()),
          //   ],
          // ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NPair(
                spacing: 4,
                icon: const Image(
                  image: AssetImage(Assets.shopIcPandaCoin30),
                  width: 14,
                  height: 14,
                ),
                child: Text(
                  model.price?.toString() ?? "-",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PingFang SC',
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: NCheck(
                    isSelected: isSelected,
                    size: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEnterLive() {
    Color bgColor = Colors.transparent;
    switch (model.goodsId) {
      case 2000:
        bgColor = Color(0xFFE4FDCC);
        break;
      case 2010:
        bgColor = Color(0xFFFADECF);
        break;
      case 2020:
      case 2030:
        bgColor = Color(0xFFFFF9E8);
        break;
      default:
        break;
    }

    return Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            bgColor,
            bgColor.withOpacity(0.0),
          ],
        ),
      ),
      child: const Text(
        "进入直播间",
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
