import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_animated_step_line_indicator.dart';

class NHorizalStep<E> extends StatefulWidget {
  const NHorizalStep({
    super.key,
    required this.items,
    this.itemWidth,
    this.itemHeight = 75,
    this.itemBuilder,
    this.itemHeaderBuilder,
    this.itemFooterBuilder,
    this.indicatorColor,
  });

  final List<E> items;
  final double? itemWidth;
  final double itemHeight;
  final Widget Function(BuildContext context, int i, bool isSelected)? itemBuilder;
  final Widget Function(BuildContext context, int i, bool isSelected)? itemHeaderBuilder;
  final Widget Function(BuildContext context, int i, bool isSelected)? itemFooterBuilder;

  final Color? indicatorColor;

  @override
  State<NHorizalStep<E>> createState() => _NHorizalStepState<E>();
}

class _NHorizalStepState<E> extends State<NHorizalStep<E>> {
  final scrollController = ScrollController();

  var selectedIndex = 0;

  @override
  void didUpdateWidget(covariant NHorizalStep<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length || oldWidget.itemWidth != widget.itemWidth) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final seedColor = Theme.of(context).colorScheme.primary;
    final items = widget.items;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final maxWidth = constraints.maxWidth;
      final itemWidth = widget.itemWidth ?? (maxWidth / items.length.toDouble()).truncateToDouble();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: widget.itemHeight,
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final title = i * 100;
                      final subtitle = i * 1010;

                      final isSelected = i == selectedIndex;
                      var color = seedColor;
                      Color unselecedColor = Colors.grey;
                      final currColor = isSelected ? color : unselecedColor;
                      final diverColor = i <= selectedIndex ? color : unselecedColor;
                      final diverHeight = i <= selectedIndex ? 2.0 : 1.0;

                      final isFirst = i == 0;
                      final isLast = i == items.length - 1;

                      return GestureDetector(
                        onTap: () {
                          selectedIndex = i;
                          setState(() {});
                        },
                        child: widget.itemBuilder?.call(context, i, isSelected) ??
                            Container(
                              width: itemWidth,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.itemHeaderBuilder?.call(context, i, isSelected) ??
                                      Text(
                                        title.toString(),
                                        style: TextStyle(fontSize: 13, color: currColor),
                                      ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 1, bottom: 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: buildDivider(
                                            color: isFirst ? diverColor.withOpacity(0.0) : diverColor,
                                            colorEnd: diverColor,
                                            thickness: diverHeight,
                                          ),
                                        ),
                                        buildIndicator(isSelected: isSelected, color: diverColor),
                                        Expanded(
                                          child: buildDivider(
                                            color: diverColor,
                                            colorEnd: diverColor,
                                            thickness: diverHeight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.itemFooterBuilder?.call(context, i, isSelected) ??
                                      Text(
                                        subtitle.toString(),
                                        style: TextStyle(fontSize: 10, color: currColor),
                                      ),
                                ],
                              ),
                            ),
                      );
                    },
                    separatorBuilder: (_, i) {
                      return const SizedBox();
                    },
                    itemCount: items.length,
                  ),
                ),
              ],
            ),
          ),

          /// 底部折线指示器
          NAnimatedStepLineIndicator(
            currentIndex: selectedIndex.toDouble(),
            count: items.length,
            itemWidth: itemWidth,
            spacing: 0,
            color: widget.indicatorColor ?? seedColor,
          )
        ],
      );
    });
  }

  Widget buildIndicator({required bool isSelected, Color color = Colors.green}) {
    if (!isSelected) {
      return CircleAvatar(
        backgroundColor: color,
        minRadius: 2,
        maxRadius: 2,
      );
    }
    return CircleAvatar(
      backgroundColor: color,
      minRadius: 4,
      maxRadius: 4,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        minRadius: 3,
        maxRadius: 3,
        child: CircleAvatar(
          backgroundColor: color,
          minRadius: 2,
          maxRadius: 2,
        ),
      ),
    );
  }

  Widget buildDivider({
    Color color = Colors.grey,
    Color? colorEnd = Colors.grey,
    double thickness = 1,
  }) {
    return Container(
      height: thickness,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color,
            colorEnd ?? color,
          ],
        ),
      ),
    );
  }
}
