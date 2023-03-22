//
//  Main.dart
//  flutter_templet_project
//
//  Created by shang on 3/13/23 4:07 PM.
//  Copyright © 3/13/23 shang. All rights reserved.
//



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/pages/demo/TabBarDemo.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:flutter_templet_project/provider/provider_demo.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:flutter_templet_project/provider/rxDart_provider_demo.dart';
import 'package:flutter_templet_project/Pages/APPUserCenterPage.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'Pages/APPDrawerMenuPage.dart';
import 'Pages/APPUserCenterPage.dart';

import 'basicWidget/error_custom_widget.dart';
import 'pages/FirstPage.dart';
import 'pages/SecondPage.dart';
import 'pages/ThirdPage.dart';
import 'pages/FourthPage.dart';
import 'vendor/TextlessDemo.dart';

import 'provider/notifier_demo.dart';

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
  await ScreenUtil.ensureScreenSize();

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

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

void setCustomErrorPage(){
  // FlutterError.onError = (details) {
  //   FlutterError.presentError(details);
  // };

  ErrorWidget.builder = (FlutterErrorDetails details){
    print("flutterErrorDetails:${details.toString()}");
    return ErrorCustomWidget(details: details);
  };
}

Future<void> initServices() async {
  print('starting services ...');
  // await Get.putAsync(() => GlobalConfigService().init());
  // await Get.putAsync(SettingsService()).init();
  print('All services started...');
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

///全局
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your aptplication.

  @override
  Widget build(BuildContext context) {
    final app = GetMaterialApp(
      key: navigatorKey,
      title: 'Flutter Templet',
      debugShowCheckedModeBanner: false,
      theme: APPThemeSettings.instance.themeData,
      // darkTheme: APPThemeSettings.instance.darkThemeData,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      // initialRoute: "/MyHomePage",
      // routes: kRoutes,
      initialRoute: AppPage.INITIAL,
      getPages: AppPage.routes,
      unknownRoute: AppPage.unknownRoute,
      routingCallback: (routing){
        // if (routing != null) {
        //   ddlog([routing.previous, routing.current]);
        // }
      },
      // routes: {
    //     "/": (context) => MyHomePage(),
    //     "/TwoPage": (context) => TwoPage(),
    //   },
    );

    return app;
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
  MyHomePage({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  final List<Tuple2<BottomNavigationBarItem, Widget>> items = [
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.white,
        icon: Icon(Icons.home),
        label: "首页",
      ),
      TabBarTabBarViewDemo(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.white,
        icon: Icon(Icons.merge_type_sharp),
        label: "按钮",
      ),
      SecondPage(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.white,
        icon: Icon(Icons.message),
        label: "消息",
      ),
      TabBarDemo(initialIndex: 3,),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.amber,
        icon: Icon(Icons.shopping_cart),
        label: "购物车",
      ),
      ThirdPage(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.red,
        icon: Icon(Icons.person),
        label: "个人中心",
      ),
      APPUserCenterPage(),
    ),
  ];

  /*切换页面*/
  void _changePage(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
      ddlog(currentIndex);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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
      bottomNavigationBar: BottomNavigationBar(
        items: items.map((e) => e.item1).toList(),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        // selectedItemColor: Colors.lightBlue,
        // unselectedItemColor: Colors.black45,
        //
        // selectedIconTheme: IconThemeData(color: Colors.lightBlue),
        // unselectedIconTheme: IconThemeData(color: Colors.black45),

        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        onTap: (index) {
          _changePage(index);
        },
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
        PopupMenuButtonExt.fromEntryFromJson(
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

  test() {
    var a = 85.99999;
    var b = 488.236;
    var c = 488.3;

    ddlog(a.toStringAsExponential(2));
    ddlog(a.toStringAsFixed(2));
    ddlog(a.toStringAsPrecision(2));
  }

  Widget buildUpdateAlert(BuildContext context) {
    final title = "新版本v ${2.0}";
    final message = """
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

///左侧抽屉菜单
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      // child: Image.asset(
                      //   "images/avatar.png",
                      //   width: 80,
                      // ),
                      child: FlutterLogo(size: 60,),
                    ),
                  ),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add account'),
                    trailing: Icon(Icons.add_a_photo),
                    onTap: (){
                      ddlog(context);
                    },
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Manage accounts'),
                    onTap: (){
                      ddlog(Icons.title);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      "Your Profile",
                    ),
                    onTap: (){
                      debugPrint("Tapped Profile");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}