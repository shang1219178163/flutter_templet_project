//
//  FilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 9:33 AM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_filter.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class FilterDemo extends StatefulWidget {
  const FilterDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FilterDemoState createState() => _FilterDemoState();
}

class _FilterDemoState extends State<FilterDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: () => debugPrint(e),
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
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
                    onPressed: () {
                      debugPrint("ElevatedButton");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child:
                          Text("ImageFilter 显示在组件上边, \nBackdropFilter 显示在组件下边"),
                    ),
                  ),
                  // buildImageFilter(),
                  // buildBackdropFilter(),
                  // buildCombin(),
                  NFilter(
                    foregroundFilter: ui.ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    filter: ui.ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    child: Image(
                      image: '404.png'.toAssetImage(),
                      fit: BoxFit.cover,
                      width: 200.0,
                      height: 120.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget buildImageFilter() {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: 2,
        sigmaY: 2,
      ),
      child: Image(
        image: '404.png'.toAssetImage(),
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
        filter: filter ??
            ui.ImageFilter.blur(
              sigmaX: 0,
              sigmaY: 0,
            ),
        child: ImageFiltered(
          imageFilter: foregroundFilter ??
              ui.ImageFilter.blur(
                sigmaX: 0,
                sigmaY: 0,
              ),
          child: child,
        ),
      ),
    );
  }

  _buildNNSlider() {
    return NSlider(
      max: 100,
      leading: IconButton(
        icon: Icon(Icons.download),
        onPressed: () {
          debugPrint("Downloading");
        },
      ),
      onChangeEnd: (double value) {
        debugPrint('NNSlider onChangeEnd: $value');
      },
      trailingBuilder: (context, value) {
        // final result = (value/100).toStringAsFixed(2);
        final result = "${value.toStringAsFixed(0)}%";

        return TextButton(
          onPressed: () {
            debugPrint("Downloading");
          },
          child: Text(result),
        );
      },
    );
  }
}
