import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 处方弹窗
class IMRecipleBottomSheet extends StatelessWidget {
  const IMRecipleBottomSheet({
    Key? key,
    required this.onWestMedicine,
    required this.onJC,
    required this.onMedicalAppliancee,
    required this.onChineseMedicinee,
    this.onBefore,
    this.onAfter,
  }) : super(key: key);

  final VoidCallback onWestMedicine;
  final VoidCallback onJC;
  final VoidCallback onMedicalAppliancee;
  final VoidCallback onChineseMedicinee;

  /// 前置回调
  final ValueChanged<int>? onBefore;

  /// 后置回调
  final ValueChanged<int>? onAfter;

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Container(
          // height: 246,
          padding: EdgeInsets.only(
            top: 38,
            bottom: 34,
            left: 28,
            right: 28,
          ),
          decoration: BoxDecoration(
              // color: Colorshite70,
              // border: Border(
              //   top: BorderSide(color: Color(0xffe4e4e4)),
              // ),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildWrapBox(
                onBefore: onBefore,
                onAfter: onAfter,
              ),
              SizedBox(
                width: 100,
                // height: 46,
                child: buildWhiteButton(
                    title: "关闭",
                    assetImage: "icon_clear.png".toAssetImage(),
                    assetImageSize: 18,
                    margin: EdgeInsets.only(top: 23),
                    radius: 12,
                    onTap: () {
                      debugPrint("关闭");
                      Navigator.of(context).pop();
                    }),
              )
            ],
          ),
        ),
      ),
    );

    // return ClipRect(
    //   child: BackdropFilter(
    //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //     child: content,
    //   ),
    // );
    return content;
  }

  Widget buildWrapBox({
    ValueChanged<int>? onBefore,
    ValueChanged<int>? onAfter,
  }) {
    final items = [
      Tuple4("西/中成药", "icon_chinese_medicine.png".toPath(), onWestMedicine, Color(0xff55D7D2)),
      Tuple4("检测检验", "icon_jc.png".toPath(), onJC, Color(0xffF7BE65)),
      Tuple4("医疗器械", "icon_medical_appliance.png".toPath(), onMedicalAppliancee, Color(0xff6CA0FB)),
      Tuple4("中药", "icon_chinese_medicine.png".toPath(), onChineseMedicinee, Color(0xffF9A46D)),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      const numPerRow = 4.0;
      final itemWidth = 80.0;
      final spacing = (constraints.maxWidth - itemWidth * numPerRow) / (numPerRow - 1).truncateToDouble();
      final runSpacing = 16.0;

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: items.map((e) {
          final i = items.indexOf(e);
          return InkWell(
            onTap: () {
              onBefore?.call(i);
              e.item3();
              onAfter?.call(i);
            },
            child: SizedBox(
              width: itemWidth,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: e.item4,
                      // borderRadius: BorderRadius.all(Radius.circular(14)),
                      // border: Border.all(),
                      shape: BoxShape.circle,
                    ),
                    child: Image(
                      image: AssetImage(e.item2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      e.item1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.fontColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  /// 创建白色按钮
  Widget buildWhiteButton({
    required String title,
    AssetImage? assetImage,
    double assetImageSize = 20,
    Widget? icon,
    Color color = AppColor.white,
    Color borderColor = const Color(0xffE4E4E4),
    EdgeInsets? margin,
    EdgeInsets? padding,
    double radius = 8,
    required VoidCallback onTap,
  }) {
    Widget image = assetImage == null
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(right: 6),
            child: Image(
              image: assetImage,
              width: assetImageSize,
              height: assetImageSize,
            ),
          );

    return InkWell(
      onTap: onTap,
      child: Container(
          margin: margin ?? EdgeInsets.only(left: 8, top: 14),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(radius.r), //边角
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? image,
              NText(title),
            ],
          )),
    );
  }
}
