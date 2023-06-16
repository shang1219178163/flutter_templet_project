

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_cancell_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_pop_view_box.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:flutter_templet_project/model/selected_model.dart';
import 'package:flutter_templet_project/uti/app_uti.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';
import 'package:tuple/tuple.dart';

class PopViewChoiceChipDemo extends StatefulWidget {

  PopViewChoiceChipDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _PopViewChoiceChipDemoState createState() => _PopViewChoiceChipDemoState();
}

class _PopViewChoiceChipDemoState extends State<PopViewChoiceChipDemo> {
  List<int> nums = List<int>.generate(49, (index) => index);

  late final funcMap = <String, Function>{
    "NChoicBox 弹窗": showPopViewBox,
    "方法 弹窗": clickUpdateTags,
  };

  late var items = <Tuple3<String, String, String>>[
    Tuple3("icon_section.png", "分组", "userTypesDesc"),
    Tuple3("icon_remark.png", "标签", "tagsDesc"),
    Tuple3("icon_tag.png", "备注", "remark",),
  ];


  /// 分组疾病列表
  late List<SelectModel<FakeDataModel>> allItems = nums.map((e){
    return SelectModel(
      id: e.toString(),
      title: "item_$e",
      isSelected: false,
      data: FakeDataModel(
      id: e.toString(),
    ));
  }).toList();


  /// 已选择的列表(多选)
  List<SelectModel<FakeDataModel>> selectedItems = [];
  /// 临时已选择的列表(多选)
  List<SelectModel<FakeDataModel>> selectedItemsTmp = [];

  /// 已选择的列表名称
  String get selectedItemsNames{
    var result = selectedItems.map((e) => e.title ?? "-").toList();
    // debugPrint("selectDiseaseTypesNames: ${result}");
    return result.join(",");
  }

  final info = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,
        )).toList(),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: info,
                builder: (context,  value, child){

                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Text(value)
                  );
                }
              ),
              Wrap(
                runSpacing: 12,
                spacing: 16,
                children: funcMap.keys.map((e) => TextButton(
                  onPressed: () => funcMap[e]?.call(),
                  child: Text(e),
                )).toList(),
              ),
            ],
          )
        ],
      )
    );
  }

  onPressed(){
    clickUpdateTags();
    // showPopViewBox(e: items[0]);
  }

  showPopViewBox({
    bool isMuti = true,
    Alignment alignment = Alignment.center,
  }) {
    final box = NPopViewBox(
      // alignment: Alignment.bottomCenter,
      title: Text("选择",
        style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff333333),
      ),),
      onCancell: (){
        handleItems(selectedItems: selectedItems);
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        selectedItems = selectedItemsTmp;
        info.value = selectedItemsNames;

        // final response = await requestUpdateSections();
        // if (response is! Map<String, dynamic> || response['code'] != 'OK' || response['result'] != true) {
        //   BrunoUti.showInfoToast(RequestMsg.networkErrorMsg);
        //   return;
        // }

        // handleDiseaseTypes(selectedItems: selectDiseaseTypes);
        // map[e.item3] = selectDiseaseTypesNames;
        // debugPrint("selectDiseaseTypesNames: ${map[e.item3]}");
        // debugPrint("map[e.item3]: ${map[e.item3]}");
        setState(() {});
      },
      contentChildBuilder: (context, setState1) {
        return Wrap(
          runSpacing: 12,
          spacing: 16,
          alignment: WrapAlignment.start,
          children: allItems.map((e) => Material(
            color: Colors.transparent,
            child: ChoiceChip(
              side: BorderSide(color: Color(0xfff3f3f3)),
              label: Text(e.title ?? "-"),
              labelStyle: TextStyle(
                color: e.isSelected == true ? Colors.white : fontColor,
              ),
              // padding: EdgeInsets.only(left: 15, right: 15),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: e.isSelected == true,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: bgColor[10],
              onSelected: (bool selected) {
                for (final element in allItems) {
                  if (element.data?.id == e.data?.id) {
                    element.isSelected = selected;
                  } else {
                    if (isMuti == false) {
                      element.isSelected = false;//单选
                    }
                  }
                }

                selectedItemsTmp = allItems.where((e) => e.isSelected == true).toList();
                setState1(() {});
                // debugPrint("${e.toString()}");
              },
            ),)).toList(),
        );
      }
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'barrierLabel',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        // return Dialog(
        //   backgroundColor: Colors.black.withOpacity(0.01),
        //   insetPadding: EdgeInsets.zero,
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.of(context).pop();
        //       // AppUti.removeInputFocus();
        //     },
        //     child: box,
        //   ),
        // );
        return Material(
          color: Colors.black.withOpacity(0.01),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              // AppUti.removeInputFocus();
            },
            child: Container(
              color: Colors.black.withOpacity(0.05),
              child: Align(
                alignment: alignment,
                child: box,
              )
            ),
          ),
        );
        return box;
      }
    );
  }

  clickUpdateTags({
    bool isSingle = false,
    WrapAlignment alignment = WrapAlignment.start,
  }) {
    return showPopView(
      title: "选择",
      onCancell: (){
        handleItems(selectedItems: selectedItems);
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        selectedItems = selectedItemsTmp;
        info.value = selectedItemsNames;

        // final response = await requestUpdateSections();
        // if (response is! Map<String, dynamic> || response['code'] != 'OK' || response['result'] != true) {
        //   BrunoUti.showInfoToast(RequestMsg.networkErrorMsg);
        //   return;
        // }

        // handleDiseaseTypes(selectedItems: selectDiseaseTypes);
        // map[e.item3] = selectDiseaseTypesNames;
        // debugPrint("selectDiseaseTypesNames: ${map[e.item3]}");
        // debugPrint("map[e.item3]: ${map[e.item3]}");
        setState(() {});
      },
      contentChildBuilder: (context, setState1) {
        return Wrap(
          runSpacing: 12,
          spacing: 16,
          alignment: alignment,
          children: allItems.map((e) => Material(
            color: Colors.transparent,
            child: ChoiceChip(
              side: BorderSide(color: Color(0xfff3f3f3)),
              label: Text(e.title ?? "-"),
              labelStyle: TextStyle(
                color: e.isSelected == true ? Colors.white : fontColor,
              ),
              // padding: EdgeInsets.only(left: 15, right: 15),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: e.isSelected == true,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: bgColor[10],
              onSelected: (bool selected) {
                for (final element in allItems) {
                  if (element.id == e.id) {
                    element.isSelected = selected;
                  } else {
                    if (isSingle) {
                      element.isSelected = false;//单选
                    }
                  }
                }

                selectedItemsTmp = allItems.where((e) => e.isSelected == true).toList();
                // selectDiseaseTypes = diseaseTypeshere((e) => e.isSelected == true).toList();
                setState1(() {});
                // debugPrint("${e.toString()}");
              },
            ),)).toList(),
        );
      }
    );
  }

  /// 弹窗封装
  showPopView({
    required String title,
    Widget? content,
    Widget? header,
    Widget? footer,
    Color divderColor = const Color(0xffF3F3F3),
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 38),
    Radius radius = const Radius.circular(8),
    Alignment alignment = Alignment.center,
    VoidCallback? onCancell,
    VoidCallback? onConfirm,
    double contentMaxHeight = 500,
    double contentMinHeight = 150,
    double buttonBarHeight = 48,
    EdgeInsets contentPadding = const EdgeInsets.all(20),
    StatefulWidgetBuilder? contentChildBuilder,
  }) {

    final scrollController = ScrollController();

    final defaultHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Text(title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: fontColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Material(
            child: IconButton(
              onPressed: onCancell ?? (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.clear,
                size: 20,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );

    final defaultContent = StatefulBuilder(
      builder: (context, setState) {

        return Scrollbar(
          controller: scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: contentMaxHeight - buttonBarHeight,
              minHeight: contentMinHeight,
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: contentPadding,
                child: contentChildBuilder?.call(context, setState),
              )
            ),
          ),
        );
      }
    );

    final defaultFooter = NCancellAndConfirmBar(
      height: buttonBarHeight,
      confirmBgColor: Theme.of(context).primaryColor,
      bottomLeftRadius: radius,
      bottomRightRadius: radius,
      onCancell: onCancell ?? (){
        Navigator.of(context).pop();
      },
      onConfirm: onConfirm ?? () {
        Navigator.of(context).pop();
      },
    );

    final child = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(radius),
      ),
      // constraints: BoxConstraints(
      //   maxHeight: contentMaxHeight,
      //   minHeight: contentMinHeight,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          header ?? defaultHeader,
          Divider(height: 1, color: divderColor,),
          content ?? defaultContent,
          footer ?? defaultFooter,
        ],
      ),
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'barrierLabel',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {

        return Align(
          alignment: alignment,
          child: child,
        );
      }
    );
  }

  /// 处理疾病分组选中数据
  handleItems({
    required List<SelectModel<FakeDataModel>> selectedItems,
  }) {
    final ids = selectedItems.map((e) => e.id).toList();
    for (final element in allItems) {
      element.isSelected = ids.contains(element.id);
    }
  }
}

