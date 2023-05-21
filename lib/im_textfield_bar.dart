


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';

class IMTextfieldBar extends StatefulWidget {

  IMTextfieldBar({
    Key? key,
    required this.onSubmitted,
    this.title,
    this.heaer,
    this.footer,
    this.spacing = 6,
    this.runSpacing = 14,
    this.isVoice = false,
  }) : super(key: key);

  final String? title;
  final ValueChanged<String>? onSubmitted;

  Widget? heaer;
  Widget? footer;
  double spacing;
  double runSpacing;
  bool isVoice;

  @override
  _IMTextfieldBarState createState() => _IMTextfieldBarState();
}

class _IMTextfieldBarState extends State<IMTextfieldBar> with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(duration: Duration(milliseconds: 350), vsync: this);
  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  late final Animation<double> _heightFactor = Tween(begin: 0.0, end: 260.0).animate(_controller);

  var isExpand = false;
  late var isVoice = widget.isVoice ?? false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isExpand) {
      _controller.value = 1;
    }
    _controller.forward().orCancel;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final textfield = NTextfield(
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      obscureText: false,
      onChanged: (val) async {
      },
      onSubmitted: widget.onSubmitted,
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
              widget.heaer ?? const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.spacing,
                  vertical: widget.runSpacing,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: InkWell(
                        onTap: () {
                          isVoice = !isVoice;
                          setState(() {});
                        },
                        child: Image(
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
                      child: InkWell(
                        onTap: () {
                          // isExpand = !isExpand;
                          if (_controller.value == _controller.lowerBound) {
                            _controller.forward().orCancel;
                          } else {
                            _controller.reverse().orCancel;
                          }
                          setState(() {});
                        },
                        child: Image(
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
                child: widget.footer ?? const SizedBox(),
              ),
              // if (isExpand) footer ?? const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}