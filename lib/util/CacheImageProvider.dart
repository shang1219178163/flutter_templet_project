import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:f_limit/f_limit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:path_provider/path_provider.dart';

@immutable
class CacheImageProvider extends painting.ImageProvider<painting.NetworkImage> implements painting.NetworkImage {
  const CacheImageProvider(
    this.url, {
    this.scale = 1.0,
    this.headers,
  });

  @override
  final String url;
  @override
  final double scale;
  @override
  final Map<String, String>? headers;

// 🔑 核心改动：使用 f_limit 替换原有的并发控制
// 限制最多10个并发图片加载，使用LIFO策略（最新请求优先）
  static final _imageLoader = fLimit(10, queueStrategy: QueueStrategy.lifo);

  @override
  Future<CacheImageProvider> obtainKey(
    painting.ImageConfiguration configuration,
  ) {
    return SynchronousFuture<CacheImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    painting.NetworkImage key,
    painting.ImageDecoderCallback decode,
  ) {
    final chunkEvents = StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      chunkEvents: chunkEvents.stream,
      codec: _loadAsync(key, chunkEvents, decode: decode),
      scale: key.scale,
      debugLabel: key.url,
    );
  }

// 🔑 关键改动：使用 f_limit 控制并发
  Future<ui.Codec> _loadAsync(
    painting.NetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents, {
    required painting.ImageDecoderCallback decode,
  }) async {
    // 使用 f_limit 来控制并发，避免同时发起太多请求
    return _imageLoader(() async {
      try {
        assert(key == this);

        final String cacheKey = _cacheKeyFromImage(key.url);
        final File cacheFile = await _childFile(cacheKey);

        // 先尝试从缓存加载
        if (cacheFile.existsSync()) {
          try {
            final buffer = await cacheFile.readAsBytes();
            final immutableBuffer = await ui.ImmutableBuffer.fromUint8List(buffer);
            return await decode(immutableBuffer);
          } catch (e) {
            // 缓存文件损坏，删除后重新下载
            await cacheFile.delete().catchError((_) => {});
          }
        }

        // 缓存不存在或已损坏，从网络下载
        final bytes = await getBytesFromNetwork(
          key.url,
          headers: headers,
          chunkEvents: chunkEvents,
        ).timeout(Duration(seconds: 30));

        if (bytes.lengthInBytes == 0) {
          throw Exception('NetworkImage is an empty file');
        }

        // 解码图片
        final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
        final codec = await decode(buffer);

        // 解码成功后写入缓存
        await cacheFile.writeAsBytes(bytes).catchError((_) => {});

        return codec;
      } catch (e) {
        // 失败时清除缓存
        scheduleMicrotask(() {
          PaintingBinding.instance.imageCache.evict(key);
        });
        rethrow;
      } finally {
        chunkEvents.close();
      }
    });
  }

// 辅助方法
  static String _cacheKeyFromImage(String url) {
    return base64Url.encode(utf8.encode(url));
  }

  static Future<File> _childFile(String cacheKey) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/image-caches/$cacheKey');
    return file;
  }

  static Future<Uint8List> getBytesFromNetwork(
    String url, {
    Map<String, String>? headers,
    StreamController<ImageChunkEvent>? chunkEvents,
  }) async {
    final resolved = Uri.base.resolve(url);
    final httpClient = HttpClient()..autoUncompress = false;

    final request = await httpClient.getUrl(resolved);
    headers?.forEach((name, value) => request.headers.add(name, value));

    final response = await request.close();

    if (response.statusCode != HttpStatus.ok) {
      throw painting.NetworkImageLoadException(
        statusCode: response.statusCode,
        uri: resolved,
      );
    }

    return consolidateHttpClientResponseBytes(
      response,
      onBytesReceived: (int cumulative, int? total) {
        chunkEvents?.add(ImageChunkEvent(
          cumulativeBytesLoaded: cumulative,
          expectedTotalBytes: total,
        ));
      },
    );
  }

  @override
  bool operator ==(Object other) => other is CacheImageProvider && url == other.url && scale == other.scale;

  @override
  int get hashCode => url.hashCode ^ scale.hashCode;
}
