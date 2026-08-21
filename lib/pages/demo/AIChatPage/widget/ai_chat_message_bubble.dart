import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';

/// 单条聊天气泡（user 右对齐 / assistant·system 左对齐）
class AiChatMessageBubble extends StatelessWidget {
  const AiChatMessageBubble({
    super.key,
    required this.message,
    this.onResend,
  });

  final AiChatMessage message;

  /// 用户消息左侧「重发」：把内容填回输入框
  final ValueChanged<String>? onResend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg, isUser) = switch (message.role) {
      AiChatRole.user => (scheme.primary, scheme.onPrimary, true),
      AiChatRole.assistant => (const Color(0xFFF0F0F0), const Color(0xFF333333), false),
      AiChatRole.system => (const Color(0xFFFFF8E1), const Color(0xFF5D4037), false),
    };

    // 等待首包：动态三点；有内容后走可选中文本 + 光标
    final Widget body;
    if (message.content.isEmpty && message.isStreaming) {
      body = _TypingDots(color: fg);
    } else {
      body = SelectableText.rich(
        TextSpan(
          style: TextStyle(color: fg, height: 1.35, fontSize: 15),
          children: [
            TextSpan(text: message.content),
            if (message.isStreaming)
              TextSpan(text: '|', style: TextStyle(color: fg.withValues(alpha: 0.7))),
          ],
        ),
      );
    }

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(isUser ? 14 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 14),
        ),
      ),
      child: body,
    );

    if (!isUser) {
      return Align(alignment: Alignment.centerLeft, child: bubble);
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: '填入输入框',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            iconSize: 18,
            onPressed: message.content.isEmpty ? null : () => onResend?.call(message.content),
            icon: Icon(Icons.replay, color: Theme.of(context).hintColor),
          ),
          bubble,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AiChatMessage>('message', message));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('onResend', onResend));
  }
}

/// 助手尚未产出文本时的跳动三点
class _TypingDots extends StatefulWidget {
  const _TypingDots({required this.color});

  final Color color;

  @override
  State<_TypingDots> createState() => _TypingDotsState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // 错开相位，形成依次亮起的波浪
            final t = (_controller.value + i / 3) % 1.0;
            final wave = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            final opacity = 0.25 + 0.75 * wave;
            final dy = -2.0 * wave;
            return Transform.translate(
              offset: Offset(0, dy),
              child: Padding(
                padding: EdgeInsets.only(right: i == 2 ? 0 : 2),
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    '•',
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 18,
                      height: 1,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
