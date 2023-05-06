

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/basicWidget/n_cancell_and_confirm_bar.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
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

  late var items = <Tuple3<String, String, String>>[
    Tuple3("icon_section.png", "分组", "userDiseaseTypesDesc"),
    Tuple3("icon_remark.png", "标签", "tagsDesc"),
    Tuple3("icon_tag.png", "备注", "remark",),
  ];

  int? _value = 1;
  final _values = <String>[];


  /// 分组疾病列表
  late List<SelectedModel<FakeDataModel>> diseaseTypes = nums.map((e){
    return SelectedModel(
      name: "item_$e",
      isSelected: false,
      data: FakeDataModel(
      id: e.toString(),
    ));
  }).toList();


  /// 已选择的列表(多选)
  List<SelectedModel<FakeDataModel>> selectedItems = [];
  /// 临时已选择的列表(多选)
  List<SelectedModel<FakeDataModel>> selectedItemsTmp = [];

  /// 已选择的列表名称
  String get selectedItemsNames{
    var result = selectedItems.map((e) => e.name ?? "-").toList();
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
      body: ValueListenableBuilder<String>(
         valueListenable: info,
         builder: (context,  value, child){

            return Text(value);
          }
      ),
    );
  }

  onPressed(){
    clickUpdateSections(e: items[0]);
  }

  clickUpdateSections({
    required Tuple3<String, String, String> e,
    bool isSingle = false,
    WrapAlignment alignment = WrapAlignment.start,
  }) {
    return showPopViewSections(
        title: e.item2,
        onCancell: (){
          handleDiseaseTypes(selectedItems: selectedItems);
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
        childBuilder: (context, setState1) {
          return Wrap(
            runSpacing: 12,
            spacing: 16,
            alignment: alignment,
            children: diseaseTypes.map((e) => Material(
            child: ChoiceChip(
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
                for (final element in diseaseTypes) {
                  if (element.data.id == e.data.id) {
                    element.isSelected = selected;
                  } else {
                    if (isSingle) {
                      element.isSelected = false;//单选
                    }
                  }
                }

                selectedItemsTmp = diseaseTypes.where((e) => e.isSelected == true).toList();
                // selectDiseaseTypes = diseaseTypeshere((e) => e.isSelected == true).toList();
                setState1(() {});
                // debugPrint("${e.toString()}");
              },
            ),)).toList(),
          );
        }
    );
  }

  showPopViewSections({
    required String title,
    VoidCallback? onCancell,
    VoidCallback? onConfirm,
    StatefulWidgetBuilder? childBuilder,
  }) {
    var titles = List<int>.generate(24, (index) => index);

    showPopView(
      title: title,
      buttonBarHeight: 48,
      onCancell: onCancell,
      onConfirm: onConfirm,
      content: StatefulBuilder(
        builder: (context, setState) {

          final content = Padding(
            padding: EdgeInsets.all(20),
            child: childBuilder?.call(context, setState) ?? Wrap(
              // runSpacing: 16,
              spacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: titles.map((e) => Material(
                child: ChoiceChip(
                label: Text('Choice_$e'),
                // padding: EdgeInsets.only(left: 15, right: 15),
                selected: _value == e,
                selectedColor: primary,
                backgroundColor: bgColor.withOpacity(0.1),
                onSelected: (bool selected) {
                  _value = selected ? e : null;
                  setState(() {});
                  debugPrint("$_value");
                },
              )),).toList(),
            ),
          );
          // return content;
          return Scrollbar(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 400 - 48,
                minHeight: 200,
              ),
              child: SingleChildScrollView(child: content),
            ),
          );
        }
      )
    );

  }

  showPopView({
    required String title,
    required Widget content,
    double horizontal = 38,
    double maxHeight = 500,
    double minHeight = 200,
    double buttonBarHeight = 48,
    VoidCallback? onCancell,
    VoidCallback? onConfirm,
    Radius radius = const Radius.circular(8)
  }) {
    final widget = Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(radius),
      ),
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear,
                      size: 20,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 1, color: lineColor,),
          content,
          NCancellAndConfirmBar(
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
          ),
        ],
      ),
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'barrierLabel',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(child: widget);
      }
    );
  }

  /// 处理疾病分组选中数据
  handleDiseaseTypes({
    required List<SelectedModel<FakeDataModel>> selectedItems,
  }) {
    final ids = selectedItems.map((e) => e.data.id).toList();
    for (final element in diseaseTypes) {
      element.isSelected = ids.contains(element.data.id);
    }
  }
}


class SelectedModel<T> {
  String? name;
  bool? isSelected;

  T data;

  SelectedModel({
    this.name,
    required this.data,
    this.isSelected = false,
  });
}

class FakeDataModel {
  String? id;
  String? name;
  String? code;
  String? createBy;

  /// 非接口返回字段
  bool? isSelected;

  FakeDataModel({
    this.id,
    this.name,
    this.code,
    this.createBy,
    this.isSelected = false,
  });

  FakeDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? json['diseaseTypeId'];
    name = json['name'] ?? json['diseaseTypeName'];
    code = json['code'] ?? json['diseaseTypeCode'];
    createBy = json['createBy'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['createBy'] = createBy;
    data['isSelected'] = isSelected;
    return data;
  }
}