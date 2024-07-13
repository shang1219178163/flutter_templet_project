// //
// //  LocationStateMixin.dart
// //  yl_patient_app
// //
// //  Created by shang on 2023/9/5 11:49.
// //  Copyright © 2023/9/5 shang. All rights reserved.
// //
//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_templet_project/extension/ddlog.dart';
// import 'package:flutter_templet_project/vendor/amap_location/location_detail_model.dart';
//
// import 'package:permission_handler/permission_handler.dart';
// import 'package:amap_flutter_location/amap_flutter_location.dart';
// import 'package:amap_flutter_location/amap_location_option.dart';
// import 'package:yl_health_app/vender/amap_location/location_detail_model.dart';
// import 'package:yl_health_app/vender/amap_location/map_util.dart';
//
// /*
// * 混入然后实现 onLocationChanged 和 onLocationFailed 即可
// * */
// example:
// //  // 当前所在位置
// //  LocationDetailModel? locationModel;
// //
// // @override
// // void onLocationChanged(LocationDetailModel locationModel) {
// //   YLog.d("$this onLocationChanged: $location");
// //   locationModel = model;
// //   return model.cityCode?.isNotEmpty == true;
// // }
// //
// // @override
// // void onLocationFailed(Map<String, Object> result) {
// //   YLog.d("$this onLocationFailed: $location");
// //     ...
// // }
//
//
// /// 高德定位混入
// mixin LocationStateMixin<T extends StatefulWidget> on State<T> {
//
//   StreamSubscription<Map<String, Object>>? _locationListener;
//   /// 请求
//   final _locationPlugin = AMapFlutterLocation();
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     stopLocation();
//     _locationListener?.cancel();
//     ///销毁定位
//     _locationPlugin.destroy();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _initData();
//   }
//
//   /// 初始化
//   Future<void> _initData() async {
//     /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作
//     ///
//     /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
//     /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
//     ///
//     /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
//     ///
//     /// [hasContains] 隐私声明中是否包含高德隐私政策说明
//     ///
//     /// [hasShow] 隐私权政策是否弹窗展示告知用户
//     AMapFlutterLocation.updatePrivacyShow(true, true);
//
//     /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作
//     ///
//     /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
//     ///
//     /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
//     ///
//     /// [hasAgree] 隐私权政策是否已经取得用户同意
//     AMapFlutterLocation.updatePrivacyAgree(true);
//
//     ///设置Android和iOS的apiKey<br>
//     ///key的申请请参考高德开放平台官网说明<br>
//     ///Android: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key
//     ///iOS: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key
//     AMapFlutterLocation.setApiKey(MapUtil.android_Key, MapUtil.iOS_Key);
//
//     ///iOS 获取native精度类型
//     if (Platform.isIOS) {
//       requestAccuracyAuthorization();
//     } else {
//       if (needPermission) {
//         /// 动态申请定位权限
//         await requestPermission();
//       }
//     }
//
//     ///注册定位结果监听
//     _locationListener = _locationPlugin
//         .onLocationChanged()
//         .listen((Map<String, Object> result) {
//       // final jsonStr = jsonEncode(result);
//       // debugPrint("LocationStateMixin jsonStr: $jsonStr");
//       if (!result.containsKey("latitude") ||
//           [0, "", null].contains(result["latitude"])) {
//         DLog.d("❌ $this ${result["errorInfo"]}");
//         onLocationFailed(result);
//         return;
//       }
//       final locationModel = LocationDetailModel.fromJson(result);
//       // debugPrint("locationModel: locationModel");
//       final isSuccess = onLocationChanged(locationModel);
//       if (isSuccess) {
//         stopLocation();
//       }
//     });
//
//     startLocation();
//   }
//
//   ///设置定位参数
//   void _setLocationOption() {
//     AMapLocationOption option = AMapLocationOption();
//
//     ///是否单次定位
//     option.onceLocation = false;
//
//     ///是否需要返回逆地理信息
//     option.needAddress = true;
//
//     ///逆地理信息的语言类型
//     option.geoLanguage = GeoLanguage.DEFAULT;
//
//     option.desiredLocationAccuracyAuthorizationMode = AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
//
//     option.fullAccuracyPurposeKey = "fullAccuracyPurposeKey";
//
//     ///设置Android端连续定位的定位间隔
//     option.locationInterval = 2000;
//
//     ///设置Android端的定位模式<br>
//     ///可选值：<br>
//     ///<li>[AMapLocationMode.Battery_Saving]</li>
//     ///<li>[AMapLocationMode.Device_Sensors]</li>
//     ///<li>[AMapLocationMode.Hight_Accuracy]</li>
//     option.locationMode = AMapLocationMode.Hight_Accuracy;
//
//     ///设置iOS端的定位最小更新距离<br>
//     option.distanceFilter = -1;
//
//     ///设置iOS端期望的定位精度
//     /// 可选值：<br>
//     /// <li>[DesiredAccuracy.Best] 最高精度</li>
//     /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
//     /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
//     /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
//     /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
//     option.desiredAccuracy = DesiredAccuracy.NearestTenMeters;
//
//     ///设置iOS端是否允许系统暂停定位
//     option.pausesLocationUpdatesAutomatically = false;
//
//     ///将定位参数设置给定位插件
//     _locationPlugin.setLocationOption(option);
//   }
//
//   ///开始定位
//   void startLocation() {
//     ///开始定位之前设置定位参数
//     _setLocationOption();
//     _locationPlugin.startLocation();
//   }
//
//   ///停止定位
//   void stopLocation() {
//     _locationPlugin.stopLocation();
//   }
//
//   ///获取iOS native的accuracyAuthorization类型
//   void requestAccuracyAuthorization() async {
//     AMapAccuracyAuthorization currentAccuracyAuthorization = await _locationPlugin.getSystemAccuracyAuthorization();
//     if (currentAccuracyAuthorization == AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
//       debugPrint("精确定位类型");
//     } else if (currentAccuracyAuthorization == AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
//       debugPrint("模糊定位类型");
//     } else {
//       debugPrint("未知定位类型");
//     }
//   }
//
//   /// 动态申请定位权限
//   void requestPermission() async {
//     // 申请权限
//     bool hasLocationPermission = await requestLocationPermission();
//     if (hasLocationPermission) {
//       debugPrint("定位权限申请通过");
//     } else {
//       // debugPrint("定位权限申请不通过");
//       openAppSettings();
//     }
//   }
//
//   /// 申请定位权限
//   /// 授予定位权限返回true， 否则返回false
//   Future<bool> requestLocationPermission() async {
//     //获取当前的权限
//     var status = await Permission.location.status;
//     if (status == PermissionStatus.granted) {
//       //已经授权
//       return true;
//     }
//     //未授权则发起一次申请
//     status = await Permission.location.request();
//     return (status == PermissionStatus.granted);
//   }
//
//   /************************* 定位回调方法 *************************/
//   /// 定位回调
//   ///
//   /// - locationModel 定位返回信息对象(有时仅返回经纬度,不返回城市信息)
//   ///
//   /// return 返回 true 则停止继续定位
//   bool onLocationChanged(LocationDetailModel model) {
//     throw UnimplementedError("❌$this 未实现 onLocationChanged");
//   }
//
//   /// 定位失败回调(可选实现)
//   ///
//   /// - error 定位失败返回信息(定位成功则为空)
//   void onLocationFailed(Map<String, Object> result) {
//     DLog.d("❌$this onLocationFailed ${result}");
//   }
// }
//
