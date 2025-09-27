
import 'package:flutter_templet_project/network/base_request_api.dart';

// https://doc.yljt.cn/docs/platform//5245

/// 【通用】获取患者标签
class TokenRefreshApi extends BaseRequestAPI {
  TokenRefreshApi({
    this.accessToken,
    this.refreshToken,
  });

  String? accessToken;

  String? refreshToken;

  @override
  String get requestURI {
    const url = '';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.GET;

  @override
  Map<String, dynamic> get requestParams {
    final map = <String, dynamic>{};
    if (accessToken != null) {
      map["accessToken"] = accessToken;
    }
    if (refreshToken != null) {
      map["refreshToken"] = refreshToken;
    }
    return map;
  }
}
