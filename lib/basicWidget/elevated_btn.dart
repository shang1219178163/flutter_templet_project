import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  const ElevatedBtn({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.radius = 12,
    this.gradient,
    this.title = "ElevatedBtn",
    this.child,
    this.onPressed,
  });

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? padding;

  final double radius;

  final Gradient? gradient;

  final String title;

  final Widget? child;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final gradientDefault = isDark
        ? const LinearGradient(colors: [Colors.red, Colors.purple])
        : const LinearGradient(colors: [Colors.red, Colors.red]);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 20),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Ink(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: onPressed == null
            ? null
            : BoxDecoration(
                gradient: gradient ?? gradientDefault,
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              ),
        child: Center(
          child: child ??
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
        ),
      ),
    );
  }
}
