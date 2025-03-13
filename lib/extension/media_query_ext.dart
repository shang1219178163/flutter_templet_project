//
//  MediaQueryExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 15:59.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/extension/edge_insets_ext.dart';
import 'package:flutter_templet_project/extension/geometry_ext.dart';

extension MediaQueryDataExt on MediaQueryData {
  /// 将 MediaQueryData 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      "size": size.toJson(),
      "devicePixelRatio": devicePixelRatio,
      "textScaleFactor": textScaleFactor,
      "platformBrightness": platformBrightness.name,
      "padding": padding.toJson(),
      "viewInsets": viewInsets.toJson(),
      "systemGestureInsets": systemGestureInsets.toJson(),
      "viewPadding": viewPadding.toJson(),
      "alwaysUse24HourFormat": alwaysUse24HourFormat,
      "accessibleNavigation": accessibleNavigation,
      "invertColors": invertColors,
      "highContrast": highContrast,
      "onOffSwitchLabels": onOffSwitchLabels,
      "disableAnimations": disableAnimations,
      "boldText": boldText,
      "navigationMode": navigationMode.name,
      "gestureSettings": gestureSettings.toJson(),
      "displayFeatures": displayFeatures.map((e) => e.toJson()).toList(),
    };
  }

  /// 将 JSON 转换回 `MediaQueryData`
  static MediaQueryData fromJson(Map<String, dynamic> json) {
    final displayFeatures = json["displayFeatures"] == null
        ? <DisplayFeature>[]
        : (json["displayFeatures"] as List<Map<String, dynamic>>? ?? <Map<String, dynamic>>[])
            .map((e) => DisplayFeatureExt.fromJson(e))
            .toList();
    return MediaQueryData(
      size: SizeExt.fromJson(json["size"] ?? {}),
      devicePixelRatio: json["devicePixelRatio"],
      textScaleFactor: json["textScaleFactor"],
      platformBrightness: json["platformBrightness"] == "Brightness.dark" ? Brightness.dark : Brightness.light,
      padding: EdgeInsetsExt.fromJson(json["padding"] ?? {}),
      viewInsets: EdgeInsetsExt.fromJson(json["viewInsets"] ?? {}),
      systemGestureInsets: EdgeInsetsExt.fromJson(json["systemGestureInsets"] ?? {}),
      viewPadding: EdgeInsetsExt.fromJson(json["viewPadding"] ?? {}),
      alwaysUse24HourFormat: json["alwaysUse24HourFormat"],
      accessibleNavigation: json["accessibleNavigation"],
      invertColors: json["invertColors"],
      highContrast: json["highContrast"],
      onOffSwitchLabels: json["onOffSwitchLabels"],
      disableAnimations: json["disableAnimations"],
      boldText: json["boldText"],
      navigationMode: json["navigationMode"] == "NavigationMode.directional"
          ? NavigationMode.directional
          : NavigationMode.traditional,
      gestureSettings: json["gestureSettings"] == null
          ? const DeviceGestureSettings(touchSlop: kTouchSlop)
          : DeviceGestureSettingsExt.fromJson(json["gestureSettings"]!),
      displayFeatures: displayFeatures,
    );
  }
}

extension GestureSettingsExt on GestureSettings {
  /// 将 GestureSettings 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      "physicalTouchSlop": physicalTouchSlop,
      "physicalDoubleTapSlop": physicalDoubleTapSlop,
    };
  }

  /// 从 JSON 解析 GestureSettings
  static GestureSettings fromJson(Map<String, dynamic> json) {
    return GestureSettings(
      physicalTouchSlop: json["physicalTouchSlop"] as double?,
      physicalDoubleTapSlop: json["physicalDoubleTapSlop"] as double?,
    );
  }
}

extension DeviceGestureSettingsExt on DeviceGestureSettings {
  /// 将 DeviceGestureSettings 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      "touchSlop": touchSlop,
    };
  }

  /// 从 JSON 解析 DeviceGestureSettings
  static DeviceGestureSettings fromJson(Map<String, dynamic> json) {
    return DeviceGestureSettings(
      touchSlop: json["touchSlop"] as double? ?? 18.0, // 默认值 18.0
    );
  }
}

extension DisplayFeatureExt on DisplayFeature {
  // 将 DisplayFeature 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'boundingRect': {
        'left': bounds.left,
        'top': bounds.top,
        'right': bounds.right,
        'bottom': bounds.bottom,
      },
      'state': state.name,
    };
  }

  // 从 JSON 转换为 DisplayFeature
  static DisplayFeature fromJson(Map<String, dynamic> json) {
    return DisplayFeature(
      type: DisplayFeatureType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DisplayFeatureType.unknown,
      ),
      bounds: Rect.fromLTWH(
        json['bounds']['left'],
        json['bounds']['top'],
        json['bounds']['right'] - json['bounds']['left'],
        json['bounds']['bottom'] - json['bounds']['top'],
      ),
      state: DisplayFeatureState.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DisplayFeatureState.unknown,
      ),
    );
  }
}
