import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';

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
      appBar: AppBar(title: Text(widget.title ?? "$widget")),
      body: buildBoy(),
    );
  }

  Widget buildBoy() {
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverMainAxisGroup(
            slivers: [
              buildSliverHeader(
                child: Text('Section 1'),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: _buldSliverList(5),
              ),
            ],
          ),
          SliverMainAxisGroup(
            slivers: [
              buildSliverHeader(
                child: Text('Section 2'),
              ),
              SliverCrossAxisGroup(
                slivers: [
                  SliverConstrainedCrossAxis(
                    maxExtent: 100,
                    sliver: SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: _buldSliverList(10),
                    ),
                  ),
                  SliverCrossAxisExpanded(
                    flex: 2,
                    sliver: SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: _buldSliverList(20),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: _buldSliverList(15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSliverHeader({required Text child, double height = 30}) {
    return NSliverPersistentHeader(
      pinned: true,
      max: height,
      min: height,
      builder:
          (BuildContext context, double shrinkOffset, bool overlapsContent) {
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
        builder:
            (BuildContext context, double shrinkOffset, bool overlapsContent) {
          return Container(
              height: 30,
              color: Colors.purple[100],
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Section 1'),
              ));
        },
      ),
    );
  }

  Widget _buldSliverList(int itemCount) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      sliver: SliverList.separated(
        itemBuilder: (_, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Item $index'),
          );
        },
        separatorBuilder: (_, __) {
          return const Divider(indent: 8, endIndent: 8);
        },
        itemCount: itemCount,
      ),
    );
  }
}
