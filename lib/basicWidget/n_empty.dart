import 'package:flutter/material.dart';

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
