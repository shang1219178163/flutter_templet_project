


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_cancell_and_confirm_bar.dart';
import 'package:flutter_templet_project/uti/app_uti.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';


mixin DialogMixin{

  /// 项目通用弹窗封装
  presentDialog({
    required BuildContext context,
    String title = "标题",
    Widget? content,
    Widget? header,
    Widget? footer,
    Color divderColor = const Color(0xffF3F3F3),
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 38),
    Radius radius = const Radius.circular(8),
    Alignment alignment = Alignment.center,
    VoidCallback? onCancell,
    VoidCallback? onConfirm,
    VoidCallback? onBarrier,
    double contentMaxHeight = 400,
    double contentMinHeight = 150,
    double buttonBarHeight = 48,
    EdgeInsets contentPadding = const EdgeInsets.all(20),
    StatefulWidgetBuilder? contentChildBuilder,
  }) {

    final defaultHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w,),
          child: Text(title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: fontColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: IconButton(
            onPressed: onCancell ?? (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.clear,
              size: 20.w,
              color: Color(0xff231815),
            ),
          ),
        ),
      ],
    );

    final defaultContent = StatefulBuilder(
        builder: (context, setState) {

          return Scrollbar(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: contentMaxHeight - buttonBarHeight,
                minHeight: contentMinHeight,
              ),
              child: SingleChildScrollView(
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
          Divider(height: 1.w, color: divderColor,),
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

          return InkWell(
            onTap: onBarrier ?? () {
              // Navigator.of(context).pop();
              AppUti.removeInputFocus();
            },
            child: Container(
                color: Colors.black.withOpacity(0.05),
                child: Align(
                  alignment: alignment,
                  child: child,
                )
            ),
          );
        }
    );
  }

  /// 项目 alert
  presentDialogAlert({
    required BuildContext context,
    required VoidCallback? onCancell,
    required VoidCallback? onConfirm,
    String? title,
    String? message,
    Widget? content,
    Widget? header,
    Widget? footer,
    Color? cancellBgColor = bgColor,
    Color? confirmBgColor = Colors.blueAccent,
    TextStyle? cancellTextStyle,
    TextStyle? confirmTextStyle,
  }) {
    assert(title != null || header != null, "title 和 header 不能同时为空!");
    assert(message != null || content != null, "title 和 header 不能同时为空!");

    presentDialog(
        context: context,
        radius: Radius.circular(12),
        header: header ?? Padding(
          padding: EdgeInsets.only(top: 24.w),
          child: Text(title ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fontColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        contentMinHeight: 50.h,
        contentChildBuilder: (context, setState){

          return Container(
            // color: ColorExt.random,
            alignment: Alignment.center,
            child: Text(message ?? "",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
        footer: NCancellAndConfirmBar(
          height: 45,
          cancellBgColor: cancellBgColor,
          confirmBgColor: confirmBgColor,
          cancellTextStyle: cancellTextStyle,
          confirmTextStyle: confirmTextStyle,
          bottomLeftRadius: Radius.circular(12),
          bottomRightRadius: Radius.circular(12),
          onCancell: onCancell ?? (){
            Navigator.of(context).pop();
          },
          onConfirm: onConfirm ?? () {
            Navigator.of(context).pop();
          },
          // divider: VerticalDivider(
          //   color: Colors.red,
          //   width: 1,
          //   thickness: 1,
          // ),
        )
    );
  }

}