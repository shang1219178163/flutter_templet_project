import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';

import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// RiverPod 页面创建
class RiverPodPageCreate extends StatefulWidget {
  RiverPodPageCreate({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<RiverPodPageCreate> createState() => _RiverPodPageCreateState();
}

class _RiverPodPageCreateState extends State<RiverPodPageCreate> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                '创建',
              ]
                  .map(
                    (e) => TextButton(
                      onPressed: onCreate,
                      child: Text(
                        e,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: NTextField(
                  controller: textEditingController,
                  minLines: 10,
                  maxLines: 10,
                  onChanged: (val) {},
                  onSubmitted: (val) {}),
            ),
          ],
        ),
      ),
    );
  }

  void onCreate() {
    // final text = '''
    // im_chat_page.dart
    // im_group_member_list_page.dart
    // im_group_setname.dart
    // im_group_setting.dart
    // follow_up_evaluation_tab_page.dart
    // follow_up_evaluation_list_page.dart
    // follow_up_evaluation_updatet_page.dart
    // follow_up_evaluation_createt_page.dart
    // patient_detail_page.dart
    // patient_list_page.dart
    // ''';

    final text = textEditingController.text;
    if (text.isEmpty) {
      ToastUtil.show("请输入文件名(用换行隔开)");
      return;
    }

    setState(() {});
    final list = text.split("\n").where((e) => e.trim().isNotEmpty).map((e) {
      final line = e.trim();
      final result = line.endsWith(".dart") ? line.split(".").first : line;

      return result;
    }).toList();
    list.forEach((e) {
      toCreateDartFile(fileName: e);
    });
  }

  /// 生成模型文件
  toCreateDartFile({
    required String fileName,
  }) async {
    try {
      final className = fileName.toCamlCase("_");
      final content = ceatePage(className: className);

      /// 生成本地文件
      final file = await FileManager().createFile(fileName: fileName, content: content);
      debugPrint("file: ${file.path}");

      showSnackBar(SnackBar(
        content: NText(
          "文件已生成(下载文件夹)",
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      debugPrint("catch: $e");
      Get.bottomSheet(Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NText(
              e.toString(),
            ),
          ],
        ),
      ));
    }
  }

  String ceatePage({required String className}) {
    return '''
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:yl_gcp_app/core/router/based.dart';
import 'package:yl_gcp_app/core/router/provider.dart';
import 'package:yl_gcp_app/module/_examples/page/state.dart';
import 'package:yl_gcp_app/module/account/model/auth_token_vo.dart';
import 'package:yl_gcp_app/vender/toast_util.dart';


class $className extends ConsumerStatefulWidget {
  
    /// 路由名称
  static String routeName = '$className';
  
  /// 路由
  static final route = GoRoute(
    name: routeName,
    path: '/' + routeName,
    pageBuilder: (context, state) => MaterialPage(
      fullscreenDialog: true,
      child: $className(),
    ),
  );

  const $className({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _${className}State();
}

class _${className}State extends ConsumerState<$className>
    with AutomaticKeepAliveClientMixin, _PageBuilder {
  @override
  _${className}State get state => this;

  @override
  bool get wantKeepAlive => true;

  /// 跳转页面并接收返回值
  void pickXXX() async {
    final result = await ref.router.pushRoutable<String>(
      const ExamplePage(
        requiredValue: '必传参数',
        model: AuthTokenVo(
          accessToken: 'AAA',
          refreshToken: 'RRR',
          expiration: 1,
        ),
      ),
    );
  }
}


mixin _PageBuilder on ConsumerState<$className> {
  _${className}State get state;

  @override
  Widget build(BuildContext context) {
    // 调用 AutomaticKeepAliveClientMixin.build
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        title: Text("$className"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () async {
              state.pickXXX();
            },
            child: const Text('带参跳转并接收返回值'),
          ),
          Text('返回值:'),
        ],
      ),
    );
  }
}
''';
  }
}
