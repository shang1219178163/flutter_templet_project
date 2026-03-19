import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_container.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 13.3
class SliverMainAxisGroupDemo extends StatefulWidget {
  const SliverMainAxisGroupDemo({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<SliverMainAxisGroupDemo> createState() => _SliverMainAxisGroupDemoState();
}

class _SliverMainAxisGroupDemoState extends State<SliverMainAxisGroupDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBoy(),
    );
  }

  Widget buildBoy() {
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          buildGroup(name: 'Section', child: buildContainer()),
          buildGroup(name: 'Section 0', child: buildSliverContainer()),
          buildGroup(name: 'Section 1', child: buldSliverList(itemCount: 5)),
          buildGroup(
            name: 'Section 2',
            child: SliverCrossAxisGroup(
              slivers: [
                SliverConstrainedCrossAxis(
                  maxExtent: 100,
                  sliver: buldSliverList(itemCount: 10),
                ),
                SliverCrossAxisExpanded(
                  flex: 2,
                  sliver: buldSliverList(itemCount: 20),
                ),
                buldSliverList(itemCount: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliverHeader({required Text child, double height = 30}) {
    return NSliverPersistentHeaderBuilder(
      pinned: true,
      max: height,
      min: height,
      builder: (context, shrinkOffset, overlapsContent) {
        return Container(
          height: height,
          color: Colors.purple[100],
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: child,
          ),
        );
      },
    );

    return SliverPersistentHeader(
      pinned: true,
      delegate: NSliverPersistentHeaderDelegate(
        max: 30,
        min: 30,
        builder: (context, shrinkOffset, overlapsContent) {
          return Container(
            height: 30,
            color: Colors.purple[100],
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget buildGroup({required String name, required Widget child, Widget? header, Widget? footer}) {
    return SliverMainAxisGroup(
      slivers: [
        header ?? buildSliverHeader(child: Text(name)),
        child,
        if (footer != null) footer,
      ],
    );
  }

  Widget buildContainer() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        foregroundDecoration: BoxDecoration(
          color: Colors.green.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          image: DecorationImage(image: AssetImage(Assets.imagesBgJiguang)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("NSliverContainer"),
            Text("NSliverContainer1"),
            Text("NSliverContainer2"),
          ],
        ),
      ),
    );
  }

  Widget buildSliverContainer() {
    return NSliverContainer(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.blue),
      ),
      foregroundPadding: const EdgeInsets.all(8),
      foregroundDecoration: BoxDecoration(
        color: Colors.green.withOpacity(0.6),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(color: Colors.blue),
        image: DecorationImage(
          image: AssetImage(Assets.imagesBgJiguang),
        ),
      ),
      // opacity: 0.3,
      // offstage: true,
      sliver: SliverPadding(
        padding: const EdgeInsets.all(0.0),
        sliver: SliverList.list(
          children: [
            Text("NSliverContainer"),
            Text("NSliverContainer1"),
            Text("NSliverContainer2"),
          ],
        ),
      ),
    );
  }

  Widget buldSliverList({required int itemCount}) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          // border: Border.all(color: Colors.blue),
        ),
        sliver: SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: DecoratedSliver(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              image: DecorationImage(image: AssetImage(Assets.imagesBgBeach)),
              // border: Border.all(color: Colors.blue),
            ),
            sliver: SliverPadding(
              padding: const EdgeInsets.all(0.8),
              sliver: SliverList.separated(
                itemBuilder: (_, int index) {
                  return Container(
                    // margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColorExt.random,
                    ),
                    child: Text('Item $index'),
                  );
                },
                separatorBuilder: (_, __) {
                  return const Divider(indent: 8, endIndent: 8);
                },
                itemCount: itemCount,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
