

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';
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

class _IMChatPageState extends State<IMChatPage> with SingleTickerProviderStateMixin {

  final _scrollController = ScrollController();

  var dataList = ValueNotifier(<String>[]);

  late final AnimationController _controller = AnimationController(duration: Duration(milliseconds: 350), vsync: this);
  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  late final Animation<double> _heightFactor = Tween(begin: 0.0, end: 300.0).animate(_controller);
  late final Animation<double> _heightFactorNew = _controller.drive(_easeInTween);

  var isExpand = false;

  final heightVN = ValueNotifier(0.0);

  @override
  void initState() {
    // TODO: implement initState
    if (isExpand) {
      _controller.value = 1;
    }

    dataList.value = List.generate(20, (index) => "index_$index");
    super.initState();
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
                  child: ListView.separated(
                    controller: _scrollController,
                    // reverse: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final e = list[index];

                      return InkWell(
                        onTap: (){
                          debugPrint("index: ${index}");
                        },
                        child: ListTile(title: Text("index: ${index}"),),
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
          buildIMInputBar(
            heaer: Container(
              color: Colors.green,
              height: 50,
            ),
            footer: Container(
              color: Colors.blue,
              height: 300,
            ),
            // isExpand: isExpand,
          ),
          buildTextField()
        ],
      )
    );
  }

  Widget buildRefresh({
    required Widget? child,
    EasyRefreshController? controller,
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
      onRefresh: onLoad,
      // onLoad: ,
      child: child,
    );
  }

  onLoad() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    final val = "onLoad_${dataList.value.length}";
    dataList.value = [...dataList.value, val];
  }

  buildIMInputBar({
    Widget? heaer,
    Widget? footer,
    double spacing = 6,
    double runSpacing = 14,
    bool isVoice = false,
    // bool isExpand = false,
  }) {

    final textfield = Container(
      constraints: BoxConstraints(
        maxHeight: 144.0,
        // maxWidth: _screenWidth(),
        // minHeight: 48.0,
        // minWidth: _screenWidth()
      ),
      child: NTextfield(
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        obscureText: false,
        onChanged: (val) async {
        },
        onSubmitted: (val) async {
          debugPrint("val:${val}");
          dataList.value = [...dataList.value, val];
        },
      ),
    );

    final box = GestureDetector(
      onLongPressStart: (details){
        debugPrint("onLongPressStart");
      },
      onLongPressEnd: (details){
        debugPrint("onLongPressEnd");
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("按住说话",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: fontColor
          ),
        ),
      ),
    );

    return Container(
      color: bgColor,
      // padding: EdgeInsets.all(6.w),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              heaer ?? const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing,
                  vertical: runSpacing,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: IconButton(
                        onPressed: () {
                          isVoice = !isVoice;
                          setState(() {});
                        },
                        icon: Image(
                          image: "icon_voice.png".toAssetImage(),
                          width: 30.w,
                          height: 30.w,
                          // color: color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: isVoice ? box : textfield,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          isExpand = !isExpand;
                          if (_controller.value == _controller.upperBound) {
                            _controller.reverse().orCancel;
                          } else {
                            _controller.forward().orCancel;
                          }
                          setState(() {});
                        },
                        icon: Image(
                          image: "icon_add_circle.png".toAssetImage(),
                          width: 30.w,
                          height: 30.w,
                          // color: color,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w,),
                  ],
                ),
              ),
              // AnimatedBuilder(
              //   animation: _controller.view,
              //   builder: (context, Widget? child) {
              //     final bool closed = !isExpand && _controller.isDismissed;
              //
              //     return Offstage(
              //       offstage: closed,
              //       child: footer ?? const SizedBox()
              //     );
              //   },
              //   // child: shouldRemoveChildren ? null : result,
              // ),
              AnimatedContainer(
                duration: Duration(milliseconds: 350),
                height: _heightFactor.value,
                child: footer ?? const SizedBox(),
              ),
              // if (isExpand) footer ?? const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  buildTextField() {
    return Container(
      color: Colors.red,
      constraints: BoxConstraints(
          maxHeight: 144.0,
          // maxWidth: _screenWidth(),
          minHeight: 48.0,
          // minWidth: _screenWidth()
      ),
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, top: 8.0, bottom: 4.0),
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration.collapsed(
          hintText: "Write a comment",
        ),
      ),
    );
  }
}