// //
// //  PatientPageNew.dart
// //  yl_health_app
// //
// //  Created by shang on 2023/8/22 16:00.
// //  Copyright © 2023/8/22 shang. All rights reserved.
// //
//
// import 'dart:async';
//
// import 'package:flutter_pickers/time_picker/model/pduration.dart';
// import 'package:easy_refresh/easy_refresh.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:tuple/tuple.dart';
// import 'package:yl_health_app/db/cache_service.dart';
// import 'package:yl_health_app/extension/build_context_ext.dart';
// import 'package:yl_health_app/extension/date_time_ext.dart';
// import 'package:yl_health_app/extension/string_ext.dart';
// import 'package:yl_health_app/extension/widget_ext.dart';
// import 'package:yl_health_app/http/api/disease_type_list_api.dart';
// import 'package:yl_health_app/http/api/doctor_info_api.dart';
// import 'package:yl_health_app/http/api/doctor_list_for_carer_api.dart';
// import 'package:yl_health_app/http/api/doctor_team_list_api.dart';
// import 'package:yl_health_app/http/api/patient_detail_api.dart';
// import 'package:yl_health_app/http/api/patient_list_by_doctor_api.dart';
// import 'package:yl_health_app/http/api/tag_list_api.dart';
// import 'package:yl_health_app/http/model/disease_types_root_model.dart';
// import 'package:yl_health_app/http/model/doctor_detail_root_model.dart';
// import 'package:yl_health_app/http/model/doctor_list_root_model.dart';
// import 'package:yl_health_app/http/model/doctor_team_list_root_model.dart';
// import 'package:yl_health_app/http/model/patient_detail_model.dart';
// import 'package:yl_health_app/http/model/patient_list_root_model.dart';
// import 'package:yl_health_app/http/model/tags_root_model.dart';
// import 'package:yl_health_app/http/model/user_detail_model.dart';
// import 'package:yl_health_app/http/request_manager.dart';
// import 'package:yl_health_app/page/patient_filter_box.dart';
// import 'package:yl_health_app/page/patient/patient_cell.dart';
// import 'package:yl_health_app/routers/navigator_util.dart';
// import 'package:yl_health_app/routers/routes.dart';
// import 'package:yl_health_app/util/color_util_new.dart';
// import 'package:yl_health_app/util/tool_util.dart';
// import 'package:yl_health_app/widget/common/my_app_bar.dart';
// import 'package:yl_health_app/widget/common/my_image.dart';
// import 'package:yl_health_app/widget/n_pair.dart';
// import 'package:yl_health_app/widget/n_placeholder.dart';
// import 'package:yl_health_app/widget/n_search_textfield.dart';
// import 'package:yl_health_app/widget/n_skeleton_screen.dart';
// import 'package:yl_health_app/widget/n_tab_bar_indicator_fixed.dart';
// import 'package:get/get.dart';
// import 'package:yl_health_app/widget/n_text.dart';
// import 'package:yl_health_app/widget/search_widget.dart';
// import 'package:yl_health_app/widget/template_search_textfield.dart';
//
// /// 患者列表页面
// class PatientPageNew extends StatefulWidget {
//   const PatientPageNew({Key? key, this.title}) : super(key: key);
//
//   final String? title;
//
//   @override
//   PatientPageNewState createState() => PatientPageNewState();
// }
//
// class PatientPageNewState extends State<PatientPageNew> with SingleTickerProviderStateMixin {
//   EasyRefreshController? _refreshController;
//
//   /// 是否加载完成
//   final hasLoading = ValueNotifier(true);
//
//   bool isGroupExpand = false;
//
//   /// 搜索
//   late final searchController = TextEditingController();
//
//   String searchText = "";
//
//   /// 筛选弹窗相关
//   // final _globalKey = GlobalKey();
//
//   var isVisible = ValueNotifier(false);
//
//   ScrollController? dropBoxController = ScrollController();
//
//   /// 列表
//   final itemScrollController = ItemScrollController();
//
//   var dataList = ValueNotifier(<PatientDetailModel>[]);
//
//   /// 用户详情
//   UserDetailModel? doctorDetailModel = CacheService().detailModel;
//
//   /// 时段选择器
//   /// 加入团队时间
//   PDuration? joinedStartDate;
//   /// 退出团队时间
//   PDuration? joinedEndDate;
//   /// 加入团队时间
//   PDuration? joinedStartDateTmp;
//   /// 退出团队时间
//   PDuration? joinedEndDateTmp;
//
//   /// 医生团队列表组
//   List<DoctorTeamDetailModel> get doctorTeamModels => CacheService().doctorTeamListRootModel?.result ?? [];
//   DoctorTeamDetailModel? selectedDoctorTeamModel;
//
//   /// 医生列表组
//   List<UserDetailModel> get doctorModels => CacheService().doctorListRootModel?.result ?? [];
//   UserDetailModel? selectedDoctorModel;
//
//   /// 疾病组
//   List<DiseaseTypesDetailModel> get diseaseModels => CacheService().diseaseTypesRootModel?.result?.content ?? [];
//   DiseaseTypesDetailModel? selectedDiseaseModel;
//
//   /// 标签组
//   List<TagDetailModel> get tagModels => CacheService().tagsRootModel?.result ?? [];
//   TagDetailModel? selectedTagModel;
//
//   ///显示筛选按钮
//   final hasFilter = ValueNotifier(false);
//
//   @override
//   void dispose() {
//     _refreshController?.dispose();
//     // tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshController = EasyRefreshController(
//       controlFinishRefresh: true,
//       controlFinishLoad: false,
//     );
//     // configRefresh();
//
//     initRequestData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: ToolUtil.renderSystemUiDark(),
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () {
//             ToolUtil.removeInputFocus();
//           },
//           child: Scaffold(
//             backgroundColor: weChatBgColor,
//             appBar: MyAppBar(
//               backgroundColor: weChatBgColor,
//               rightActions: [
//                 buildFilterButton(
//                   onPressed: (){
//                     isVisible.value = !isVisible.value;
//                     closeKeyboard();
//
//                     setState(() {});
//                   }
//                 ),
//               ],
//               title: '患者',
//               leadingVisible: false,
//               brightness: Brightness.dark,
//               overlayStyle: SystemUiOverlayStyle.dark,
//               bottom: buildPreferredSize(
//                 searchEnabled: false,
//                 onPressed: (){
//                   NavigatorUtil.jump(APPRouter.patientSearchPage);
//                 }
//               ),
//             ),
//             body: buildBody(),
//           ),
//         ),
//       );
//     } catch (exception) {
//       return Text(exception.toString());
//     }
//   }
//
//   buildBody() {
//     return SafeArea(
//       child: Column(
//         children: [
//           Expanded(
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // buildGroupAndTagBar(),
//                     Expanded(child: buildList()),
//                     // buildListCountDescBar(),
//                   ],
//                 ),
//                 // 筛选弹窗隐藏显示监听
//                 ValueListenableBuilder<bool>(
//                   valueListenable: isVisible,
//                   builder: (context, bool value, child) {
//                     if (value == false) {
//                       return const SizedBox();
//                     }
//                     return Positioned(
//                       top: 0,
//                       bottom: 0,
//                       width: context.screenSize.width,
//                       // height: 600.h,
//                       child: PatientFilterBox(
//                         doctorTeamModels: doctorTeamModels,
//                         doctorModels: doctorModels,
//                         diseaseModels: diseaseModels,
//                         tagModels: tagModels,
//                         selectedDoctorTeamModel: selectedDoctorTeamModel,
//                         selectedDoctorModel: selectedDoctorModel,
//                         selectedDiseaseModel: selectedDiseaseModel,
//                         selectedTagModel: selectedTagModel,
//                         onCancel: () {
//                           selectedDoctorTeamModel = null;
//                           selectedDoctorModel = null;
//                           selectedDiseaseModel = null;
//                           selectedTagModel = null;
//
//                           closeDropBox();
//                           requestPatientList();
//                         },
//                         onConfirm: (DoctorTeamDetailModel? doctorTeamModel, UserDetailModel? doctorModel, DiseaseTypesDetailModel? diseaseModel, TagDetailModel? tagModel) {
//                           selectedDoctorTeamModel = doctorTeamModel;
//                           selectedDoctorModel = doctorModel;
//                           selectedDiseaseModel = diseaseModel;
//                           selectedTagModel = tagModel;
//
//                           closeDropBox();
//                           requestPatientList();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// 筛选按钮
//   Widget buildFilterButton({
//     Color? color = fontColor,
//     VoidCallback? onPressed,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         margin: const EdgeInsets.only(right: 14),
//         // padding: const EdgeInsets.only(right: 14),
//         child: NPair(
//           label: NText(data: "筛选", fontSize: 14, color: color,),
//           icon: MyImage(
//             "images/icon_filter_template.png",
//             color: color,
//             width: 13,
//             height: 13,
//           ),
//           isReverse: true,
//         ),
//       ),
//     );
//   }
//
//
//   /// 导航栏底部的搜索组件
//   /// searchEnabled 搜索是否可用
//   /// onPressed 搜索组件不可用点击回调
//   PreferredSize buildPreferredSize({
//     bool searchEnabled = true,
//     VoidCallback? onPressed,
//   }) {
//     const padding = EdgeInsets.only(
//       left: 16,
//       right: 16,
//       bottom: 12,
//     );
//     final height = 36 + padding.top + padding.bottom;
//
//     return PreferredSize(
//       preferredSize: Size.fromHeight(height),
//       child: Padding(
//         padding: padding,
//         child: InkWell(
//           onTap: onPressed,
//           child: NSearchTextField(
//             controller: searchController,
//             placeholder: '搜索',
//             backgroundColor: white,
//             onChanged: (v) {},
//             enabled: searchEnabled,
//           )
//           // NSearchTextField(
//           //   backgroundColor: Colors.white,
//           //   controller: searchController,
//           //   placeholder: "搜索",
//           //   onChanged: (value) {
//           //     // debugPrint(value);
//           //   },
//           //   enabled: searchEnabled,
//           // ),
//         ),
//       ),
//     );
//   }
//
//
//   buildList() {
//     return ValueListenableBuilder<List<PatientDetailModel>>(
//         valueListenable: dataList,
//         builder: (context, dataList, child) {
//           if (dataList.isEmpty) {
//             return hasLoading.value ? const NSkeletonScreen() : NPlaceholder(
//               imageAndTextSpacing: 10,
//               onTap: () async {
//                 FocusScope.of(context).unfocus();
//                 await requestPatientList();
//               },
//             );
//           }
//
//           return buildRefresh(
//               onRefresh: () async {
//                 await requestPatientList();
//                 _refreshController?.finishRefresh();
//               },
//               child: ListView.separated(
//                   itemBuilder: (context, index) {
//
//                     final model = dataList[index];
//                     return PatientCell(model: model);
//                   },
//                   separatorBuilder: (context, index) {
//                     return const Divider(height: 1,);
//                   },
//                   itemCount: dataList.length,
//                 ),
//               );
//         });
//   }
//
//
//   buildRefresh({
//     required Widget? child,
//     required FutureOr Function()? onRefresh,
//   }) {
//     return EasyRefresh(
//       controller: _refreshController,
//       onRefresh: onRefresh,
//       // onLoad: () async {
//       //   if (!mounted) {
//       //     return;
//       //   }
//       //   page += 1;
//       //   final models = await widget.onRequest(false, page, widget.pageSize, _items.value.last);
//       //   _items.value = [..._items.value, ...models];
//       //   // setState(() {});
//       //
//       //   final result = models.length >= widget.pageSize ? IndicatorResult.noMore : IndicatorResult.success;
//       //   _refreshController?.finishLoad(result);
//       // },
//       child: child,
//     );
//   }
//
//   ///查询患者列表
//   Future<PatientListRootModel?> requestPatientList({
//     bool isRefreshList = true,
//     bool isCheckTab = false,
//     ValueChanged<PatientListRootModel>? cb,
//     VoidCallback? errorCb,
//   }) async {
//     String? doctorId = CacheService().userID;
//
//     // debugPrint("requestPaticentList userId: ${doctorId}");
//     // final getGroupPublicUser = isTeam ? "Y" : "N";
//     const getGroupPublicUser = "A";
//     // int? doctorId = int.tryParse(userId);
//
//     String? joiningStartTime;
//     if (joinedStartDate != null) {
//       final dateTime = DateTime(joinedStartDate!.year!, joinedStartDate!.month!, joinedStartDate!.day!);
//       joiningStartTime = DateTimeExt.stringFromDate(date: dateTime, format: DATE_FORMAT_DAY);
//     }
//
//     String? joiningEndTime;
//     if (joinedEndDate != null) {
//       final dateTime = DateTime(joinedEndDate!.year!, joinedEndDate!.month!, joinedEndDate!.day!);
//       joiningEndTime = DateTimeExt.stringFromDate(date: dateTime, format: DATE_FORMAT_DAY);
//     }
//
//     var api = PatientListByDoctorApi(
//       doctorId: doctorId,
//       getGroupPublicUser: getGroupPublicUser,
//       diseaseTypeId: isCheckTab ? null : selectedDiseaseModel?.id,
//       tagsId: isCheckTab ? null : selectedTagModel?.id,
//       patientRealName: isCheckTab ? null : searchText,
//       groupNo: isCheckTab ? null : selectedDoctorTeamModel?.groupNo,
//       groupName: selectedDoctorTeamModel?.groupName,
//       joiningStartTime: joiningStartTime,
//       joiningEndTime: joiningEndTime,
//     );
//     var response = await api.startRequest();
//     final rootModel = PatientListRootModel.fromJson(response);
//     if (response['code'] != 'OK') {
//       return null;
//     }
//
//     var list = <PatientDetailModel>[];
//     rootModel.result?.forEach((e) {
//       e.items?.forEach((element) {
//         element.key = e.key;
//       });
//       list.addAll(e.items ?? []);
//     });
//     dataList.value = [...list];
//     hasLoading.value = false;
//     return rootModel;
//   }
//
//   requestPatientDetail({String? userId, ValueChanged<Map>? cb, VoidCallback? errorCb}) async {
//     // userId = "419871467138764800";//add test
//     // String doctorId = "422324509454110720";// add test
//     var api = PatientDetailApi(userId: userId, doctorId: userId);
//     var response = await RequestManager().request(api);
//     // final rootModel = PatientListRootModel.fromJson(response);
//     if (response is Map && response['code'] == 'OK') {
//       cb?.call(response);
//     } else {
//       errorCb?.call();
//     }
//   }
//
//   initRequestData() async {
//     await requestPatientList();
//     await refreshFilter();
//   }
//
//   /// 刷新筛选项
//   refreshFilter() async {
//     await requestDiseaseTypes();
//     await requestTagList();
//
//     final fitterModels = [doctorTeamModels, diseaseModels, tagModels];
//     hasFilter.value = fitterModels.where((e) => e.isNotEmpty).isNotEmpty && dataList.value.isNotEmpty;
//     debugPrint("hasFilter:${hasFilter.value}");
//   }
//
//
//   requestUserInfo({ValueChanged<Map>? cb, VoidCallback? errorCb}) async {
//     if (doctorDetailModel?.diseaseDepartmentId != null) {
//       return;
//     }
//     final userId = CacheService().userID;
//     // var api = DoctorInfoApi(id: userID);
//     var infoApi =  DoctorInfoApi(id: userId);
//
//     var response = await RequestManager().request(infoApi);
//     final rootModel = DoctorDetailRootModel.fromJson(response);
//     CacheService().detailModel = rootModel.result;
//     // debugPrint(rootModel.message);
//     if (response is Map && response['code'] == 'OK') {
//       cb?.call(response);
//       // await api.removeCache();
//     } else {
//       errorCb?.call();
//     }
//   }
//
//   requestDiseaseTypes({ValueChanged<Map>? cb, VoidCallback? errorCb}) async {
//     // if (diseaseTypesRootModel?.result?.content?.isNotEmpty == true) {
//     //   return;
//     // }
//     var diseaseDepartmentId = CacheService().detailModel?.diseaseDepartmentId ?? "";
//     var agencyId = CacheService().loginUserModel?.agencyId ?? "";
//
//     var api = DiseaseTypeListApi(
//       diseaseDepartmentId: diseaseDepartmentId,
//       agencyId: agencyId,
//     );
//     // api.removeCache();
//     var response = await RequestManager().request(api);
//     var rootModel = DiseaseTypesRootModel.fromJson(response);
//     CacheService().diseaseTypesRootModel = rootModel;
//     // diseaseTypesRootModel = rootModel;
//     // debugPrint("${rootModel.runtimeType}");
//     if (response is Map && response['code'] == 'OK') {
//       cb?.call(response);
//       // await api.removeCache();
//     } else {
//       errorCb?.call();
//     }
//   }
//
//   requestTagList({ValueChanged<Map>? cb, VoidCallback? errorCb}) async {
//     // if (tagsRootModel?.result?.isNotEmpty == true) {
//     //   return;
//     // }
//     var diseaseDepartmentId = CacheService().detailModel?.diseaseDepartmentId;
//     var agencyId = CacheService().loginUserModel?.agencyId;
//
//     var api = TagListApi(
//       diseaseDepartmentId: diseaseDepartmentId,
//       agencyId: agencyId,
//     );
//     // api.removeCache();
//     var response = await RequestManager().request(api);
//     var rootModel = TagsRootModel.fromJson(response);
//     CacheService().tagsRootModel = rootModel;
//     // tagsRootModel = rootModel;
//     if (response is Map && response['code'] == 'OK') {
//       cb?.call(response);
//       // await api.removeCache();
//     } else {
//       errorCb?.call();
//     }
//   }
//
//   /// 医生(团队)列表
//   Future<DoctorTeamListRootModel> requestDoctorTeamList() async {
//     // if (doctorTeamListRootModel != null) {
//     //   return Future.value(doctorTeamListRootModel);
//     // }
//     var api = DoctorTeamListApi();
//     Map<String, dynamic>? response = await RequestManager().request(api);
//     final rootModel = DoctorTeamListRootModel.fromJson(response);
//     return Future.value(rootModel);
//   }
//
//   /// 医生列表
//   Future<DoctorListRootModel> requestDoctorList() async {
//     var healthManagementId = CacheService().loginUserModel?.id;
//     var api = DoctorListForCarerApi(
//       agencyId: healthManagementId ?? "",
//     );
//
//     Map<String, dynamic>? response = await RequestManager().request(api);
//     final rootModel = DoctorListRootModel.fromJson(response);
//     // final list = rootModel.result?.content ?? [];
//     return rootModel;
//   }
//
//   closeDropBox() {
//     if (isVisible.value == false) {
//       return;
//     }
//     isVisible.value = !isVisible.value;
//   }
//
//   closeKeyboard() {
//     FocusManager.instance.primaryFocus?.unfocus();
//   }
// }
//
