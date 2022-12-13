import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 曝光检测
class VisibilityDetectorDemo extends StatefulWidget {

  final String? title;

  VisibilityDetectorDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _VisibilityDetectorDemoState createState() => _VisibilityDetectorDemoState();
}

class _VisibilityDetectorDemoState extends State<VisibilityDetectorDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemBuilder: (context, i) {
        return _buildRow(i);
      }
    );
  }

  Widget _buildRow(int i) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, j) {
          String key = '$i - $j';
          return Container(
            width: 200,
            height: 180,
            margin: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1)
            ),
            child: VisibilityDetector(
              key: Key(key),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                debugPrint('Widget ${visibilityInfo.key} is ${visiblePercentage.toInt()}% visible');
              },
              child: Center(
                child: Text(key, style: TextStyle(fontSize: 18.0)),
              ),
            ),
          );
        },
      ),
    );
  }
}