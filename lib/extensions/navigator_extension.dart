//
//
// ignore: avoid_web_libraries_in_flutter
// import 'package:flutter/cupertino.dart' show BuildContext, Navigator;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

extension NavigatorExt on Navigator{

  // @optionalTypeArgs
  // static void popPage<T extends Object?>(BuildContext context, [ T? result ]) {
  //   if (!Navigator.canPop(context)) {
  //     ddlog("已经是根页面了！");
  //     return;
  //   }
  //   Navigator.of(context).pop<T>(result);
  // }

}

enum ImageAlignment {
  /// 文字左边
  left,

  /// 文字顶部
  top,

  /// 文字右边
  right,

  /// 文字底部
  bottom,
}

extension TextButtonExt on TextButton{

  static TextButton build({
    required Text text,
    required Widget image,
    required ImageAlignment imageAlignment,
    double? padding = 10,
    required void callback(Text text)}) {
    switch (imageAlignment) {
      case ImageAlignment.left:
        return TextButton(
          onPressed: () => callback(text),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              SizedBox(width: 8),
              text,
            ],
          ),
        );

      case ImageAlignment.top:
        return TextButton(
          onPressed: () => callback(text),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              SizedBox(height: padding),
              text,
            ],
          ),
        );

      case ImageAlignment.right:
        return TextButton(
          onPressed: () => callback(text),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              text,
              SizedBox(width: 8),
              image,
            ],
          ),
        );

      case ImageAlignment.bottom:
        return TextButton(
          onPressed: () => callback(text),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              text,
              SizedBox(height: padding),
              image,
            ],
          ),
        );
    }
  }
}
