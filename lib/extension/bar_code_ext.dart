//
//  BarCodeExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/21 09:32.
//  Copyright © 2025/3/21 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

extension BarcodeExt on Barcode {
  /// 转 json
  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['type'] = type.index;
    data['format'] = format.index;
    data['displayValue'] = displayValue;
    data['rawValue'] = rawValue;
    data['rawBytes'] = rawBytes;
    data['boundingBox'] = {
      'left': boundingBox.left,
      'top': boundingBox.top,
      'right': boundingBox.right,
      'bottom': boundingBox.bottom,
    };
    data['points'] = cornerPoints.map((e) => {"x": e.x, "y": e.y});
    data['value'] = value;
    return data;
  }

  /// 基于缓存图片文件获取
  static Future<List<String>> barcodeFromFilePath({required String path}) async {
    final barcodeScanner = BarcodeScanner();
    final barcodes = await barcodeScanner.processImage(InputImage.fromFilePath(path));
    final qr = barcodes.map((e) => e.rawValue ?? "").where((e) => e.isNotEmpty).toList();
    return qr;
  }

  /// 基于 extended_image 的缓存图片文件获取
  static Future<List<String>> barcodeFromUrl({required String url}) async {
    final path = await getCachedImageFilePath(url);
    if (path == null) {
      return [];
    }
    return barcodeFromFilePath(path: path);
  }
}
