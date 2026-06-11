import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

/// 链接识别
class LinkifyPage extends StatefulWidget {
  const LinkifyPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<LinkifyPage> createState() => _LinkifyPageState();
}

class _LinkifyPageState extends State<LinkifyPage> {
  final scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant LinkifyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              buildLinkify(selectable: true),
              buildLinkify(selectable: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLinkify({required bool selectable}) {
    final text = [
      "还在问朋友比赛谁赢了?下载[春秋直播]，从此你才是消息最灵通的那位!",
      "专属邀请链接:https://invite.kbisai.com?inviteCode=4M3FQA",
      "专属邀请码:4M3FQA"
    ].join("\n");

    final style = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );

    final linkStyle = style.copyWith(
      decorationColor: style.color,
      decoration: TextDecoration.underline,
    );

    if (selectable) {
      final child = SelectableLinkify(
        text: text,
        style: style,
        linkStyle: linkStyle,
        // TextSpan(children: spans, style: style),
        // textAlign: textAlign,
        // textDirection: textDirection,
        // maxLines: maxLines,
        // textScaler: TextScaler.noScaling,
        options: const LinkifyOptions(humanize: false),
        onOpen: (link) async {
          await launchUrl(Uri.parse(link.url));
        },
        onTap: () {
          NFullscreenTextLinkify.show(context, message: text);
        },
        contextMenuBuilder: NFullscreenTextLinkify.editableTextContextMenu,
      );
      return child;
    }

    final child = Linkify(
      text: text,
      style: style,
      linkStyle: linkStyle,
      // textAlign: textAlign,
      // textDirection: textDirection,
      // locale: locale,
      // softWrap: softWrap,
      // overflow: overflow,
      // maxLines: maxLines,
      // text: TextSpan(children: spans, style: style),
      // textScaler: TextScaler.noScaling,
      options: const LinkifyOptions(humanize: false),
      onOpen: (link) async {
        await launchUrl(Uri.parse(link.url));
      },
    );
    return child;
  }
}

/// 双击全屏消息显示
class NFullscreenTextLinkify extends StatefulWidget {
  const NFullscreenTextLinkify({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  static void show(
    BuildContext context, {
    required String message,
  }) {
    onDismiss() {
      Navigator.of(context).pop();
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'NFullscreenMessage',
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return NFullscreenTextLinkify(message: message, onDismiss: onDismiss);
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

  /// 文字消息上下文菜单
  static Widget editableTextContextMenu(BuildContext context, EditableTextState state) {
    final anchors = state.contextMenuAnchors;
    final style = const TextStyle();
    final children = [
      TextButton(
        onPressed: () {
          state.copySelection(SelectionChangedCause.toolbar);
        },
        child: Text('复制', style: style),
      ),
      TextButton(
        onPressed: () {
          state.selectAll(SelectionChangedCause.toolbar);
        },
        child: Text('全选', style: style),
      ),
      TextButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          state.hideToolbar();
        },
        child: Text('取消', style: style),
      ),
    ];
    return CupertinoTextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor == null ? anchors.primaryAnchor : anchors.secondaryAnchor!,
      children: children,
    );
    // return AdaptiveTextSelectionToolbar(
    //   anchors: editableTextState.contextMenuAnchors,
    //   children: children
    // );
  }

  /// 文字消息上下文菜单
  static Widget selectableRegionContextMenu(BuildContext context, SelectableRegionState state) {
    final anchors = state.contextMenuAnchors;
    return CupertinoTextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
      children: [
        CupertinoTextSelectionToolbarButton.text(
          onPressed: () {
            state.copySelection(SelectionChangedCause.toolbar);
          },
          text: '复制',
        ),
        CupertinoTextSelectionToolbarButton.text(
          onPressed: () {
            state.selectAll(SelectionChangedCause.toolbar);
          },
          text: '全选',
        ),
        CupertinoTextSelectionToolbarButton.text(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            state.hideToolbar();
          },
          text: '取消',
        ),
      ],
    );
  }

  @override
  State<NFullscreenTextLinkify> createState() => _NFullscreenTextLinkifyState();
}

class _NFullscreenTextLinkifyState extends State<NFullscreenTextLinkify> {
  String get message => widget.message;

  final focusNode = FocusNode();
  final regionKey = GlobalKey<SelectableRegionState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      focusNode.requestFocus();
      await Future.delayed(const Duration(milliseconds: 100));
      _selectAll(); // 双保险（解决布局延迟）
    });
  }

  void _selectAll() {
    regionKey.currentState?.selectAll(SelectionChangedCause.toolbar);
  }

  @override
  void didUpdateWidget(covariant NFullscreenTextLinkify oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    // final bgColor = theme.colorScheme.primary;
    // final textColor = theme.colorScheme.onPrimary;

    final bgColor = isDark ? Color(0xFF242434) : Colors.white;
    final textColor = !isDark ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        child: GestureDetector(
          onTap: widget.onDismiss,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              // border: Border.all(color: Colors.blue),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: widget.onDismiss,
                    child: buildText(value: message),
                  ),
                  // SelectableText(
                  //   model.message.textContent,
                  //   style: TextStyle(
                  //     color: textColor,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText({required String value}) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final isLeft = true;

    final style = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );

    return RepaintBoundary(
      child: SelectableRegion(
        key: regionKey,
        focusNode: focusNode,
        selectionControls: CupertinoTextSelectionControls(),
        // selectionControls: materialTextSelectionControls,
        // contextMenuBuilder: NFullscreenMessage.selectableRegionContextMenu,
        child: GestureDetector(
          onTap: widget.onDismiss,
          child: Linkify(
            text: value,
            style: style,
            linkStyle: style.copyWith(
              decorationColor: style.color,
              decoration: TextDecoration.underline,
            ),
            // TextSpan(children: spans, style: style),
            // textAlign: textAlign,
            // textDirection: textDirection,
            // maxLines: maxLines,
            // textScaler: TextScaler.noScaling,
            onOpen: (link) async {
              await launchUrl(Uri.parse(link.url));
            },
          ),
        ),
      ),
    );

    // return RepaintBoundary(
    //   child: SelectableLinkify(
    //     text: value,
    //     style: tmpStyle,
    //     linkStyle: tmpStyle.copyWith(
    //       decorationColor: tmpStyle.color,
    //       decoration: TextDecoration.underline,
    //     ),
    //     // TextSpan(children: spans, style: style),
    //     // textAlign: textAlign,
    //     // textDirection: textDirection,
    //     // maxLines: maxLines,
    //     // textScaler: TextScaler.noScaling,
    //     onOpen: (link) async {
    //       await launchUrl(Uri.parse(link.url));
    //     },
    //     contextMenuBuilder: NFullscreenMessage.editableTextContextMenu,
    //     onTap: () {
    //       Navigator.of(context).pop();
    //     },
    //   ),
    // );
  }
}
