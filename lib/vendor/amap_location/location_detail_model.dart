//
//  LocationDetailModel.dart
//  yl_patient_app
//
//  Created by shang on 2023/9/5 11:49.
//  Copyright © 2023/9/5 shang. All rights reserved.
//

//文档 https://pub-web.flutter-io.cn/packages/amap_flutter_location

import 'package:flutter/foundation.dart';

/// 高德地图定位模型(省市区信息 android上只有通过[AMapLocationOption.needAddress]为true时才有可能返回值)
class LocationDetailModel {
  LocationDetailModel(
      {this.callbackTime,
      this.locTime,
      this.locationType,
      this.accuracy,
      this.altitude,
      this.speed,
      this.bearing,
      this.latitude,
      this.longitude,
      this.province,
      this.country,
      this.district,
      this.city,
      this.cityCode,
      this.street,
      this.streetNumber,
      this.adCode,
      this.address,
      this.description});

  /// 回调时间，格式为"yyyy-MM-dd HH:mm:ss
  String? callbackTime;

  /// 定位时间， 格式为"yyyy-MM-dd HH:mm:ss
  String? locTime;

  /// 定位类型， 具体类型可以参考https://lbs.amap.com/api/android-location-sdk/guide/utilities/location-type
  int? locationType;

  /// 精确度
  double? accuracy;

  /// 海拔, android上只有locationType==1时才会有值
  double? altitude;

  /// 速度， android上只有locationType==1时才会有值
  double? speed;

  /// 角度，android上只有locationType==1时才会有值
  double? bearing;

  /// 维度
  double? latitude;

  /// 精度
  double? longitude;

  /// 国家
  String? country;

  /// 省
  String? province;

  /// 城市

  String? city;

  /// 城市编码
  String? cityCode;

  /// 城市编码(通用)
  String? cityCodeNew;

  /// 城镇（区）
  String? district;

  /// 区域编码
  String? adCode;

  /// 街道
  String? street;

  /// 门牌号
  String? streetNumber;

  /// 地址信息
  String? address;

  /// 位置语义
  String? description;

  LocationDetailModel.fromJson(Map<String, dynamic> json) {
    locTime = json['locTime'];
    callbackTime = json['callbackTime'];
    speed = json['speed'];
    bearing = json['bearing'];
    accuracy = json['accuracy'];
    adCode = json['adCode'];
    altitude = json['altitude'];
    locationType = json['locationType'];

    latitude = json['latitude'];
    longitude = json['longitude'];

    country = json['country'];
    province = json['province'];
    district = json['district'];
    cityCode = json['cityCode'];
    cityCodeNew = (adCode != null && adCode!.length > 4)
        ? "${adCode?.substring(0, 4)}00"
        : null;
    city = json['city'];
    street = json['street'];
    streetNumber = json['streetNumber'];

    address = json['address'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['locTime'] = locTime;
    data['callbackTime'] = callbackTime;
    data['speed'] = speed;
    data['bearing'] = bearing;
    data['accuracy'] = accuracy;
    data['altitude'] = altitude;
    data['locationType'] = locationType;

    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['country'] = country;
    data['province'] = province;

    data['city'] = city;
    data['cityCode'] = cityCode;
    data['cityCodeNew'] = cityCodeNew;
    data['district'] = district;
    data['adCode'] = adCode;

    data['street'] = street;
    data['streetNumber'] = streetNumber;
    data['address'] = address;
    data['description'] = description;
    return data;
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    final isEqual = other is LocationDetailModel &&
        runtimeType == other.runtimeType &&
        mapEquals(toJson(), other.toJson());
    return isEqual;
  }

  @override
  int get hashCode => Object.hash(
      callbackTime.hashCode,
      locTime.hashCode,
      locationType.hashCode,
      accuracy.hashCode,
      altitude.hashCode,
      speed.hashCode,
      bearing.hashCode,
      latitude.hashCode,
      longitude.hashCode,
      province.hashCode,
      country.hashCode,
      district.hashCode,
      city.hashCode,
      cityCode.hashCode,
      street.hashCode,
      streetNumber.hashCode,
      adCode.hashCode,
      address.hashCode,
      description.hashCode);
}

//"{'locTime':'2023-08-08 17:33:37','province':'陕西省','callbackTime':'2023-08-08 17:33:37','district':'雁塔区','country':'中国','street':'雁南五路','speed':-1.0,'latitude':'34.192569','city':'西安市','streetNumber':'1958号','bearing':-1.0,'accuracy':59.8563551869,'adCode':'610113','altitude':438.782470703125,'locationType':1,'longitude':'108.953720','cityCode':'029','address':'陕西省西安市雁塔区雁南五路靠近华美达广场酒店','description':'陕西省西安市雁塔区雁南五路靠近华美达广场酒店'}"
