import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/provider/rxDart_provider_demo.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricScrollWidget extends StatefulWidget {
  const LyricScrollWidget({
    Key? key,
    required this.lyrics,
    required this.positionStream,
    required this.onSeek,
  }) : super(key: key);

  final List<LyricLine> lyrics;
  final Stream<Duration> positionStream;
  final Function(Duration position) onSeek;

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
    widget.positionStream.listen(_onPosition);
  }

  void _onScroll() {
    if (_itemPositionsListener.itemPositions.value.isNotEmpty) {
      final firstVisible = _itemPositionsListener.itemPositions.value.first;
      _isScrolling = firstVisible.itemLeadingEdge != 0;
      setState(() {});
    }
  }

  void _onPosition(Duration position) {
    final newIndex = _findCurrentLyricIndex(position);
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      _scrollToCurrentLyric(_currentIndex);
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
    if (!_itemScrollController.isAttached) {
      return;
    }
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.lyrics.length + 1,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemBuilder: (context, index) {
        if (index == widget.lyrics.length) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.green,
          );
        }
        final e = widget.lyrics[index];
        final isCurrent = index == _currentIndex;

        var title = e.text;
        title = "$e";
        return GestureDetector(
          onTap: () {
            widget.onSeek(e.startTime);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: isCurrent ? 16 : 15,
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
  LyricLine({
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  final Duration startTime; // 开始时间
  final Duration endTime; // 结束时间
  final String text; // 歌词文本

  String get startTimeStr => startTime.toString().split(".").first;
  String get endTimeStr => endTime.toString().split(".").first;

  @override
  String toString() {
    final result = "[${startTimeStr} - ${endTimeStr}] ${text}";
    return result;
  }
}
