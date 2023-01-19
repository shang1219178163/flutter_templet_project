//
//  PreferredSizeSegmentedControl.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 10:04 AM.
//  Copyright © 12/15/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreferredSizeSegmentedControl extends StatelessWidget implements PreferredSizeWidget {

  PreferredSizeSegmentedControl({
  	Key? key,
    this.preferredSize = const Size(double.infinity, 48),
    required this.titles,
    required this.groupValue,
    required this.onValueChanged,
  }) : super(key: key);

  List<String> titles;

  int groupValue;

  ValueChanged<int> onValueChanged;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {

    final map = <int, Widget>{};
    for (int i = 0; i < titles.length; i++) {
      map[i] = Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('${titles[i]}', style: TextStyle(fontSize: 15))
      );
    }

    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(width: 24),
            Expanded(
              child: CupertinoSegmentedControl(
                children: map,
                groupValue: groupValue,
                onValueChanged: onValueChanged,
                borderColor: Colors.white,
                unselectedColor: Theme.of(context).primaryColor,
                selectedColor: Colors.white,
              ),
            ),
            // SizedBox(width: 24)
          ],
        ),
      ),
    );;
  }
}





