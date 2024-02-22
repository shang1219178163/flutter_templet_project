// //
// //  patient_filter_box.dart
// //  yl_health_app
// //
// //  Created by shang on 2024/1/20 10:17.
// //  Copyright © 2024/1/20 shang. All rights reserved.
// //
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:yl_health_app/extension/build_context_ext.dart';
// import 'package:yl_health_app/extension/string_ext.dart';
// import 'package:yl_health_app/http/model/disease_types_root_model.dart';
// import 'package:yl_health_app/http/model/doctor_team_list_root_model.dart';
// import 'package:yl_health_app/http/model/tags_root_model.dart';
// import 'package:yl_health_app/http/model/user_detail_model.dart';
// import 'package:yl_health_app/util/color_util_new.dart';
// import 'package:yl_health_app/widget/enhance/en_expansion_tile.dart';
// import 'package:yl_health_app/widget/n_choice_box.dart';
// import 'package:yl_health_app/widget/n_footer_button_bar.dart';
//
//
// typedef FilterBoxValueChanged = void Function(DoctorTeamDetailModel? doctorTeamModel, UserDetailModel? doctorModel, DiseaseTypesDetailModel? diseaseModel, TagDetailModel? tagModel);
//
// 下拉筛选菜单封装
// class PatientFilterBox extends StatefulWidget {
//
//   PatientFilterBox({
//     super.key,
//     required this.doctorTeamModels,
//     required this.doctorModels,
//     required this.diseaseModels,
//     required this.tagModels,
//     required this.selectedDoctorTeamModel,
//     required this.selectedDoctorModel,
//     required this.selectedDiseaseModel,
//     required this.selectedTagModel,
//     required this.onCancel,
//     required this.onConfirm,
//   });
//
//   final List<DoctorTeamDetailModel> doctorTeamModels;
//   final List<UserDetailModel> doctorModels;
//   final List<DiseaseTypesDetailModel> diseaseModels;
//   final List<TagDetailModel> tagModels;
//
//   final DoctorTeamDetailModel? selectedDoctorTeamModel;
//   final UserDetailModel? selectedDoctorModel;
//   final DiseaseTypesDetailModel? selectedDiseaseModel;
//   final TagDetailModel? selectedTagModel;
//
//   final FilterBoxValueChanged onConfirm;
//   final VoidCallback? onCancel;
//
//   @override
//   State<PatientFilterBox> createState() => _PatientFilterBoxState();
// }
//
// class _PatientFilterBoxState extends State<PatientFilterBox> {
//
//   final _scrollController = ScrollController();
//
//   /// 医生团队列表组
//   List<DoctorTeamDetailModel> get doctorTeamModels => widget.doctorTeamModels;
//   DoctorTeamDetailModel? selectedDoctorTeamModel;
//   DoctorTeamDetailModel? selectedDoctorTeamModelTmp;
//
//   /// 医生列表组
//   List<UserDetailModel> get doctorModels => widget.doctorModels;
//   UserDetailModel? selectedDoctorModel;
//   UserDetailModel? selectedDoctorModelTmp;
//
//   /// 疾病组
//   List<DiseaseTypesDetailModel> get diseaseModels => widget.diseaseModels;
//   DiseaseTypesDetailModel? selectedDiseaseModel;
//   DiseaseTypesDetailModel? selectedDiseaseModelTmp;
//
//   /// 标签组
//   List<TagDetailModel> get tagModels => widget.tagModels;
//   TagDetailModel? selectedTagModel;
//   TagDetailModel? selectedTagModelTmp;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     selectedDoctorTeamModelTmp = widget.selectedDoctorTeamModel;
//     selectedDoctorModelTmp = widget.selectedDoctorModel;
//     selectedDiseaseModelTmp = widget.selectedDiseaseModel;
//     selectedTagModelTmp = widget.selectedTagModel;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return buildDropBox(
//       controller: _scrollController,
//       hasShadow: true,
//     );
//   }
//
//   /// 筛选弹窗
//   Widget buildDropBox({
//     required ScrollController? controller,
//     bool hasShadow = false,
//   }) {
//
//     final choicSections = [
//       buildDropBoxDoctorTeamChoice(),
//       // buildDropBoxDoctorChoice(),
//       buildDropBoxDiseaseChoice(),
//       buildDropBoxTagChoice(),
//     ];
//
//     final child = Container(
//       width: double.maxFinite,
//       decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(8),
//             bottomRight: Radius.circular(8),
//           )
//       ),
//       child: Column(
//         children: [
//           const Divider(
//             height: 1,
//             color: lineColor,
//           ),
//           Expanded(
//             child: Container(
//               // padding: const EdgeInsets.only(
//               //   bottom: 24,
//               // ),
//               child: CupertinoScrollbar(
//                 controller: controller,
//                 child: SingleChildScrollView(
//                   controller: controller,
//                   child: Container(
//                     color: Colors.white,
//                     child: Column(
//                       children: choicSections.map((e) {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                               child: e,
//                             ),
//                             if(choicSections.last != e)buildDvider(),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           buildDropBoxButtonBar(),
//         ],
//       ),
//     );
//     return InkWell(
//       onTap: (){
//         widget.onCancel?.call();
//       },
//       child: Container(
//         color: Colors.black.withOpacity(0.4),
//         padding: EdgeInsets.only(
//           bottom: context.appBarHeight + 51,
//         ),
//         child: child,
//       ),
//     );
//   }
//
//   /// 筛选弹窗 医生团队选择
//   Widget buildDropBoxDoctorTeamChoice({
//     String title = "医生团队",
//     bool isExpand = false,
//     int collapseCount = 6,
//   }) {
//
//     final models = doctorTeamModels;
//     if (models.isEmpty) {
//       return const SizedBox();
//     }
//     final disable = (models.length <= collapseCount);
//
//     return StatefulBuilder(builder: (context, setState1) {
//       final items = isExpand ? models : models.take(collapseCount).toList();
//
//       return buildExpandMenu(
//           title: title,
//           disable: disable,
//           isExpand: isExpand,
//           onExpansionChanged: (val) {
//             isExpand = !isExpand;
//             setState(() {});
//           },
//           childrenHeader: (onTap) => Column(
//             children: [
//               buildDropBoxChoicePart<DoctorTeamDetailModel>(
//                 models: items,
//                 cbID: (e) => e.id ?? "",
//                 cbName: (e) => e.groupName ?? "",
//                 cbSelected: (e) => e.id == selectedDoctorTeamModelTmp?.id,
//                 onChanged: (List<ChoiceBoxModel> value) {
//                   // debugPrint("selectedModels: $value");
//                   if (value.isEmpty) {
//                     selectedDoctorTeamModelTmp = null;
//                     return;
//                   }
//                   selectedDoctorTeamModelTmp = value.first.data;
//                   selectedDoctorModelTmp = null;
//                   setState(() {});
//                 },
//               ),
//             ],
//           ),
//           children: []);
//     });
//   }
//
//   /// 筛选弹窗 医生选择
//   Widget buildDropBoxDoctorChoice({
//     String title = "医生",
//     bool isExpand = false,
//     int collapseCount = 6,
//   }) {
//     // return const SizedBox();
//
//     final models = doctorModels;
//     if (models.isEmpty) {
//       return const SizedBox();
//     }
//     final disable = (models.length <= collapseCount);
//
//     return StatefulBuilder(builder: (context, setState1) {
//       final items = isExpand ? models : models.take(collapseCount).toList();
//
//       return buildExpandMenu(
//         title: title,
//         disable: disable,
//         isExpand: isExpand,
//         onExpansionChanged: (val) {
//           isExpand = !isExpand;
//           setState(() {});
//         },
//         childrenHeader: (onTap) => Column(
//           children: [
//             buildDropBoxChoicePart<UserDetailModel>(
//               models: items,
//               cbID: (e) => e.id ?? "",
//               cbName: (e) => e.name ?? e.realName ?? "",
//               cbSelected: (e) => e.id == selectedDoctorModelTmp?.id,
//               onChanged: (List<ChoiceBoxModel> value) {
//                 // debugPrint("selectedModels: $value");
//                 if (value.isEmpty) {
//                   selectedDoctorModelTmp = null;
//                   return;
//                 }
//                 selectedDoctorModelTmp = value.first.data;
//                 selectedDoctorTeamModelTmp = null;
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         children: [],
//       );
//     });
//   }
//
//   /// 筛选弹窗 疾病组选择
//   Widget buildDropBoxDiseaseChoice({
//     String title = "分组",
//     bool isExpand = false,
//     int collapseCount = 6,
//   }) {
//     final models = diseaseModels;
//     if (models.isEmpty) {
//       return const SizedBox();
//     }
//     final disable = (models.length <= collapseCount);
//
//     return StatefulBuilder(builder: (context, setState) {
//       final items = isExpand ? models : models.take(collapseCount).toList();
//
//       return buildExpandMenu(
//         title: title,
//         disable: disable,
//         isExpand: isExpand,
//         onExpansionChanged: (val) {
//           isExpand = !isExpand;
//           setState(() {});
//         },
//         childrenHeader: (onTap) => Column(
//           children: [
//             buildDropBoxChoicePart<DiseaseTypesDetailModel>(
//               models: items,
//               cbID: (e) => e.id ?? "",
//               cbName: (e) => e.name ?? "",
//               cbSelected: (e) => e.id == selectedDiseaseModelTmp?.id,
//               onChanged: (List<ChoiceBoxModel> value) {
//                 // debugPrint("selectedModels: $value");
//                 if (value.isEmpty) {
//                   selectedDiseaseModelTmp = null;
//                   return;
//                 }
//                 selectedDiseaseModelTmp = value.first.data;
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         children: [],
//       );
//     });
//   }
//
//   /// 筛选弹窗 标签选择
//   Widget buildDropBoxTagChoice({
//     String title = "标签",
//     bool isExpand = false,
//     int collapseCount = 6,
//     Color btnColor = const Color(0xffFF7E6E),
//   }) {
//     final models = tagModels;
//     if (models.isEmpty) {
//       return const SizedBox();
//     }
//     final disable = (models.length <= collapseCount);
//
//     return StatefulBuilder(builder: (context, setState) {
//       final items = isExpand ? models : models.take(collapseCount).toList();
//
//       return buildExpandMenu(
//         title: title,
//         disable: disable,
//         isExpand: isExpand,
//         onExpansionChanged: (val) {
//           isExpand = !isExpand;
//           setState(() {});
//         },
//         childrenHeader: (onTap) => Column(
//           children: [
//             buildDropBoxChoicePart<TagDetailModel>(
//               models: items,
//               cbID: (e) => e.id ?? "",
//               cbName: (e) => e.name ?? "",
//               cbSelected: (e) => e.id == selectedTagModelTmp?.id,
//               onChanged: (List<ChoiceBoxModel> value) {
//                 // debugPrint("selectedModels: $value");
//                 if (value.isEmpty) {
//                   selectedTagModelTmp = null;
//                   return;
//                 }
//                 selectedTagModelTmp = value.first.data;
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         children: [],
//       );
//     });
//   }
//
//   /// 筛选弹窗 选择子菜单
//   Widget buildDropBoxChoicePart<T>({
//     required List<T> models,
//     required String Function(T) cbID,
//     required String Function(T) cbName,
//     required bool Function(T) cbSelected,
//     ValueChanged<List<ChoiceBoxModel>>? onChanged,
//   }) {
//     return NChoiceBox(
//       isSingle: true,
//       itemColor: Colors.transparent,
//       // wrapAlignment: WrapAlignment.spaceBetween,
//       items: models
//           .map((e) => ChoiceBoxModel<T>(
//         id: cbID(e),
//         title: cbName(e),
//         isSelected: cbSelected(e),
//         data: e,
//       ))
//           .toList(),
//       onChanged: onChanged ??
//               (List<ChoiceBoxModel> value) {
//             debugPrint("selectedModels: $value");
//           },
//     );
//   }
//
//   Widget buildDvider() {
//     return Container(
//       height: 8,
//       margin: const EdgeInsets.only(top: 15),
//       color: lineColor[30],
//     );
//   }
//
//   /// 筛选弹窗 取消确认菜单
//   Widget buildDropBoxButtonBar() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(8),
//         bottomRight: Radius.circular(8),
//       ),
//       child: NFooterButtonBar(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           border: Border(
//               top: BorderSide(color: Color(0xffE5E5E5), width: 0.5)
//           ),
//         ),
//         cancelTitle: "重置",
//         confirmTitle: "确定",
//         // hideCancel: true,
//         onCancel: () {
//           // Navigator.of(context).pop();
//           handleResetFilter();
//         },
//         onConfirm: () {
//           // Navigator.of(context).pop();
//           handleConfirmFilter();
//         },
//       ),
//     );
//
//     // return NCancelAndConfirmBar(
//     //   cancelTitle: "重置",
//     //   bottomLeftRadius: const Radius.circular(8),
//     //   bottomRightRadius: const Radius.circular(8),
//     //   onCancel: () {
//     //     // Navigator.of(context).pop();
//     //     handleResetFilter();
//     //   },
//     //   onConfirm: () {
//     //     // Navigator.of(context).pop();
//     //     handleConfirmFilter();
//     //   },
//     // );
//   }
//
//
//   Widget buildExpandMenu({
//     required String title,
//     List<Widget>? children,
//     bool isExpand = true,
//     ValueChanged<bool>? onExpansionChanged,
//     Color color = const Color(0xff737373),
//     bool disable = false,
//     ExpansionWidgetBuilder? header,
//     ExpansionWidgetBuilder? childrenHeader,
//     ExpansionWidgetBuilder? childrenFooter,
//   }) {
//     return Theme(
//       data: ThemeData(
//         dividerColor: Colors.transparent,
//       ),
//       child: EnhanceExpansionTile(
//         header: header,
//         childrenHeader: childrenHeader,
//         childrenFooter: childrenFooter,
//         tilePadding: const EdgeInsets.symmetric(horizontal: 0),
//         // leading: Icon(Icons.ac_unit),
//         // trailing: OutlinedButton.icon(
//         //     onPressed: (){
//         //       debugPrint("arrow");
//         //     },
//         //     icon: Icon(Icons.expand_more),
//         //     label: Text("展开"),
//         //   style: OutlinedButton.styleFrom(
//         //     shape: StadiumBorder()
//         //   ),
//         // ),
//         trailing: buildExpandMenuTrailing(
//           isExpand: isExpand,
//           color: color,
//           borderColor: color.withOpacity(0.2),
//           hide: disable,
//         ),
//         collapsedTextColor: fontColor,
//         textColor: fontColor,
//         iconColor: color,
//         collapsedIconColor: color,
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: weChatTitleColor,
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         initiallyExpanded: disable ? false : isExpand,
//         onExpansionChanged: onExpansionChanged,
//         children: children ?? <Widget>[Container()],
//       ),
//     );
//   }
//
//   buildExpandMenuTrailing({
//     bool isExpand = true,
//     Color color = Colors.blueAccent,
//     Color borderColor = Colors.blueAccent,
//     bool hide = false,
//   }) {
//     if (hide) {
//       return const SizedBox();
//     }
//
//     final tuple = isExpand ? ("收起", "icon_arrow_up.png") : ("展开", "icon_arrow_down.png");
//     // final icon = Icon(
//     //   isExpand ? Icons.expand_less : Icons.expand_more,
//     //   size: 24,
//     //   color: color,
//     // );
//
//     return Container(
//       padding: const EdgeInsets.only(left: 12, right: 6, top: 4, bottom: 4),
//       decoration: const BoxDecoration(
//         // color: Colors.red,
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         // border: Border.all(color: borderColor),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             tuple.$1,
//             style: TextStyle(color: color, fontSize: 12),
//           ),
//           const SizedBox(
//             width: 4,
//           ),
//           Image(
//             image: tuple.$2.toAssetImage(),
//             width: 10,
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// 重置过滤参数
//   handleResetFilter() {
//     closeKeyboard();
//
//     selectedDoctorTeamModel = selectedDoctorTeamModelTmp = null;
//     selectedDoctorModel = selectedDoctorModelTmp = null;
//     selectedDiseaseModel = selectedDiseaseModelTmp = null;
//     selectedTagModel = selectedTagModelTmp = null;
//
//     widget.onCancel?.call();
//   }
//
//   /// 确定过滤参数
//   handleConfirmFilter() {
//     closeKeyboard();
//
//     selectedDoctorTeamModel = selectedDoctorTeamModelTmp;
//     selectedDoctorModel = selectedDoctorModelTmp;
//     selectedDiseaseModel = selectedDiseaseModelTmp;
//     selectedTagModel = selectedTagModelTmp;
//
//     widget.onConfirm(selectedDoctorTeamModel, selectedDoctorModel, selectedDiseaseModel, selectedTagModel);
//   }
//
//   closeKeyboard() {
//     FocusManager.instance.primaryFocus?.unfocus();
//   }
//
//
// }