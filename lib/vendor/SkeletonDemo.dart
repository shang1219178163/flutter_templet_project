import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SkeletonDemo extends StatefulWidget {

  final String? title;

  const SkeletonDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _SkeletonDemoState createState() => _SkeletonDemoState();
}

class _SkeletonDemoState extends State<SkeletonDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildSkeleton(_buildSkeletonList()),
    );
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

  _buildSkeletonList() {
    final _items = <String>[
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    ];

    const bgColor = Color(0xFFf3f3f3);

    return Scrollbar(
      child: ListView.builder(
        // padding: kMaterialListPadding,
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _items[index];

          final screenSize = MediaQuery.of(context).size;
          // print('screenSize:${screenSize}');
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
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

  _buildSkeletonListOne() {
    final _items = <String>[
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
    ];
    return Scrollbar(
      child: ListView.builder(
        padding: kMaterialListPadding,
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _items[index];
          return ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: Color(0xFFf3f3f3),
              child: Text(item),
            ),
            title: Text('This item represents $item.'),
            subtitle: const Text('Even more additional list item information appears on line three.'),
          );
        },
      ),
    );
  }

  // _buildGrayContainer() {
  //   return Container(
  //     backgroundColor: Colors.grey,
  //   );
  // }

}