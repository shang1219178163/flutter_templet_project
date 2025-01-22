//
//  RichTextDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/31/21 12:11 PM.
//  Copyright © 7/31/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_footer.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/pages/demo/ScrollbarDemo.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:tuple/tuple.dart';

class RichTextDemo extends StatefulWidget {
  final String? title;

  const RichTextDemo({Key? key, this.title}) : super(key: key);

  @override
  _RichTextDemoState createState() => _RichTextDemoState();
}

class _RichTextDemoState extends State<RichTextDemo> {
  List<({String title, VoidCallback action})> get records => [
        (title: "展示隐私", action: onShowPrivacy),
        (title: "展示服务", action: onShowService),
      ];

  var linkMap = {
    '《用户协议》': 'https://flutter.dev',
    '《隐私政策》': 'https://flutter.dev',
    '您的': 'https://flutter.dev',
  };

  String text = """
        亲爱的xxxx用户，感谢您信任并使用xxxxAPP！
xxxx十分重视用户权利及隐私政策并严格按照相关法律法规的要求，对《用户协议》和《隐私政策》进行了更新,特向您说明如下：
        1.为向您提供更优质的服务，我们会收集、使用必要的信息，并会采取业界先进的安全措施保护您的信息安全；
        2.基于您的明示授权，我们可能会获取设备号信息、包括：设备型号、操作系统版本、设备设置、设备标识符、MAC（媒体访问控制）地址、IMEI（移动设备国际身份码）、广告标识符（“IDFA”与“IDFV”）、集成电路卡识别码（“ICCD”）、软件安装列表。我们将使用三方产品（友盟、极光等）统计使用我们产品的设备数量并进行设备机型数据分析与设备适配性分析。（以保障您的账号与交易安全），且您有权拒绝或取消授权；
        3.您可灵活设置伴伴账号的功能内容和互动权限，您可在《隐私政策》中了解到权限的详细应用说明；
        4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息；
        5.您可以查询、更正、删除您的个人信息，我们也提供账户注销的渠道。
        请您仔细阅读并充分理解相关条款，其中重点条款已为您黑体加粗标识，方便您了解自己的权利。如您点击“同意”，即表示您已仔细阅读并同意本《用户协议》及《隐私政策》，将尽全力保障您的合法权益并继续为您提供优质的产品和服务。如您点击“不同意”，将可能导致您无法继续使用我们的产品和服务。
""";

  late final textSpans = <TextSpan>[
    TextSpan(
      text: '红色',
      style: TextStyle(fontSize: 18.0, color: Colors.red),
    ),
    TextSpan(
      text: '绿色',
      style: TextStyle(fontSize: 18.0, color: Colors.green),
    ),
    TextSpan(
      text: '蓝色',
      style: TextStyle(fontSize: 18.0, color: Colors.blue),
    ),
    TextSpan(
      text: '白色',
      style: TextStyle(fontSize: 18.0, color: Colors.orange),
    ),
    TextSpan(
      text: '紫色',
      style: TextStyle(fontSize: 18.0, color: Colors.purple),
    ),
    TextSpan(
      text: '黑色',
      style: TextStyle(fontSize: 18.0, color: Colors.black),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              matchRegExp();
            },
            child: Text(
              "done",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: records.map((e) {
                    return ElevatedButton(
                      style: TextButton.styleFrom(
                        // padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: const Size(24, 28),
                        // foregroundColor: Colors.blue,
                      ),
                      onPressed: e.action,
                      child: Text(e.title),
                    );
                  }).toList(),
                ),
              ),
              // NSectionBox(
              //   title: "buildRichText",
              //   child: buildRichText().toBorder(),
              // ),
              NSectionBox(
                title: "buildWidgetSpan",
                child: buildWidgetSpan(),
              ),
              NSectionBox(
                title: "richTextWid04",
                child: richTextWid04(),
              ),
              NSectionBox(
                title: "buildHospital - PlaceholderAlignment",
                child: Column(
                  children: [
                    ...PlaceholderAlignment.values.map((e) {
                      return NSectionBox(
                        title: "buildHospital - ${e.name}",
                        child: buildHospital(
                          alignment: e,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRichText() {
    return Text.rich(
      TextSpan(
        children: RichTextExt.createTextSpans(
          text: text,
          textTaps: linkMap.keys.toList(),
          // linkStyle: TextStyle(fontSize: 18.0, color: Colors.red),
          onLink: (textTap) {
            ddlog(textTap);
          },
        ),
      ),
      // style: TextStyle(
      //   wordSpacing: 12
      // ),
      strutStyle: StrutStyle(
        leading: 0.4,
      ),
    );
  }

  /// 图文混排
  Widget buildWidgetSpan() {
    return Text.rich(TextSpan(
      children: <InlineSpan>[
        TextSpan(text: '图文混排 '),
        TextSpan(text: 'Flutter is'),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            width: 120,
            height: 40,
            child: Card(
              color: Colors.blue,
              child: Center(child: Text('Hello World!')),
            ),
          ),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            child: FlutterLogo(
              size: 40,
            ),
          ),
        ),
        TextSpan(text: 'the best!'),
      ],
    ));
  }

  Widget richTextWid04() {
    return RichText(
      text: TextSpan(
        text: '多种样式，如：',
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        children: textSpans
            .map((e) => e.copyWith(
                  onLink: onLink,
                ))
            .toList(),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// WidgetSpan 和文字首行对齐
  Widget buildHospital({
    TextBaseline textBaseline = TextBaseline.alphabetic,
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    double spacing = 7,
  }) {
    var departmentDesc = ["第四军医大西京医院", "眼科"].where((e) => e?.isNotEmpty == true).join("·");
    departmentDesc *= 6;

    var hospitalLevel = "三级甲等";
    // hospitalLevel = "";

    return Opacity(
      opacity: hospitalLevel.isEmpty && departmentDesc.isEmpty ? 0 : 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: spacing).copyWith(
            // left: hospitalLevel.isNotEmpty ? 0 : 7,
            // top: hospitalLevel.isNotEmpty ? 0 : 2,
            // bottom: 0,
            ),
        // padding: EdgeInsets.only(right: 70),
        decoration: BoxDecoration(
          // color: const Color(0xFFF6F6F6),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text.rich(
          style: TextStyle(
            textBaseline: textBaseline,
          ),
          TextSpan(
            children: [
              WidgetSpan(
                alignment: alignment,
                baseline: textBaseline,
                child: Transform.translate(
                  offset: Offset(-spacing, 0),
                  child: Visibility(
                    visible: hospitalLevel.isNotEmpty,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: spacing, vertical: 2),
                      margin: const EdgeInsets.only(right: 0.5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF55C82B), Color(0xFF12B199)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: NText(
                        hospitalLevel,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TextSpan(
                text: departmentDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: fontColor737373,
                  // height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void matchRegExp() {
    final reg = RegExp(r'《[^《》]+》', multiLine: true).allMatches(text);
    final list = reg.map((e) => e.group(0)).toList();
    ddlog(list);

    var str3 = '''
  Multi
  Line
  String
  ''';

    final result1 = str3.splitMapJoin(RegExp(r'^', multiLine: true), // Matches the beginning of the line
        onMatch: (m) => '** ${m.group(0)}', // Adds asterisk to match
        onNonMatch: (n) => n); // Just return non-matches
    debugPrint(result1);

    var s = 'bezkoder';
    ddlog(s.padLeft(10)); // '  bezkoder'
    ddlog(s.padLeft(10, ' ')); // '==bezkoder'

    ddlog(s.padRight(12)); // 'bezkoder  '
    ddlog(s.padRight(12, '=')); // 'bezkoder=='
  }

  void onLink(String? text) {
    debugPrint("onTap: $text");
  }

  void onShowPrivacy() {
    Widget content = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: buildRichText(),
    );
    GetDialog.showCustom(
      header: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Center(
          child: NText(
            "用户协议",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      footer: NFooterButtonBar(
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () {
          Navigator.of(context).pop();
        },
      ),
      child: content,
    );
  }

  void onShowService() {
    Widget content = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: buildRichText(),
    );

    content = Scrollbar(child: SingleChildScrollView(child: content));

    GetBottomSheet.showCustom(
      addUnconstrainedBox: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NPickerToolBar(
            title: "用户服务",
            // confirmTitle: "同意",
            onConfirm: () {},
          ),
          Flexible(child: content),
        ],
      ),
    );
  }
}
