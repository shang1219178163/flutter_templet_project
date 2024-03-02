
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/model_generator.dart';

class JsonToDartPage extends StatefulWidget {

  JsonToDartPage({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _JsonToDartPageState createState() => _JsonToDartPageState();
}

class _JsonToDartPageState extends State<JsonToDartPage> {

  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();


  var rootClassNameStr = "Root";
  var classPrefix = "YY";
  var classSuffix = "Model";

  late final _nameController = TextEditingController(text: rootClassNameStr);
  late final _prefixController = TextEditingController(text: classPrefix);
  late final _suffixController = TextEditingController(text: classSuffix);

  final _scrollController = ScrollController();

  var jsonStr = "";
  final outVN = ValueNotifier("");


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            onPressed: (){
              Get.bottomSheet(Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NText("1. 所有对象不能为空(零属性)",),
                  ],
                ),
              ));
            },
            icon: Icon(Icons.warning_amber_rounded)
          ),
        ]
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {

          final direction = constraints.maxWidth > 500 ? Axis.horizontal : Axis.vertical;
          if (direction == Axis.horizontal) {
            return buildBodyHorizontal(constraints: constraints);
          }
          return buildBodyVertical(constraints: constraints);
        }
      ),
    );
  }

  buildBodyVertical({double spacing = 10, required BoxConstraints constraints}) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(spacing*3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTop(),
              Container(
                height: constraints.maxHeight * 0.7,
                child: buildLeft(isVertical: true),
              ),
              SizedBox(height: spacing*3,),
              Container(
                child: buildRight(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBodyHorizontal({double spacing = 10, required BoxConstraints constraints}) {
    return Container(
      padding: EdgeInsets.all(spacing*3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTop(),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLeft(),
                SizedBox(width: spacing*3,),
                Expanded(
                  child: buildRight(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTop({
    bool isVertical = false,
    double spacing = 10,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NText("JSON to Dart",
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: spacing,),
        NText("Paste your JSON in the textarea below, click convert and get your Dart classes for free.",
          maxLines: 3,
        ),
        SizedBox(height: spacing*2,),
      ],
    );
  }

  Widget buildTextfield({
    hintText = "hintText",
    maxLines = 1,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xff999999),
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        fillColor: bgColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        counterText: '',
      ),
      onChanged: (val) async{
        // debugPrint("onChanged: $val");
      },
      onSubmitted: (val){
        debugPrint("onSubmitted: $val");
      },
      onEditingComplete: () {
        debugPrint("onEditingComplete: ");
      },
      // onTap: (){
      //   debugPrint("onTap: ${controller?.value.text}");
      // },
      // onTapOutside: (e){
      //   debugPrint("onTapOutside: $e ${controller?.value.text}");
      // },
    );
  }

  Widget buildLeft({
    bool isVertical = false,
    double spacing = 10,
    double maxWidth = 400,
  }) {
    double? maxWidth = isVertical ? double.maxFinite : 300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: maxWidth,
            child: buildTextfield(
              controller: _textEditingController,
              focusNode: _focusNode,
              maxLines: 200,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: spacing),
          width: maxWidth,
          child: buildTextfield(
            controller: _nameController,
            hintText: rootClassNameStr,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: spacing),
          width: maxWidth,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  child: buildTextfield(
                    controller: _prefixController,
                    hintText: "类名前缀",
                  ),
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  child: buildTextfield(
                    controller: _suffixController,
                    hintText: "类名后缀",
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   elevation: 0,
              //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // ),
              onPressed: onGenerate,
              child: NText("Generate Dart"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: onPaste,
                child: NText("Paste"),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // minimumSize: Size(50, 18),
                shape: CircleBorder(),
              ),
              onPressed: () async{
                final jsonStr = await loadData();
                _textEditingController.text = jsonStr;
                toCreateDartFile();
              },
              child: NText("try", color: Colors.black45,),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
            onPressed: (){
              debugPrint("copy");
              Clipboard.setData(ClipboardData(text: outVN.value));
            },
            child: NText("Copy Dart code to clipboard"),
          ),
        ),
      ],
    );
  }


  Widget buildRight({
    ScrollController? controller,
    double spacing = 10,
    bool selectable = true,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: outVN,
      builder: (context,  value, child){

        final child = selectable ?
        SelectableText(value,
          // maxLines: 1000,
        ) : NText(value,
          // maxLines: 1000,
        );

        return Scrollbar(
          controller: controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: controller,
            child: child,
          ),
        );
      }
    );
  }

  /// 转模型
  String convertModel({required String rawJson, String rootClassName = "RootModel", String classPrefix = "YY", String classSuffix = "Model"}) {
    final classGenerator = ModelGenerator(rootClassName);
    var dartCode = classGenerator.generateDartClasses(rawJson, classPrefix: classPrefix, classSuffix: classSuffix);
    // debugPrint("dartCode.code:${dartCode.code}");
    return dartCode.code;
  }

  /// 生成模型文件
  toCreateDartFile() async {
    try {
      _focusNode.unfocus();
      outVN.value = convertModel(
        rawJson: _textEditingController.text,
        rootClassName: _nameController.text,
        classPrefix: _prefixController.text,
        classSuffix: _suffixController.text,
      );

      final fileName = (_prefixController.text ?? "").toUpperCase() +
        (_nameController.text.capitalizeFirst ?? "") +
        (_suffixController.text.capitalizeFirst ?? "");
      // debugPrint("fileName: $fileName");

      /// 生成本地文件
      final file = await FileManager().createFile(fileName: fileName, content: outVN.value);
      debugPrint("file: ${file.path}");

      showSnackBar(SnackBar(
        content: NText("文件已生成(下载文件夹)",
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
            NText(e.toString(),),
          ],
        ),
      ));
    }

  }

  onGenerate() async {
    if (_textEditingController.text.isEmpty) {
      var data = await Clipboard.getData("text/plain");
      final dateStr = data?.text ?? "";
      if (dateStr.isNotEmpty) {
        _textEditingController.text = dateStr;
      }
    }

    var text = _textEditingController.text;

    final replace = "\nflutter: ";
    if (text.contains(replace)) {
      text = text.replaceAll(replace, "");
      _textEditingController.text = text;

      Clipboard.setData(ClipboardData(text: text));
    }


    try {
      jsonDecode(_textEditingController.text);

      toCreateDartFile();
    } catch (e) {
      debugPrint("catch: $e");
      Get.bottomSheet(Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NText(e.toString(),),
          ],
        ),
      ));
    }

    //{ "name": "John Smith", "age": 30, "city": "New York"\ }
  }

  Future<String> loadData() async {
    final response = await rootBundle.loadString('assets/data/appInfo.json');
    return response;
  }


  onClear() {
    _textEditingController.text = "";
  }

  onPaste() async {
    var data = await Clipboard.getData("text/plain");
    final dateStr = data?.text ?? "";
    if (dateStr.isNotEmpty) {
      _textEditingController.text = dateStr;
    }

    onGenerate();
  }

//   onFilter() {
//     var tmp = '''
// {"code":"OK","result":[{"diseaseTypeName":null,"diseaseTypeCode":"UNKNOWN","order":0,"addressBookListOfPatients":[{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_477943852426072064","publicUserId":"477941652151521280","realName":"罗丹","sex":"W","avatar":"https://yl-oss.yljt.cn/patient_avatar.png","birthday":null,"age":29,"pyRealName":"LUODAN","pytopRealName":"L","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[],"tags":[]},{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_478530848304271360","publicUserId":"468717563210551296","realName":"尚斌斌","sex":"M","avatar":"https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/PUBLIC_USER/20230908/c42cd68fc0b743c49d3ca3551f9fcb9c.jpg","birthday":null,"age":34,"pyRealNa
// flutter: me":"SHANGBINBIN","pytopRealName":"S","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[],"tags":[]},{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_478565377928728576","publicUserId":"473861286408015872","realName":"高欢欢","sex":"W","avatar":"https://yl-oss.yljt.cn/patient_avatar.png","birthday":null,"age":26,"pyRealName":"GAOHUANHUAN","pytopRealName":"G","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[],"tags":[]},{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_482940443250659328","publicUserId":"482940424961445888","realName":"1","sex":"W","avatar":"https://yl-oss.yljt.cn/patient_avatar.png","birthday":null,"age":0,"pyRealName":"1","pytopRealName":"1","doctorName":null,"doctorId":
// flutter: null,"groupName":null,"departmentId":null,"userDiseaseTypes":[],"tags":[]}]},{"diseaseTypeName":"A001-伤寒","diseaseTypeCode":"TBWCYBX","order":65,"addressBookListOfPatients":[{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_465890253206982656","publicUserId":"72702448782905344","realName":"王小虎","sex":"M","avatar":"https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/product/20210609/77f91d617fac456cbe23981f944acde2.jpg","birthday":null,"age":36,"pyRealName":"WANGXIAOHU","pytopRealName":"W","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[{"publicuserId":"72702448782905344","diseaseTypeId":"441248466238062592","diseaseTypeCode":"2VLASF2","diseaseTypeName":"A01.401-副伤寒"},{"publicuserId":"72702448782905344","diseaseTypeId":"44124835937
// flutter: 1390976","diseaseTypeCode":"TBWCYBX","diseaseTypeName":"A001-伤寒"}],"tags":[]}]},{"diseaseTypeName":"A01.401-副伤寒","diseaseTypeCode":"2VLASF2","order":65,"addressBookListOfPatients":[{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_465890253206982656","publicUserId":"72702448782905344","realName":"王小虎","sex":"M","avatar":"https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/product/20210609/77f91d617fac456cbe23981f944acde2.jpg","birthday":null,"age":36,"pyRealName":"WANGXIAOHU","pytopRealName":"W","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[{"publicuserId":"72702448782905344","diseaseTypeId":"441248466238062592","diseaseTypeCode":"2VLASF2","diseaseTypeName":"A01.401-副伤寒"},{"publicuserId":"72702448782905344","diseaseTypeId":"4412
// flutter: 48359371390976","diseaseTypeCode":"TBWCYBX","diseaseTypeName":"A001-伤寒"}],"tags":[]}]},{"diseaseTypeName":"A00.001-哈哈啊","diseaseTypeCode":"TX9GRHI","order":65,"addressBookListOfPatients":[{"groupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_482254014032908288","publicUserId":"472810748950138880","realName":"任卢锋","sex":"M","avatar":"https://yl-oss.yljt.cn/patient_avatar.png","birthday":null,"age":27,"pyRealName":"RENLUFENG","pytopRealName":"R","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[{"publicuserId":"472810748950138880","diseaseTypeId":"482138155313283072","diseaseTypeCode":"TX9GRHI","diseaseTypeName":"A00.001-哈哈啊"}],"tags":[]}]},{"diseaseTypeName":"S82.001-髌骨骨折","diseaseTypeCode":"W0XIX4O","order":83,"addressBookListOfPatients":[{"g
// flutter: roupNo":"461136790186897408","groupId":"CONSULTATION@J@1T_482619426751647744","publicUserId":"482580691249844224","realName":"王佳琪","sex":"M","avatar":"https://yl-oss.yljt.cn/patient_avatar.png","birthday":null,"age":25,"pyRealName":"WANGJIAQI","pytopRealName":"W","doctorName":null,"doctorId":null,"groupName":null,"departmentId":null,"userDiseaseTypes":[{"publicuserId":"482580691249844224","diseaseTypeId":"482526992163160064","diseaseTypeCode":"W0XIX4O","diseaseTypeName":"S82.001-髌骨骨折"}],"tags":[]}]}],"application":"yl-yft-api","traceId":"3797089b-0727-4e4a-b3f2-6c270efce006","message":"OK"}
//     ''';
//
//     final replace = "\nflutter: ";
//     if (tmp.contains(replace)) {
//       tmp = tmp.replaceAll(replace, "");
//       _textEditingController.text = tmp;
//
//       Clipboard.setData(ClipboardData(text: tmp));
//     }
//   }


  onPressed() {
    // var tmp = "{ 'name': 'John Smith', 'age': 30, 'city': 'New York',}>";
    // // tmp = "atogeneratedBCDE";
    // var str = tmp.toUnderScoreCase();
    // debugPrint("str: $str");
    // var str1 = str.toUncamlCase();
    // debugPrint("str1: $str1");
    onGenerate();
  }

}

// extension StringExt on String{
//   /// 驼峰转下划线
//   String toUnderScoreCase() {
//     var str = this;
//     var items = str.split("");
//     for (var i = 0; i < items.length; i++) {
//       var char = items[i];
//       final isUpper = char.contains(RegExp(r'[A-Z]'));
//       // debugPrint("$char $isUpper");
//       if (isUpper) {
//         str = str.replaceFirst(char, "${i == 0 ? '' : '_'}${char.toLowerCase()}");
//       }
//     }
//     return str;
//   }
// }

