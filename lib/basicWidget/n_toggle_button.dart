import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ToggleButton<T> extends StatefulWidget {
  const ToggleButton(
      {super.key,
      required this.onChanged,
      this.borderRadius = 20,
      this.backgroundColor,
      this.sliderColor,
      required this.originData,
      this.selectTextColor,
      this.textColor,
      this.textSize = 12,
      this.margin,
      this.itemWidth = 60,
      this.height = 26,
      this.labelBuilder,
      this.value});

  final double itemWidth;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? sliderColor;
  final Color? selectTextColor;
  final Color? textColor;
  final double textSize;
  final EdgeInsetsGeometry? margin;
  final List<T> originData;
  final T? value;

  final String? Function(T)? labelBuilder;

  final ValueChanged<T> onChanged;

  @override
  State<ToggleButton<T>> createState() => _ToggleButtonState<T>();
}

class _ToggleButtonState<T> extends State<ToggleButton<T>> {
  late double itemWidth;
  late double height;
  late double borderRadius;
  Color? backgroundColor;
  Color? sliderColor;
  Color? selectTextColor;
  Color? textColor;
  late double textSize;
  EdgeInsetsGeometry? margin;

  late List<T> originData;
  T? selected;

  @override
  void initState() {
    super.initState();
    itemWidth = widget.itemWidth;
    height = widget.height;
    borderRadius = widget.borderRadius;
    backgroundColor = widget.backgroundColor;
    sliderColor = widget.sliderColor;
    selectTextColor = widget.selectTextColor;
    textColor = widget.textColor;
    textSize = widget.textSize;
    margin = widget.margin;
    originData = widget.originData;
    if (originData.isNotEmpty) {
      selected = widget.value ?? originData.first;
    }
  }

  @override
  void didUpdateWidget(covariant ToggleButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool shouldUpdate = false;
    if (!listEquals(oldWidget.originData, widget.originData)) {
      originData = widget.originData;
      shouldUpdate = true;

      if (!originData.contains(selected)) {
        selected = widget.value ?? (originData.isNotEmpty ? originData.first : null);
      }
    }

    if (widget.value != null && widget.value != selected) {
      selected = widget.value;
      shouldUpdate = true;
    }
    if (shouldUpdate) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    if (originData.isEmpty) {
      return const SizedBox.shrink();
    }

    final int index = originData.contains(selected) ? originData.indexOf(selected as T) : -1;
    final int itemCount = originData.length;
    final double width = itemWidth * itemCount + 2;
    final double sliderWidth = itemWidth;

    return Container(
      margin: margin ?? const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(1),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: itemWidth * index,
            top: 0,
            width: sliderWidth,
            height: height - 2,
            child: Container(
              decoration: BoxDecoration(
                color: sliderColor ?? themeProvider.color181829OrF6F6F6,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          Row(
            children: List.generate(itemCount, (index) {
              final T value = originData[index];
              final isSelected = value == selected;
              final label = widget.labelBuilder?.call(value) ?? value.toString();

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (selected != value) {
                      setState(() => selected = value);
                      widget.onChanged.call(value);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? selectTextColor ?? const Color(0xFFE44554)
                            : textColor ?? themeProvider.subtitleColor,
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
