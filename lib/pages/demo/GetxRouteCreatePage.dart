import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

class GetxRouteCreatePage extends StatefulWidget {
  GetxRouteCreatePage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<GetxRouteCreatePage> createState() => _GetxRouteCreatePageState();
}

class _GetxRouteCreatePageState extends State<GetxRouteCreatePage> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final textEditingController = TextEditingController();

  final descVN = ValueNotifier("");

  @override
  void initState() {
    super.initState();

    var text = '''
/// 视频播放
static const String chewiePlayerPage = '/chewiePlayerPage';
static const String cameraPage = '/cameraPage';

// 搜索消息
static const String messageSearchPage = '/messageSearchPage';
///聊天页面
static const String imChatPage = '/imChatPage';
/// 修改群名称
static const String imGroupSetNamePage = '/imGroupSetNamePage';
///聊天成员列表页面
static const String imGroupMemberListPage = '/imGroupMemberListPage';
/// 群设置
static const String imGroupSetting = '/imGroupSetting';
/// 群投诉
static const String imGroupComplaint = '/imGroupComplaint';

static const String callingVideo = '/callingVideo';
/// 语音通话页
static const String callAudioPage = '/callAudioPage';
/// 视频通话页
static const String videoTalkingPage = '/videoTalkingPage';
static const String callVideoPage = '/callVideoPage';
static const String imVideoCallingPage = '/imVideoCallingPage';


/// 音视频随访页
static const String imCallingFollowPage = '/imCallingFollowPage';
/// 常用语列表
static const String phrasesPage = '/phrasesPage';
/// 常用语编辑
static const String phrasesUpdatePage = '/phrasesUpdatePage';

static const String patientDetailPage = '/patientDetailPage';
static const String patientSearchPage = '/patientSearchPage';
static const String patientGroupPage = '/patientGroupPage';
    ''';

    textEditingController.text = text;
  }

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
                      child: Text(
                        e,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: onCreate,
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
    final text = textEditingController.text;
    if (text.isEmpty) {
      ToastUtil.show("请输入文件名(用换行隔开)");
      return;
    }

    setState(() {});
    final list = text.split("\n").where((e) {
      var tmp = e.trim();
      return tmp.isNotEmpty && tmp.contains("=");
    }).map((e) {
      final line = e.trim();
      final chars = ["const String", "="];
      final list = line.splitSet(chars.toSet());
      final name = list[1].trim();
      // ddlog("name: $name");
      final result =
          "GetPage(name: APPRouter.$name, page: () => const ${name.toCapitalize()}()),\n";
      ddlog("$result");
      return result;
    }).toList();
    // ddlog("list: \n$list");
    // toCreateDartFile(fileName: "AppPages");
  }

  /// 生成模型文件
  toCreateDartFile({required String fileName}) async {
    try {
      final className = fileName.toCamlCase("_");
      final content = ceatePage(className: className);

      /// 生成本地文件
      final file =
          await FileManager().createFile(fileName: fileName, content: content);
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

  String ceatePage({required String className, String content = ""}) {
    // GetPage(name: APPRouter.appSplashPage, page: () => const AppSplashPage()),
    return '''
class AppPages {
  static final List<GetPage> pages = [

    $content,

  ];
}
''';
  }
}
