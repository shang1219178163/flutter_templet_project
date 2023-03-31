import 'package:flutter/material.dart';

class PageLifecycleObserverDemo extends StatefulWidget {

  const PageLifecycleObserverDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _PageLifecycleObserverDemoState createState() => _PageLifecycleObserverDemoState();
}

class _PageLifecycleObserverDemoState extends State<PageLifecycleObserverDemo> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  @override
  void dispose() {
    super.dispose();
    print('YM--------dispose');
    WidgetsBinding.instance.removeObserver(this); //添加观察者
  }


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => print(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      //  应用程序处于闲置状态并且没有收到用户的输入事件。
      //注意这个状态，在切换到后台时候会触发，所以流程应该是先冻结窗口，然后停止UI
        print('YM----->AppLifecycleState.inactive');
        break;
      case AppLifecycleState.paused:
//      应用程序处于不可见状态
        print('YM----->AppLifecycleState.paused');
        break;
      case AppLifecycleState.resumed:
      //    进入应用时候不会触发该状态
      //  应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume。
        print('YM----->AppLifecycleState.resumed');
        break;
      case AppLifecycleState.detached:
      //当前页面即将退出
        print('YM----->AppLifecycleState.detached');
        break;
    }
  }

  ///当前系统改变了一些访问性活动的回调
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    print("YM-----@@@@@@@@@ didChangeAccessibilityFeatures");
  }

  ///低内存回调
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    print("YM-----@@@@@@@@@ didHaveMemoryPressure");
  }

  ///用户本地设置变化时调用，如系统语言改变
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    print("YM-----@@@@@@@@@ didChangeLocales");
  }

  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    var size = WidgetsBinding.instance.window.physicalSize;
    print("YM-----@@@@@@@@@ didChangeMetrics  ：宽：${size.width} 高：${size.height}");
  }


  @override
  Future<bool> didPopRoute() {
    print('YM--------didPopRoute');//页面弹出
    return Future.value(false);//true为拦截，false不拦截
  }

  @override
  Future<bool> didPushRoute(String route) {
    print('YM--------PushRoute');
    return Future.value(true);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    print('YM--------didPushRouteInformation');
    return Future.value(true);
  }

  //文字大小改变时候的监听
  @override
  void didChangeTextScaleFactor() {
    print("YM--------@@@@@@@@@ didChangeTextScaleFactor  ：${WidgetsBinding.instance.window.textScaleFactor}");
  }

  @override
  void didChangePlatformBrightness() {
    final window = WidgetsBinding.instance.window;
    final brightness = window.platformBrightness;
    // Brightness.light 亮色
    // Brightness.dark 暗色
    print('YM----平台主题改变----didChangePlatformBrightness$brightness');
    // window.onPlatformBrightnessChanged = () {
    //   // This callback gets invoked every time brightness changes
    //   final brightness = window.platformBrightness;
    //   print('YM----平台亮度改变----didChangePlatformBrightness$brightness');
    // };
  }
}