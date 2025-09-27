import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:http_proxy/http_proxy.dart';

class DioProxy {
  // 创建http
  static HttpProxy? proxy;
  // 是否启用代理
  static bool isProxy = false;

  // 初始化
  static initHttp() async {
    var httpProxy = await HttpProxy.createHttpProxy();
    HttpOverrides.global = httpProxy;
  }

  /// 设置抓包
  static Future setProxy(Dio? dio) async {
    if (dio == null || kReleaseMode) {
      return;
    }
    proxy ??= await HttpProxy.createHttpProxy();
    if (proxy?.host != null) {
      isProxy = true;
    }
    // ignore: deprecated_member_use
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.idleTimeout = const Duration(seconds: 5);
      if (isProxy) {
        client.findProxy = (uri) {
          return "PROXY ${proxy!.host}:${proxy!.port}";
        };
        // 代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }
      return null;
    };
  }
}
