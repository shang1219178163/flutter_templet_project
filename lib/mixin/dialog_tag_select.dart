

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/mixin/dialog_mixin.dart';
import 'package:flutter_templet_project/model/selected_model.dart';

// 定义数据源
// TagsRootModel? tagsRootModel = CacheService().tagsRootModel;

// /// 标签列表
// List<TagDetailModel> get tags => tagsRootModel?.result ?? [];

// /// 选择的标签
// List<TagDetailModel> selectTags = [];

// /// 临时选择的标签病列表
// List<TagDetailModel> selectTagsTmp = [];

// /// 已选择的标签
// String get selectTagNames {
//   List<String> result = selectTags.map((e) => e.name ?? "-").toList();
//   // debugPrint("selectDiseaseTypesNames: ${result}");
//   return result.join();
// }

// 使用:
// DialogPaticentTagSelect().present(
//   context: context,
//   publicUserId: patientModel?.publicUserId,
//   title: e.item2,
//   tags: tags,
//   selectTagsTmp: selectTagsTmp,
//   selectTags: selectTags,
//   onCancel: (){
//
//   },
//   onConfirm: (List<TagDetailModel> selectedItems){
//     selectTags = selectedItems;
//     ...
//   },
// );



/// 标签选择弹窗工具类
class DialogTagSelect with DialogMixin {

  /// 展示标签弹窗
  present<T>({
    required BuildContext context,
    /// 病人id
    required String? userId,
    /// 标题
    required String title,
    /// 标签列表
    required List<SelectModel<T>> tags,
    /// 临时选择的标签病列表
    required List<SelectModel<T>> selectTagsTmp,
    /// 选择的标签
    required List<SelectModel<T>> selectTags,
    /// 取消回调
    required VoidCallback onCancel,
    /// 确定回调
    required ValueChanged<List<SelectModel<T>>> onConfirm,
    bool isMuti = true,
  }) {
    return presentDialog(
      context: context,
      title: title,
      onCancel: () {
        selectTagsTmp = selectTags;
        final ids = selectTagsTmp.map((e) => e.id).toList();
        for (var element in tags) {
          element.isSelected = ids.contains(element.id);
        }

        Navigator.of(context).pop();
        onCancel();
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        selectTags = selectTagsTmp;
        // final response = await requestUpdateTag(
        //     selectTags: selectTags,
        //     uerId: userId,
        // );
        // if (response is! Map<String, dynamic> ||
        //     response['code'] != 'OK' ||
        //     response['result'] != true) {
        //   // BrunoUtil.showInfoToast(RequestMsg.networkErrorMsg);
        //   return;
        // }

        final ids = selectTags.map((e) => e.id).toList();
        for (var element in tags) {
          element.isSelected = ids.contains(element.id);
        }

        onConfirm(selectTags);
      },
      contentChildBuilder: (context, setState1) {
        return Wrap(
          runSpacing: 8.w,
          spacing: 16.w,
          children: tags
              .map(
                (e) => ChoiceChip(
              side: e.isSelected == true
                  ? const BorderSide(color: Colors.transparent)
                  : const BorderSide(color: Color(0xffF3F3F3)),
              label: Text(e.title ?? "-"),
              labelStyle: TextStyle(
                color: e.isSelected == true ? Colors.white : Color(0xff181818),
              ),
              // padding: EdgeInsets.only(left: 15, right: 15),
              // selected: (e == selectTagModel),
              selected: e.isSelected == true,
              selectedColor: context.primaryColor,
              backgroundColor: Colors.white,
              onSelected: (bool selected) {
                for (var element in tags) {
                  if (element.id == e.id) {
                    element.isSelected = selected;
                  } else {
                    if (isMuti == false) {
                      element.isSelected = false;
                    }
                  }
                }
                selectTagsTmp = tags.where((e) => e.isSelected == true).toList();
                setState1(() {});
              },
            ),
          )
              .toList(),
        );
      },
    );
  }

  /// 设置标签(新增或者更新)
  Future<Map<String, dynamic>?> requestUpdateTag({
    required List<SelectModel> selectTags,
    required String? uerId,
  }) async {
    // 如果 选择为空走清除接口;选择不为空,更新;

    return {};
  }
}


class TagDetailModel {
  TagDetailModel({
    this.id,
    this.name,
    this.color,
    this.isSelected = false,
  });

  String? id;
  String? name;
  String? color;
  /// 非接口返回字段
  bool? isSelected = false;

  TagDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? json['tagsId'];
    name = json['name'] ?? json['tagsName'];
    color = json['color'] ?? json['tagsColor'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['isSelected'] = isSelected;
    return data;
  }
}