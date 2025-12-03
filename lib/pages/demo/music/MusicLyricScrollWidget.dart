import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricScrollWidget extends StatefulWidget {
  final List<LyricLine> lyrics;
  final Duration currentPosition;
  final Function(Duration) onSeek;

  const LyricScrollWidget({
    Key? key,
    required this.lyrics,
    required this.currentPosition,
    required this.onSeek,
  }) : super(key: key);

  @override
  _LyricScrollWidgetState createState() => _LyricScrollWidgetState();
}

class _LyricScrollWidgetState extends State<LyricScrollWidget> {
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();

  int _currentIndex = 0;
  bool _isScrolling = false;

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  void _onScroll() {
    if (_itemPositionsListener.itemPositions.value.isNotEmpty) {
      final firstVisible = _itemPositionsListener.itemPositions.value.first;
      setState(() {
        _isScrolling = firstVisible.itemLeadingEdge != 0;
      });
    }
  }

  // 根据时间查找当前歌词索引
  int _findCurrentLyricIndex(Duration position) {
    for (int i = 0; i < widget.lyrics.length; i++) {
      if (position >= widget.lyrics[i].startTime && position < widget.lyrics[i].endTime) {
        return i;
      }
    }
    return 0;
  }

  // 滚动到当前歌词
  void _scrollToCurrentLyric(int index) {
    if (!_isScrolling && _itemScrollController.isAttached && index < widget.lyrics.length) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void didUpdateWidget(LyricScrollWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIndex = _findCurrentLyricIndex(widget.currentPosition);
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      _scrollToCurrentLyric(_currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.lyrics.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemBuilder: (context, index) {
        final lyric = widget.lyrics[index];
        final isCurrent = index == _currentIndex;

        return GestureDetector(
          onTap: () {
            widget.onSeek(lyric.startTime);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              lyric.text,
              style: TextStyle(
                fontSize: isCurrent ? 22 : 18,
                color: isCurrent ? Colors.blue : Colors.grey,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class LyricLine {
  final Duration startTime; // 开始时间
  final Duration endTime; // 结束时间
  final String text; // 歌词文本

  LyricLine({
    required this.startTime,
    required this.endTime,
    required this.text,
  });
}
