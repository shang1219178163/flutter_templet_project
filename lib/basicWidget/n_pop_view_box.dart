import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';

/// PopView 内容
class NPopViewBox extends StatefulWidget {
  NPopViewBox({
    Key? key,
    this.title,
    this.scrollController,
    this.content,
    this.header,
    this.footer,
    this.divderColor = const Color(0xffF3F3F3),
    this.margin = const EdgeInsets.symmetric(horizontal: 38),
    this.radius = const Radius.circular(8),
    this.alignment = Alignment.center,
    this.onCancell,
    this.onConfirm,
    this.contentMaxHeight = 500,
    this.contentMinHeight = 150,
    this.buttonBarHeight = 48,
    this.contentPadding = const EdgeInsets.all(20),
    this.contentChildBuilder,
  }) : super(key: key);

  final Widget? title;
  final Widget? content;
  final Widget? header;
  final Widget? footer;
  final Color divderColor;
  final EdgeInsets margin;
  final Radius radius;
  final Alignment alignment;
  final VoidCallback? onCancell;
  final VoidCallback? onConfirm;
  final double contentMaxHeight;
  final double contentMinHeight;
  final double buttonBarHeight;
  final EdgeInsets contentPadding;
  final StatefulWidgetBuilder? contentChildBuilder;
  final ScrollController? scrollController;

  @override
  _NPopViewBoxState createState() => _NPopViewBoxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('divderColor', divderColor));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties.add(DiagnosticsProperty<Radius>('radius', radius));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onCancell', onCancell));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onConfirm', onConfirm));
    properties.add(DoubleProperty('contentMaxHeight', contentMaxHeight));
    properties.add(DoubleProperty('contentMinHeight', contentMinHeight));
    properties.add(DoubleProperty('buttonBarHeight', buttonBarHeight));
    properties.add(DiagnosticsProperty<EdgeInsets>('contentPadding', contentPadding));
    properties.add(ObjectFlagProperty<StatefulWidgetBuilder?>.has('contentChildBuilder', contentChildBuilder));
    properties.add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController));
  }
}

class _NPopViewBoxState extends State<NPopViewBox> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final scrollController = widget.scrollController ?? _scrollController;

    final defaultHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 20,
          ),
          child: widget.title ??
              Text(
                "标题",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff333333),
                ),
              ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Material(
            child: IconButton(
              onPressed: widget.onCancell ??
                  () {
                    Navigator.of(context).pop();
                  },
              icon: Icon(
                Icons.clear,
                size: 20,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );

    final defaultContent = StatefulBuilder(builder: (context, setState) {
      return Scrollbar(
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.contentMaxHeight - widget.buttonBarHeight,
            minHeight: widget.contentMinHeight,
          ),
          child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: widget.contentPadding,
                child: widget.contentChildBuilder?.call(context, setState),
              )),
        ),
      );
    });

    final defaultFooter = NCancelAndConfirmBar(
      height: widget.buttonBarHeight,
      confirmBgColor: Theme.of(context).primaryColor,
      bottomRadius: widget.radius,
      onCancel: widget.onCancell ??
          () {
            Navigator.of(context).pop();
          },
      onConfirm: widget.onConfirm ??
          () {
            Navigator.of(context).pop();
          },
    );
    return Align(
      alignment: widget.alignment,
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(widget.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.header ?? defaultHeader,
            Divider(
              height: 1,
              color: widget.divderColor,
            ),
            widget.content ?? defaultContent,
            widget.footer ?? defaultFooter,
          ],
        ),
      ),
    );
  }

  // toShowGeneralDialog({
  //   required Widget child,
  //   Alignment alignment = Alignment.center,
  //   Duration transitionDuration = const Duration(milliseconds: 200),
  //
  // }) {
  //
  //   return showGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierLabel: 'barrierLabel',
  //     transitionDuration: transitionDuration,
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       if (child is Align) {
  //         return child;
  //       }
  //       return Align(
  //         alignment: alignment,
  //         child: child,
  //       );
  //     }
  //   );
  // }
}
