//
//  NInputAccessoryViewOneOne.dart
//  projects
//
//  Created by shang on 2026/4/29 16:51.
//  Copyright © 2026/4/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/elevated_btn.dart';
import 'package:flutter_templet_project/basicWidget/input_accessory_view/asset_picker_manager/asset_picker_manager.dart';
import 'package:flutter_templet_project/basicWidget/input_accessory_view/chat_input_bar.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/n_screen_manager.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:provider/provider.dart';

/// 键盘辅助视图会话状态，避免 Overlay 重建时丢失已选图片
class InputAccessoryViewSession {
  FocusNode? focusNode;
  TextEditingController? controller;
  TextInputType? keyboardType;
  String? hintText;
  List<TextInputFormatter>? inputFormatters;
  int? maxLines;
  int? maxLength;
  VoidCallback? onPhoto;
  VoidCallback? onEmoji;
  VoidCallback? onConfirm;
  List<AssetUploadModel> selectedModels = <AssetUploadModel>[];
  String inputText = '';
  bool visible = true;
  bool isShowing = false;
  bool isPickingAssets = false;

  /// selectedModels 对应的url数组
  List<String> get selectedUrls =>
      selectedModels.map((e) => e.url ?? '').where((e) => e.startsWith("http") == true).whereType<String>().toList();

  void update({
    required FocusNode focusNode,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? maxLength,
    VoidCallback? onPhoto,
    VoidCallback? onEmoji,
    VoidCallback? onConfirm,
    List<AssetUploadModel>? selectedModels,
    bool? visible,
  }) {
    this.focusNode = focusNode;
    this.controller = controller;
    this.keyboardType = keyboardType;
    this.hintText = hintText;
    this.inputFormatters = inputFormatters;
    this.maxLines = maxLines;
    this.maxLength = maxLength;
    this.onPhoto = onPhoto;
    this.onEmoji = onEmoji;
    this.onConfirm = onConfirm;
    if (selectedModels != null) {
      this.selectedModels = List<AssetUploadModel>.from(selectedModels);
    }
    if (visible != null) {
      this.visible = visible;
    }
  }
}

final InputAccessoryViewSession accessorySession = InputAccessoryViewSession();

/// 键盘辅助视图
class NInputAccessoryViewOne extends StatefulWidget {
  const NInputAccessoryViewOne({
    super.key,
    this.focusNode,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines = 3,
    this.maxLength,
    this.inputFormatters,
    this.textFieldBuilder,
    required this.onConfirm,
    this.onPhoto,
    this.onEmoji,
    this.selectedModels = const [],
  });

  final FocusNode? focusNode;

  final TextEditingController controller;

  final TextInputType? keyboardType;

  final String? hintText;

  final int? maxLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final TextField Function(TextField v)? textFieldBuilder;

  final VoidCallback onConfirm;

  final VoidCallback? onPhoto;

  final VoidCallback? onEmoji;

  final List<AssetUploadModel> selectedModels;

  static void _onKeyboardMetricsChanged() {
    if (NOverlayDialog.isShowing) {
      NOverlayDialog.build();
    }
  }

  static Widget _buildOverlayEntry(BuildContext ctx) {
    final bottom = NScreenManager.mediaQueryData.viewInsets.bottom;

    onHideKeyBorad() {
      accessorySession.inputText = accessorySession.controller?.text ?? '';
      accessorySession.focusNode?.unfocus();
      dismiss();
    }

    final child = Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        width: MediaQuery.sizeOf(ctx).width,
        child: Offstage(
          offstage: !accessorySession.visible,
          child: TapRegion(
            onTapOutside: (event) => onHideKeyBorad(),
            child: NInputAccessoryViewOne(
              key: const ValueKey<String>('n_input_accessory_view_one'),
              focusNode: accessorySession.focusNode,
              controller: accessorySession.controller!,
              keyboardType: accessorySession.keyboardType,
              hintText: accessorySession.hintText,
              maxLines: accessorySession.maxLines,
              maxLength: accessorySession.maxLength,
              inputFormatters: accessorySession.inputFormatters,
              onConfirm: () {
                accessorySession.onConfirm?.call();
                dismiss();
              },
              onPhoto: accessorySession.onPhoto,
              onEmoji: accessorySession.onEmoji,
              selectedModels: accessorySession.selectedModels,
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        if (accessorySession.visible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onHideKeyBorad,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
        child,
      ],
    );
  }

  /// 刷新或重新展示 Overlay（选图路由变化可能导致 Overlay 被销毁）
  static void refreshOverlay({BuildContext? context}) {
    if (accessorySession.focusNode == null || accessorySession.controller == null) {
      return;
    }
    if (NOverlayDialog.isShowing) {
      NOverlayDialog.build();
      return;
    }
    NScreenManager.addListener(_onKeyboardMetricsChanged);
    final contextNew = context ?? ToolUtil.navigator.context;
    accessorySession.isShowing = true;
    NOverlayDialog.show(
      contextNew,
      hideBarrier: true,
      barrierDismissible: false,
      from: Alignment.bottomCenter,
      builder: _buildOverlayEntry,
    );
  }

  /// 选图前隐藏辅助视图，选图结束后重新展示
  static Future<void> executePickAssets({int maxCount = 3}) async {
    if (accessorySession.isPickingAssets) {
      return;
    }
    accessorySession.isPickingAssets = true;
    accessorySession.visible = false;
    NScreenManager.removeListener(_onKeyboardMetricsChanged);
    NOverlayDialog.dismiss(immediately: true);
    await WidgetsBinding.instance.endOfFrame;
    try {
      final pickedModels = await AssetPickerManager.pickAssets(
        context: ToolUtil.globalContext,
        currentModels: accessorySession.selectedModels,
        maxCount: maxCount,
      );
      accessorySession.selectedModels = List<AssetUploadModel>.from(pickedModels);
    } finally {
      accessorySession.visible = true;
      refreshOverlay();
      accessorySession.focusNode?.requestFocus();
      accessorySession.isPickingAssets = false;
    }
  }

  /// 选图前隐藏辅助视图，选图结束后重新展示
  static Future<void> hide() async {
    accessorySession.visible = false;
    NScreenManager.removeListener(_onKeyboardMetricsChanged);
    NOverlayDialog.dismiss(immediately: true);
    await WidgetsBinding.instance.endOfFrame;
  }

  /// 选图前隐藏辅助视图，选图结束后重新展示
  static Future<void> reShow() async {
    accessorySession.visible = true;
    refreshOverlay();
    accessorySession.focusNode?.requestFocus();
    accessorySession.isPickingAssets = false;
  }

  static void show({
    BuildContext? context,
    required FocusNode focusNode,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? hintText = "请输入",
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? maxLength,
    VoidCallback? onPhoto,
    VoidCallback? onEmoji,
    VoidCallback? onConfirm,
    List<AssetUploadModel>? selectedModels,
    bool visible = true,
  }) {
    if (!NOverlayDialog.isShowing) {
      accessorySession.isShowing = false;
    }
    accessorySession.update(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      hintText: hintText,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      onPhoto: onPhoto,
      onEmoji: onEmoji,
      onConfirm: onConfirm,
      selectedModels: selectedModels,
      visible: visible,
    );
    if (controller.text != accessorySession.inputText) {
      controller.text = accessorySession.inputText;
    }
    refreshOverlay(context: context);
  }

  static void dismiss({bool force = false}) {
    if (accessorySession.isPickingAssets && !force) {
      return;
    }
    accessorySession.isShowing = false;
    accessorySession.visible = true;
    NScreenManager.removeListener(_onKeyboardMetricsChanged);
    NOverlayDialog.dismiss(immediately: true);
  }

  /// 清除输入内容和已选图片
  static void clearContent() {
    accessorySession.inputText = '';
    accessorySession.selectedModels = <AssetUploadModel>[];
    accessorySession.controller?.clear();
    if (NOverlayDialog.isShowing) {
      NOverlayDialog.build();
    }
  }

  @override
  State<NInputAccessoryViewOne> createState() => _NInputAccessoryViewOneState();
}

class _NInputAccessoryViewOneState extends State<NInputAccessoryViewOne> {
  late FocusNode focusNode = widget.focusNode ?? FocusNode();
  var inputType = InputType.text;
  final uploadController = AssetUploadBoxController();
  var selectedModels = <AssetUploadModel>[];
  List<String> urls = <String>[];

  @override
  void initState() {
    super.initState();
    syncSelectedModels(widget.selectedModels);
    focusNode.addListener(handleFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(handleFocusChange);
    super.dispose();
  }

  void handleFocusChange() {
    if (focusNode.hasFocus && inputType == InputType.emoji) {
      inputType = InputType.text;
      setState(() {});
    }
  }

  void syncSelectedModels(List<AssetUploadModel> models) {
    selectedModels = List<AssetUploadModel>.from(models);
    urls = selectedModels
        .where((AssetUploadModel model) => model.url?.startsWith('http') == true)
        .map((AssetUploadModel model) => model.url ?? '')
        .toList();
  }

  @override
  void didUpdateWidget(covariant NInputAccessoryViewOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    final entityIds = widget.selectedModels.map((model) => model.entity?.id).join(',');
    final oldEntityIds = oldWidget.selectedModels.map((model) => model.entity?.id).join(',');
    final itemUrls = widget.selectedModels.map((model) => model.url ?? '').join(',');
    final oldUrls = oldWidget.selectedModels.map((model) => model.url ?? '').join(',');
    if (entityIds != oldEntityIds || itemUrls != oldUrls) {
      syncSelectedModels(widget.selectedModels);
      setState(() {});
    }
  }

  void updateSessionInputText(String v) {
    accessorySession.inputText = v;
  }

  void updateSessionSelectedModels(List<AssetUploadModel> models) {
    syncSelectedModels(models);
    accessorySession.selectedModels = List<AssetUploadModel>.from(models);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    final color242434OrF6F6F6 = themeProvider.color242434OrF6F6F6;

    final textField = TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      minLines: 1,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6).copyWith(bottom: 8),
        hintText: widget.hintText,
        fillColor: color242434OrF6F6F6,
        filled: true,
      ),
    );
    final Widget textFieldNew = widget.textFieldBuilder?.call(textField) ?? textField;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        color: themeProvider.color242434OrWhite,
        // border: Border.all(color: Colors.blue),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color242434OrF6F6F6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFieldNew,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 8),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.blue),
                  // ),
                  child: AssetUploadBox(
                    key: ValueKey<String>(
                      selectedModels.map((model) => model.entity?.id ?? model.url ?? '').join(','),
                    ),
                    controller: uploadController,
                    maxCount: 3,
                    rowCount: 5,
                    radius: 4,
                    items: selectedModels,
                    canTakePhoto: true,
                    onPickRequest: (int maxCount) => NInputAccessoryViewOne.executePickAssets(maxCount: maxCount),
                    onChanged: (List<AssetUploadModel> items) {
                      updateSessionSelectedModels(items);
                    },
                    onTap: (urls, index) async {
                      await NInputAccessoryViewOne.hide();
                      await AssetUploadBox.jumpImagePreview(urls: urls, index: index);
                      NInputAccessoryViewOne.reShow();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          buildMenuBar(themeProvider: themeProvider),
          SizedBox(
            height: inputType == InputType.emoji ? 280 : 0,
            child: inputType == InputType.emoji
                ? EmojiInputView(inputType: inputType, textEditingController: widget.controller)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget buildMenuBar({required ThemeProvider themeProvider}) {
    final iconColor = themeProvider.isDark ? Colors.white : null;
    final emojiPath = inputType == InputType.emoji ? Assets.inputBarIcTextKeyboard : Assets.inputBarIcEmoji;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (widget.onPhoto != null)
              GestureDetector(
                onTap: () async {
                  await NInputAccessoryViewOne.executePickAssets();
                  widget.onPhoto?.call();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Image(
                    image: const AssetImage(Assets.inputBarIcPhoto),
                    width: 24,
                    height: 24,
                    color: iconColor,
                  ),
                ),
              ),
            if (widget.onEmoji != null)
              GestureDetector(
                onTap: () {
                  //只关闭键盘
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  setState(() {
                    inputType = inputType == InputType.emoji ? InputType.text : InputType.emoji;
                    if (inputType == InputType.emoji) {
                      focusNode.unfocus();
                    } else {
                      focusNode.requestFocus();
                    }
                    widget.onEmoji?.call();
                  });
                },
                child: Image(
                  image: AssetImage(emojiPath),
                  width: 24,
                  height: 24,
                  color: iconColor,
                ),
              ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, value, child) {
            final disable = value.text.isEmpty;
            updateSessionInputText(value.text);
            return ElevatedBtn(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              radius: 4,
              onPressed: disable
                  ? null
                  : () {
                      // DLog.d("发送 ${value.text}");
                      // DLog.d(["发送 ${value.text}", selectedModels.map((e) => e.toJson())]);
                      widget.onConfirm();
                      widget.focusNode?.unfocus();
                    },
              title: "发送",
            );
          },
        ),
      ],
    );
  }
}

/// NInputAccessoryViewOne 输入框混入
mixin NInputAccessoryViewOneMixin<T extends StatefulWidget> on State<T> {
  final _focusNode = FocusNode();
  final _textEditingController = TextEditingController();
  // 展示礼物辅助视图
  Future<void> showInputView({String? hintText, required ValueChanged<InputAccessoryViewSession> onSend}) async {
    NInputAccessoryViewOne.show(
      context: context,
      focusNode: _focusNode,
      controller: _textEditingController,
      hintText: hintText ?? "请输入",
      maxLength: 1000,
      onEmoji: () {
        DLog.d("选择表情");
      },
      onPhoto: () {
        DLog.d("选择图片");
      },
      onConfirm: () {
        onSend(accessorySession);
      },
    );

    await Future.delayed(const Duration(milliseconds: 150));
    _focusNode.requestFocus();
    return;
  }
}
