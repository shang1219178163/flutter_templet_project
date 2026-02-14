import 'package:flutter/material.dart';

import 'package:flutter_templet_project/generated/assets.dart';

/// 播放器上的直线指示器
class NLineProgressIndicator extends StatelessWidget {
  const NLineProgressIndicator({
    super.key,
    this.width = 160,
    this.prefix = const AssetImage(Assets.imagesIcBrightnessWhite),
    this.prefixSize = 16,
    this.backgroundColor = const Color(0xB3000000),
    this.progressValueColor = const Color(0xFFE91025),
    this.progressBgColor = const Color(0xff7c7c85),
    required this.valueVN,
  });

  final double? width;
  final AssetImage prefix;
  final double prefixSize;

  final Color backgroundColor;
  final Color progressValueColor;
  final Color progressBgColor;

  final ValueNotifier<double> valueVN;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueVN,
      child: Image(
        image: prefix,
        width: prefixSize,
        height: prefixSize,
        fit: BoxFit.cover,
      ),
      builder: (context, value, child) {
        return Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: StadiumBorder(),
          ),
          child: Row(
            children: [
              if (child != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: child,
                ),
              Expanded(
                child: LinearProgressIndicator(
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(3),
                  value: value,
                  backgroundColor: progressBgColor,
                  valueColor: AlwaysStoppedAnimation(
                    progressValueColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 视频音量指示器
class VolumeProgressIndicator extends NLineProgressIndicator {
  const VolumeProgressIndicator({
    super.key,
    super.width,
    required super.valueVN,
  }) : super(
          prefix: const AssetImage(Assets.imagesIcVolumeWhite),
        );
}

/// 视频亮度指示器
class BrightnessProgressIndicator extends NLineProgressIndicator {
  const BrightnessProgressIndicator({
    super.key,
    super.width,
    required super.valueVN,
  }) : super(
          prefix: const AssetImage(Assets.imagesIcBrightnessWhite),
        );
}
