import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/vendor/apple_sigin_mixin.dart';
import 'package:flutter_templet_project/vendor/fluwx/fluwx_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:tuple/tuple.dart';

/// 第三方登录类型
enum NLoginType {
  account,
  wechat,
  apple,
}

/// 登录页第三方登录
class NThirdLogin extends StatefulWidget {
  const NThirdLogin({
    Key? key,
    required this.wxIsInstalled,
    required this.onAgreedPrivice,
  }) : super(key: key);

  final bool Function() onAgreedPrivice;
  final bool wxIsInstalled;

  @override
  NThirdLoginState createState() => NThirdLoginState();
}

class NThirdLoginState extends State<NThirdLogin> with AppleSiginMixin, LoginMixin {
  List<Tuple2<String, VoidCallback>> get thirdLoginItems {
    return [
      if (Platform.isIOS) Tuple2("icon_apple_bg_grey.png".toPath(), onLoginApple),
      Tuple2("icon_wechat_bg_green.png".toPath(), onLoginWechat),
    ];
  }

  bool get isCheck => widget.onAgreedPrivice();

  bool get wxIsInstalled => widget.wxIsInstalled;

  static const Color borderColor = Color(0xffe4e4e4);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (thirdLoginItems.isEmpty || !wxIsInstalled) {
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              const Expanded(
                child: Divider(
                  height: 1,
                  color: borderColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: NText('第三方登录', fontSize: 14, color: AppColor.fontColorB3B3B3),
              ),
              const Expanded(
                child: Divider(
                  height: 1,
                  color: borderColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: thirdLoginItems.map((e) {
              return InkWell(
                onTap: e.item2,
                child: Image(image: e.item1.toAssetImage(), width: 40, height: 40),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  initFlux() async {
    // 初始化微信登录
    if (Platform.isAndroid) {
      await FluwxUtil().init();
    }
    // 微信授权监听
    FluwxUtil().addListen(
      type: '授权',
      callback: (res) {
        _authWeChat(res);
      },
    );
  }

  // 微信登录
  _authWeChat(res) async {
    ToastUtil.loading('正在登录...');
    // var api = WechatSignInApi(code: res.code);
    // // 把微信登录返回的code传给后台，剩下的事就交给后台处理
    // var response = await api.startRequest();
    // handleLoginResult(loginType: NThirdLoginType.wechat, response: response);
  }

  onLoginApple() async {
    if (!isCheck) {
      ToastUtil.show('请先阅读并同意协议');
      return;
    }

    final param = await appleSigin();
    debugPrint("param: $param");

    String identityToken = param['identityToken'] ?? "";
    if (identityToken.isEmpty) {
      ToastUtil.show("Apple 账户未登录, 请登录后重试");
      return;
    }

    ToastUtil.loading('正在登录...');

    final map = <String, dynamic>{};
    map["idType"] = "IOS";
    map['userId'] = param["userIdentifier"];
    map['authorizationCode'] = param["authorizationCode"];
    map['identityToken'] = param["identityToken"];

    // final response = await AppleSignInApi(
    //   userIdentifier: map["userId"],
    //   authorizationCode: map["authorizationCode"],
    //   identityToken: map["identityToken"],
    // ).startRequest();
    // // debugPrint("response: $response");
    // handleLoginResult(loginType: NThirdLoginType.apple, response: response);
  }

  onLoginWechat() {
    if (!isCheck) {
      return ToastUtil.show('请先阅读并同意协议');
    }

    initFlux();
    FluwxUtil().authLogin();
  }
}

mixin LoginMixin<T extends StatefulWidget> on State<T> {
  /// LoginMixin 登录结果统一处理
  handleLoginResult({
    required NLoginType loginType,
    Map<String, dynamic>? response,
    Map<String, dynamic>? appleMap,
  }) async {
    // final rootModel = DoctorLoginRootModel.fromJson(response);
    // if (rootModel.code != 'OK') {
    //   EasyToast.hideLoading();
    //   EasyToast.showToast(rootModel.message ?? "请稍后重试");
    //   return;
    // }
    // CacheService().loginRootModel = rootModel;
    //
    // await requestUserInfo(userId: rootModel.result?.userId);
    // EventManager.successLoginInit.fire(true);
    //
    // Timer(const Duration(milliseconds: 0), () {
    //   EasyToast.hideLoading();
    //   NavigatorUtil.goHomePage();
    // });
  }

  /// LoginMixin 更新本地用户信息
  Future<bool> requestUserInfo({required String? userId}) async {
    // var infoApi = DoctorInfoApi(id: userId);
    // final response = await RequestManager().request(infoApi) ?? {};
    // final rootModel = DoctorDetailRootModel.fromJson(response);
    // if (rootModel.code == 'OK') {
    //   if (rootModel.result?.isApproved != true) {
    //     EasyToast.showToast('当前账号审核中，请联系管理员', cb: (){
    //       CacheService().remove('TOKEN');
    //       Get.offNamed(AppRouter.loginPage);
    //     });
    //     return false;
    //   }
    //
    //   if (rootModel.result?.lockStatus == 'Y') {
    //     EasyToast.showToast('当前账号已被禁用，请联系管理员', cb: (){
    //       CacheService().remove('TOKEN');
    //       Get.offNamed(AppRouter.loginPage);
    //     });
    //     return false;
    //   }
    //   // CacheService().detailModel = rootModel.result;
    // } else {
    //   debugPrint("❌infoApi: ${infoApi.requestURI} 请求失败");
    // }
    return true;
  }
}
