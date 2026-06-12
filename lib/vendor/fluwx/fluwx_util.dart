import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
    final image = await _buildImageToShare(
      filePath: filePath,
      url: url,
      asset: asset,
      binary: binary,
    );
    final shareImageModel = WeChatShareImageModel(
      image,
      title: title,
      description: decs,
      scene: scene,
    );
    return fluwx.share(shareImageModel);
  }

  Future<WeChatImageToShare> _buildImageToShare({
    String? filePath,
    String? url,
    String? asset,
    Uint8List? binary,
  }) async {
    if (binary != null) {
      return WeChatImageToShare(uint8List: binary);
    }
    if (asset != null) {
      final data = await rootBundle.load(asset);
      return WeChatImageToShare(uint8List: data.buffer.asUint8List());
    }
    if (filePath != null) {
      if (Platform.isAndroid) {
        return WeChatImageToShare(localImagePath: filePath);
      }
      final bytes = await File(filePath).readAsBytes();
      return WeChatImageToShare(uint8List: bytes);
    }
    if (url != null) {
      final bytes = await _fetchImageBytes(url);
      if (bytes == null) {
        throw Exception('网络图片加载失败: $url');
      }
      return WeChatImageToShare(uint8List: bytes);
    }
    throw Exception('缺少图片资源信息');
  }

  Future<Uint8List?> _fetchImageBytes(String imageUrl) async {
    try {
      final Response<List<int>> response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }
      debugPrint('图片加载失败: ${response.statusCode}');
      return null;
    } catch (err) {
      debugPrint('图片加载异常: $err');
      return null;
    }
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
  }) async {
    final thumbBytes = await File(thumbFile).readAsBytes();
    final model = WeChatShareVideoModel(
      videoUrl: videoUrl,
      thumbData: thumbBytes,
      title: title,
      description: desc,
      scene: scene,
    );
    return fluwx.share(model);
  }

  /// 分享链接
  /// url=链接
  /// thumbFile=缩略图本地路径
  /// networkThumb=缩略图网络地址
  /// assetThumb=缩略图资源路径
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
  }) async {
    desc = desc ?? "";
    title = title ?? "";
    if (desc.length > 54) {
      desc = "${desc.substring(0, 54)}...";
    }
    if (title.length > 20) {
      title = "${title.substring(0, 20)}...";
    }
    var resolvedThumbBytes = thumbBytes;
    resolvedThumbBytes ??= await _buildThumbBytes(
      thumbFile: thumbFile,
      networkThumb: networkThumb,
      assetThumb: assetThumb,
    );
    final model = WeChatShareWebPageModel(
      url,
      thumbData: resolvedThumbBytes,
      title: title,
      description: desc,
      scene: scene,
    );
    return fluwx.share(model);
  }

  Future<Uint8List?> _buildThumbBytes({
    String? thumbFile,
    String? networkThumb,
    String? assetThumb,
  }) async {
    if (thumbFile != null) {
      return File(thumbFile).readAsBytes();
    }
    if (networkThumb?.isNotEmpty == true) {
      return _fetchImageBytes(networkThumb!);
    }
    if (assetThumb?.isNotEmpty == true) {
      final ByteData data = await rootBundle.load(assetThumb!);
      return data.buffer.asUint8List();
    }
    return null;
  }
}
