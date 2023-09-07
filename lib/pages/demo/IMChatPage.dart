

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/basicWidget/im_textfield_bar.dart';
import 'package:flutter_templet_project/mixin/bottom_sheet_phrases_mixin.dart';
import 'package:flutter_templet_project/mixin/keyboard_change_mixin.dart';
import 'package:flutter_templet_project/pages/EmojiPage.dart';
import 'package:flutter_templet_project/uti/color_util.dart';
import 'package:tuple/tuple.dart';

class IMChatPage extends StatefulWidget {

  IMChatPage({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _IMChatPageState createState() => _IMChatPageState();
}

class _IMChatPageState extends State<IMChatPage> with
    SingleTickerProviderStateMixin,
    RouteAware,
    WidgetsBindingObserver,
    KeyboardChangeMixin,
    BottomSheetPhrasesMixin {

  final _scrollController = ScrollController();

  final _inputController = TextEditingController();
  final _inputChars = <String>[];

  var currentEmojiVN = ValueNotifier("");

  var dataList = ValueNotifier(<String>[]);

  late final AnimationController _controller = AnimationController(duration: Duration(milliseconds: 350), vsync: this);
  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  late final Animation<double> _heightFactor = Tween(begin: 0.0, end: 200.0).animate(_controller);
  late final Animation<double> _heightFactorNew = _controller.drive(_easeInTween);

  var isExpand = false;

  final heightVN = ValueNotifier(0.0);


  final inputBarFooterItems = <Tuple3<String, IconData, String>>[
    const Tuple3("照片", Icons.insert_photo, ""),
    const Tuple3("拍摄", Icons.photo_camera, ""),
    const Tuple3("常用语", Icons.notifications_active, ""),
    const Tuple3("五个字标题", Icons.ac_unit, ""),
    const Tuple3("位置", Icons.location_on_outlined, ""),
    const Tuple3("其他1", Icons.access_alarm, ""),
    const Tuple3("其他2", Icons.color_lens_outlined, ""),
  ];


  static final RegExp emojiReg = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    if (isExpand) {
      _controller.value = 1;
    }

    dataList.value = List.generate(20, (index) => "index_$index");
    super.initState();
  }

  final isKeyboardVisibleVN = ValueNotifier(false);

  @override
  void onKeyboardChanged(bool visible) {
    // TODO deal with keyboard visibility change.
    debugPrint("onKeyboardChanged:${visible ? "展开键盘" : "收起键盘"}");
    isKeyboardVisibleVN.value = visible;
    if (isKeyboardVisibleVN.value) {
      // isExpand.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     scrollToEdge(controller: _scrollController, isTop: false);
      //   },
      //   child: Icon(Icons.vertical_align_top),
      // ),
    );
  }

  buildBody() {
    return SafeArea(
      bottom: false,
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: dataList,
              builder: (context, list, child) {
                if (list.isEmpty) {
                  return SizedBox();
                }

                return buildRefresh(
                  onRefresh: onLoad,
                  child: ListView.separated(
                    controller: _scrollController,
                    // reverse: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final e = list[index];

                      return InkWell(
                        onTap: (){
                          debugPrint("index: ${index}, $e");
                        },
                        child: ListTile(title: Text(e),
                          subtitle: Text("index: ${index}"),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.red, height: 1,);
                    },
                  )
                );
              }
            ),
          ),
          // buildIMInputBar(
          //   heaer: Container(
          //     color: Colors.green,
          //     height: 50,
          //   ),
          //   footer: Container(
          //     color: Colors.blue,
          //     height: 300,
          //   ),
          //   // isExpand: isExpand,
          // ),
          IMTextfieldBar(
            controller: _inputController,
            onChanged: (String val) {
              debugPrint("onChanged:$val");
            },
            onSubmitted: (String val) {
              debugPrint("onSubmitted:$val");
            },
            header: Container(
              color: Colors.green,
              height: 50,
            ),
            footerBuilder: (context, event) {
              Widget child = SizedBox();
              switch (event) {
                case IMTextfieldBarEvent.add:
                  {
                    child = buildIMBarFooter(
                      cb: (index) {
                        debugPrint("cb:$index");
                          choosePhrases(
                            cb: (val) {
                              debugPrint(val.phrases ?? "-");
                            },
                            onCancel: (){
                              Navigator.of(context).pop();
                            },
                            onAdd: () {
                            debugPrint("onAdd");
                            Navigator.of(context).pop();
                          }
                        );
                      }
                    );
                  }
                  break;
                case IMTextfieldBarEvent.emoji:
                  {
                    child = Container(
                      height: 200,
                      child: EmojiPage(
                        hideAppBar: true,
                        hideSelected: true,
                        onChanged: (val) {
                          debugPrint("onChanged: ${val}");
                          // debugPrint("selection: ${_inputController.selection}");
                          // return;

                          _inputController.text += val;
                          _inputChars.add(val);
                          debugPrint("onChanged _inputController.text: ${_inputController.text}");

                          final matches = emojiReg.allMatches(_inputController.text);
                          final list = matches.map((e) => e.group(0)).where((e) => e != null).toList();
                          debugPrint("onChanged list: ${list}");
                          // debugPrint("onChanged list runes: ${list.map((e) => e!.runes.toList().toString()).join("_")}");
                          debugPrint("onChanged last length: ${list.last?.length}");

                          final lastIndex = _inputController.text.indexOf("${list.last}");
                          debugPrint("onChanged lastIndex: ${lastIndex}");
                        },
                        onDelete: (){
                          // debugPrint("onDelete: ${_inputController.text}");
                          if (_inputController.text.isEmpty) {
                            return;
                          }
                          if (!emojiReg.hasMatch(_inputController.text)) {
                            _inputController.text = _inputController.text.substring(0, _inputController.text.length - 1);
                            return;
                          }
                          final matches = emojiReg.allMatches(_inputController.text);
                          final list = matches.map((e) => e.group(0)).where((e) => e != null).whereType<String>().toList();
                          debugPrint("onChanged list: ${list}");

                          if (list.isNotEmpty && _inputController.text.endsWith(list.last)) {
                            _inputController.text = _inputController.text.substring(0, _inputController.text.length - list.last.length);
                          } else {
                            _inputController.text = _inputController.text.substring(0, _inputController.text.length - 1);
                          }
                        },
                        onSend: (val){
                          debugPrint("onSend: ${val}");

                          dataList.value = [_inputController.text, ...dataList.value];
                          _inputController.clear();
                          _inputChars.clear();


                        },
                      ),
                    );
                  }
                  break;
                default:
                  break;
              }
              return child;
            },
          ),
        ],
      )
    );
  }

  Widget buildRefresh({
    required Widget? child,
    EasyRefreshController? controller,
    FutureOr Function()? onRefresh,
    FutureOr Function()? onLoad,
  }) {
    return EasyRefresh(
      refreshOnStart: true,
      controller: controller,
      header: const ClassicHeader(
        showMessage: false,
        dragText: "下拉加载",
        armedText: "释放加载",
        readyText: "加载中...",
        processingText: "加载中...",
        processedText: "加载完成",
        noMoreText: "我可是有底线的 ~",
        failedText: "加载失败",
      ),
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }

  onLoad() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    final val = "onLoad_${dataList.value.length}";
    dataList.value = [...dataList.value, val];
  }

  // buildIMInputBar({
  //   Widget? heaer,
  //   Widget? footer,
  //   double spacing = 6,
  //   double runSpacing = 14,
  //   bool isVoice = false,
  //   // bool isExpand = false,
  // }) {
  //
  //   final textfield = NTextfield(
  //       maxLines: 3,
  //       keyboardType: TextInputType.multiline,
  //       obscureText: false,
  //       onChanged: (val) async {
  //       },
  //       onSubmitted: (val) async {
  //         debugPrint("val:${val}");
  //         dataList.value = [...dataList.value, val];
  //       },
  //   );
  //
  //   final box = GestureDetector(
  //     onLongPressStart: (details){
  //       debugPrint("onLongPressStart");
  //     },
  //     onLongPressEnd: (details){
  //       debugPrint("onLongPressEnd");
  //     },
  //     onLongPressCancel: () {
  //       debugPrint("onLongPressCancel");
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(Radius.circular(4.w)),
  //       ),
  //       child: Text("按住说话",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //             fontSize: 18.sp,
  //             fontWeight: FontWeight.bold,
  //             color: fontColor
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   return Container(
  //     color: bgColor,
  //     // padding: EdgeInsets.all(6.w),
  //     child: StatefulBuilder(
  //       builder: (context, setState) {
  //         return Column(
  //           children: [
  //             heaer ?? const SizedBox(),
  //             Padding(
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: spacing,
  //                 vertical: runSpacing,
  //               ),
  //               child: Row(
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                     child: InkWell(
  //                       onTap: () {
  //                         isVoice = !isVoice;
  //                         setState(() {});
  //                       },
  //                       child: Image(
  //                         image: "icon_voice_circle.png".toAssetImage(),
  //                         width: 30.w,
  //                         height: 30.w,
  //                         // color: color,
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: isVoice ? box : textfield,
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 6.w),
  //                     child: InkWell(
  //                       onTap: () {
  //                         isExpand = !isExpand;
  //                         if (_controller.value == _controller.upperBound) {
  //                           _controller.reverse().orCancel;
  //                         } else {
  //                           _controller.forward().orCancel;
  //                         }
  //                         setState(() {});
  //                       },
  //                       child: Image(
  //                         image: "icon_add_circle.png".toAssetImage(),
  //                         width: 30.w,
  //                         height: 30.w,
  //                         // color: color,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 6.w,),
  //                 ],
  //               ),
  //             ),
  //             // AnimatedBuilder(
  //             //   animation: _controller.view,
  //             //   builder: (context, Widget? child) {
  //             //     final bool closed = !isExpand && _controller.isDismissed;
  //             //
  //             //     return Offstage(
  //             //       offstage: closed,
  //             //       child: footer ?? const SizedBox()
  //             //     );
  //             //   },
  //             //   // child: shouldRemoveChildren ? null : result,
  //             // ),
  //             AnimatedContainer(
  //               duration: Duration(milliseconds: 350),
  //               height: _heightFactor.value,
  //               child: footer ?? const SizedBox(),
  //             ),
  //             // if (isExpand) footer ?? const SizedBox(),
  //             SizedBox(
  //               height: max(runSpacing, MediaQuery.of(context).padding.bottom),
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  buildIMBarFooter({
    int rowCount = 4,
    required ValueChanged<int> cb,
  }) {
    return Container(
      color: Color(0xe3e3e3),
      padding: EdgeInsets.only(
        top: 16.w,
        left: 16.w,
        right: 16.w,
      ),
      child: LayoutBuilder(
        builder: (context, constraints){
          final runSpacing = 16.w;

          // final spacing = 16.w;
          // final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1))/rowCount).truncateToDouble();

          final itemWidth = 64.w;
          final spacing = (constraints.maxWidth - itemWidth * rowCount) /(rowCount - 1).truncateToDouble();
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: inputBarFooterItems.map((e) {

              final i = inputBarFooterItems.indexOf(e);
              return InkWell(
                onTap: () => cb.call(i),
                child: SizedBox(
                  width: itemWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 54.w,
                        height: 54.w,
                        // padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(14.w)),
                        ),
                        child: Icon(e.item2, size: 30,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.w),
                        child: Text(e.item1,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: fontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      ),
    );
  }
}