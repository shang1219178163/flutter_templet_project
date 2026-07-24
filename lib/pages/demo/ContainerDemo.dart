import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_decoration/en_decoration_image.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/shadow/n_inner_shadow.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class ContainerDemo extends StatefulWidget {
  final String? title;

  const ContainerDemo({Key? key, this.title}) : super(key: key);

  @override
  _ContainerDemoState createState() => _ContainerDemoState();
}

class _ContainerDemoState extends State<ContainerDemo> {
  bool isSliver = true;

  late final themeData = Theme.of(context);
  late final primary = themeData.colorScheme.primary;
  late final isDark = themeData.brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeData.scaffoldBackgroundColor,
        image: DecorationImage(
          image: AssetImage(Assets.imagesBgLoginTopLight),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('TextButton');
                isSliver = !isSliver;
                setState(() {});
              },
              child: Text(
                'done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        // body: isSliver ? buildBodyCustom() : buildBodyColumn(),
        body: CustomScrollView(
          slivers: [
            NSectionBox(
              title: "EnDecorationImage - placeholder",
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  image: EnDecorationImage(
                    image: CachedNetworkImageProvider(
                      AppRes.image.urls[6],
                      cacheKey: "${DateTime.now()}",
                    ),
                    placeholder: AssetImage(Assets.assetsImagesFlutter),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            buildSection(),
            buildSection1(),
            buildGradientBorder(),
            buildSectionDecorationImage(),
            buildSectionEnDecorationImage(),
            NSectionBox(
              title: "NInnerShadow",
              child: buildInnerShadow(),
            ),
          ]
              .map((e) => SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                          ),
                          child: e,
                        ),
                        Divider(height: 16),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildSection() {
    var bgBlur = 10.0;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Opacity(
        opacity: 1,
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.blue),
            gradient: LinearGradient(
              colors: [Colors.green, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(AppRes.image.urls[0]),
              fit: BoxFit.cover,
            ),
          ),
          // foregroundDecoration: BoxDecoration(
          //   color: Colors.yellow,
          //   border: Border.all(color: Colors.green, width: 5),
          //   borderRadius: BorderRadius.all(Radius.circular(400)),
          //   image: DecorationImage(
          //     image: NetworkImage('https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: bgBlur, sigmaY: bgBlur),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.red,
              ),
              child: Text('VCG21409037867'),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection1() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: "img_update.png".toAssetImage(),
        repeat: ImageRepeat.repeat,
        alignment: Alignment.topLeft,
      )),
      transform: Matrix4.rotationZ(.2),
      alignment: Alignment.centerRight, //卡片内文字居中
      child: Text(
        //卡片文字
        "5.20", style: TextStyle(color: Colors.red, fontSize: 40.0),
      ),
    );
  }

  Widget buildSectionDecorationImage() {
    const msg = "静夜思 * 李白 • 床前明月光, 疑是地上霜, 举头望明月, 低头思故乡.";

    return NSectionBox(
      title: "DecorationImage - Alignment(0.9, -3)",
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          image: DecorationImage(
            image: AssetImage(Assets.assetsIconGoldMedal),
            alignment: Alignment(0.9, -3),
            colorFilter: ColorFilter.mode(Colors.green, BlendMode.dstATop),
          ),
        ),
        // transform: Matrix4.rotationZ(.2),
        alignment: Alignment.centerRight, //卡片内文字居中
        child: Text(
          msg,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildSectionEnDecorationImage() {
    const msg = "静夜思 * 李白 • 床前明月光, 疑是地上霜, 举头望明月, 低头思故乡.";

    return NSectionBox(
      title: "EnDecorationImage \nAlignment.topRight + Offset(-12, -12)",
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          image: EnDecorationImage(
            image: AssetImage(Assets.assetsIconGoldMedal),
            alignment: Alignment.topRight,
            colorFilter: ColorFilter.mode(Colors.green, BlendMode.dstATop),
            destinationOffset: Offset(-12, -12),
          ),
        ),
        // transform: Matrix4.rotationZ(.2),
        alignment: Alignment.centerRight, //卡片内文字居中
        child: Text(
          msg,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildGradientBorder() {
    var borderRadius = BorderRadius.circular(15);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.green,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white,
          ),
          child: Center(
            child: Text('Enter further widgets here'),
          ),
        ),
      ),
    );
  }

  Widget buildInnerShadow() {
    return NInnerShadow(
      blur: 16,
      blurExtent: 4,
      offset: Offset(0, 0),
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100.0,
        // decoration: BoxDecoration(
        //   // color: Colors.white,
        //   borderRadius: BorderRadius.circular(20),
        // ),
        alignment: Alignment.center,
        child: Text("NInnerShadowBox"),
      ),
    );
  }
}
