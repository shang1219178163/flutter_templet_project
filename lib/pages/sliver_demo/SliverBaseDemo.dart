import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class SliverBaseDemo extends StatelessWidget {
  const SliverBaseDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverBase'),
      ),
      // body: _buildSliverOpacityAndPadding(),
      body: _buildSliverOpacityAndPadding(),
    );
  }

  sectionHeader({Widget? child}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
        ),
        child: child ?? Text('SliverToBoxAdapter'),
      ),
    );
  }

  _buildSliverOpacityAndPadding() {
    return CustomScrollView(
      slivers: <Widget>[
        sectionHeader(child: Text('SliverOpacity')),
        SliverOpacity(
          opacity: 0.5,
          alwaysIncludeSemantics: true,
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.red,
              child: Center(
                child: Text('透明效果'),
              ),
            ),
          ),
        ),
        sectionHeader(child: Text('SliverPadding')),
        SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  '设置padding',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
