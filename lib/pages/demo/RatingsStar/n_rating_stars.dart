//
//  NRatingStars.dart
//  projects
//
//  Created by shang on 2026/1/14 12:24.
//  Copyright © 2026/1/14 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_templet_project/generated/assets.dart';

class NRatingStars extends StatefulWidget {
  const NRatingStars({
    super.key,
    required this.valueVN,
    this.onChanged,
    this.starSize = 21,
    this.starSpacing = 2,
  });

  final ValueNotifier<double> valueVN;
  final Function(double value)? onChanged;

  final double starSize;
  final double starSpacing;

  @override
  State<NRatingStars> createState() => _NRatingStarsState();
}

class _NRatingStarsState extends State<NRatingStars> {
  // late var value = widget.valueVN.value;

  // @override
  // void dispose() {
  //   widget.valueVN.removeListener(onValueLtr);
  //   super.dispose();
  // }
  //
  // @override
  // void initState() {
  //   widget.valueVN.addListener(onValueLtr);
  //   super.initState();
  // }
  //
  // onValueLtr() {
  //   value = widget.valueVN.value;
  //   setState(() {});
  // }

  @override
  void didUpdateWidget(covariant NRatingStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.starSize != widget.starSize) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    return ValueListenableBuilder(
      valueListenable: widget.valueVN,
      builder: (context, value, child) {
        return RatingStars(
          axis: Axis.horizontal,
          value: value,
          onValueChanged: (v) {
            widget.valueVN.value = v;
            widget.onChanged?.call(v);
          },
          starCount: 5,
          starSize: widget.starSize,
          valueLabelColor: Colors.white,
          valueLabelTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 12.0,
          ),
          valueLabelRadius: 10,
          maxValue: 5,
          starSpacing: widget.starSpacing,
          maxValueVisibility: false,
          valueLabelVisibility: false,
          animationDuration: Duration(milliseconds: 0),
          valueLabelPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
          valueLabelMargin: const EdgeInsets.only(right: 8),
          starOffColor: const Color(0xffe7e8ea),
          starColor: Color(0xffE91025),
          starBuilder: (int index, Color? color) {
            final isSelected = index < value;
            final path = isSelected ? Assets.imagesIcRatingStarSelected : Assets.imagesIcRatingStarLight;
            // DLog.d([index, isSelected, color]);
            return Container(
              // decoration: BoxDecoration(
              // color: Colors.transparent,
              // border: Border.all(color: Colors.blue),
              // borderRadius: BorderRadius.all(Radius.circular(0)),
              // ),
              child: Image.asset(
                path,
                width: widget.starSize,
                height: widget.starSize,
              ),
            );
          },
          // angle: 12,
        );
      },
    );
  }
}
