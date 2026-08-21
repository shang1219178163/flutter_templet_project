import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopScopeDemoOne extends StatelessWidget {
  const PopScopeDemoOne({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    final currOverlayStyle = SystemUiOverlayStyle.dark;
    final overlayStyle = SystemUiOverlayStyle.light;

    return PopScope(
      onPopInvokedWithResult: (canPop, result) async {
        Future.delayed(const Duration(milliseconds: 300), () {
          SystemChrome.setSystemUIOverlayStyle(overlayStyle);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: currOverlayStyle,
            title: Text("$this"),
          ),
          body: Text("StatelessWidget 下的电池栏颜色设置 SystemUiOverlayStyle"),
        ),
      ),
    );
  }
}
