import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/Debounce.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';


// https://pub-web.flutter-io.cn/packages/fluwx

// 防抖
final _debounce = Debounce();

/// fluwx 功能封装类
class FluwxUtil {

  static const weChatAppKey = 'wxdf948255a98cb714';
  // static const weChatAppSecret = '6fab866e9f5306ebb13ad257182cd549';

  /// 未安装微信提示语
  static String notWechat = '没有安装微信，请安装后使用该功能';

  static const universalLink ='https://h.yljk.cn/';

  static Future init() async {
    final isSuccess = await fluwx.registerWxApi(
      appId: weChatAppKey, //查看微信开放平台
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: universalLink, //查看微信开放平台
    );
    debugPrint(isSuccess ? "fluwx 微信注册成功" : "fluwx 微信注册失败");
  }

  static Future<bool> isWeChatInstalled() async {
    return await fluwx.isWeChatInstalled;
  }

  /// 创建授权及支付状态监听
  static void addListen({
    String? type,
    required Function(BaseWeChatResponse res) callback,
  }) {
    fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) {
      if (res is fluwx.WeChatAuthResponse) {
        int? errCode = res.errCode;
        if (errCode == 0) {
          _debounce(() {
            callback(res);
          });
        } else if (errCode == -4) {
          EasyToast.showToast("用户拒绝授权");
        } else if (errCode == -2) {
          EasyToast.showToast("用户取消$type");
        } else {
          EasyToast.showToast('失败原因：${res.errStr}');
        }
      }
    });
  }

  /// 微信授权登录
  static void authLogin() {
    fluwx.sendWeChatAuth(
      scope: "snsapi_userinfo",
      state: "wechat_sdk_demo_test",
    ).then((data) {
      if (!data) {
        EasyToast.showToast('没有安装微信，请安装微信后使用该功能');
      }
    });
  }

  /// 调用微信支付
  static void authPay(params) {
    fluwx.payWithWeChat(
      appId: params['appId'],
      partnerId: params['partnerId'],
      prepayId: params['prepayId'],
      packageValue: params['packageValue'],
      nonceStr: params['nonceStr'],
      timeStamp: params['timeStamp'],
      sign: params['sign'],
    )
        .then((data) {
      debugPrint('微信支付返回值：$data');
    }).catchError((e) {
      debugPrint('微信支付异常：$e');
    });
  }

  /// 分享图片到微信，
  /// file=本地路径
  /// url=网络地址
  /// asset=内置在app的资源图片
  /// thumbBytes=Uint8List类型图片
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  static Future<bool> shareImage({
    String? title,
    String? decs,
    String? filePath,
    String? url,
    String? asset,
    Uint8List? binary,
    WeChatScene scene = WeChatScene.SESSION,
  }) async {
    WeChatImage? image;
    if (filePath != null) {
      image = WeChatImage.file(File(filePath));
    } else if (binary != null) {
      image = WeChatImage.binary(binary);
    } else if (url != null) {
      image = WeChatImage.network(url);
    } else if (asset != null) {
      image = WeChatImage.asset(asset);
    } else {
      throw Exception("缺少图片资源信息");
    }

    final shareImageModel = WeChatShareImageModel(
      image,
      title: title,
      description: decs,
      scene: scene,
    );
    return shareToWeChat(shareImageModel);
  }

  /// 分享文本
  /// content=分享内容
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  static Future<bool> shareText({
    required String title,
    required String content,
    WeChatScene scene = WeChatScene.SESSION,
  }) {
    final model = WeChatShareTextModel(content,
      title: title,
      scene: scene,
    );
    return shareToWeChat(model);
  }

  /// 分享视频
  /// videoUrl=视频网上地址
  /// thumbFile=缩略图本地路径
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  static Future<bool> shareVideo({
    required String videoUrl,
    required String thumbFile,
    required String title,
    required String desc,
    WeChatScene scene = WeChatScene.SESSION,
  }) {
    final image = WeChatImage.file(File(thumbFile));
    final model = WeChatShareVideoModel(
      videoUrl: videoUrl,
      thumbnail: image,
      title: title,
      description: desc,
      scene: scene,
    );
    return shareToWeChat(model);
  }

  /// 分享链接
  /// url=链接
  /// thumbFile=缩略图本地路径
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  static Future<bool> shareUrl({
    required String url,
    String? thumbFile,
    Uint8List? thumbBytes,
    String? title = "",
    String? desc = "",
    String? networkThumb,
    String? assetThumb,
    WeChatScene scene = WeChatScene.SESSION,
  }) {
    desc = desc ?? "";
    title = title ?? "";
    if (desc.length > 54) {
      desc = "${desc.substring(0, 54)}...";
    }
    if (title.length > 20) {
      title = "${title.substring(0, 20)}...";
    }

    WeChatImage? image;
    if (thumbFile != null) {
      image = WeChatImage.file(File(thumbFile));
    } else if (thumbBytes != null) {
      image = WeChatImage.binary(thumbBytes);
    } else if (StringExt.isNotEmpty(networkThumb)) {
      image = WeChatImage.network(Uri.encodeFull(networkThumb!));
    } else if (StringExt.isNotEmpty(assetThumb)) {
      image = WeChatImage.asset(assetThumb!, suffix: ".png");
    }
    var model = WeChatShareWebPageModel(
      url,
      thumbnail: image,
      title: title,
      description: desc,
      scene: scene,
    );
    return shareToWeChat(model);
  }
}
