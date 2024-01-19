//
//  Main.dart
//  flutter_templet_project
//
//  Created by shang on 3/13/23 4:07 PM.
//  Copyright © 3/13/23 shang. All rights reserved.
//



import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http_proxy/http_proxy.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/pages/demo/CalendarDatePickerDemo.dart';
import 'package:flutter_templet_project/pages/demo/TabBarDemo.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:flutter_templet_project/provider/provider_demo.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:flutter_templet_project/provider/rxDart_provider_demo.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/routes/AppRouteObserver.dart';
import 'package:flutter_templet_project/util/app_util.dart';
import 'package:flutter_templet_project/util/localizations/AppCupertinoLocalizations.dart';
import 'package:flutter_templet_project/util/localizations/ZhCupertinoLocalizations.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/Pages/APPDrawerMenuPage.dart';
import 'package:flutter_templet_project/Pages/APPUserCenterPage.dart';

import 'package:flutter_templet_project/basicWidget/error_custom_widget.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';

import 'package:flutter_templet_project/provider/notifier_demo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


// void main() {
//   runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await myErrorsHandler.initialize();
//     FlutterError.onError = (FlutterErrorDetails details) {
//       FlutterError.presentError(details);
//       myErrorsHandler.onError(details);
//       exit(1);
//     };
//     runApp(MyApp());
//   }, (Object error, StackTrace stack) {
//     myErrorsHandler.onError(error, stack);
//     exit(1);
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// That's all done.You can use Charles or other proxy tools now.
  // final httpProxy = await HttpProxy.createHttpProxy();
  // HttpOverrides.global = httpProxy;

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {
      // empty debugPrint implementation in the release mode
    };
  }
  await ScreenUtil.ensureScreenSize();
  await CacheService().init();

  setCustomErrorPage();
  await initServices();
  await initDebugInfo();
  // AppInit.catchException(() => runApp(MyApp()));
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: ColorFilteredProvider()),
        ChangeNotifierProvider(create: (context) => ColorFilteredProvider()),

        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider<Person>(create: (ctx) => Person(),),
        ChangeNotifierProvider<Foo>(create: (ctx) => Foo(),),
        Provider(create: (context) => CounterBloc()),
        ProxyProvider<Person, EatModel>(
          update: (ctx, person, eatModel) => EatModel(name: person.name),
        ),
      ],
      child: MyApp(),
    ),
  );

  var systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

void setCustomErrorPage(){
  // FlutterError.onError = (details) {
  //   FlutterError.presentError(details);
  // };

  ErrorWidget.builder = (FlutterErrorDetails details){
    debugPrint("flutterErrorDetails:${details.toString()}");
    return ErrorCustomWidget(details: details);
  };
}

Future<void> initServices() async {
  debugPrint('starting services ...');
  // await Get.putAsync(() => GlobalConfigService().init());
  // await Get.putAsync(SettingsService()).init();
  debugPrint('All services started...');
}

Future<void> initDebugInfo() async {
  ///向Timeline事件中添加每个widget的build信息
  debugProfileBuildsEnabled = true;
  ///向timeline事件中添加每个renderObject的paint信息
  // debugProfilePaintsEnabled = true;
  // ///每个layer会出现一个边框,帮助区分layer层级
  // debugPaintLayerBordersEnabled = true;
  // ///打印标记为dirty的widgets
  // debugPrintRebuildDirtyWidgets = true;
  // ///打印标记为dirty的renderObjects
  // debugPrintLayouts = true;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your aptplication.

  @override
  Widget build(BuildContext context) {
    final app = GetMaterialApp(
      popGesture: true,//swipe back
      navigatorKey: AppUtil.navigatorKey,
      title: 'Flutter Templet',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh'),
      localizationsDelegates: [
        // AppCupertinoLocalizations.delegate,
        // ZhCupertinoLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CH')],
      theme: APPThemeService().themeData,
      // darkTheme: APPThemeSettings.instance.darkThemeData,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      // initialRoute: "/MyHomePage",
      // routes: kRoutes,
      initialRoute: AppPage.INITIAL,
      getPages: AppPage.routes,
      unknownRoute: AppPage.unknownRoute,
      navigatorObservers: [AppRouteObserver().routeObserver],
      routingCallback: AppRouteObserver().routingCallback ?? (routing) {
        // if (routing != null) {
        //   ddlog([routing.previous, routing.current]);
        // }
      },
      // routes: {
    //     "/": (context) => MyHomePage(),
    //     "/TwoPage": (context) => TwoPage(),
    //   },
      builder: EasyLoading.init(),
    );

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {

        return TooltipVisibility(
          visible: false,// 关闭返回按钮长按 tooltip
          child: app,
        );
      }
    );
    //全局置灰
    // return Consumer<ColorFilteredProvider>(
    //   builder: (BuildContext context, provider, Widget? child) {
    //     return ColorFiltered(
    //       colorFilter: ColorFilter.mode(provider.color, BlendMode.color),
    //       child: app,
    //     );
    //   },
    // );
  }
}

final kScaffoldKey = GlobalKey<ScaffoldState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  final unreadVN = ValueNotifier(0);

  final List<Tuple2<Tuple2<String, Widget>, Widget>> items = [
    Tuple2(
      Tuple2("首页", Icon(Icons.home),),
      TabBarTabBarViewDemo(),
    ),
    Tuple2(
      Tuple2("按钮", Icon(Icons.merge_type_sharp),),
      SecondPage(),
    ),
    Tuple2(
      Tuple2("消息", Icon(Icons.message),),
      TabBarDemo(initialIndex: 3,),
    ),
    Tuple2(
      Tuple2("购物车", Icon(Icons.shopping_cart),),
      ThirdPage(),
    ),
    Tuple2(
      Tuple2("个人中心", Icon(Icons.person),),
      APPUserCenterPage(),
    ),
  ];


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    getPackageInfo().then((value){
      CacheService().setString(CACHE_APP_NAME, value.appName);
      CacheService().setString(CACHE_APP_PACKAGE_NAME, value.packageName);
      CacheService().setString(CACHE_APP_VERSION, value.version);
    });

    configRefresh();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final page = Scaffold(
      key: kScaffoldKey,
      // drawer: MyDrawer(),
      drawer: APPDrawerMenuPage(),
      endDrawer: APPDrawerMenuPage(),
      // appBar: buildAppBar(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // canvasColor: Colors.red,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedFontSize: 10.sp, // 选中字体大小
          unselectedFontSize: 10.sp, // 未选中字体大小
          selectedItemColor: context.primaryColor,
          onTap: (index) => _onBarTap(index),
          items: items.map((e) => BottomNavigationBarItem(
            tooltip: '', // 去除长按文字提示
            label: e.item1.item1,
            icon: ValueListenableBuilder<int>(
              valueListenable: unreadVN,
              builder: (context, badge, child){

                return buildIcon(
                  title: e.item1.item1,
                  normalIcon: e.item1.item2,
                  activeIcon: e.item1.item2,
                  badge: badge,
                );
              }
            ),
          ),).toList(),
        ),
      ),
      body: items.map((e) => e.item2).toList()[currentIndex],
      // body: PageView(onPageChanged: (index){
      //     _changePage(index);
      //   },
      //     children: pages,
      // ),
    );
    return Consumer<ColorFilteredProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        //仅首页置灰
        return ColorFiltered(
          colorFilter: ColorFilter.mode(provider.color, BlendMode.color),
          child: page,
        );
      },
    );
  }

  ///创建导航栏
  AppBar buildAppBar(){
    return AppBar(
      title: Text(widget.title ?? "标题"),
      leading: Icon(Icons.arrow_back),
      actions: [
        PopupMenuButtonExt.fromEntryJson(
            json: {"aa": "0",
              "bb": "1",
              "cc": "2"},
            checkedString: "aa",
            callback: (value) {
              setState(() => ddlog(value));
            }),
        PopupMenuButtonExt.fromCheckList(
            list: ["a", "b", "c"],
            checkedIdx: 1,
            callback: (value) {
              setState(() => ddlog(value));
            }),
      ],
    );
  }

  Widget buildIcon({
    required String title,
    required Widget normalIcon,
    required Widget activeIcon,
    int badge = 0,
  }) {

    if (badge > 99) {
      badge = 99;
    }

    final badgeChild = title != "消息" || badge == 0 ? SizedBox() : Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: const ShapeDecoration(
        color: Colors.red,
        shape: StadiumBorder(),
      ),
      child: Text("$badge",
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white,
        ),),
    );

    final icon = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          normalIcon,
          Positioned(  // draw a red marble
            top: -5,
            right: -5,
            child: badgeChild,
          ),
        ]
    );
    return icon;
  }

  /*切换页面*/
  void _onBarTap(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      currentIndex = index;
      setState(() {});
      if (index == tabItems.length - 1) {
        unreadVN.value = 100;
      }
      ddlog(currentIndex);
    }
  }

  Future<PackageInfo> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;// 医链健康执业版
    // String packageName = packageInfo.packageName;// com.yilian.ylHealthApp
    // String version = packageInfo.version;// 1.0.0
    // String buildNumber = packageInfo.buildNumber;//1
    // debugPrint("packageInfo: ${packageInfo.toString()}");
    return Future.value(packageInfo);
  }

  /// 上拉刷新,下拉加载全局配置
  configRefresh() {
    EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
      triggerOffset: 50,
      showMessage: false,
      dragText: "下拉刷新",
      armedText: "释放刷新",
      readyText: "正在刷新...",
      processingText: "正在刷新...",
      processedText: "刷新完成",
      noMoreText: "我可是有底线的 ~",
      failedText: "刷新失败",
      messageText: '更新时间 %T',
    );

    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
      triggerOffset: 50,
      showMessage: false,
      dragText: "上拉加载",
      armedText: "释放加载",
      readyText: "加载中...",
      processingText: "加载中...",
      processedText: "加载完成",
      noMoreText: "我可是有底线的 ~",
      failedText: "加载失败",
      // messageBuilder: (context, state, text, dateTime) {
      //   return SizedBox();
      // },
      noMoreIcon: SizedBox(),
    );
  }


  test() {
    var a = 85.99999;
    var b = 488.236;
    var c = 488.3;

    ddlog(a.toStringAsExponential(2));
    ddlog(a.toStringAsFixed(2));
    ddlog(a.toStringAsPrecision(2));
  }

  Widget buildUpdateAlert(BuildContext context) {
    const title = "新版本v ${2.0}";
    const message = """
      1、支持立体声蓝牙耳机，同时改善配对性能
      2、提供屏幕虚拟键盘
      3、更简洁更流畅，使用起来更快
      4、修复一些软件在使用时自动退出bug5、新增加了分类查看功能
      """;

    return Container(
      padding: EdgeInsets.only(top: 100, left: 15, bottom: 100, right: 15),
      child: Column( //Column控件用来垂直摆放子Widget
        // crossAxisAlignment: CrossAxisAlignment.start, //水平方向距左对⻬
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 20),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15),
              child: Text(message, style: TextStyle(fontSize: 14),),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    ddlog("以后再说");
                  },
                  child: Text("以后再说", style: TextStyle(fontSize: 14),),
                ),
                TextButton(
                  onPressed: () {
                    ddlog("立即升级");
                  },
                  child: Text("立即升级",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }
}

