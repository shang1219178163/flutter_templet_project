//
//	StepperDemo.dart
//	MacTemplet
//
//	Created by Bin Shang on 2021/06/11 17:15
//	Copyright © 2021 Bin Shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

import 'package:tuple/tuple.dart';
import '../../basicWidget/enhance_stepper.dart';


///步骤一二三
class StepperDemo extends StatefulWidget {
  const StepperDemo({Key? key}) : super(key: key);

  @override
  _StepperDemoState createState() => _StepperDemoState();
}


class _StepperDemoState extends State<StepperDemo> {
  StepperType _type = StepperType.vertical;

  int groupValue = 0;

  List<Tuple2> tuples = [
    Tuple2(Icons.directions_bike, StepState.indexed, ),
    Tuple2(Icons.directions_bus, StepState.editing, ),
    Tuple2(Icons.directions_railway, StepState.complete, ),
    Tuple2(Icons.directions_boat, StepState.disabled, ),
    Tuple2(Icons.directions_car, StepState.error, ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$widget"),
          actions: [
            TextButton(
              onPressed: (){
                ddlog("change");
                setState(() {
                  _type = _type == StepperType.vertical ? StepperType.horizontal : StepperType.vertical;
                });
              },
              child: Icon(Icons.change_circle_outlined,
                color: Colors.white,)),
          ],
          bottom: buildPreferredSize(context),
        ),
        // body: buildStepper(context),
        body: groupValue == 0 ? buildStepper(context) : buildStepperCustom(context),
      //   body: Theme(
      //     data: ThemeData(
      //     accentColor: Colors.orange,
      //     primarySwatch: Colors.orange,
      //     colorScheme: ColorScheme.light(
      //     primary: Colors.orange
      //     )
      //   ),
      //     child: buildStepperCustom(context),
      // ),
    );
  }

  PreferredSizeWidget buildPreferredSize(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 48),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 24),
            Expanded(
              child: CupertinoSegmentedControl(
                children: const <int, Widget>{
                  0: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Stepper', style: TextStyle(fontSize: 15))),
                  1: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('enhance_stepper', style: TextStyle(fontSize: 15))),
                },
                groupValue: groupValue,
                onValueChanged: (value) {
                  // TODO: - fix it
                  ddlog(value.toString());
                  setState(() {
                    groupValue = int.parse("$value");
                  });
                },
                borderColor: Colors.white,
                unselectedColor: Theme.of(context).primaryColor,
                selectedColor: Colors.white,
              ),
            ),
            SizedBox(width: 24)
          ],
        ),
      ),
    );
  }

  void go(int index) {
    if (index == -1 && _index <= 0 ) {
      ddlog("it's first Step!");
      return;
    }

    if (index == 1 && _index >= tuples.length - 1) {
      ddlog("it's last Step!");
      return;
    }

    setState(() {
      _index += index;
    });
  }

  Widget buildStepper(BuildContext context) {
    return Stepper(
        type: _type,
        currentStep: _index,
        physics: ClampingScrollPhysics(),
        steps: tuples.map((e) => Step(
          state: StepState.values[tuples.indexOf(e)],
          isActive: _index == tuples.indexOf(e),
          title: Text("step ${tuples.indexOf(e)}"),
          subtitle: Text(e.item2.toString().split(".").last,),
          content: Text("Content for Step ${tuples.indexOf(e)}"),
      )).toList(),
      onStepCancel: () {
        go(-1);
      },
      onStepContinue: () {
        go(1);
      },
      onStepTapped: (index) {
        ddlog(index);
        setState(() {
          _index = index;
        });
      },
      controlsBuilder: (BuildContext context, ControlsDetails details){
        return Row(
          children: [
            SizedBox(height: 30,),
            if (_index != tuples.length - 1) ElevatedButton(
              onPressed: details.onStepContinue,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
              child: Text("Continue"),
            ),
            SizedBox(width: 8,),
            if (_index != 0)  ElevatedButton(
              onPressed: details.onStepCancel,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
              child: Text("Cancel"),
            ),
          ],
        );
      }
    );
  }

  Widget buildStepperCustom(BuildContext context) {
    return EnhanceStepper(
        stepIconSize: 30,
        type: _type,
        horizontalTitlePosition: HorizontalTitlePosition.bottom,
        horizontalLinePosition: HorizontalLinePosition.top,
        currentStep: _index,
        physics: ClampingScrollPhysics(),
        steps: tuples.map((e) => EnhanceStep(
          icon: Icon(e.item1, color: Theme.of(context).primaryColor, size: 30,),
          state: StepState.values[tuples.indexOf(e)],
          isActive: _index == tuples.indexOf(e),
          title: Text("step ${tuples.indexOf(e)}"),
          subtitle: Text(e.item2.toString().split(".").last,),
          // content: Text("Content for Step ${tuples.indexOf(e)}"),
          content: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height/tuples.length,
            height: MediaQuery.of(context).size.height*0.55,
            color: Colors.green.randomOpacity(),
            child: Text("Content for Step ${tuples.indexOf(e)}"),
          ),
          
        )).toList(),
        onStepCancel: () {
          go(-1);
        },
        onStepContinue: () {
          go(1);
        },
        onStepTapped: (index) {
          ddlog(index);
          setState(() {
            _index = index;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details){
          return Row(
            children: [
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: details.onStepContinue,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                child: Text("Next"),
              ),
              SizedBox(width: 8,),
              TextButton(
                onPressed: details.onStepCancel,
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                child: Text("Back"),
              ),
            ],
          );
        }
    );
  }

  Widget buildRow(String title) {
    return Row(
      children: <Widget>[
        Container(
          height: 72.0,
          child: Center(
            child: Icon(Icons.security),
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 12.0),
          child: Text(title),
        ),
      ],
    );
  }

}
