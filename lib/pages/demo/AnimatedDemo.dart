//
//  AnimatedDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/22/21 5:44 PM.
//  Copyright © 6/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_color_flash_anim.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition.dart';
import 'package:flutter_templet_project/pages/demo/AnimatedSwitcherDemo.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class AnimatedDemo extends StatefulWidget {
  String? title;

  AnimatedDemo({Key? key, this.title}) : super(key: key);

  @override
  _AnimatedDemoState createState() => _AnimatedDemoState();
}

class _AnimatedDemoState extends State<AnimatedDemo> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  );

  final colorController = NColorFlashAnimController();
  final colorControllerOne = NColorFlashAnimController();

  double size = 100;
  final isLoading = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildPageView(),
    );
  }

  Widget _buildPageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      onPageChanged: (index) {
        debugPrint('当前为第$index页');
        setState(() {
          widget.title = '当前为第$index页';
        });
      },
      children: <Widget>[
        _buildTweenAnimationBuilder(),
        buildColorFlashAnim(),
        _buildPausePlayIcon(),
        _buildAnimatedSizeIcon(),
        _buildAnimatedCrossFade(),
        _buildAnimatedScale(),
        _buildAnimatedNSlideTransition(),
        _buildAnimatedLineSlideTransition(),
        Container(
          color: Colors.red,
          child: Center(child: Text('第0页')),
        ),
        Container(
          color: Colors.yellow,
          child: Center(child: Text('第1页')),
        ),
        Container(
          color: Theme.of(context).primaryColor,
          child: Center(child: Text('第2页')),
        ),
      ],
    );
  }

  Widget buildColorFlashAnim() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NColorFlashAnim(
              controller: colorController,
              builder: (animationController, animation) {
                return AnimatedBuilder(
                  animation: animationController,
                  child: GestureDetector(
                    onTap: colorController.startAnim,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                      ),
                      child: Text("ColorAnim"),
                    ),
                  ),
                  builder: (_, child) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: animation.value ?? Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: child ?? SizedBox(),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: NColorFlashAnim(
              controller: colorControllerOne,
              builder: (animationController, animation) {
                return AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) {
                    return GestureDetector(
                      onTap: colorControllerOne.startAnim,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: animation.value,
                          // border: Border.all(
                          //   color: animation.value ?? Colors.transparent,
                          //   width: 3,
                          // ),
                        ),
                        child: Text(
                          "ColorAnimOne",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///播放按钮组件
  Widget _buildPausePlayIcon() {
    return Center(
      child: InkWell(
        onTap: () {
          DLog.d("AnimatedIcon");
          if (_controller.status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (_controller.status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedIcon(
              icon: AnimatedIcons.pause_play,
              progress: _controller,
              size: 35,
            ),
            Text("AnimatedIcon"),
          ],
        ),
      ),
    );
  }

  ///缩放组件
  Widget _buildAnimatedSizeIcon() {
    return GestureDetector(
      onTap: () {
        DLog.d("AnimatedSize");
        setState(() {
          size = size == 100 ? 200 : 100;
        });
      },
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 350),
                child: FlutterLogo(
                  size: size,
                ),
              ),
              Text("AnimatedSize"),
            ],
          ),
        ),
      ),
    );
  }

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  ///播放按钮组件
  Widget _buildAnimatedCrossFade() {
    return Center(
      child: InkWell(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedCrossFade(
                crossFadeState: _crossFadeState,
                duration: Duration(milliseconds: 2),
                firstChild: Icon(
                  Icons.text_rotate_up,
                  size: 150,
                  color: Colors.green,
                ),
                secondChild: Icon(Icons.text_rotate_vertical, size: 150),
              ),
              Text("AnimatedCrossFade"),
              Text("$_crossFadeState"),
            ],
          ),
        ),
        onTap: () {
          DLog.d("AnimatedCrossFade");
          setState(() {
            _crossFadeState =
                _crossFadeState == CrossFadeState.showFirst ? CrossFadeState.showSecond : CrossFadeState.showFirst;
          });
        },
      ),
    );
  }

  int _count = 0;

  Widget _buildAnimatedScale() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("ScaleTransition"),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              //执行缩放动画
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Text(
              '$_count',
              //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
              key: ValueKey<int>(_count),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          OutlinedButton(
            onPressed: () {
              DLog.d("AnimatedSwitcher");

              setState(() {
                _count += 1;
              });
            },
            child: Text(
              '+1',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedNSlideTransition() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("NSlideTransition"),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return NSlideTransition(
                direction: AxisDirection.up, //上入下出
                position: animation,
                child: child,
              );
            },
            child: Text(
              '$_count',
              //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
              key: ValueKey<int>(_count),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          OutlinedButton(
            onPressed: () {
              DLog.d("AnimatedSwitcher");

              setState(() {
                _count += 1;
              });
            },
            child: Text(
              '+1',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLineSlideTransition() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("LineSlideTransition"),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final tween = Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset(0, 0),
              );
              return LineSlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            child: Text(
              '$_count',
              //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
              key: ValueKey<int>(_count),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          OutlinedButton(
            onPressed: () {
              DLog.d("AnimatedSwitcher");

              setState(() {
                _count += 1;
              });
            },
            child: Text(
              '+1',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTweenAnimationBuilder() {
    final duration = const Duration(milliseconds: 1300);
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.3, end: 1.0),
        duration: duration,
        builder: (_, value, child) {
          return AnimatedOpacity(
            duration: duration,
            opacity: value,
            child: Transform.rotate(
              angle: value * 2 * 3.1415926, // 360°
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            ),
          );
        },
        child: OutlinedButton(
          onPressed: () {
            debugPrint([widget, 'TweenAnimationBuilder'].join(", "));
          },
          child: Text('TweenAnimationBuilder'),
        ),
      ),
    );
  }

  Widget _buildNTweenAnimationBuilder() {
    final duration = const Duration(milliseconds: 1300);
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.3, end: 1.0),
        duration: duration,
        builder: (_, value, child) {
          return AnimatedOpacity(
            duration: duration,
            opacity: value,
            child: Transform.rotate(
              angle: value * 2 * 3.1415926, // 360°
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            ),
          );
        },
        child: OutlinedButton(
          onPressed: () {
            debugPrint([widget, 'TweenAnimationBuilder'].join(", "));
          },
          child: Text('TweenAnimationBuilder'),
        ),
      ),
    );
  }
}
