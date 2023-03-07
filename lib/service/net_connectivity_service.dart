// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
//
// // abstract class NetConnectivityListener {
// //   void onNetStateChaneged(ConnectivityResult result);
// // }
//
// class NetConnectivityService {
//
//   NetConnectivityService._() {
//     try {
//       _connectivity.onConnectivityChanged.listen((event) {
//         netState.value = event;
//         onLine.value = (event != ConnectivityResult.none);
//         for (final listener in listeners) {
//           listener.onNetStateChaneged(event);
//         }
//       });
//     } catch (e, trace) {
//       // Log.error('ConnectivityService', e, trace);
//     }
//   }
//
//   static final NetConnectivityService _instance = NetConnectivityService._();
//
//   factory NetConnectivityService() => _instance;
//
//   static NetConnectivityService get instance => _instance;
//
//
//   final Connectivity _connectivity = Connectivity();
//
//   final List<NetConnectivityListener> listeners = [];
//   /// 网络当前状态(wifi, mobile, none); 可通过 ValueListenableBuilder 监听网络状态改变
//   final netState = ValueNotifier<ConnectivityResult>(ConnectivityResult.mobile);
//   /// 是否联网; 可通过 ValueListenableBuilder 监听网络状态改变
//   final onLine = ValueNotifier<bool>(true);
//
//   Future<ConnectivityResult> checkConnectivity() async {
//     return await _connectivity.checkConnectivity();
//   }
//
//   addListener(NetConnectivityListener? listener) {
//     if (listener != null) {
//       listeners.add(listener);
//     }
//   }
//
//   removeListener(NetConnectivityListener? listener) {
//     if (listener != null) {
//       listeners.remove(listener);
//     }
//   }
//
//   clearListeners() {
//     listeners.clear();
//   }
// }
//
//
// mixin NetConnectivityMixin<T extends StatefulWidget> on State<T> {
//   @override
//   void initState() {
//     ConnectivityService.instance.removeListener(connectivityListener);
//     ConnectivityService.instance.addListener(connectivityListener);
//
//     super.initState();
//   }
//
//   void onNetStateChaneged(ConnectivityResult result);
//
//   @override
//   void dispose() {
//     ConnectivityService.instance.removeListener(connectivityListener);
//
//     super.dispose();
//   }
//
//   NetConnectivityListener get connectivityListener;
// }