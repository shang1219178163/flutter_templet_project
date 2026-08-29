import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/animated_halo.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class AnimatedHaloPage extends StatefulWidget {
  const AnimatedHaloPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AnimatedHaloPage> createState() => _AnimatedHaloPageState();
}

class _AnimatedHaloPageState extends State<AnimatedHaloPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
    final scheme = Theme.of(context).colorScheme;
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
    final scheme = Theme.of(context).colorScheme;
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
    final theme = Theme.of(context);
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
      subtitle: 'size  spacing  strokeWidth  innerStrokeWidth  child',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: 'size',
            value: size,
            min: 24,
            max: 200,
            onChanged: (v) => onMark('size ${v.round()}', () => size = v),
          ),
          buildSlider(
            label: 'spacing',
            value: spacing,
            min: 0,
            max: 24,
            fractionDigits: 1,
            onChanged: (v) => onMark('spacing ${v.toStringAsFixed(1)}', () => spacing = v),
          ),
          buildSlider(
            label: 'strokeWidth',
            value: strokeWidth,
            min: 0.5,
            max: 8,
            fractionDigits: 1,
            onChanged: (v) => onMark('strokeWidth ${v.toStringAsFixed(1)}', () => strokeWidth = v),
          ),
          buildSlider(
            label: 'innerStrokeWidth',
            value: innerStrokeWidth,
            min: 0.5,
            max: 8,
            fractionDigits: 1,
            onChanged: (v) => onMark('innerStrokeWidth ${v.toStringAsFixed(1)}', () => innerStrokeWidth = v),
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
          buildColorRow('color', color, _color, (v) => onMark('color ${v == _color ? '默' : v}', () => color = v)),
          buildColorRow(
            'innerColor',
            innerColor,
            _innerColor,
            (v) => onMark('innerColor ${v == _innerColor ? '默' : v}', () => innerColor = v),
          ),
        ],
      ),
    );
  }

  Widget buildColorRow(String label, Color value, Color fallback, ValueChanged<Color> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        buildColorDots(value: value, fallback: fallback, onChanged: onChanged),
      ],
    );
  }

  Widget buildColorDots({
    required Color value,
    required Color fallback,
    required ValueChanged<Color> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = e == null ? value == fallback : value == e;
        return GestureDetector(
          onTap: () => onChanged(e ?? fallback),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: e ?? scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: e == null
                ? Text('默', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600))
                : selected
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color:
                            ThemeData.estimateBrightnessForColor(e) == Brightness.dark ? Colors.white : Colors.black87,
                      )
                    : null,
          ),
        );
      }).toList(),
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    int fractionDigits = 0,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return NSlider(
      leading: SizedBox(
        width: 108,
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
      trailingBuilder: (context, v) {
        return Text(
          v.toStringAsFixed(fractionDigits),
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
            fontFamily: 'monospace',
          ),
        );
      },
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
    imageUrl = _imageUrl;
    setState(() {});
  }
}
