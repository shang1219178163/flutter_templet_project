import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 自定义顶部appBar
class NAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NAppBar({
    super.key,
    this.titleStr = '',
    this.title,
    this.centerTitle = true,
    this.actions,
    this.backgroundColor,
    this.titleSpacing,
    this.bottom,
    this.leading,
    this.leadingWidth,
    this.flexibleSpace,
    this.leadingVisible = true,
    this.systemOverlayStyle = SystemUiOverlayStyle.dark,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.toolbarHeight = kToolbarHeight,
    this.onBack,
    this.copyBuilder,
  });

  final String titleStr;
  final Widget? title;
  final bool centerTitle; //标题是否居中，默认居中
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final double? titleSpacing;
  final Widget? leading;
  final bool leadingVisible;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double toolbarHeight;
  final SystemUiOverlayStyle systemOverlayStyle; // ios系统风格
  final bool automaticallyImplyLeading; //配合leading 使用，如果左侧不需要图标 ，设置false
  /// 默认返回按钮事件
  final VoidCallback? onBack;

  /// 二次赋值
  final AppBar Function(AppBar appBar)? copyBuilder;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final iconColor = AppBarTheme.of(context).iconTheme?.color;
    // 默认标题
    final defaultTitle = Text(
      titleStr.toShort(),
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: iconColor),
      maxLines: 1,
    );

    // 默认返回按钮
    final defaultBackButton = Visibility(
      visible: leadingVisible,
      child: IconButton(
        onPressed: () {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.arrow_back_ios_new_outlined, color: iconColor, size: 18),
      ),
    );

    final child = AppBar(
      title: title ?? defaultTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      scrolledUnderElevation: elevation,
      flexibleSpace: flexibleSpace,
      leading: leading ?? defaultBackButton,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      systemOverlayStyle: systemOverlayStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      actions: actions,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
    );
    return copyBuilder?.call(child) ?? child;
  }
}
