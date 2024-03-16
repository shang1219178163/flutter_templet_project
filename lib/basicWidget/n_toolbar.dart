//
//  NToolbar.dart
//  yl_health_app
//
//  Created by shang on 2024/3/15 16:10.
//  Copyright © 2024/3/15 shang. All rights reserved.
//


import 'package:flutter/material.dart';


/// picker 顶部
class NToolbar extends StatelessWidget {

  const NToolbar({
  	super.key,
  	required this.title,
    this.onCancel,
    this.trailing,
  });

  final String title;
  final VoidCallback? onCancel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: NavigationToolbar(
        leading: InkWell(
          onTap: onCancel ?? (){
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: const Text("取消",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Color(0xff737373),
              ),
            ),
          ),
        ),
        middle: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0
          ),
          textAlign: TextAlign.center,
        ),
        trailing: trailing,
      ),
    );
  }
}