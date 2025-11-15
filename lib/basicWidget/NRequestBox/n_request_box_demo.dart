import 'package:flutter_templet_project/extension/extension_local.dart';
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_templet_project/basicWidget/NNet/NNetContainerListView.dart';
// import 'package:flutter_templet_project/basicWidget/NRequestBox/n_request_box.dart';
// import 'package:yl_health_app/extension/date_time_ext.dart';
// import 'package:yl_health_app/extension/string_ext.dart';
// import 'package:yl_health_app/http/api/scheme_page_api.dart';
// import 'package:yl_health_app/http/model/department_page_root_model.dart';
// import 'package:yl_health_app/page/doctor/home/patient_scheme_cell_one.dart';
// import 'package:yl_health_app/util/color_util.dart';
// import 'package:yl_health_app/vender/bruno/bruno_util.dart';
// import 'package:yl_health_app/widget/NNet/NNetContainerListView.dart';
// import 'package:yl_health_app/widget/NRequestBox/n_request_box.dart';
//
//
// /// 列表请求组件
// /// 支持: 下拉刷新,上拉加载; 搜索框回调; 下拉弹窗;
// class NRequestBoxDemo extends StatefulWidget {
//
//   NRequestBoxDemo({
//     Key? key,
//     this.title,
//     this.hideAppBar = false,
//   }) : super(key: key);
//
//   final String? title;
//
//   final bool hideAppBar;
//
//   @override
//   _NRequestBoxDemoState createState() => _NRequestBoxDemoState();
// }
//
// class _NRequestBoxDemoState extends State<NRequestBoxDemo> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: widget.hideAppBar ? null : AppBar(
//         title: Text(widget.title ?? "$widget"),
//         actions: ['done',].map((e) => TextButton(
//           child: Text(e,
//             style: TextStyle(color: Colors.white),
//           ),
//           onPressed: (){
//
//           },
//         )).toList(),
//       ),
//       body: buildBody(),
//     );
//   }
//
//   buildBody() {
//     return NRequestBox(
//       onSearchChanged: (String value) {
//         debugPrint(value);
//       },
//       // btnBulder: (context, onToggle) {
//       //   return ElevatedButton(
//       //     onPressed: onToggle,
//       //     child: Text("按钮")
//       //   );
//       // },
//       dropView: Container(
//         // color: Colors.white,
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Container(
//               height: 400,
//               color: Colors.green,
//             ),
//             Container(
//               height: 400,
//               color: Colors.yellowAccent,
//             ),
//           ],
//         ),
//       ),
//       dropViewCancel: (){
//         return true;
//       },
//       dropViewConfirm: (){
//         return false;
//       },
//       body: NNetContainerListView<DepartmentPageDetailModel>(
//           onRequest: (bool isRefresh, int page, int pageSize, last) {
//             final ownerId = "412636124799488000";
//             return requestList(isRefresh: isRefresh, ownerId: ownerId);
//           },
//           onRequestError: (Object error, StackTrace stack) {
//             BrunoUtil.showInfoToast("$error");
//           },
//           itemBuilder: (BuildContext context, int index, DepartmentPageDetailModel data) {
//             final e = data;
//
//             return InkWell(
//               onTap: (){
//                 debugPrint("$e");
//               },
//               child: PatientSchemeCellOne(
//                 color: e.statusTuple?.item2 ?? primary,
//                 isFirst: index == 0,
//                 isLast: false,
//                 time: e.updateTime == null ? "-" : DateTimeExt.stringFromTimestamp(timeSamp: e.updateTime!),
//                 planTitle: e.name ?? "-",
//                 planTime: e.dateRangeDes ?? "-",
//                 status: e.statusDes ?? "-",
//                 scence: e.sceneTuple?.item1 ?? "",
//                 scenceColor: e.sceneTuple?.item2 ?? Color(0xff5690F4),
//                 btnTitle: e.btnTitle != null ? "${e.btnTitle} >" : "查看详情 >",
//                 onClick: () {
//                   debugPrint("$e");
//                 },
//               ),
//             );
//           },
//           separatorBuilder: (context, int index){
//             return SizedBox();
//           }
//       ),
//     );
//   }
//
//   Future<List<DepartmentPageDetailModel>> requestList({
//     required bool isRefresh,
//     required String ownerId,
//     int pageNo = 1,
//     int pageSize = 20,
//   }) async {
//     // if (isRefresh) {
//     //   pageNo = 1;
//     // } else {
//     //   pageNo++;
//     // }
//
//     Map<String, dynamic>? response = await SchemePageApi(
//       ownerId: ownerId,
//       pageNo: pageNo,
//       pageSize: pageSize,
//     ).startRequest();
//     // debugPrint(response.runtimeType.toString());
//     final rootModel = DepartmentPageRootModel.fromJson(response ?? {});
//     var list = rootModel.result?.content ?? [];
//     return list;
//   }
// }
//
