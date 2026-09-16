import 'package:flutter/material.dart';

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

  @override
  State<DiscussTitleBar> createState() => _DiscussTitleBarState();
}

class _DiscussTitleBarState extends State<DiscussTitleBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final cs = Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {}

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
    final accent = cs.primary;
    final style = TextStyle(
      color: widget.isHot ? accent : cs.onSurface,
      fontSize: 14.5,
      fontWeight: FontWeight.w500,
      fontFamily: "PingFang SC",
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                  color: accent,
                ),
              ),
            Expanded(
              child: Text(
                widget.title,
                style: widget.style ?? style,
              ),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
