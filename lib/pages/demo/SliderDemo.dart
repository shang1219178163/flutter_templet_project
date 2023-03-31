//
//  SliderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/5/21 9:44 AM.
//  Copyright © 6/5/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_slider.dart';
import 'package:flutter_templet_project/provider/notifier_demo.dart';


/// This is the main application widget.
class SliderDemo extends StatefulWidget {

  final String? title;
  const SliderDemo({ Key? key, this.title}) : super(key: key);

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {

  var sliderVN = ValueNotifier(50.0);

  RangeValues _rangeValues = RangeValues(30, 70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? "$widget"),),
      body: SafeArea(
        child: _buildBody(),
      )
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Slider'),
        _buildSlider(),
        Text('RangeSlider'),
        _buildRangeSlider(),

        _buildNNSlider()
      ],
    );
  }

  _buildSlider() {
    return Row(
      children: [
        Expanded(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorColor: Colors.red,
                  ),
                  child: Slider(
                    inactiveColor: Color(0xffC0C0C0),
                    activeColor: Color(0xff21BA45),
                    onChangeStart: (double value) {
                      debugPrint('Start value is $value');
                    },
                    onChangeEnd: (double value) {
                      debugPrint('Finish value is $value');
                    },
                    //onChanged: (double value) {},
                    divisions: 100,
                    //label: 'Admitida',
                    value: sliderVN.value,
                    min: 0.0,
                    max: 100.0,
                    label: (sliderVN.value/100).toStringAsFixed(2),

                    onChanged: (double value) {
                      sliderVN.value = value;
                      setState(() {});
                    },
                  )
              );
            }
          ),
        ),
        ValueListenableBuilder(
          valueListenable: sliderVN,
          builder: (BuildContext context, double value, Widget? child) {
            final result = (value/100).toStringAsFixed(2);
            return TextButton(
              onPressed: () { debugPrint(result); },
              child: Text(result),
            );
          }
        ),
      ],
    );
  }

  _buildRangeSlider() {
    return RangeSlider(
      values: _rangeValues,
      min: 0,
      max: 100,
      divisions: 10,
      labels: RangeLabels(
        _rangeValues.start.round().toString(),
        _rangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _rangeValues = values;
        });
      },
    );
  }

  _buildNNSlider() {
    return NNSlider(
      max: 100,
      leading: IconButton(
        icon: Icon(Icons.download),
        onPressed: () {
          debugPrint("Downloading");
        },
      ),
      onChangeEnd: (double value) {
        debugPrint('NNSlider onChangeEnd: $value');
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

