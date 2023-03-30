//
//  FSkeleton.dart
//  flutter_templet_project
//
//  Created by shang on 3/30/23 8:06 AM.
//  Copyright © 3/30/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NSkeleton extends StatelessWidget {

  const NSkeleton({
  	Key? key,
  	this.title,
    this.child,

  }) : super(key: key);

  final String? title;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _buildSkeleton(child ?? _buildList());
  }

  _buildSkeleton(Widget? child) {
    return Shimmer(
      // This is the default value
      duration: Duration(seconds: 1),
      // This is NOT the default value. Default value: Duration(seconds: 0)
      interval: Duration(seconds: 0),
      // This is the default value
      color: Colors.white,
      // This is the default value
      colorOpacity: 0.3,
      // This is the default value
      enabled: true,
      // This is the default value
      direction: ShimmerDirection.fromLTRB(),
      // This is the ONLY required parameter
      child: child ?? Container(
        color: Colors.lightBlue,
        // marigin: EdgeInsets.only(top: 8),
      ),
    );
  }

  _buildList() {
    final List<String> _items = <String>[
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    ];

    const bgColor = Color(0xFFf3f3f3);

    return Scrollbar(
      child: ListView.builder(
        // padding: kMaterialListPadding,
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          final String item = _items[index];

          final screenSize = MediaQuery.of(context).size;
          // print('screenSize:${screenSize}');
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      // child: Text(item),
                      backgroundColor: bgColor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: bgColor,
                        height: 20,
                        width: screenSize.width * 0.5,
                      ),
                      SizedBox(height: 4),
                      Container(
                        color: bgColor,
                        height: 40,
                        width: screenSize.width - 100,
                      ),
                    ],
                  )
                ],
              ),
              Divider(indent: 18),
            ],
          );
        },
      ),
    );
  }

}
