import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/OverlayEntry/n_reuse_toast.dart';
import 'package:get/get.dart';

/// OverlayEntry 弹窗
class OverlayEntryPage extends StatefulWidget {
  const OverlayEntryPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<OverlayEntryPage> createState() => _OverlayEntryPageState();
}

class _OverlayEntryPageState extends State<OverlayEntryPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final countVN = ValueNotifier(0);

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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      countVN.value = 90;
                      NReuseToast.show(
                        context: context,
                        tag: "success",
                        message: "第一次",
                        child: buildGiftCard(count: countVN.value),
                      );
                    },
                    child: Text("第一次 ${countVN.value}"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      countVN.value++;
                      NReuseToast.show(
                        context: context,
                        tag: "success",
                        message: "更新内容 ${countVN.value}",
                        child: buildGiftCard(count: countVN.value),
                      );
                    },
                    child: Text("更新内容"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final num = IntExt.random(max: 200);
                      // 不同类型
                      NReuseToast.show(
                        context: context,
                        tag: "error $num",
                        message: "新的 toast",
                        child: buildGiftCard(count: num),
                      );
                    },
                    child: Text("新的 toast"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGiftCard({int count = 99}) {
    final avatar = "https://p9-passport.byteacctimg.com/img/user-avatar/ad3a331f1d369e7b6b9fb461fb4dcab4~40x40.awebp";
    final name = "小西同学";
    final gift = "大啤酒";
    final giftUrl = "https://p6-passport.byteacctimg.com/img/mosaic-legacy/3795/3033762272~100x100.awebp";
    final num = "×$count";

    var width = 210.0;
    if (count >= 10 && count <= 99) {
      width = 220;
    } else if (count >= 100) {
      width = 240;
    }
    return Container(
      height: 40,
      width: width,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE13508),
            Color(0xFFE13508).withOpacity(0.0),
          ],
        ),
        shape: StadiumBorder(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 4),
          NNetworkImage(
            url: avatar,
            radius: 16,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                gift,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(width: 13),
          NNetworkImage(
            url: giftUrl,
            radius: 16,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 8),
          FittedBox(
            child: Text(
              num,
              style: TextStyle(
                color: Color(0xFFFFD876),
                fontSize: 26,
                fontWeight: FontWeight.w900,
                fontFamily: 'DDINPRO',
              ),
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
