import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/pages/demo/TabBarDemo.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:flutter_templet_project/provider/rxDart_provider_demo.dart';
import 'package:flutter_templet_project/Pages/APPUserCenterPage.dart';

import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

import 'Pages/APPDrawerMenuPage.dart';
import 'Pages/APPUserCenterPage.dart';

import 'extensions/button_extension.dart';
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
  setCustomErrorPage();
  await initServices();
  // AppInit.catchException(() => runApp(MyApp()));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        Provider(create: (context) => CounterBloc()),

      ],
      child: MyApp(),
    ),
  );
}

void setCustomErrorPage(){
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails){
    print("flutterErrorDetails:${flutterErrorDetails.toString()}");
    return Center(
      // child: Text("Flutter ?????????"),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text("Flutter ?????????",
                style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  };
}

Future<void> initServices() async {
  print('starting services ...');
  // await Get.putAsync(() => GlobalConfigService().init());
  // await Get.putAsync(SettingsService()).init();
  print('All services started...');
}

///??????
final GlobalKey<NavigatorState> navigatorState = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your aptplication.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: navigatorState,
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
  }
}

final GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();

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
        label: "??????",
      ),
      TabBarTabBarViewDemo(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.white,
        icon: Icon(Icons.merge_type_sharp),
        label: "??????",
      ),
      SecondPage(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.white,
        icon: Icon(Icons.message),
        label: "??????",
      ),
      TabBarDemo(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.amber,
        icon: Icon(Icons.shopping_cart),
        label: "?????????",
      ),
      ThirdPage(),
    ),
    Tuple2(
      BottomNavigationBarItem(
        // backgroundColor: Colors.red,
        icon: Icon(Icons.person),
        label: "????????????",
      ),
      APPUserCenterPage(),
    ),
  ];

  /*????????????*/
  void _changePage(int index) {
    /*???????????????????????????????????????  ?????? */
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
      ddlog(currentIndex);
    }
  }

  // void openDrawer() {
  //   scaffoldKey.currentState!.openDrawer();
  // }
  //
  // void closeDrawer() {
  //   Navigator.of(context).pop();
  // }

  //lifecycle
  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: kScaffoldKey,
      // drawer: MyDrawer(),
      drawer: APPDrawerMenuPage(),
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

  }

  ///???????????????
  AppBar buildAppBar(){
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title ?? "??????"),
      //????????????????????????
      leading: Icon(Icons.arrow_back)
          .opacity(0)
          .gestures(onTap: () => ddlog("back")),
      //??????????????????????????????
      actions: [
        // Icon(Icons.settings)
        //     .padding(right: 8)
        //     .gestures(onTap: ()=> ddlog("settings")),
        // Icon(Icons.search)
        //     // .padding(right: 8)
        //     .gestures(onTap: ()=> ddlog("search")),

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
    return Container(
      child: Column( //Column???????????????????????????Widget
        // crossAxisAlignment: CrossAxisAlignment.start, //????????????????????????
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("?????????v ${2.0}").fontSize(20)
            // .padding(right: 20)
            //     .width(MediaQuery.of(context).size.width - 30)
            ,
            Text("""
          1?????????????????????????????????????????????????????????
          2???????????????????????????
          3??????????????????????????????????????????
          4?????????????????????????????????????????????bug5?????????????????????????????????
          """).fontSize(14)
                .width(MediaQuery.of(context).size.width - 30),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    ddlog("????????????");
                  },
                  child: Text("????????????").fontSize(14),
                ),
                TextButton(
                  onPressed: () {
                    ddlog("????????????");
                  },
                  child: Text("????????????").fontSize(14)
                      .textColor(Colors.white)
                      .backgroundColor(Colors.blue),
                ),
              ],
            ),
          ]
      )
          .padding(top: 100, left: 15, bottom: 100, right: 15),
    );
  }
}

///??????????????????
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //????????????????????????????????????
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