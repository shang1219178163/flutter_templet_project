//
//  AnimatedGroupDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 8:21 AM.
//  Copyright © 1/19/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

/// 混合动画回调类型
typedef AnimatedGroupBuilder = Widget Function(BuildContext context, Widget? child, List<Animation<dynamic>> animations);

class AnimatedGroup extends StatefulWidget {
  /// 混合动画
  AnimatedGroup({
    Key? key,
    this.data,
    required this.animations,
    required this.builder,
    this.controller,
    this.duration = const Duration(milliseconds: 2000),
    this.child,
  }) : super(key: key);

  /// 扩展字段(比如字符串可方便断点调试)
  dynamic data;

  /// 混合动画数组
  List<AnimatedGroupItemModel> animations;

  /// 混合动画回调
  AnimatedGroupBuilder builder;

  /// 控制器
  AnimationController? controller;

  /// AnimationController 控制的 duration 属性
  Duration? duration;

  /// 不需要多次构建的部分
  Widget? child;


  @override
  AnimatedGroupState createState() => AnimatedGroupState();
}
/// 混合动画 State
class AnimatedGroupState extends State<AnimatedGroup> with TickerProviderStateMixin {

  AnimationController? _controller;

  /// 仅限于无法满足功能时使用(透传对象, 方便二次开发)
  AnimationController get controller => _controller!;

  List<Animation<dynamic>> _animations = [];

  @override
  void initState() {
    _controller = widget.controller ?? AnimationController(duration: widget.duration, vsync: this);
    _animations = widget.animations.map((e) => e.tween.animate(_buildAnim(e.begin, e.end))).toList();

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (BuildContext context, Widget? child){
        return widget.builder(context, child, _animations);
      },
      child: widget.child,
    );
  }

  /// 开始执行动画
  ///
  /// isRemovedOnCompletion 是否单程动画
  ///
  /// isReverse 是否逆转动画
  palyeAnimations({bool isRemovedOnCompletion = true, bool isReverse = false}) async {
    try {
      if (!isReverse) {
        await _controller?.forward().orCancel;
        if (!isRemovedOnCompletion) {
          await _controller?.reverse().orCancel;
        }
      } else {
        await _controller?.reverse().orCancel;
        if (!isRemovedOnCompletion) {
          await _controller?.forward().orCancel;
        }
      }
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  /// 创建动画对象
  CurvedAnimation _buildAnim(double begin, double end) {
    return CurvedAnimation(
      parent: _controller!,
      curve: Interval(
        begin,
        end,
        curve: Curves.ease,
      ),
    );
  }

}

/// 混合动画单个动画模型
class AnimatedGroupItemModel{
  /// 混合动画单个动画模型
  AnimatedGroupItemModel({
    this.data,
    required this.tween,
    required this.begin,
    required this.end,
  });

  /// 扩展字段(比如字符串可方便断点调试)
  dynamic data;

  /// 动画 Tween
  Tween tween;

  /// 动画开始时间 (0 - 1.0)
  double begin;

  /// 动画结束时间 (0 - 1.0)
  double end;

}

// example
//
// class AnimatedGroupDemo extends StatefulWidget {
//
//   final String? title;
//
//   AnimatedGroupDemo({ Key? key, this.title}) : super(key: key);
//
//
//   @override
//   _AnimatedGroupDemoState createState() => _AnimatedGroupDemoState();
// }
//
// class _AnimatedGroupDemoState extends State<AnimatedGroupDemo> {
//
//   GlobalKey<AnimatedGroupState> _globalKey = GlobalKey();
//
//   final _animations = <AnimatedGroupItemModel>[
//     AnimatedGroupItemModel(
//         tween: Tween<double>(begin: .0, end: 300.0,),
//         begin: 0.0,
//         end: 0.6
//     ),
//     AnimatedGroupItemModel(
//         tween: ColorTween(begin: Colors.green, end: Colors.red,),
//         begin: 0.0,
//         end: 0.6
//     ),
//     AnimatedGroupItemModel(
//         tween: Tween<EdgeInsets>(
//           begin: const EdgeInsets.only(left: .0),
//           end: const EdgeInsets.only(left: 100.0),
//         ),
//         begin: 0.6,
//         end: 1.0
//     ),
//   ];
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? "$widget"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               child: Text("start animation"),
//               onPressed: (){
//                 _globalKey.currentState?.palyeAnimations(isRemovedOnCompletion: false);
//               },
//             ),
//             Container(
//               width: 300,
//               height: 300,
//               child: AnimatedGroup(
//                 key: _globalKey,
//                 duration: Duration(milliseconds: 2000),
//                 animations: _animations,
//                 child: Text("AnimatedGroupWidget 混合动画", style: TextStyle(color: Colors.white, backgroundColor: Colors.green),),
//                 builder: (BuildContext context, Widget? child, List<Animation<dynamic>> animations) {
//                   final aHeight = animations[0];
//                   final aColor = animations[1];
//                   final aPadding = animations[2];
//
//                   return Stack(
//                     children: [
//                       Container(
//                         alignment: Alignment.bottomCenter,
//                         padding: aPadding.value,
//                         child: Container(
//                           color: aColor.value,
//                           width: 50.0,
//                           height: aHeight.value,
//                         ),
//                       ),
//                       Center(child: child!)
//                     ],
//                   );
//                 },
//               ),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.1),
//                   border: Border.all(
//                     color: Colors.black.withOpacity(0.5),
//                   )
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
