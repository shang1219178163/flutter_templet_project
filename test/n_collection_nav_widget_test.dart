import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_collection_nav_widget.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('5 列 5 行且图标大于格子宽度时不溢出', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final items = List.generate(
      30,
      (i) => AttrNavItem(icon: Assets.imagesImgPlaceholder, name: '测试标题啊'),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NCollectionNavWidget(
            items: items,
            onItem: (e) {},
            iconSize: 68,
            textGap: 5,
            pageColumnNum: 5,
            pageRowNum: 5,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(NCollectionNavWidget), findsOneWidget);
  });

  testWidgets('row/col 组合矩阵无溢出异常', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final counts = [24, 26, 30, 50];
    for (var row = 1; row <= 5; row++) {
      for (var col = 1; col <= 5; col++) {
        for (final count in counts) {
          final items = List.generate(
            count,
            (i) => AttrNavItem(icon: Assets.imagesImgPlaceholder, name: '测试标题啊'),
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NCollectionNavWidget(
                  items: items,
                  onItem: (e) {},
                  iconSize: 68,
                  textGap: 5,
                  pageColumnNum: col,
                  pageRowNum: row,
                ),
              ),
            ),
          );
          await tester.pump();
          final ex = tester.takeException();
          if (ex != null) {
            fail('row=$row col=$col count=$count 异常: $ex');
          }
        }
      }
    }
  });
}
