//
//  ImageExtension.dart
//  flutter_templet_project
//
//  Created by shang on 9/15/22 7:02 PM.
//  Copyright © 9/15/22 shang. All rights reserved.
//

import 'dart:async';
import 'dart:ui' as ui;

// import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/extension/src/file_ext.dart';
import 'package:flutter_templet_project/extension/src/widget_ext.dart';

extension UIImageExt on ui.Image {
  /// 获取本地图片图像
  static Future<ui.Image> getImageFromAssets(String path) async {
    final immutableBuffer = await rootBundle.loadBuffer(path);
    final codec = await ui.instantiateImageCodecFromBuffer(
      immutableBuffer,
    );
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  /// ui.Image 类型转 Uint8List
  FutureOr<Uint8List?> toUint8List({
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    var byteData = await toByteData(format: format);
    final bytes = byteData?.buffer.asUint8List();
    return bytes;
  }

  /// 获取文件在内存中的大小
  FutureOr<String?> fileSize({
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    var byteData = await toByteData(format: format);
    final result = byteData?.fileSize();
    // print("imageSize: ${result}");
    return result;
  }
}

extension ImageExt on Image {
  static FutureOr<Uint8List?> imageDataFromUrl({
    required String imageUrl,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    var img = Image.network(imageUrl);
    var imgInfo = await img.image.getImageInfo();
    var uint8List = await imgInfo.image.toUint8List();
    return uint8List;
  }
}

extension ImageProviderExt on ImageProvider {
  /// return Future<ImageInfo>
  Future<ImageInfo> getImageInfo({
    ImageConfiguration configuration = const ImageConfiguration(),
  }) async {
    final completer = Completer<ImageInfo>();
    resolve(configuration).addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool _) async {
          // imageInfo.image.dispose();
          completer.complete(imageInfo);
          evict();
        },
        onError: (Object exception, StackTrace? stackTrace) {
          completer.completeError(exception, stackTrace);
          evict();
        },
      ),
    );
    return completer.future;
  }
}

extension Uint8ListExt on Uint8List {
  /// 转 ui.Image
  Future<ui.Image> toImage() async {
    final data = this;
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

extension ByteDataExt on ByteData {
  /// 获取文件在内存中的大小
  String fileSize() {
    final length = buffer.lengthInBytes;
    if (length == 0) {
      throw Exception("获取文件字节失败");
    }

    return length.fileSizeDesc;
  }
}

extension ImageChunkEventExt on ImageChunkEvent {
  // 当前百分比进度(0 - 1)
  double? get current {
    if (expectedTotalBytes == null) {
      return null;
    }
    final result = cumulativeBytesLoaded / expectedTotalBytes!;
    return result;
  }
}

extension ImageCacheExt on ImageCache {
  /// PaintingBinding.instance?.imageCache?.clear();
  static clear() {
    PaintingBinding.instance.imageCache.clear();
  }

  /// PaintingBinding.instance?.imageCache?.clearLiveImages();
  static clearLiveImages() {
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// evict
  static bool evict(Object key, {bool includeLive = true}) {
    return (PaintingBinding.instance.imageCache.evict(key, includeLive: includeLive) == true);
  }

  /// evict images
  static evictImages(List<String> urls) {
    urls.forEach((e) {
      Object key = NetworkImage(
        e,
        scale: 1.0,
      );
      PaintingBinding.instance.imageCache.evict(key, includeLive: true);
    });
  }
}
