import 'package:flutter/material.dart';
import 'package:flutter_templet_project/model/user_model.dart';

// MaterialApp(
// restorationScopeId: 'app',
// onGenerateRoute: ...
// )

/// RestorationMixin使用示例
class RestorationMixinDemo extends StatefulWidget {
  const RestorationMixinDemo({super.key});

  @override
  State<RestorationMixinDemo> createState() => _RestorationMixinDemoState();
}

class _RestorationMixinDemoState extends State<RestorationMixinDemo> with RestorationMixin {
  // ====== 1️⃣ 可恢复的变量 ======
  final _counter = RestorableInt(0);
  final _controller = RestorableTextEditingController();
  late final RestorableRouteFuture<void> _dialogRoute;

  // ====== 2️⃣ restorationId 必须唯一 ======
  @override
  String? get restorationId => '$widget';

  // ====== 3️⃣ 注册需要恢复的属性 ======
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, 'counter');
    registerForRestoration(_controller, 'text_field');
    _dialogRoute = RestorableRouteFuture<void>(
      onPresent: (navigator, args) {
        return navigator.restorablePush(dialogBuilder);
      },
    );
    registerForRestoration(_dialogRoute, 'dialog');
  }

  final tips = """"
  ## Testing State Restoration

{@template flutter.widgets.RestorationManager}
要在 Android 上测试状态恢复：
  1.开启“Don't keep events”，这会破坏Android Activity
     一旦用户离开它。该选项应该可用
     当设备打开开发者选项时。
  2. 在 Android 设备上运行代码示例。
  3. 在手机上的应用程序中创建一些内存状态，
     例如通过导航到不同的屏幕。
  4. 将 Flutter 应用程序置于后台，然后返回。它将重新启动
     并恢复其状态。

要在 iOS 上测试状态恢复：
  1. 在 Xcode 中打开 `ios/Runner.xcworkspace/`。
  2.（仅限 iOS 14+）：切换到在配置文件或发布模式下构建，如下
     调试时不支持从主屏幕启动应用程序
     模式。
  2. 按 Xcode 中的“播放”按钮构建并运行应用程序。
  3. 在手机上的应用程序中创建一些内存状态，
     例如通过导航到不同的屏幕。
  4. 将应用程序置于手机后台，例如返回主屏幕。
  5. 在 Xcode 中按 Stop 按钮终止运行中的应用程序
     背景。
  6. 在手机上再次打开应用程序（不是通过 Xcode）。它将重新启动
     并恢复其状态。
{@endtemplate}
  """;

  // ====== 4️⃣ Dialog 路由定义 ======
  static Route<void> dialogBuilder(BuildContext context, Object? args) {
    return DialogRoute<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('状态恢复示例'),
        content: const Text('此弹窗状态可在应用重启后恢复！'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _counter.dispose();
    _controller.dispose();
    super.dispose();
  }

  void increment() {
    _counter.value++;
    setState(() {});
  }

  // ====== 5️⃣ 页面结构 ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RestorationMixin 示例')),
      body: ListView(
        restorationId: 'main_list', // 🌟 自动恢复滚动位置
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                tips,
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
          ),
          const Divider(),
          // 计数器
          Card(
            child: ListTile(
              title: Text('计数值：${_counter.value}', style: Theme.of(context).textTheme.titleLarge),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: increment,
              ),
            ),
          ),
          const Divider(),

          // 输入框
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller.value,
                decoration: const InputDecoration(
                  labelText: '可恢复输入内容',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const Divider(),

          // 弹窗按钮
          ElevatedButton.icon(
            onPressed: _dialogRoute.present,
            icon: const Icon(Icons.message_outlined),
            label: const Text('打开可恢复弹窗'),
          ),

          const Divider(),

          // 长列表滚动恢复示例
          ...List.generate(
            30,
            (i) => ListTile(
              title: Text('列表项 #$i'),
            ),
          ),
        ],
      ),
    );
  }
}

class RestorableUser extends RestorableValue<UserModel> {
  RestorableUser(UserModel user) : _user = user;

  UserModel _user;

  @override
  UserModel createDefaultValue() => UserModel(name: "默认用户");

  @override
  void didUpdateValue(UserModel? oldValue) {
    notifyListeners();
  }

  @override
  UserModel fromPrimitives(Object? data) {
    final map = data as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(map);
  }

  @override
  Object? toPrimitives() {
    return _user.toJson();
  }

  @override
  UserModel get value => _user;

  @override
  set value(UserModel newValue) {
    if (newValue == _user) {
      return;
    }
    _user = newValue;
    notifyListeners();
  }
}
//
// class User {
//   final String name;
//   final int age;
//
//   User(this.name, this.age);
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is User && runtimeType == other.runtimeType && name == other.name && age == other.age;
//
//   @override
//   int get hashCode => name.hashCode ^ age.hashCode;
// }
