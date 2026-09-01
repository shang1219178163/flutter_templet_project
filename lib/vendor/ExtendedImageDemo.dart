import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class ExtendedImageDemo extends StatefulWidget {
  ExtendedImageDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ExtendedImageDemo> createState() => _ExtendedImageDemoState();
}

class _ExtendedImageDemoState extends State<ExtendedImageDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 原 Demo 使用网络图 + cache + BoxFit.fill + loadStateChanged
  int urlIndex = 0;
  bool useWidth = true;
  double width = 200;
  bool useHeight = true;
  double height = 200;
  BoxFit fit = BoxFit.fill;
  Alignment alignment = Alignment.center;
  ImageRepeat repeat = ImageRepeat.noRepeat;
  FilterQuality filterQuality = FilterQuality.low;
  ClipKind clipKind = ClipKind.antiAlias;
  ShapeKind shapeKind = ShapeKind.rounded;
  double shapeRadius = 8;
  bool useBorder = false;
  Color? borderColor = Colors.red;
  double borderWidth = 1;
  Color? color;
  BlendMode colorBlendMode = BlendMode.srcIn;
  bool cache = true;
  bool enableLoadState = true;
  bool useLoadStateChanged = true;
  ExtendedImageMode mode = ExtendedImageMode.none;
  bool clearMemoryCacheIfFailed = true;
  bool enableSlideOutPage = false;
  bool handleLoadingProgress = false;
  bool isAntiAlias = false;
  double scale = 1;
  double retries = 3;
  bool gaplessPlayback = false;
  bool matchTextDirection = false;
  bool excludeFromSemantics = false;
  bool useSemanticLabel = false;
  bool clearMemoryCacheWhenDispose = false;
  bool useLayoutInsets = false;
  double layoutInset = 16;
  String lastEvent = '—';

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
          final previewHeight = (constraints.maxHeight * 0.42).clamp(280.0, 400.0);
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
                            NLangEnum.en: 'Widget ExtendedImage.network',
                            NLangEnum.zh: '组件 ExtendedImage.network',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Preview is the original ClipRRect + loadStateChanged card. Unfinished load shows a teal photo icon; completed uses ExtendedRawImage with BoxFit.fill.',
                              NLangEnum.zh: '预览沿用原 buildCardItem：ClipRRect 圆角 8。未完成显示 photo 图标，完成后 ExtendedRawImage 且 BoxFit.fill。',
                            },
                            {
                              NLangEnum.en:
                                  'Network defaults: cache true, enableLoadState true. Original fit is BoxFit.fill. loadStateChanged replaces the completed child, so turn it off to try gesture/editor.',
                              NLangEnum.zh:
                                  '网络默认 cache、enableLoadState 为 true。原 Demo fit 为 BoxFit.fill。loadStateChanged 会替换完成态，调试缩放/裁剪时请关掉。',
                            },
                            {
                              NLangEnum.en:
                                  'onDoubleTap fires in gesture mode. ShapeKind maps BoxShape and borderRadius.',
                              NLangEnum.zh: 'onDoubleTap 仅在 gesture 模式触发。ShapeKind 映射 BoxShape/borderRadius。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildSurfaceCard(),
                        buildNetworkCard(),
                        buildBehaviorCard(),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: previewHeight,
            width: double.infinity,
            child: ClipRect(
              child: ColoredBox(
                color: scheme.surface,
                child: Center(
                  child: buildCardItem(
                    url: AppRes.image.urls[urlIndex],
                    fit: fit,
                    width: useWidth ? width : null,
                    height: useHeight ? height : null,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
    );
  }

  Widget buildCardItem({
    required String url,
    BoxFit fit = BoxFit.fill,
    double? width,
    double? height,
  }) {
    return ExtendedImage.network(
        url,
        key: ValueKey('$urlIndex-$cache-$scale-$retries-$mode'),
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        filterQuality: filterQuality,
        clipBehavior: clipOf(),
        shape: shapeOf(),
        borderRadius: borderRadiusOf(),
        border: useBorder ? Border.all(color: borderColor ?? Colors.red, width: borderWidth) : null,
        color: color,
        colorBlendMode: color != null ? colorBlendMode : null,
        cache: cache,
        enableLoadState: enableLoadState,
        mode: mode,
        clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
        enableSlideOutPage: enableSlideOutPage,
        handleLoadingProgress: handleLoadingProgress,
        isAntiAlias: isAntiAlias,
        scale: scale,
        retries: retries.round(),
        gaplessPlayback: gaplessPlayback,
        matchTextDirection: matchTextDirection,
        excludeFromSemantics: excludeFromSemantics,
        semanticLabel: useSemanticLabel ? 'extended image' : null,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        layoutInsets: layoutInsetsOf(),
        cacheRawData: mode == ExtendedImageMode.editor,
        initGestureConfigHandler: mode == ExtendedImageMode.gesture ? (state) => GestureConfig() : null,
        initEditorConfigHandler: mode == ExtendedImageMode.editor ? (state) => EditorConfig() : null,
        onDoubleTap: mode == ExtendedImageMode.gesture ? onDoubleTap : null,
        loadStateChanged: useLoadStateChanged
            ? (state) {
                if (state.extendedImageLoadState != LoadState.completed) {
                  return Icon(
                    Icons.photo,
                    color: Colors.teal.shade100,
                    size: 100,
                  );
                }
                var widget = ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  width: width,
                  height: height,
                  fit: fit,
                );
                DLog.d('Source Rect width ${widget.width} height : ${widget.height}');
                return widget;
              }
            : null,
    );
  }

  Clip clipOf() => clipKind.clip;

  BoxShape? shapeOf() {
    switch (shapeKind) {
      case ShapeKind.none:
        return null;
      case ShapeKind.rounded:
        return BoxShape.rectangle;
      case ShapeKind.stadium:
        return BoxShape.circle;
    }
  }

  BorderRadius? borderRadiusOf() {
    if (shapeKind != ShapeKind.rounded) {
      return null;
    }
    return BorderRadius.circular(shapeRadius);
  }

  EdgeInsets layoutInsetsOf() {
    if (!useLayoutInsets) {
      return EdgeInsets.zero;
    }
    return EdgeInsets.all(layoutInset);
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'url · fit · alignment · repeat · filterQuality · clipBehavior · shape · mode',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'url',
            child: buildChoiceChips(
              values: const [0, 1, 2, 3, 4],
              isSelected: (e) => urlIndex == e,
              labelOf: (e) => 'urls[$e]',
              onChanged: onUrlIndex,
            ),
          ),
          buildField(
            label: 'fit',
            showTopGap: true,
            child: buildChoiceChips(
              values: BoxFit.values,
              isSelected: (e) => fit == e,
              labelOf: (e) => e.name,
              onChanged: onFit,
            ),
          ),
          buildField(
            label: 'alignment',
            showTopGap: true,
            child: buildChoiceChips(
              values: AlignmentExt.allCases,
              isSelected: (e) => alignment == e,
              labelOf: (e) => e.toString().split('.').last,
              onChanged: onAlignment,
            ),
          ),
          buildField(
            label: 'repeat',
            showTopGap: true,
            child: buildChoiceChips(
              values: ImageRepeat.values,
              isSelected: (e) => repeat == e,
              labelOf: (e) => e.name,
              onChanged: onRepeat,
            ),
          ),
          buildField(
            label: 'filterQuality',
            showTopGap: true,
            child: buildChoiceChips(
              values: FilterQuality.values,
              isSelected: (e) => filterQuality == e,
              labelOf: (e) => e.name,
              onChanged: onFilterQuality,
            ),
          ),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: ClipKind.values,
              isSelected: (e) => clipKind == e,
              labelOf: (e) => e.label,
              onChanged: onClipKind,
            ),
          ),
          buildField(
            label: 'shape',
            showTopGap: true,
            child: buildChoiceChips(
              values: ShapeKind.values,
              isSelected: (e) => shapeKind == e,
              labelOf: (e) {
                switch (e) {
                  case ShapeKind.none:
                    return 'none';
                  case ShapeKind.rounded:
                    return 'rounded';
                  case ShapeKind.stadium:
                    return 'circle';
                }
              },
              onChanged: onShapeKind,
            ),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(
              label: 'borderRadius',
              value: shapeRadius,
              min: 0,
              max: 80,
              onChanged: onShapeRadius,
            ),
          buildField(
            label: 'mode',
            showTopGap: true,
            child: buildChoiceChips(
              values: ExtendedImageMode.values,
              isSelected: (e) => mode == e,
              labelOf: (e) => e.name,
              onChanged: onMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '外观',
      subtitle: 'width · height · color · colorBlendMode · border · layoutInsets',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'width',
            value: useWidth,
            onChanged: onUseWidth,
          ),
          if (useWidth)
            buildSlider(
              label: 'width',
              value: width,
              min: 40,
              max: 360,
              onChanged: onWidth,
            ),
          buildSwitch(
            title: 'height',
            value: useHeight,
            onChanged: onUseHeight,
          ),
          if (useHeight)
            buildSlider(
              label: 'height',
              value: height,
              min: 40,
              max: 360,
              onChanged: onHeight,
            ),
          buildField(
            label: 'color',
            showTopGap: true,
            child: buildColorDots(value: color, onChanged: onColor),
          ),
          if (color != null)
            buildField(
              label: 'colorBlendMode',
              showTopGap: true,
              child: buildChoiceChips(
                values: BlendMode.values,
                isSelected: (e) => colorBlendMode == e,
                labelOf: (e) => e.name,
                onChanged: onColorBlendMode,
              ),
            ),
          buildSwitch(
            title: 'border',
            value: useBorder,
            onChanged: onUseBorder,
          ),
          if (useBorder) ...[
            buildField(
              label: 'border.color',
              showTopGap: true,
              child: buildColorDots(value: borderColor, onChanged: onBorderColor),
            ),
            buildSlider(
              label: 'border.width',
              value: borderWidth,
              min: 0.5,
              max: 8,
              onChanged: onBorderWidth,
              fractionDigits: 1,
            ),
          ],
          buildSwitch(
            title: 'layoutInsets',
            value: useLayoutInsets,
            onChanged: onUseLayoutInsets,
          ),
          if (useLayoutInsets)
            buildSlider(
              label: 'layoutInsets',
              value: layoutInset,
              min: 0,
              max: 48,
              onChanged: onLayoutInset,
            ),
        ],
      ),
    );
  }

  Widget buildNetworkCard() {
    return NDecorationCard(
      icon: const Icon(Icons.cloud_download_outlined),
      title: '网络',
      subtitle: 'cache · scale · retries · enableLoadState · loadStateChanged · memory',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'cache',
            value: cache,
            onChanged: onCache,
          ),
          buildSlider(
            label: 'scale',
            value: scale,
            min: 0.5,
            max: 3,
            onChanged: onScale,
            fractionDigits: 2,
          ),
          buildSlider(
            label: 'retries',
            value: retries,
            min: 0,
            max: 8,
            onChanged: onRetries,
          ),
          buildSwitch(
            title: 'enableLoadState',
            value: enableLoadState,
            onChanged: onEnableLoadState,
          ),
          buildSwitch(
            title: 'loadStateChanged',
            value: useLoadStateChanged,
            onChanged: onUseLoadStateChanged,
          ),
          buildSwitch(
            title: 'handleLoadingProgress',
            value: handleLoadingProgress,
            onChanged: onHandleLoadingProgress,
          ),
          buildSwitch(
            title: 'clearMemoryCacheIfFailed',
            value: clearMemoryCacheIfFailed,
            onChanged: onClearMemoryCacheIfFailed,
          ),
          buildSwitch(
            title: 'clearMemoryCacheWhenDispose',
            value: clearMemoryCacheWhenDispose,
            onChanged: onClearMemoryCacheWhenDispose,
          ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'gaplessPlayback · semantics · isAntiAlias · onDoubleTap',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSwitch(
            title: 'gaplessPlayback',
            value: gaplessPlayback,
            onChanged: onGaplessPlayback,
          ),
          buildSwitch(
            title: 'matchTextDirection',
            value: matchTextDirection,
            onChanged: onMatchTextDirection,
          ),
          buildSwitch(
            title: 'excludeFromSemantics',
            value: excludeFromSemantics,
            onChanged: onExcludeFromSemantics,
          ),
          buildSwitch(
            title: 'semanticLabel',
            value: useSemanticLabel,
            onChanged: onUseSemanticLabel,
          ),
          buildSwitch(
            title: 'isAntiAlias',
            value: isAntiAlias,
            onChanged: onIsAntiAlias,
          ),
          if (mode != ExtendedImageMode.none)
            buildSwitch(
              title: 'enableSlideOutPage',
              value: enableSlideOutPage,
              onChanged: onEnableSlideOutPage,
            ),
        ],
      ),
    );
  }

  Widget buildField({
    required String label,
    required Widget child,
    bool showTopGap = false,
  }) {
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopGap) const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              fontSize: 12.5,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required bool Function(T value) isSelected,
    required String Function(T value) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((e) {
        final selected = isSelected(e);
        return ChoiceChip(
          label: Text(labelOf(e)),
          selected: selected,
          showCheckmark: false,
          selectedColor: scheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'monospace',
            fontSize: 12.5,
          ),
          side: BorderSide(
            color: selected ? scheme.primary.withValues(alpha: 0.35) : scheme.outlineVariant.withValues(alpha: 0.65),
          ),
          onSelected: (on) {
            if (on) {
              onChanged(e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(e),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e ?? scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.65),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: e == null
                  ? Text(
                      '默',
                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    )
                  : selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
            ),
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
    final scheme = theme.colorScheme;
    return NSliderListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
      valueBuilder: fractionDigits > 0
          ? (context, v) {
              return Text(
                v.toStringAsFixed(fractionDigits),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            }
          : null,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final scheme = theme.colorScheme;
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
          fontSize: 13.5,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  void onUrlIndex(int value) {
    urlIndex = value;
    setState(() {});
  }

  void onFit(BoxFit value) {
    fit = value;
    setState(() {});
  }

  void onAlignment(Alignment value) {
    alignment = value;
    setState(() {});
  }

  void onRepeat(ImageRepeat value) {
    repeat = value;
    setState(() {});
  }

  void onFilterQuality(FilterQuality value) {
    filterQuality = value;
    setState(() {});
  }

  void onClipKind(ClipKind value) {
    clipKind = value;
    setState(() {});
  }

  void onShapeKind(ShapeKind value) {
    shapeKind = value;
    setState(() {});
  }

  void onShapeRadius(double value) {
    shapeRadius = value;
    setState(() {});
  }

  void onMode(ExtendedImageMode value) {
    mode = value;
    if (mode == ExtendedImageMode.none) {
      enableSlideOutPage = false;
    }
    setState(() {});
  }

  void onUseWidth(bool value) {
    useWidth = value;
    setState(() {});
  }

  void onWidth(double value) {
    width = value;
    setState(() {});
  }

  void onUseHeight(bool value) {
    useHeight = value;
    setState(() {});
  }

  void onHeight(double value) {
    height = value;
    setState(() {});
  }

  void onColor(Color? value) {
    color = value;
    setState(() {});
  }

  void onColorBlendMode(BlendMode value) {
    colorBlendMode = value;
    setState(() {});
  }

  void onUseBorder(bool value) {
    useBorder = value;
    setState(() {});
  }

  void onBorderColor(Color? value) {
    borderColor = value;
    setState(() {});
  }

  void onBorderWidth(double value) {
    borderWidth = value;
    setState(() {});
  }

  void onUseLayoutInsets(bool value) {
    useLayoutInsets = value;
    setState(() {});
  }

  void onLayoutInset(double value) {
    layoutInset = value;
    setState(() {});
  }

  void onCache(bool value) {
    cache = value;
    setState(() {});
  }

  void onScale(double value) {
    scale = value;
    setState(() {});
  }

  void onRetries(double value) {
    retries = value;
    setState(() {});
  }

  void onEnableLoadState(bool value) {
    enableLoadState = value;
    setState(() {});
  }

  void onUseLoadStateChanged(bool value) {
    useLoadStateChanged = value;
    setState(() {});
  }

  void onHandleLoadingProgress(bool value) {
    handleLoadingProgress = value;
    setState(() {});
  }

  void onClearMemoryCacheIfFailed(bool value) {
    clearMemoryCacheIfFailed = value;
    setState(() {});
  }

  void onClearMemoryCacheWhenDispose(bool value) {
    clearMemoryCacheWhenDispose = value;
    setState(() {});
  }

  void onGaplessPlayback(bool value) {
    gaplessPlayback = value;
    setState(() {});
  }

  void onMatchTextDirection(bool value) {
    matchTextDirection = value;
    setState(() {});
  }

  void onExcludeFromSemantics(bool value) {
    excludeFromSemantics = value;
    setState(() {});
  }

  void onUseSemanticLabel(bool value) {
    useSemanticLabel = value;
    setState(() {});
  }

  void onIsAntiAlias(bool value) {
    isAntiAlias = value;
    setState(() {});
  }

  void onEnableSlideOutPage(bool value) {
    enableSlideOutPage = value;
    setState(() {});
  }

  void onDoubleTap(ExtendedImageGestureState state) {
    lastEvent = 'onDoubleTap';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onReset() {
    urlIndex = 0;
    useWidth = true;
    width = 200;
    useHeight = true;
    height = 200;
    fit = BoxFit.fill;
    alignment = Alignment.center;
    repeat = ImageRepeat.noRepeat;
    filterQuality = FilterQuality.low;
    clipKind = ClipKind.antiAlias;
    shapeKind = ShapeKind.rounded;
    shapeRadius = 8;
    useBorder = false;
    borderColor = Colors.red;
    borderWidth = 1;
    color = null;
    colorBlendMode = BlendMode.srcIn;
    cache = true;
    enableLoadState = true;
    useLoadStateChanged = true;
    mode = ExtendedImageMode.none;
    clearMemoryCacheIfFailed = true;
    enableSlideOutPage = false;
    handleLoadingProgress = false;
    isAntiAlias = false;
    scale = 1;
    retries = 3;
    gaplessPlayback = false;
    matchTextDirection = false;
    excludeFromSemantics = false;
    useSemanticLabel = false;
    clearMemoryCacheWhenDispose = false;
    useLayoutInsets = false;
    layoutInset = 16;
    lastEvent = '—';
    setState(() {});
  }
}
