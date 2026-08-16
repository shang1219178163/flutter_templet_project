import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_stream_event_kind.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_error.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/sse_event_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiChatError.isCancel', () {
    test('Dio cancel', () {
      final token = CancelToken()..cancel('user_stop');
      expect(
        AiChatError.isCancel(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.cancel,
            error: 'user_stop',
          ),
        ),
        isTrue,
      );
      expect(token.isCancelled, isTrue);
    });

    test('仅认本模块 cancel reason，不认泛 cancel 文案', () {
      expect(AiChatError.isCancel('user_stop'), isTrue);
      expect(AiChatError.isCancel('dispose'), isTrue);
      expect(AiChatError.isCancel('fail'), isTrue);
      expect(AiChatError.isCancel('Exception: user_stop'), isTrue);
      expect(AiChatError.isCancel('Request was cancelled'), isFalse);
      expect(AiChatError.isCancel('operation cancel by peer'), isFalse);
    });
  });

  group('AiChatError.format / isConnectionIssue', () {
    test('SocketException → 中文连接文案', () {
      final text = AiChatError.format(const SocketException('Connection reset'));
      expect(text, contains('网络'));
      expect(AiChatError.isConnectionIssue(const SocketException('x')), isTrue);
    });

    test('401', () {
      expect(
        AiChatError.format(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
            ),
          ),
        ),
        contains('401'),
      );
    });
  });

  group('SseEventParser', () {
    test('delta + DONE', () {
      final p = SseEventParser();
      final events = p.addChunk(
        'data: {"choices":[{"delta":{"content":"你"}}]}\n\n'
        'data: [DONE]\n\n',
      );
      expect(events.length, 2);
      expect(events[0].kind, AiStreamEventKind.delta);
      expect(events[0].delta, '你');
      expect(events[1].kind, AiStreamEventKind.done);
    });

    test('跨 chunk 半行', () {
      final p = SseEventParser();
      expect(p.addChunk('data: {"choices":[{"delta":{"content":"好'), isEmpty);
      final events = p.addChunk('"}}]}\n\n');
      expect(events.single.delta, '好');
    });

    test('非对象 JSON → 中文错误', () {
      final p = SseEventParser();
      final events = p.addChunk('data: [1,2]\n\n');
      expect(events.single.kind, AiStreamEventKind.error);
      expect(events.single.message, contains('JSON'));
    });
  });
}
