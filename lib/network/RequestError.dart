//
//  RequestError.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/16 16:14.
//  Copyright © 2023/11/16 shang. All rights reserved.
//


/// 网络错误
enum RequestError{
  unknown("未知错误"),
  jsonError("JSON解析错误"),
  paramsError("参数错误"),
  urlError("请求链接异常"),
  timeout("请求超时。"),
  networkError("网络错误，请稍后再试"),
  notNetwork("无法连接到网络"),
  serverError("服务器响应超时，请稍后再试"),
  cancel("取消网络请求");

  const RequestError(this.desc);
  final String desc;
}


enum RequestStatusCode{
  code401("校验失败!"),
  code403("无权限访问!"),
  code404("404未找到!"),
  code500("服务器内部错误!"),
  code502("服务器内部错误!");

  const RequestStatusCode(this.desc);
  final String desc;
}