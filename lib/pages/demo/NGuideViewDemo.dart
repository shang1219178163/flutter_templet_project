import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_guide_view.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

class NGuideViewDemo extends StatefulWidget {
  const NGuideViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NGuideViewDemo> createState() => _NGuideViewDemoState();
}

class _NGuideViewDemoState extends State<NGuideViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final guideItems = [
    Assets.guidePoster1,
    Assets.guidePoster2,
    Assets.guidePoster3,
    Assets.guidePoster4,
    Assets.guidePoster5,
  ];

  @override
  void didUpdateWidget(covariant NGuideViewDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NGuideView(
      length: guideItems.length,
      itemBuilder: (context, index) {
        final e = guideItems[index];
        final isLast = index == guideItems.length - 1;
        return GestureDetector(
          onTap: isLast ? guideHome : null,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(e),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }

  void guideHome() {
    DLog.d("进入主页");
    SnackUtil.show("进入主页");
  }
}
