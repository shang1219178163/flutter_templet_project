import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:fluwx/fluwx.dart';

// https://pub-web.flutter-io.cn/packages/fluwx

// 防抖
final _debounce = Debounce();

/// fluwx 功能封装类
class FluwxUtil {
  static final FluwxUtil _instance = FluwxUtil._();
  FluwxUtil._();
  factory FluwxUtil() => _instance;
  static FluwxUtil get instance => _instance;

  static const weChatAppKey = 'wxdf948255a98cb714';
  // static const weChatAppSecret = '6fab866e9f5306ebb13ad257182cd549';

  /// 未安装微信提示语
  static String notWechat = '没有安装微信，请安装后使用该功能';

  static const universalLink = 'https://h.yljk.cn/';

  final Fluwx fluwx = Fluwx();

  Future<bool> init() async {
    final isSuccess = await fluwx.registerApi(
      appId: weChatAppKey, //查看微信开放平台
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: universalLink, //查看微信开放平台
    );
    debugPrint(isSuccess ? "fluwx 微信注册成功" : "fluwx 微信注册失败");
    return isSuccess;
  }

  Future<bool> isWeChatInstalled() async {
    return fluwx.isWeChatInstalled;
  }

  /// 创建授权及支付状态监听
  void addListen({
    String? type,
    required Function(WeChatResponse res) callback,
  }) {
    fluwx.addSubscriber((response) {
      if (response is WeChatAuthResponse) {
        var errCode = response.errCode;
        if (errCode == 0) {
          _debounce(() {
            callback(response);
          });
        } else if (errCode == -4) {
          ToastUtil.show("用户拒绝授权");
        } else if (errCode == -2) {
          ToastUtil.show("用户取消$type");
        } else {
          ToastUtil.show('失败原因：${response.errStr}');
        }
      }
    });
  }

  /// 微信授权登录
  void authLogin() {
    fluwx
        .authBy(
      which: NormalAuth(
        scope: "snsapi_userinfo",
        state: "wechat_sdk_demo_test",
      ),
    )
        .then((data) {
      if (!data) {
        ToastUtil.show('没有安装微信，请安装微信后使用该功能');
      }
    });
  }

  /// 调用微信支付
  void authPay(Map<String, dynamic> params) {
    final payment = Payment(
      appId: params['appId'],
      partnerId: params['partnerId'],
      prepayId: params['prepayId'],
      packageValue: params['packageValue'],
      nonceStr: params['nonceStr'],
      timestamp: params['timeStamp'],
      sign: params['sign'],
    );
    fluwx.pay(which: payment).then((data) {
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
  Future<bool> shareImage({
    String? title,
    String? decs,
    String? filePath,
    String? url,
    String? asset,
    Uint8List? binary,
    WeChatScene scene = WeChatScene.session,
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
    return fluwx.share(shareImageModel);
  }

  /// 分享文本
  /// content=分享内容
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  Future<bool> shareText({
    required String title,
    required String content,
    WeChatScene scene = WeChatScene.session,
  }) {
    final model = WeChatShareTextModel(
      content,
      title: title,
      scene: scene,
    );
    return fluwx.share(model);
  }

  /// 分享视频
  /// videoUrl=视频网上地址
  /// thumbFile=缩略图本地路径
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  Future<bool> shareVideo({
    required String videoUrl,
    required String thumbFile,
    required String title,
    required String desc,
    WeChatScene scene = WeChatScene.session,
  }) {
    final image = WeChatImage.file(File(thumbFile));
    final model = WeChatShareVideoModel(
      videoUrl: videoUrl,
      thumbnail: image,
      title: title,
      description: desc,
      scene: scene,
    );
    return fluwx.share(model);
  }

  /// 分享链接
  /// url=链接
  /// thumbFile=缩略图本地路径
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  Future<bool> shareUrl({
    required String url,
    String? thumbFile,
    Uint8List? thumbBytes,
    String? title = "",
    String? desc = "",
    String? networkThumb,
    String? assetThumb,
    WeChatScene scene = WeChatScene.session,
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
    } else if (networkThumb.isNotEmpty) {
      image = WeChatImage.network(Uri.encodeFull(networkThumb!));
    } else if (assetThumb.isNotEmpty) {
      image = WeChatImage.asset(assetThumb!, suffix: ".png");
    }
    var model = WeChatShareWebPageModel(
      url,
      thumbnail: image,
      title: title,
      description: desc,
      scene: scene,
    );
    return fluwx.share(model);
  }
}
