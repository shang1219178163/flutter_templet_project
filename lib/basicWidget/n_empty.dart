import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NEmpty extends StatelessWidget {
  const NEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.66,
      child: Hero(
        tag: 'avatar',
        child: Image(
          image: '404.png'.toAssetImage(),
        ),
      ),
    );
  }
}
