//
//  ColorSchemeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/7/15 15:49.
//  Copyright © 2025/7/15 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 从图片获取主色调
class ColorSchemeDemo extends StatefulWidget {
  const ColorSchemeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ColorSchemeDemo> createState() => _ColorSchemeDemoState();
}

class _ColorSchemeDemoState extends State<ColorSchemeDemo> {
  final scrollController = ScrollController();

  List<ImageProvider> get assetsImage => [
        'assets/images/background_ocean.png',
        'assets/images/bg_jiguang.png',
        'assets/images/bg_mk11.jpg',
        'assets/images/bg_mountain.png',
        'assets/images/bg_nfs.jpg',
        'assets/images/bg_ocean.jpg',
      ].map((e) => AssetImage(e)).toList();

  int activeIndex = 0;
  Color activeColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: assetsImage.length,
      itemBuilder: (_, i) {
        final imageProvider = assetsImage[i];
        final isSelected = i == activeIndex;
        final radius = BorderRadius.circular(6);
        final border = Border.all(color: !isSelected ? Colors.transparent : activeColor, width: 2);

        return GestureDetector(
          onTap: () async {
            var scheme = await ColorScheme.fromImageProvider(provider: imageProvider);
            activeColor = scheme.primary;
            activeIndex = i;
            setState(() {});
          },
          child: Row(
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(borderRadius: radius, border: border),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Image(
                    image: imageProvider,
                    height: 80,
                    width: 120,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 80,
                  color: activeColor,
                ),
              ),
            ],
          ),
        );
      },
    );
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Row(
              children: [
                ListView.builder(
                  itemCount: assetsImage.length,
                  itemBuilder: (_, i) {
                    final imageProvider = assetsImage[i];
                    final isSelected = i == activeIndex;
                    final radius = BorderRadius.circular(6);
                    final border = Border.all(color: activeColor, width: 2);

                    return Row(
                      children: [
                        Container(
                          height: 80,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(borderRadius: radius, border: border),
                          child: ClipRRect(
                            borderRadius: radius,
                            child: Image(
                              image: imageProvider,
                              height: 80,
                              width: 120,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
