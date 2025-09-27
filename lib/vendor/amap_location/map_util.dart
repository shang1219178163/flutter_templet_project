//
//  MapUtil.dart
//  yl_patient_app
//
//  Created by shang on 2023/9/5 11:49.
//  Copyright © 2023/9/5 shang. All rights reserved.
//

import 'dart:io';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

/// 地图关文件
class MapUtil {
  static String iOSKey = "";

  static String androidKey = "";

  /// 高德地图
  static Future<List<({String name, String url})>> jumpMap(
      longitude, latitude) async {
    // 高德地图
    var aMapUrl = '${Platform.isAndroid ? 'android' : 'ios'}'
        'amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2';
    // qq地图
    var qqMapUrl =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    // 百度地图
    var baiDuUrl =
        'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving';

    /// 苹果地图
    var appleUrl = 'http://maps.apple.com/?&daddr=$latitude,$longitude';

    final items = [
      (name: "高德地图", url: aMapUrl),
      (name: "腾讯地图", url: qqMapUrl),
      (name: "百度地图", url: baiDuUrl),
      (name: "苹果地图", url: appleUrl),
    ];

    var list = <({String name, String url})>[];
    for (final e in items) {
      var canLaunchUrl = await canLaunch(e.url);
      if (canLaunchUrl) {
        list.add(e);
      }
    }
    return list;
  }

  /// 高德地图
  static Future<bool> jumpAMap(longitude, latitude) async {
    var url = '${Platform.isAndroid ? 'android' : 'ios'}'
        'amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2';
    var canLaunchUrl = await canLaunch(url);
    if (!canLaunchUrl) {
      ToastUtil.show('未检测到高德地图~');
      return false;
    }
    await launch(url);
    return true;
  }

  /// 腾讯地图
  static Future<bool> jumpTencentMap(longitude, latitude) async {
    var url =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    var canLaunchUrl = await canLaunch(url);
    if (!canLaunchUrl) {
      ToastUtil.show('未检测到腾讯地图~');
      return false;
    }
    await launch(url);
    return canLaunchUrl;
  }

  /// 百度地图
  static Future<bool> jumpBaiduMap(longitude, latitude) async {
    var url =
        'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving';
    var canLaunchUrl = await canLaunch(url);
    if (!canLaunchUrl) {
      ToastUtil.show('未检测到百度地图~');
      return false;
    }
    await launch(url);
    return canLaunchUrl;
  }

  /// 苹果地图
  static Future<bool> jumpAppleMap(longitude, latitude) async {
    var url = 'http://maps.apple.com/?&daddr=$latitude,$longitude';
    var canLaunchUrl = await canLaunch(url);
    if (!canLaunchUrl) {
      ToastUtil.show('打开失败~');
      return false;
    }
    await launch(url);
    return canLaunchUrl;
  }
}

//获取位置
//{locTime: 2023-08-08 15:43:29, province: 陕西省, callbackTime: 2023-08-08 15:43:29, district: 雁塔区, country: 中国, street: 雁南五路, speed: -1.0, latitude: 34.192703, city: 西安市, streetNumber: 1958号, bearing: -1.0, accuracy: 59.8577476420869, adCode: 610113, altitude: 438.624755859375, locationType: 1, longitude: 108.953632, cityCode: 029, address: 陕西省西安市雁塔区雁南五路靠近华美达广场酒店, description: 陕西省西安市雁塔区雁南五路靠近华美达广场酒店}
