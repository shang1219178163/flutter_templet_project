import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class PhoneAreaCodeBtn<T> extends StatefulWidget {
  const PhoneAreaCodeBtn({
    super.key,
    required this.onTap,
    required this.valueVN,
    required this.nameCb,
    this.padding = const EdgeInsets.only(left: 4, right: 10, top: 2),
    this.textColor,
    this.hasArrow = true,
    this.dividerHeight = 24,
  });

  final VoidCallback onTap;

  final ValueNotifier<T?> valueVN;
  final String Function(T? e) nameCb;
  final Color? textColor;
  final bool hasArrow;

  final EdgeInsets padding;

  /// 竖线高度
  final double dividerHeight;

  @override
  State<PhoneAreaCodeBtn<T>> createState() => _PhoneAreaCodeBtnState<T>();
}

class _PhoneAreaCodeBtnState<T> extends State<PhoneAreaCodeBtn<T>> {
  @override
  void didUpdateWidget(covariant PhoneAreaCodeBtn<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textColor != widget.textColor ||
        oldWidget.hasArrow != widget.hasArrow ||
        oldWidget.padding != widget.padding ||
        oldWidget.dividerHeight != widget.dividerHeight) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();
    final textColorNew = widget.textColor ?? themeProvider.subtitleColor;

    final hasDivider = widget.dividerHeight > 0;

    var width = 32.0 + widget.padding.left + widget.padding.right;
    if (widget.hasArrow) {
      width += 16;
    }
    if (hasDivider) {
      width += 16;
    }
    // width += 10;

    return GestureDetector(
      // onTap: () {
      //   PickerAreaCodePopup.show(context, onChange: (AreaCodeEntity areaCode) {
      //     provider.updateNationalCode(areaCode.phoneCode);
      //   });
      // },
      onTap: widget.onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width + 18,
          minWidth: width,
        ),
        padding: widget.padding,
        decoration: const BoxDecoration(
          // color: Colors.green,
          // border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.valueVN,
              builder: (context, value, child) {
                final name = widget.nameCb(value);
                return Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColorNew,
                  ),
                );
              },
            ),
            if (widget.hasArrow)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                // child: Icon(Icons.arrow_drop_down, size: 16, color: textColorNew),
                child: Image(
                  image: const AssetImage(Assets.imagesIcArrowDropDownFill),
                  width: 8,
                  height: 8,
                  color: textColorNew,
                ),
              ),
            if (hasDivider)
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Container(
                  height: 24,
                  width: 0.5,
                  color: themeProvider.lineColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
