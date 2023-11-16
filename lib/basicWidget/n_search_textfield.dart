

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/Debounce.dart';


// ```
// Expanded(
//   child: Container(
//     height: 36.h,
//     // margin: EdgeInsets.all(16),
//     child: NSearchTextfield(
//       controller: searchEditingController,
//       placeholder: searchPlaceholder,
//       backgroundColor: you color,
//       borderRadius: BorderRadius.all(Radius.circular(4)),
//       cb: (value) {
//         // debugPrint(value);
//         searchText = value;
//         requestPaticentList(isTeam: isTeam, searchText: searchText);
//       },
//     ),
//   ),
// ),
// ```

/// 搜索框封装
class NSearchTextfield extends StatefulWidget {

  NSearchTextfield({
    Key? key,
    this.controller,
    this.placeholder = "请输入",
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsetsDirectional.fromSTEB(3.8, 8, 5, 8),
    this.delay = const Duration(milliseconds: 500),
    required this.onChanged,
    this.onSubmitted,
    this.onSuffixTap,
  }) : super(key: key);

  TextEditingController? controller;
  /// 默认请输入
  String placeholder;
  /// 默认浅灰色
  Color? backgroundColor;
  /// 默认圆角 4px
  BorderRadius? borderRadius;

  EdgeInsetsGeometry padding;
  /// 默认0.5秒延迟
  final Duration delay;

  /// 回调
  ValueChanged<String> onChanged;
  ValueChanged<String>? onSubmitted;
  VoidCallback? onSuffixTap;

  @override
  _NSearchTextfieldState createState() => _NSearchTextfieldState();
}

class _NSearchTextfieldState extends State<NSearchTextfield> {

  late final _debounce = Debounce(delay: widget.delay);

  late final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return buildSearch(
      controller: widget.controller ?? _controller,
      placeholder: widget.placeholder,
      backgroundColor: widget.backgroundColor,
      borderRadius: widget.borderRadius,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onSuffixTap: widget.onSuffixTap,
    );
  }

  buildSearch({
    required TextEditingController controller,
    required String placeholder,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    required ValueChanged<String> onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onSuffixTap,
    EdgeInsetsGeometry? padding,
  }) {
    return CupertinoSearchTextField(
      controller: controller,
      placeholder: placeholder,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      padding: padding ?? EdgeInsets.zero,
      prefixIcon: Image(
        image: "icon_search.png".toAssetImage(),
        width: 14.h,
        height: 14.h,
      ),
      prefixInsets: EdgeInsets.only(
        left: 12.w,
        top: 10.w,
        bottom: 10.w,
        right: 6.w
      ),
      suffixIcon: Icon(
        Icons.cancel,
        color: const Color(0xff999999),
        size: 16.h,
      ),
      suffixInsets: EdgeInsets.only(
        left: 6.w,
        top: 10.w,
        bottom: 10.w,
        right: 12.w,
      ),
      onChanged: (String value) {
        _debounce(() {
          // debugPrint('searchText: $value');
          onChanged.call(value);
        });
      },
      onSubmitted: (String value) {
        _debounce(() {
          // debugPrint('onSubmitted: $value');
          onChanged.call(value);
        });
      },
      onSuffixTap: onSuffixTap ?? (){
        controller.clear();
        onChanged.call("");
      },
    );
  }
}