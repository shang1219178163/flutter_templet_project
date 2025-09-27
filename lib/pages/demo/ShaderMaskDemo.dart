//
//  ShaderMaskDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 9:15 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ShaderMaskDemo extends StatefulWidget {
  const ShaderMaskDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ShaderMaskDemo> createState() => _ShaderMaskDemoState();
}

class _ShaderMaskDemoState extends State<ShaderMaskDemo> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ShaderMask"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShaderMask(),
            Text("BlendMode"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...BlendMode.values.map((e) => buildExample(blendMode: e)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildShaderMask() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1.0,
          colors: <Color>[
            Colors.yellow,
            Colors.deepOrange.shade900,
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: const Text(
        'I’m burning the memories!',
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }

  Widget buildExample({BlendMode blendMode = BlendMode.modulate}) {
    return ShaderMask(
      blendMode: blendMode,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Container(
        width: 125,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(width: 5, color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '${blendMode}'.split(".").last,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
