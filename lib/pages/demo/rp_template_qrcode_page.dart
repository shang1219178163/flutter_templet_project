

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_four_corner.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_ticket_divder.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

import 'package:flutter_templet_project/util/R.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';



/// 处方模板二维码
class QrcodePage extends StatefulWidget {

  QrcodePage({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _QrcodePageState createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {

  /// 标题
  late final name = "标题";
  /// 二维码链接
  late final qrUrl = R.image.urls[1];

  /// 分享 shareItems
  List<Tuple3<String, String, VoidCallback>> get shareItems {
    return [
      Tuple3("分享给好友", "icon_wechat.png".toPath(), onShareWechat),
      Tuple3("发送给患者", "icon_wechat.png".toPath(), onSharePatient),
    ];
  }

  final _shareKey = GlobalKey(debugLabel: 'QRCode');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: Text('二维码'),),
      body: buildBody(),
    );
  }

  buildBody() {
    final radius = Radius.circular(16.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: 58.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          // padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 36.h),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.red),//勿删
            borderRadius: BorderRadius.all(radius),
          ),
          child: Column(
            children: [
              buildShareWidget(
                key: _shareKey,
                radius: radius,
              ),
              const NTicketDivder(),
              buildShareBar(),
            ],
          ),
        ),
      ],
    );
  }

  /// 要分享的图片部分
  Widget buildShareWidget({
    Key? key,
    required Radius radius,
    bool hideQrcodeTips = false,
  }) {
    return RepaintBoundary(
      key: key,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(color: Colors.red),//勿删
          borderRadius: BorderRadius.all(radius),
        ),
        child: Column(
          children: [
            Container(
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xff5690F4),
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.only(
                  topLeft: radius,
                  topRight: radius,
                ),
              ),
              child: NText(name ?? "-",
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            /// 二维码
            Container(
              padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 36.h),
              decoration: BoxDecoration(
                // color: Color(0xff5690F4),
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.only(
                  bottomLeft: radius,
                  bottomRight: radius,
                ),
              ),
              child: Column(
                children: [
                  NFourCorner(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: NNetworkImage(
                        url: qrUrl,
                        height: 300,
                      ),
                    ),
                  ),
                  if(!hideQrcodeTips)Padding(
                    padding: EdgeInsets.only(top: 36.h),
                    child: NText("微信扫一扫或长按识别",
                      fontSize: 18.sp,
                      color: Color(0xff5B626B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 分享菜单
  Widget buildShareBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: shareItems.map((e){

          return InkWell(
            onTap: e.item3,
            child: NPair(
              direction: Axis.vertical,
              icon: Image(
                image: AssetImage(e.item2),
                width: 56.w,
                height: 56.h,
              ),
              child: NText(e.item1,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: fontColor[20],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 分享到微信
  onShareWechat() async {
    debugPrint("onShareWechat");
    final image = await _shareKey.currentContext?.toImage(pixelRatio: 2);
    final imageWidget = await _shareKey.currentContext?.toImageWidget(pixelRatio: 2);

    debugPrint("image: $image");
    if (image == null) {
      EasyToast.showToast("生成图片失败,请稍后重试");
     return;
    }
    if (imageWidget == null) {
      EasyToast.showToast("生成图片失败,请稍后重试");
      return;
    }
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(30),
        child: imageWidget,
      ),
    );
  }
  
  /// 分享到给患者
  onSharePatient(){
    debugPrint("onSharePatient");
  }


}