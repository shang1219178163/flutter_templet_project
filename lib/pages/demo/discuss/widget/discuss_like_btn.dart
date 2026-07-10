import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_scale_button.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 点赞按钮
class DiscussLikeBtn extends StatefulWidget {
  const DiscussLikeBtn({
    super.key,
    required this.likeNumber,
    required this.like,
    this.likeNumberZeroStr = "赞",
    required this.onLike,
    // required this.onEnable,
    required this.disable,
    this.onDisable,
  });

  final String? likeNumberZeroStr;
  final int likeNumber;
  final bool like;

  final Future<Map<String, dynamic>> Function() onLike;

  // /// 是否响应点击
  // final bool Function()? onEnable;

  final bool disable;

  final VoidCallback? onDisable;

  @override
  State<DiscussLikeBtn> createState() => _DiscussLikeBtnState();
}

class _DiscussLikeBtnState extends State<DiscussLikeBtn> {
  int likeNumber = 0;
  bool like = false;

  late final themeProvider = context.read<ThemeProvider>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    like = widget.like;
    likeNumber = widget.likeNumber;
  }

  @override
  void didUpdateWidget(covariant DiscussLikeBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.like != widget.like ||
        oldWidget.likeNumber != widget.likeNumber ||
        oldWidget.likeNumberZeroStr != widget.likeNumberZeroStr ||
        oldWidget.onLike != widget.onLike ||
        oldWidget.disable != widget.disable ||
        oldWidget.onDisable != widget.onDisable) {
      initData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // likeNumber = 10000;//add test
    var likeNumberStr = likeNumber < 10000 ? "$likeNumber" : "9999+";
    if (likeNumber == 0 && widget.likeNumberZeroStr?.isNotEmpty == true) {
      likeNumberStr = widget.likeNumberZeroStr ?? "";
    }

    final isLike = like ?? false;
    final likeIcon = isLike == true ? Assets.discussIcLikeHighlighted : Assets.discussIcLike;

    return NPair(
      spacing: 0,
      isReverse: true,
      icon: NScaleButton(
        enabled: !widget.disable,
        tween: Tween<double>(begin: 1.0, end: 1.5),
        builder: (AnimationController controller) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(left: 2, top: 0, bottom: 0),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.blue),
              // ),
              child: Image(
                image: AssetImage(likeIcon),
                width: 18,
                height: 18,
              ),
            ),
          );
        },
      ),
      child: Text(
        likeNumberStr,
        style: TextStyle(
          color: isLike ? AppColor.cancelColor : AppColor.fontColor999999,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: "PingFang SC",
        ),
      ),
    );
  }

  onTap() async {
    if (widget.disable) {
      widget.onDisable?.call();
      return;
    }
    final map = await widget.onLike();
    if (map.isEmpty) {
      return;
    }
    DLog.d(["onLike", map]);
    like = map["like"] ?? false;
    likeNumber = map["likeNumber"] ?? 0;
    setState(() {});
  }
}
