import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 属性元祖
typedef SystemThemeTabRecord<T> = ({String example, String name, T value});

/// 系统主题切换
class NSystemThemeTab extends StatefulWidget {
  const NSystemThemeTab({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  State<NSystemThemeTab> createState() => _NSystemThemeTabState();
}

class _NSystemThemeTabState extends State<NSystemThemeTab> {
  var index = 0;

  List<SystemThemeTabRecord<ThemeMode>> systemModes = [
    (
      example: "assets/images/ic_mode_dark_example.png",
      name: "深色",
      value: ThemeMode.dark,
    ),
    (
      example: "assets/images/ic_mode_light_example.png",
      name: "浅色",
      value: ThemeMode.light,
    ),
    (
      example: "assets/images/ic_mode_follow_example.png",
      name: "跟随系统",
      value: ThemeMode.system,
    ),
  ];

  final numPerRow = 3;

  @override
  void initState() {
    index = systemModes.map((e) => e.value).toList().indexOf(widget.mode);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NSystemThemeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      index = systemModes.map((e) => e.value).toList().indexOf(widget.mode);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 34),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          buildNavigationbar(context: context, title: "皮肤主题"),
          buildTab(
            context: context,
          ),
        ],
      ),
    );
  }

  Widget buildNavigationbar({
    required BuildContext context,
    required String title,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: NavigationToolbar(
        middle: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.w500,
            // color: themeProvider.titleColor,
            // backgroundColor: Colors.white,
            // decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildTab({
    required BuildContext context,
  }) {
    // ThemeProvider themeProvider = context.read<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
      child: LayoutBuilder(builder: (context, constraints) {
        // final itemWidth = (constraints.maxWidth / numPerRow).truncateToDouble();
        final itemWidth = ((constraints.maxWidth - 39 * (numPerRow - 1)) / numPerRow).truncateToDouble();

        return Wrap(
          // alignment: WrapAlignment.start,
          // crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 39,
          children: systemModes.map(
            (e) {
              final i = systemModes.indexOf(e);

              final isSelected = i == index;
              final imagePath =
                  isSelected ? "assets/images/ic_circle_selected.png" : "assets/images/ic_circle_unselected.png";
              final color = isSelected ? null : (isDark ? null : Colors.red);
              return GestureDetector(
                onTap: () {
                  // debugPrint("$this ${[index, e, themeProvider.themeMode].asMap()}}");
                  // if (themeProvider.themeMode == e.value) {
                  //   return;
                  // }
                  index = i;
                  setState(() {});
                  widget.onChanged(e.value);
                  // themeProvider.toggleTheme(e.value);
                },
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(e.example),
                        height: 120,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(e.name),
                      ),
                      Image(
                        image: AssetImage(imagePath),
                        width: 16,
                        height: 16,
                        color: color,
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        );
      }),
    );
  }
}
