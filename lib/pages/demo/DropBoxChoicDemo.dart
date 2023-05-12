


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/enhance_expansion_choic.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_expansion/enhance_expansion_tile.dart';

import 'package:flutter_templet_project/basicWidget/n_cancell_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/uti/Debounce.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';
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
  final items = List.generate(20, (i) => i).toList();

  var searchText = "";
  late final searchtEditingController = TextEditingController();

  final _debounce = Debounce(milliseconds: 500);

  // final _throttle = Throttle(milliseconds: 500);

  var isVisible = ValueNotifier(false);

  final _globalKey = GlobalKey();

  ScrollController? dropBoxController = ScrollController();

  /// 标签组
  List<FakeDataModel> get models => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "选项_$e",
  )).toList();
  List<FakeDataModel> selectedModels = [];
  List<FakeDataModel> selectedModelsTmp = [];

  List<FakeDataModel> get tagModels => items.map((e) => FakeDataModel(
    id: "id_$e",
    name: "标签_$e",
  )).toList();
  List<FakeDataModel> selectedTagModels = [];
  List<FakeDataModel> selectedTagModelsTmp = [];

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildSearchAndFilterBar(),
                        Expanded(
                          child: buildList(
                            items: items.map((e) => "item_$e").toList(),
                          )
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: isVisible,
                        builder: (context, bool value, child) {
                          if (value == false) {
                            return const SizedBox();
                          }

                          final top = _globalKey.currentContext?.renderBoxSize?.height ??
                              60.h;
                          return Positioned(
                            top: top,
                            bottom: 0,
                            width: context.screenSize.width,
                            // height: 600.h,
                            child: buildDropBox(
                              controller: dropBoxController,
                              hasShadow: true,
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  buildSearchAndFilterBar() {
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
            width: 8.w,
          ),
          buildTextBtn(
            padding: EdgeInsets.only(left: 16.w),
            icon: Icon(Icons.fitbit),
            cb: (){
              isVisible.value = !isVisible.value;
              closeKeyboard();
            }
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

  buildTextBtn({
    String title = "筛选",
    Color? color = Colors.blue,
    VoidCallback? cb,
    bool isIconRight = false,
    OutlinedBorder? shape,
    double labelIconPadding = 4,
    EdgeInsets? padding,
    Widget? icon,
  }) {
    final label = Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      ),
    );

    var child = <Widget>[label];
    if (icon != null) {
      child = isIconRight
          ? [Flexible(child: label), SizedBox(width: labelIconPadding), icon]
          : [icon, SizedBox(width: labelIconPadding), Flexible(child: label)];
    }

    return TextButton(
      style: TextButton.styleFrom(
        // splashFactory: NoSplash.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
        // shape: StadiumBorder(
        //   side: BorderSide(color: color ?? Color(0xFF000000)),
        // ),
      ),
      onPressed: cb ?? () {
        debugPrint(title);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: child,
      ),
    );
  }

  /// 筛选弹窗
  Widget buildDropBox({
    required ScrollController? controller,
    bool hasShadow = false,
    bool isSingle = false,
  }) {
    final child = Container(
      width: double.maxFinite,
      // padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.w),
          bottomRight: Radius.circular(30.w),
        ),
        boxShadow: !hasShadow ? null : [
          BoxShadow(
            offset: Offset(0, 8.w),
            blurRadius: 8.w,
            // spreadRadius: 4,
            color: context.primaryColor.withOpacity(0.3),
          ),
        ]
      ),
      child: Column(
        children: [
          Divider(height: 1.h, color: lineColor,),
          Expanded(
            child: CupertinoScrollbar(
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    // bottom: 30.w,
                  ),
                  child: Column(
                    children: [
                      buildDropBoxTagChoic(models: models),
                      SizedBox(
                        height: 24.w,
                      ),
                      EnhanceExpansionChoic<FakeDataModel>(
                        title: Text("EnhanceExpansionChoic",
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        isSingle: isSingle,
                        models: tagModels,
                        cbID: (e) => e.id ?? "",
                        cbTitle: (e) => e.name ?? "",
                        cbSelected: (e) => selectedTagModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
                        onChanged: (value) {
                          // debugPrint("selectedModels: ${value.map((e) => e.title).toList()}");
                          selectedTagModelsTmp = value.map((e) => e.data!).toList();
                          debugPrint("selectedTagModelsTmp: ${selectedTagModelsTmp.map((e) => e.name).toList()}");
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          buildDropBoxButtonBar(),
        ],
      ),
    );
    return Container(
      color: Colors.black.withOpacity(0.1),
      padding: EdgeInsets.only(bottom: context.appBarHeight.h),
      child: child,
    );
  }

  /// 筛选弹窗 标签选择
  Widget buildDropBoxTagChoic({
    required List<FakeDataModel> models,
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
          title: "标签",
          childrenHeader: Column(
            children: [
              buildDropBoxChoicPart<FakeDataModel>(
                models: items,
                cbID: (e) => e.id ?? "",
                cbName: (e) => e.name ?? "",
                cbSelected: (e) => selectedModelsTmp.map((e) => e.id ?? "").toList().contains(e.id),
                onChanged: (value) {
                  // debugPrint("selectedModels: $value");
                  selectedModelsTmp = value.map((e) => e.data!).toList();
                  debugPrint("selectedTagModelsTmp: ${selectedModelsTmp.map((e) => e.name).toList()}");
                },
              ),
            ],
          ),
          children: [],
        );
      }
    );
  }

  /// 筛选弹窗 选择子菜单
  buildDropBoxChoicPart<T>({
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbName,
    required bool Function(T) cbSelected,
    ValueChanged<List<ChoiceBoxModel<T>>>? onChanged,
  }) {
    return NChoiceBox<T>(
      isSingle: true,
      itemColor: Colors.transparent,
      // wrapAlignment: WrapAlignment.spaceBetween,
      // wrapAlignment: WrapAlignment.start,
      items: models.map((e) => ChoiceBoxModel<T>(
        id: cbID(e),
        title: cbName(e),
        isSelected: cbSelected(e),
        data: e,
      )).toList(),
      onChanged: onChanged ?? (value) {
        debugPrint("selectedModels: $value");
      },
    );
  }

  /// 筛选弹窗 取消确认菜单
  Widget buildDropBoxButtonBar() {
    return NCancellAndConfirmBar(
      cancellTitle: "重置",
      bottomLeftRadius: Radius.circular(30.w),
      bottomRightRadius: Radius.circular(30.w),
      onCancell: () {
        // Navigator.of(context).pop();
        handleResetFitler();
      },
      onConfirm: () {
        // Navigator.of(context).pop();
        handleConfirmFitler();
      },
    );
  }

  /// 重置过滤参数
  handleResetFitler() {
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
  handleConfirmFitler() {
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
    Widget childrenHeader = const SizedBox(),
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnhanceExpansionTile(
        childrenHeader: childrenHeader,
        // childrenFooter: Container(
        //   height: 30,
        //   color: Colors.blueAccent,
        // ),
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
          boderColor: color.withOpacity(0.2),
        ),
        collapsedTextColor: fontColor,
        textColor: fontColor,
        iconColor: color,
        collapsedIconColor: color,
        title: Text(
          title,
          style: TextStyle(
              color: fontColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold
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
    Color boderColor = Colors.blueAccent,
  }) {
    final title = isExpand ? "收起" : "展开";
    final icon = isExpand
        ? Icon(Icons.expand_less, size: 24, color: color,)
        : Icon(Icons.expand_more, size: 24, color: color,);

    return Container(
      width: 66.w,
      height: 29.w,
      // color: Colors.red,
      padding: EdgeInsets.only(left: 8.w, right: 4.w, top: 2.w, bottom: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.w)),
        border: Border.all(color: boderColor),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: color),
          ),
          const SizedBox(width: 0,),
          icon,
        ],
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
      ).addCupertinoScrollbar(),
    );
  }

  closeDropBox() {
    if (isVisible.value == false) {
      return;
    }
    isVisible.value = !isVisible.value;
  }

  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}