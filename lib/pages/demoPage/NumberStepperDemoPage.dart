//
//  NumberStepperDemoPage.dart
//  flutter_templet_project
//
//  Created by shang on 6/13/21 6:26 AM.
//  Copyright © 6/13/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NumberStepper.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class NumberStepperDemoPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: kPrimaryColor,
        title: Text("Custom Stepper"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                  // border: Border.all(color: Theme.of(context).primaryColor, width: 1), // 边色与边宽度
                ),
                child: OutlinedButton(
                  style: ButtonStyle(
                    padding:  MaterialStateProperty.all(EdgeInsets.zero),
                    minimumSize: MaterialStateProperty.all(Size(44, 44)),
                  ),
                  child: Icon(Icons.security, color: Colors.white,),
                  onPressed: () { ddlog("onPressed"); },
                ),
              ),
              Spacer(),
              NumberStepper(
                minValue: 1,
                maxValue: 1000,
                stepValue: 100,
                iconSize: 60,
                value: 1000,
                color: Theme.of(context).primaryColor,
                style: NumberStepperStyle.system,
                block: (value){
                  ddlog(value);
                },
              ),
              SizedBox(height: 20,),
              NumberStepper(
                minValue: 1,
                maxValue: 1000,
                stepValue: 100,
                iconSize: 40,
                value: 1000,
                color: Theme.of(context).primaryColor,
                style: NumberStepperStyle.outlined,
                block: (value){
                  ddlog(value);
                },
              ),
              Spacer(),
              NumberStepper(
                minValue: 1,
                maxValue: 1000,
                stepValue: 100,
                iconSize: 30,
                value: 1000,
                color: Theme.of(context).primaryColor,
                style: NumberStepperStyle.textfield,
                block: (value){
                  ddlog(value);
                },
              ),

              Spacer(),

            ],
          ),
        ),
      ),
    );
  }


  Widget buildCard(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.red,
                  offset: Offset(0, 20),
                  blurRadius: 30.0),
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/avatar.png',fit: BoxFit.fitWidth,),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0,left: 8.0),
              child: Text('Juicy Strawberry',style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0,left: 8.0),
              child: Row(
                children: [
                  Text('\$20.40',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  NumberStepper(
                    minValue: 1,
                    maxValue: 1000,
                    stepValue: 100,
                    iconSize: 30,
                    value: 1000,
                    color: Colors.red,
                    block: (value){
                      ddlog(value);
                    },
                  )
                ],
              ),
            ),

          ],
        ),
      ));
  }


}