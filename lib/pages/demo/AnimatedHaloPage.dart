import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/animated_halo.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class AnimatedHaloPage extends StatefulWidget {
  const AnimatedHaloPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AnimatedHaloPage> createState() => _AnimatedHaloPageState();
}

class _AnimatedHaloPageState extends State<AnimatedHaloPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 最近事件
  String lastEvent = '—';

  /// 边长，对应稿 72
  double size = 72;

  /// 外环描边色
  Color color = _color;

  /// 内环描边色
  Color innerColor = _innerColor;

  /// 内外环半径差
  double spacing = 6;

  /// 外环线宽
  double strokeWidth = 2;

  /// 内环线宽
  double innerStrokeWidth = 4;
  /// 一轮动画时长
  double durationMs = 1483;

  /// 中间圆形网络图
  String? imageUrl = _imageUrl;

  static const _imageUrl =
      'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737078692/im/msg/rec/651722246582308864.jpg';

  static const _color = Color(0xFF51D3B1);
  static const _innerColor = Color(0xFF00B887);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cap = (constraints.maxHeight * 0.45).clamp(240.0, 360.0);
          final previewHeight = (size + 64).clamp(240.0, cap);
          return Column(
            children: [
              buildPreview(previewHeight),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const NDescriptionCard(
                          initialLang: NLangEnum.zh,
                          title: {
                            NLangEnum.en: 'Description',
                            NLangEnum.zh: '说明',
                          },
                          subtitle: {
                            NLangEnum.en: 'Widget AnimatedHalo',
                            NLangEnum.zh: '组件 AnimatedHalo',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Blue frame is the preview bounds. child (e.g. NNetworkImage) is clipped to a circle inside the inner ring. spacing is the outer-ring radius delta (default 6).',
                              NLangEnum.zh: '蓝框是预览边界。child（如 NNetworkImage）从外部传入，裁成圆贴在内环内侧。spacing 为外环相对内环的半径增量（默认 6）。',
                            },
                          ],
                        ),
                        buildSizeCard(),
                        buildColorCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: previewHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border.all(color: Colors.blue),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(
                  child: AnimatedHalo(
                    size: size,
                    color: color,
                    innerColor: innerColor,
                    spacing: spacing,
                    strokeWidth: strokeWidth,
                    innerStrokeWidth: innerStrokeWidth,
                    duration: Duration(milliseconds: durationMs.round()),
                    child: NNetworkImage(
                      url: imageUrl ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
              child: Text(
                lastEvent,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSizeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_outlined),
      title: '尺寸',
      subtitle: 'size  spacing  strokeWidth  innerStrokeWidth  duration  child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('size'),
            min: 24,
            max: 200,
            value: size.clamp(24, 200),
            onChanged: (v) => onMark('size ${v.round()}', () => size = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('spacing'),
            min: 0,
            max: 24,
            value: spacing.clamp(0, 24),
            onChanged: (v) => onMark('spacing ${v.toStringAsFixed(1)}', () => spacing = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('strokeWidth'),
            min: 0.5,
            max: 8,
            value: strokeWidth.clamp(0.5, 8),
            onChanged: (v) => onMark('strokeWidth ${v.toStringAsFixed(1)}', () => strokeWidth = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('innerStrokeWidth'),
            min: 0.5,
            max: 8,
            value: innerStrokeWidth.clamp(0.5, 8),
            onChanged: (v) => onMark('innerStrokeWidth ${v.toStringAsFixed(1)}', () => innerStrokeWidth = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('duration'),
            min: 200,
            max: 4000,
            value: durationMs.clamp(200, 4000),
            onChanged: (v) => onMark('duration ${v.round()}ms', () => durationMs = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              final ms = v.round();
              final text = ms >= 1000 ? '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : 1)}s' : '${ms}ms';
              return Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          const Text('child'),
          buildImageChips(),
        ],
      ),
    );
  }

  Widget buildImageChips() {
    final urls = <String?>[null, ...AppRes.image.urls.where((e) => e.contains('.aliyuncs.com')).take(4)];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: urls.map((e) {
        final selected = imageUrl == e;
        return ChoiceChip(
          label: Text(e == null ? '无' : '图${urls.indexOf(e)}'),
          selected: selected,
          showCheckmark: false,
          onSelected: (on) {
            if (on) {
              onMark('child ${e ?? 'null'}', () => imageUrl = e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildColorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '颜色',
      subtitle: 'color  innerColor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceColorListItem(
            title: const Text('color'),
            value: color == _color ? null : color,
            onChanged: (e) {
              final v = e ?? _color;
              onMark('color ${v == _color ? '默' : v}', () => color = v);
            },
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('innerColor'),
            value: innerColor == _innerColor ? null : innerColor,
            onChanged: (e) {
              final v = e ?? _innerColor;
              onMark('innerColor ${v == _innerColor ? '默' : v}', () => innerColor = v);
            },
          ),
        ],
      ),
    );
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    size = 72;
    color = _color;
    innerColor = _innerColor;
    spacing = 6;
    strokeWidth = 2;
    innerStrokeWidth = 4;
    durationMs = 1483;
    imageUrl = _imageUrl;
    setState(() {});
  }
}
