


import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion_of_model.dart';
import 'package:flutter_templet_project/basicWidget/n_filter_drop_box.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/model/fake_data_model.dart';
import 'package:get_storage/get_storage.dart';

class DropBoxChoicDemo extends StatefulWidget {

  DropBoxChoicDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _DropBoxChoicDemoState createState() => _DropBoxChoicDemoState();
}

class _DropBoxChoicDemoState extends State<DropBoxChoicDemo> {
  final items = List.generate(6, (i) => i).toList();

  var searchText = "";
  late final searchtEditingController = TextEditingController();

  final _debounce = Debounce(delay: Duration(milliseconds: 500));

  // final _throttle = Throttle(milliseconds: 500);

  var showDropBox = ValueNotifier(false);

  final dropBoxController = NFilterDropBoxController();

  final _globalKey = GlobalKey();

  /// 选项组
  List<FakeDataModel> get models => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "选项_$e",
  )).toList();
  List<FakeDataModel> selectedModels = [];
  List<FakeDataModel> selectedModelsTmp = [];

  /// 标签组
  List<TagDetailModel> get tagModels => items.map((e) => TagDetailModel(
    id: "id_$e",
    name: "标签_$e",
  )).toList();
  List<TagDetailModel> selectedTagModels = [];
  List<TagDetailModel> selectedTagModelsTmp = [];

  @override
  Widget build(BuildContext context) {
    bool isSingle = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: Column(
        children: [
          buildSearchAndFilterBar(
            onToggle:  (){
              // showDropBox.value = !showDropBox.value;
              dropBoxController.onToggle();
              closeKeyboard();
            },
          ),
          Expanded(
            child: NFilterDropBox(
              controller: dropBoxController,
              sections: getDropBoxSections(isSingle: isSingle),
              onCancel: onFilterCancel,
              onReset: onFitlerReset,
              onConfirm: onFitlerConfirm,
              child: buildList(
                items: items.map((e) => "item_$e").toList(),
              ),
            )
          ),
          // Expanded(
          //   child: Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //       buildList(
          //         items: items.map((e) => "item_$e").toList(),
          //       ),
          //       ValueListenableBuilder<bool>(
          //         valueListenable: showDropBox,
          //         builder: (context, bool value, child) {
          //
          //           return Positioned(
          //             top: 0,
          //             bottom: 0,
          //             width: context.screenSize.width,
          //             child: Offstage(
          //               offstage: !value,
          //               child: buildDropBox(
          //                 controller: dropBoxController,
          //                 hasShadow: true,
          //               ),
          //             ),
          //           );
          //         }
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  buildSearchAndFilterBar({
    required VoidCallback onToggle,
}) {
    return Container(
      key: _globalKey,
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 12.w, bottom: 12.w),
      child: Row(
        children: [
          Expanded(
            child: buildSearch(cb: (value) {
              searchText = value;
              //...
            }),
          ),
          SizedBox(
            width: 8,
          ),
          buildFilterBtn(
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }

  buildSearch({
    String placeholder = "搜索",
    ValueChanged<String>? cb
  }) {
    return Container(
      height: 36.h,
      // width: 295.w,
      // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: CupertinoSearchTextField(
        controller: searchtEditingController,
        padding: EdgeInsets.zero,
        // prefixIcon: Icon(Icons.search, color: Color(0xff999999), size: 20.h,),
        prefixIcon: Image(
          image: "icon_search.png".toAssetImage(),
          width: 14.w,
          height: 14.w,
        ),
        suffixIcon: Icon(
          Icons.clear,
          color: const Color(0xff999999),
          size: 20.h,
        ),
        prefixInsets: EdgeInsets.only(left: 14.w, top: 5, bottom: 5, right: 6.w),
        // padding: EdgeInsets.only(left: 3, top: 5, bottom: 5, right: 5),
        placeholder: placeholder,
        placeholderStyle: TextStyle(fontSize: 15.sp, color: fontColor[30]),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            color: bgColor
        ),
        onChanged: (String value) {
          _debounce(() {
            debugPrint('searchText: $value');
            cb?.call(value);
          });
        },
        onSubmitted: (String value) {
          _debounce(() {
            debugPrint('onSubmitted: $value');
            cb?.call(value);
          });
        },
      ),
    );
  }

  Widget buildFilterBtn({
    String title = "筛选",
    IconData? icon = Icons.fitbit,
    Color? color = Colors.blue,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: NPair(
        icon: Icon(icon, color: color,),
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        )
      ),
    );
  }

  /// 筛选弹窗
  List<Widget> getDropBoxSections({
    bool isSingle = false,
  }) {
    final choicSections = [
      NChoiceExpansionOfModel(
        title: '标签',
        items: models,
        isSingle: isSingle,
        idCb: (e) => e.id ?? "",
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => selectedModels.map((e) => e.id).contains(e.id),
        onChanged: (list){
          ddlog("NChoiceExpansionOfModel: ${list.map((e) => "${e.name}_${e.isSelected}")}");
          selectedModelsTmp = list;
        },
      ),
      NChoiceExpansionOfModel(
        title: '标签',
        items: tagModels,
        // selectedItems: selectedTagModelsTmp,
        isSingle: isSingle,
        idCb: (e) => e.id ?? "",
        titleCb: (e) => e.name ?? "",
        selectedCb: (e) => selectedTagModels.map((e) => e.id).contains(e.id),
        onChanged: (list){
          // ddlog(list.map((e) => "${e.name}_${e.isSelected}"));
          selectedTagModelsTmp = list;
          debugPrint("重置 selectedTagModelsTmp: ${selectedTagModelsTmp.map((e) => e.name).toList()}");
          // setState((){});
        },
      ),
      // buildDropBoxTagChoic<FakeDataModel>(
      //   title: "标签",
      //   models: models,
      //   cbID: (e) => e.id ?? "",
      //   cbName: (e) => e.name ?? "",
      //   cbSelected: (e) => selectedModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
      //   onChanged: (value) {
      //     // debugPrint("selectedModels: $value");
      //     selectedModelsTmp = value.map((e) => e.data).toList();
      //     debugPrint("selectedModelsTmp: ${selectedModelsTmp.map((e) => e.name).toList()}");
      //   },
      // ),
    ];
    return choicSections;
  }

  // /// 筛选弹窗
  // Widget buildDropBox({
  //   required ScrollController? controller,
  //   bool hasShadow = false,
  //   bool isSingle = false,
  // }) {
  //   final tags = List.generate(10, (i) => TagDetailModel(
  //     id: i.toString(),
  //     name: "标签$i",
  //   )).toList();
  //   final choicSections = [
  //     NChoiceExpansionOfModel(
  //       title: '标签',
  //       items: tags,
  //       isSingle: isSingle,
  //       idCb: (e) => e.id ?? "",
  //       titleCb: (e) => e.name ?? "",
  //       onChanged: (list){
  //         ddlog(list.map((e) => "${e.name}_${e.isSelected}"));
  //       },
  //     ),
  //     buildDropBoxTagChoic<FakeDataModel>(
  //       title: "标签",
  //       models: models,
  //       cbID: (e) => e.id ?? "",
  //       cbName: (e) => e.name ?? "",
  //       cbSelected: (e) => selectedModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
  //       onChanged: (value) {
  //         // debugPrint("selectedModels: $value");
  //         selectedModelsTmp = value.map((e) => e.data!).toList();
  //         debugPrint("selectedModelsTmp: ${selectedModelsTmp.map((e) => e.name).toList()}");
  //       },
  //     ),
  //   ];
  //
  //   return NFilterDropBox(
  //     sections: choicSections,
  //     onCancel: onFilterCancel,
  //     onReset: onFitlerReset,
  //     onConfirm: onFitlerConfirm,
  //   );
  // }

  /// 筛选弹窗 标签选择
  Widget buildDropBoxTagChoic<T>({
    required String title,
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(T) cbSelected,
    ValueChanged<List<ChoiceBoxModel<T>>>? onChanged,
    bool isExpand = false,
    int collapseCount = 6,
  }) {
    final disable = (models.length <= collapseCount);

    return StatefulBuilder(
      builder: (context, setState) {

        final items = isExpand ? models : models.take(collapseCount).toList();
        return buildExpandMenu(
          disable: disable,
          isExpand: isExpand,
          onExpansionChanged: (val) {
            isExpand = !isExpand;
            setState(() {});
          },
          title: title,
          childrenHeader: (isExpanded, onTap) => Column(
            children: [
              NChoiceBox<T>(
                isSingle: true,
                itemColor: Colors.transparent,
                // wrapAlignment: WrapAlignment.spaceBetween,
                // wrapAlignment: WrapAlignment.start,
                items: items.map((e) => ChoiceBoxModel<T>(
                  id: cbID(e),
                  title: cbName(e),
                  isSelected: cbSelected(e),
                  data: e,
                )).toList(),
                onChanged: onChanged ?? (value) {
                  debugPrint("selectedModels: $value");
                },
              ),
            ],
          ),
          children: [],
        );
      }
    );
  }

  /// 筛选弹窗 取消确认菜单
  Widget buildDropBoxButtonBar() {
    return NCancelAndConfirmBar(
      cancelTitle: "重置",
      bottomRadius: Radius.circular(20),
      onCancel: () {
        // Navigator.of(context).pop();
        onFitlerReset();
      },
      onConfirm: () {
        // Navigator.of(context).pop();
        onFitlerConfirm();
      },
    );
  }

  void onFilterCancel() {
    closeDropBox();
    selectedModelsTmp = [];
    selectedTagModelsTmp = [];
    debugPrint("取消 selectedModels: ${selectedModels.map((e) => e.name).toList()}");
    debugPrint("取消 selectedTagModels: ${selectedTagModels.map((e) => e.name).toList()}");
  }

  /// 重置过滤参数
  onFitlerReset() {
    closeDropBox();

    selectedModelsTmp = [];
    selectedModels = selectedModelsTmp;

    selectedTagModelsTmp = [];
    selectedTagModels = selectedTagModelsTmp;
    debugPrint("重置 selectedModels: ${selectedModels.map((e) => e.name).toList()}");
    debugPrint("重置 selectedTagModels: ${selectedTagModels.map((e) => e.name).toList()}");
    //请求
  }
  /// 确定过滤参数
  onFitlerConfirm() {
    closeDropBox();

    selectedModels = selectedModelsTmp;
    selectedTagModels = selectedTagModelsTmp;
    debugPrint("重置 selectedModels: ${selectedModels.map((e) => e.name).toList()}");
    debugPrint("确定 selectedTagModels: ${selectedTagModels.map((e) => e.name).toList()}");
    //请求
  }


  Widget buildExpandMenu({
    required String title,
    List<Widget> children = const [],
    bool isExpand = true,
    ValueChanged<bool>? onExpansionChanged,
    Color color = const Color(0xffFF7E6E),
    bool disable = false,
    ExpansionWidgetBuilder? header,
    ExpansionWidgetBuilder? childrenHeader,
    ExpansionWidgetBuilder? childrenFooter,
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnhanceExpansionTile(
        header: header,
        childrenHeader: childrenHeader,
        childrenFooter: childrenFooter,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        // leading: Icon(Icons.ac_unit),
        // trailing: OutlinedButton.icon(
        //     onPressed: (){
        //       debugPrint("arrow");
        //     },
        //     icon: Icon(Icons.expand_more),
        //     label: Text("展开"),
        //   style: OutlinedButton.styleFrom(
        //     shape: StadiumBorder()
        //   ),
        // ),
        trailing: disable ? const SizedBox() : buildExpandMenuTrailing(
          isExpand: isExpand,
          color: color,
        ),
        collapsedTextColor: fontColor,
        textColor: fontColor,
        iconColor: color,
        collapsedIconColor: color,
        title: Text(
          title,
          style: TextStyle(
              color: fontColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
          ),
        ),
        initiallyExpanded: disable ? false : isExpand,
        onExpansionChanged: onExpansionChanged,
        children: children,
      ),
    );
  }

  buildExpandMenuTrailing({
    bool isExpand = true,
    Color color = Colors.blueAccent,
  }) {
    final title = isExpand ? "收起" : "展开";
    final icon = isExpand
        ? Icon(Icons.expand_less, size: 24, color: color,)
        : Icon(Icons.expand_more, size: 24, color: color,);

    return Container(
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: StadiumBorder(),
      ),
      child: NPair(
        icon: NText(title,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          style: TextStyle(color: color),
        ),
        child: icon,
      ),
    );
  }

  buildList({required List<String> items}) {
    return Material(
      // color: Colors.transparent,
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          final e = items[index];
          return ListTile(
            title: Text(e),
            onTap: () {
              debugPrint(e);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            indent: 15,
            endIndent: 15,
            color: Color(0xFFe4e4e4),
          );
        },
      ).toCupertinoScrollbar(),
    );
  }

  closeDropBox() {
    dropBoxController.onToggle();
    if (showDropBox.value == false) {
      return;
    }
    showDropBox.value = !showDropBox.value;
  }

  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}