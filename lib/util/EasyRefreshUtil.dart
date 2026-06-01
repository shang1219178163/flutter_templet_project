import 'dart:math' as math;

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// EasyRefresh 配置类
class EasyRefreshUtil {
  /// 自定义 header
  static Header refreshHeader() {
    return ClassicHeader(
      triggerOffset: 50,
      hitOver: true,
      safeArea: false,
      showMessage: false, //是否显示描述文字 ‘上次更新时间’
      showText: true, //是否显示下面的文字
      // 下面是一些文本配置
      dragText: "下拉刷新",
      armedText: "释放刷新",
      readyText: "正在刷新...",
      processingText: "正在刷新...",
      processedText: "刷新完成",
      noMoreText: "我可是有底线的 ~",
      failedText: "刷新失败",
      messageText: '更新时间 %T',
      textStyle: const TextStyle(fontSize: 14),
      infiniteOffset: null,
      spacing: 0,
      textBuilder: (context, state, text) {
        return SizedBox();
      },
      messageBuilder: (context, state, text, dateTime) {
        return SizedBox();
      },
      pullIconBuilder: (context, state, animation) {
        return SizedBox(
          child: CupertinoActivityIndicator(radius: 10),
        );
      },
    );
  }

  /// 自定义 footer
  static Footer refreshFooter() {
    return ClassicFooter(
      triggerOffset: 50,
      showMessage: false, //是否显示描述文字 ‘上次更新时间’
      // 下面是一些文本配置
      armedText: "释放加载",
      dragText: "上拉加载",
      readyText: "加载中...",
      processingText: "加载中...",
      processedText: "加载成功",
      failedText: "加载失败",
      noMoreText: "我可是有底线的 ~",
      textStyle: const TextStyle(fontSize: 14),
      infiniteOffset: null,
      spacing: 0,
      textBuilder: (context, state, text) {
        return const SizedBox();
      },
      messageBuilder: (context, state, text, dateTime) {
        return const SizedBox();
      },
      pullIconBuilder: (context, state, animation) {
        return const SizedBox(
          child: CupertinoActivityIndicator(radius: 10),
        );
      },
    );
  }

  /// 上拉加载完成后不展示「加载成功 / 没有更多」等结果态
  static Footer refreshFooterWithoutResult() {
    return ClassicFooter(
      triggerOffset: 50,
      showMessage: false, //是否显示描述文字 ‘上次更新时间’
      showText: true, //是否显示下面的文字
      processingText: "加载中...",
      processedText: "",
      readyText: "加载中...",
      armedText: "释放以加载更多",
      dragText: "上拉加载",
      failedText: "加载失败",
      noMoreText: "",
      textStyle: TextStyle(fontSize: 14),
      infiniteOffset: null,
      succeededIcon: const SizedBox.shrink(),
      noMoreIcon: const SizedBox.shrink(),
      textBuilder: (BuildContext context, IndicatorState state, String text) {
        if (shouldHideLoadResult(state)) {
          return const SizedBox.shrink();
        }
        return Text(text, style: TextStyle(fontSize: 14));
      },
      pullIconBuilder: (BuildContext context, IndicatorState state, double animation) {
        if (shouldHideLoadResult(state)) {
          return const SizedBox.shrink();
        }
        if (state.mode == IndicatorMode.processing || state.mode == IndicatorMode.ready) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        if (state.mode == IndicatorMode.processed || state.mode == IndicatorMode.done) {
          if (state.result == IndicatorResult.fail) {
            return const Icon(Icons.error_outline);
          }
          return const SizedBox.shrink();
        }
        return Transform.rotate(
          angle: -math.pi * animation,
          child: const Icon(Icons.arrow_downward),
        );
      },
    );
  }

  static bool shouldHideLoadResult(IndicatorState state) {
    if (state.result == IndicatorResult.noMore) {
      return true;
    }
    if (state.mode == IndicatorMode.processed || state.mode == IndicatorMode.done) {
      return state.result != IndicatorResult.fail;
    }
    return false;
  }
}
