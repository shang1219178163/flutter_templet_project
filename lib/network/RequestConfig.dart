
/// app 接口环境
enum APPEnvironment { dev, beta, test, pre, prod }

///request config
class RequestConfig {
  static APPEnvironment current = APPEnvironment.dev;

  /// 环境集合
  static Map<APPEnvironment, String> originMap = {
    APPEnvironment.dev: 'https://*.cn',
    APPEnvironment.beta: 'https://*.cn',
    APPEnvironment.test: 'https://*.cn',
    APPEnvironment.pre: 'https://*.cn',
    APPEnvironment.prod: 'https://*.cn',
  };

  static String get baseUrl {
    final result = originMap[current] ?? originMap[APPEnvironment.dev]!;
    return result;
  }

  static String get protocolUrl {
    switch (current) {
      case APPEnvironment.prod:
        return 'https://yljk.cn';
      default:
        return 'https://yljk.cn';
    }
  }

  static String apiTitle = '/api/crm';
  static String ossImageUrl = 'https://yl-oss.yljt.cn';
  static const connectTimeout = 15000;

}

class RequestMsg {
  static String networkSucessMsg = "操作成功";
  static String networkErrorMsg = "网络连接失败,请稍后重试";
  static String networkErrorSeverMsg = '服务器响应超时，请稍后再试！';

  static Map<String, String> statusCodeMap = <String, String>{
    '401': '验票失败!',
    '403': '无权限访问!',
    '404': '404未找到!',
    '500': '服务器内部错误!',
    '502': '服务器内部错误!',
  };

}



