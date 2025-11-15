import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ColorFilterDemo extends StatefulWidget {
  const ColorFilterDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ColorFilterDemo> createState() => _ColorFilterDemoState();
}

class _ColorFilterDemoState extends State<ColorFilterDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final predictionLevels = List.generate(11, (i) => i);
  final predictionLevelMap = {
    1: Color(0xFF707796).withOpacity(0.3),
    2: Color(0xFF90643E).withOpacity(0.3),
    3: Color(0xFF5D6DB6).withOpacity(0.3),
    4: Color(0xFFF2A236).withOpacity(0.3),
    5: Color(0xFF6C96E7).withOpacity(0.3),
    6: Color(0xFF49CFB7).withOpacity(0.3),
    7: Color(0xFF6C71E7).withOpacity(0.3),
    8: Color(0xFF9747FF).withOpacity(0.3),
    9: Color(0xFFF56C6C).withOpacity(0.3),
    10: Color(0xFFD28E5D).withOpacity(0.3),
  };

  @override
  void didUpdateWidget(covariant ColorFilterDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            // ...predictionLevels.map((i) {
            //   final predictionLevel = predictionLevels[i];
            //   final predictionLevelBgColor = predictionLevelMap[predictionLevel] ?? Color(0xFF707796).withOpacity(0.3);
            //
            //   return Container(
            //     height: 80,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(8),
            //       image: DecorationImage(
            //         image: AssetImage("assets/images/predict_lv_bg.pngg"),
            //         colorFilter: ColorFilter.mode(
            //           predictionLevelBgColor,
            //           BlendMode.darken,
            //         ),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //   );
            // }),
            ...BlendMode.values.map((e) {
              // final predictionLevel = predictionLevels[e];
              // final predictionLevelBgColor = predictionLevelMap[predictionLevel] ?? Color(0xFF707796).withOpacity(0.3);

              return Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_predict.png"),
                    colorFilter: ColorFilter.mode(
                      Color(0xFF49CFB7),
                      e,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Text("$e"),
              );
            }),

            buildColorOpacity(),
          ],
        ),
      ),
    );
  }

  Widget buildColorOpacity() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final numPerRow = 3;
        final itemWidth = ((constraints.maxWidth - (numPerRow - 1) * 8) / numPerRow).truncateToDouble();

        final list = List.generate(20, (i) => i * 5).map((e) {
          var v = e / 100.0;
          final color = Colors.white.withOpacity(v);
          return "${color.toHex()}, $v";
        }).toList();
        return Wrap(
          // alignment: WrapAlignment.start,
          // crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          children: list.map(
            (e) {
              final i = list.indexOf(e);

              // final isSelected = i == index;
              // final color = isSelected ? Colors.red : Colors.black;
              return GestureDetector(
                onTap: () {
                  // index = i;
                  setState(() {});
                },
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(e),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
