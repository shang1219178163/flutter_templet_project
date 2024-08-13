//
//  WidgetThemeConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 09:33.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

class WidgetThemeConvert extends ConvertProtocol {
  @override
  String get name => "组件生成对应的 Theme 文件";

  @override
  String exampleTemplet() {
    return """
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yl_health_app/extension/string_ext.dart';
import 'package:yl_health_app/routers/navigator_util.dart';
import 'package:yl_health_app/util/color_util_new.dart';
import 'package:yl_health_app/widget/common/my_icon.dart';
import 'package:yl_health_app/widget/common/my_text.dart';

///自定义顶部appBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    this.title = '',
    this.centerTitle = true,
    this.rightActions,
    this.backgroundColor = white,
    this.mainColor = fontColor,
    this.titleW,
    this.titleSpacing,
    this.bottom,
    this.leading,
    this.leadingWidth,
    this.flexibleSpace,
    this.leadingImg = '',
    this.leadingVisible = true,
    this.brightness = Brightness.dark,
    this.overlayStyle = SystemUiOverlayStyle.dark,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.toolbarHeight = 48,
    this.backClick,
  }) : super(key: key);

  final String title;
  final bool centerTitle; //标题是否居中，默认居中
  final List<Widget>? rightActions;
  final Color? backgroundColor;//背景色
  final Color? mainColor;
  final Widget? titleW;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final double? titleSpacing;
  final Widget? leading;
  final bool leadingVisible;
  final PreferredSizeWidget? bottom;
  final String leadingImg;
  final double elevation;
  final double toolbarHeight;
  final Brightness brightness; //状态栏颜色 默认为白色文字
  final SystemUiOverlayStyle overlayStyle;
  final bool automaticallyImplyLeading; //配合leading 使用，如果左侧不需要图标 ，设置false
  final Function? backClick;

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final titleStr = title.toShort();

    return AppBar(
      title: titleW ??
          MyText(
            titleStr,
            size: 18,
            color: mainColor,
            fontWeight: FontWeight.w500,
          ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      leading: leading ??
          Visibility(
            visible: leadingVisible,
            child: IconButton(
              onPressed: () {
                if (backClick != null) {
                  backClick!();
                } else {
                  NavigatorUtil.goBack();
                }
              },
              icon: MyIcon(
                Icons.arrow_back_ios_new_outlined,
                color: mainColor,
                size: 18,
              ),
            ),
          ),
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      systemOverlayStyle: Platform.isAndroid
          ? SystemUiOverlayStyle(
              statusBarBrightness: brightness,
              statusBarIconBrightness: brightness,
              systemNavigationBarColor: Colors.transparent,
            )
          : overlayStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      actions: rightActions ?? rightActions,
      toolbarHeight: toolbarHeight,
      bottom: bottom ?? bottom,
    );
  }
}
""";
  }

  @override
  Future<ConvertModel?> convertFile({required File file}) async {
    try {
      final name = file.path.split("/").last;
      String content = await file.readAsString();
      return convert(content: content, name: name);
    } catch (e) {
      debugPrint("$this $e");
    }
    return null;
  }

  @override
  Future<ConvertModel?> convert({
    String? name,
    required String content,
  }) async {
    if (content.isEmpty) {
      return null;
    }
    final lines = content
        .split("\n")
        .where((e) => !e.startsWith("//"))
        .join("\n")
        .split("Widget build(BuildContext context)")
        .first
        .split("\n")
        .where(
            (e) => e.startsWith("class ") || e.trimLeft().startsWith("final "))
        .toList();

    final line =
        (lines.where((e) => e.startsWith("class ")).firstOrNull ?? "ClassName");
    // final clsName =
    //     (lines.where((e) => e.startsWith("class ")).firstOrNull ?? "ClassName")
    //         .split(" ")[1]
    //         .replaceFirst("My", "Yl")
    //         .replaceFirst("N", "Yl");

    var clsName = "";
    if (line.contains("<")) {
      clsName = line.split("<").first.split(" ")[1];
    } else {
      clsName = line.split(" ")[1];
    }
    clsName = clsName.replaceFirst("My", "Yl").replaceFirst("N", "Yl");

    final propertys = lines.where((e) {
      final result = e.trimLeft().startsWith("final ") &&
          e.contains("?") &&
          !e.contains(")");
      return result;
    }).map((e) {
      final eContent = e.trimLeft();
      final comment = eContent.contains("//") ? eContent.split("//").last : "";
      final parts = eContent.split(RegExp(r'[ ;]+'));
      final p = (name: parts[2], type: parts[1], comment: comment);
      return p;
    }).toList();
    // transformViewController.out = clsName +
    //     propertys.map((e) => e.toString()).join(""
    //         "\n");

    final fileName =
        "${clsName.toUncamlCase("_")}_theme.dart".replaceFirst("yl_", "");
    final contentNew = _createThemeFileContent(
      clsName: clsName,
      propertys: propertys,
    );
    return ConvertModel(
      name: name ?? clsName,
      content: content,
      nameNew: fileName,
      contentNew: contentNew,
    );
  }

  String _createThemeFileContent({
    String prefix = "Yl",
    required String clsName,
    required List<PropertyRecord> propertys,
  }) {
    final projectName = "yl_design";
    final dateStr = DateTimeExt.stringFromDate(
      date: DateTime.now(),
      format: 'yyyy/MM/dd HH:mm:ss',
    );

    final name = clsName.startsWith(prefix) ? clsName : prefix + clsName;
    final content = """
//
//  ${name}Theme.dart
//  $projectName
//
//  Created by shang on ${dateStr?.substring(0, 16)}.
//  Copyright © ${dateStr?.substring(0, 10)} shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 自定义 
class ${name}Theme extends ThemeExtension<${name}Theme> {
  /// 自定义  
  ${name}Theme({
${propertys.map((e) => "\t\tthis.${e.name},").join("\n")}
  });

${propertys.map((e) => """
  /// ${e.comment}
  final ${e.type} ${e.name};
  """).join("\n")}

  @override
  ThemeExtension<${name}Theme> copyWith({
${propertys.map((e) => """
\t\t${e.type} ${e.name},
""").join("")}
  }) =>
      ${name}Theme(
    ${propertys.map((e) => """
      ${e.name}: ${e.name} ?? this.${e.name},
    """).join("")}
      );

  @override
  ThemeExtension<${name}Theme> lerp(
    covariant ${name}Theme? other,
    double t,
  ) =>
      ${name}Theme(
    ${propertys.map((e) => """
      ${e.name}: ${e.type.replaceAll("?", "")}.lerp(${e.name}, other?.${e.name}, t),
    """).join("")}
      );
}
    """;
    return content;
  }
}
