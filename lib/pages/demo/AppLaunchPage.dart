import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

class AppLaunchPage extends StatefulWidget {
  AppLaunchPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppLaunchPageState createState() => _AppLaunchPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
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
          image: AssetImage(Assets.imagesBgMountain),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Timer?>('timer', timer));
  }
}
