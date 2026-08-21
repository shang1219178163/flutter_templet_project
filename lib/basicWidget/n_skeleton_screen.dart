import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NSkeletonScreen extends StatelessWidget {
  const NSkeletonScreen({
    super.key,
    this.backgroundColor,
  });

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            buildItem(),
            buildItem(),
            buildItem(),
            buildItem(),
          ],
        ),
      ),
    );
  }

  Widget buildItem() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildBox(double.infinity, 71),
            const SizedBox(height: 16),
            buildBox(200, 20),
            const SizedBox(height: 16),
            buildBox(300, 16),
            const SizedBox(height: 16),
            buildBox(100, 16),
          ],
        ),
      ),
    );
  }

  Widget buildBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
