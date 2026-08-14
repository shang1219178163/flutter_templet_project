/// Core GetPages for app startup (kept small for hot restart).
import 'package:flutter_templet_project/pages/app_settings_page.dart';
import 'package:flutter_templet_project/pages/app_tab_page.dart';
import 'package:flutter_templet_project/pages/demo/APPForgetPwdPage.dart';
import 'package:flutter_templet_project/pages/demo/AppLaunchPage.dart';
import 'package:flutter_templet_project/pages/demo/AppSandboxFileDirectory.dart';
import 'package:flutter_templet_project/pages/demo/CompileEnvironmentPage.dart';
import 'package:flutter_templet_project/pages/demo/DevelopToolList.dart';
import 'package:flutter_templet_project/pages/demo/LoginPage.dart';
import 'package:flutter_templet_project/pages/demo/LoginPageOne.dart';
import 'package:flutter_templet_project/pages/demo/LoginPageTwo.dart';
import 'package:flutter_templet_project/pages/unknown_page.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/routes/middleware/AuthMiddleware.dart';
import 'package:get/get.dart';

class AppRouterCore {
  AppRouterCore._();

  static final unknownRoute = GetPage(
    name: AppRouter.unknown,
    page: () => UnknownPage(),
  );

  static final List<GetPage> pages = [
    unknownRoute,
    GetPage(
      name: AppRouter.sandboxFileDirectory,
      page: () => AppSandboxFileDirectory(),
    ),
    GetPage(
      name: AppRouter.compileEnvironmentPage,
      page: () => CompileEnvironmentPage(),
    ),
    GetPage(
      name: AppRouter.developToolList,
      page: () => DevelopToolList(),
    ),
    GetPage(
      name: AppRouter.launchPage,
      page: () => AppLaunchPage(),
    ),
    GetPage(
      name: AppRouter.appTabPage,
      page: () => AppTabPage(),
    ),
    GetPage(
      name: AppRouter.login, page: () => LoginPage(),
      middlewares: [
        AuthMiddleware(),
      ],
      // transition: Transition.downToUp,login
    ),
    GetPage(
      name: AppRouter.loginPageOne, page: () => LoginPageOne(),
      // transition: Transition.downToUp,),
    ),
    GetPage(
      name: AppRouter.loginPageTwo, page: () => LoginPageTwo(),
      // transition: Transition.downToUp,),
    ),
    GetPage(
      name: AppRouter.forgetPasswordPage,
      page: () => APPForgetPwdPage(),
    ),
    GetPage(
      name: AppRouter.settingsPage,
      page: () => AppSettingsPage(),
    ),
  ];
}
