import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter_templet_project/util/R.dart';

/// 曝光检测
class VisibilityDetectorDemo extends StatefulWidget {
  final String? title;

  const VisibilityDetectorDemo({Key? key, this.title}) : super(key: key);

  @override
  _VisibilityDetectorDemoState createState() => _VisibilityDetectorDemoState();
}

class _VisibilityDetectorDemoState extends State<VisibilityDetectorDemo> {
  final percentVN = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return VisibilityDetector(
      key: Key("page"),
      onVisibilityChanged: (visibilityInfo) {
        percentVN.value = visibilityInfo.visibleFraction;

        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'Widget ${visibilityInfo.key} is ${visiblePercentage.toInt()}% visible');
      },
      child: _buildPage1(),
    );

    // return _buildPage();
    return _buildPage1();
  }

  Widget _buildPage() {
    return ListView.builder(itemBuilder: (context, i) {
      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, j) {
            var key = '$i - $j';
            return Container(
              width: 200,
              // height: 180,
              margin: EdgeInsets.all(3.0),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: VisibilityDetector(
                key: Key(key),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  debugPrint(
                      'Widget ${visibilityInfo.key} is ${visiblePercentage.toInt()}% visible');
                },
                child: Center(
                  child: Text(key, style: TextStyle(fontSize: 18.0)),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildPage1() {
    final imgUrls = R.image.urls;
    return ListView.builder(
        itemCount: imgUrls.length,
        itemBuilder: (context, i) {
          var key = '$i';
          var url = imgUrls[i];

          return Container(
            // width: 200,
            height: 180,
            margin: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                )),
            child: VisibilityDetector(
              key: Key(key),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                debugPrint(
                    'Widget ${visibilityInfo.key} is ${visiblePercentage.toInt()}% visible');
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(key,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.red)),
              ),
            ),
          );
        });
  }
}
