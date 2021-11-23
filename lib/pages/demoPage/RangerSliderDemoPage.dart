//
//  RangerSliderDemoPage.dart
//  fluttertemplet
//
//  Created by shang on 6/5/21 9:44 AM.
//  Copyright © 6/5/21 shang. All rights reserved.
//



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// This is the main application widget.
class RangerSliderDemoPage extends StatefulWidget {

  final String? title;
  RangerSliderDemoPage({ Key? key, this.title}) : super(key: key);

  @override
  _RangerSliderDemoPageState createState() => _RangerSliderDemoPageState();
}

class _RangerSliderDemoPageState extends State<RangerSliderDemoPage> {

  RangeValues _currentRangeValues = RangeValues(40, 80);

  var sliderValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title ?? "$widget",
      home: Scaffold(
        appBar: AppBar(title: Text(widget.title ?? "$widget"),),
        body: SafeArea(
          child: Column(
            children: [
              buildRangeSlider(context),
              buildSlider(context),
            ],
          ),
        )
      )
    );
  }

  Widget buildRangeSlider(BuildContext context) {
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

  Widget buildSlider(BuildContext context) {
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
}

