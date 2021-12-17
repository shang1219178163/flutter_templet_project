//
//  ButtonBorderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 5:28 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class BorderDemo extends StatefulWidget {

  final String? title;

  BorderDemo({ Key? key, this.title}) : super(key: key);


  @override
  _BorderDemoState createState() => _BorderDemoState();
}

class _BorderDemoState extends State<BorderDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildHeaderText(String data) {
    return Column(
        children: [
          Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
        ]
    );
  }

  _buildBody() {
    return ListView(
      children: [
        Column(
          children: [
            _buildHeaderText("OutlinedButton - ButtonStyle - BorderSide"),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red, width: 1),
              ),
              child: Text('BeveledRectangleBorder'),
              onPressed: () {

              },
            ),

            _buildHeaderText("TextButton - ButtonStyle - BorderSide"),

            TextButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
                onPressed: (){},
                child: Text('TextButton')
            ),

            _buildHeaderText("ElevatedButton - ButtonStyle - OutlinedBorder"),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildBeveledRectangleBorder(radius: 0),
              ),
              child: Text('BeveledRectangleBorder'),
              onPressed: () {

              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildBeveledRectangleBorder(radius: 10),
              ),
              child: Text('BeveledRectangleBorder'),
              onPressed: () {

              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildBeveledRectangleBorder(radius: 100),
              ),
              child: Text('BeveledRectangleBorder'),
              onPressed: () {

              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildCircleBorder(),
                minimumSize: Size(100, 100),
              ),
              child: Text('CircleBorder'),
              onPressed: () {

              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildContinuousRectangleBorder(radius: 20),
              ),
              child: Text('ContinuousRectangleBorder'),
              onPressed: () {

              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildRoundedRectangleBorder(radius: 8),
              ),
              child: Text('RoundedRectangleBorder'),
              onPressed: () {

              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: _buildStadiumBorder(radius: 20),
              ),
              child: Text('StadiumBorder'),
              onPressed: () {

              },
            ),


            _buildHeaderText("Container - BoxDecoration - BoxBorder"),

            Container(
              child: Icon(Icons.pool, size: 32, color: Colors.white,),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border(
                      top: BorderSide(color: Colors.red, width: 3,)
                  )
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                iconSize: 56,
                icon: Icon(Icons.check),
                onPressed: () {},
              ),
            ),

            _buildContainerBorder(),
          ],
        ),
      ],
    );

  }

  _buildContainerBorder() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildHeaderText("Container - ShapeDecoration - ShapeBorder",),

        Container(
          margin: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            // color: Colors.green,
            shape: Border.all(color: Colors.green, width: 2)
          ),
          child: TextButton(child: Text("ShapeDecoration - Border.all"), onPressed: () {  },),
        ),

        Container(
          margin: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            shape: Border(
              top: BorderSide(color: Colors.red, width: 5),
              bottom: BorderSide(color: Colors.yellow, width: 5),
              right: BorderSide(color: Colors.blue, width: 5),
              left: BorderSide(color: Colors.green, width: 5)
            )
          ),
          child: TextButton(child: Text('ShapeDecoration - Border.top,bottom,right,left'), onPressed: () {  },),
        ),

        Container(
          margin: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.yellowAccent,
              shape: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2))
          ),
          child: TextButton(child: Text('ShapeDecoration - UnderlineInputBorder'), onPressed: () {  },),
        ),

        Container(
          margin: EdgeInsets.all(8),
          decoration: ShapeDecoration(
              color: Colors.yellowAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: Colors.red, width: 2))
          ),
          child: TextButton(child: Text('ShapeDecoration - RoundedRectangleBorder'), onPressed: () {  },),
        ),

        Container(
          margin: EdgeInsets.all(8),
          decoration: ShapeDecoration(
              color: Colors.yellowAccent,
              shape: CircleBorder(side: BorderSide(color: Colors.red, width: 2))
          ),
          child: TextButton(child: Text('ShapeDecoration - CircleBorder'), onPressed: () {  },),
        ),

        Container(
          margin: EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.yellowAccent,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.red, width: 2))
          ),
          child: TextButton(child: Text('ShapeDecoration - BeveledRectangleBorder'), onPressed: () {  },),
        ),

        Container(
          margin: EdgeInsets.all(8),
          decoration: new UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.red),
              insets: EdgeInsets.fromLTRB(0, 0, 0, 10)
          ),
          child: TextButton(child: Text('UnderlineTabIndicator - borderSide'), onPressed: () {  },),
        ),
      ]);

  }

  /// 斜角矩形边框
  _buildBeveledRectangleBorder({required double radius, double width = 1, Color color = Colors.red,}) {
    return BeveledRectangleBorder(
        side: BorderSide(width: width, color: color),
        borderRadius: BorderRadius.circular(radius)
    );
  }

  /// 斜角矩形边框
  _buildCircleBorder({double width = 1, Color color = Colors.red,}) {
    return CircleBorder(
        side: BorderSide(width: width, color: color),
    );
  }

  /// 连续的圆角矩形，直线和圆角平滑连续的过渡，和RoundedRectangleBorder相比，圆角效果会小一些。
  _buildContinuousRectangleBorder({required double radius, double width = 1, Color color = Colors.red,}) {
    return ContinuousRectangleBorder(
        side: BorderSide(width: width, color: color),
        borderRadius: BorderRadius.circular(radius)
    );
  }

  /// 圆角矩形
  _buildRoundedRectangleBorder({required double radius, double width = 1, Color color = Colors.red,}) {
    return RoundedRectangleBorder(
        side: BorderSide(width: width, color: color),
        borderRadius: BorderRadius.circular(radius)
    );
  }

  /// 类似足球场的形状，两边圆形，中间矩形
  _buildStadiumBorder({required double radius, double width = 1, Color color = Colors.red,}) {
    return StadiumBorder(
        side: BorderSide(width: width, color: color),
    );
  }


  _buildShapeBorder({Color color = Colors.red,}){
    return ShapeDecoration(
      color: color,
      shape: Border(
          top: BorderSide(color: Colors.red, width: 15),
          bottom: BorderSide(color: Colors.yellow, width: 15),
          right: BorderSide(color: Colors.blue, width: 15),
          left: BorderSide(color: Colors.green, width: 15)
      )
    );
  }
  /// 带外边框
  _buildOutlineInputBorder({required double radius, double width = 1, Color color = Colors.red,}) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: width, color: color),
      borderRadius: BorderRadius.circular(radius),
    );
  }
  /// 下划线边框
  _buildUnderlineInputBorder({required double radius, double width = 1, Color color = Colors.red,}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(width: width, color: color),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}




