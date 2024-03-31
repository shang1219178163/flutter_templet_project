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


class FilterDemoOne extends StatefulWidget {

  const FilterDemoOne({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _FilterDemoOneState createState() => _FilterDemoOneState();
}

class _FilterDemoOneState extends State<FilterDemoOne> {

  var imageFilteredVN = ValueNotifier(0.0);
  var backdropFilterVN = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                debugPrint("ElevatedButton");
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text("前景模糊 ImageFilter 显示在组件上边, \n背景模糊 BackdropFilter 显示在组件下边"),
              ),
            ),
            _buildNNSlider(
              max: 20,
              leading: Text("前景模糊"),
              onChanged: (val) {
                imageFilteredVN.value = val;
              }
            ),
            _buildNNSlider(
              max: 20,
              leading: Text("背景模糊"),
              onChanged: (val) {
                backdropFilterVN.value = val;
              }
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                imageFilteredVN,
                backdropFilterVN
              ]),
              builder: ( context, child) {

                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text("01" * 399),
                    NFilter(
                      foregroundFilter: ui.ImageFilter.blur(
                        sigmaX: imageFilteredVN.value,
                        sigmaY: imageFilteredVN.value,
                      ),
                      filter: ui.ImageFilter.blur(
                        sigmaX: backdropFilterVN.value,
                        sigmaY: backdropFilterVN.value,
                      ),
                      child: Image(
                        image: '404.png'.toAssetImage(),
                        fit: BoxFit.cover,
                        width: 200.0,
                        height: 120.0,
                      ),
                    ),
                  ],
                );
              }
            )
          ],
        ),
      ),
    );
  }

  _buildNNSlider({
    double max = 100,
    Widget? leading,
    ValueChanged<double>? onChanged
  }) {
    return NSlider(
      leading: leading,
      max: max,
      onChanged: onChanged,
      trailingBuilder: (context, value) {
        // final result = (value/100).toStringAsFixed(2);
        final result = value.toStringAsFixed(0);

        return TextButton(
          onPressed: () {
            debugPrint(result);
          },
          child: Text(result),
        );
      },
    );
  }
}


