import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuBarDemo extends StatefulWidget {
  const MenuBarDemo({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<MenuBarDemo> createState() => _MenuBarDemoState();
}

class _MenuBarDemoState extends State<MenuBarDemo> {
  static const _message = '"Talk less. Smile more." - A. Burr';

  static const _colors = <(String, Color, LogicalKeyboardKey)>[
    ('Red Background', Colors.red, LogicalKeyboardKey.keyR),
    ('Green Background', Colors.green, LogicalKeyboardKey.keyG),
    ('Blue Background', Colors.blue, LogicalKeyboardKey.keyB),
  ];

  ShortcutRegistryEntry? _shortcutsEntry;
  String? _lastSelection;
  Color backgroundColor = Colors.red;
  bool showingMessage = false;

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    registerShortcuts();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          MenuBar(children: buildMenus()),
          Expanded(
            child: ColoredBox(
              color: backgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        showingMessage ? _message : '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(_lastSelection == null ? '' : 'Last Selected: $_lastSelection'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildMenus() {
    return [
      SubmenuButton(
        menuChildren: [
          MenuItemButton(
            onPressed: onAbout,
            child: const Text('About'),
          ),
          MenuItemButton(
            onPressed: onToggleMessage,
            shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true),
            child: Text(showingMessage ? 'Hide Message' : 'Show Message'),
          ),
          MenuItemButton(
            onPressed: showingMessage ? onResetMessage : null,
            shortcut: const SingleActivator(LogicalKeyboardKey.escape),
            child: const Text('Reset Message'),
          ),
          SubmenuButton(
            menuChildren: [
              for (final e in _colors) buildColorItem(e),
            ],
            child: const Text('Background Color'),
          ),
        ],
        child: const Text('Menu Demo'),
      ),
    ];
  }

  Widget buildColorItem((String, Color, LogicalKeyboardKey) e) {
    return MenuItemButton(
      onPressed: () => onBackgroundColor(e.$1, e.$2),
      shortcut: SingleActivator(e.$3, control: true),
      child: Text(e.$1),
    );
  }

  void registerShortcuts() {
    _shortcutsEntry?.dispose();
    _shortcutsEntry = ShortcutRegistry.of(context).addAll({
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): VoidCallbackIntent(onToggleMessage),
      for (final e in _colors)
        SingleActivator(e.$3, control: true): VoidCallbackIntent(() => onBackgroundColor(e.$1, e.$2)),
      if (showingMessage)
        const SingleActivator(LogicalKeyboardKey.escape): VoidCallbackIntent(onResetMessage),
    });
  }

  void onAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'MenuBar Sample',
      applicationVersion: '1.0.0',
    );
    _lastSelection = 'About';
    setState(() {});
  }

  void onToggleMessage() {
    _lastSelection = showingMessage ? 'Hide Message' : 'Show Message';
    showingMessage = !showingMessage;
    setState(() {});
  }

  void onResetMessage() {
    _lastSelection = 'Reset Message';
    showingMessage = false;
    setState(() {});
  }

  void onBackgroundColor(String label, Color value) {
    _lastSelection = label;
    backgroundColor = value;
    setState(() {});
  }
}
