import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

class AppLaunchPage extends StatefulWidget {
  AppLaunchPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppLaunchPageState createState() => _AppLaunchPageState();
}

class _AppLaunchPageState extends State<AppLaunchPage> {
  Timer? timer;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {


    timer?.cancel();
    timer ??= Timer(const Duration(milliseconds: 300), () {
      Get.offAndToNamed(AppRouter.appTabPage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: "bg_mountain.png".toAssetImage(),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
