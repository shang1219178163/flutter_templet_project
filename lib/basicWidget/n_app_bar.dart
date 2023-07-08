

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';

class NAppBar extends StatelessWidget {

  const NAppBar({
  	Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);


  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: fontColor,
          // size: 20,
        ),
        elevation: 0,
        shadowColor: const Color(0xffe4e4e4),
        title: title,
        titleTextStyle: const TextTheme(
          titleMedium: TextStyle(
            // headline6 is used for setting title's theme
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ).titleMedium,
        actions: actions,
    );
  }
}