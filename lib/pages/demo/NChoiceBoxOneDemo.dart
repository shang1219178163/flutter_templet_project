import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box_one.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/mixin/dialog_mixin.dart';
import 'package:flutter_templet_project/model/order_model.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:tuple/tuple.dart';

class NChoiceBoxOneDemo extends StatefulWidget {
  NChoiceBoxOneDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NChoiceBoxOneDemo> createState() => _NChoiceBoxOneDemoState();
}

class _NChoiceBoxOneDemoState extends State<NChoiceBoxOneDemo> {
  final _scrollController = ScrollController();

  final rpItems = <Tuple3<String, String, String>>[
    Tuple3('西药/中成药/特医', RpType.WESTERN_MEDICINE.name, "+添加药品"),
    Tuple3('医疗器械', RpType.MEDICAL_APPLIANCE.name, "+添加器械"),
    Tuple3('检测检验', RpType.JC.name, "+添加检测"),
    Tuple3('中药', RpType.CHINESE_MEDICINE.name, "+添加药品"),
  ];

  late final rpItemCurrent = ValueNotifier(rpItems[0]);

  final canChange = false;

  final tags = List.generate(
      10,
      (i) => TagDetailModel(
            id: i.toString(),
            name: "标签$i${"元" * i}",
          )).toList();
  List<TagDetailModel> selectedTags = [];

  final orders = List.generate(10, (i) {
    final model = OrderModel(
      id: i,
      name: "订单$i",
      price: IntExt.random(max: 99999, min: 100).toDouble(),
    );
    model.isSelected = true;
    return model;
  }).toList();

  List<OrderModel> selectedOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    var isSingle = false;
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            buildRpTypeBox(),
            NSectionBox(
              title: "标签选择",
              child: buildChoiceBox(
                models: tags,
                isSingle: isSingle,
                idCb: (e) => e.id ?? "",
                titleCb: (e) => e.name ?? "",
                selectedCb: (e) => selectedTags.map((e) => e.id).contains(e.id),
                onChanged: (list) {
                  selectedTags = list;
                  debugPrint("重置 selectedTagModelsTmp: ${selectedTags.map((e) => e.name).toList()}");
                },
                // itemBuilder: (e, isSelected) {
                //   return buildItem(
                //     e: e,
                //     isSelected: isSelected,
                //     titleCb: (e) => e.name ?? "",
                //     primaryColor: Colors.blue,
                //   );
                // },
              ),
            ),
            NSectionBox(
              title: "人员选择",
              child: buildChoiceBox(
                models: orders,
                isSingle: isSingle,
                idCb: (e) => e.id.toString(),
                titleCb: (e) => e.name,
                selectedCb: (e) => selectedOrders.map((e) => e.id).contains(e.id),
                onChanged: (list) {
                  // DLog.d(list.map((e) => "${e.name}_${e.isSelected}"));
                  selectedOrders = list;
                  debugPrint("重置 selectedUsers: ${selectedOrders.map((e) => e.name).toList()}");
                  // setState((){});
                },
                itemBuilder: (e, isSelected) {
                  return buildItem(
                    e: e,
                    isSelected: isSelected,
                    titleCb: (e) => e.name,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 模板类型
  Widget buildRpTypeBox() {
    Widget content = NChoiceBoxOne<Tuple3<String, String, String>>(
      items: rpItems,
      selectedItem: rpItemCurrent,
      itemNameCb: (e) => e.item1,
      primaryColor: context.primaryColor,
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      styleSelected: TextStyle(
        color: context.primaryColor,
        fontSize: 15,
      ),
      // numPerRow: 0,
      // enable: false,
      canChanged: (val, onSelect) {
        if (rpItemCurrent.value == val) {
          return false;
        }
        if (val.item2 != RpType.WESTERN_MEDICINE.name) {
          return true;
        }
        if (!canChange) {
          DeleteAlert().show(
            context,
            scrollController: ScrollController(),
            title: "提示",
            message: "切换模板种类会清空已选中的药品，是否确认切换?",
            onConfirm: () async {
              Navigator.of(context).pop();
              onSelect(val, true);
            },
          );
        }
        return canChange;
      },
      // onChanged: (val) {
      //   YLog.d("onChanged: ${val.title},${val.value}");
      //   // rpItemCurrent.value = val;
      // },
    );

    return buildItemHeader(
      title: '模版类型',
      isRequired: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: content,
      ),
    );
  }

  /// 标签选择组件
  Widget buildChoiceBox<T>({
    bool isSingle = false,
    required List<T> models,
    required String Function(T) idCb,
    required String Function(T) titleCb,
    required bool Function(T) selectedCb,
    required ValueChanged<List<T>> onChanged,
    Widget? Function(T e, bool isSelected)? itemBuilder,
  }) {
    return NChoiceBox<T>(
      isSingle: isSingle,
      // itemColor: Colors.transparent,
      // wrapAlignment: WrapAlignment.spaceBetween,
      items: models
          .map((e) => ChoiceBoxModel<T>(
                id: idCb(e),
                title: titleCb(e),
                isSelected: selectedCb(e),
                data: e,
              ))
          .toList(),
      onChanged: (val) {
        final selectedItems = val.map((e) => e.data).toList();
        onChanged(selectedItems);
      },
      itemBuilder: itemBuilder,
    );
  }

  /// 子元素自定义
  Widget buildItem<T>({
    required T e,
    required bool isSelected,
    required String Function(T e) titleCb,
    Color primaryColor = Colors.green,
  }) {
    final textColor = isSelected ? primaryColor : Color(0xff737373);
    final borderColor = isSelected ? primaryColor : Colors.transparent;
    final bgColor = textColor.withOpacity(0.1);

    final title = titleCb(e);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: NText(
        title,
        fontSize: 14,
        color: textColor,
      ),
    );
  }

  //item 表头
  Widget buildItemHeader({
    EdgeInsets? padding,
    required String title,
    String? detailTitle,
    required bool isRequired,
    Widget? leading,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              leading ?? const SizedBox(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: NText(
                              title,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              // letterSpacing: 2,
                            ),
                          ),
                          SizedBox(
                              width: 10,
                              child: Offstage(
                                offstage: !isRequired,
                                child: NText(
                                  '*',
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              )),
                        ],
                      ),
                    if (detailTitle?.isNotEmpty == true)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NText(detailTitle ?? "", color: fontColorBCBFC2, fontSize: 12, fontWeight: FontWeight.w500),
                        ],
                      ),
                  ],
                ),
              ),
              trailing ?? const SizedBox(),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

/// 处方类型
enum RpType {
  /// 西药
  WESTERN_MEDICINE('西药/中成药/特医'),

  /// 中药
  CHINESE_MEDICINE('中药'),

  /// 器械
  MEDICAL_APPLIANCE('医疗器械'),

  /// 检查
  JC('检测检查'),

  /// 续方
  RENEW_RP('续方');

  const RpType(
    this.desc,
  );

  /// 当前枚举对应的 描述文字
  final String desc;
}
