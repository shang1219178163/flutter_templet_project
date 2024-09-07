# flutter_templet_project

个人模板工程, 支持 iOS, andriod, web, mac, window.

achive：
```
flutter build ios --release --dart-define=CHANNEL=GSY --dart-define=LANGUAGE=Dart
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
├── android (包含 fastlane 打包脚本)
├── ios (包含 fastlane 打包脚本)
├── lib
│   ├── APPThemeSettings.dart (主题设置)
│   ├── basicWidget (组件封装,N开头的是稳定版,核心之一)
│   ├── cache (数据缓存和文件管理类)
│   ├── enum (枚举类型)
│   ├── eventbus (弃用)
│   ├── extension (类型功能扩展,核心之一)
│   ├── main.dart (项目入口)
│   ├── mixin (mixin 封装,通常是赋予类各种共用方法和属性,提高代码复用性,简化冗余代码)
│   ├── model (测试数据载体)
│   ├── network (网络封装)
│   ├── pages (各种 demo 演示页)
│   ├── provider (各种状态管理库测试 demo 目录)
│   ├── routes (路由管理)
│   ├── service (网络状态管理,前后台切换状态封装单例类)
│   ├── util (没有合适地方放的公用工具类)
│   └── vendor (引入的第三方及二次封装示例)
```

## Flutter SDK 大版本升级命令

flutter pub upgrade --dry-run

flutter pub outdated

flutter pub upgrade --major-versions