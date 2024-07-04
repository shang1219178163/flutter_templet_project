//
//  CacheController.dart
//  yl_health_app_v2.20.4.1
//
//  Created by shang on 2024/3/25 15:33.
//  Copyright © 2024/3/25 shang. All rights reserved.
//

import 'dart:async';
import 'dart:convert';

import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:get/get.dart';

class CacheController {
  CacheController();

  String get userId => CacheService().userID ?? "";

  // /// 群聊天模型列表转存
  // Future<bool>? setGroupHistorys<T extends IMMsgDetailModel>({
  //   required String groupId,
  //   required List<T> value,
  // }) {
  //   final key = "GroupHistorys_$groupId";
  //   return setModels<T>(
  //     key: key,
  //     value: value,
  //     mapCb: (e) => e.toJson(),
  //   );
  // }
  //
  // /// 群聊天模型列表读取
  // List<IMMsgDetailModel> getGroupHistorys({
  //   required String groupId,
  // }) {
  //   final key = "GroupHistorys_$groupId";
  //   return getModels(key: key, modelCb: (e) => IMMsgDetailModel.fromJson(e));
  // }
  //
  // /// 模型群详情
  // Future<bool>? setGroupDetailModel({
  //   required IMGroupDetailModel model,
  // }) {
  //   String groupId = model.groupId ?? "";
  //   if (groupId.isEmpty) {
  //     return Future(() => false);
  //   }
  //
  //   final key = "GroupDetailModel_$groupId";
  //   final json = model.toJson();
  //   return CacheService().setMap(key, json);
  // }
  //
  // /// 模型群详情
  // IMGroupDetailModel? getGroupDetailModel({
  //   required String groupId,
  // }) {
  //   final key = "GroupDetailModel_$groupId";
  //   final json = CacheService().getMap(key);
  //   if (json == null) {
  //     return null;
  //   }
  //   final model = IMGroupDetailModel.fromJson(json);
  //   return model;
  // }
  //
  // /// 患者模型转存
  // Future<bool>? setPatientModel({
  //   required PatientDetailModel value,
  // }) {
  //   if (value.id?.isNotEmpty != true) {
  //     return Future(() => false);
  //   }
  //   final key = "PatientModel_${value.id}";
  //   return CacheService().setMap(key, value.toJson());
  // }
  //
  // /// 患者模型读取
  // PatientDetailModel? getPatientModel({
  //   required String id,
  // }) {
  //   if (id.isNotEmpty != true) {
  //     return null;
  //   }
  //   final key = "PatientModel_$id";
  //   final json = CacheService().getMap(key);
  //   if (json == null) {
  //     return null;
  //   }
  //   final model = PatientDetailModel.fromJson(json);
  //   return model;
  // }
  //
  // /// 全部患者列表转存
  // Future<bool>? setPatients<T extends PatientDetailModel>({
  //   required List<T> value,
  // }) {
  //   if (userId.isNotEmpty != true) {
  //     return Future(() => false);
  //   }
  //   final key = "PatientList_$userId";
  //   return setModels<T>(
  //     key: key,
  //     value: value,
  //     mapCb: (e) => e.toJson(),
  //   );
  // }
  //
  // /// 全部患者列表读取
  // List<PatientDetailModel> getPatients() {
  //   if (userId.isNotEmpty != true) {
  //     return [];
  //   }
  //   final key = "PatientList_$userId";
  //   return getModels(key: key, modelCb: (e) => PatientDetailModel.fromJson(e));
  // }
}
