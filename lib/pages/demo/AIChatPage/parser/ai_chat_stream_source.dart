import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_provider.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_sse_progress.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_error.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_env_service.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/sse_event_parser.dart';

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
    final lastUser = messages.reversed
        .where((m) => m['role'] == 'user')
        .map((m) => m['content']?.trim() ?? '')
        .firstWhere((c) => c.isNotEmpty, orElse: () => '');
    final q = lastUser.isEmpty ? '（空消息）' : lastUser;
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
    String? url,
    this.apiKey = kAiDefaultApiKey,
    String? model,
  })  : dio = dio ?? Dio(),
        url = url ?? AiProvider.deepseek.defaultBaseUrl,
        model = model ?? AiProvider.deepseek.defaultModel;

  final Dio dio;

  /// 完整 completions URL
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
    // idle → hasDelta（收到正文）→ done（收到 [DONE]）
    var progress = AiSseProgress.idle;

    void note(AiStreamEvent e) {
      if (e.isDone) {
        progress = AiSseProgress.done;
      } else if (e.kind == AiStreamEventKind.delta && progress == AiSseProgress.idle) {
        progress = AiSseProgress.hasDelta;
      }
    }

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
          note(e);
          yield e;
          // 流内 error 事件后不再补 done
          if (e.kind == AiStreamEventKind.error) {
            return;
          }
        }
      }
      // 流结束时冲刷半行 / 未闭合 data
      for (final e in parser.flush()) {
        note(e);
        yield e;
        if (e.kind == AiStreamEventKind.error) {
          return;
        }
      }
      // 无 [DONE]：有正文则视为正常结束；零增量断开则按链接中断
      if (progress == AiSseProgress.hasDelta) {
        yield AiStreamEvent.done();
      } else if (progress == AiSseProgress.idle) {
        yield AiStreamEvent.error('链接中断，请检查网络后重试');
      }
    } catch (e) {
      // 用户取消不视为错误
      if (AiChatError.isCancel(e)) {
        return;
      }
      yield AiStreamEvent.error(AiChatError.format(e));
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

  @override
  Stream<AiStreamEvent> start({
    required List<Map<String, String>> messages,
    CancelToken? cancelToken,
  }) {
    return (useMock ? mock : remote).start(
      messages: messages,
      cancelToken: cancelToken,
    );
  }
}
