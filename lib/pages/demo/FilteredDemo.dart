//
//  FilteredDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 9:33 AM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/FilterWidget.dart';


class FilteredDemo extends StatefulWidget {

  FilteredDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _FilteredDemoState createState() => _FilteredDemoState();
}

class _FilteredDemoState extends State<FilteredDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text("01" * 1299),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    print("ElevatedButton");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text("ImageFilter 显示在组件上边, \nBackdropFilter 显示在组件下边"),
                  ),
                ),
                buildImageFilter(),
                buildBackdropFilter(),
                buildCombin(),
                FilterWidget(
                  foregroundFilter: ui.ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  filter: ui.ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  child: Image.asset(
                    'images/404.png',
                    fit: BoxFit.cover,
                    width: 200.0,
                    height: 120.0,
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget buildImageFilter() {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: 2,
        sigmaY: 2,
      ),
      child: Image.asset(
        'images/404.png',
        fit: BoxFit.cover,
        width: 200.0,
        height: 120.0,
      ),
    );
  }

  Widget buildBackdropFilter() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          alignment: Alignment.center,
          width: 200.0,
          height: 120.0,
          color: Colors.lightBlue.withOpacity(0.3),
          child: const Text(
            'BackdropFilter',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget buildCombin({
    BorderRadius borderRadius = BorderRadius.zero,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    ui.ImageFilter? foregroundFilter,
    ui.ImageFilter? filter,
    Widget? child,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: filter ?? ui.ImageFilter.blur(
          sigmaX: 0,
          sigmaY: 0,
        ),
        child: ImageFiltered(
          imageFilter: foregroundFilter ?? ui.ImageFilter.blur(
            sigmaX: 0,
            sigmaY: 0,
          ),
          child: child,
        ),
      ),
    );
  }

}


