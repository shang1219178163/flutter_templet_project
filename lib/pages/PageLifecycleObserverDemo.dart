import 'package:flutter/material.dart';

class PageLifecycleObserverDemo extends StatefulWidget {

  const PageLifecycleObserverDemo({
    Key? key, 
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _PageLifecycleObserverDemoState createState() => _PageLifecycleObserverDemoState();
}

class _PageLifecycleObserverDemoState extends State<PageLifecycleObserverDemo> with WidgetsBindingObserver{

  @override
  void dispose() {
    super.dispose();
    debugPrint('$widget dispose');
    WidgetsBinding.instance.removeObserver(this); //添加观察者
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  //可以获取 widget 最新属性值和之前的属性值
  @override
  void didUpdateWidget(PageLifecycleObserverDemo oldWidget){
    super.didUpdateWidget(oldWidget);
    debugPrint("$widget didUpdateWidget:${widget.title}");
  }


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    debugPrint("$widget build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e.toString()),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Text(arguments.toString(),)
    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      //  应用程序处于闲置状态并且没有收到用户的输入事件。
      //注意这个状态，在切换到后台时候会触发，所以流程应该是先冻结窗口，然后停止UI
        debugPrint('YM----->AppLifecycleState.inactive');
        break;
      case AppLifecycleState.paused:
//      应用程序处于不可见状态
        debugPrint('YM----->AppLifecycleState.paused');
        break;
      case AppLifecycleState.resumed:
      //    进入应用时候不会触发该状态
      //  应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume。
        debugPrint('YM----->AppLifecycleState.resumed');
        break;
      case AppLifecycleState.detached:
      //当前页面即将退出
        debugPrint('YM----->AppLifecycleState.detached');
        break;
      case AppLifecycleState.hidden:
      //当前页面即将隐藏
        debugPrint('YM----->AppLifecycleState.hidden');
        break;
    }
  }

  ///当前系统改变了一些访问性活动的回调
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    debugPrint("$widget didChangeAccessibilityFeatures");
  }

  ///低内存回调
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    debugPrint("$widget didHaveMemoryPressure");
  }

  ///用户本地设置变化时调用，如系统语言改变
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    debugPrint("$widget didChangeLocales");
  }

  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    var size = WidgetsBinding.instance.window.physicalSize;
    debugPrint("$widget didChangeMetrics  ：宽：${size.width} 高：${size.height}");
  }


  @override
  Future<bool> didPopRoute() {
    debugPrint('$widget didPopRoute');//页面弹出
    return Future.value(false);//true为拦截，false不拦截
  }

  @override
  Future<bool> didPushRoute(String route) {
    debugPrint('$widget PushRoute');
    return Future.value(true);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    debugPrint('$widget didPushRouteInformation');
    return Future.value(true);
  }

  //文字大小改变时候的监听
  @override
  void didChangeTextScaleFactor() {
    debugPrint("$widget didChangeTextScaleFactor：${WidgetsBinding.instance.window.textScaleFactor}");
  }

  @override
  void didChangePlatformBrightness() {
    final window = WidgetsBinding.instance.window;
    final brightness = window.platformBrightness;
    // Brightness.light 亮色
    // Brightness.dark 暗色
    debugPrint('$widget didChangePlatformBrightness$brightness');
    // window.onPlatformBrightnessChanged = () {
    //   // This callback gets invoked every time brightness changes
    //   final brightness = window.platformBrightness;
    //   print('YM----平台亮度改变----didChangePlatformBrightness$brightness');
    // };
  }
}