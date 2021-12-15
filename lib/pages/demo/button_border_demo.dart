//
//  ButtonBorderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 5:28 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ButtonBorderDemo extends StatefulWidget {

  final String? title;

  ButtonBorderDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ButtonBorderDemoState createState() => _ButtonBorderDemoState();
}

class _ButtonBorderDemoState extends State<ButtonBorderDemo> {


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

  _buildBody() {
    return Center(
      child: Column(
        children: [
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

          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red, width: 1),
            ),
            child: Text('BeveledRectangleBorder'),
            onPressed: () {

            },
          ),

          TextButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue, width: 1),
            ),
            onPressed: (){},
            child: Text('TextButton')
          )

        ],
      ),
    );

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




