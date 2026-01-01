import 'package:flutter/material.dart';

import 'package:flutter_templet_project/generated/assets.dart';

/// 弹窗底部指示条
class NPoppuBottomIndicator extends StatelessWidget {
  const NPoppuBottomIndicator({
    super.key,
    this.title = "收起",
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: AssetImage(Assets.imagesImagePopupBottomIndicatorLight),
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              const Image(
                image: AssetImage(Assets.imagesIconArrowUp),
                width: 10,
                height: 5,
              )
            ],
          ),
        ),
      ],
    );
  }
}
