import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

class GameMathPageNew extends StatefulWidget {
  const GameMathPageNew({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<GameMathPageNew> createState() => _GameMathPageNewState();
}

class _GameMathPageNewState extends State<GameMathPageNew> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant GameMathPageNew oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
            ScoreBoard(),
          ],
        ),
      ),
    );
  }
}

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 国旗 + 队伍名
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTeam(R.image.urls.first, "韩国男篮"),
              const SizedBox(width: 60),
              _buildTeam(R.image.urls.last, "关岛男篮"),
            ],
          ),
          const SizedBox(height: 8),
          // 比分和下方的线
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "99",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "-",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "66",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 底部连接线
              Positioned(
                bottom: -8,
                child: CustomPaint(
                  size: const Size(100, 20),
                  painter: _BracketPainter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(String flagUrl, String name) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image.network(
            flagUrl,
            width: 28,
            height: 20,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    // 左竖
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    // 下横
    path.lineTo(size.width, size.height);
    // 右竖
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
