

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_pop_view_box.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:flutter_templet_project/model/selected_model.dart';
import 'package:flutter_templet_project/uti/app_util.dart';
import 'package:flutter_templet_project/uti/color_util.dart';
import 'package:tuple/tuple.dart';

class DialogChoiceChipDemo extends StatefulWidget {

  DialogChoiceChipDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _DialogChoiceChipDemoState createState() => _DialogChoiceChipDemoState();
}

class _DialogChoiceChipDemoState extends State<DialogChoiceChipDemo> {
  List<int> nums = List<int>.generate(49, (index) => index);

  late final funcMap = <String, Function>{
    "NChoicBox 弹窗": showPopViewBox,
    "方法弹窗": clickUpdateTags,
    "弹窗高度固定": clickAlertInset,
    "弹窗高度自适应": clickAlertMaxHeight,
  };

  late var items = <Tuple3<String, String, String>>[
    Tuple3("icon_section.png", "分组", "userTypesDesc"),
    Tuple3("icon_remark.png", "标签", "tagsDesc"),
    Tuple3("icon_tag.png", "备注", "remark",),
  ];


  /// 分组疾病列表
  late List<SelectModel<FakeDataModel>> tags = nums.map((e){
    return SelectModel(
      id: e.toString(),
      name: "标签_$e",
      isSelected: false,
      data: FakeDataModel(
      id: e.toString(),
    ));
  }).toList();


  /// 已选择的列表(多选)
  List<SelectModel<FakeDataModel>> selectedTags = [];
  /// 临时已选择的列表(多选)
  List<SelectModel<FakeDataModel>> selectedTagsTmp = [];

  /// 已选择的列表名称
  List<String> get selectedTagsNames => selectedTags.map((e) => e.name ?? "-").toList();


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
        selectedTagsTmp = selectedTags;
        handleItems(selectedItems: selectedTags);
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        selectedTags = selectedTagsTmp;
        info.value = selectedTagsNames.join(",");

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
          children: tags.map((e) => Material(
            color: Colors.transparent,
            child: ChoiceChip(
              side: BorderSide(color: Color(0xfff3f3f3)),
              label: Text(e.name ?? "-"),
              labelStyle: TextStyle(
                color: e.isSelected == true ? Colors.white : fontColor,
              ),
              // padding: EdgeInsets.only(left: 15, right: 15),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: e.isSelected == true,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: bgColor[10],
              onSelected: (bool selected) {
                for (final element in tags) {
                  if (element.data?.id == e.data?.id) {
                    element.isSelected = selected;
                  } else {
                    if (isMuti == false) {
                      element.isSelected = false;//单选
                    }
                  }
                }

                selectedTagsTmp = tags.where((e) => e.isSelected == true).toList();
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
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.01),
          insetPadding: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              // AppUti.removeInputFocus();
            },
            child: box,
          ),
        );
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
        handleItems(selectedItems: selectedTags);
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        selectedTags = selectedTagsTmp;
        info.value = selectedTagsNames.join(",");

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
          children: tags.map((e) => Material(
            color: Colors.transparent,
            child: ChoiceChip(
              side: BorderSide(color: Color(0xfff3f3f3)),
              label: Text(e.name ?? "-"),
              labelStyle: TextStyle(
                color: e.isSelected == true ? Colors.white : fontColor,
              ),
              // padding: EdgeInsets.only(left: 15, right: 15),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: e.isSelected == true,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: bgColor[10],
              onSelected: (bool selected) {
                for (final element in tags) {
                  if (element.id == e.id) {
                    element.isSelected = selected;
                  } else {
                    if (isSingle) {
                      element.isSelected = false;//单选
                    }
                  }
                }

                selectedTagsTmp = tags.where((e) => e.isSelected == true).toList();
                // selectDiseaseTypes = diseaseTypeshere((e) => e.isSelected == true).toList();
                setState1(() {});
                // debugPrint("${e.toString()}");
              },
            ),)).toList(),
        );
      }
    );
  }

  clickAlertInset() {
    presentAlertInset(
      header: Container(
        color: ColorExt.random,
        height: 50,
      ),
      footer: Container(
        color: ColorExt.random,
        height: 50,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 2, color: Colors.red,),
          Container(
            color: ColorExt.random,
            height: 150,
          ),
        ],
      ),
    );
  }

  clickAlertMaxHeight() {
    final isMuti = true;

    presentAlertMaxHeight(
      header: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xffe4e4e4)
            ),
          ),
        ),
        child: Text("标题",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      footer: NCancelAndConfirmBar(
        onCancel: (){
          selectedTagsTmp = selectedTags;
          handleItems(selectedItems: selectedTagsTmp);
          Navigator.of(context).pop();
          debugPrint("${DateTime.now()} onCancell");

        },
        onConfirm: (){
          Navigator.of(context).pop();
          selectedTags = selectedTagsTmp;
          info.value = selectedTagsNames.join(",");
          debugPrint("${DateTime.now()} ${info.value}");
        }
      ),
      contentBuilder: (context, setState) {

        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 8.w,
            spacing: 16.w,
            children: tags.map((e) => ChoiceChip(
              label: Text(e.name ?? ""),
              labelStyle: TextStyle(
                color: e.isSelected == true ? Colors.white : Color(0xff181818),
              ),
              // padding: EdgeInsets.only(left: 15, right: 15),
              selected: e.isSelected == true,
              selectedColor: context.primaryColor,
              onSelected: (selected) {
                for (var element in tags) {
                  if (element.id == e.id) {
                    element.isSelected = selected;
                  } else {
                    if (isMuti == false) {
                      element.isSelected = false;
                    }
                  }
                }
                selectedTagsTmp = tags.where((e) => e.isSelected == true).toList();
                setState((){});
              },
            )).toList(),
          ),
        );
      }
    );
  }

  /// 固定高度弹窗
  presentAlertInset({
    required Widget content,
    Widget? header,
    Widget? footer,
  }) {
    return showGeneralDialog(
      context: context,
      // barrierDismissible: true,
      // barrierColor: Colors.yellowAccent,
      barrierLabel: 'showGeneralDialog',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {

        return Material(
          color: Colors.black.withOpacity(0.05),
          child: InkWell(
            onTap: () {
              debugPrint("barrier dismiss");
              Navigator.of(context).pop();
            },
            child: Dialog(
              // backgroundColor: Colors.red,
              insetPadding: EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 100,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (header != null) header,
                  Expanded(
                    child: content,
                  ),
                  if (footer != null) footer,
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  /// 内容自适应高度
  presentAlertMaxHeight({
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8)),
    EdgeInsets contentPadding = const EdgeInsets.all(0),
    required StatefulWidgetBuilder? contentBuilder,
    double maxHeight = 400,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 50,
      vertical: 100,
    ),
    Widget? header,
    Widget? footer,
    VoidCallback? onCancel,
  }) {
    final scrollController = ScrollController();

    final defaultContent = StatefulBuilder(
      builder: (context, setState) {

        return Scrollbar(
          controller: scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              minHeight: 100,
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: contentPadding,
                child: contentBuilder?.call(context, setState),
              )
            ),
          ),
        );
      }
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      // barrierColor: Colors.yellowAccent,
      barrierLabel: 'showGeneralDialog',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {

        return Material(
          color: Colors.black.withOpacity(0.05),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 50),
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            // ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (header != null) header,
                    Flexible(child: defaultContent),
                    if (footer != null) footer,
                  ],
                ),
              ),
            ),
          ),
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

    final defaultFooter = NCancelAndConfirmBar(
      height: buttonBarHeight,
      confirmBgColor: Theme.of(context).primaryColor,
      bottomLeftRadius: radius,
      bottomRightRadius: radius,
      onCancel: onCancell ?? (){
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
    for (final element in tags) {
      element.isSelected = ids.contains(element.id);
    }
  }
}

