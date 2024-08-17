import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// show AssetEntity, AssetEntityImageProvider;

class WechatAssetsPickerDemo extends StatefulWidget {
  const WechatAssetsPickerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WechatAssetsPickerDemoState createState() => _WechatAssetsPickerDemoState();
}

class _WechatAssetsPickerDemoState extends State<WechatAssetsPickerDemo> {
  int maxCount = 9;
  var selectedAssets = <AssetEntity>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            '选择',
          ]
              .map((e) => TextButton(
                    onPressed: onPicker,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: Column(
          children: [
            photoSection(items: selectedAssets, rowCount: 4),
          ],
        ));
  }

  photoSection({
    List<AssetEntity> items = const [],
    int maxCount = 9,
    int rowCount = 3,
    double spacing = 10,
  }) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var itemWidth =
          ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount)
              .truncateToDouble();
      // print("itemWidth: $itemWidth");
      return Wrap(spacing: spacing, runSpacing: spacing, children: [
        ...items.map((e) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // border: Border.all(width: 2),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: FadeInImage(
              width: itemWidth,
              height: itemWidth,
              placeholder: 'img_placeholder.png'.toAssetImage(),
              image: AssetEntityImageProvider(e, isOriginal: false),
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
        if (items.length < 9)
          InkWell(
            onTap: () {
              onPicker();
            },
            child: Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                // border: Border.all(width: 1),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Icon(Icons.add),
            ),
          )
      ]);
    });
  }

  onPicker() async {
    final result = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxCount,
          selectedAssets: selectedAssets,
          themeColor: context.primaryColor,
        ));
    debugPrint(result.toString());
    selectedAssets = result ?? [];

    for (final e in selectedAssets) {
      final path = await e.fileWithSubtype;
      debugPrint(path.toString());
    }
    setState(() {});
  }
}

class WechatPhotoPickerDemo extends StatefulWidget {
  const WechatPhotoPickerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WechatPhotoPickerDemoState createState() => _WechatPhotoPickerDemoState();
}

class _WechatPhotoPickerDemoState extends State<WechatPhotoPickerDemo> {
  int maxCount = 9;
  var selectedAssets = <AssetEntity>[];

  final _globalKey =
      GlobalKey<WechatPhotoPickerState>(debugLabel: 'WechatPhotoPickerState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            '选择',
          ]
              .map((e) => TextButton(
                    onPressed: onPicker,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: Column(
          children: [
            WechatPhotoPicker(
              key: _globalKey,
              rowCount: 4,
              onChanged: (List<AssetEntity> assets) {
                debugPrint("onChanged assets: ${assets.length}");
                selectedAssets = assets;
              },
              onPicker: () => AssetPicker.pickAssets(context,
                  pickerConfig: AssetPickerConfig(
                    maxAssets: maxCount,
                    selectedAssets: selectedAssets,
                  )),
            )
          ],
        ));
  }

  onPicker() async {
    _globalKey.currentState?.onPicker();
    debugPrint("onPicker:${selectedAssets.length}");
  }
}

/// 基于 wechat_assets_picker 的图片选择组件
class WechatPhotoPicker extends StatefulWidget {
  WechatPhotoPicker({
    Key? key,
    this.maxCount = 9,
    this.rowCount = 3,
    this.spacing = 10,
    this.decoration,
    this.placeholder = const AssetImage('assets/images/img_placeholder.png'),
    this.addBuilder,
    required this.onChanged,
    this.onPicker,
  }) : super(key: key);

  /// 最大个数
  int maxCount;

  /// 每行元素个数
  int rowCount;

  /// 元素间距
  double spacing;

  /// 元素修饰器
  BoxDecoration? decoration;

  /// 占位图片
  ImageProvider placeholder;

  /// 添加图片
  Widget Function(BuildContext context, double itemWidth)? addBuilder;

  /// 确认选择回调函数
  void Function(List<AssetEntity> assets) onChanged;

  /// 解决flutter数据无法透传的问题(透传 AssetPicker.pickAssets 方法)
  Future<List<AssetEntity>?> Function()? onPicker;

  @override
  WechatPhotoPickerState createState() => WechatPhotoPickerState();
}

class WechatPhotoPickerState extends State<WechatPhotoPicker> {
  /// 媒体对象数组
  List<AssetEntity> selectedAssets = [];

  @override
  Widget build(BuildContext context) {
    return photoSection(
      selectedAssets: selectedAssets,
      maxCount: widget.maxCount,
      rowCount: widget.rowCount,
      spacing: widget.spacing,
    );
  }

  /// 图片区域
  photoSection({
    List<AssetEntity> selectedAssets = const [],
    int maxCount = 9,
    int rowCount = 3,
    double spacing = 10,
  }) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var itemWidth =
          ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount)
              .truncateToDouble();
      // print("itemWidth: $itemWidth");
      return Wrap(spacing: spacing, runSpacing: spacing, children: [
        ...selectedAssets
            .map((e) => Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: widget.decoration ??
                      BoxDecoration(
                        // border: Border.all(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                  child: FadeInImage(
                    width: itemWidth,
                    height: itemWidth,
                    placeholder: widget.placeholder,
                    image: AssetEntityImageProvider(e, isOriginal: false),
                    fit: BoxFit.cover,
                  ),
                ))
            .toList(),
        if (selectedAssets.length < maxCount)
          InkWell(
            onTap: onPicker,
            child: Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                // border: Border.all(width: 10),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: widget.addBuilder?.call(context, itemWidth) ??
                  Icon(
                    Icons.add,
                    size: itemWidth / 3,
                    color: Colors.black.withOpacity(0.3),
                  ),
            ),
          )
      ]);
    });
  }

  /// 打开相册,选择媒体素材
  onPicker() async {
    var result = await widget.onPicker?.call() ??
        await AssetPicker.pickAssets(context,
            pickerConfig: AssetPickerConfig(
              maxAssets: widget.maxCount,
              selectedAssets: selectedAssets,
            ));
    selectedAssets = result ?? [];
    widget.onChanged(selectedAssets);
    setState(() {});
  }
}
