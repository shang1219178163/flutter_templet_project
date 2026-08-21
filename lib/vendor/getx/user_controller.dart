import 'package:get/get.dart';

class _User {
  String name;
  int age;

  _User({required this.name, required this.age});
}

class UserController extends GetxController {
  var user = _User(name: '张三', age: 25).obs;

  void updateUser() {
    // 整个对象替换，UI会更新
    user.value = _User(name: '李四', age: 26);

    // 修改对象属性，UI不会更新（这是坑）
    user.value.name = '王五'; // ❌ UI不会更新

    // 想让属性变化也触发更新，需要这样
    user.update((v) {
      v?.name = '王五';
      v?.age = 27;
    }); // ✅ 这样UI会更新
  }
}
