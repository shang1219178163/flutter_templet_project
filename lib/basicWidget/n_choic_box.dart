

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cancell_and_confirm_bar.dart';

/// 选择 box
class NChoicBox extends StatefulWidget {

  NChoicBox({
    Key? key,
    this.title,
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

  Widget? title;
  Widget? content;
  Widget? header;
  Widget? footer;
  Color divderColor = const Color(0xffF3F3F3);
  EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 38);
  Radius radius = const Radius.circular(8);
  Alignment alignment = Alignment.center;
  VoidCallback? onCancell;
  VoidCallback? onConfirm;
  double contentMaxHeight = 500;
  double contentMinHeight = 150;
  double buttonBarHeight = 48;
  EdgeInsets contentPadding = const EdgeInsets.all(20);
  StatefulWidgetBuilder? contentChildBuilder;

  @override
  _NChoicBoxState createState() => _NChoicBoxState();
}

class _NChoicBoxState extends State<NChoicBox> {

  @override
  Widget build(BuildContext context) {
    return buildBody(
      title: widget.title,
      content: widget.content,
      header: widget.header,
      footer: widget.footer,
      divderColor: widget.divderColor,
      margin: widget.margin,
      radius: widget.radius,
      alignment: widget.alignment,
      onCancell: widget.onCancell,
      onConfirm: widget.onConfirm,
      contentMaxHeight: widget.contentMaxHeight,
      contentMinHeight: widget.contentMinHeight,
      buttonBarHeight: widget.buttonBarHeight,
      contentPadding: widget.contentPadding,
      contentChildBuilder: widget.contentChildBuilder,
    );
  }

  buildBody(
      {
        Widget? title,
        Widget? content,
        Widget? header,
        Widget? footer,
        Color divderColor = const Color(0xffF3F3F3),
        EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 38),
        Radius radius = const Radius.circular(8),
        Alignment alignment = Alignment.center,
        VoidCallback? onCancell,
        VoidCallback? onConfirm,
        double contentMaxHeight = 500,
        double contentMinHeight = 150,
        double buttonBarHeight = 48,
        EdgeInsets contentPadding = const EdgeInsets.all(20),
        StatefulWidgetBuilder? contentChildBuilder,
      }
  ) {

    final defaultHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: title ?? Text("标题",
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
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.clear,
                size: 20,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );

    final defaultContent = StatefulBuilder(
        builder: (context, setState) {

          return Scrollbar(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: contentMaxHeight - buttonBarHeight,
                minHeight: contentMinHeight,
              ),
              child: SingleChildScrollView(
                  child: Padding(
                    padding: contentPadding,
                    child: contentChildBuilder?.call(context, setState),
                  )
              ),
            ),
          );
        }
    );

    final defaultFooter = NCancellAndConfirmBar(
      height: buttonBarHeight,
      confirmBgColor: Theme.of(context).primaryColor,
      bottomLeftRadius: radius,
      bottomRightRadius: radius,
      onCancell: onCancell ?? (){
        Navigator.of(context).pop();
      },
      onConfirm: onConfirm ?? () {
        Navigator.of(context).pop();
      },
    );
    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(radius),
        ),
        // constraints: BoxConstraints(
        //   maxHeight: contentMaxHeight,
        //   minHeight: contentMinHeight,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            header ?? defaultHeader,
            Divider(height: 1, color: divderColor,),
            content ?? defaultContent,
            footer ?? defaultFooter,
          ],
        ),
      ),
    );
  }


  toShowGeneralDialog({
    required Widget child,
    Alignment alignment = Alignment.center,
    Duration transitionDuration = const Duration(milliseconds: 200),

  }) {

    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'barrierLabel',
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {

        return Align(
          alignment: alignment,
          child: child,
        );
      }
    );
  }

}