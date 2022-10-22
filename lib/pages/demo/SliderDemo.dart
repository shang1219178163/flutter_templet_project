//
//  SliderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/5/21 9:44 AM.
//  Copyright © 6/5/21 shang. All rights reserved.
//



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// This is the main application widget.
class SliderDemo extends StatefulWidget {

  final String? title;
  SliderDemo({ Key? key, this.title}) : super(key: key);

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {

  var sliderValue = 5.0;

  RangeValues _currentRangeValues = RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title ?? "$widget",
      home: Scaffold(
        appBar: AppBar(title: Text(widget.title ?? "$widget"),),
        body: SafeArea(
          child: _buildBody(),
        )
      )
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Slider'),
        _buildSlider(context),
        Text('RangeSlider'),
        _buildRangeSlider(context),
      ],
    );
  }

  _buildSlider(BuildContext context) {
    return Slider(
      inactiveColor: Color(0xffC0C0C0),
      activeColor: Color(0xff21BA45),
      onChangeStart: (double value) {
        print('Start value is ' + value.toString());
      },
      onChangeEnd: (double value) {
        print('Finish value is ' + value.toString());
      },
      //onChanged: (double value) {},
      divisions: 5,
      //label: 'Admitida',
      value: sliderValue,
      min: 0.0,
      max: 9.0,
      onChanged: (double value) {
        setState(() {
          sliderValue = value;
        });
      },
    );
  }

  _buildRangeSlider(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      min: 0,
      max: 100,
      divisions: 10,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }

}

