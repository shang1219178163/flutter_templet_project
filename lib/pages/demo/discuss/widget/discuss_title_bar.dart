import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 评论筛选栏
class DiscussTitleBar extends StatefulWidget {
  const DiscussTitleBar({
    super.key,
    required this.title,
    this.hasIndicator = true,
    this.style,
    this.trailing,
    this.isHot = false,
  });

  final bool hasIndicator;
  final String title;
  final TextStyle? style;
  final Widget? trailing;
  final bool isHot;

  static const double barHeight = 44;

  @override
  State<DiscussTitleBar> createState() => _DiscussTitleBarState();
}

class _DiscussTitleBarState extends State<DiscussTitleBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
  late final themeProvider = context.read<ThemeProvider>();

  @override
  void dispose() {
    // tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    // DLog.d([hashCode, tabController.index]);
  }

  @override
  void didUpdateWidget(covariant DiscussTitleBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title ||
        oldWidget.hasIndicator != widget.hasIndicator ||
        oldWidget.style != widget.style ||
        oldWidget.isHot != widget.isHot) {
      initData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final style = TextStyle(
      color: widget.isHot ? AppColor.cancelColor : themeProvider.titleColor,
      fontSize: 14.5,
      fontWeight: FontWeight.w500,
      fontFamily: "PingFang SC",
    );


    return SizedBox(
      height: DiscussTitleBar.barHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themeProvider.color242434OrWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.hasIndicator)
                Container(
                  width: 2,
                  height: 18,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                    color: AppColor.cancelColor,
                  ),
                ),
              Expanded(
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.transparent,
                  //   border: Border.all(color: Colors.blue),
                  //   borderRadius: BorderRadius.all(Radius.circular(0)),
                  // ),
                  child: Text(
                    widget.title,
                    style: widget.style ?? style,
                  ),
                ),
              ),
              if (widget.trailing != null)
               widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
