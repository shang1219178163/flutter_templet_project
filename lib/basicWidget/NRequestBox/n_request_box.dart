import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_search_textfield.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

// buildBody2() {
//   return NRequestListBox(
//     onSearchChanged: (String value) {
//       debugPrint(value);
//     },
//     dropView: Container(
//       // color: Colors.white,
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Container(
//             height: 400,
//             color: Colors.green,
//           ),
//           Container(
//             height: 400,
//             color: Colors.yellowAccent,
//           ),
//         ],
//       ),
//     ),
//     dropViewCancel: (){
//       return true;
//     },
//     dropViewConfirm: (){
//       return false;
//     },
//     body: NNetContainerListView<DepartmentPageDetailModel>(
//       onRequest: (bool isRefresh, int page, int pageSize, last) {
//         final ownerId = "412636124799488000";
//         return requestList(isRefresh: isRefresh, ownerId: ownerId);
//       },
//       onRequestError: (Object error, StackTrace stack) {
//         BrunoUtil.showInfoToast("$error");
//       },
//       itemBuilder: (BuildContext context, int index, DepartmentPageDetailModel data) {
//         final e = data;
//
//         return InkWell(
//           onTap: (){
//             debugPrint("$e");
//           },
//           child: PatientSchemeCellOne(
//             color: e.statusTuple?.item2 ?? primary,
//             isFirst: index == 0,
//             isLast: false,
//             time: e.updateTime == null ? "-" : DateTimeExt.stringFromTimestamp(timeSamp: e.updateTime!),
//             planTitle: e.name ?? "-",
//             planTime: e.dateRangeDes ?? "-",
//             status: e.statusDes ?? "-",
//             scence: e.sceneTuple?.item1 ?? "",
//             scenceColor: e.sceneTuple?.item2 ?? Color(0xff5690F4),
//             btnTitle: e.btnTitle != null ? "${e.btnTitle} >" : "查看详情 >",
//             onClick: () {
//               debugPrint("$e");
//             },
//           ),
//         );
//       },
//       separatorBuilder: (context, int index){
//         return SizedBox();
//       }
//     ),
//   );
// }

typedef ToggleWidgetBuilder = Widget Function(
    bool isVisible, VoidCallback onToggle);

/// 列表请求组件
/// 支持: 下拉刷新,上拉加载; 搜索框回调; dropbox
class NRequestBox extends StatefulWidget {
  NRequestBox({
    Key? key,
    this.placeholder = "搜索",
    this.onSearchChanged,
    this.btnBuilder,
    this.dropView,
    this.dropViewCancel,
    this.dropViewConfirm,
    this.bodyDecoration,
    required this.body,
  }) : super(key: key);

  /// 占位
  final String? placeholder;

  /// 为空时,不显示搜索栏
  final ValueChanged<String>? onSearchChanged;

  /// 带翻转方法的构建方法
  final ToggleWidgetBuilder? btnBuilder;

  /// 为空时,不显示右边按钮
  final Widget? dropView;

  /// 重置按钮
  final bool Function()? dropViewCancel;

  /// 确定按钮
  final bool Function()? dropViewConfirm;

  /// 修饰属性
  final Decoration? bodyDecoration;

  /// 容器
  final Widget body;

  @override
  _NRequestBoxState createState() => _NRequestBoxState();
}

class _NRequestBoxState extends State<NRequestBox> {
  /// 搜索
  late final _searchController = TextEditingController();

  late final _searchPlaceholder = widget.placeholder ?? "搜索";

  ///显示筛选按钮
  final _showDropbox = ValueNotifier(false);

  final _dropBoxController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.bodyDecoration ??
          BoxDecoration(
            color: bgColor,
            // border: Border.all(color: Colors.blue),
            // borderRadius: BorderRadius.all(Radius.circular(0.w)),
          ),
      child: Column(
        children: [
          if (widget.onSearchChanged != null)
            buildSearchAndFilterBar(
                controller: _searchController,
                placeholder: _searchPlaceholder,
                onChanged: widget.onSearchChanged!,
                btnBulder: widget.btnBuilder,
                onClick: widget.dropView == null
                    ? null
                    : () {
                        _showDropbox.value = !_showDropbox.value;
                      }),
          Expanded(
            child: buildStack(
              body: widget.body,
              showPositionedChild: _showDropbox,
              positionedChild: buildDropBoxNew(
                controller: _dropBoxController,
                onCancel: () {
                  final isCancel = widget.dropViewCancel?.call() == true;
                  if (isCancel) {
                    _showDropbox.value = false;
                  }
                },
                onConfirm: () {
                  final isConfirm = widget.dropViewConfirm?.call() == true;
                  if (isConfirm) {
                    _showDropbox.value = false;
                  }
                },
                child: widget.dropView ??
                    Container(
                      // color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            height: 400,
                            color: Colors.green,
                          ),
                          Container(
                            height: 400,
                            color: Colors.yellowAccent,
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索框和筛选按钮
  buildSearchAndFilterBar({
    required TextEditingController? controller,
    String placeholder = "请搜索",
    required ValueChanged<String> onChanged,
    ToggleWidgetBuilder? btnBulder,
    VoidCallback? onClick,
  }) {
    return Container(
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h, bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36.h,
              child: NSearchTextField(
                controller: controller,
                placeholder: placeholder,
                onChanged: onChanged,
              ),
            ),
          ),
          if (onClick != null)
            InkWell(
              onTap: onClick,
              child: btnBulder?.call(_showDropbox.value, onClick) ??
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onPressed: onClick,
                    child: NPair(
                      child: NText("筛选", fontSize: 16.sp),
                      icon: Image(
                        image: "icon_patient_filter.png".toAssetImage(),
                        width: 18.w,
                        height: 18.h,
                      ),
                    ),
                    // direction: Axis.vertical,
                    // isReverse: true,
                  ),
            ),
        ],
      ),
    );
  }

  /// 创建叠层
  buildStack({
    required Widget body,
    required Widget positionedChild,
    required ValueNotifier<bool> showPositionedChild,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        body,
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder<bool>(
                valueListenable: showPositionedChild,
                builder: (context, value, child) {
                  if (!value) {
                    return const SizedBox();
                  }
                  return positionedChild;
                })),
      ],
    );
  }

  Widget buildDropBox({
    required ScrollController? controller,
    required Widget? child,
    bool hasShadow = false,
    double bottom = kBottomNavigationBarHeight * 4,
    double radius = 30,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      padding: EdgeInsets.only(
        bottom: bottom,
      ),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radius.r),
              bottomRight: Radius.circular(radius.r),
            ),
            boxShadow: [
              if (hasShadow)
                BoxShadow(
                  offset: Offset(0, 8.w),
                  blurRadius: 8.w,
                  // color: const Color(0xff999999),
                  color: Colors.red,
                ),
            ]),
        child: Column(
          children: [
            Divider(
              height: 1.h,
              color: lineColor,
            ),
            Expanded(
              child: CupertinoScrollbar(
                controller: controller,
                child: SingleChildScrollView(
                  controller: controller,
                  child: child,
                ),
              ),
            ),
            NCancelAndConfirmBar(
              cancelTitle: "重置",
              bottomRadius: Radius.circular(radius.r),
              onCancel: onCancel,
              onConfirm: onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropBoxNew({
    required ScrollController? controller,
    required Widget? child,
    bool hasShadow = false,
    double bottom = kBottomNavigationBarHeight * 4,
    double radius = 30,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(radius.r),
                bottomRight: Radius.circular(radius.r),
              ),
              boxShadow: [
                if (hasShadow)
                  BoxShadow(
                    offset: Offset(0, 8.w),
                    blurRadius: 8.w,
                    // color: const Color(0xff999999),
                    color: Colors.red,
                  ),
              ]),
          child: Column(
            children: [
              Divider(
                height: 1.h,
                color: lineColor,
              ),
              Expanded(
                child: CupertinoScrollbar(
                  controller: controller,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: child,
                  ),
                ),
              ),
              NCancelAndConfirmBar(
                cancelTitle: "重置",
                bottomRadius: Radius.circular(radius.r),
                onCancel: onCancel,
                onConfirm: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
