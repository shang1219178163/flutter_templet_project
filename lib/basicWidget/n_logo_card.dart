import 'package:flutter/material.dart';
import 'package:social_fe_app/value/app_font_family.dart';

import 'en_decoration_image.dart';

/// 带 logo 的 card 组件
class NLogoCard extends StatelessWidget {
  const NLogoCard({
    super.key,
    required this.name,
    required this.color,
    required this.logo,
    this.margin,
    this.padding = const EdgeInsets.all(12),
    this.radius = 0,
    this.header,
    required this.child,
  });

  final String name;
  final Color color;
  final AssetImage? logo;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double radius;
  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        image: logo == null
            ? null
            : EnDecorationImage(
                image: logo!,
                scale: 3,
                alignment: Alignment.topRight,
                destinationOffset: const Offset(-12, 5),
              ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header ?? Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFontFamily.dingTalk.value,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
