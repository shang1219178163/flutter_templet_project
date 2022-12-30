
import 'package:flutter/material.dart';

typedef PageIndicatorItemWidgetBuilder = Widget Function(bool isSelected, Size itemSize);

/// 轮播图指示器
class PageIndicatorWidget extends StatelessWidget {

  PageIndicatorWidget({ 
    Key? key, 
    this.margin = const EdgeInsets.only(bottom: 10),
    required this.currentIndex,
    required this.itemCount,
    this.normalColor = const Color(0x25ffffff), 
    this.selectedColor = Colors.white,
    this.itemSize = const Size(8, 2),
    this.itemBuilder,
  }) : super(key: key);

  ValueNotifier<int> currentIndex;

  EdgeInsetsGeometry? margin;

  int itemCount;
  Size itemSize;
  PageIndicatorItemWidgetBuilder? itemBuilder;

  Color? normalColor;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return buildPageIndicator();
  }

  Widget buildPageIndicator() {
    return Container(
      margin: this.margin,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: buildPageIndicatorItem(
                currentIndex: this.currentIndex.value,
                normalColor: this.normalColor,
                selectedColor: this.selectedColor,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildPageIndicatorItem({
    currentIndex: 0,
    normalColor: const Color(0x25ffffff), 
    selectedColor: Colors.white,
  }) {
    List<Widget> list = List.generate(this.itemCount, (index) {
      return this.itemBuilder != null ? this.itemBuilder!(currentIndex == index, this.itemSize) : ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(1)),
        child: Container(
          width: this.itemSize.width,
          height: this.itemSize.height,
          color: currentIndex == index ? selectedColor : normalColor,
        ),
      );
    });
    return list;
  }
}