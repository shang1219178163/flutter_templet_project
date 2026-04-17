import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_decoration/en_decoration_image.dart';
import 'package:flutter_templet_project/basicWidget/n_flex_separated.dart';
import 'package:flutter_templet_project/basicWidget/n_inner_shadow.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
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
            buildSection(),
            buildSection1(),
            buildGradientBorder(),
            buildSectionEnDecorationImage(),
            NSectionBox(
              title: "NInnerShadow",
              child: buildInnerShadow(),
            ),
            NSectionBox(
              title: "聊天气泡",
              child: chatBubble(),
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
                color: Colors.red.withOpacity(0.5),
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

  Widget buildSectionEnDecorationImage() {
    const msg = "静夜思 * 李白 • 床前明月光, 疑是地上霜, 举头望明月, 低头思故乡.";

    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        image: EnDecorationImage(
          image: "img_update.png".toAssetImage(),
          alignment: Alignment.topRight,
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.dstATop),
          // destinationOffset: Offset(-16, -12),
        ),
      ),
      // transform: Matrix4.rotationZ(.2),
      alignment: Alignment.centerRight, //卡片内文字居中
      child: Text(
        msg,
        style: TextStyle(color: Colors.red),
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
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const LinearGradient(
          colors: [Color(0x99F9F9F9), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: const Border(top: BorderSide(color: Colors.white)),
      ),
      child: GestureDetector(
        onTap: () {
          DLog.d("onTap");
        },
        child: NInnerShadow(
          borderRadius: BorderRadius.circular(8),
          shadows: [
            // BoxShadow(
            //   color: Color.fromRGBO(255, 254, 233, 0.50),
            //   offset: Offset(0, 5),
            //   blurRadius: 16,
            // ),
          ],
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFFFED47A), Color(0xFFFCBF67), Color(0xFFF29E4E), Color(0xFFE99676)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: NText('进入诊室', color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget chatBubble() {
    var imageUrl = "https://cdn.kbisai.com/kanbisai/goods/bubble/zu_qiu.png";
    // imageUrl = "https://cdn.kbisai.com/kanbisai/goods/bubble/lan_qiu.png";

    var text = "聊天气泡的“拉伸”本质是背景形状可伸缩（capInsets / 9-slice）+ 内容自适应";
    text += "可以，直接教你一套工程级“反推 centerSlice”方法，等价于 iOS 的 capInsets，而且可以做到一次算准、长期复用。";

    final padding = const EdgeInsets.symmetric(horizontal: 54, vertical: 54);
    return Container(
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          // image: AssetImage(Assets.imagesBgChatBubble),
          image: CachedNetworkImageProvider(imageUrl),
          centerSlice: Rect.fromLTWH(padding.left, padding.top, 1, 1),
          fit: BoxFit.fill,
        ),
      ),
      child: Text(
        text,
        maxLines: 9,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
