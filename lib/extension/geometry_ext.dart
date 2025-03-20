//
//  GeometryExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 16:30.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

import 'dart:ui';

extension OffsetExt on Offset {
  Map<String, dynamic> toJson() => {'dx': dx, 'dy': dy};

  static Offset fromJson(Map<String, dynamic> json) {
    return Offset(json['dx'], json['dy']);
  }
}

extension SizeExt on Size {
  /// 等比缩放大小
  Size toWidth(double width) {
    final scale = width / this.width;
    final heightNew = scale * height;
    // print("SizeExt:${heightNew}");
    return Size(width, heightNew);
  }

  /// 等比缩放大小
  Size toHeight(double height) {
    final scale = height / this.height;
    final widthNew = scale * width;
    // print("SizeExt:${widthNew}");
    return Size(widthNew, height);
  }

  Map<String, dynamic> toJson() => {'width': width, 'height': height};

  static Size fromJson(Map<String, dynamic> json) {
    return Size(json['width'], json['height']);
  }
}

extension RectExt on Rect {
  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'width': width,
        'height': height,
      };

  static Rect fromJson(Map<String, dynamic> json) {
    return Rect.fromLTWH(
      json['left'],
      json['top'],
      json['width'],
      json['height'],
    );
  }
}

extension RadiusExt on Radius {
  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  static Radius fromJson(Map<String, dynamic> json) {
    return Radius.elliptical(json['x'], json['y']);
  }
}

extension RRectExt on RRect {
  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
        'tlRadius': tlRadius.toJson(),
        'trRadius': trRadius.toJson(),
        'blRadius': blRadius.toJson(),
        'brRadius': brRadius.toJson(),
      };

  static RRect fromJson(Map<String, dynamic> json) {
    return RRect.fromLTRBAndCorners(
      json['left'],
      json['top'],
      json['right'],
      json['bottom'],
      topLeft: RadiusExt.fromJson(json['tlRadius']),
      topRight: RadiusExt.fromJson(json['trRadius']),
      bottomLeft: RadiusExt.fromJson(json['blRadius']),
      bottomRight: RadiusExt.fromJson(json['brRadius']),
    );
  }
}
