

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_long_press_menu.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_target_follower.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/editable_text_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/basicWidget/im_textfield_bar.dart';
import 'package:flutter_templet_project/mixin/bottom_sheet_phrases_mixin.dart';
import 'package:flutter_templet_project/mixin/keyboard_change_mixin.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';
import 'package:flutter_templet_project/pages/demo/EmojiPage.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
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
    SafeSetStateMixin,
    BottomSheetPhrasesMixin {

  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  final _inputController = TextEditingController();

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

  /// 长按菜单专用
  final List<OverlayEntry> longPressEntries = [];

  final isKeyboardVisibleVN = ValueNotifier(false);

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (isExpand) {
      _controller.value = 1;
    }

    initData();
  }

  @override
  void onKeyboardChanged(bool visible) {
    // TODO deal with keyboard visibility change.
    debugPrint("onKeyboardChanged:${visible ? "展开键盘" : "收起键盘"}");
    isKeyboardVisibleVN.value = visible;
    if (isKeyboardVisibleVN.value) {
      // isExpand.value = false;
    }
  }

  initData(){
    dataList.value = List.generate(20, (index) => "index_$index");
  }

  @override
  Widget build(BuildContext context) {
    // _controller.forward();
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: hideApp ? null : AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            debugPrint(e);
            setState(() {});
          }),).toList(),
        elevation: 0,
        // bottom: buildAppbarBottom(),
      ),
      body: buildBody(),
      // body: buildListView(),
      // bottomSheet: buildInputBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     scrollToEdge(controller: _scrollController, isTop: false);
      //   },
      //   child: Icon(Icons.vertical_align_top),
      // ),
    );
  }

  PreferredSize buildAppbarBottom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: ValueListenableBuilder<List<String>>(
          valueListenable: dataList,
          builder: (context,  value, child){

            // if (value.length < 3) {
            //   return SizedBox();
            // }
            return Container(
              width: double.maxFinite,
              height: 48,
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor,
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0.w)),
              ),
              alignment: Alignment.center,
              child: Text("${value.length}条数据"),
            );
          }
      ),
    );
  }

  buildBody() {
    return SafeArea(
      // bottom: false,
      child: Column(
        children: [
          buildTips1(tips: "患者暂未购买问诊服务"),
          buildTips2(tips: "患者暂未购买问诊服务"),
          Expanded(
            // flex: 1,
            child: buildListView(),
          ),
          buildInputBar(),
        ],
      )
    );
  }

  Widget buildListView() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: dataList,
      builder: (context, list, child) {
        if (list.isEmpty) {
          return SizedBox();
        }

        return buildRefresh(
          onRefresh: onLoad,
          // onLoad: onRefresh,
          child: MediaQuery.removePadding(
            removeTop: true,
            removeBottom: true,
            context: context,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint("onTap");
              },
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  // physics: ClampingScrollPhysics(),
                  // cacheExtent: 600,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final e = list[index];

                    final isOwner = index %2 == 0;
                    return InkWell(
                      onTap: (){
                        debugPrint("index: ${index}, $e");
                      },
                      child: buildChatCell(
                        modelIndex: index,
                        imgUrl: R.image.urls[IntExt.random(max: R.image.urls.length, )],
                        isOwner: isOwner,
                        name: "路人甲",
                        title: "title",
                        contentChild: buildContentChild(
                          modelIndex: index,
                          isOwner: isOwner,
                          // text: "buildContentChild",
                          text: "聊一会" * IntExt.random(min: 1, max: 6,),
                        ),
                      ),
                      // child: ListTile(title: Text(e),
                      //   subtitle: Text("index: ${index}"),
                      // ),
                    );
                  },
                ),
              ),
            ),
          )
        );
      }
    );
  }

  Widget buildChatCell({
    required int modelIndex,
    required bool isOwner,
    required String imgUrl,
    required String name,
    String title = "",
    String extra = "",
    String time = "",
    double spacing = 16,
    double runSpacing = 12,
    double imgSize = 40,
    double imgGap = 10,
    Widget? contentChild,
  }) {
    // if (model.restructureMsgBody?.contains("inviteID") == true) {
    //   final dataSignalModel = model.restructureMsgBodyFirst?.msgContent?.dataSignalModel;
    //   final dataSignalDataModel = model.restructureMsgBodyFirst?.msgContent?.dataSignalDataModel;
    //   debugPrint("$dataSignalModel$dataSignalDataModel");
    // }
    final contentBgColor = isOwner ? primaryColor : bgColor;
    final contentFontColor = Colors.white;

    var contentWidget = contentChild ??
        Container(
          color: contentBgColor,
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: NText(
            "--" * 3,
            fontSize: 14,
            color: contentFontColor,
            maxLines: 100,
          ),
        );

    return Container(
      // color: ColorExt.random,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
            Container(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: NText(
                "${DateTime.now().toString().substring(0, 19)}",
                color: Colors.black.withOpacity(0.5),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: Opacity(
                  opacity: !isOwner ? 1 : 0,
                  child: InkWell(
                    onTap: () {

                    },
                    child: NNetworkImage(
                      url: imgUrl,
                      width: imgSize,
                      height: imgSize,
                      radius: 5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (!isOwner)
                      Container(
                        padding: const EdgeInsets.only(left: 4, bottom: 4),
                        child: NText(
                          name,
                          fontSize: 13,
                          maxLines: 100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    contentWidget,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Opacity(
                  opacity: isOwner ? 1 : 0,
                  child: NNetworkImage(
                    url: imgUrl,
                    width: imgSize,
                    height: imgSize,
                    radius: 5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildContentChild({
    required int modelIndex,
    required bool isOwner,
    required String text,
  }) {
    final contentBgColor = Colors.green;
    final contentFontColor = Colors.white;

    double bottomRightRadius = isOwner != true ? 8 : 0;
    double bottomLeftRadius = isOwner == true ? 8 : 0;

    final borderRadius = BorderRadius.circular(4);

    Widget child = buildTextChild(
      text: text,
      isOwner: true,
      borderRadius: borderRadius,
      contentBgColor: contentBgColor,
      contentFontColor: contentFontColor,
    );


    late final menueItems = <Tuple2<String, String>>[
      Tuple2("复制", "icon_copy.png",),
      Tuple2("引用", "icon_quote.png",),
      Tuple2("撤回", "icon_revoke.png",),
    ];

    if (menueItems.isEmpty) {
      return child;
    }

    child = NTargetFollower(
        targetAnchor: isOwner ? Alignment.topRight : Alignment.topLeft,
        followerAnchor: isOwner ? Alignment.bottomRight : Alignment.bottomLeft,
        // targetAnchor: isOwner ? Alignment.topCenter : Alignment.topCenter,
        // followerAnchor: isOwner ? Alignment.bottomCenter : Alignment.bottomCenter,
        entries: longPressEntries,
        offset: Offset(0, -8),
        onLongPressEnd: (e) {
          // 勿删
        },
        target: child,
        followerBuilder: (context, onHide) {
          // debugPrint("${DateTime.now()} followerBuilder:");
          return TapRegion(
            onTapInside: (tap) {
              debugPrint('On Tap Inside!!');
            },
            onTapOutside: (tap) {
              debugPrint('On Tap Outside!!');
              onHide();
            },
            child: NLongPressMenu(
              items: menueItems.map((e) => Tuple2(e.item1, e.item2.toAssetImage())).toList(),
              onItem: (Tuple2<String, AssetImage> t) {
                onHide();
                debugPrint("onChanged_$t");
                ToastUtil.show(t.item1);
              }
            ),
          );
        }
    );
    return child;
  }


  Widget buildCellChild({
    required bool? isOwner,
    Widget? image,
    required String? text,
    Color? contentBgColor,
    Color? contentFontColor,
    BorderRadius? borderRadius,
  }) {
    // String? text = model.restructureMsgBodyFirst?.msgContent?.text;
    // final contentBgColor = isOwner == true ? primary : bgColor;
    // final contentFontColor = isOwner == true ? Colors.white : fontColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      constraints: const BoxConstraints(minHeight: 37),
      margin: isOwner == true ? const EdgeInsets.only(right: 6) : const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: contentBgColor,
        borderRadius: borderRadius,
      ),
      // constraints: BoxConstraints().loosen(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOwner != true && image != null) image,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: NText(
                text ?? "",
              // textAlign: TextAlign.right,
                fontSize: 15,
                color: contentFontColor,
                maxLines: 100,
                fontWeight: FontWeight.w500
            ),
          ),
          if (isOwner == true && image != null) image,
        ],
      ),
    );
  }

  Widget buildTextChild({
    required String? text,
    required bool isOwner,
    Color? contentBgColor,
    Color? contentFontColor,
    BorderRadius? borderRadius,
  }) {
    // String? text = model.restructureMsgBodyFirst?.msgContent?.text;
    if (text == null) {
      return const SizedBox();
    }
    // final contentBgColor = isOwner == true ? primary : bgColor;
    // final contentFontColor = isOwner == true ? Colors.white : fontColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: contentBgColor,
        borderRadius: borderRadius,
      ),
      margin: isOwner ? const EdgeInsets.only(right: 6) : const EdgeInsets.only(left: 6),
      constraints: const BoxConstraints(minHeight: 37),
      // constraints: BoxConstraints().loosen(),
      child: NText(
        text,
        // textAlign: TextAlign.right,
        fontSize: 16,
        color: contentFontColor,
        maxLines: 100,
      ),
    );
  }

  Widget buildInputBar() {
    return IMTextfieldBar(
      controller: _inputController,
      onChanged: (String val) {
        debugPrint("onChanged:$val");
      },
      onSubmitted: (String val) {
        debugPrint("onSubmitted:$val");
      },
      // header: Container(
      //   color: Colors.green,
      //   height: 50,
      // ),
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
                    _inputController.text += val;
                    debugPrint("onChanged _inputController.text: ${_inputController.text}");

                    _inputController.moveCursorEnd();
                  },
                  onDelete: () {
                    // debugPrint("onDelete: ${_inputController.text}");
                    // final baseOffset = _inputController.selection.baseOffset;
                    // debugPrint("baseOffset: ${baseOffset}");

                    _inputController.deleteChar();

                    debugPrint("_inputController.text: ${_inputController.text}");
                  },
                  onSend: (val){
                    debugPrint("onSend: ${val}");
                    if (_inputController.text.trim().isEmpty) {
                      return;
                    }

                    dataList.value = [_inputController.text, ...dataList.value];
                    _inputController.clear();
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
    );
  }

  Widget buildRefresh({
    required Widget child,
    EasyRefreshController? controller,
    FutureOr Function()? onRefresh,
    FutureOr Function()? onLoad,
  }) {
    // return child;
    return EasyRefresh(
      refreshOnStart: true,
      controller: controller,
      clipBehavior: Clip.none,
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

  onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    initData();
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

  /// 问诊倒计时显示器 Widget
  Widget buildTips1({
    required String? tips,
  }) {
    Widget child = Container(
      height: 44,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 17, right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xffe5e5e5),
            ),
          ),
          Container(
            height: 32,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 17, right: 7),
            decoration: BoxDecoration(
              color: const Color(0xffEBF8F8),
              borderRadius: BorderRadius.circular(18), //边角
            ),
            child: NText(
              tips ?? "这是一个提示",
              fontSize: 13,
              color: context.primaryColor,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xffe5e5e5),
            ),
          ),
        ],
      ),
    );
    return child;
  }

  /// 问诊倒计时显示器 Widget
  Widget buildTips2({
    required String? tips,
  }) {
    Widget child = Container(
      height: 44,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffFFF4EB),
              borderRadius: BorderRadius.circular(8), //边角
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Image(
                    image: "icon_hi.png".toAssetImage(),
                    width: 35,
                    height: 42,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 16),
                  child: NText(
                    tips ?? "这是一个提示",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffFF8F3E),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
    return child;
  }
}