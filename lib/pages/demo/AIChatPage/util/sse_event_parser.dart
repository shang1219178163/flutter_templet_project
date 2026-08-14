import 'dart:convert';

import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';

/// OpenAI 兼容 SSE 增量解析器：`data: {...}` / `data: [DONE]`。
///
/// 按行缓冲：TCP 分包可能切断一行，需跨 chunk 拼接后再解析。
class SseEventParser {
  /// 尚未凑齐换行的半行缓冲
  final StringBuffer _lineBuf = StringBuffer();

  /// 当前事件块内累积的 data 行（空行触发 dispatch）
  final List<String> _dataLines = [];

  /// 喂入一段字符串（通常是某次网络 chunk 解码结果）
  List<AiStreamEvent> addChunk(String chunk) {
    final out = <AiStreamEvent>[];
    // 统一换行，再按 \n 切行
    var text = (_lineBuf..write(chunk)).toString().replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    while (true) {
      final idx = text.indexOf('\n');
      if (idx < 0) {
        break;
      }
      out.addAll(_consumeLine(text.substring(0, idx)));
      text = text.substring(idx + 1);
    }
    // 剩余无换行部分留到下次
    _lineBuf
      ..clear()
      ..write(text);
    return out;
  }

  /// 流结束时调用：处理半行与未 dispatch 的 data
  List<AiStreamEvent> flush() {
    final out = <AiStreamEvent>[];
    final rest = _lineBuf.toString();
    _lineBuf.clear();
    if (rest.isNotEmpty) {
      out.addAll(_consumeLine(rest));
    }
    if (_dataLines.isNotEmpty) {
      out.addAll(_dispatch());
    }
    return out;
  }

  /// 消费一行 SSE 文本
  List<AiStreamEvent> _consumeLine(String line) {
    // 空行 = 一个事件结束
    if (line.isEmpty) {
      return _dispatch();
    }
    // 注释行（心跳等）忽略
    if (line.startsWith(':')) {
      return const [];
    }
    if (line.startsWith('data:')) {
      _dataLines.add(line.length > 5 ? line.substring(5).trimLeft() : '');
    }
    return const [];
  }

  /// 将累积的 data 行解析为 [AiStreamEvent]
  List<AiStreamEvent> _dispatch() {
    if (_dataLines.isEmpty) {
      return const [];
    }
    final data = _dataLines.join('\n').trim();
    _dataLines.clear();
    if (data == '[DONE]') {
      return [AiStreamEvent.done()];
    }

    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map) {
        return [AiStreamEvent.error('SSE data is not a JSON object')];
      }
      final map = Map<String, dynamic>.from(decoded);
      // OpenAI 风格错误对象
      if (map['error'] != null) {
        return [AiStreamEvent.error(map['error'].toString())];
      }
      final content = _deltaContent(map);
      if (content == null || content.isEmpty) {
        // role / finish_reason 等无正文的帧直接跳过
        return const [];
      }
      return [AiStreamEvent.delta(content)];
    } catch (e) {
      return [AiStreamEvent.error('SSE JSON parse failed: $e')];
    }
  }

  /// 从 JSON 取出增量 content（兼容 delta / message / 顶层字段）
  String? _deltaContent(Map<String, dynamic> map) {
    final choices = map['choices'];
    if (choices is List && choices.isNotEmpty && choices.first is Map) {
      final first = Map<String, dynamic>.from(choices.first as Map);
      final delta = first['delta'];
      if (delta is Map && delta['content'] is String) {
        return delta['content'] as String;
      }
      final message = first['message'];
      if (message is Map && message['content'] is String) {
        return message['content'] as String;
      }
    }
    if (map['content'] is String) {
      return map['content'] as String;
    }
    if (map['delta'] is String) {
      return map['delta'] as String;
    }
    return null;
  }
}
