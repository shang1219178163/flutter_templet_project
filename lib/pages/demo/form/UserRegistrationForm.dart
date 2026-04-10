import 'package:flutter/material.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  // 第一步：在 State 中声明 GlobalKey，只创建一次
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 第二步：用 Form 包裹所有表单字段，绑定 key
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第三步：用 TextFormField 而不是 TextField
          TextFormField(
            decoration: const InputDecoration(
              labelText: '用户名',
              hintText: '请输入用户名',
            ),
            // 第四步：编写 validator
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '用户名不能为空';
              }
              if (value.length < 6) {
                return '用户名至少需要 4 个字符';
              }
              return null; // 验证通过
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '密码',
              hintText: '请输入密码',
            ),
            // 第四步：编写 validator
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '密码不能为空';
              }
              if (value.length < 6) {
                return '密码至少需要 6 个字符';
              }
              return null; // 验证通过
            },
          ),
          const SizedBox(height: 16),
          // 第五步：提交按钮
          ElevatedButton(
            onPressed: () {
              // 第六步：触发验证
              if (_formKey.currentState!.validate()) {
                // 全部通过，处理数据
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('提交成功')),
                );
              }
              // 验证失败时不需要手动处理，错误信息自动显示
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}
