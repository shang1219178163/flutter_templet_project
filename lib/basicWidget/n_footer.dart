import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///表尾
@Deprecated("已弃用,请使用 NFooterButtonBar")
class NFooter extends StatelessWidget {
  const NFooter({
    super.key,
    required this.title,
    required this.onPressed,
    this.style,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    this.btnHeight = 45,
    this.radius = 22.5,
    this.color,
    this.btnColor,
    this.btnElevation = 2,
    this.header,
    this.child,
    this.footer,
  });

  final String title;
  final TextStyle? style;
  final EdgeInsets padding;
  final double btnHeight;
  final double radius;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? btnColor;
  final double? btnElevation;
  final Widget? header;
  final Widget? footer;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final effectiveBtnColor = btnColor ?? Theme.of(context).primaryColor;
    return Container(
      color: color,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) header!,
          MaterialButton(
            height: btnHeight,
            color: effectiveBtnColor,
            disabledColor: effectiveBtnColor.withValues(alpha: 0.5),
            elevation: btnElevation,
            onPressed: onPressed ??
                () {
                  debugPrint(title);
                },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: child ??
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DoubleProperty('btnHeight', btnHeight));
    properties.add(DoubleProperty('radius', radius));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('btnColor', btnColor));
    properties.add(DoubleProperty('btnElevation', btnElevation));
  }
}
