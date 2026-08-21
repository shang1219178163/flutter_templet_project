//
//  SliderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/5/21 9:44 AM.
//  Copyright © 6/5/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_animated_slider.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class SliderDemo extends StatefulWidget {
  final String? title;
  const SliderDemo({Key? key, this.title}) : super(key: key);

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  var sliderVN = ValueNotifier(50.0);

  var rangeValues = RangeValues(30, 70);

  final sliderController = AnimatedSliderController();

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // 禁止滑动时的水波纹/放大圈
        overlayShape: SliderComponentShape.noOverlay,
        overlayColor: Colors.transparent,
        trackHeight: 4, // 修改高度
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8.0, //默认
          pressedElevation: 0,
        ), //按下效果
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NSectionBox(
          title: "Slider",
          child: buildSlider(),
        ),
        NSectionBox(
          title: "RangeSlider",
          child: buildRangeSlider(),
        ),
        NSectionBox(
          title: "buildNSlider",
          child: buildNSlider(),
        ),
        NSectionBox(
          title: "Slider",
          child: ValueListenableBuilder(
            valueListenable: sliderVN,
            builder: (context, value, child) {
              return Slider(
                min: 0.0,
                max: 100.0,
                value: value,
                onChanged: (v) {
                  sliderVN.value = v;
                },
              );
            },
          ),
        ),
        NSectionBox(
          title: "AnimatedSlider",
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                AnimatedSlider(
                  controller: sliderController,
                  min: 0.0,
                  max: 100.0,
                  value: sliderVN.value,
                  onChanged: (v) {
                    DLog.d(v);
                  },
                ),
                Row(
                  children: [
                    ...[0.0, 30.0, 60.0, 90.0].map(
                      (e) {
                        return TextButton(
                          onPressed: () {
                            sliderController.animateTo(e);
                            sliderVN.value = e;
                            setState(() {});
                          },
                          child: Text("value $e"),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget buildSlider() {
    return Row(
      children: [
        Expanded(
          child: StatefulBuilder(builder: (context, setState) {
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorColor: Colors.red,
              ),
              child: Slider(
                inactiveColor: Color(0xffC0C0C0),
                activeColor: Color(0xff21BA45),
                onChangeStart: (value) {
                  debugPrint('Start value is $value');
                },
                onChangeEnd: (value) {
                  debugPrint('Finish value is $value');
                },
                //onChanged: (double value) {},
                divisions: 100,
                //label: 'Admitida',
                value: sliderVN.value,
                min: 0.0,
                max: 100.0,
                label: (sliderVN.value / 100).toStringAsFixed(2),
                onChanged: (value) {
                  sliderVN.value = value;
                  setState(() {});
                },
              ),
            );
          }),
        ),
        ValueListenableBuilder(
          valueListenable: sliderVN,
          builder: (context, value, child) {
            final result = (value / 100).toStringAsFixed(2);
            return TextButton(
              onPressed: () {
                debugPrint(result);
              },
              child: Text(result),
            );
          },
        ),
      ],
    );
  }

  Widget buildRangeSlider() {
    return RangeSlider(
      values: rangeValues,
      min: 0,
      max: 100,
      divisions: 10,
      labels: RangeLabels(
        rangeValues.start.round().toString(),
        rangeValues.end.round().toString(),
      ),
      onChanged: (values) {
        setState(() {
          rangeValues = values;
        });
      },
    );
  }

  Widget buildNSlider() {
    return NSlider(
      min: 0.0,
      max: 100.0,
      value: sliderVN.value,
      leading: IconButton(
        icon: Icon(Icons.download),
        onPressed: () {
          debugPrint("Downloading");
        },
      ),
      onChangeEnd: (value) {
        debugPrint('NNSlider onChangeEnd: $value');
        sliderVN.value = value;
        setState(() {});
      },
      trailingBuilder: (context, value) {
        // final result = (value/100).toStringAsFixed(2);
        final result = "${value.toStringAsFixed(0)}%";

        return TextButton(
          onPressed: () {
            debugPrint("Downloading");
          },
          child: Text(result),
        );
      },
    );
  }
}
