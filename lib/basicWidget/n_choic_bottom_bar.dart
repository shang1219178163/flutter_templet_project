import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 选择列表,底部菜单
class NChoicBottomBar extends StatelessWidget {
  const NChoicBottomBar({
    super.key,
    required this.checkIcon,
    required this.checkDesc,
    required this.onCheck,
    required this.onAdd,
    required this.onDelete,
  });

  final IconData? checkIcon;
  final String checkDesc;
  final VoidCallback onCheck;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: onCheck,
                    child: Row(
                      children: [
                        Icon(
                          checkIcon,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("全选 ($checkDesc)"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onAdd,
                          child: Container(
                            height: double.maxFinite,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: context.primaryColor,
                            ),
                            child: NText(
                              "新增",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: onDelete,
                          child: Container(
                            height: double.maxFinite,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                            ),
                            child: NText(
                              "删除",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
