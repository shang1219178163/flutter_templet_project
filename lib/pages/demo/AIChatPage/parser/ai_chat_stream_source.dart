import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/sse_event_parser.dart';

/// 默认 API Key：构建时通过 `--dart-define=DEEPSEEK_API_KEY=sk-xxx` 注入
// ignore: do_not_use_environment -- 从 --dart-define 注入
const kAiDefaultApiKey = String.fromEnvironment('DEEPSEEK_API_KEY', defaultValue: '');

/// DeepSeek / OpenAI 兼容的 chat completions 地址
const kAiDefaultBaseUrl = 'https://api.deepseek.com/chat/completions';

/// 默认模型 id
const kAiDefaultModel = 'deepseek-chat';

/// 由 chat completions URL 推导 `/models` 地址
String resolveModelsUrl(String chatCompletionsUrl) {
  final t = chatCompletionsUrl.trim();
  if (t.isEmpty) {
    return 'https://api.deepseek.com/models';
  }
  if (t.contains('/chat/completions')) {
    return t.replaceFirst('/chat/completions', '/models');
  }
  if (t.endsWith('/models')) {
    return t;
  }
  final base = t.endsWith('/') ? t.substring(0, t.length - 1) : t;
  return '$base/models';
}

/// 流式对话数据源抽象：产出统一的 [AiStreamEvent]
abstract class AiChatStreamSource {
  /// [messages] 为 OpenAI 风格 `[{role, content}, ...]`（含历史多轮）
  Stream<AiStreamEvent> start({
    required List<Map<String, String>> messages,
    CancelToken? cancelToken,
  });
}

/// Mock：直接产出 delta，不走 SSE，便于本地演示打字效果
class MockAiChatStreamSource implements AiChatStreamSource {
  @override
  Stream<AiStreamEvent> start({
    required List<Map<String, String>> messages,
    CancelToken? cancelToken,
  }) async* {
    final lastUser = messages.reversed.firstWhere(
      (m) => m['role'] == 'user',
      orElse: () => const {'content': ''},
    )['content']
        ?.trim();
    final q = (lastUser == null || lastUser.isEmpty) ? '（空消息）' : lastUser;
    final reply = '这是 Mock 流式回复。\n你说：「$q」\n\n'
        '1. Dio SSE\n2. SseEventParser\n3. ChangeNotifier\n4. 打字缓冲\n';
    final random = Random();
    final runes = reply.runes.toList();
    // 每次最多 2 个码点 + 随机延迟，模拟网络抖动
    for (var i = 0; i < runes.length; i += 2) {
      if (cancelToken?.isCancelled ?? false) {
        return;
      }
      final end = min(i + 2, runes.length);
      yield AiStreamEvent.delta(String.fromCharCodes(runes.sublist(i, end)));
      await Future<void>.delayed(Duration(milliseconds: 20 + random.nextInt(40)));
    }
    if (!(cancelToken?.isCancelled ?? false)) {
      yield AiStreamEvent.done();
    }
  }
}

/// 真实 SSE（OpenAI / DeepSeek 兼容 chat completions + stream:true）
class DioSseAiChatStreamSource implements AiChatStreamSource {
  DioSseAiChatStreamSource({
    Dio? dio,
    this.url = kAiDefaultBaseUrl,
    this.apiKey = kAiDefaultApiKey,
    this.model = kAiDefaultModel,
  }) : dio = dio ?? Dio();

  final Dio dio;

  /// 完整 completions URL（可在设置页修改）
  String url;

  String apiKey;

  /// 下次请求使用的 model 字段
  String model;

  @override
  Stream<AiStreamEvent> start({
    required List<Map<String, String>> messages,
    CancelToken? cancelToken,
  }) async* {
    if (url.trim().isEmpty) {
      yield AiStreamEvent.error('SSE URL 为空');
      return;
    }

    final parser = SseEventParser();
    // 有状态 UTF-8 解码，避免多字节字符跨包被拆坏
    const utf8Decoder = Utf8Decoder(allowMalformed: true);
    // 部分服务只关连接不发 [DONE]，用此标记补发 done
    var sawDone = false;
    try {
      final response = await dio.post<ResponseBody>(
        url.trim(),
        data: {
          'model': model,
          'stream': true,
          'messages': messages,
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
            if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
          },
        ),
        cancelToken: cancelToken,
      );

      final body = response.data;
      if (body == null) {
        yield AiStreamEvent.error('空响应流');
        return;
      }

      await for (final chunk in utf8Decoder.bind(body.stream)) {
        if (cancelToken?.isCancelled ?? false) {
          return;
        }
        if (chunk.isEmpty) {
          continue;
        }
        for (final e in parser.addChunk(chunk)) {
          if (e.isDone) {
            sawDone = true;
          }
          yield e;
        }
      }
      // 流结束时冲刷半行 / 未闭合 data
      for (final e in parser.flush()) {
        if (e.isDone) {
          sawDone = true;
        }
        yield e;
      }
      if (!sawDone) {
        yield AiStreamEvent.done();
      }
    } on DioException catch (e) {
      // 用户取消不视为错误
      if (!CancelToken.isCancel(e)) {
        yield AiStreamEvent.error(e.message ?? e.toString());
      }
    } catch (e) {
      yield AiStreamEvent.error(e.toString());
    }
  }
}

/// Mock / Remote 切换包装；URL、Key、Model 都落在 [remote] 上
class SwitchingAiChatStreamSource implements AiChatStreamSource {
  SwitchingAiChatStreamSource({
    MockAiChatStreamSource? mock,
    DioSseAiChatStreamSource? remote,
  })  : mock = mock ?? MockAiChatStreamSource(),
        remote = remote ?? DioSseAiChatStreamSource();

  final MockAiChatStreamSource mock;
  final DioSseAiChatStreamSource remote;

  /// true 走本地 Mock；false 走真实 SSE
  bool useMock = false;

  String get sseUrl => remote.url;

  set sseUrl(String value) => remote.url = value;

  /// 由当前 completions URL 推导的 models 地址
  String get modelsUrl => resolveModelsUrl(sseUrl);

  @override
  Stream<AiStreamEvent> start({
    required List<Map<String, String>> messages,
    CancelToken? cancelToken,
  }) {
    return (useMock ? mock : remote).start(messages: messages, cancelToken: cancelToken);
  }
}
