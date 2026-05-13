import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_status_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/PointGoodsRootModel.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/n_check.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 商品 - 气泡
class GoodsChatBubbleItem extends StatelessWidget {
  const GoodsChatBubbleItem({
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
    // isSelected = true;//add test
    final borderColor = isSelected ? Color(0xFFE91025) : Colors.transparent;
    final bgColor = isSelected ? (themeProvider.isDark ? Colors.white.withOpacity(0.1) : Color(0xFFFFF4EC)) : color;

    final thumbUrl = model.animationUrl ?? model.thumbUrl ?? "";
    final name = model.goodsName ?? "";

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: thumbUrl,
            width: 56,
            height: 36,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'PingFang SC',
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
          // NPair(
          //   spacing: 4,
          //   icon: const Image(
          //     image: AssetImage(Assets.mineIcPandaCoin30),
          //     width: 14,
          //     height: 14,
          //   ),
          //   child: Text(
          //     model.price?.toString() ?? "-",
          //     style: const TextStyle(
          //       fontSize: 13,
          //       fontWeight: FontWeight.w500,
          //       fontFamily: 'PingFang SC',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
