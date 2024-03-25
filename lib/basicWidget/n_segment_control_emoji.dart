

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';


class NSegmentControlEmoji extends StatefulWidget {

  const NSegmentControlEmoji({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.segmentGap = 5,
    this.segmentRadius = 4,
    this.segmentPadding = const EdgeInsets.symmetric(vertical: 7),
    required this.onChanged,
  });
  /// 数据源
  final List<SegmentEmojiModel> items;
  /// 默认选项
  final int selectedIndex;
  /// 间距
  final double segmentGap;
  /// 圆角
  final double segmentRadius;
  /// 内边距
  final EdgeInsets segmentPadding;

  final ValueChanged<int> onChanged;

  @override
  State<NSegmentControlEmoji> createState() => _NSegmentControlEmojiState();
}

class _NSegmentControlEmojiState extends State<NSegmentControlEmoji> {


  late var current = widget.items[widget.selectedIndex];

  @override
  void didUpdateWidget(covariant NSegmentControlEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (
      oldWidget.items != widget.items ||
      oldWidget.selectedIndex != widget.selectedIndex ||
      oldWidget.segmentGap != widget.segmentGap ||
      oldWidget.segmentRadius != widget.segmentRadius ||
      oldWidget.segmentPadding != widget.segmentPadding ||
      oldWidget.onChanged != widget.onChanged
    ) {
      current = widget.items[widget.selectedIndex];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSegmentControl(
      items: widget.items,
      segmentGap: widget.segmentGap,
      segmentRadius: widget.segmentRadius,
      segmentPadding: widget.segmentPadding,
      onChanged: widget.onChanged,
    );
  }

  Widget buildSegmentControl({
    required List<SegmentEmojiModel> items,
    double segmentGap = 5,
    double segmentRadius = 4,
    EdgeInsets segmentPadding = const EdgeInsets.symmetric(vertical: 7),
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((e){

        final index = items.indexOf(e);
        final isSelected = current == e;
        final iconColor = isSelected ? e.activeColor : null;
        final textColor = isSelected ? e.activeColor : Colors.black54;

        return Expanded(
          child: InkWell(
            onTap: (){
              current = e;
              setState((){});
              onChanged(index);
            },
            child: Container(
              margin: EdgeInsets.only(left: index == 0 ? 0 : segmentGap),
              padding: segmentPadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor?.withOpacity(0.08),
                borderRadius: BorderRadius.all(Radius.circular(segmentRadius)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(e.iconPath.isNotEmpty)Image(
                    image: AssetImage(e.iconPath),
                    width: 25,
                    height: 25,
                    color: iconColor,
                  ),
                  if(e.iconPath.isNotEmpty || e.name.isNotEmpty)SizedBox(width: 6,),
                  if(e.name.isNotEmpty)Flexible(
                    child: Text(e.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class SegmentEmojiModel{
  SegmentEmojiModel({
    required this.iconPath,
    required this.name,
    required this.activeColor,
    this.child,
  });

  String iconPath;
  String name;
  Color activeColor;
  Widget? child;
}