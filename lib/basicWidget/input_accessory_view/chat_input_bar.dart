import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/input_accessory_view/chat_input_emoji.dart';

enum InputType {
  text,
  emoji,
}

class EmojiInputView extends StatelessWidget {
  const EmojiInputView({
    super.key,
    required InputType inputType,
    required this.textEditingController,
  }) : _inputType = inputType;

  final InputType _inputType;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      onEnd: () {},
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      height: _inputType == InputType.emoji ? 280 : 0,
      child: Container(
        color: isDark ? const Color(0xff21213d) : Colors.white,
        child: ChatInputEmoji(
          deleteOnTap: () {
            var selection = textEditingController.selection;
            var value = textEditingController.value;
            if (selection.baseOffset != selection.extentOffset) {
              textEditingController.text = textEditingController.text.replaceRange(selection.start, selection.end, '');
              textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: selection.start));
            } else if (selection.baseOffset == 0) {
              return;
            } else if (selection.baseOffset != value.text.length) {
              var subText = value.text.substring(0, selection.start);
              subText = subText.characters.skipLast(1).toString();
              var text = subText.characters.skipLast(1).toString() + value.text.substring(selection.start);
              var newSelection = TextSelection.fromPosition(TextPosition(offset: subText.length));

              textEditingController.value = TextEditingValue(
                text: text,
                selection: newSelection,
              );
            } else {
              var text = value.text.characters.skipLast(1).toString();
              var newSelection = TextSelection.fromPosition(TextPosition(offset: text.length));

              textEditingController.value = TextEditingValue(
                text: text,
                selection: newSelection,
              );
            }
          },
          emojiClicked: (emoji) {
            var selection = textEditingController.selection;

// 确保选区有效性
            if (selection.start < 0 || selection.end < 0 || selection.start > textEditingController.text.length) {
              // 如果选区无效，将光标移动到文本末尾并插入 emoji
              textEditingController.text += emoji;
              textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length),
              );
            } else if (selection.baseOffset != selection.extentOffset) {
              // 替换选区中的文本为 emoji
              textEditingController.text = textEditingController.text.replaceRange(
                selection.start,
                selection.end,
                emoji,
              );
              textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: selection.start + emoji.length),
              );
            } else {
              // 在光标处插入 emoji
              textEditingController.text = textEditingController.text.substring(0, selection.start) +
                  emoji +
                  textEditingController.text.substring(selection.start);
              textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: selection.start + emoji.length),
              );
            }
          },
        ),
      ),
    );
  }
}
