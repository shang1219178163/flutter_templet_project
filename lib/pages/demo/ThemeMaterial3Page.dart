import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';

class ThemeMaterial3Page extends StatefulWidget {
  const ThemeMaterial3Page({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ThemeMaterial3Page> createState() => _ThemeMaterial3PageState();
}

class _ThemeMaterial3PageState extends State<ThemeMaterial3Page> {
  final scrollController = ScrollController();

  var useMaterial3 = true;

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
        child: Column(
          children: [
            NPair(
              icon: Text("useMaterial3"),
              child: NResizeSwitch(
                value: useMaterial3,
                onChanged: (v) {
                  useMaterial3 = !useMaterial3;
                  setState(() {});
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: buildButton(theme: lightTheme())),
                  VerticalDivider(width: 16),
                  Expanded(child: buildButton(theme: darkTheme())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({required ThemeData theme}) {
    return Theme(
      data: theme,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("useMaterial3: ${useMaterial3}"),
          FilledButton(
            onPressed: () => debugPrint('FilledButton pressed'),
            child: const Text('FilledButton'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => debugPrint('OutlinedButton pressed'),
            child: const Text('OutlinedButton'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => debugPrint('TextButton pressed'),
            child: const Text('TextButton'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => debugPrint('ElevatedButton pressed'),
            child: const Text('ElevatedButton'),
          ),
          const SizedBox(height: 12),
          IconButton(
            onPressed: () => debugPrint('IconButton pressed'),
            icon: const Icon(Icons.favorite),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => debugPrint('FilledButton.tonal pressed'),
            child: const Text(
              'Tonal Button (M3)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send),
            label: const Text('FilledButton.icon'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: null, // disabled
            child: const Text('Disabled Button'),
          ),
        ].map((e) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              // border: Border.all(color: Colors.blue),
            ),
            child: e,
          );
        }).toList(),
      ),
    );
  }

  ThemeData darkTheme() {
    const seedColor = Color(0xffE91025);

    /// 背景色设置
    backgroundBuilder(context, states, child) {
      final colors = states.contains(WidgetState.disabled)
          ? [Colors.grey.shade300, Colors.grey.shade300]
          : [Colors.red, Colors.purple];

      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: colors,
          ),
        ),
        child: child,
      );
    }

    return ThemeData(
      useMaterial3: useMaterial3,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      // 🌕 FilledButton（主按钮）
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          minimumSize: WidgetStateProperty.all(const Size(30, 30)),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade300;
            }
            // if (states.contains(WidgetState.pressed)) return seedColor.shade700;

            return seedColor;
          }),
          backgroundBuilder: backgroundBuilder,
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),

      // 🌕 ElevatedButton（有阴影按钮）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          minimumSize: WidgetStateProperty.all(const Size(30, 30)),
          backgroundColor: WidgetStateProperty.all(seedColor),
          backgroundBuilder: backgroundBuilder,
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shadowColor: WidgetStateProperty.all(seedColor.withOpacity(0.1)),
          elevation: WidgetStateProperty.all(2),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),

      // 🌕 OutlinedButton（描边按钮）
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          minimumSize: WidgetStateProperty.all(const Size(30, 30)),
          side: WidgetStateProperty.all(const BorderSide(color: seedColor, width: 1)),
          foregroundColor: WidgetStateProperty.all(seedColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          overlayColor: WidgetStateProperty.all(seedColor.withOpacity(0.05)),
        ),
      ),

      // 🌕 TextButton（纯文字按钮）
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          foregroundColor: WidgetStateProperty.all(seedColor),
          overlayColor: WidgetStateProperty.all(seedColor.withOpacity(0.08)),
          textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ),
      ),

      // 🌕 IconButton（图标按钮）
      iconTheme: const IconThemeData(color: seedColor), // 🔑 关键
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          iconSize: WidgetStateProperty.all(24),
          foregroundColor: WidgetStateProperty.all(seedColor),
          overlayColor: WidgetStateProperty.all(seedColor.withOpacity(0.1)),
        ),
      ),
    );
  }

  ThemeData lightTheme() {
    const seedColor = Colors.blue;

    /// 背景色设置
    backgroundBuilder(context, states, child) {
      final colors =
          states.contains(WidgetState.disabled) ? [Colors.grey.shade300, Colors.grey.shade300] : [seedColor, seedColor];

      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: colors,
          ),
        ),
        child: child,
      );
    }

    return ThemeData(
      useMaterial3: useMaterial3,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      // 🌕 FilledButton（主按钮）
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          minimumSize: WidgetStateProperty.all(const Size(30, 30)),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return Colors.grey.shade300;
            // if (states.contains(WidgetState.pressed)) return seedColor.shade700;
            return seedColor;
          }),
          backgroundBuilder: backgroundBuilder,
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),

      // 🌕 ElevatedButton（有阴影按钮）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          minimumSize: WidgetStateProperty.all(const Size(30, 30)),
          backgroundColor: WidgetStateProperty.all(seedColor),
          backgroundBuilder: backgroundBuilder,
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shadowColor: WidgetStateProperty.all(seedColor.withOpacity(0.1)),
          elevation: WidgetStateProperty.all(2),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),

      // 🌕 OutlinedButton（描边按钮）
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          minimumSize: WidgetStateProperty.all(const Size(30, 30)),
          side: WidgetStateProperty.all(const BorderSide(color: seedColor, width: 1)),
          foregroundColor: WidgetStateProperty.all(seedColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          overlayColor: WidgetStateProperty.all(seedColor.withOpacity(0.05)),
        ),
      ),

      // 🌕 TextButton（纯文字按钮）
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          foregroundColor: WidgetStateProperty.all(seedColor),
          overlayColor: WidgetStateProperty.all(seedColor.withOpacity(0.08)),
          textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ),
      ),

      // 🌕 IconButton（图标按钮）
      iconTheme: const IconThemeData(color: seedColor), // 🔑 关键
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
          iconSize: WidgetStateProperty.all(24),
          // foregroundColor: WidgetStateProperty.all(seedColor),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // 禁用状态
            }
            return seedColor; // 默认状态
          }),
          overlayColor: WidgetStateProperty.all(seedColor.withOpacity(0.1)),
        ),
      ),
    );
  }
}
