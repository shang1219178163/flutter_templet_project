//
//  Main.dart
//  flutter_templet_project
//
//  Created by shang on 3/13/23 4:07 PM.
//  Copyright © 3/13/23 shang. All rights reserved.
//

import 'package:dart_ping/dart_ping.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:http_proxy/http_proxy.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/error_custom_widget.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:flutter_templet_project/provider/notifier_demo.dart';
import 'package:flutter_templet_project/provider/provider_demo.dart';
import 'package:flutter_templet_project/provider/rxDart_provider_demo.dart';
import 'package:flutter_templet_project/routes/AppRouteObserver.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/routes/InitialBinding.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_generic_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:route_stack_manager/route_stack_manager.dart';
import 'package:tuple/tuple.dart';

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

  // /// 从  --dart-define=app_env=beta 读取运行环境
  RequestConfig.initFromEnvironment();

  // final ping = Ping('baidu.com', count: 20);
  // ping.stream.listen((event) {
  //   DLog.d("ping $event");
  // });

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
  await DBManager().init();

  setCustomErrorPage();
  await initServices();
  await initDebugInfo();
  // AppInit.catchException(() => runApp(MyApp()));
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: ColorFilteredProvider()),
        ChangeNotifierProvider(create: (context) => ColorFilteredProvider()),

        ChangeNotifierProvider(create: (context) => DBGenericProvider<DBTodo>()),
        ChangeNotifierProvider(create: (context) => DBGenericProvider<DBStudent>()),
        ChangeNotifierProvider(create: (context) => DBGenericProvider<DBOrder>()),

        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider<Person>(
          create: (ctx) => Person(),
        ),
        ChangeNotifierProvider<Foo>(
          create: (ctx) => Foo(),
        ),
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

void setCustomErrorPage() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    final errorDesc = "FlutterError.onError $details";
    CacheService().updateLogs(value: errorDesc, isClear: true);
    // exit(1);
  };

  ErrorWidget.builder = (details) {
    final errorDesc = "ErrorWidget.builder $details";
    debugPrint(errorDesc);
    CacheService().updateLogs(value: errorDesc, isClear: true);

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
  // debugPaintPointersEnabled = true; // 启用点击区域可视化
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your aptplication.

  @override
  Widget build(BuildContext context) {
    final app = GetMaterialApp(
      popGesture: true, //swipe back
      navigatorKey: ToolUtil.navigatorKey,
      title: 'Flutter Templet',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh'),
      initialBinding: InitialBinding(),
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
      navigatorObservers: [
        AppRouteObserver().routeObserver,
        RouteManagerObserver(),
      ],
      routingCallback: AppRouteObserver().routingCallback ??
          (routing) {
            // if (routing != null) {
            //   DLog.d([routing.previous, routing.current]);
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
          visible: false, // 关闭返回按钮长按 tooltip
          child: app,
        );
      },
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
