//
//  NumberStepperDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/13/21 6:26 AM.
//  Copyright © 6/13/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/number_stepper.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NumberStepperDemo extends StatelessWidget {
  const NumberStepperDemo({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: kPrimaryColor,
        title: Text("NumberStepperDemo"),
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
                  onPressed: () { ddlog("onPressed"); },
                  child: Icon(Icons.security, color: Colors.white,),
                ),
              ),
              SizedBox(height: 20,),
              UnconstrainedBox(
                child: NumberStepper(
                  min: 1,
                  max: 1000,
                  step: 100,
                  iconSize: 60,
                  value: 1000,
                  color: Theme.of(context).primaryColor,
                  canEdit: false,
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                  onChanged: (value){
                    ddlog(value);
                  },
                ),
              ),
              SizedBox(height: 20,),
              UnconstrainedBox(
                child: NumberStepper(
                  min: 1,
                  max: 99999,
                  step: 100,
                  iconSize: 40,
                  value: 99999,
                  color: Theme.of(context).primaryColor,
                  canEdit: false,
                  onChanged: (value){
                    ddlog(value);
                  },
                ),
              ),
              SizedBox(height: 20,),
              NumberStepper(
                min: 1,
                max: 99999,
                step: 1,
                iconSize: 32,
                value: 999,
                color: Theme.of(context).primaryColor,
                onChanged: (value){
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
                    min: 1,
                    max: 1000,
                    step: 100,
                    iconSize: 30,
                    value: 1000,
                    color: Colors.red,
                    onChanged: (value){
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