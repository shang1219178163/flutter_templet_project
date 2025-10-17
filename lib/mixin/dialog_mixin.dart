import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

mixin DialogMixin {
  /// 项目通用弹窗封装
  presentDialog({
    required BuildContext context,
    required ScrollController? scrollController,
    String title = "标题",
    Widget? content,
    Widget? header,
    Widget? footer,
    Color divderColor = const Color(0xffF3F3F3),
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 38),
    Radius radius = const Radius.circular(8),
    Alignment alignment = Alignment.center,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    VerticalDivider? buttonBarDivider,
    VoidCallback? onBarrier,
    bool hasCancelButton = true,
    double contentMaxHeight = 400,
    double contentMinHeight = 150,
    double buttonBarHeight = 48,
    EdgeInsets contentPadding = const EdgeInsets.all(20),
    StatefulWidgetBuilder? contentChildBuilder,
    EdgeInsets contentOffset = EdgeInsets.zero,
    Color? barrierColor,
  }) {
    Color? bColor = Theme.of(context).scaffoldBackgroundColor;

    final defaultHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 20.w,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              // color: fontColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: IconButton(
            onPressed: onCancel ??
                () {
                  Navigator.of(context).pop();
                },
            icon: Icon(
              Icons.clear,
              size: 20.w,
              // color: Color(0xff231815),
            ),
          ),
        ),
      ],
    );

    final defaultContent = StatefulBuilder(builder: (context, setState) {
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
              )),
        ),
      );
    });

    final defaultFooter = NCancelAndConfirmBar(
      height: buttonBarHeight,
      confirmBgColor: Theme.of(context).primaryColor,
      bottomRadius: radius,
      divider: buttonBarDivider,
      hasCancelButton: hasCancelButton,
      onCancel: onCancel ??
          () {
            Navigator.of(context).pop();
          },
      onConfirm: onConfirm ??
          () {
            Navigator.of(context).pop();
          },
    );

    final child = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bColor,
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
          Divider(
            height: 1.w,
            color: divderColor,
          ),
          content ?? defaultContent,
          footer ?? defaultFooter,
        ],
      ),
    );

    final page = Material(
      color: barrierColor ?? Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: onBarrier ??
            () {
              // Navigator.of(context).pop();
              ToolUtil.removeInputFocus();
            },
        child: Container(
            padding: contentOffset,
            color: barrierColor ?? Colors.black.withOpacity(0.05),
            child: Align(
              alignment: alignment,
              child: child,
            )),
      ),
    );

    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'barrierLabel',
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        });
  }

  /// 项目通用 alert 弹窗封装
  presentDialogAlert({
    required BuildContext context,
    required ScrollController? scrollController,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    String? title,
    String? message,
    Widget? content,
    Widget? header,
    Widget? footer,
    bool hasCancelButton = true,
    Radius radius = const Radius.circular(4),
    Color dividerColor = Colors.transparent,
    String confirmTitle = '确定',
    Color? cancelBgColor,
    Color? confirmBgColor,
    TextStyle? cancellTextStyle,
    TextStyle? confirmTextStyle,
    VerticalDivider? buttonBarDivider,
    Divider? buttonBarDividerTop,
    EdgeInsets contentOffset = EdgeInsets.zero,
  }) {
    assert(message != null || content != null, "message 和 content 不能同时为空!");

    cancelBgColor ??= Theme.of(context).hoverColor;
    confirmBgColor ??= Theme.of(context).primaryColor;
    Color? bColor = Theme.of(context).scaffoldBackgroundColor;

    final titleWidget = title == null
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 24.h, bottom: 8.h),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );

    presentDialog(
      scrollController: scrollController,
      context: context,
      radius: Radius.circular(12.w),
      contentOffset: contentOffset,
      header: header ?? titleWidget,
      contentMinHeight: 50.h,
      contentChildBuilder: (context, setState) {
        return Container(
          // color: ColorExt.random,
          color: bColor,
          alignment: Alignment.center,
          child: Text(
            message ?? "",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
      footer: NCancelAndConfirmBar(
        height: 45.w,
        divider: buttonBarDivider,
        hasCancelButton: hasCancelButton,
        cancelBgColor: cancelBgColor,
        confirmBgColor: confirmBgColor,
        cancelTextStyle: cancellTextStyle,
        confirmTextStyle: confirmTextStyle,
        bottomRadius: Radius.circular(12.w),
        onCancel: onCancel ??
            () {
              Navigator.of(context).pop();
            },
        onConfirm: onConfirm ??
            () {
              Navigator.of(context).pop();
            },
        // divider: VerticalDivider(
        //   color: Colors.red,
        //   width: 1,
        //   thickness: 1,
        // ),
      ),
    );
  }

  presentCupertinoAlert(
    BuildContext context, {
    Widget? title,
    Widget? content,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    final dialog = CupertinoAlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: onCancel ??
              () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
          child: Text("取消"),
        ),
        TextButton(
          onPressed: onConfirm ??
              () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
          child: Text("确定"),
        ),
      ],
    );

    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'barrierLabel',
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return dialog;
        });
  }
}

/// 删除确认弹窗
class DeleteAlert with DialogMixin {
  void show(
    BuildContext context, {
    required ScrollController? scrollController,
    String? title,
    String? message,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    presentDialogAlert(
      context: context,
      scrollController: scrollController,
      title: title,
      message: message,
      radius: const Radius.circular(8),
      confirmBgColor: AppColor.white,
      cancelBgColor: AppColor.white,
      confirmTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      buttonBarDividerTop: const Divider(
        height: 1,
        color: AppColor.lineColor,
      ),
      buttonBarDivider: const VerticalDivider(
        width: 1,
        color: AppColor.lineColor,
      ),
      onCancel: onCancel,
      onConfirm: onConfirm,
    );
  }
}
