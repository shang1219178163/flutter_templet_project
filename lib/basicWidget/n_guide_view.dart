import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/indicator/n_page_indicator.dart';

/// 引导图
class NGuideView<T> extends StatefulWidget {
  const NGuideView({
    super.key,
    required this.length,
    required this.itemBuilder,
    this.indicatorbuilder,
    this.indicatorPadding = const EdgeInsets.symmetric(horizontal: 100, vertical: 34),
    this.indicatorSpacing = 34,
  });

  final int length;

  final NullableIndexedWidgetBuilder itemBuilder;

  final EdgeInsetsGeometry indicatorPadding;
  final double indicatorSpacing;
  final Widget Function(bool isActive)? indicatorbuilder;

  @override
  State<NGuideView> createState() => _NGuideViewState();
}

class _NGuideViewState extends State<NGuideView> {
  late final indexVN = ValueNotifier(0);
  late final pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NGuideView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: widget.length,
          onPageChanged: (index) {
            indexVN.value = index;
          },
          itemBuilder: widget.itemBuilder,
        ),
        if (widget.length > 1)
          Positioned(
            bottom: widget.indicatorSpacing,
            left: 0,
            right: 0,
            child: NPageIndicator(
              length: widget.length,
              listenable: indexVN,
              padding: widget.indicatorPadding,
              builder: widget.indicatorbuilder ??
                  (isActive) {
                    final bgColor = !isActive ? Colors.transparent : Colors.white;
                    return Container(
                      width: 27,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: ShapeDecoration(
                        color: bgColor,
                        shape: const StadiumBorder(
                          side: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    );
                  },
            ),
          ),
      ],
    );
  }
}
