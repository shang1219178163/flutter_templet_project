

enum APPChannel { dev, beta, test, pre, prod }

///request config
class RequestConfig {
  static APPChannel current = APPChannel.dev;

  static String get baseUrl {
    switch (current) {
      case APPChannel.beta:
        return 'https://*.cn';
      case APPChannel.test:
        return 'https://*.cn';
      case APPChannel.pre:
        return 'https://*.cn';
      case APPChannel.prod:
        return 'https://*.cn';
      default:
        return 'https://*.cn';
    }
  }

  static String get protocolUrl {
    switch (current) {
      case APPChannel.prod:
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



