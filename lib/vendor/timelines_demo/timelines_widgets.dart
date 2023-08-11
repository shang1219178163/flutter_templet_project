import 'package:flutter/material.dart';

typedef NavigateWidgetBuilder = Widget Function();

mixin NavigateMixin on Widget {
  NavigateWidgetBuilder? get navigationBuilder;

  Future<T?> navigate<T>(BuildContext context) {
    if (navigationBuilder == null) {
      return Future.value();
    } else {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => navigationBuilder!(),
        ),
      );
    }
  }
}

const kNavigationCardRadius = 8.0;

class NavigationCard extends StatelessWidget with NavigateMixin {
  const NavigationCard({
    Key? key,
    this.margin,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(kNavigationCardRadius)),
    this.navigationBuilder,
    required this.child,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Widget child;
  @override
  final NavigateWidgetBuilder? navigationBuilder;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius!)
          : null,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => navigate(context),
        child: child,
      ),
    );
  }
}

class TitleAppBar extends AppBar {
  TitleAppBar({
    super.key, 
    super.title,
  });

  Widget build(BuildContext context) {
    return AppBar(
      title: title,
    );
  }
}
